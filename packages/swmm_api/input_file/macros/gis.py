import inspect
import time

import pandas as pd
from tqdm.auto import tqdm

from .reduce_unneeded import remove_empty_sections
from .geo import complete_vertices, simplify_vertices, reduce_vertices
from .tags import get_node_tags, get_link_tags, get_subcatchment_tags, TAG_COL_NAME
from ..inp import SwmmInput
from ..section_labels import *
from ..section_lists import LINK_SECTIONS, NODE_SECTIONS
from ..sections import Tag, InfiltrationGreenAmpt, InfiltrationHorton, InfiltrationCurveNumber
from ..sections._identifiers import IDENTIFIERS

"""
{'AeronavFAA': 'r',
 'ARCGEN': 'r',
 'BNA': 'raw',
 'DXF': 'raw',
 'CSV': 'raw',
 'OpenFileGDB': 'r',
 'ESRIJSON': 'r',
 'ESRI Shapefile': 'raw',
 'GeoJSON': 'rw',
 'GPKG': 'rw',
 'GML': 'raw',
 'GPX': 'raw',
 'GPSTrackMaker': 'raw',
 'Idrisi': 'r',
 'MapInfo File': 'raw',
 'DGN': 'raw',
 'S57': 'r',
 'SEGY': 'r',
 'SUA': 'r',
 'TopoJSON': 'r'}
 
# end = '.json'
# end = '.shp'
# end = '.gpkg'
"""


LIST_SECTIONS_NO_GIS = [TITLE, OPTIONS, REPORT, FILES, RAINGAGES, EVAPORATION, TEMPERATURE, ADJUSTMENTS,
                        LID_CONTROLS, LID_USAGE, AQUIFERS, GROUNDWATER, GWF, SNOWPACKS, DIVIDERS, CONTROLS, POLLUTANTS, LANDUSES, COVERAGES, LOADINGS, BUILDUP, WASHOFF,
                        TREATMENT, RDII,  # kann den Knoten noch zugeordnet werden
                        HYDROGRAPHS, CURVES, TIMESERIES, PATTERNS, STREETS, INLETS,
                        INLET_USAGE, MAP, LABELS, SYMBOLS, BACKDROP, PROFILES,
                        ]


def set_crs(inp, crs="EPSG:32633"):
    """
    add geo-support to the inp-data

    Warnings:
        only for `VERTICES`, `COORDINATES`, `POLYGONS` sections

    Args:
        inp:
        crs: Coordinate Reference System of the geometry objects.
                Can be anything accepted by :meth:`pyproj.CRS.from_user_input() <pyproj.crs.CRS.from_user_input>`,
                such as an authority string (eg “EPSG:32633”) or a WKT string.
    """
    for sec in [VERTICES, COORDINATES, POLYGONS]:
        if sec in inp:
            inp[sec].set_crs(crs=crs)


def convert_inp_to_geo_package(inp_fn, gpkg_fn=None, driver='GPKG', label_sep='.', crs="EPSG:32633"):
    """
    convert inp file data from an .inp-file to a GIS database

    Args:
        inp_fn (str | pathlib.Path): filename of the SWMM inp file
        gpkg_fn (str | pathlib.Path): filename of the new geopackage file
        driver (str): The OGR format driver used to write the vector file. (see: fiona.supported_drivers)
        label_sep (str): separator for attribute label between section header and object attribute.
            I.e. "JUNCTIONS.Elevation" with label_sep='.'
        crs (str): Coordinate Reference System of the geometry objects.
                    Can be anything accepted by pyproj.CRS.from_user_input(),
                    such as an authority string (eg “EPSG:4326”) or a WKT string.
    """
    if gpkg_fn is None:
        if isinstance(inp_fn, str):
            gpkg_fn = inp_fn.replace('.inp', '.gpkg')
        else:
            gpkg_fn = inp_fn.with_suffix('.gpkg')

    inp = SwmmInput.read_file(inp_fn)

    write_geo_package(inp, gpkg_fn, driver=driver, label_sep=label_sep, crs=crs)


