import math
from itertools import cycle

import numpy as np

from matplotlib import pyplot as plt, patches, cm
from matplotlib.colors import Normalize
import matplotlib.patheffects as pe

from .. import SEC, SwmmInput
from ..section_labels import *
from ..sections import Polygon, SubCatchment, BackdropSection
from .geo import complete_vertices
from .macros import links_dict
from ._plotting_helpers import _custom_color_mapper, _get_auto_size_function, _darken_color, _get_mid_point_angle, _add_custom_legend


def set_inp_dimensions(ax: plt.Axes, inp: SwmmInput):
    """
    Set same boundary as in GUI.

    Based in MAP section in inp file.

    Works inplace.

    Args:
        ax ():
        inp ():
    """
    if MAP not in inp:
        return
    map_dim = inp[MAP]['DIMENSIONS']
    x_min, x_max = map_dim['lower-left X'], map_dim['upper-right X']
    delta_x = x_max - x_min
    y_min, y_max = map_dim['lower-left Y'], map_dim['upper-right Y']
    delta_y = y_max - y_min
    ax.set_xlim(x_min, x_max)
    ax.set_ylim(y_min, y_max)


def init_empty_map_plot() -> (plt.Figure, plt.Axes):
    """
    Initialize empty map plot.

    Returns:
        (plt.Figure, plt.Axes): figure and axes of the map plot.
    """
    fig, ax = plt.subplots(layout='constrained')  # type: plt.Figure, plt.Axes
    ax.set_axis_off()
    ax.set_aspect('equal')
    return fig, ax


def add_link_map(ax: plt.Axes, inp: SwmmInput,
                 line_width_default=1,
                 line_width_max=5,
                 make_width_proportional=False,

                 values_dict=None,

                 cmap=None,

                 value_min=None,
                 value_max=None,

                 discrete=False,

                 colorbar_kwargs=None,

                 add_arrows=False,
                 add_border_line=True,

                 **kwargs):
    """
    Plots the links to a map plot.

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
        line_width_default (float | int | optional): default is 1.
        line_width_max (float | int | optional): default is 5.
        make_width_proportional (bool): default is False.
        values_dict (dict[str, any]):
        cmap (str | optional):
        value_min (int | float | optional):
        value_max (int | float | optional):
        discrete (bool): default is False. Use values as discrete values.
        colorbar_kwargs (dict): kwargs to pass for the color bar.
        add_arrows (bool): add arrows to the line. default is False.
        add_border_line(bool): add a black outline around the line. default is True.
        **kwargs: other keyword arguments are passed to `ax.plot`.
    """
    complete_vertices(inp)

    if VERTICES not in inp:
        # nothing to plot
        return

    # ---
    # style defaults
    link_style = {
        CONDUITS: {'color': 'yellow'},
        WEIRS: {'color': 'cyan'},
        ORIFICES: {'color': 'lightpink'},
        PUMPS: {'color': 'sienna'},
        OUTLETS: {'color': 'violet'},
    }
    for k, v in link_style.items():
        v['border_color'] = _darken_color(v['color'])

    # ---
    kwargs.setdefault('solid_capstyle', 'round')
    kwargs.setdefault('solid_joinstyle', 'round')

    di_links = links_dict(inp)

    if values_dict:
        if discrete:
            values = values_dict.values()
            values_convert = {v: i for i, v in enumerate(sorted(set(values)))}
            values_dict = {k: values_convert[v] for k, v in values_dict.items()}

        values = values_dict.values()

        if value_min is None:
            value_min = min(values)

        if value_max is None:
            value_max = max(values)

        new_width = _get_auto_size_function(value_min, value_max, line_width_default, line_width_max)

        if cmap:
            get_color_from_value = _custom_color_mapper(cmap, vmin=value_min, vmax=value_max)

    for link, vertices in inp[VERTICES].items():
        x, y = zip(*vertices.vertices)
        section_label = di_links[link]._section_label

        style = {}

        if values_dict and make_width_proportional:
            style['linewidth'] = new_width(values_dict.get(link, np.nan))
        else:
            style['linewidth'] = line_width_default

        if values_dict and cmap:
            style['color'] = get_color_from_value(values_dict.get(link, np.nan))
            line_border_color = _darken_color(style['color'])
        else:
            style['color'] = link_style[section_label]['color']
            line_border_color = link_style[section_label]['border_color']

        ax.plot(x, y,
                **{**style, **kwargs},
                path_effects=[pe.Stroke(linewidth=style['linewidth'] + .7, foreground=line_border_color), pe.Normal()] if add_border_line else None)

        if add_arrows:
            x_mid, y_mid, angle = _get_mid_point_angle(x, y)
            ax.plot(x_mid, y_mid, markeredgewidth=0.35, markersize=style['linewidth'] * 4,
                    marker=(3, 0, angle - 90), c=style['color'], markeredgecolor=line_border_color)

    if colorbar_kwargs is not None:
        if discrete:
            get_color_from_value = _custom_color_mapper(cmap, vmin=value_min, vmax=value_max)
            if 'label' in colorbar_kwargs:
                colorbar_kwargs['title'] = colorbar_kwargs.pop('label')

            if ax.legend_ is not None:
                ax.add_artist(ax.legend_)

            _add_custom_legend(ax, {label: {'color': get_color_from_value(value), 'lw': 1} for label, value in values_convert.items()},
                               **colorbar_kwargs)

        else:
            if 'title' in colorbar_kwargs:
                colorbar_kwargs['label'] = colorbar_kwargs.pop('title')

            colorbar_kwargs.setdefault('location', 'bottom')
            colorbar_kwargs.setdefault('pad', 0)
            colorbar_kwargs.setdefault('shrink', 0.3)
            ax.get_figure().colorbar(cm.ScalarMappable(Normalize(vmin=value_min, vmax=value_max), cmap), ax=ax, **colorbar_kwargs)


