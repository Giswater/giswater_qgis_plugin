/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_inp_dscenario_frpump;

CREATE OR REPLACE VIEW ve_inp_dscenario_frpump
AS SELECT s.dscenario_id,
    f.element_id,
    n.node_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_frpump f
    JOIN ve_inp_frpump n USING (element_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;


CREATE OR REPLACE VIEW v_ui_arc_x_relations
AS WITH links_node AS (
         SELECT n.node_id,
            l.feature_id,
            l.exit_type AS proceed_from,
            l.exit_id AS proceed_from_id,
            l.state AS l_state,
            n.state AS n_state
           FROM node n
             JOIN link l ON n.node_id = l.exit_id
          WHERE l.state = 1
        )
 SELECT row_number() OVER () + 1000000 AS rid,
    ve_connec.arc_id,
    ve_connec.connec_type AS featurecat_id,
    ve_connec.conneccat_id AS catalog,
    ve_connec.connec_id AS feature_id,
    ve_connec.code AS feature_code,
    ve_connec.sys_type,
    a.state AS arc_state,
    ve_connec.state AS feature_state,
    st_x(ve_connec.the_geom) AS x,
    st_y(ve_connec.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM ve_connec
     JOIN link l ON ve_connec.connec_id = l.feature_id
     JOIN arc a ON a.arc_id = ve_connec.arc_id
  WHERE ve_connec.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (c.connec_id) row_number() OVER () + 2000000 AS rid,
    a.arc_id,
    c.connec_type AS featurecat_id,
    c.conneccat_id AS catalog,
    c.connec_id AS feature_id,
    c.code AS feature_code,
    c.sys_type,
    a.state AS arc_state,
    c.state AS feature_state,
    st_x(c.the_geom) AS x,
    st_y(c.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    've_connec'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN ve_connec c ON c.connec_id = n.feature_id
UNION
 SELECT row_number() OVER () + 3000000 AS rid,
    ve_gully.arc_id,
    ve_gully.gully_type AS featurecat_id,
    ve_gully.gullycat_id AS catalog,
    ve_gully.gully_id AS feature_id,
    ve_gully.code AS feature_code,
    ve_gully.sys_type,
    a.state AS arc_state,
    ve_gully.state AS feature_state,
    st_x(ve_gully.the_geom) AS x,
    st_y(ve_gully.the_geom) AS y,
    l.exit_type AS proceed_from,
    l.exit_id AS proceed_from_id,
    've_gully'::text AS sys_table_id
   FROM ve_gully
     JOIN link l ON ve_gully.gully_id = l.feature_id
     JOIN arc a ON a.arc_id = ve_gully.arc_id
  WHERE ve_gully.arc_id IS NOT NULL AND l.exit_type::text <> 'NODE'::text AND l.state = 1 AND a.state = 1
UNION
 SELECT DISTINCT ON (g.gully_id) row_number() OVER () + 4000000 AS rid,
    a.arc_id,
    g.gully_type AS featurecat_id,
    g.gullycat_id AS catalog,
    g.gully_id AS feature_id,
    g.code AS feature_code,
    g.sys_type,
    a.state AS arc_state,
    g.state AS feature_state,
    st_x(g.the_geom) AS x,
    st_y(g.the_geom) AS y,
    n.proceed_from,
    n.proceed_from_id,
    've_gully'::text AS sys_table_id
   FROM arc a
     JOIN links_node n ON a.node_1 = n.node_id
     JOIN ve_gully g ON g.gully_id = n.feature_id;


CREATE OR REPLACE VIEW v_element_x_gully
AS SELECT element_x_gully.gully_id,
    element_x_gully.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate,
    element.serial_number,
    element.brand_id,
    element.model_id,
    element.updated_at
   FROM element_x_gully
     JOIN element ON element.element_id::text = element_x_gully.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text;

DROP VIEW IF EXISTS v_ui_element_x_gully;
CREATE OR REPLACE VIEW v_ui_element_x_gully
AS SELECT element_x_gully.gully_id,
    element_x_gully.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    element.epa_type,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate
   FROM element_x_gully
     JOIN element ON element.element_id = element_x_gully.element_id
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

-- 25/08/2025
CREATE OR REPLACE VIEW v_ui_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    et.idval AS omzone_type,
    o.macroomzone_id,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
   FROM selector_expl se, omzone o
     LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
  WHERE se.expl_id = ANY(o.expl_id) AND se.cur_user = CURRENT_USER AND o.omzone_id > 0
  ORDER BY o.omzone_id;

CREATE OR REPLACE VIEW ve_omzone
AS SELECT DISTINCT ON (o.omzone_id) o.omzone_id,
    o.code,
    o.name,
    o.descript,
    o.active,
    et.idval AS omzone_type,
    o.macroomzone_id,
    o.expl_id,
    o.sector_id,
    o.muni_id,
    o.graphconfig,
    o.stylesheet,
    o.lock_level,
    o.link,
    o.the_geom,
    o.addparam,
    o.created_at,
    o.created_by,
    o.updated_at,
    o.updated_by
   FROM selector_expl se, omzone o
     LEFT JOIN edit_typevalue et ON et.id::text = o.omzone_type::text AND et.typevalue::text = 'omzone_type'::text
  WHERE se.expl_id = ANY(o.expl_id) AND se.cur_user = CURRENT_USER AND o.omzone_id > 0
  ORDER BY o.omzone_id;

DROP VIEW IF EXISTS v_ui_drainzone;
DROP VIEW IF EXISTS ve_drainzone;
DROP VIEW IF EXISTS v_ui_dwfzone;
DROP VIEW IF EXISTS ve_dwfzone;
DROP VIEW IF EXISTS v_ui_sector;
DROP VIEW IF EXISTS ve_sector;
DROP VIEW IF EXISTS v_ui_dma;
DROP VIEW IF EXISTS ve_dma;
DROP VIEW IF EXISTS v_ui_macrosector;
DROP VIEW IF EXISTS ve_macrosector;
DROP VIEW IF EXISTS v_ui_macroomzone;
DROP VIEW IF EXISTS ve_macroomzone;

CREATE OR REPLACE VIEW v_ui_drainzone
AS SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS drainzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM drainzone d
     LEFT JOIN edit_typevalue et ON et.id::text = d.drainzone_type::text AND et.typevalue::text = 'drainzone_type'::text
  WHERE d.drainzone_id > 0
  ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW ve_drainzone
AS SELECT DISTINCT ON (d.drainzone_id) d.drainzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.drainzone_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM drainzone d WHERE d.drainzone_id > 0
  ORDER BY d.drainzone_id;

CREATE OR REPLACE VIEW v_ui_dwfzone
AS SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dwfzone_type,
    da.name AS drainzone,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dwfzone d
     LEFT JOIN edit_typevalue et ON et.id::text = d.dwfzone_type::text AND et.typevalue::text = 'dwfzone_type'::text
     LEFT JOIN drainzone da ON d.drainzone_id = da.drainzone_id
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dwfzone_id > 0
  ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW ve_dwfzone
AS SELECT DISTINCT ON (d.dwfzone_id) d.dwfzone_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dwfzone_type,
    d.drainzone_id,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dwfzone d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dwfzone_id > 0
  ORDER BY d.dwfzone_id;

CREATE OR REPLACE VIEW v_ui_sector
AS SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    et.idval AS sector_type,
    ms.name AS macrosector,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text,
    s.stylesheet::text,
    s.lock_level,
    s.link,
    s.addparam::text,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
   FROM selector_sector ss, sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
     LEFT JOIN edit_typevalue et ON et.id::text = s.sector_type::text AND et.typevalue::text = 'sector_type'::text
  WHERE ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER AND s.sector_id > 0
  ORDER BY s.sector_id;

CREATE OR REPLACE VIEW ve_sector
AS SELECT s.sector_id,
    s.code,
    s.name,
    s.descript,
    s.active,
    s.sector_type,
    s.macrosector_id,
    s.expl_id,
    s.muni_id,
    s.graphconfig::text,
    s.stylesheet::text,
    s.lock_level,
    s.link,
    s.the_geom,
    s.addparam::text,
    s.created_at,
    s.created_by,
    s.updated_at,
    s.updated_by
   FROM selector_sector ss, sector s
  WHERE ss.sector_id = s.sector_id AND ss.cur_user = CURRENT_USER AND s.sector_id > 0
  ORDER BY s.sector_id;

CREATE OR REPLACE VIEW v_ui_dma
AS SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    et.idval AS dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dma d
     LEFT JOIN edit_typevalue et ON et.id::text = d.dma_type::text AND et.typevalue::text = 'dma_type'::text
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dma_id > 0;

CREATE OR REPLACE VIEW ve_dma
AS SELECT d.dma_id,
    d.code,
    d.name,
    d.descript,
    d.active,
    d.dma_type,
    d.expl_id,
    d.sector_id,
    d.muni_id,
    d.graphconfig::text,
    d.stylesheet::text,
    d.lock_level,
    d.link,
    d.the_geom,
    d.addparam::text,
    d.created_at,
    d.created_by,
    d.updated_at,
    d.updated_by
   FROM selector_expl se, dma d
  WHERE se.expl_id = ANY(d.expl_id) AND se.cur_user = CURRENT_USER AND d.dma_id > 0;

CREATE OR REPLACE VIEW v_ui_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    code,
    name,
    descript,
    active,
    expl_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macrosector m
  WHERE macrosector_id > 0
  ORDER BY macrosector_id;

CREATE OR REPLACE VIEW ve_macrosector
AS SELECT DISTINCT ON (macrosector_id) macrosector_id,
    code,
    name,
    descript,
    active,
    expl_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    the_geom,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macrosector m
  WHERE macrosector_id > 0
  ORDER BY macrosector_id;

CREATE OR REPLACE VIEW v_ui_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macroomzone m
  WHERE macroomzone_id > 0
  ORDER BY macroomzone_id;

CREATE OR REPLACE VIEW ve_macroomzone
AS SELECT DISTINCT ON (macroomzone_id) macroomzone_id,
    code,
    name,
    descript,
    active,
    expl_id,
    sector_id,
    muni_id,
    stylesheet::text,
    lock_level,
    link,
    the_geom,
    addparam::text,
    created_at,
    created_by,
    updated_at,
    updated_by
   FROM macroomzone m
  WHERE macroomzone_id > 0
  ORDER BY macroomzone_id;
