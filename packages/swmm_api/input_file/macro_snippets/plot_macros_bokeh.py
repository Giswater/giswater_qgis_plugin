from bokeh.plotting import figure, output_file, show, save
import matplotlib.pyplot as plt
from matplotlib import patches
from shapely import geometry as shp

from ..macros import find_link
from ..sections import Outfall, Polygon, SubCatchment
from swmm_api.input_file.section_labels import *


def plot_map(inp):  # TODO
    fig = figure(
        tools="pan,box_zoom,reset,save",
        title="SWMM Model",
        # y_axis_type="log",
        # y_range=[0.001, 10 ** 11],
        # x_axis_label='sections',
        # y_axis_label='particles'
        x_axis_location=None, y_axis_location=None, sizing_mode='stretch_height'
    )
    fig.aspect_ratio = 1
    fig.grid.grid_line_color = None
    fig.background_fill_color = "#eeeeee"
    fig.axis.visible = False
    fig.y_range.flipped = True

    def _points(c):
        return c.x, c.y

    for section in [CONDUITS,
                    PUMPS,
                    ORIFICES,
                    WEIRS,
                    OUTLETS]:
        if section in inp:
            for link in inp[section].values():  # type: swmm_api.input_file.sections.link._Link
                if link.name in inp[VERTICES]:
                    points = [_points(inp[COORDINATES][link.from_node])] \
                             + inp[VERTICES][link.name].vertices \
                             + [_points(inp[COORDINATES][link.to_node])]
                else:
                    points = [_points(inp[COORDINATES][link.from_node]), _points(inp[COORDINATES][link.to_node])]

                x, y = zip(*points)
                fig.line(x, y, line_color="black", line_width =1)
                fig.line(x, y, line_color="yellow", line_width =0.5)

    if POLYGONS in inp:
        for poly in inp[POLYGONS].values():  # type: Polygon
            x, y = zip(*poly.polygon)
            fig.patch(x, y)
            # ax.plot(x, y, 'r-')
            center = shp.Polygon(poly.polygon).centroid

            fig.scatter(x=center.x, y=center.y, marker='square', fill_color='black')

            subcatch = inp[SUBCATCHMENTS][poly.subcatchment]  # type: SubCatchment
            outlet = subcatch.outlet
            outlet_point = inp[COORDINATES][outlet]
            fig.line([center.x, outlet_point.x], [center.y, outlet_point.y], line_color='red', line_dash="dashed")

    coords = inp[COORDINATES].frame
    node_style = {
        JUNCTIONS: {'marker': 'circle', 'color': 'blue'},
        STORAGE: {'marker': 'square', 'color': 'green'},
        OUTFALLS: {'marker': 'triangle', 'color': 'red'},

    }
    fig.scatter(x=coords.x, y=coords.y, marker=node_style[JUNCTIONS]['marker'], fill_color=node_style[JUNCTIONS]['color'], line_color='black')

    for section in [STORAGE, OUTFALLS]:
        if section in inp:
            is_in_sec = coords.index.isin(inp[section].keys())
            fig.scatter(coords[is_in_sec].x, coords[is_in_sec].y, marker=node_style[section]['marker'], size=5,
                        line_color="black", fill_color=node_style[section]['color'], alpha=0.5)

    return fig
