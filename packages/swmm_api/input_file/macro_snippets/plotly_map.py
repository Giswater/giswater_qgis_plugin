import numpy as np

from swmm_api.input_file.section_labels import *


def append_na(x, every=3):
    every_index = every - 1
    return np.reshape(np.insert(np.reshape(x, (-1, every_index)), every_index, None, axis=1), (1, -1))[0]


def plotly_map(inp, fn):  # TODO
    coords = inp[COORDINATES]
    from mp.libs.timeseries.plots.plotly_interface import PlotlyAxes, Ax
    from plotly.graph_objs import Scatter
    axes = PlotlyAxes()

    for edge_kind, color in [('CONDUITS', 'black'),
                             ('WEIRS', 'red'),
                             ('PUMPS', 'blue'),
                             ('ORIFICES', 'orange'),
                             ('OUTLETS', 'cyan')]:
        if edge_kind not in inp:
            continue

        nodes = inp[edge_kind][['from_node', 'to_node']].stack().values
        x = coords.lookup(nodes, ['x'] * len(nodes))
        y = coords.lookup(nodes, ['y'] * len(nodes))

        x = append_na(x, 3)
        y = append_na(y, 3)

        edge_scatter = Scatter(x=x, y=y, hoverinfo='none',  # hovertext=[],
                               showlegend=True, line=dict(color=color),
                               mode='lines', name=edge_kind)

        axes.append(Ax(edge_scatter))

    axes.append(Ax(Scatter(x=coords.x, y=coords.y, hoverinfo='text', hovertext=coords.index,
                           mode='markers',
                           name='JUNCTIONS', marker=dict(color='grey'))))

    # https://plot.ly/python/igraph-networkx-comparison/
    fig = axes.get_figure(vertical_spacing=0.02, spaces=[4, 4, 1.5], bg=None)
    # fig.set_title(inp.station)

    fig.turn_axes_off()
    fig.set_size_auto()
    fig.set_hover_mode("closest")
    fig.save(fn, auto_open=True)


def plotly_mapX(inp, fn):
    from mp.libs.timeseries.plots.plotly_interface import PlotlyAxes, Ax
    from plotly.graph_objs import Scattergeo

    # TODO keine ahnung wie man koordinaten umrechnet
    coords = inp[COORDINATES].frame
    axes = PlotlyAxes()

    # for edge_kind, color in [('CONDUITS', 'black'),
    #                          ('WEIRS', 'red'),
    #                          ('PUMPS', 'blue'),
    #                          ('ORIFICES', 'orange'),
    #                          ('OUTLETS', 'cyan')]:
    #     if edge_kind not in inp:
    #         continue
    #
    #     nodes = inp[edge_kind][['from_node', 'to_node']].stack().values
    #     x = coords.lookup(nodes, ['x'] * len(nodes))
    #     y = coords.lookup(nodes, ['y'] * len(nodes))
    #
    #     x = append_na(x, 3)
    #     y = append_na(y, 3)
    #
    #     edge_scatter = Scatter(x=x, y=y, hoverinfo='none',  # hovertext=[],
    #                            showlegend=True, line=dict(color=color),
    #                            mode='lines', name=edge_kind)
    #
    #     axes.append(Ax(edge_scatter))

    axes.append(
        Ax(Scattergeo(lon=coords.x, lat=coords.y, hoverinfo='lon+lat',  # 'text', hovertext=coords.index,
                      mode='markers',
                      name='JUNCTIONS', marker=dict(color='grey'))))

    # https://plot.ly/python/igraph-networkx-comparison/
    fig = axes.get_figure(bg=None)
    fig.figure.layout.update(dict(geo=dict(
        scope="europe",
        projection=dict(type="transverse mercator"),
        showland=True,
        lonaxis=dict(
            showgrid=True,
            gridwidth=0.5,
            # range=[-140.0, -55.0],
            dtick=5
        ),
        lataxis=dict(
            showgrid=True,
            gridwidth=0.5,
            # range=[20.0, 60.0],
            dtick=5
        )
        # rotation=dict(
        #     lon=-34/2
        # )
        # landcolor='rgb(243, 243, 243)',
        # countrycolor='rgb(204, 204, 204)',
    ), ))
    # fig.set_title(inp.station)
    # fig.turn_axes_off()
    # fig.set_size_auto()
    # fig.set_hover_mode("closest")
    fig.save(fn, auto_open=True)
