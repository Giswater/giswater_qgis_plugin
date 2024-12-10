import matplotlib.pyplot as plt

from .collection import nodes_dict, links_dict
from .graph import get_path_subgraph, links_connected
from ..sections import Outfall, Junction, Storage, Conduit, Weir, Orifice
from ...output_file import OBJECTS, VARIABLES


class COLS:
    INVERT_ELEV = 'SOK'
    CROWN_ELEV = 'BUK'
    GROUND_ELEV = 'GOK'  # rim elevation
    STATION = 'x'
    WATER = 'water'
    # NODE_STATION = 'node'
    LABEL = 'label'


def get_longitudinal_data(inp, start_node, end_node, out=None, zero_node=None, depth_agg_func=None):
    sub_list, sub_graph = get_path_subgraph(inp, start=start_node, end=end_node)

    if zero_node is None:
        zero_node = start_node

    keys = [COLS.STATION, COLS.INVERT_ELEV, COLS.CROWN_ELEV, COLS.GROUND_ELEV, COLS.WATER, COLS.LABEL]

    res = {k: [] for k in keys}

    def _update_res(*args):
        for k, v in zip(keys, args):
            res[k].append(v)

    # ---------------
    nodes = nodes_dict(inp)
    # ---------------
    profile_height = 0
    # ---------------
    nodes_depth = None
    if out is not None:
        if depth_agg_func is None:
            depth_agg_func = lambda s: s.mean()
        nodes_depth = depth_agg_func(out.get_part(OBJECTS.NODE, sub_list, VARIABLES.NODE.DEPTH)).to_dict()
    # ---------------
    stations_ = list(iter_over_inp_(inp, sub_list, sub_graph))
    stations = dict(stations_)
    for node, x in stations_:
        n = nodes[node]  # type: swmm_api.input_file.sections.node._Node
        sok = n.elevation
        # ---------------
        gok = sok
        if isinstance(n, Outfall):
            gok += profile_height
        elif isinstance(n, (Storage, Junction)):
            gok += n.depth_max
        # ---------------
        if nodes_depth is not None:
            water = sok + nodes_depth[node]
        else:
            water = None
        # ------------------
        prior_conduit, following_conduit = links_connected(inp, node, sub_graph)

        if prior_conduit:
            prior_conduit = prior_conduit[0]
            profile_height = inp.XSECTIONS[prior_conduit.name].height

            sok_ = sok
            if isinstance(following_conduit, Weir):
                pass
            elif isinstance(following_conduit, Orifice):
                pass
            elif isinstance(following_conduit, Conduit):
                sok_ += prior_conduit.offset_downstream

            buk = profile_height + sok_
            _update_res(x - stations[zero_node], sok_, buk, gok, water, node)

        if following_conduit:
            following_conduit = following_conduit[0]
            profile_height = inp.XSECTIONS[following_conduit.name].height

            sok_ = sok
            if isinstance(following_conduit, Weir):
                sok_ += following_conduit.height_crest
            elif isinstance(following_conduit, Orifice):
                sok_ += following_conduit.offset
            elif isinstance(following_conduit, Conduit):
                sok_ += following_conduit.offset_upstream

            buk = profile_height + sok_
            _update_res(x - stations[zero_node], sok_, buk, gok, water, node)

    return res


def get_water_level(inp, start_node, end_node, out, zero_node=None, absolute=True):
    nodes_depth = out.get_part(OBJECTS.NODE, None, VARIABLES.NODE.DEPTH).mean().to_dict()
    nodes = nodes_dict(inp)
    x_list = []
    water_level_list = []
    stations_ = list(iter_over_inp(inp, start_node, end_node))
    stations = dict(stations_)
    sok = 0
    for node, x in stations_:
        x_list.append(x - stations.get(zero_node, 0))
        if absolute:
            sok = nodes[node].elevation
        water_level_list.append(sok + nodes_depth[node])

    return {COLS.WATER: water_level_list, COLS.STATION: x_list}


def iter_over_inp_(inp, sub_list, sub_graph):
    links = links_dict(inp)

    x = 0
    for node in sub_list:
        yield node, x
        # ------------------
        out_edges = list(sub_graph.out_edges(node))
        if out_edges:
            following_link_label = sub_graph.get_edge_data(*out_edges[0])['label']
            if isinstance(following_link_label, list):
                following_link_label = following_link_label[0]
            following_link = links[following_link_label]
            if isinstance(following_link, Conduit):
                x += following_link.length


