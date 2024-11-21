# from networkx import DiGraph, all_simple_paths, subgraph, node_connected_component
import networkx as nx
from .collection import nodes_dict, links_dict
from .filter import create_sub_inp
from ..inp import SwmmInput
from ..section_labels import SUBCATCHMENTS


def inp_to_graph(inp, add_subcatchments=False):
    """
    Create a network of the model with the networkx package

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        add_subcatchments (bool): if the subcatchments should be added to the graph

    Returns:
        networkx.DiGraph: networkx graph of the model
    """
    # g = nx.Graph()
    g = nx.DiGraph()

    # Add all nodes
    for node in nodes_dict(inp).values():
        g.add_node(node.name, obj=node)

    # Add all subcatchments as nodes
    # connect SC to outlet nodes
    if add_subcatchments and (SUBCATCHMENTS in inp):
        for sc_label, sc in inp[SUBCATCHMENTS].items():
            g.add_node(sc.name, obj=sc)
        for sc in inp.SUBCATCHMENTS.values():  # has to be a second loop -> if a SC has a SC as Outlet and that SC is not jet in the network
            g.add_edge(sc.name, sc.outlet, label=f'Outlet({sc.name})')

    for link in links_dict(inp).values():
        # if link.FromNode not in g:
        #     g.add_node(link.FromNode)
        # if link.ToNode not in g:
        #     g.add_node(link.ToNode)

        if g.has_edge(link.from_node, link.to_node):  # Parallel link
            label = g.get_edge_data(link.from_node, link.to_node)['label']
            obj = g.get_edge_data(link.from_node, link.to_node)['obj']
            if isinstance(label, str):
                label = [label]
                obj = [obj]
            label.append(link.name)
            obj.append(link)
            g.add_edge(link.from_node, link.to_node, label=label, obj=obj)

        else:  # new link
            g.add_edge(link.from_node, link.to_node, label=link.name, obj=link)
    return g


def get_path(g, start, end):
    # dijkstra_path(g, start, end)
    return list(nx.all_simple_paths(g, start, end))[0]


def get_path_subgraph(base, start, end):
    g = inp_to_graph(base) if isinstance(base, SwmmInput) else base
    sub_list = get_path(g, start=start, end=end)
    sub_graph = nx.subgraph(g, sub_list)
    return sub_list, sub_graph


# ---------------------------------------
def next_nodes(g, node):
    return list(g.successors(node))


def previous_nodes(g, node):
    return list(g.predecessors(node))


# ---------------------------------------
def _next_links_labels(g, node):
    for i in g.out_edges(node):
        label = g.get_edge_data(*i)['label']
        if isinstance(label, list):
            yield from label
        else:
            yield label


def next_links_labels(g, node):
    return list(_next_links_labels(g, node))


def next_links(inp, node, g=None):
    if g is None:
        g = inp_to_graph(inp)
    links = links_dict(inp)
    for label in _next_links_labels(g, node):
        if label in links:
            yield links[label]


# ---------------------------------------
def _previous_links_labels(g, node):
    for i in g.in_edges(node):
        label = g.get_edge_data(*i)['label']
        if isinstance(label, list):
            yield from label
        else:
            yield label


def previous_links_labels(g, node):
    return list(_previous_links_labels(g, node))


def previous_links(inp, node, g=None):
    if g is None:
        g = inp_to_graph(inp)
    links = links_dict(inp)
    for label in _previous_links_labels(g, node):
        if label in links:
            yield links[label]


# def _previous_links(g, node):
#     for i in g.in_edges(node):
#         yield i, g.get_edge_data(*i)


def links_connected(inp, node, g=None):
    """
    Get the names of the links connected to the node.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        node (str): name of the node.
        g (networkx.DiGraph | optionl): graph of the swmm-network.

    Returns:
        tuple[list[swmm_api.input_file.sections.link._Link]]: list of the upstream and downstream links connected to the node
    """
    if g is None:
        g = inp_to_graph(inp)
    next_ = list(next_links(inp, node, g=g))
    previous_ = list(previous_links(inp, node, g=g))
    return previous_, next_


def number_in_out(g, node):
    return g.in_degree(node), g.out_degree(node)


def get_downstream_nodes(graph, node):
    """
    Get all nodes downstream of the node given.

    only the direction of links defined in the INP file counts (not the elevation)

    Args:
        graph (networkx.DiGraph): network of the inp data
        node (str): node label

    Returns:
        list[str]: list of nodes downstream of the given node
    """
    return _downstream_nodes(graph,  node)


def _downstream_nodes(graph: nx.DiGraph, node: str, node_list=None) -> list:
    if node_list is None:
        node_list = []
    node_list.append(node)
    next_nodes = list(graph.successors(node))
    if next_nodes:
        for n in next_nodes:
            if n in node_list:
                continue
            node_list = _downstream_nodes(graph, n, node_list)
    return node_list


# def _downstream_nodes2(graph: DiGraph, node: str): # SLOWER - maybe because of recursion
#     yield node
#     for n in graph.successors(node):
#         yield from _downstream_nodes2(graph, n)


