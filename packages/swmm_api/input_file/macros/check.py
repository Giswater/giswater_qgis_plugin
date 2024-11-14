import itertools

from ._helpers import get_used_curves
from .collection import links_dict, nodes_dict
from .graph import inp_to_graph, next_links_labels, previous_links_labels
from ..section_labels import SUBCATCHMENTS, CURVES
from ..section_lists import NODE_SECTIONS, LINK_SECTIONS


def check_for_nodes_old(inp):
    """
    check if any link-end-node is missing

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
       tuple[set[swmm_api.input_file.sections.link._Link], set[str]]: set of corrupt links and a set of missing nodes
    """
    links = links_dict(inp)
    node_labels = set(nodes_dict(inp).keys())
    nodes_missing = set()
    links_corrupt = set()
    for link in links.values():
        if link.from_node not in node_labels:
            nodes_missing.add(link.from_node)
            links_corrupt.add(link)

        if link.to_node not in node_labels:
            nodes_missing.add(link.to_node)
            links_corrupt.add(link)

    return links_corrupt, nodes_missing


def check_for_nodes(inp):
    """
    Check if any link-end-node is missing.

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
       dict[str, list[swmm_api.input_file.sections.link._Link]]: dict of missing nodes with connected corrupt links
    """
    links = links_dict(inp)
    node_labels = set(nodes_dict(inp).keys())
    nodes_missing = dict()

    for link in links.values():
        if link.from_node not in node_labels:
            if link.from_node in nodes_missing:
                nodes_missing[link.from_node].append(link)
            else:
                nodes_missing[link.from_node] = [link]


        if link.to_node not in node_labels:
            if link.to_node in nodes_missing:
                nodes_missing[link.to_node].append(link)
            else:
                nodes_missing[link.to_node] = [link]

    return nodes_missing


def check_for_duplicate_nodes(inp):
    """
    Check if any node or subcatchment has a duplicate label in a different section.

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
        set[str]: set of duplicate nodes and subcatchments
    """
    nodes = {s: set(inp[s]) for s in NODE_SECTIONS + [SUBCATCHMENTS] if s in inp}

    nodes_duplicate = set()
    for s1, s2 in itertools.combinations(nodes.keys(), 2):
        nodes_duplicate |= nodes[s1] & nodes[s2]

    return nodes_duplicate


def check_for_duplicate_links(inp):
    """
    Check if any link has a duplicate label in a different section.

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
        set[str]: set of duplicate links
    """
    links = {s: set(inp[s]) for s in LINK_SECTIONS if s in inp}

    links_duplicate = set()
    for s1, s2 in itertools.combinations(links.keys(), 2):
        links_duplicate |= links[s1] & links[s2]

    return links_duplicate


def check_for_duplicates(inp):
    """
    check if any node, link or subcatchment has a duplicate label in a different section

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
        tuple[set[str], set[str]]: set of duplicate nodes, links and subcatchments
    """
    return check_for_duplicate_nodes(inp), check_for_duplicate_links(inp)


def check_for_subcatchment_outlets_old(inp):
    """
    check if any subcatchments lost their outlets

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
        tuple[set[swmm_api.input_file.sections.subcatch.SubCatchment], set[str]]: : set of subcatchments_corrupt, outlets_missing
    """
    if SUBCATCHMENTS in inp:
        possible_outlets = set(nodes_dict(inp).keys()) | set(inp.SUBCATCHMENTS.keys())
        outlets = inp.SUBCATCHMENTS.frame.outlet
        outlets_missing = set(outlets) - possible_outlets
        subcatchments_corrupt = {sc for sc in inp.SUBCATCHMENTS.values() if sc.outlet in outlets_missing}
        return subcatchments_corrupt, outlets_missing


def check_for_subcatchment_outlets(inp):
    """
    Check if any subcatchments lost their outlets.

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
        dict[str, list[swmm_api.input_file.sections.subcatch.SubCatchment]]: : dict of outlets_missing with connected subcatchments
    """
    if SUBCATCHMENTS in inp:
        possible_outlets = set(nodes_dict(inp).keys()) | set(inp.SUBCATCHMENTS.keys())
        outlets = inp.SUBCATCHMENTS.frame.outlet
        outlets_missing = set(outlets) - possible_outlets
        import pandas as pd
        subcatchments_by_outlets_missing = pd.Series(index=outlets.values, data=outlets.index).groupby(level=0).apply(list).loc[list(outlets_missing)].to_dict()
        return subcatchments_by_outlets_missing


def check_for_curves(inp):
    """
    Check if any curve is missing.

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:
       dict[str, list[swmm_api.input_file.sections.link._Link]]: dict of missing nodes with connected corrupt links
    """
    used_curves = get_used_curves(inp)
    if CURVES not in inp:
        return used_curves
    return used_curves - set(inp.CURVES)


def check_outfall_connections(inp):
    """
    ERROR 141: Outfall ____ has more than 1 inlet link or an outlet link.

    Args:
        inp (swmm_api.SwmmInput): inp data

    Returns:

    """
    #
    g = inp_to_graph(inp)
    error_nodes = {}
    for outfall_label in inp.OUTFALLS:
        upstream_links = previous_links_labels(g, outfall_label)
        downstream_links = next_links_labels(g, outfall_label)
        if len(upstream_links) > 1 or downstream_links:
            error_nodes[outfall_label] = (upstream_links, downstream_links)
    return error_nodes