def iter_over_inp(inp, start_node, end_node):
    sub_list, sub_graph = get_path_subgraph(inp, start=start_node, end=end_node)
    return iter_over_inp_(inp, sub_list, sub_graph)


def get_node_station(inp, start_node, end_node, zero_node=None):
    stations = dict(iter_over_inp(inp, start_node, end_node))
    if zero_node:
        return set_zero_node(stations, zero_node)
    return stations


def set_zero_node(stations, zero_node):
    return {node: stations[node] - stations[zero_node] for node in stations}


def plot_longitudinal(inp, start_node, end_node, out=None, ax=None, zero_node=None, depth_agg_func=None, add_node_labels=False):
    """
    Make a longitudinal plot.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        start_node (str): Label of the start node.
        end_node (str): Label of the end node.
        out (swmm_api.SwmmOutput):
        ax (plt.Axes):
        zero_node (str): Label
        add_node_labels (bool): of the node, where the x-axis should be 0. Default: at start node.
        depth_agg_func (function): Aggregation function to get single value from series. Default: ``lambda s: s.mean()``.

    Returns:
        plt.Figure, plt.Axes: matplotlib plot
    """
    res = get_longitudinal_data(inp, start_node, end_node, out, zero_node=zero_node, depth_agg_func=depth_agg_func)

    if ax is None:
        fig, ax = plt.subplots()
    else:
        fig = ax.get_figure()

    ax.plot(res[COLS.STATION], res[COLS.INVERT_ELEV], c='black')
    ax.plot(res[COLS.STATION], res[COLS.GROUND_ELEV], c='brown', lw=0.5)
    ax.plot(res[COLS.STATION], res[COLS.CROWN_ELEV], c='black')
    bottom = ax.get_ylim()[0]

    # Ground Fill
    ax.fill_between(res[COLS.STATION], res[COLS.GROUND_ELEV], res[COLS.CROWN_ELEV], color='#C49B98', alpha=0.5)
    ax.fill_between(res[COLS.STATION], res[COLS.INVERT_ELEV], bottom, color='#C49B98', alpha=0.5)

    if any(res[COLS.WATER]):
        # Water line
        ax.plot(res[COLS.STATION], res[COLS.WATER], c='blue', lw=0.7)
        # Water fill
        ax.fill_between(res[COLS.STATION], res[COLS.WATER], res[COLS.INVERT_ELEV], color='#00D7FF', alpha=0.7)
        # Conduit Fill
        ax.fill_between(res[COLS.STATION], res[COLS.CROWN_ELEV], res[COLS.WATER], color='#B0B0B0', alpha=0.5)
        ax.set_ylim(top=max([max(res[COLS.WATER]), ax.get_ylim()[1]]))
    else:
        # Conduit Fill
        ax.fill_between(res[COLS.STATION], res[COLS.CROWN_ELEV], res[COLS.INVERT_ELEV], color='#B0B0B0', alpha=0.5)

    ax.set_xlim(res[COLS.STATION][0], res[COLS.STATION][-1])
    ax.set_ylim(bottom=bottom)

    if add_node_labels:
        _add_node_labels(ax, res)

        ax.set_xticks(res[COLS.STATION], minor=False)
        ax.set_xticklabels(res[COLS.LABEL], rotation=90, minor=False)
        ax.grid(axis='x', ls=':', color='grey', which='major')

    return fig, ax


def _add_node_labels(ax, res):
    secax = ax.secondary_xaxis('top')
    # secax.set_xlabel('angle [rad]')
    secax.set_xticks(ax.get_xticks())

    # secax.set_xticks(res[COLS.STATION], which='major')
    # secax.set_xticklabels(res[COLS.LABEL], rotation=90, minor=False)
    # secax.grid(axis='x', ls=':', color='grey', which='major')



