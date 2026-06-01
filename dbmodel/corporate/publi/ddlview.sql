/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = publi, public, pg_catalog;

CREATE OR REPLACE VIEW publi.v_ud_arc AS
SELECT ud_ve_arc.arc_id,
       ud_ve_arc.node_1,
       ud_ve_arc.sys_y1,
       ud_ve_arc.sys_elev1,
       ud_ve_arc.node_2,
       ud_ve_arc.sys_y2,
       ud_ve_arc.sys_elev2,
       ud_ve_arc.gis_length,
       ud_ve_arc.slope,
       ud_ve_arc.inverted_slope,
       ud_ve_arc.cat_shape,
       ud_ve_arc.matcat_id,
       ud_ve_arc.cat_geom1,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ud_ve_exploitation.name AS expl_id,
       ud_ve_arc.macroexpl_id,
       ud_ve_municipality.name AS muni_id,
       ud_ve_dwfzone.name AS dwfzone_id,
       ud_ve_drainzone.name AS drainzone_id,
       ud_ve_arc.builtdate,
       ud_ve_arc.the_geom
FROM publi.ud_ve_arc
JOIN ud.value_state ON value_state.id = ud_ve_arc.state
JOIN ud.value_state_type ON value_state_type.id = ud_ve_arc.state_type
JOIN publi.ud_ve_exploitation ON ud_ve_exploitation.expl_id = ud_ve_arc.expl_id
JOIN publi.ud_ve_municipality ON ud_ve_municipality.muni_id = ud_ve_arc.muni_id
LEFT JOIN publi.ud_ve_dwfzone ON ud_ve_dwfzone.dwfzone_id = ud_ve_arc.dwfzone_id
LEFT JOIN publi.ud_ve_drainzone ON ud_ve_drainzone.drainzone_id = ud_ve_arc.drainzone_id;


CREATE OR REPLACE VIEW publi.v_ud_dma AS
SELECT dma_id,
       name,
       dma_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ud_ve_dma;

CREATE OR REPLACE VIEW publi.v_ud_drainzone AS
SELECT drainzone_id,
       name,
       drainzone_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ud_ve_drainzone;

CREATE OR REPLACE VIEW publi.v_ud_dwfzone AS
SELECT dwfzone_id,
       name,
       dwfzone_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ud_ve_dwfzone;

CREATE OR REPLACE VIEW publi.v_ud_element AS
SELECT ud_ve_element.element_id,
       ud_ve_element.top_elev,
       ud_ve_element.element_type,
       ud_ve_element.elementcat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ud_ve_exploitation.name AS expl_id,
       ud_ve_municipality.name AS muni_id,
       ud_ve_element.builtdate,
       ud_ve_element.the_geom
FROM publi.ud_ve_element
JOIN ud.value_state ON value_state.id = ud_ve_element.state
JOIN ud.value_state_type ON value_state_type.id = ud_ve_element.state_type
JOIN publi.ud_ve_exploitation ON ud_ve_exploitation.expl_id = ud_ve_element.expl_id
JOIN publi.ud_ve_municipality ON ud_ve_municipality.muni_id = ud_ve_element.muni_id;

CREATE OR REPLACE VIEW publi.v_ud_exploitation AS
SELECT expl_id,
       name,
       'EXPLOITATION'::text AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ud_ve_exploitation;

CREATE OR REPLACE VIEW publi.v_ud_gully AS
SELECT ud_ve_gully.gully_id,
       ud_ve_gully.top_elev,
       ud_ve_gully.ymax,
       ud_ve_gully.gully_type,
       ud_ve_gully.gullycat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ud_ve_exploitation.name AS expl_id,
       ud_ve_gully.macroexpl_id,
       ud_ve_municipality.name AS muni_id,
       ud_ve_dwfzone.name AS dwfzone_id,
       ud_ve_drainzone.name AS drainzone_id,
       ud_ve_gully.builtdate,
       ud_ve_gully.the_geom
