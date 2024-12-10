import networkx as nx

from swmm_api.input_file.macros import inp_to_graph, create_sub_inp, plot_map, add_node_labels


def plot_sub_map(inp, node, depth=2):
    """
    Plot model as map but only around a base-node of interest.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        node (str): label of the node.
        depth (int): number of nodes around the base-node to be included in the plot.

    Returns:
        (plt.Figure, plt.Axes): figure and axis of the plot
    """
    g = inp_to_graph(inp)
    nodes = nx.single_source_shortest_path_length(g.to_undirected(), node, cutoff=depth)
    inp_sub = create_sub_inp(inp.copy(), list(nodes))
    fig, ax = plot_map(inp_sub)
    add_node_labels(ax, inp_sub)
    return fig, ax
