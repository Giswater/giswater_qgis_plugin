import plotly.graph_objects as go

from swmm_api import SwmmInput
from swmm_api.input_file.macros import complete_vertices
from swmm_api.input_file.section_labels import (
    MAP,
    VERTICES,
    POLYGONS,
    COORDINATES,
    SUBCATCHMENTS,
    JUNCTIONS,
    STORAGE,
    OUTFALLS, ORIFICES, PUMPS, WEIRS,
)
from swmm_api.input_file.sections import Polygon, SubCatchment

# TODO
#   plot all links in one scatter
#   use geo dataframe with or without rpt file


def set_inp_dimensions(fig, inp: SwmmInput):
    map_dim = inp[MAP]["DIMENSIONS"]
    x_min, x_max = map_dim["lower-left X"], map_dim["upper-right X"]
    y_min, y_max = map_dim["lower-left Y"], map_dim["upper-right Y"]

    fig.update_layout(
        xaxis=dict(range=[x_min, x_max]),
        yaxis=dict(range=[y_min, y_max], scaleanchor="x", scaleratio=1),
        showlegend=False,
    )


def init_empty_map_plot():
    fig = go.Figure()
    fig.update_xaxes(showgrid=True, visible=False)
    fig.update_yaxes(showgrid=True, visible=False)
    fig.update_layout(
        template="plotly_white", autosize=True, margin=dict(l=0, r=0, t=20, b=0)
    )

    fig.update_yaxes(
        scaleanchor="x",
        scaleratio=1,
    )
    return fig


def get_auto_size_function(value_min, value_max, size_min, size_max):
    diff_values = value_max - value_min
    diff_size = size_max - size_min

    def new_size(value):
        if (diff_values == 0) or (diff_size == 0):
            return size_min
        return (value - value_min) / diff_values * diff_size + size_min

    return new_size


def add_link_map(
    fig,
    inp: SwmmInput,
    color_default="gold",
    line_style_default="solid",
    line_width_default=3,
    line_width_max=10,
    make_width_proportional=False,
    values_dict=None,
    cmap=None,
    cmap_label=None,
    make_cmap_bar=True,
    value_min=0.001,
    value_max=None,
    add_arrows=True,
):
    complete_vertices(inp)

    if VERTICES in inp:
        if values_dict and make_width_proportional:
            values = values_dict.values()

            if value_min is None:
                value_min = min(values)

            if value_max is None:
                value_max = max(values)

            new_width = get_auto_size_function(
                value_min, value_max, line_width_default, line_width_max
            )
        else:
            new_width = lambda _: line_width_default
            if values_dict is None:
                values_dict = {}

        for link, vertices in inp[VERTICES].items():
            x, y = zip(*vertices.vertices)
            value = values_dict.get(link, 0)

            line_color = color_default if not cmap else cmap(value)

            if ORIFICES in inp and link in inp.ORIFICES:
                line_color = 'pink'

            if PUMPS in inp and link in inp.PUMPS:
                line_color = 'brown'

            if WEIRS in inp and link in inp.WEIRS:
                line_color = 'cyan'

            fig.add_trace(
                go.Scatter(
                    x=x,
                    y=y,
                    mode="lines",
                    line=dict(
                        color=line_color,
                        width=new_width(value),
                        dash=line_style_default,
                    ),
                    showlegend=False,
                    hoverinfo='skip'
                    # marker=go.scatter.Marker(size=20,symbol= "arrow-bar-up", angleref="previous", line_color='black',
                    #         line_width=1)
                    # name='LINK'
                )
            )
            # -----
            if add_arrows:
                import numpy as np
                # Calculate the total length of the path and the cumulative lengths
                cumulative_lengths = [0]  # start at the first point
                for i in range(1, len(x)):
                    dx = x[i] - x[i - 1]
                    dy = y[i] - y[i - 1]
                    segment_length = np.sqrt(dx ** 2 + dy ** 2)
                    cumulative_lengths.append(cumulative_lengths[-1] + segment_length)

                # Total path length
                total_length = cumulative_lengths[-1]

                # Find the midpoint along the total path length
                midpoint_length = total_length / 2

                # Find the segment containing the midpoint
                for i in range(1, len(cumulative_lengths)):
                    if cumulative_lengths[i] >= midpoint_length:
                        break

                # Interpolate the exact position of the midpoint within this segment
                segment_ratio = (midpoint_length - cumulative_lengths[i - 1]) / (cumulative_lengths[i] - cumulative_lengths[i - 1])
                mid_x = x[i - 1] + segment_ratio * (x[i] - x[i - 1])
                mid_y = y[i - 1] + segment_ratio * (y[i] - y[i - 1])

                # Compute the direction vector for this segment
                dx = x[i] - x[i - 1]
                dy = y[i] - y[i - 1]
                length = np.sqrt(dx ** 2 + dy ** 2)

                # Normalize the direction vector
                dx /= length
                dy /= length

                # Compute the perpendicular vector
                perp_dx = -dy
                perp_dy = dx

                # Offset the midpoint slightly along the perpendicular direction to position the arrow
                arrow_offset = 0.1  # Adjust this as needed
                arrow_x = mid_x + perp_dx * arrow_offset
                arrow_y = mid_y + perp_dy * arrow_offset

                # Add the triangular arrow at the computed midpoint
                fig.add_trace(go.Scatter(
                    x=[arrow_x],
                    y=[arrow_y],
                    mode='markers',
                    marker=dict(
                        symbol='arrow',
                        size=12,
                        angle=90-np.degrees(np.arctan2(dy, dx)),  # Align arrow with the segment's angle
                        color=line_color,
                        line_color='black',
                        line_width=1
                    ),
                    showlegend=False
                ))


