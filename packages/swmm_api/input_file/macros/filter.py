from .reduce_unneeded import (reduce_controls, reduce_curves, reduce_raingages, remove_empty_sections, reduce_pattern,
                              reduce_timeseries, reduce_report_objects, )
from ..section_labels import *
from ..section_lists import LINK_SECTIONS, NODE_SECTIONS, NODE_SECTIONS_ADD, LINK_SECTIONS_ADD, SUBCATCHMENT_SECTIONS
from ..sections import Tag
from ..sections._identifiers import IDENTIFIERS


def filter_tags(inp, kind, list_of_objects):
    """
    Filter tags for one object-type.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        kind (str): one of (`Subcatch`, `Node`, `Link`). You can use the :attr:`Tag.TYPES` attribute.
        list_of_objects (list[str]): list of object-labels.

    .. Important::
        works inplace
    """
    if TAGS in inp:
        new = inp[TAGS].create_new_empty()
        all_types = [Tag.TYPES.Subcatch, Tag.TYPES.Node, Tag.TYPES.Link]
        other_types = all_types.copy()
        other_types.remove(kind)

        new.add_multiple(*inp[TAGS].filter_keys(other_types, by='kind'))
        new.add_multiple(*inp[TAGS].filter_keys(((kind, k) for k in list_of_objects)))
        inp[TAGS] = new
        # inp[TAGS] = inp[TAGS].slice_section(((kind, k) for k in list_of_objects))  # error: removes other objects


def filter_nodes(inp, final_nodes):
    """
     Filter nodes in the network.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        final_nodes (list | set):

    Returns:
        swmm_api.SwmmInput: new inp-file data
    """
    for section in NODE_SECTIONS + NODE_SECTIONS_ADD:
        if section in inp:
            inp[section] = inp[section].slice_section(final_nodes)

    # ---
    for section in [INFLOWS, DWF, GROUNDWATER, INLET_USAGE]:
        if section in inp:
            inp[section] = inp[section].slice_section(final_nodes, by=IDENTIFIERS.node)

    # ---
    filter_tags(inp, Tag.TYPES.Node, final_nodes)

    # __________________________________________
    remove_empty_sections(inp)
    return inp


def filter_links_within_nodes(inp, final_nodes):
    """
    filter links by nodes in the network

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        final_nodes (list | set):

    Returns:
        swmm_api.SwmmInput: new inp-file data
    """
    final_links = set()
    for section in LINK_SECTIONS:
        if section in inp:
            inp[section] = inp[section].slice_section(final_nodes, by=['from_node', 'to_node'])
            final_links |= set(inp[section].keys())

    # ---
    inp = _filter_link_components(inp, final_links)
    # ---
    remove_empty_sections(inp)
    return inp


def filter_links(inp, final_links):
    """
    filter links by nodes in the network

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        final_links (list | set):

    Returns:
        swmm_api.SwmmInput: new inp-file data
    """
    for section in LINK_SECTIONS:
        if section in inp:
            inp[section] = inp[section].slice_section(final_links)

    # ---
    inp = _filter_link_components(inp, final_links)
    # ---
    remove_empty_sections(inp)
    return inp


def _filter_link_components(inp, final_links):
    for section in LINK_SECTIONS_ADD:
        if section in inp:
            inp[section] = inp[section].slice_section(final_links)

    # ---
    filter_tags(inp, Tag.TYPES.Link, final_links)

    # ---
    if CONDUITS in inp and INLET_USAGE in inp:
        inp[INLET_USAGE] = inp[INLET_USAGE].slice_section(final_links, by='conduit')

    # ---
    remove_empty_sections(inp)
    return inp


def filter_subcatchments(inp, final_nodes):
    """
    filter subcatchments by nodes in the network

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        final_nodes (list | set):

    Returns:
        swmm_api.SwmmInput: new inp-file data
    """
    other_sc_sections = SUBCATCHMENT_SECTIONS.copy()
    other_sc_sections.remove(SUBCATCHMENTS)

    if SUBCATCHMENTS in inp:
        sub_orig = inp[SUBCATCHMENTS].copy()
        # all with an outlet to final_nodes
        inp[SUBCATCHMENTS] = inp[SUBCATCHMENTS].slice_section(final_nodes, by='outlet')
        # all with an outlet to a subcatchment
        inp[SUBCATCHMENTS].update(sub_orig.slice_section(inp[SUBCATCHMENTS].keys(), by='outlet'))

        # __________________________________________
        for section in other_sc_sections:
            if section in inp:
                inp[section] = inp[section].slice_section(inp[SUBCATCHMENTS])

        for section in [LID_USAGE, GWF, GROUNDWATER]:
            if section in inp:
                inp[section] = inp[section].slice_section(final_nodes, by=IDENTIFIERS.subcatchment)

        # __________________________________________
        filter_tags(inp, Tag.TYPES.Subcatch, inp[SUBCATCHMENTS])

    else:
        for section in other_sc_sections:
            if section in inp:
                del inp[section]

        if TAGS in inp:
            inp[TAGS] = inp[TAGS].slice_section([Tag.TYPES.Node, Tag.TYPES.Link], by='kind')

    # __________________________________________
    remove_empty_sections(inp)
    return inp


def create_sub_inp(inp, nodes):
    """
    Split model network and only keep nodes.

    Warnings:
        This changes the inp-object. Use inp.copy() as parameter for this function when original structure should not be changed.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        nodes (list[str]): list of node labels to keep in inp data

    Returns:
        swmm_api.SwmmInput: filtered inp-file data
    """
    inp = filter_nodes(inp, nodes)
    inp = filter_links_within_nodes(inp, nodes)
    inp = filter_subcatchments(inp, nodes)

    # __________________________________________
    reduce_controls(inp)
    reduce_curves(inp)
    reduce_raingages(inp)
    reduce_pattern(inp)
    reduce_timeseries(inp)
    remove_empty_sections(inp)
    reduce_report_objects(inp)
    return inp