def write_geo_package(inp, gpkg_fn, driver='GPKG', label_sep='.', crs="EPSG:32633",
                      simplify_link_min_length=None, add_style=True, add_subcatchment_connector=False):
    """
    Write the inp file data to a GIS database.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        gpkg_fn (str | pathlib.Path): filename of the new geopackage file
        driver (str): The OGR format driver used to write the vector file. (see: fiona.supported_drivers)
        label_sep (str): separator for attribute label between section header and object attribute.
            I.e. "JUNCTIONS.Elevation" with label_sep='.'
        crs (str): Coordinate Reference System of the geometry objects.
                    Can be anything accepted by pyproj.CRS.from_user_input(),
                    such as an authority string (eg “EPSG:4326”) or a WKT string.
        simplify_link_min_length (float): simplify links with a minimum length of ... (default: all)
        add_style (bool): if the default style should be added to the geopackage.
        add_subcatchment_connector (bool): if a line layer should be added which symbolize the connection between the subcatchments and their outlet.
    """
    import geopandas as gpd

    remove_empty_sections(inp)

    todo_sections = NODE_SECTIONS + LINK_SECTIONS + [SUBCATCHMENTS]
    print(*todo_sections, sep=' | ')

    set_crs(inp, crs=crs)

    # ---------------------------------
    t0 = time.perf_counter()
    nodes_tags = get_node_tags(inp)
    if COORDINATES in inp:
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

                if not df.empty:
                    gpd.GeoDataFrame(df).to_file(gpkg_fn, driver=driver, layer=sec)
                print(f'{f"{time.perf_counter() - t0:0.1f}s":^{len(sec)}s}', end=' | ')
            else:
                print(f'{f"-":^{len(sec)}s}', end=' | ')
            t0 = time.perf_counter()

        # ---------------------------------
        links_tags = get_link_tags(inp)
        complete_vertices(inp)
        simplify_vertices(inp, min_length=simplify_link_min_length)
        for sec in LINK_SECTIONS:
            if sec in inp:
                df = inp[sec].frame.rename(columns=lambda c: f'{sec}{label_sep}{c}').join(
                    inp[XSECTIONS].frame.rename(columns=lambda c: f'{XSECTIONS}{label_sep}{c}'))

                if sec == OUTLETS:
                    df[f'{OUTLETS}{label_sep}curve_description'] = df[f'{OUTLETS}{label_sep}curve_description'].astype(str)

                if LOSSES in inp:
                    df = df.join(inp[LOSSES].frame.rename(columns=lambda c: f'{LOSSES}{label_sep}{c}'))

                df = df.join(inp[VERTICES].geo_series).join(links_tags)

                if not df.empty:
                    gpd.GeoDataFrame(df).to_file(gpkg_fn, driver=driver, layer=sec)

                print(f'{f"{time.perf_counter() - t0:0.1f}s":^{len(sec)}s}', end=' | ')
            else:
                print(f'{f"-":^{len(sec)}s}', end=' | ')
            t0 = time.perf_counter()
    else:
        for sec in NODE_SECTIONS + LINK_SECTIONS:
            print(f'{f"-":^{len(sec)}s}', end=' | ')
    # ---------------------------------
    if POLYGONS in inp:
        df = inp[SUBCATCHMENTS].frame.rename(columns=lambda c: f'{SUBCATCHMENTS}{label_sep}{c}').join(
            inp[SUBAREAS].frame.rename(columns=lambda c: f'{SUBAREAS}{label_sep}{c}')).join(
            inp[INFILTRATION].frame.rename(columns=lambda c: f'{INFILTRATION}{label_sep}{c}')).join(
            inp[POLYGONS].geo_series).join(get_subcatchment_tags(inp))

        if not df.empty:
            gpd.GeoDataFrame(df).to_file(gpkg_fn, driver=driver, layer=SUBCATCHMENTS)

        print(f'{f"{time.perf_counter() - t0:0.1f}s":^{len(SUBCATCHMENTS)}s}')

        if add_subcatchment_connector and (COORDINATES in inp):
            gs_connector = get_subcatchment_connectors(inp)
            gpd.GeoDataFrame(gs_connector).to_file(gpkg_fn, driver=driver, layer=SUBCATCHMENTS + '_connector')
    else:
        print(f'{f"-":^{len(SUBCATCHMENTS)}s}')

    if add_style:
        apply_gis_style_to_gpkg(gpkg_fn)