def add_subcatchment_map(
    fig,
    inp: SwmmInput,
    add_center_point=True,
    center_point_kwargs=None,
    add_connector_line=True,
    connector_line_kwargs=None,
):
    if POLYGONS in inp:
        if COORDINATES in inp:
            points = dict(inp[COORDINATES])
        else:
            points = {}
        import shapely.geometry as shp

        points.update(
            {
                poly.subcatchment: shp.Polygon(poly.polygon).centroid
                for poly in inp[POLYGONS].values()
            }
        )

        for poly in inp[POLYGONS].values():  # type: Polygon

            fig.add_trace(
                go.Scatter(
                    x=[p[0] for p in poly.polygon],
                    y=[p[1] for p in poly.polygon],
                    mode="lines",
                    line=go.scatter.Line(color="lightgrey", dash="dash"),
                    showlegend=False,
                    fill="toself",
                    name=f'{inp.SUBCATCHMENTS[poly.subcatchment]}\n<br>{inp.SUBAREAS[poly.subcatchment]}\n<br>{inp.INFILTRATION[poly.subcatchment]}',
                )
            )

            if add_center_point:
                if center_point_kwargs is None:
                    center_point_kwargs = {}
                center_point_kwargs.update(dict(symbol="square-open", color="darkgrey", size=10))

                center = points[poly.subcatchment]
                fig.add_trace(
                    go.Scatter(
                        x=[center.x],
                        y=[center.y],
                        mode="markers",
                        marker=go.scatter.Marker(**center_point_kwargs),
                        showlegend=False,
                        hoverinfo='skip'
                    )
                )

            if add_connector_line:
                if connector_line_kwargs is None:
                    connector_line_kwargs = {}
                connector_line_kwargs.update(dict(dash="dash", color="darkgrey"))

                subcatch = inp[SUBCATCHMENTS][poly.subcatchment]  # type: SubCatchment
                outlet_point = points[subcatch.outlet]
                center = points[poly.subcatchment]

                fig.add_trace(
                    go.Scatter(
                        x=[center.x, outlet_point.x],
                        y=[center.y, outlet_point.y],
                        mode="lines",
                        line=go.scatter.Line(**connector_line_kwargs),
                        showlegend=False,
                        hoverinfo='skip'
                    )
                )


def add_node_map(
    fig,
    inp: SwmmInput,
    size_default=10,
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
    if COORDINATES in inp:
        coords = inp[COORDINATES].frame
        node_style = {
            JUNCTIONS: {"symbol": "circle", "color": "blue"},
            STORAGE: {"symbol": "square", "color": "green"},
            OUTFALLS: {"symbol": "triangle-down", "color": "red"},
        }

        if values_dict and make_size_proportional:
            values = values_dict.values()

            if value_min is None:
                value_min = min(values)

            if value_max is None:
                value_max = max(values)

            new_size = get_auto_size_function(
                value_min, value_max, size_default, size_max
            )
        else:
            new_size = lambda _: size_default

        for section in [JUNCTIONS, STORAGE, OUTFALLS]:
            if section in inp:
                is_in_sec = coords.index.isin(inp[section].keys())
                node_coords = coords[is_in_sec]

                if values_dict:
                    node_values = [values_dict.get(n, 0) for n in node_coords.index]

                sizes = (
                    [new_size(i) for i in node_values]
                    if make_size_proportional
                    else size_default
                )

                fig.add_trace(
                    go.Scatter(
                        x=node_coords.x,
                        y=node_coords.y,
                        mode="markers",
                        marker=dict(
                            size=sizes,
                            color=node_values if cmap else node_style[section]["color"],
                            symbol=node_style[section]["symbol"],
                            line_color='black',
                            line_width=1
                        ),
                        name=section,
                        showlegend=True,
                    )
                )

    if make_cmap_bar and cmap:
        fig.update_layout(
            coloraxis=dict(colorscale=cmap, colorbar=dict(title=cmap_label))
        )