FROM publi.ud_ve_gully
JOIN ud.value_state ON value_state.id = ud_ve_gully.state
JOIN ud.value_state_type ON value_state_type.id = ud_ve_gully.state_type
JOIN publi.ud_ve_exploitation ON ud_ve_exploitation.expl_id = ud_ve_gully.expl_id
JOIN publi.ud_ve_municipality ON ud_ve_municipality.muni_id = ud_ve_gully.muni_id
LEFT JOIN publi.ud_ve_dwfzone ON ud_ve_dwfzone.dwfzone_id = ud_ve_gully.dwfzone_id
LEFT JOIN publi.ud_ve_drainzone ON ud_ve_drainzone.drainzone_id = ud_ve_gully.drainzone_id;

CREATE OR REPLACE VIEW publi.v_ud_link AS
SELECT ud_ve_link.link_id,
       ud_ve_link.feature_id,
       ud_ve_link.feature_type,
       ud_ve_link.top_elev1,
       ud_ve_link.y1,
       ud_ve_link.elevation1,
       ud_ve_link.exit_id,
       ud_ve_link.exit_type,
       ud_ve_link.top_elev2,
       ud_ve_link.y2,
       ud_ve_link.elevation2,
       ud_ve_link.linkcat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ud_ve_exploitation.name AS expl_id,
       ud_ve_link.macroexpl_id,
       ud_ve_municipality.name AS muni_id,
       ud_ve_dwfzone.name AS dwfzone_id,
       ud_ve_drainzone.name AS drainzone_id,
       ud_ve_link.builtdate,
       ud_ve_link.the_geom
FROM publi.ud_ve_link
JOIN ud.value_state ON value_state.id = ud_ve_link.state
LEFT JOIN ud.value_state_type ON value_state_type.id = ud_ve_link.state_type
JOIN publi.ud_ve_exploitation ON ud_ve_exploitation.expl_id = ud_ve_link.expl_id
JOIN publi.ud_ve_municipality ON ud_ve_municipality.muni_id = ud_ve_link.muni_id
LEFT JOIN publi.ud_ve_dwfzone ON ud_ve_dwfzone.dwfzone_id = ud_ve_link.dwfzone_id
LEFT JOIN publi.ud_ve_drainzone ON ud_ve_drainzone.drainzone_id = ud_ve_link.drainzone_id;

CREATE OR REPLACE VIEW publi.v_ud_macrosector AS
SELECT macrosector_id,
       name,
       'MACROSECTOR'::text AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ud_ve_macrosector;

CREATE OR REPLACE VIEW publi.v_ud_municipality AS
SELECT muni_id,
       name,
       'MUNICIPALITY'::text AS type,
       observ,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ud_ve_municipality;


CREATE OR REPLACE VIEW publi.v_ud_node AS
SELECT ud_ve_node.node_id,
       ud_ve_node.sys_top_elev,
       ud_ve_node.sys_ymax,
       ud_ve_node.sys_elev,
       ud_ve_node.node_type,
       ud_ve_node.nodecat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ud_ve_exploitation.name AS expl_id,
       ud_ve_node.macroexpl_id,
       ud_ve_municipality.name AS muni_id,
       ud_ve_dwfzone.name AS dwfzone_id,
       ud_ve_drainzone.name AS drainzone_id,
       ud_ve_node.builtdate,
       ud_ve_node.the_geom
FROM publi.ud_ve_node
JOIN ud.value_state ON value_state.id = ud_ve_node.state
JOIN ud.value_state_type ON value_state_type.id = ud_ve_node.state_type
JOIN publi.ud_ve_exploitation ON ud_ve_exploitation.expl_id = ud_ve_node.expl_id
JOIN publi.ud_ve_municipality ON ud_ve_municipality.muni_id = ud_ve_node.muni_id
LEFT JOIN publi.ud_ve_dwfzone ON ud_ve_dwfzone.dwfzone_id = ud_ve_node.dwfzone_id
LEFT JOIN publi.ud_ve_drainzone ON ud_ve_drainzone.drainzone_id = ud_ve_node.drainzone_id;

CREATE OR REPLACE VIEW publi.v_ud_sector AS
SELECT sector_id,
       name,
       sector_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ud_ve_sector;

