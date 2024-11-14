from ._helpers import print_warning
from .collection import nodes_dict
from .convert_object import junction_to_divider, junction_to_storage
from .graph import inp_to_graph, next_links_labels, next_links, previous_nodes, next_nodes, previous_links
from .macros import calc_slope
from .. import SEC
from ..sections import Storage, Conduit, Divider, Junction
from .cross_section_curve import get_cross_section_maker


def to_kinematic_wave(inp):
    """
    Alpha -> not well tested!

    ERROR 115: adverse slope for Conduit _______.
        Under Steady or Kinematic Wave routing, all conduits must have positive slopes.
        This can usually be corrected by reversing the inlet and outlet nodes of the conduit (i.e., right-click on the conduit and select Reverse from the popup menu that appears).
        Adverse slopes are permitted under Dynamic Wave routing.

    EROOR 131: the following links form cyclic loops in the drainage system.
        The Steady and Kinematic Wave flow routing methods cannot be applied to systems where a cyclic loop exists (i.e., a directed path along a set of links that begins and ends at the same node).
        Most often the cyclic nature of the loop can be eliminated by reversing the direction of one of its links (i.e., switching the inlet and outlet nodes of the link).
        The names of the links that form the loop will be listed following this message.

    ERROR 133: Node _______ has more than one outlet link.
        Under Steady and Kinematic Wave flow routing, a junction node can have only a single outlet link.

    ERROR 139: Regulator _______ is the outlet of a non-storage node.
        Under Steady or Kinematic Wave flow routing, orifices, weirs, and outlet links can only be used as outflow links from storage nodes.

    Args:
        inp (swmm_api.SwmmInput):

    Returns:
        swmm_api.SwmmInput: model is kinematic wave ready
    """
    nodes = nodes_dict(inp)
    graph = inp_to_graph(inp)

    # For every link with a negative slope
    # higher inlet node
    # or lower outlet node
    for link in inp.CONDUITS.values():
        slope = calc_slope(inp, link)
        if slope < 0:
            print(link, f'{slope=:0.3f}')
            node_in = nodes[link.from_node]
            node_out = nodes[link.to_node]
            elevation_in_previous = min([nodes[n].elevation for n in previous_nodes(graph, node_in.name)])
            elevation_out_next = max([nodes[n].elevation for n in next_nodes(graph, node_out.name)])

            if elevation_in_previous > node_out.elevation:
                node_in.elevation = node_out.elevation
                print(f'   {node_in._short_debug_string}.elevation = {node_out._short_debug_string}.elevation = {node_out.elevation}')
            elif elevation_out_next < node_in.elevation:
                node_out.elevation = node_in.elevation
                print(f'   {node_out._short_debug_string}.elevation = {node_in._short_debug_string}.elevation = {node_in.elevation}')
            else:
                print_warning('   No solution found.')

    # -----------------
    # Für jedes Wehr -> gibt es eine abzweigung? mach einen
    # if SEC.WEIRS in inp:
    #     for weir in list(inp.WEIRS.values()):
    #         node_in = nodes[weir.from_node]
    #         outflow_links = list(next_links(inp, node_in.name, graph))
    #         n_outflow = len(outflow_links)
    #         if n_outflow > 1:
    #             print(node_in._short_debug_string, f'{n_outflow=} | {[o._short_debug_string for o in outflow_links]}')
    #             if weir.height_crest <= 0.05:
    #                 flow_begin = 0
    #             else:
    #                 # link_prev = list(next_links(inp, node_in.name, graph))[0]
    #                 link_prev = list(previous_links(inp, node_in.name, graph))[0]
    #                 slope = calc_slope(inp, link_prev)
    #                 cs = get_cross_section_maker(inp, link_prev.name)
    #
    #                 # flow_max = weir.discharge_coefficient * weir.height_crest ** 1.5
    #
    #                 if weir.height_crest >= inp.XSECTIONS[link_prev.name].height:
    #                     flow_begin = cs.flow_v(slope, k=1)
    #                 else:
    #                     flow_begin = cs.flow_t(weir.height_crest, slope=slope, k=1)
    #             if isinstance(node_in, Junction):
    #                 print(f'   Junction to Divider-weir: {node_in.name}')
    #                 # junction_to_divider(inp, node_in.name, link=weir.name, kind=Divider.TYPES.WEIR, data=[flow_begin, weir.height_crest, weir.discharge_coefficient])
    #                 # junction_to_divider(inp, node_in.name, link=weir.name, kind=Divider.TYPES.CUTOFF, data=flow_begin)
    #
    #                 print(f'   Junction to Storage: {node_in.name}')
    #                 junction_to_storage(inp, node_in.name, kind=Storage.TYPES.FUNCTIONAL, data=[0, 0, 10])
    #             elif isinstance(node_in, Storage):
    #                 pass
    #                 # print(f'   Storage to Divider-weir: {node_in.name}')
    #                 # inp[SEC.STORAGE].pop(node_in.name)
    #                 # inp.add_obj(Divider(name=node_in.name, elevation=node_in.elevation, depth_max=node_in.depth_max,
    #                 #                     depth_init=node_in.depth_init,
    #                 #                     link=weir.name, kind='WEIR', data=[flow_begin, weir.height_crest, weir.discharge_coefficient]))
    #             else:
    #                 print(f'   No solution for {node_in}')
    #
    #             # print(f'   weir to conduit: {weir.name}')
    #             # inp.WEIRS.pop(weir.name)
    #             # inp.add_obj(Conduit(weir.name, weir.from_node, weir.to_node, offset_upstream=weir.height_crest, length=10, roughness=0.0125))

    # -----------------
    graph = inp_to_graph(inp)
    for junction in list(inp.JUNCTIONS.values()):
        outflow_links = list(next_links(inp, junction.name, graph))
        n_outflow = len(outflow_links)
        if n_outflow > 1:
            print(junction._short_debug_string, f'{n_outflow=} | {[o._short_debug_string for o in outflow_links]}')
            print(f'   Junction to Storage: {junction.name}')
            junction_to_storage(inp, junction.name, kind=Storage.TYPES.FUNCTIONAL, data=[0, 0, 10])
            # junction_to_divider(inp, junction.name, link='', kind='OVERFLOW', data=None)
    #
    # # -----------------
    nodes = nodes_dict(inp)

    for regulator_section in (SEC.ORIFICES, SEC.WEIRS, SEC.OUTLETS):
        if regulator_section in inp:
            for regulator in inp[regulator_section].values():
                node_out = nodes[regulator.from_node]
                if not isinstance(node_out, Storage):
                    print(regulator._short_debug_string, '|', node_out._short_debug_string)
                    print(f'   Junction to Storage: {node_out.name}')
                    junction_to_storage(inp, node_out.name, kind=Storage.TYPES.FUNCTIONAL, data=[0, 0, 10])

    return inp
