import copy

from matplotlib import pyplot as plt, patches, cm
from matplotlib.colors import Normalize, BoundaryNorm, LinearSegmentedColormap
from matplotlib.lines import Line2D

from swmm_api import SwmmInput
from swmm_api.input_file import SEC
from swmm_api.input_file.macros import complete_vertices
from swmm_api.input_file.section_labels import (MAP, VERTICES, POLYGONS, COORDINATES, SUBCATCHMENTS, JUNCTIONS, STORAGE,
                                                OUTFALLS, )
from swmm_api.input_file.sections import Polygon, SubCatchment


def get_matplotlib_colormap(cmap, set_under='lightgray', set_bad='k'):
    cmap = copy.copy(plt.cm.get_cmap(cmap))

    if set_under:
        cmap.set_under(set_under)
    if set_bad:
        cmap.set_bad('k')
    return cmap


def get_color_mapper(cmap, vmin, vmax):
    norm = Normalize(vmin=vmin, vmax=vmax)
    return lambda x: cmap(norm(x))


def custom_color_mapper(cmap, vmin=None, vmax=None, set_under='lightgray', set_bad='k'):
    cmap = get_matplotlib_colormap(cmap, set_under, set_bad)
    return get_color_mapper(cmap, vmin=vmin, vmax=vmax)


def get_discrete_colormap(cmap):
    # cmap = copy.copy(plt.cm.get_cmap(cmap))  # define the colormap
    # extract all colors from the .jet map
    cmaplist = [cmap(i) for i in range(cmap.N)]
    # force the first color entry to be grey
    cmaplist[0] = (.85, .85, .85, 1.0)

    # create the new map
    cmap = LinearSegmentedColormap.from_list('Custom cmap', cmaplist, cmap.N)

    return cmap

def set_inp_dimensions(ax: plt.Axes, inp: SwmmInput):
    map_dim = inp[MAP]['DIMENSIONS']
    x_min, x_max = map_dim['lower-left X'], map_dim['upper-right X']
    delta_x = x_max - x_min
    y_min, y_max = map_dim['lower-left Y'], map_dim['upper-right Y']
    delta_y = y_max - y_min
    ax.set_xlim(x_min, x_max)
    ax.set_ylim(y_min, y_max)


def init_empty_map_plot() -> (plt.Figure, plt.Axes):
    fig, ax = plt.subplots(layout='constrained')  # type: plt.Figure, plt.Axes
    ax.set_axis_off()
    ax.set_aspect('equal')
    return fig, ax


def get_auto_size_function(value_min, value_max, size_min, size_max):
    diff_values = value_max - value_min
    diff_size = size_max - size_min
    def new_size(value):
        if (diff_values == 0) or (diff_size == 0):
            return size_min
        return (value - value_min) / diff_values * diff_size + size_min
    return new_size


def add_link_map(ax: plt.Axes, inp: SwmmInput,
                 color_default='y',
                 line_style_default='-',
                 line_width_default=1,

                 line_width_max=10,

                 make_width_proportional=False,
                 values_dict=None,

                 cmap=None,
                 cmap_label=None,
                 make_cmap_bar=True,
                 value_min=0.001,
                 value_max=None
                 ):
    complete_vertices(inp)

    if VERTICES in inp:
        if values_dict and make_width_proportional:
            values = values_dict.values()

            if value_min is None:
                value_min = min(values)

            if value_max is None:
                value_max = max(values)

            new_width = get_auto_size_function(value_min, value_max, line_width_default, line_width_max)
        else:
            new_width = lambda _: line_width_default
            if values_dict is None:
                values_dict = {}

        if cmap:
            cmap_ = get_matplotlib_colormap(cmap, set_under='lightgray', set_bad='k')
            norm = Normalize(vmin=value_min, vmax=value_max)
            cmapper = lambda x: cmap_(norm(x))

        for link, vertices in inp[VERTICES].items():
            x, y = zip(*vertices.vertices)
            value = values_dict.get(link, 0)

            ax.plot(x, y,
                    color=color_default if not cmap else cmapper(value),
                    linestyle=line_style_default,
                    linewidth=new_width(value),
                    solid_capstyle='round', solid_joinstyle='round')

        if make_cmap_bar and cmap:
            fig = ax.get_figure()
            fig.colorbar(cm.ScalarMappable(norm=norm, cmap=cmap), ax=ax,
                         location='bottom', label=cmap_label, pad=0, shrink=0.3)



def add_subcatchment_map(ax: plt.Axes, inp: SwmmInput,
                         add_center_point=True, center_point_kwargs=None,
                         add_connector_line=True, connector_line_kwargs=None):
    if POLYGONS in inp:
        if COORDINATES in inp:
            points = dict(inp[COORDINATES])
        else:
            points = {}
        from shapely import geometry as shp
        points.update({poly.subcatchment: shp.Polygon(poly.polygon).centroid for poly in inp[POLYGONS].values()})

        for poly in inp[POLYGONS].values():  # type: Polygon

            # ----------------
            # sub-catchment polygon
            ax.add_patch(patches.Polygon(poly.polygon, closed=True, fill=False, hatch='/'))

            # ----------------
            # center point of sub-catchment
            if add_center_point:

                if center_point_kwargs is None:
                    center_point_kwargs = {}
                center_point_kwargs.update(dict(marker='s', c='k'))

                center = points[poly.subcatchment]
                ax.scatter(x=center.x, y=center.y, **center_point_kwargs, zorder=999)

            # ----------------
            # center connector to sub-catchment
            if add_connector_line:

                if connector_line_kwargs is None:
                    connector_line_kwargs = {}
                connector_line_kwargs.update(dict(linestyle='--', color='r'))

                subcatch = inp[SUBCATCHMENTS][poly.subcatchment]  # type: SubCatchment
                outlet_point = points[subcatch.outlet]
                center = points[poly.subcatchment]
                ax.plot([center.x, outlet_point.x], [center.y, outlet_point.y], **connector_line_kwargs)