def animated_plot_longitudinal(filename, inp, start_node, end_node, out=None, ax=None, zero_node=None, add_node_labels=False, index_to_plot=None, path_ffmpeg=None):
    """
    Create an animation of the water level in the nodes as a mp4 file.

    Args:
        filename:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        start_node (str): Label of the start node.
        end_node (str): Label of the end node.
        out (SwmmOut):
        ax (plt.Axes):
        zero_node (str): Label of the node, where the x-axis should be 0. Default: at start node.
        add_node_labels (bool): of the node, where the x-axis should be 0. Default: at start node.
    """
    import matplotlib.animation as animation
    from tqdm.auto import tqdm
    import sys

    if path_ffmpeg is None:
        # AIX 'aix'
        # Emscripten 'emscripten'
        # Linux 'linux'
        # WASI 'wasi'
        # Windows 'win32'
        # Windows/Cygwin 'cygwin'
        # macOS 'darwin'
        if 'win32' in sys.platform:
            plt.rcParams['animation.ffmpeg_path'] = r'C:\Program Files\ffmpeg\bin\ffmpeg.exe'
        else:
            plt.rcParams['animation.ffmpeg_path'] = r'ffmpeg'

    fps = 10  # frames per second
    extra_args = ['-vcodec', 'libx264', '-crf', '18']  # codec and quality

    # Writer
    FFMpegWriter = animation.writers['ffmpeg']
    # metadata = dict(title='Nice movie', artist='cle')
    writer = FFMpegWriter(fps=fps, extra_args=extra_args)

    fig, ax = plot_longitudinal(inp, start_node, end_node, ax=ax, zero_node=zero_node, add_node_labels=add_node_labels)

    fig.set_size_inches(15,6)

    line_water = None

    if index_to_plot is None:
        index_to_plot = out.index

    with writer.saving(fig, filename, 200):  # dpi > 200: maybe performance problems when playing
        for j in tqdm(index_to_plot):
            res = get_longitudinal_data(inp, start_node, end_node, out, zero_node=zero_node, depth_agg_func=lambda s: s.loc[j])

            if line_water is not None:
                # ax.lines.remove(line_water[0])
                line_water[0].remove()
                # ax.collections.remove(fill_water)
                fill_water.remove()
                # ax.collections.remove(fill_conduit)
                fill_conduit.remove()

            # Water line
            line_water = ax.plot(res[COLS.STATION], res[COLS.WATER], c='blue', lw=0.7)
            # Water fill
            fill_water = ax.fill_between(res[COLS.STATION], res[COLS.WATER], res[COLS.INVERT_ELEV], color='#00D7FF', alpha=0.7)
            # Conduit Fill
            fill_conduit = ax.fill_between(res[COLS.STATION], res[COLS.CROWN_ELEV], res[COLS.WATER], color='#B0B0B0', alpha=0.5)

            ax.set_title(f'Time = {j}')

            writer.grab_frame()


def jupyter_animated_plot_longitudinal(inp, start_node, end_node, out=None, ax=None, zero_node=None, add_node_labels=False):
    from ipywidgets import interact
    import ipywidgets as widgets
    from IPython.display import display

    fig, ax = plot_longitudinal(inp, start_node, end_node, zero_node=zero_node, add_node_labels=add_node_labels)
    # fig.set_size_inches(15,6)

    line_water = None
    fill_water = None  # Define fill_water here
    fill_conduit = None  # Define fill_conduit here

    def plot_func(time):
        global line_water, fill_water, fill_conduit  # Use global variables
        print(time, type(time))
        res = get_longitudinal_data(inp, start_node, end_node, out, zero_node=zero_node, depth_agg_func=lambda s: s.iloc[time])

        if line_water is not None:
            # ax.lines.remove(line_water[0])
            line_water[0].remove()

            # ax.collections.remove(fill_water)
            fill_water.remove()
            # ax.collections.remove(fill_conduit)
            fill_conduit.remove()

        # Water line
        line_water = ax.plot(res[COLS.STATION], res[COLS.WATER], c='blue', lw=0.7)
        # Water fill
        fill_water = ax.fill_between(res[COLS.STATION], res[COLS.WATER], res[COLS.INVERT_ELEV], color='#00D7FF', alpha=0.7)
        # Conduit Fill
        fill_conduit = ax.fill_between(res[COLS.STATION], res[COLS.CROWN_ELEV], res[COLS.WATER], color='#B0B0B0', alpha=0.5)

        ax.set_title(f'Time = {out.index[time]}')
        fig.canvas.draw_idle()
        return fig

    # Creating IntSlider widget
    play = widgets.Play(
        value=0,
        min=0,
        max=200,  # out.index.size,
        step=10,
        interval=10,
        description='Play',
        disabled=False
    )

    slider = widgets.IntSlider()
    widgets.jslink((play, 'value'), (slider, 'value'))

    interact(plot_func, time=slider)

    # Display the slider
    # display(widgets)

    # Attaching the function to the slider
    # play.observe(plot_func, names='value')

    widgets.HBox([play, slider])