CREATE OR REPLACE VIEW publi.v_ws_arc AS
SELECT ws_ve_arc.arc_id,
       ws_ve_arc.node_1,
       ws_ve_arc.elevation1,
       ws_ve_arc.depth1,
       ws_ve_arc.node_2,
       ws_ve_arc.elevation2,
       ws_ve_arc.depth2,
       ws_ve_arc.arccat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ws_ve_exploitation.name AS expl_id,
       ws_ve_municipality.name AS muni_id,
       ws_ve_macroexploitation.name AS macroexpl_id,
       ws_ve_presszone.name AS presszone_id,
       ws_ve_dma.name AS dma_id,
       ws_ve_arc.builtdate,
       ws_ve_arc.ownercat_id,
       ws_ve_arc.the_geom
FROM publi.ws_ve_arc
JOIN ws.value_state ON value_state.id = ws_ve_arc.state
JOIN ws.value_state_type ON value_state_type.id = ws_ve_arc.state_type
JOIN publi.ws_ve_exploitation ON ws_ve_exploitation.expl_id = ws_ve_arc.expl_id
JOIN publi.ws_ve_municipality ON ws_ve_municipality.muni_id = ws_ve_arc.muni_id
JOIN publi.ws_ve_macroexploitation ON ws_ve_macroexploitation.macroexpl_id = ws_ve_arc.macroexpl_id
LEFT JOIN publi.ws_ve_presszone ON ws_ve_presszone.presszone_id = ws_ve_arc.presszone_id
LEFT JOIN publi.ws_ve_dma ON ws_ve_dma.dma_id = ws_ve_arc.dma_id;

CREATE OR REPLACE VIEW publi.v_ws_connec AS
SELECT ws_ve_connec.connec_id,
       ws_ve_connec.top_elev,
       ws_ve_connec.depth,
       ws_ve_connec.connec_type,
       ws_ve_connec.conneccat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ws_ve_exploitation.name AS expl_id,
       ws_ve_municipality.name AS muni_id,
       ws_ve_macroexploitation.name AS macroexpl_id,
       ws_ve_presszone.name AS presszone_id,
       ws_ve_dma.name AS dma_id,
       ws_ve_connec.builtdate,
       ws_ve_connec.ownercat_id,
       ws_ve_connec.the_geom
FROM publi.ws_ve_connec
JOIN ws.value_state ON value_state.id = ws_ve_connec.state
JOIN ws.value_state_type ON value_state_type.id = ws_ve_connec.state_type
JOIN publi.ws_ve_exploitation ON ws_ve_exploitation.expl_id = ws_ve_connec.expl_id
JOIN publi.ws_ve_municipality ON ws_ve_municipality.muni_id = ws_ve_connec.muni_id
JOIN publi.ws_ve_macroexploitation ON ws_ve_macroexploitation.macroexpl_id = ws_ve_connec.macroexpl_id
LEFT JOIN publi.ws_ve_presszone ON ws_ve_presszone.presszone_id = ws_ve_connec.presszone_id
LEFT JOIN publi.ws_ve_dma ON ws_ve_dma.dma_id = ws_ve_connec.dma_id;

CREATE OR REPLACE VIEW publi.v_ws_dma AS
SELECT dma_id,
       name,
       dma_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_dma;

CREATE OR REPLACE VIEW publi.v_ws_dqa AS
SELECT dqa_id,
       name,
       dqa_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_dqa;

CREATE OR REPLACE VIEW publi.v_ws_element AS
SELECT ws_ve_element.element_id,
       ws_ve_element.top_elev,
       ws_ve_element.element_type,
       ws_ve_element.elementcat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ws_ve_exploitation.name AS expl_id,
       ws_ve_municipality.name AS muni_id,
       ws_ve_element.builtdate,
       ws_ve_element.ownercat_id,
       ws_ve_element.the_geom
FROM publi.ws_ve_element
JOIN ws.value_state ON value_state.id = ws_ve_element.state
LEFT JOIN ws.value_state_type ON value_state_type.id = ws_ve_element.state_type
JOIN publi.ws_ve_exploitation ON ws_ve_exploitation.expl_id = ws_ve_element.expl_id
JOIN publi.ws_ve_municipality ON ws_ve_municipality.muni_id = ws_ve_element.muni_id;

