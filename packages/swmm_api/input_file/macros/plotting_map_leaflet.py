import geopandas as gpd

from .tags import get_link_tags, get_node_tags
from .geo import complete_vertices
from .gis import subcatchment_geo_data_frame
from ..section_labels import *
from ..section_lists import LINK_SECTIONS, NODE_SECTIONS

# import xyzservices
# xyzservices.providers


def plot_map(inp, label_sep='.'):
    m = gpd.GeoDataFrame(subcatchment_geo_data_frame(inp)).explore(
        # tiles="Esri.WorldTopoMap"
    )

    # ---
    links_tags = get_link_tags(inp)
    complete_vertices(inp)

    line_style = {
        CONDUITS: {'marker': 'o', 'color': 'gold'},
        OUTLETS: {'marker': 's', 'color': 'grey'},
        ORIFICES: {'marker': '^', 'color': 'pink'},
        PUMPS: {'marker': '^', 'color': 'brown'},
        WEIRS: {'marker': '^', 'color': 'cyan'},
    }


    for sec in LINK_SECTIONS:
        if sec in inp:
            df = inp[sec].frame.rename(columns=lambda c: f'{sec}{label_sep}{c}').join(
                inp[XSECTIONS].frame.rename(columns=lambda c: f'{XSECTIONS}{label_sep}{c}'))

            if sec == OUTLETS:
                df[f'{OUTLETS}{label_sep}curve_description'] = df[f'{OUTLETS}{label_sep}curve_description'].astype(str)

            if LOSSES in inp:
                df = df.join(inp[LOSSES].frame.rename(columns=lambda c: f'{LOSSES}{label_sep}{c}'))

            df = df.join(inp[VERTICES].geo_series).join(links_tags)
            gpd.GeoDataFrame(df).explore(m=m, style_kwds=dict(color=line_style[sec]['color']))

    # ---
    nodes_tags = get_node_tags(inp)

    node_style = {
        JUNCTIONS: {'marker': 'o', 'color': 'blue'},
        STORAGE: {'marker': 's', 'color': 'green'},
        OUTFALLS: {'marker': '^', 'color': 'red'},
    }

    for sec in NODE_SECTIONS:
        if sec in inp:
            df = inp[sec].frame.rename(columns=lambda c: f'{sec}{label_sep}{c}')

            if sec == STORAGE:
                df[f'{STORAGE}{label_sep}data'] = df[f'{STORAGE}{label_sep}data'].astype(str)

            for sub_sec in [DWF, INFLOWS]:
                if sub_sec in inp:
                    x = inp[sub_sec].frame.unstack(1)
                    x.columns = [f'{label_sep}'.join([sub_sec, c[1], c[0]]) for c in x.columns]
                    df = df.join(x)

            df = df.join(inp[COORDINATES].geo_series).join(nodes_tags)
            gpd.GeoDataFrame(df).explore(m=m, style_kwds=dict(color=node_style[sec]['color']), radius=100)

    return m