def add_node_map(ax: plt.Axes, inp: SwmmInput,
                 size_default=20,
                 size_max=40,
                 make_size_proportional=False,
                 values_dict=None,

                 cmap=None,
                 cmap_label=None,
                 make_cmap_bar=True,
                 value_min=0.001,
                 value_max=None,
                 discrete=False,
                 ):
    """
    Only one marker per scatter possible.
    """
    if COORDINATES in inp:
        coords = inp[COORDINATES].frame
        node_style = {
            JUNCTIONS: {'marker': 'o', 'color': 'b'},
            STORAGE: {'marker': 's', 'color': 'g'},
            OUTFALLS: {'marker': '^', 'color': 'r'},
        }

        # -------------
        if values_dict and make_size_proportional:
            values = values_dict.values()

            if value_min is None:
                value_min = min(values)

            if value_max is None:
                value_max = max(values)

            new_size = get_auto_size_function(value_min, value_max, size_default, size_max)
        else:
            new_size = lambda _: size_default

        # -------------
        for section in [JUNCTIONS, STORAGE, OUTFALLS]:
            if section in inp:
                is_in_sec = coords.index.isin(inp[section].keys())

                if values_dict:
                    node_values = [values_dict.get(n, 0) for n in coords[is_in_sec].index]

                if make_size_proportional:
                    kwargs = dict(
                        s=[new_size(i) for i in node_values],
                    )
                else:
                    kwargs = dict(
                        s=size_default,
                    )

                if cmap is not None:
                    kwargs.update(
                        dict(
                            c=node_values,
                            cmap=cmap,
                        )
                    )

                    if discrete:
                        # define the bins and normalize
                        bounds = list(range(0, value_max + 2, 1))
                        norm = BoundaryNorm(bounds, cmap.N)

                        kwargs.update(
                            dict(
                                norm=norm,
                            )
                        )
                    else:
                        kwargs.update(
                            dict(
                                vmin=value_min,
                                vmax=value_max,
                            )
                        )

                else:
                    kwargs.update(
                        dict(
                            c=node_style[section]['color'],
                        )
                    )

                ax.scatter(x=coords[is_in_sec].x, y=coords[is_in_sec].y,
                           marker=node_style[section]['marker'],
                           **kwargs,
                           linewidths=0.5, edgecolors='k', zorder=9999)

    # ---------------------
    if make_cmap_bar and cmap:
        fig = ax.get_figure()
        cb = fig.colorbar(ax.collections[0], ax=ax, location='bottom', label=cmap_label, pad=0, shrink=0.3,
                          # ticks=range(0, 13, 2)
                          **(dict(spacing='proportional', ticks=[b+.5 for b in bounds], boundaries=bounds, format='%1i',
                          drawedges=True) if discrete else dict())
                          )
        if discrete:
            cb.ax.tick_params(length=0)


def add_node_labels(ax: plt.Axes, inp: SwmmInput):
    for name, node in inp.COORDINATES.items():
        ax.text(node.x, node.y, name, horizontalalignment='center', verticalalignment='baseline')


def plot_map(inp, sc_connector=True, sc_center=True,
             custom_node_size=None,
             color_link_default='y',
             line_style_link_default='-',
             node_size_default=30,
             node_size_max=60,
             node_cmap=None,
             cmap_label=None,
             value_node_min=0.001,
             value_node_max=None,
             make_cmap_bar=True):  # TODO
    """
    Get the map-plot of the system.

    Args:
        inp ():

    Returns:
        (plt.Figure, plt.Axes): figure and axis of the plot
    """
    fig, ax = init_empty_map_plot()

    # ---------------------
    add_link_map(ax, inp)
    # ---------------------
    add_subcatchment_map(ax, inp)
    # ---------------------
    add_node_map(ax, inp)

    return fig, ax


def add_custom_legend(ax, lines_dict, **kwargs):
    """
    lines_dict:
    { label in legend: {line_dict ie: color, marker, linewidth, linestyle, ...) }
    kwargs: for legend
    """
    lines = []
    labels = []
    for label, line in lines_dict.items():
        labels.append(label)
        if isinstance(line, Line2D):
            lines.append(line)
        else:
            lines.append(Line2D([0], [0], **line))
    return ax.legend(lines, labels, **kwargs)


def add_backdrop(ax, inp):
    """
    Add the backdrop image to the plot

    Args:
        ax (plt.Axes):
        inp (SwmmInput):
    """
    if SEC.BACKDROP in inp:
        from swmm_api.input_file.sections import BackdropSection
        k = BackdropSection.KEYS
        fn = inp.BACKDROP[k.FILE]
        x0, y0, x1, y1 = inp.BACKDROP[k.DIMENSIONS]
        im = plt.imread(fn)
        ax.imshow(im, extent=[x0, x1, y0, y1])