def add_subcatchment_map(ax: plt.Axes, inp: SwmmInput,
                         add_center_point=True,
                         center_point_kwargs=None,
                         use_pole_of_inaccessibility_as_center_point=False,

                         add_connector_line=True,
                         connector_line_kwargs=None,
                         add_connector_arrows=False,

                         values_dict=None,

                         cmap='cividis',
                         colorbar_kwargs=None,

                         value_min=None,
                         value_max=None,

                         discrete=False,

                         add_random_hatch=False,
                         **kwargs):
    """
    Plots the subcatchments to a map plot.

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
        add_center_point ():
        center_point_kwargs ():
        use_pole_of_inaccessibility_as_center_point ():
        add_connector_line ():
        connector_line_kwargs ():
        add_connector_arrows ():
        values_dict ():
        cmap ():
        colorbar_kwargs ():
        value_min ():
        value_max ():
        discrete ():
        add_random_hatch ():
        **kwargs ():
    """
    if POLYGONS not in inp:
        return

    if COORDINATES in inp:
        points = dict(inp[COORDINATES])
    else:
        points = {}

    # all point from nodes and center point of polygons for connector lines
    if use_pole_of_inaccessibility_as_center_point:
        from shapely.algorithms.polylabel import polylabel
        points.update({poly.subcatchment: polylabel(poly.geo) for poly in inp[POLYGONS].values()})
    else:
        points.update({poly.subcatchment: poly.geo.centroid for poly in inp[POLYGONS].values()})

    # ---
    if add_random_hatch:
        hatches = cycle(['/', '\\', '|', '-', '+', 'x', 'o', 'O', '.', '*'])

        reset_hatch = 'hatch' not in kwargs

        import matplotlib as mpl
        mpl.rcParams['hatch.linewidth'] = 0.3

    # ---
    if values_dict:
        values = values_dict.values()

        if discrete:
            values_convert = {v: i for i, v in enumerate(sorted(set(values)))}
            values_dict = {k: values_convert[v] for k, v in values_dict.items()}
            values = values_dict.values()

        if value_min is None:
            value_min = min(values)

        if value_max is None:
            value_max = max(values)

        get_color_from_value = _custom_color_mapper(cmap, vmin=value_min, vmax=value_max)

    for label, poly in inp[POLYGONS].items():  # type: Polygon

        # ----------------
        # sub-catchment polygon
        kwargs.setdefault('fill', True)
        kwargs.setdefault('linewidth', 0.5)
        kwargs.setdefault('alpha', 0.5)

        # ---
        if add_random_hatch:
            kwargs.setdefault('hatch', next(hatches) * 2)

        # ---
        if values_dict:
            kwargs['facecolor'] = get_color_from_value(values_dict.get(label, np.nan))
            kwargs['edgecolor'] = _darken_color(kwargs['facecolor'])
        else:
            kwargs.setdefault('facecolor', 'lightgray')
            kwargs.setdefault('edgecolor', 'darkgrey')

        # ---
        rasterize = False
        if 'rasterize' in kwargs:
            rasterize = kwargs.pop('rasterize')
        p = patches.Polygon(poly.polygon, closed=True, **kwargs)
        p.set_rasterized(rasterize)

        ax.add_patch(patches.Polygon(poly.polygon, closed=True, **kwargs))

        # ---
        if add_random_hatch and reset_hatch:
            del kwargs['hatch']

        # ----------------
        # center point of sub-catchment
        if add_center_point:

            if center_point_kwargs is None:
                center_point_kwargs = {}

            center_point_kwargs.setdefault('marker', 's')
            center_point_kwargs.setdefault('markersize', 5)
            center_point_kwargs.setdefault('markeredgewidth', 0.5)
            center_point_kwargs.setdefault('fillstyle', 'none')
            center_point_kwargs.setdefault('alpha', 0.5)
            center_point_kwargs.setdefault('color', 'black')

            center = points[poly.subcatchment]
            ax.plot(center.x, center.y, lw=0, **center_point_kwargs)

        # ----------------
        # center connector to sub-catchment
        if add_connector_line:

            if connector_line_kwargs is None:
                connector_line_kwargs = {}
            connector_line_kwargs.setdefault('linestyle', '--')
            connector_line_kwargs.setdefault('color', 'black')
            connector_line_kwargs.setdefault('alpha', 0.5)
            connector_line_kwargs.setdefault('lw', 0.5)

            subcatch = inp[SUBCATCHMENTS][poly.subcatchment]  # type: SubCatchment
            outlet_point = points[subcatch.outlet]
            center = points[poly.subcatchment]
            ax.plot([center.x, outlet_point.x], [center.y, outlet_point.y], **connector_line_kwargs)

            if add_connector_arrows:
                x_mid, y_mid, angle = _get_mid_point_angle([center.x, outlet_point.x], [center.y, outlet_point.y])
                ax.plot(x_mid, y_mid, markeredgewidth=0.4, markersize=4,
                        marker=(3, 0, angle - 90), **connector_line_kwargs)

    if colorbar_kwargs is not None:
        if discrete:
            if 'label' in colorbar_kwargs:
                colorbar_kwargs['title'] = colorbar_kwargs.pop('label')

            if ax.legend_ is not None:
                ax.add_artist(ax.legend_)
            _add_custom_legend(ax, {label: {'color': get_color_from_value(value), 'marker': 's', 'lw': 0} for label, value in values_convert.items()},
                               **colorbar_kwargs)

        else:
            if 'title' in colorbar_kwargs:
                colorbar_kwargs['label'] = colorbar_kwargs.pop('title')

            colorbar_kwargs.setdefault('location', 'bottom')
            colorbar_kwargs.setdefault('pad', 0)
            colorbar_kwargs.setdefault('shrink', 0.3)
            ax.get_figure().colorbar(cm.ScalarMappable(Normalize(vmin=value_min, vmax=value_max), cmap), ax=ax, **colorbar_kwargs)


