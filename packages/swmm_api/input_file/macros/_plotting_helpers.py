import copy

import numpy as np

from matplotlib import pyplot as plt, colors as mcolors
from matplotlib.colors import Normalize, LinearSegmentedColormap
from matplotlib.lines import Line2D


def _get_matplotlib_colormap(cmap, set_under='lightgray', set_bad='black'):
    cmap = copy.copy(plt.cm.get_cmap(cmap))

    if set_under:
        cmap.set_under(set_under)
    if set_bad:
        cmap.set_bad(set_bad)
    return cmap


def _get_color_mapper(cmap, vmin, vmax):
    norm = Normalize(vmin=vmin, vmax=vmax)
    return lambda x: cmap(norm(x))


def _custom_color_mapper(cmap, vmin=None, vmax=None, set_under='lightgray', set_bad='black'):
    cmap = _get_matplotlib_colormap(cmap, set_under, set_bad)
    return _get_color_mapper(cmap, vmin=vmin, vmax=vmax)


def _get_discrete_colormap(cmap):
    # cmap = copy.copy(plt.cm.get_cmap(cmap))  # define the colormap
    # extract all colors from the .jet map
    cmaplist = [cmap(i) for i in range(cmap.N)]
    # force the first color entry to be grey
    cmaplist[0] = (.85, .85, .85, 1.0)

    # create the new map
    cmap = LinearSegmentedColormap.from_list('Custom cmap', cmaplist, cmap.N)

    return cmap


def _get_auto_size_function(value_min, value_max, size_min, size_max):
    diff_values = value_max - value_min
    diff_size = size_max - size_min

    def new_size(value):
        if (diff_values == 0) or (diff_size == 0):
            return size_min
        return (value - value_min) / diff_values * diff_size + size_min

    return new_size


def _darken_color(color):
    lc = mcolors.rgb_to_hsv(mcolors.to_rgb(color))

    if lc[2] > 0.5:
        lc[2] -= .5
    elif lc[2] <= .5:
        lc[2] /= 2

    return mcolors.hsv_to_rgb(lc)


def _get_mid_point_angle(x, y):
    distances = np.sqrt(np.diff(x) ** 2 + np.diff(y) ** 2)
    mid_distance = np.sum(distances) / 2
    cumulative_distances = np.cumsum(distances)

    for i, d in enumerate(cumulative_distances):
        if d >= mid_distance:
            t = (mid_distance - (cumulative_distances[i - 1] if i > 0 else 0)) / distances[i]
            x_mid = x[i] + t * (x[i + 1] - x[i])
            y_mid = y[i] + t * (y[i + 1] - y[i])
            dx, dy = x[i + 1] - x[i], y[i + 1] - y[i]
            angle = np.arctan2(dy, dx)
            break
    return x_mid, y_mid, np.degrees(angle)


def _add_custom_legend(ax, lines_dict, **kwargs):
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