CREATE OR REPLACE VIEW publi.v_ws_link AS
SELECT ws_ve_link.link_id,
       ws_ve_link.feature_id,
       ws_ve_link.feature_type,
       ws_ve_link.top_elev1,
       ws_ve_link.depth1,
       ws_ve_link.elevation1,
       ws_ve_link.exit_id,
       ws_ve_link.exit_type,
       ws_ve_link.top_elev2,
       ws_ve_link.depth2,
       ws_ve_link.elevation2,
       ws_ve_link.linkcat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ws_ve_exploitation.name AS expl_id,
       ws_ve_municipality.name AS muni_id,
       ws_ve_presszone.name AS presszone_id,
       ws_ve_dma.name AS dma_id,
       ws_ve_link.builtdate,
       ws_ve_link.the_geom
FROM publi.ws_ve_link
JOIN ws.value_state ON value_state.id = ws_ve_link.state
LEFT JOIN ws.value_state_type ON value_state_type.id = ws_ve_link.state_type
JOIN publi.ws_ve_exploitation ON ws_ve_exploitation.expl_id = ws_ve_link.expl_id
JOIN publi.ws_ve_municipality ON ws_ve_municipality.muni_id = ws_ve_link.muni_id
LEFT JOIN publi.ws_ve_presszone ON ws_ve_presszone.presszone_id = ws_ve_link.presszone_id
LEFT JOIN publi.ws_ve_dma ON ws_ve_dma.dma_id = ws_ve_link.dma_id;

CREATE OR REPLACE VIEW publi.v_ws_macroexploitation AS
SELECT macroexpl_id,
       name,
       'MACROEXPLOITATION'::text AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_macroexploitation;

CREATE OR REPLACE VIEW publi.v_ws_exploitation AS
SELECT expl_id,
       name,
       'EXPLOITATION'::text AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_exploitation;

CREATE OR REPLACE VIEW publi.v_ws_macrosector AS
SELECT macrosector_id,
       name,
       'MACROSECTOR'::text AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_macrosector;

CREATE OR REPLACE VIEW publi.v_ws_municipality AS
SELECT muni_id,
       name,
       'MUNICIPALITY'::text AS type,
       observ,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_municipality;

CREATE OR REPLACE VIEW publi.v_ws_node AS
SELECT ws_ve_node.node_id,
       ws_ve_node.top_elev,
       ws_ve_node.depth,
       ws_ve_node.node_type,
       ws_ve_node.nodecat_id,
       value_state.name AS state,
       value_state_type.name AS state_type,
       ws_ve_exploitation.name AS expl_id,
       ws_ve_municipality.name AS muni_id,
       ws_ve_macroexploitation.name AS macroexpl_id,
       ws_ve_presszone.name AS presszone_id,
       ws_ve_dma.name AS dma_id,
       ws_ve_node.builtdate,
       ws_ve_node.ownercat_id,
       ws_ve_node.the_geom
FROM publi.ws_ve_node
JOIN ws.value_state ON value_state.id = ws_ve_node.state
JOIN ws.value_state_type ON value_state_type.id = ws_ve_node.state_type
JOIN publi.ws_ve_exploitation ON ws_ve_exploitation.expl_id = ws_ve_node.expl_id
JOIN publi.ws_ve_municipality ON ws_ve_municipality.muni_id = ws_ve_node.muni_id
JOIN publi.ws_ve_macroexploitation ON ws_ve_macroexploitation.macroexpl_id = ws_ve_node.macroexpl_id
LEFT JOIN publi.ws_ve_presszone ON ws_ve_presszone.presszone_id = ws_ve_node.presszone_id
LEFT JOIN publi.ws_ve_dma ON ws_ve_dma.dma_id = ws_ve_node.dma_id;

CREATE OR REPLACE VIEW publi.v_ws_presszone AS
SELECT presszone_id,
       name,
       presszone_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_presszone;

CREATE OR REPLACE VIEW publi.v_ws_sector AS
SELECT sector_id,
       name,
       sector_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_sector;

CREATE OR REPLACE VIEW publi.v_ws_supplyzone AS
SELECT supplyzone_id,
       name,
       supplyzone_type AS type,
       descript,
       (ST_Dump(the_geom)).geom AS geom
FROM publi.ws_ve_supplyzone;