def add_node_map(ax: plt.Axes, inp: SwmmInput,

                 size_default=20,  # = size_min
                 size_max=40,
                 make_size_proportional=False,

                 values_dict=None,

                 cmap=None,  # if set - make color based on values_dict

                 value_min=None,
                 value_max=None,

                 discrete=False,

                 colorbar_kwargs=None,
                 add_kind_legend=True,
                 **kwargs):
    """
    Plots the nodes to a map plot.

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
        size_default ():
        size_max ():
        make_size_proportional ():
        values_dict ():
        cmap ():
        value_min ():
        value_max ():
        discrete ():
        colorbar_kwargs ():
        add_kind_legend ():
        **kwargs:
    """
    if COORDINATES not in inp:
        # nothing to plot
        return

    coords = inp[COORDINATES].frame

    # ---
    # style defaults
    node_style = {
        JUNCTIONS: {'marker': 'o', 'c': 'blue'},
        STORAGE: {'marker': 's', 'c': 'lime'},
        OUTFALLS: {'marker': '^', 'c': 'red'},
    }
    for k, v in node_style.items():
        v['edgecolor'] = _darken_color(v['c'])

    # ---
    if values_dict:
        if discrete:
            values = values_dict.values()
            values_convert = {v: i for i, v in enumerate(sorted(set(values)))}
            values_dict = {k: values_convert[v] for k, v in values_dict.items()}

        values = values_dict.values()

        if value_min is None:
            value_min = min(values)

        if value_max is None:
            value_max = max(values)

        new_size = _get_auto_size_function(value_min, value_max, size_default, size_max)

    # -------------
    kwargs.setdefault('s', size_default)
    kwargs.setdefault('linewidths', 0.5)
    kwargs.setdefault('zorder', 2)

    # -------------
    for section in [JUNCTIONS, STORAGE, OUTFALLS]:
        if section not in inp:
            continue

        coords_in_sec = coords[coords.index.isin(inp[section].keys())]

        if values_dict:
            node_values = [values_dict.get(n, np.nan) for n in coords_in_sec.index]

            # ---
            if make_size_proportional:
                kwargs['s'] = [new_size(i) for i in node_values]

            # ---
            if cmap is not None:
                kwargs.update(
                    dict(
                        c=node_values,
                        cmap=cmap,
                        vmin=value_min,
                        vmax=value_max,
                        edgecolor='black',
                    )
                )

        ax.scatter(x=coords_in_sec.x, y=coords_in_sec.y, **{**node_style[section], **kwargs}, label=section if add_kind_legend else None)

    # ---------------------
    if colorbar_kwargs is not None:
        if discrete:
            get_color_from_value = _custom_color_mapper(cmap, vmin=value_min, vmax=value_max)
            if 'label' in colorbar_kwargs:
                colorbar_kwargs['title'] = colorbar_kwargs.pop('label')

            if ax.legend_ is not None:
                ax.add_artist(ax.legend_)

            _add_custom_legend(ax, {label: {'color': get_color_from_value(value), 'marker': 's', 'lw': 0} for label, value in values_convert.items()},
                               **colorbar_kwargs)

        else:
            if 'title' in colorbar_kwargs:
                colorbar_kwargs['label'] = colorbar_kwargs.pop('title')

            colorbar_kwargs.setdefault('location', 'bottom')
            colorbar_kwargs.setdefault('pad', 0)
            colorbar_kwargs.setdefault('shrink', 0.3)
            ax.get_figure().colorbar(ax.collections[0], ax=ax, **colorbar_kwargs)
    else:
        if add_kind_legend:
            if ax.legend_ is not None:
                ax.add_artist(ax.legend_)
            ax.legend()