# def _downstream_nodes3(graph: DiGraph, node: str) -> list[str]: NOT WORKING
#     while graph.out_degree[node] >= 1:
#         yield node
#         node = list(graph.successors(node))[0]


def get_upstream_nodes(graph, node):
    """
    Get all nodes upstream of the node given

    only the direction of links defined in the INP file counts (not the elevation)

    Args:
        graph (networkx.DiGraph): network of the inp data
        node (str): node label

    Returns:
        list[str]: list of nodes upstream of the given node
    """
    return list(_upstream_nodes(graph, node))


def _upstream_nodes(graph: nx.DiGraph, node: str, nodes_list=None) -> set:
    if nodes_list is None:
        nodes_list = set()
    nodes_list.add(node)
    for n in graph.predecessors(node):
        if n in nodes_list:
            continue
        nodes_list = _upstream_nodes(graph, n, nodes_list)
    return nodes_list


# def _upstream_nodes2(graph: DiGraph, node: str):
#     yield node
#     for n in graph.predecessors(node):
#         yield from _upstream_nodes2(graph, n)


def subcatchments_connected(inp, node: str, graph=None):
    """
    Get as list of SC, which have the same node as outlet.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        node (str): label of the node
        graph (nx.DiGraph): network

    Returns:
        list[swmm_api.input_file.sections.SubCatchment]: list of connected subcatchments
    """
    if graph is None:
        graph = inp_to_graph(inp, add_subcatchments=True)
    return [inp.SUBCATCHMENTS[k] for k in graph.predecessors(node) if k in inp.SUBCATCHMENTS]


def get_network_forks(inp):
    # pd.DataFrame.from_dict(forks, orient='index')
    g = inp_to_graph(inp)
    nodes = nodes_dict(inp)
    return {n: number_in_out(g, n) for n in nodes}


def split_network(inp, keep_node, split_at_node=None, keep_split_node=True, graph=None, init_print=True):
    """
    split model network at the ``split_at_node``-node and keep the part with the ``keep_node``-node.

    If you don't want to keep the ``split_at_node``-node toggle ``keep_split_node`` to False

    Set ``graph`` if a network-graph already exists (is faster).

    Notes:
        CONTROLS not supported

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        keep_node (str): label of a node in the part you want to keep
        split_at_node (str | list | tuple | set): if you want to split the network,
                define the label of the node (or multiple) where you want to split it.
        keep_split_node (bool): if you want to keep the ``split_at_node`` node.
        graph (networkx.DiGraph): networkx graph of the model

    Returns:
        SwmmInput: filtered inp-file data
    """
    if graph is None:
        graph = inp_to_graph(inp)

    n_nodes_before = len(graph.nodes)

    if split_at_node is not None:
        if isinstance(split_at_node, str):
            graph.remove_node(split_at_node)
        else:
            for n in split_at_node:
                graph.remove_node(n)

    if isinstance(graph, nx.DiGraph):
        graph = graph.to_undirected()
    sub = nx.subgraph(graph, nx.node_connected_component(graph, keep_node))

    # _______________
    final_nodes = list(sub.nodes)
    if split_at_node is not None and keep_split_node:
        if isinstance(split_at_node, str):
            final_nodes.append(split_at_node)
        else:
            final_nodes += list(split_at_node)
    final_nodes = set(final_nodes)

    if callable(init_print):
        init_print(f'Reduced Network from {n_nodes_before} nodes to {len(final_nodes)} nodes.')
    elif init_print:
        print(f'Reduced Network from {n_nodes_before} nodes to {len(final_nodes)} nodes.')

    # _______________
    return create_sub_inp(inp, final_nodes)


def conduit_iter_over_inp(inp, start, end):
    """
    Iterate of the inp-file data.

    Only correct when FromNode and ToNode are in the correct direction

    doesn't look backwards if split node

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        start (str): start node label
        end (str): end node label

    Yields:
        Conduit: input conduits
    """
    g = inp_to_graph(inp)

    if start and end:
        shortest_path_nodes = get_path(g, start, end)
        for n in shortest_path_nodes:
            for i in g.out_edges(n):
                if i[1] in shortest_path_nodes:
                    # TODO multiple labels
                    yield g.get_edge_data(*i)['label']
    # else:
    #     node = start
    #     while node:
    #         for l in next_links(g, node):
    #             yield l
    #
    #         # Todo: abzweigungen ...
    #         node = list(next_nodes(g, node))[0]

    # while True:
    #     found = False
    #     for i, c in inp[sec.CONDUITS].items():
    #         if c.FromNode == node:
    #             conduit = c
    #
    #             node = conduit.ToNode
    #             yield conduit
    #             found = True
    #             break
    #     if not found or (node is not None and (node == end)):
    #         break


def get_downstream_path(graph: nx.DiGraph, node: str) -> list[str]:
    node_list = []
    while graph.out_degree[node] >= 1:
        node_list.append(node)
        node = list(graph.successors(node))[0]
    node_list.append(node)
    return node_list
