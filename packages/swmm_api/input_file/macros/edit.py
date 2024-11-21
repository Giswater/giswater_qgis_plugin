import warnings
from typing import Literal

import numpy as np

from ._helpers import get_constituents, SwmmApiInputMacrosWarning
from .collection import nodes_dict, links_dict, subcatchments_per_node_dict
from .combine_dwf import combine_dwf
from .graph import next_links_labels, previous_links, previous_links_labels, links_connected, _previous_links_labels
from .macros import calc_slope, find_link, delete_sections
from .._type_converter import is_equal
from ..inp import SwmmInput
from ..section_labels import *
from ..section_lists import NODE_SECTIONS, LINK_SECTIONS, SUBCATCHMENT_SECTIONS, POLLUTANT_SECTIONS, NODE_SECTIONS_ADD, \
    LINK_SECTIONS_ADD
from ..sections import Tag, DryWeatherFlow, Junction, Coordinate, Conduit, Loss, Vertices, EvaporationSection, Inflow, \
    ReportSection, GroundwaterFlow, Groundwater, LIDUsage, InletUsage, Control, ControlVariable, ControlExpression
from ..sections._identifiers import IDENTIFIERS


def delete_node(inp, node_label, graph=None, alt_node=None):
    """
    Delete node in inp data.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        node_label (str): label of node to delete
        graph (networkx.DiGraph): networkx graph of model
        alt_node (str): node label | optional: move flows to this node

    .. Important::
        works inplace
    """
    for section in NODE_SECTIONS + NODE_SECTIONS_ADD:
        if (section in inp) and (node_label in inp[section]):
            inp[section].pop(node_label)

    remove_obj_from_reporting(inp, kind=ReportSection.KEYS.NODES, label=node_label)
    remove_obj_tag(inp, kind=Tag.TYPES.Node, label=node_label)
    remove_obj_from_control(inp, kind=Control.OBJECTS.NODE, label=node_label)

    connected_subcatchments = []

    # AND delete connected links
    if graph is not None:
        if node_label in graph:
            if alt_node is not None:
                links_in = []
                for c in graph.in_edges(node_label):
                    l = graph.get_edge_data(*c)['label']
                    if l.startswith('Outlet('):
                        connected_subcatchments.append(c[0])
                    else:
                        links_in.append(l)

                # move SC
                # for sc in connected_subcatchments:
                #     graph.add_edge(sc.name, alt_node, label=f'Outlet({sc.name})')
            else:
                links_in = previous_links_labels(graph, node_label)

            links = next_links_labels(graph, node_label) + links_in  # type: list[str]

            graph.remove_node(node_label)
        else:
            links = []
    else:
        links = []
        for section in LINK_SECTIONS:
            if section in inp:
                links += list(inp[section].filter_keys([node_label], by='from_node')) + \
                         list(inp[section].filter_keys([node_label], by='to_node'))  # type: list[Conduit]
        links = [l.name for l in links]  # type: list[str]

    for link in links:
        delete_link(inp, link)

    if alt_node is not None:
        # INFOWS, DWF
        move_flows(inp, node_label, alt_node)
        # SUBCATCHMENTS
        reconnect_subcatchments(inp, node_label, alt_node, graph, connected_subcatchments)
    else:
        if SUBCATCHMENTS in inp:
            # node is parameter -> delete object

            # for sc in subcatchments_per_node_dict(inp)[from_node]:
            #     delete_subcatchment(sc.name)
            #     sc.outlet = to_node

            # TODO
            warnings.warn('delete_node in SUBCATCHMENTS section not implemented.', SwmmApiInputMacrosWarning)
            # delete_subcatchment()

        # ---
        constituents = get_constituents(inp)
        for section in (DWF, INFLOWS):
            if section in inp:
                for constituent in constituents:
                    if (node_label, constituent) in inp[section]:
                        del inp[section][(node_label, constituent)]
    # ---
    if GROUNDWATER in inp:
        for gw in list(inp.GROUNDWATER.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
            if gw.node == node_label:
                del inp.GROUNDWATER[gw.section_key]
        # warnings.warn('delete_node in GROUNDWATER section not implemented.')

    # ---
    if INLET_USAGE in inp:
        # node is parameter -> delete object
        for inlet_usage in list(inp.INLET_USAGE.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
            if inlet_usage.node == node_label:
                del inp.INLET_USAGE[inlet_usage.section_key]
        # warnings.warn('delete_node in INLET_USAGE section not implemented.')

    # ---
    if TREATMENT in inp:
        if POLLUTANTS in inp:
            for p in inp.POLLUTANTS:
                if (node_label, p) in inp.TREATMENT:
                    del inp.TREATMENT[(node_label, p)]
        else:
            for t in list(inp.TREATMENT.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
                if t.node == node_label:
                    del inp.TREATMENT[t.section_key]


def _mean_dwf_flow(inp, node):
    """Calculate the annual mean dry weather flow of a node."""
    from math import prod
    if isinstance(node, tuple):
        obj = inp.DWF[node]
    elif isinstance(node, DryWeatherFlow):
        obj = node
    else:
        return
    attributes_pattern = ['pattern1', 'pattern2', 'pattern3', 'pattern4']
    return obj.base_value * prod(np.mean(inp.PATTERNS[obj[p]].factors) for p in attributes_pattern if isinstance(obj[p], str))


def move_flows(inp: SwmmInput, from_node, to_node, only_constituent=None):
    """
    move flow (INFLOWS or DWF) from one node to another

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        from_node (str): first node label
        to_node (str): second node label
        only_constituent (list): only consider this constituent (default: FLOW)

    Notes:
        works inplace
    """
    for section in (INFLOWS, DWF):
        if section not in inp:
            continue

        if only_constituent is None:
            only_constituent = [DryWeatherFlow.TYPES.FLOW]  # TODO Pollutants

        for constituent in only_constituent:
            index_old = (from_node, constituent)

            if index_old in inp[section]:
                index_new = (to_node, constituent)

                obj = inp[section].pop(index_old)
                obj.node = to_node

                if index_new not in inp[section]:
                    inp[section].add_obj(obj)

                elif section == DWF:
                    obj: DryWeatherFlow

                    attributes_pattern = ['pattern1', 'pattern2', 'pattern3', 'pattern4']

                    # DryWeatherFlow can be easily added when Patterns are equal
                    if not all(is_equal(obj[p], inp[section][index_new][p]) for p in attributes_pattern):
                        warnings.warn(f'`move_flows` from "{from_node}" to "{to_node}". DWF patterns don\'t match!', SwmmApiInputMacrosWarning)

                        # combine flow to fit annual flow in the best possible way
                        combine_dwf(inp, obj, to_node, constituent)

                        # using dominant flow pattern
                        # mean pattern factor * base_value
                        # if _mean_dwf_flow(inp, obj) > _mean_dwf_flow(inp, index_new):
                        #     print_warning(w+f'mean DWF of node {from_node} is bigger -> using patterns {obj.get(attributes_pattern)}')
                        #     for p in attributes_pattern:
                        #         inp[section][index_new][p] = obj[p]
                        # else:
                        #     print_warning(w+f'mean DWF of node {to_node} is bigger -> using patterns {inp[section][index_new].get(attributes_pattern)}')
                    else:
                        inp[section][index_new].base_value += obj.base_value

                elif section == INFLOWS:
                    obj: Inflow
                    # Inflows can't be added due to the multiplication factor / timeseries
                    # if (TimeSeries, Type, Mfactor, Sfactor,Pattern) are equal then sum(Baseline)
                    if all(is_equal(obj[k], inp[section][index_new][k], precision=5) for k in ['constituent', 'time_series', 'kind', 'mass_unit_factor', 'scale_factor', 'pattern']):
                        inp[section][index_new].base_value += obj.base_value

                    else:
                        warnings.warn(f'in `move_flows` from "{from_node}" to "{to_node}". {section} Already Exists! -> Ignoring', SwmmApiInputMacrosWarning)

            # else:
            #     print_warning(f'Nothing to move from "{from_node}" [{section}]')


def reconnect_subcatchments(inp: SwmmInput, from_node, to_node, graph=None, connected_subcatchments=None):
    """
    Reconnect sub-catchements from one node to another.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        from_node (str): first node label
        to_node (str): second node label

    Notes:
        works inplace
    """
    if SUBCATCHMENTS not in inp:
        return

    if connected_subcatchments is None:
        df = inp.SUBCATCHMENTS.frame
        sc_search = df.outlet == from_node
        connected_subcatchments = sc_search[sc_search].index

    for sc_label in connected_subcatchments:
        inp.SUBCATCHMENTS[sc_label].outlet = to_node
        if graph is not None:
            graph.add_edge(sc_label, to_node, label=f'Outlet({sc_label})')

    # for sc in subcatchments_per_node_dict(inp)[from_node]:
    #     sc.outlet = to_node


def delete_link(inp: SwmmInput, link: str):
    for s in LINK_SECTIONS + LINK_SECTIONS_ADD:
        if (s in inp) and (link in inp[s]):
            inp[s].pop(link)

    remove_obj_from_reporting(inp, kind=ReportSection.KEYS.LINKS, label=link)
    remove_obj_tag(inp, kind=Tag.TYPES.Link, label=link)
    remove_obj_from_control(inp, kind=Control.OBJECTS.LINK, label=link)

    # ---
    if CONDUITS in inp and link in inp.CONDUITS and INLET_USAGE in inp:
        for inlet_usage in list(inp.INLET_USAGE.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
            if inlet_usage.conduit == link:
                del inp.INLET_USAGE[inlet_usage.section_key]


def delete_subcatchment(inp: SwmmInput, subcatchment: str):
    for s in SUBCATCHMENT_SECTIONS:
        if (s in inp) and (subcatchment in inp[s]):
            inp[s].pop(subcatchment)

    remove_obj_from_reporting(inp, ReportSection.KEYS.SUBCATCHMENTS, label=subcatchment)
    remove_obj_tag(inp, kind=Tag.TYPES.Subcatch, label=subcatchment)
    # remove_obj_from_control(inp)  # not implemented in SWMM

    # ---
    if GWF in inp:
        for k in (GroundwaterFlow.TYPES.DEEP, GroundwaterFlow.TYPES.LATERAL):
            if (subcatchment, k) in inp.GWF:
                del inp.GWF[(subcatchment, k)]

    # ---
    if GROUNDWATER in inp:
        for gw in list(inp.GROUNDWATER.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
            if gw.subcatchment == subcatchment:
                del inp.GROUNDWATER[gw.section_key]
        # warnings.warn('delete_subcatchment in GROUNDWATER section not implemented.')

    # ---
    if LID_USAGE in inp:
        if LID_CONTROLS in inp:
            for lid in inp.LID_CONTROLS:
                if (subcatchment, lid) in inp.LID_USAGE:
                    del inp[LID_USAGE][(subcatchment, lid)]
        else:
            for lid_usage in list(inp.LID_USAGE.values()):  # or using filter section. my guess is that very few lid_usage objects are being defined.
                if lid_usage.subcatchment == subcatchment:
                    del inp.LID_USAGE[lid_usage.section_key]
        # warnings.warn('delete_subcatchment in LID_USAGE section not implemented.')


def split_conduit(inp, conduit, intervals=None, length=None, from_inlet=True):
    if _ := True:
        raise NotImplementedError('"split_conduit" is not working yet.')
    # mode = [cut_point (GUI), intervals (n), length (l)]
    nodes = nodes_dict(inp)
    if isinstance(conduit, str):
        conduit = inp[CONDUITS][conduit]  # type: Conduit

    dx = 0
    n_new_nodes = 0
    if intervals:
        dx = conduit.length / intervals
        n_new_nodes = intervals - 1
    elif length:
        dx = length
        n_new_nodes = np.ceil(conduit.length / length - 1)

    from_node = nodes[conduit.from_node]
    to_node = nodes[conduit.to_node]

    from_node_coord = inp[COORDINATES][from_node.name]
    to_node_coord = inp[COORDINATES][to_node.name]

    loss = None
    if (LOSSES in inp) and (conduit.name in inp[LOSSES]):
        loss = inp[LOSSES][conduit.name]  # type: Loss

    new_nodes = []
    new_links = []

    x = dx
    last_node: Junction = from_node
    for new_node_i in range(n_new_nodes + 1):
        warnings.warn('unknown behavior for node is not a junction', SwmmApiInputMacrosWarning)  # TODO node is not a junction
        if x >= conduit.length:
            node = to_node
        else:
            node = Junction(name=f'{from_node.name}_{to_node.name}_{chr(new_node_i + 97)}',
                            elevation=np.interp(x, [0, conduit.length], [from_node.elevation, to_node.elevation]),
                            depth_max=np.interp(x, [0, conduit.length], [from_node.depth_max, to_node.depth_max]),
                            depth_init=np.interp(x, [0, conduit.length], [from_node.depth_init, to_node.depth_init]),
                            depth_surcharge=np.interp(x, [0, conduit.length], [from_node.depth_surcharge, to_node.depth_surcharge]),
                            area_ponded=float(np.mean([from_node.area_ponded, to_node.area_ponded])),
                            )
            new_nodes.append(node)
            inp[JUNCTIONS].add_obj(node)

            # TODO: COORDINATES based on vertices
            inp[COORDINATES].add_obj(Coordinate(node.name,
                                                x=np.interp(x, [0, conduit.length],
                                                             [from_node_coord.x, to_node_coord.x]),
                                                y=np.interp(x, [0, conduit.length],
                                                             [from_node_coord.y, to_node_coord.y])))

        link = Conduit(name=f'{conduit.name}_{chr(new_node_i + 97)}',
                       from_node=last_node.name,
                       to_node=node.name,
                       length=dx,
                       roughness=conduit.roughness,
                       offset_upstream=0 if new_node_i != 0 else conduit.offset_upstream,
                       offset_downstream=0 if new_node_i != (n_new_nodes - 1) else conduit.offset_downstream,
                       flow_initial=conduit.flow_initial,
                       flow_max=conduit.flow_max)
        new_links.append(link)
        inp[CONDUITS].add_obj(link)

        xs = inp[XSECTIONS][conduit.name].copy()
        xs.link = link.name
        inp[XSECTIONS].add_obj(xs)

        if loss:
            inlet = loss.entrance if loss.entrance and (new_node_i == 0) else 0
            outlet = loss.exit if loss.exit and (new_node_i == n_new_nodes - 1) else 0
            average = loss.average / (n_new_nodes + 1)
            flap_gate = loss.has_flap_gate

            if any([inlet, outlet, average, flap_gate]):
                inp[LOSSES].add_obj(Loss(link.name, inlet, outlet, average, flap_gate))

        # TODO: VERTICES

        if node is to_node:
            break
        last_node = node
        x += dx

    # if conduit.Name in inp[VERTICES]:
    #     pass
    # else:
    #     # interpolate coordinates
    #     pass

    delete_link(inp, conduit.name)


def combine_vertices(inp: SwmmInput, label1, label2):
    if COORDINATES not in inp:
        # if there are not coordinates this function is nonsense
        return

    vertices_class = Vertices

    if VERTICES not in inp:
        # we will at least ad the coordinates of the common node
        inp[VERTICES] = Vertices.create_section()
    else:
        vertices_class = inp[VERTICES]._section_object

    new_vertices = []

    if label1 in inp[VERTICES]:
        new_vertices += list(inp[VERTICES][label1].vertices)

    common_node = links_dict(inp)[label1].to_node
    if common_node in inp[COORDINATES]:
        new_vertices += [inp[COORDINATES][common_node].point]

    if label2 in inp[VERTICES]:
        new_vertices += list(inp[VERTICES][label2].vertices)

    if label1 in inp[VERTICES]:
        inp[VERTICES][label1].vertices = new_vertices
    else:
        inp[VERTICES].add_obj(vertices_class(label1, vertices=new_vertices))


def combine_conduits(inp, c1, c2, graph=None, reroute_flows_to: Literal['from_node', 'to_node']='from_node'):
    """
    Combine the two conduits to one - keep attributes of the first (c1).

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        c1 (str | Conduit): conduit 1 to combine
        c2 (str | Conduit): conduit 2 to combine
        graph (networkx.DiGraph): optional, runs faster with graph (inp representation)
        reroute_flows_to (str): reroute the flows and subcatchments outlets to new link.

    Returns:
        Conduit: new combined conduit

    .. Important::
        works inplace
    """
    if isinstance(c1, str):
        c1 = inp[CONDUITS][c1]
    if isinstance(c2, str):
        c2 = inp[CONDUITS][c2]
    # -------------------------
    if graph:
        graph.remove_edge(c1.from_node, c1.to_node)
    # -------------------------
    if c1.from_node == c2.to_node:
        c_first = c2.copy()  # type: Conduit
        c_second = c1.copy()  # type: Conduit
    elif c1.to_node == c2.from_node:
        c_first = c1.copy()  # type: Conduit
        c_second = c2.copy()  # type: Conduit
    else:
        raise EnvironmentError('Links not connected')

    # -------------------------
    # vertices + Coord of middle node
    combine_vertices(inp, c_first.name, c_second.name)

    # -------------------------
    c_new = c1  # type: Conduit
    # -------------------------
    common_node = c_first.to_node
    c_new.from_node = c_first.from_node
    c_new.to_node = c_second.to_node
    # -------------------------
    if graph:
        graph.add_edge(c_new.from_node, c_new.to_node, label=c_new.name)

    if isinstance(c_new, Conduit):
        c_new.length = round(c1.length + c2.length, 1)

        # offsets
        c_new.offset_upstream = c_first.offset_upstream
        c_new.offset_downstream = c_second.offset_downstream

    # Loss
    if (LOSSES in inp) and (c_new.name in inp[LOSSES]):
        warnings.warn(f'combine_conduits {c1.name} and {c2.name}. BUT WHAT TO DO WITH LOSSES?', SwmmApiInputMacrosWarning)
        # add losses
        pass

    delete_node(inp, common_node, graph=graph, alt_node=c_new[reroute_flows_to])
    return c_new


def combine_conduits_keep_slope(inp, c1, c2, graph=None):
    """
    Combine the two conduits to one keep attributes of the first (c1)
    and keep the slope of c1 by adding a downstream offset.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        c1 (str | Conduit): conduit 1 to combine
        c2 (str | Conduit): conduit 2 to combine
        graph (networkx.DiGraph): optional, runs faster with graph (inp representation)

    Returns:
        Conduit: new combined conduit

    .. Important::
        works inplace
    """
    nodes = nodes_dict(inp)
    new_out_offset = (- calc_slope(inp, c1) * c2.length
                      + c1.offset_downstream
                      + nodes[c1.to_node].elevation
                      - nodes[c2.to_node].elevation)
    c1 = combine_conduits(inp, c1, c2, graph=graph)
    c1.offset_downstream = round(new_out_offset, 2)
    return c1


def dissolve_conduit(inp, c, graph=None):
    """
    Dissolve a conduit.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        c (str | Conduit): conduit 1 to combine
        graph (networkx.DiGraph): optional, runs faster with graph (inp representation)

    Returns:
        SwmmInput: inp data
    """
    if isinstance(c, str):
        c = links_dict(inp)[c]
    common_node = c.from_node
    for c_old in list(previous_links(inp, common_node, g=graph)):
        if graph:
            graph.remove_edge(c_old.from_node, c_old.to_node)

        c_new = c_old  # type: Conduit

        # vertices + Coord of middle node
        combine_vertices(inp, c_new.name, c.name)

        c_new.to_node = c.to_node
        # -------------------------
        if graph:
            graph.add_edge(c_new.from_node, c_new.to_node, label=c_new.name)

        # Loss
        if LOSSES in inp and c_new.name in inp[LOSSES]:
            warnings.warn(f'dissolve_conduit {c.name} in {c_new.name}. BUT WHAT TO DO WITH LOSSES?', SwmmApiInputMacrosWarning)

        if isinstance(c_new, Conduit):
            c_new.length = round(c.length + c_new.length, 1)
            # offsets
            c_new.offset_downstream = c.offset_downstream

    delete_node(inp, common_node, graph=graph, alt_node=c.to_node)


def rename_node(inp: SwmmInput, old_label: str, new_label: str, g=None):
    """
    change node label

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        old_label (str): previous node label
        new_label (str): new node label
        g (DiGraph): optional - graph of the network

    .. Important::
        works inplace
        CONTROLS Not Implemented!
    """
    # subcatchment outlets
    if SUBCATCHMENTS in inp:
        for obj in subcatchments_per_node_dict(inp)[old_label]:
            obj.outlet = new_label
        # -------
        # for obj in inp.SUBCATCHMENTS.filter_keys([old_label], 'outlet'):  # type: SubCatchment
        #     obj.outlet = new_label
        # -------

    # ---
    # Nodes and basic node components
    for section in NODE_SECTIONS + NODE_SECTIONS_ADD:
        if (section in inp) and (old_label in inp[section]):
            inp[section][new_label] = inp[section].pop(old_label)
            if hasattr(inp[section][new_label], IDENTIFIERS.name):

                inp[section][new_label].name = new_label
            else:
                inp[section][new_label].node = new_label

    rename_obj_in_tags(inp, Tag.TYPES.Node, old_label, new_label)
    rename_obj_in_reporting_section(inp, ReportSection.KEYS.NODES, old_label, new_label)
    rename_obj_in_control_section(inp, Control.OBJECTS.NODE, old_label, new_label)

    # ---
    # link: from-node and to-node
    previous_links, next_links = links_connected(inp, old_label, g=g)
    for link in previous_links:
        link.to_node = new_label

    for link in next_links:
        link.from_node = new_label

    # ---
    # (dwf-)inflows
    constituents = get_constituents(inp)
    for section in (INFLOWS, DWF, TREATMENT):
        if section in inp:
            for constituent in constituents:
                if (old_label, constituent) in inp[section]:
                    new = inp[section].pop((old_label, constituent))
                    new.node = new_label
                    inp[section].add_obj(new)

    # ---
    if GROUNDWATER in inp:
        for gw in list(inp.GROUNDWATER.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
            if gw.node == old_label:
                new = inp.GROUNDWATER.pop(gw.section_key)  # type: Groundwater
                new.node = new_label
                inp.GROUNDWATER.add_obj(new)

    # ---
    if INLET_USAGE in inp:
        for inlet_usage in list(inp.INLET_USAGE.values()):  # or using filter section. my guess is that very few INLET_USAGE objects are being defined.
            if inlet_usage.node == old_label:
                # node is not an identifier
                # inlet_usage.node = new_label
                # => but to be safe
                new = inp.INLET_USAGE.pop(inlet_usage.section_key)  # type: InletUsage
                new.node = new_label
                inp.INLET_USAGE.add_obj(new)


def rename_link(inp: SwmmInput, old_label: str, new_label: str):
    """
    change link label

    Notes:
        works inplace
        CONTROLS Not Implemented!

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        old_label (str): previous link label
        new_label (str): new link label
    """
    for section in LINK_SECTIONS + LINK_SECTIONS_ADD:
        if (section in inp) and (old_label in inp[section]):
            inp[section][new_label] = inp[section].pop(old_label)
            if hasattr(inp[section][new_label], IDENTIFIERS.name):
                inp[section][new_label].name = new_label
            else:
                inp[section][new_label].link = new_label

    rename_obj_in_tags(inp, Tag.TYPES.Link, old_label, new_label)
    rename_obj_in_reporting_section(inp, ReportSection.KEYS.LINKS, old_label, new_label)
    rename_obj_in_control_section(inp, Control.OBJECTS.LINK, old_label, new_label)

    if CONDUITS in inp and old_label in inp.CONDUITS and INLET_USAGE in inp:
        for inlet_usage in list(inp.INLET_USAGE.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
            if inlet_usage.conduit == old_label:
                new = inp.INLET_USAGE.pop(inlet_usage.section_key)  # type: GroundwaterFlow
                new.conduit = new_label
                inp.INLET_USAGE.add_obj(new)


def rename_subcatchment(inp: SwmmInput, old_label: str, new_label: str):
    for section in SUBCATCHMENT_SECTIONS:
        if (section in inp) and (old_label in inp[section]):
            inp[section][new_label] = inp[section].pop(old_label)
            if hasattr(inp[section][new_label], IDENTIFIERS.name):
                inp[section][new_label].name = new_label
            else:
                inp[section][new_label].subcatchment = new_label

    rename_obj_in_tags(inp, Tag.TYPES.Subcatch, old_label, new_label)
    rename_obj_in_reporting_section(inp, ReportSection.KEYS.SUBCATCHMENTS, old_label, new_label)
    # rename_obj_in_control_section(inp)  # not implemented in SWMM

    # ---
    if GWF in inp:
        for k in (GroundwaterFlow.TYPES.DEEP, GroundwaterFlow.TYPES.LATERAL):
            if (old_label, k) in inp.GWF:
                new = inp.GWF.pop((old_label, k))  # type: GroundwaterFlow
                new.subcatchment = new_label
                inp.GWF.add_obj(new)

    # ---
    if GROUNDWATER in inp:
        for gw in list(inp.GROUNDWATER.values()):  # or using filter section. my guess is that very few groundwater objects are being defined.
            if gw.subcatchment == old_label:
                new = inp.GROUNDWATER.pop(gw.section_key)  # type: Groundwater
                new.subcatchment = new_label
                inp.GROUNDWATER.add_obj(new)

    # ---
    if LID_USAGE in inp:
        if LID_CONTROLS in inp:
            for lid in inp.LID_CONTROLS:
                if (old_label, lid) in inp.LID_USAGE:
                    new = inp.LID_USAGE.pop((old_label, lid))  # type: LIDUsage
                    new.subcatchment = new_label
                    inp.LID_USAGE.add_obj(new)

        else:
            for lid_usage in list(inp.LID_USAGE.values()):  # or using filter section. my guess is that very few lid_usage objects are being defined.
                if lid_usage.subcatchment == old_label:
                    new = inp.LID_USAGE.pop(lid_usage.section_key)  # type: LIDUsage
                    new.subcatchment = new_label
                    inp.LID_USAGE.add_obj(new)


def rename_timeseries(inp, old_label, new_label):
    """
    change timeseries label

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        old_label (str): previous timeseries label
        new_label (str): new timeseries label

    .. Important::
        works inplace
    """
    if old_label in inp[TIMESERIES]:
        obj = inp[TIMESERIES].pop(old_label)  # type: swmm_api.input_file.sections.timeseries
        obj.name = new_label
        inp[TIMESERIES].add_obj(obj)

    key = EvaporationSection.KEYS.TIMESERIES  # TemperatureSection.KEYS.TIMESERIES, ...

    if RAINGAGES in inp:
        f = inp[RAINGAGES].frame
        filtered_table = f[(f['source'] == key) & (f['timeseries'] == old_label)]
        if not filtered_table.empty:
            for i in filtered_table.index:
                inp[RAINGAGES][i].timeseries = new_label

    if EVAPORATION in inp:
        if key in inp[EVAPORATION]:
            if inp[EVAPORATION][key] == old_label:
                inp[EVAPORATION][key] = new_label

    if TEMPERATURE in inp:
        if key in inp[TEMPERATURE]:
            if inp[TEMPERATURE][key] == old_label:
                inp[TEMPERATURE][key] = new_label

    if OUTFALLS in inp:
        f = inp[OUTFALLS].frame
        filtered_table = f[(f['kind'] == key) & (f['data'] == old_label)]
        if not filtered_table.empty:
            for i in filtered_table.index:
                inp[OUTFALLS][i].data = new_label

    if INFLOWS in inp:
        f = inp[INFLOWS].frame
        filtered_table = f[f['time_series'] == old_label]
        if not filtered_table.empty:
            for i in filtered_table.index:
                inp[INFLOWS][i].time_series = new_label


def flip_link_direction(inp, link_label):
    link = find_link(inp, link_label)
    if link:
        link.from_node, link.to_node = link.to_node, link.from_node


def remove_quality_model(inp):
    """
    remove all sections only for modelling quality

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    .. Important::
        works inplace
    """
    inp.delete_sections(POLLUTANT_SECTIONS)

    for sec in [INFLOWS, DWF]:
        for k in list(inp[sec].keys()):
            if inp[sec][k].constituent != 'FLOW':
                del inp[sec][k]


def delete_pollutant(inp, label):
    """
    Delete pollutant in model

    Remove all entries with this pollutant

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label (str):

    .. Important::
        works inplace
    """
    if POLLUTANTS in inp:
        del inp.POLLUTANTS[label]
    # ---
    if LOADINGS in inp:
        for l in inp.LOADINGS:
            if label in inp.LOADINGS[l].pollutant_buildup_dict:
                del inp.LOADINGS[l].pollutant_buildup_dict[label]
    # ---
    if LANDUSES in inp:
        for lu in inp.LANDUSES:
            for sec in [BUILDUP, WASHOFF]:
                if (sec in inp) and ((lu, label) in inp[sec]):
                    del inp[sec][(lu, label)]
    # ---
    if LID_CONTROLS in inp:
        for lid_control in inp.LID_CONTROLS.values():
            if ((lid_control.LAYER_TYPES.REMOVALS in lid_control.layer_dict)
                    and (label in lid_control.layer_dict[lid_control.LAYER_TYPES.REMOVALS])):
                warnings.warn('delete_pollutant in LID_CONTROLS (REMOVALS) section not implemented.', SwmmApiInputMacrosWarning)  # TODO
    # ---
    for n in nodes_dict(inp):
        for sec in [TREATMENT, DWF, INFLOWS]:
            if (sec in inp) and ((n, label) in inp[sec]):
                del inp[sec][(n, label)]


def copy_link(inp_from: SwmmInput, inp_to: SwmmInput, link_label):
    for s in LINK_SECTIONS + LINK_SECTIONS_ADD:
        if (s in inp_from) and (link_label in inp_from[s]):
            inp_to.add_obj(inp_from[s][link_label].copy())

    if (TAGS in inp_from) and ((Tag.TYPES.Link, link_label) in inp_from.TAGS):
        inp_to.add_obj(inp_from[TAGS][(Tag.TYPES.Link, link_label)].copy())


def copy_node(inp_from: SwmmInput, inp_to: SwmmInput, node_label):
    for s in NODE_SECTIONS + NODE_SECTIONS_ADD:
        if (s in inp_from) and (node_label in inp_from[s]):
            inp_to.add_obj(inp_from[s][node_label].copy())

    if (TAGS in inp_from) and ((Tag.TYPES.Node, node_label) in inp_from.TAGS):
        inp_to.add_obj(inp_from[TAGS][(Tag.TYPES.Node, node_label)].copy())


def remove_obj_from_reporting(inp, kind, label):
    """
    Remove object from reporting section.

    Object will not be reported in the output-file.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        kind (str): one of (`SUBCATCHMENTS`, `NODES`, `LINKS`). You can use the :attr:`ReportSection.KEYS` attribute.
        label (str): label of the object, which shouldn't be reported in the output-file.

    .. Important::
        works inplace
    """
    if (REPORT in inp) and (kind in inp.REPORT):
        if (isinstance(inp.REPORT[kind], (list, tuple, set))
                and (label in inp.REPORT[kind])):
            inp.REPORT[kind] = list(inp.REPORT[kind])
            inp.REPORT[kind].remove(label)


def rename_obj_in_reporting_section(inp, kind, old_label, new_label):
    """
    Rename object in reporting section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        kind (str): one of (`SUBCATCHMENTS`, `NODES`, `LINKS`). You can use the :attr:`ReportSection.KEYS` attribute.
        old_label (str): old label of the object, which tag should be renamed.
        new_label (str): new label of the object, which tag should be renamed.

    .. Important::
        works inplace
    """
    if (REPORT in inp) and (kind in inp.REPORT):
        if (isinstance(inp.REPORT[kind], (list, tuple, set))
                and (old_label in inp.REPORT[kind])):
            inp.REPORT[kind] = list(inp.REPORT[kind])
            inp.REPORT[kind].remove(old_label)
            inp.REPORT[kind].append(new_label)


def remove_obj_tag(inp, kind, label):
    """
    Remove tag froo object.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        kind (str): one of (`Subcatch`, `Node`, `Link`). You can use the :attr:`Tag.TYPES` attribute.
        label (str): label of the object, which tag should be removed.

    .. Important::
        works inplace
    """
    if (TAGS in inp) and ((kind, label) in inp.TAGS):
        del inp[TAGS][(kind, label)]


def rename_obj_in_tags(inp, kind, old_label, new_label):
    """
    Rename object in tags section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        kind (str): one of (`Subcatch`, `Node`, `Link`). You can use the :attr:`Tag.TYPES` attribute.
        old_label (str): old label of the object, which tag should be renamed.
        new_label (str): new label of the object, which tag should be renamed.

    .. Important::
        works inplace
    """
    if (TAGS in inp) and ((kind, old_label) in inp.TAGS):
        inp[TAGS][(kind, new_label)] = inp[TAGS].pop((kind, old_label))
        inp.TAGS[(kind, new_label)].name = new_label


def remove_obj_from_control(inp, kind: str, label: str):
    """
    Remove object from CONTROLS section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        kind (str): one of (`NODE`, `LINK`). You can use the :attr:`swmm_api.input_file.sections.Control.OBJECTS` attribute.
        label (str): label of the object, which will be removed from the model.

    .. Important::
        works inplace
    """
    if CONTROLS not in inp:
        return

    possible_kinds = {kind}
    if kind == Control.OBJECTS.LINK:
        possible_kinds = {Control.OBJECTS.LINK,
                          Control.OBJECTS.CONDUIT,
                          Control.OBJECTS.ORIFICE,
                          Control.OBJECTS.OUTLET,
                          Control.OBJECTS.WEIR,
                          Control.OBJECTS.PUMP}

    for label_control in list(inp.CONTROLS.keys()):
        control = inp.CONTROLS[label_control]

        if isinstance(control, ControlExpression):
            # expressions dont have object labels
            ...
        elif isinstance(control, ControlVariable):
            if (control.object_kind in possible_kinds) and (control.label == label):
                del inp.CONTROLS[label_control]
        else:
            # ---
            # if object in condition: remove whole rule
            for condition in control.conditions:  # type: Control._Condition
                if (condition.object_kind in possible_kinds) and (condition.label == label):
                    del inp.CONTROLS[label_control]
                    continue

            # ---
            if label_control not in inp.CONTROLS:
                continue

            # ---
            # if object in action: remove only this action
            if kind == Control.OBJECTS.LINK:  # action only for links
                for action in list(control.actions_if):  # type: Control._Action
                    if action.label == label:
                        # i = control.actions_if.index(action)
                        # inp.CONTROLS[label_control].actions_if.remove(i)
                        inp.CONTROLS[label_control].actions_if.remove(action)

                for action in list(control.actions_else):  # type: Control._Action
                    if action.label == label:
                        # i = control.actions_else.index(action)
                        # inp.CONTROLS[label_control].actions_else.remove(i)
                        inp.CONTROLS[label_control].actions_else.remove(action)

                # if no actions left
                if not control.actions_if:
                    del inp.CONTROLS[label_control]


def rename_obj_in_control_section(inp, kind, old_label: str, new_label: str):
    """
    Rename a object in the CONTROLS section.

    Args:
        inp (swmm_api.SwmmInput): input data.
        kind (str): one of (`LINK`, `NODE`). You can use the :attr:`swmm_api.input_file.sections.Control.OBJECTS` attribute.
        old_label (str): old label of the object, which tag should be renamed.
        new_label (str): new label of the object, which tag should be renamed.

    .. Important::
        works inplace
    """
    if CONTROLS not in inp:
        return

    possible_kinds = {kind}
    if kind == Control.OBJECTS.LINK:
        possible_kinds = {Control.OBJECTS.LINK,
                          Control.OBJECTS.CONDUIT,
                          Control.OBJECTS.ORIFICE,
                          Control.OBJECTS.OUTLET,
                          Control.OBJECTS.WEIR,
                          Control.OBJECTS.PUMP}

    for control in inp.CONTROLS.values():
        if isinstance(control, ControlExpression):
            # expressions dont have object labels
            ...
        elif isinstance(control, ControlVariable):
            if (control.object_kind in possible_kinds) and (control.label == old_label):
                control.label = new_label
            #warnings.warn('The reduction of Variables and Expressions in the CONTROL section is not yet implemented in function `rename_obj_in_control_section`.', SwmmApiInputMacrosWarning)
        else:
            # ---
            for condition in control.conditions:  # type: Control._Condition
                if (condition.object_kind in possible_kinds) and (condition.label == old_label):
                    condition.label = new_label

            # ---
            if kind == Control.OBJECTS.LINK:  # action only for links
                for action in list(control.actions_if) + list(control.actions_else):  # type: Control._Action
                    if action.label == old_label:
                        action.label = new_label