def add_node_labels(ax: plt.Axes, inp: SwmmInput, x_offset=0, y_offset=0, **kwargs):
    """
    Add the labels of the nodes to the map plot as text.

    Works inplace.

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
        x_offset (int | float): moves text in x direction. (in map units)
        y_offset (int | float): moves text in y direction. (in map units)
        **kwargs: kwargs for plt.Axes.text()
    """
    if COORDINATES not in inp:
        return

    if ('horizontalalignment' not in kwargs) and ('ha' not in kwargs):
        kwargs['ha'] = 'center'

    if ('verticalalignment' not in kwargs) and ('va' not in kwargs):
        kwargs['va'] = 'baseline'

    for name, node in inp.COORDINATES.items():
        ax.text(node.x + x_offset, node.y + y_offset, name, **kwargs)


def add_subcatchments_labels(ax: plt.Axes, inp: SwmmInput, x_offset=0, y_offset=0, **kwargs):
    """
    Add the labels of the subcatchments at the centroid of the polygon to the map plot as text.

    Works inplace.

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
        x_offset (int | float): moves text in x direction. (in map units)
        y_offset (int | float): moves text in y direction. (in map units)
        **kwargs: kwargs for plt.Axes.text()
    """
    if POLYGONS not in inp:
        return

    if ('horizontalalignment' not in kwargs) and ('ha' not in kwargs):
        kwargs['ha'] = 'center'

    if ('verticalalignment' not in kwargs) and ('va' not in kwargs):
        kwargs['va'] = 'baseline'

    for name, poly in inp.POLYGONS.items():
        node = poly.geo.centroid
        ax.text(node.x + x_offset, node.y + y_offset, name, **kwargs)