def get_subcatchment_connectors(inp):
    """
    create connector line objects between subcatchment outlets and centroids

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    Returns:
        geopandas.GeoSeries: line objects between subcatchment outlets and centroids
    """
    # centroids = inp[s.POLYGONS].geo_series.centroid
    # outlets = inp[s.SUBCATCHMENTS].frame.outlet
    # junctions = inp[s.COORDINATES].geo_series.reindex(outlets.values)
    # junctions.index = outlets.index
    import geopandas as gpd
    import shapely.geometry as shp

    res = {}

    n_polygons = len(inp[POLYGONS].keys())
    if n_polygons > 1000:
        iterator = tqdm(inp[POLYGONS], total=n_polygons, desc='get_subcatchment_connectors')
    else:
        iterator = inp[POLYGONS]

    for p in iterator:
        c = inp[POLYGONS][p].geo.centroid
        o = inp[SUBCATCHMENTS][p].outlet
        if o in inp[COORDINATES]:
            res[p] = shp.LineString([inp[COORDINATES][o].point, (c.x, c.y)])
        elif o in inp[POLYGONS]:
            res[p] = shp.LineString([inp[POLYGONS][o].geo.centroid, (c.x, c.y)])
        else:
            print(inp[SUBCATCHMENTS][p])
            continue

    gs = gpd.GeoSeries(res, crs=inp[POLYGONS]._crs)
    gs.index.name = 'Subcatchment'
    gs.name = 'geometry'
    return gs


def links_geo_data_frame(inp, label_sep='.'):
    """
    convert link data in inp file to geo-data-frame

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label_sep (str): separator for attribute label between section header and object attribute.
            I.e. "JUNCTIONS.Elevation" with label_sep='.'

    Returns:
        geopandas.GeoDataFrame: links as geo-data-frame
    """
    import geopandas as gpd

    links_tags = get_link_tags(inp)
    complete_vertices(inp)
    res = None
    for sec in LINK_SECTIONS:
        if sec in inp:
            df = inp[sec].frame.rename(columns=lambda c: f'{sec}{label_sep}{c}').join(
                inp[XSECTIONS].frame.rename(columns=lambda c: f'{XSECTIONS}{label_sep}{c}'))

            if sec == OUTLETS:
                df[f'{OUTLETS}{label_sep}curve_description'] = df[f'{OUTLETS}{label_sep}curve_description'].astype(str)

            if LOSSES in inp:
                df = df.join(inp[LOSSES].frame.rename(columns=lambda c: f'{LOSSES}{label_sep}{c}'))

            df = df.join(inp[VERTICES].geo_series).join(links_tags)
            if res is None:
                res = df
            else:
                res = pd.concat([res, df], axis=0)
                # res = res.append(df)
    return gpd.GeoDataFrame(res)


def nodes_geo_data_frame(inp, label_sep='.'):
    """
    convert nodes data in inp file to geo-data-frame

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        label_sep (str): separator for attribute label between section header and object attribute.
            I.e. "JUNCTIONS.Elevation" with label_sep='.'

    Returns:
        geopandas.GeoDataFrame: nodes as geo-data-frame
    """
    import geopandas as gpd

    nodes_tags = get_node_tags(inp)
    res = None
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

            if res is None:
                res = df
            else:
                res = pd.concat([res, df], axis=0)
                # res = res.append(df)

    return gpd.GeoDataFrame(res)


def subcatchment_geo_data_frame(inp: SwmmInput, label_sep='.'):
    return inp[SUBCATCHMENTS].frame.rename(columns=lambda c: f'{SUBCATCHMENTS}{label_sep}{c}').join(
               inp[SUBAREAS].frame.rename(columns=lambda c: f'{SUBAREAS}{label_sep}{c}')).join(
               inp[INFILTRATION].frame.rename(columns=lambda c: f'{INFILTRATION}{label_sep}{c}')).join(
               inp[POLYGONS].geo_series).join(get_subcatchment_tags(inp))