def add_link_labels(ax: plt.Axes, inp: SwmmInput, x_offset=0, y_offset=0, **kwargs):
    """
    Add the labels of the links to the map plot as text.

    Works inplace.

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
        x_offset (int | float): moves text in x direction. (in map units)
        y_offset (int | float): moves text in y direction. (in map units)
        **kwargs: kwargs for plt.Axes.text()
    """
    complete_vertices(inp)

    if VERTICES not in inp:
        return

    if ('horizontalalignment' not in kwargs) and ('ha' not in kwargs):
        kwargs['ha'] = 'center'

    if ('verticalalignment' not in kwargs) and ('va' not in kwargs):
        kwargs['va'] = 'baseline'

    if 'rotation_mode' not in kwargs:
        kwargs['rotation_mode'] = 'anchor'

    for name, vertices in inp.VERTICES.items():
        x, y = zip(*vertices.vertices)
        x_mid, y_mid, angle = _get_mid_point_angle(x, y)
        if 100 < angle % 360 < 290:
            angle = angle % 360 + 180
        alpha = math.radians(angle)
        x_offset_ = math.cos(alpha) * x_offset - math.sin(alpha) * y_offset
        y_offset_ = math.sin(alpha) * x_offset + math.cos(alpha) * y_offset
        ax.text(x_mid + x_offset_, y_mid + y_offset_, name, rotation=angle, **kwargs)


def add_labels(ax: plt.Axes, inp: SwmmInput, x_offset=0, y_offset=0, **kwargs):
    """
    Add the GUI labels to the map plot as text.

    Works inplace.

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
        x_offset (int | float): moves text in x direction. (in map units)
        y_offset (int | float): moves text in y direction. (in map units)
        **kwargs: kwargs for plt.Axes.text()
    """
    if LABELS not in inp:
        return

    if ('horizontalalignment' not in kwargs) and ('ha' not in kwargs):
        kwargs['ha'] = 'center'

    if ('verticalalignment' not in kwargs) and ('va' not in kwargs):
        kwargs['va'] = 'baseline'

    for name, label_obj in inp.LABELS.items():
        ax.text(label_obj.x + x_offset, label_obj.y + y_offset, label_obj.label, **kwargs)


def add_backdrop(ax, inp):
    """
    Add the backdrop image to the plot

    Args:
        ax (plt.Axes): Axes of the map plot.
        inp (swmm_api.SwmmInput): SWMM input-file data.
    """
    if SEC.BACKDROP in inp:
        k = BackdropSection.KEYS
        fn = inp.BACKDROP[k.FILE]
        x0, y0, x1, y1 = inp.BACKDROP[k.DIMENSIONS]
        im = plt.imread(fn)
        ax.imshow(im, extent=[x0, x1, y0, y1])


def plot_map(inp):
    """
    Get the map-plot of the system.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        (plt.Figure, plt.Axes): figure and axis of the plot
    """
    fig, ax = init_empty_map_plot()
    add_link_map(ax, inp)
    add_subcatchment_map(ax, inp)
    add_node_map(ax, inp)
    add_node_labels(ax, inp)
    return fig, ax


def plot_map2(inp):
    """
    Get the map-plot of the system.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        (plt.Figure, plt.Axes): figure and axis of the plot
    """
    map = (PlottingMap(inp).
           add_link_map().
           add_subcatchment_map().
           add_node_map().
           add_node_labels())

    return map.fig, map.ax


class PlottingMap:
    """Class for map plotting macros."""

    def __init__(self, inp: SwmmInput, ax: plt.Axes = None):
        self.inp: SwmmInput = inp

        if ax is None:
            self.fig, self.ax = init_empty_map_plot()
        else:
            self.ax: plt.Axes = ax
            self.fig: plt.Figure = ax.get_figure()

    def add_link_map(self, line_width_default=1,
                     line_width_max=5,
                     make_width_proportional=False,
                     values_dict=None,
                     cmap=None,
                     value_min=None,
                     value_max=None,
                     discrete=False,
                     colorbar_kwargs=None,
                     add_arrows=False,
                     add_border_line=True,
                     **kwargs):
        """
        Plots the links to a map plot.

        Args:
            line_width_default (float | int | optional): default is 1.
            line_width_max (float | int | optional): default is 5.
            make_width_proportional (bool): default is False.
            values_dict (dict[str, any]):
            cmap (str | optional):
            value_min (int | float | optional):
            value_max (int | float | optional):
            discrete (bool): default is False. Use values as discrete values.
            colorbar_kwargs (dict): kwargs to pass for the color bar.
            add_arrows (bool): add arrows to the line. default is False.
            add_border_line(bool): add a black outline around the line. default is True.
            **kwargs: other keyword arguments are passed to `ax.plot`.

        Returns:
            PlottingMap: Object for map plotting macros.
        """
        add_link_map(self.ax, self.inp,
                     line_width_default=line_width_default,
                     line_width_max=line_width_max,
                     make_width_proportional=make_width_proportional,
                     values_dict=values_dict,
                     cmap=cmap,
                     value_min=value_min,
                     value_max=value_max,
                     discrete=discrete,
                     colorbar_kwargs=colorbar_kwargs,
                     add_arrows=add_arrows,
                     add_border_line=add_border_line,
                     **kwargs
                     )
        return self

    def add_subcatchment_map(self,
                             add_center_point=True,
                             center_point_kwargs=None,
                             use_pole_of_inaccessibility_as_center_point=False,

                             add_connector_line=True,
                             connector_line_kwargs=None,
                             add_connector_arrows=False,

                             values_dict=None,

                             cmap='cividis',
                             colorbar_kwargs=None,

                             value_min=None,
                             value_max=None,

                             discrete=False,

                             add_random_hatch=False,
                             **kwargs):
        """
        Plots the subcatchments to a map plot.

        Args:
            ax (plt.Axes): Axes of the map plot.
            inp (swmm_api.SwmmInput): SWMM input-file data.
            add_center_point ():
            center_point_kwargs ():
            use_pole_of_inaccessibility_as_center_point ():
            add_connector_line ():
            connector_line_kwargs ():
            add_connector_arrows ():
            values_dict ():
            cmap ():
            colorbar_kwargs ():
            value_min ():
            value_max ():
            discrete ():
            add_random_hatch ():
            **kwargs ():
        """
        add_subcatchment_map(self.ax, self.inp,
                             add_center_point=add_center_point,
                             center_point_kwargs=center_point_kwargs,
                             use_pole_of_inaccessibility_as_center_point=use_pole_of_inaccessibility_as_center_point,

                             add_connector_line=add_connector_line,
                             connector_line_kwargs=connector_line_kwargs,
                             add_connector_arrows=add_connector_arrows,

                             values_dict=values_dict,

                             cmap=cmap,
                             colorbar_kwargs=colorbar_kwargs,

                             value_min=value_min,
                             value_max=value_max,

                             discrete=discrete,

                             add_random_hatch=add_random_hatch,
                             **kwargs)
        return self

    def add_node_map(self,
                     size_default=20,  # = size_min
                     size_max=40,
                     make_size_proportional=False,

                     values_dict=None,

                     cmap=None,  # if set - make color based on values_dict

                     value_min=None,
                     value_max=None,

                     discrete=False,

                     colorbar_kwargs=None,
                     add_kind_legend=True,
                     **kwargs):
        """
        Plots the nodes to a map plot.

        Args:
            size_default ():
            size_max ():
            make_size_proportional ():
            values_dict ():
            cmap ():
            value_min ():
            value_max ():
            discrete ():
            colorbar_kwargs ():
            add_kind_legend ():
            **kwargs:
        """
        add_node_map(self.ax, self.inp,
                     size_default=size_default,
                     size_max=size_max,
                     make_size_proportional=make_size_proportional,
                     values_dict=values_dict,
                     cmap=cmap,
                     value_min=value_min,
                     value_max=value_max,
                     discrete=discrete,
                     colorbar_kwargs=colorbar_kwargs,
                     add_kind_legend=add_kind_legend,
                     **kwargs
                     )
        return self

    def add_node_labels(self, x_offset=0, y_offset=0, **kwargs):
        """
        Add the labels of the nodes to the map plot as text.

        Works inplace.

        Args:
            x_offset (int | float): moves text in x direction. (in map units)
            y_offset (int | float): moves text in y direction. (in map units)
            **kwargs: kwargs for plt.Axes.text()
        """
        add_node_labels(self.ax, self.inp, x_offset=x_offset, y_offset=y_offset, **kwargs)
        return self

    def add_subcatchments_labels(self, x_offset=0, y_offset=0, **kwargs):
        """
        Add the labels of the subcatchments at the centroid of the polygon to the map plot as text.

        Works inplace.

        Args:
            x_offset (int | float): moves text in x direction. (in map units)
            y_offset (int | float): moves text in y direction. (in map units)
            **kwargs: kwargs for plt.Axes.text()
        """
        add_subcatchments_labels(self.ax, self.inp, x_offset=x_offset, y_offset=y_offset, **kwargs)
        return self

    def add_link_labels(self, x_offset=0, y_offset=0, **kwargs):
        """
        Add the labels of the links to the map plot as text.

        Works inplace.

        Args:
            x_offset (int | float): moves text in x direction. (in map units)
            y_offset (int | float): moves text in y direction. (in map units)
            **kwargs: kwargs for plt.Axes.text()
        """
        add_link_labels(self.ax, self.inp, x_offset=x_offset, y_offset=y_offset, **kwargs)
        return self

    def add_labels(self, x_offset=0, y_offset=0, **kwargs):
        """
        Add the GUI labels to the map plot as text.

        Works inplace.

        Args:
            x_offset (int | float): moves text in x direction. (in map units)
            y_offset (int | float): moves text in y direction. (in map units)
            **kwargs: kwargs for plt.Axes.text()
        """
        add_labels(self.ax, self.inp, x_offset=x_offset, y_offset=y_offset, **kwargs)
        return self

    def add_backdrop(self):
        add_backdrop(self.ax, self.inp)
        return self