def gpkg_to_swmm(fn, label_sep='.', infiltration_class=None, custom_section_handler=None, simplify=False):
    """
    import inp data from GIS gpkg file created from the swmm_api.input_file.macro_snippets.gis_export.convert_inp_to_geo_package function

    Args:
        fn (str | pathlib.Path): filename to GPKG datebase file
        label_sep (str):  separator for attribute label between section header and object attribute.
            I.e. "JUNCTIONS.Elevation" with label_sep='.'

    Returns:
        SwmmInput: inp data
    """
    import geopandas as gpd

    inp = SwmmInput(custom_section_handler=custom_section_handler)

    if infiltration_class is not None:
        inp.set_infiltration_method(infiltration_class)

    section_dict = inp._converter

    layers_available = gpd.list_layers(fn).name.values

    for sec in NODE_SECTIONS:
        if sec not in layers_available:
            continue
        gdf = gpd.read_file(fn, layer=sec).set_index(IDENTIFIERS.name).infer_objects()

        cols = gdf.columns[gdf.columns.str.startswith(sec)]
        inp[sec] = section_dict[sec].create_section(gdf[cols].reset_index().infer_objects().values)

        for sub_sec in [DWF, INFLOWS]:
            cols = gdf.columns[gdf.columns.str.startswith(sub_sec)]
            if not cols.empty:
                gdf_sub = gdf[cols].copy()
                gdf_sub.columns = pd.MultiIndex.from_tuples([col.split(label_sep) for col in gdf_sub.columns])
                cols_order = gdf_sub.columns.droplevel(1)
                gdf_sub = gdf_sub.stack(1, future_stack=True)[cols_order]
                if sub_sec == DWF:
                    gdf_sub = gdf_sub.loc[gdf_sub[(sub_sec, 'base_value')].notna()]
                inp[sub_sec].update(section_dict[sub_sec].create_section(gdf_sub.reset_index().values))

        inp[COORDINATES].update(section_dict[COORDINATES].create_section_from_geoseries(gdf.geometry))

        tags = gdf[[TAG_COL_NAME]].copy().dropna()
        if not tags.empty:
            tags['type'] = Tag.TYPES.Node
            inp[TAGS].update(section_dict[TAGS].create_section(tags.reset_index()[['type', IDENTIFIERS.name, TAG_COL_NAME]].values))

    # ---------------------------------
    for sec in LINK_SECTIONS:
        if sec not in layers_available:
            continue
        gdf = gpd.read_file(fn, layer=sec).set_index(IDENTIFIERS.name).infer_objects()

        cols = gdf.columns[gdf.columns.str.startswith(sec)]
        inp[sec] = section_dict[sec].create_section(gdf[cols].reset_index().infer_objects().values)

        for sub_sec in [XSECTIONS, LOSSES]:
            cols = gdf.columns[gdf.columns.str.startswith(sub_sec)].to_list()
            if cols:
                if sub_sec == XSECTIONS:
                    cols = [f'{sub_sec}{label_sep}{i}' for i in inspect.getfullargspec(section_dict[sub_sec]).args[2:]]
                gdf_sub = gdf[cols].copy().dropna(how='all')
                if sub_sec == LOSSES:
                    # either a number or a string
                    gdf_sub[f'{LOSSES}{label_sep}has_flap_gate'] = (gdf_sub[f'{LOSSES}{label_sep}has_flap_gate'] == 1) | (gdf_sub[f'{LOSSES}{label_sep}has_flap_gate'] == 'True')
                inp[sub_sec].update(section_dict[sub_sec].create_section(gdf_sub.reset_index().values))

        inp[VERTICES].update(section_dict[VERTICES].create_section_from_geoseries(gdf.geometry))

        tags = gdf[[TAG_COL_NAME]].copy().dropna()
        if not tags.empty:
            tags['type'] = Tag.TYPES.Link
            inp[TAGS].update(section_dict[TAGS].create_section(tags.reset_index()[['type', IDENTIFIERS.name, TAG_COL_NAME]].values))

    if simplify:
        simplify_vertices(inp)
    reduce_vertices(inp)

    # ---------------------------------
    if SUBCATCHMENTS in layers_available:
        gdf = gpd.read_file(fn, layer=SUBCATCHMENTS).set_index(IDENTIFIERS.name).infer_objects()

        for sec in [SUBCATCHMENTS, SUBAREAS, INFILTRATION]:
            cols = gdf.columns[gdf.columns.str.startswith(sec)]
            if (sec == INFILTRATION) and infiltration_class is None:
                given_cols = [c.replace(f'{sec}.', '') for c in cols]

                for _inf_cls in (InfiltrationGreenAmpt, InfiltrationHorton, InfiltrationCurveNumber):
                    # Extract the parameter names, excluding 'self'
                    init_args = list(inspect.signature(_inf_cls.__init__).parameters.keys())[2:]
                    if len(set(given_cols) & set(init_args)) == len(given_cols):
                        # print('found', _inf_cls)
                        infiltration_class = _inf_cls
                        inp.set_infiltration_method(infiltration_class)
                        break
                # ---
                if infiltration_class is None:
                    for _inf_cls in (InfiltrationGreenAmpt, InfiltrationHorton, InfiltrationCurveNumber):
                        try:
                            inp.set_infiltration_method(_inf_cls)
                            inp[sec] = section_dict[sec].create_section(gdf[cols].reset_index().infer_objects().values)
                        except TypeError:
                            pass
            else:
                inp[sec] = section_dict[sec].create_section(gdf[cols].reset_index().infer_objects().values)

        inp[POLYGONS] = section_dict[POLYGONS].create_section_from_geoseries(gdf.geometry)

        tags = gdf[[TAG_COL_NAME]].copy().dropna()
        if not tags.empty:
            tags['type'] = Tag.TYPES.Subcatch
            inp[TAGS].update(section_dict[TAGS].create_section(tags.reset_index()[['type', IDENTIFIERS.name, TAG_COL_NAME]].values))

    return inp


def update_length(inp):
    """
    Set the length of all conduits based on the length of the vertices.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.

    .. Important::
        Works inplace.
    """
    for c in inp.CONDUITS.values():
        c.length = inp.VERTICES[c.name].geo.length


def update_area(inp, decimals=4):
    """
    Set the area of all subcatchments based on the area of the polygons.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        decimals (int): decimal places for the new value

    .. Important::
        Works inplace.
    """
    for sc in inp.SUBCATCHMENTS.values():
        sc.area = round(inp.POLYGONS[sc.name].geo.area, decimals-4) * 1e-4  # m² to ha


def _create_gpkg_style_table(fn_gpkg):
    import sqlite3
    # Connect to the GeoPackage
    conn = sqlite3.connect(fn_gpkg)
    cursor = conn.cursor()

    # SQL statement to create the layer_styles table
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS layer_styles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        f_table_name TEXT NOT NULL,
        f_geometry_column TEXT NOT NULL,
        styleQML TEXT,
        styleSLD TEXT,
        styleName TEXT DEFAULT '',
        description TEXT DEFAULT '',
        owner TEXT DEFAULT '',
        f_table_catalog TEXT DEFAULT '',
        f_table_schema TEXT DEFAULT '',
        ui TEXT DEFAULT '',
        useAsDefault BOOLEAN DEFAULT TRUE,
        update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """

    # Execute the SQL statement
    cursor.execute(create_table_sql)

    # Commit changes and close connection
    conn.commit()
    conn.close()


def apply_gis_style_to_gpkg(fn_gpkg):
    from .gis_styles import GIS_STYLE_PATH
    import sqlite3

    _create_gpkg_style_table(fn_gpkg)

    for section in (JUNCTIONS, STORAGE, OUTFALLS, CONDUITS, ORIFICES, OUTLETS, PUMPS, WEIRS, SUBCATCHMENTS, SUBCATCHMENTS + '_connector'):
        layer_name = section

        # Path to your QML file and GeoPackage
        fn_qml = GIS_STYLE_PATH / f'{section.capitalize()}.qml'
        fn_sld = fn_qml.with_suffix('.sld')

        # Read the QML file
        with open(fn_qml, 'r') as file:
            qml_content = file.read()

        with open(fn_sld, 'r') as file:
            sld_content = file.read().replace('__XX__', str(GIS_STYLE_PATH))

        # Connect to the GeoPackage
        conn = sqlite3.connect(fn_gpkg)
        cursor = conn.cursor()

        # Assuming you have a table for styles ('layer_styles') and a layer ('your_layer_name')
        # Check if a style already exists for the layer
        cursor.execute("SELECT COUNT(*) FROM layer_styles WHERE f_table_name = ?", (layer_name,))
        if cursor.fetchone()[0] == 0:
            # Insert new style entry if it doesn't exist
            cursor.execute("""
                INSERT INTO layer_styles (styleName, f_table_name, f_geometry_column, styleQML, styleSLD, useAsDefault)
                VALUES (?, ?, ?, ?, ?, ?)
            """, (f'{section.lower()}_style', layer_name, 'geom', qml_content, sld_content, 1))
        else:
            # Update existing style entry
            cursor.execute("""
                UPDATE layer_styles
                SET styleQML = ?, styleSLD = ?, useAsDefault = ?, styleName = ?, f_table_catalog = "", f_table_schema = "", owner = "", description = ?
                WHERE f_table_name = ? AND f_geometry_column = ?
            """, (qml_content, sld_content, 1, f'{section.lower()}_style', f'style for section {section}', layer_name, 'geom'))

        # Commit changes and close connection
        conn.commit()
        conn.close()
