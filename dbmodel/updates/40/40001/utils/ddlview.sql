/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS vp_basic_arc;
DROP VIEW IF EXISTS vp_basic_node;
DROP VIEW IF EXISTS vp_basic_connec;
DROP VIEW IF EXISTS vp_basic_gully;

DROP VIEW IF EXISTS v_edit_exploitation;
DROP VIEW IF EXISTS v_edit_macrodqa;
DROP VIEW IF EXISTS v_edit_macrodma;
DROP VIEW IF EXISTS v_edit_macrosector;
DROP VIEW IF EXISTS v_edit_sector;
DROP VIEW IF EXISTS v_ui_sector;

DROP VIEW IF EXISTS v_state_element;
DROP VIEW IF EXISTS v_state_arc;
DROP VIEW IF EXISTS v_state_node;
DROP VIEW IF EXISTS v_state_connec;
DROP VIEW IF EXISTS v_state_link;
DROP VIEW IF EXISTS v_state_link_connec;

DROP VIEW IF EXISTS v_edit_flwreg CASCADE;
DROP VIEW IF EXISTS v_edit_inp_frpump CASCADE;
DROP VIEW IF EXISTS v_edit_inp_dscenario_frpump CASCADE;

DROP VIEW IF EXISTS vi_controls;
DROP VIEW IF EXISTS vi_coordinates;
DROP VIEW IF EXISTS vi_curves;
DROP VIEW IF EXISTS vi_demands;
DROP VIEW IF EXISTS vi_emitters;
DROP VIEW IF EXISTS vi_junctions;
DROP VIEW IF EXISTS vi_labels;
DROP VIEW IF EXISTS vi_mixing;
DROP VIEW IF EXISTS vi_patterns;
DROP VIEW IF EXISTS vi_pipes;
DROP VIEW IF EXISTS vi_pumps;
DROP VIEW IF EXISTS vi_reservoirs;
DROP VIEW IF EXISTS vi_rules;
DROP VIEW IF EXISTS vi_sources;
DROP VIEW IF EXISTS vi_status;
DROP VIEW IF EXISTS vi_tags;
DROP VIEW IF EXISTS vi_tanks;
DROP VIEW IF EXISTS vi_title;
DROP VIEW IF EXISTS vi_valves;
DROP VIEW IF EXISTS vi_vertices;

DROP VIEW IF EXISTS vi_adjustments;
DROP VIEW IF EXISTS vi_aquifers;
DROP VIEW IF EXISTS vi_buildup;
DROP VIEW IF EXISTS vi_evaporation;
DROP VIEW IF EXISTS vi_files;
DROP VIEW IF EXISTS vi_gully;
DROP VIEW IF EXISTS vi_hydrographs;
DROP VIEW IF EXISTS vi_inflows;
DROP VIEW IF EXISTS vi_landuses;
DROP VIEW IF EXISTS vi_lid_controls;
DROP VIEW IF EXISTS vi_map;
-- DROP VIEW IF EXISTS vi_pollutants; -- TODO: refactor gw_fct_rpt2pg_import_rpt
DROP VIEW IF EXISTS vi_polygons;
DROP VIEW IF EXISTS vi_raingages;
DROP VIEW IF EXISTS vi_rdii;
DROP VIEW IF EXISTS vi_snowpacks;
DROP VIEW IF EXISTS vi_symbols;
DROP VIEW IF EXISTS vi_temperature;
DROP VIEW IF EXISTS vi_transects;
DROP VIEW IF EXISTS vi_treatment;
DROP VIEW IF EXISTS vi_washoff;

DROP VIEW IF EXISTS vu_dma;
DROP VIEW IF EXISTS vu_link;
DROP VIEW IF EXISTS vu_arc;
DROP VIEW IF EXISTS vu_node;

DROP VIEW IF EXISTS v_sector_node;


CREATE OR REPLACE VIEW v_edit_cat_feature_link
AS SELECT cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature.code_autofill,
    cat_feature.shortcut_key,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_link USING (id);


  CREATE OR REPLACE VIEW v_edit_cat_feature_element
AS SELECT
	cat_feature.id,
    cat_feature.feature_class AS system_id,
    cat_feature_element.epa_default,
    cat_feature.code_autofill,
    cat_feature.shortcut_key ,
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_element USING (id);


-- ====================

CREATE OR REPLACE VIEW ve_frelem AS
  SELECT element.element_id,
    element.code,
    element.sys_code,
    element.top_elev,
    element.elementcat_id,
    cat_element.element_type,
    element.epa_type,
    element.state,
    element.state_type,
    element.pol_id,
    element.expl_id,
    element.muni_id,
    element.sector_id,
    element.num_elements,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.observ,
    element.comment,
    cat_element.link,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.rotation,
    element.verified,
    element.datasource,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.inventory,
    element.publish,
    element.expl_visibility,
    element.trace_featuregeom,
    element.lock_level,
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by,
    element.omzone_id,
    man_frelem.node_id,
    man_frelem.order_id,
    concat (man_frelem.node_id,'_FR', man_frelem.order_id) AS nodarc_id,
    man_frelem.to_arc,
    man_frelem.flwreg_length,
    element.the_geom,
    st_x(st_endpoint(st_setsrid(st_makeline(element.the_geom, st_lineinterpolatepoint(a.the_geom, flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE))) AS symbol_x,
    st_y(st_endpoint(st_setsrid(st_makeline(element.the_geom, st_lineinterpolatepoint(a.the_geom, flwreg_length / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE))) AS symbol_y
    FROM element
    JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
    JOIN man_frelem ON element.element_id::text = man_frelem.element_id::text
    LEFT JOIN selector_sector s USING (sector_id)
    LEFT JOIN selector_expl e using (expl_id)
	  JOIN arc a ON arc_id = to_arc
    WHERE element.expl_id = e.expl_id
    AND s.cur_user = "current_user"()::text AND e.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_genelem AS
SELECT e.* FROM (
SELECT element.element_id,
    element.code,
    element.sys_code,
    element.top_elev,
    element.elementcat_id,
    cat_element.element_type,
    element.pol_id,
    element.expl_id,
    element.muni_id,
    element.sector_id,
    element.omzone_id,
    element.epa_type,
    element.state,
    element.state_type,
    element.num_elements,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.observ,
    element.comment,
    element.link,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.asset_id,
    element.verified,
    element.datasource,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.rotation,
    element.inventory,
    element.publish,
    element.trace_featuregeom,
    element.lock_level,
    element.expl_visibility,
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by,
    element.the_geom
   FROM selector_expl, element
    JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
    LEFT JOIN cat_feature_element ON cat_element.element_type::text = cat_feature_element.id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) e
  LEFT JOIN selector_sector s USING (sector_id)
  LEFT JOIN selector_municipality m USING (muni_id)
  JOIN man_genelem USING (element_id)
  WHERE (s.cur_user = current_user OR s.sector_id IS NULL)
  AND (m.cur_user = current_user OR e.muni_id IS NULL);

CREATE OR REPLACE VIEW v_ext_raster_dem
AS SELECT DISTINCT ON (r.id) r.id,
    c.code,
    c.alias,
    c.raster_type,
    c.descript,
    c.source,
    c.provider,
    c.year,
    r.rast,
    r.rastercat_id,
    r.envelope
    FROM v_ext_municipality a, ext_raster_dem r
    JOIN ext_cat_raster c ON c.id = r.rastercat_id
    WHERE st_dwithin(r.envelope, a.the_geom, 0::double precision);


CREATE OR REPLACE VIEW ve_pol_element
AS SELECT e.pol_id,
    e.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM element e
    JOIN polygon USING (pol_id);

CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN connec ON polygon.feature_id = connec.connec_id
    LEFT JOIN plan_psector_x_connec pp ON polygon.feature_id = pp.connec_id
    JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = connec.expl_id) or (se.cur_user =current_user and se.expl_id = ANY(connec.expl_visibility))
    JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = connec.sector_id)
    JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
    JOIN selector_state ss ON ss.cur_user = current_user AND connec.state = ss.state_id;

CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    LEFT JOIN plan_psector_x_node pp ON polygon.feature_id = pp.node_id
    JOIN node ON polygon.feature_id = node.node_id
    JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = node.expl_id) or (se.cur_user =current_user and se.expl_id = ANY(node.expl_visibility))
    JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = node.sector_id)
    JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
    JOIN selector_state ss ON ss.cur_user = current_user AND node.state = ss.state_id;


CREATE OR REPLACE VIEW v_ui_element_x_link
AS SELECT
    element_x_link.link_id,
    element_x_link.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
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
    element.link,
    element.publish,
    element.inventory
   FROM element_x_link
     JOIN element ON element.element_id::text = element_x_link.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT element_x_node.node_id,
    element_x_node.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
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
    element.link,
    element.publish,
    element.inventory
   FROM element_x_node
     JOIN element ON element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT element_x_connec.connec_id,
    element_x_connec.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
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
    element.link,
    element.publish,
    element.inventory
   FROM element_x_connec
     JOIN element ON element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::TEXT
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT element_x_arc.arc_id,
    element_x_arc.element_id,
    cat_feature.feature_class,
    cat_element.element_type,
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
    element.link,
    element.publish,
    element.inventory
   FROM element_x_arc
     JOIN element ON element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON element.state = value_state.id
     LEFT JOIN value_state_type ON element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

-- PSECTORS
CREATE OR REPLACE VIEW v_plan_psector_node
AS SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    cat_node.node_type,
    cat_feature.feature_class,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    plan_psector.priority AS psector_priority,
    node.the_geom
   FROM selector_psector,
    node
     JOIN plan_psector_x_node USING (node_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
  WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

  CREATE OR REPLACE VIEW v_plan_psector_connec
AS SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.conneccat_id,
    cat_connec.connec_type,
    cat_feature.feature_class,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    plan_psector.priority AS psector_priority,
    connec.the_geom
   FROM selector_psector,
    connec
     JOIN plan_psector_x_connec USING (connec_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
  WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_psector_arc
AS SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    cat_arc.arc_type,
    cat_feature.feature_class,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    plan_psector.priority AS psector_priority,
    arc.the_geom
   FROM selector_psector,
    arc
     JOIN plan_psector_x_arc USING (arc_id)
     JOIN plan_psector USING (psector_id)
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
  WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ui_plan_psector
AS SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.workcat_id,
    plan_psector.parent_id
   FROM selector_expl,
    plan_psector
     JOIN exploitation USING (expl_id)
     LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
     LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
     LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_ui_om_visit
AS SELECT om_visit.id,
    om_visit_cat.name AS visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name AS exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.visit_type
   FROM om_visit
     LEFT JOIN om_visit_cat ON om_visit.visitcat_id = om_visit_cat.id
     LEFT JOIN exploitation ON exploitation.expl_id = om_visit.expl_id;

CREATE OR REPLACE VIEW v_ext_streetaxis
AS SELECT ext_streetaxis.id,
    ext_streetaxis.code,
    ext_streetaxis.type,
    ext_streetaxis.name,
    ext_streetaxis.text,
    ext_streetaxis.the_geom,
    ext_streetaxis.expl_id,
    ext_streetaxis.muni_id,
        CASE
            WHEN ext_streetaxis.type IS NULL THEN ext_streetaxis.name::text
            WHEN ext_streetaxis.text IS NULL THEN ((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '.'::text
            WHEN ext_streetaxis.type IS NULL AND ext_streetaxis.text IS NULL THEN ext_streetaxis.name::text
            ELSE (((ext_streetaxis.name::text || ', '::text) || ext_streetaxis.type::text) || '. '::text) || ext_streetaxis.text
        END AS descript,
    ext_streetaxis.source
   FROM selector_municipality s, ext_streetaxis
   WHERE ext_streetaxis.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_ext_municipality
AS SELECT DISTINCT s.muni_id,
    m.name,
    m.active,
    m.the_geom
    FROM ext_municipality m, selector_municipality s
    WHERE m.muni_id = s.muni_id AND s.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN connec ON polygon.feature_id::text = connec.connec_id::text
    JOIN selector_expl se ON (se.cur_user = CURRENT_USER AND se.expl_id = connec.expl_id) or (se.cur_user = CURRENT_USER and se.expl_id = ANY(connec.expl_visibility))
    JOIN selector_sector ss ON (ss.cur_user = CURRENT_USER AND ss.sector_id = connec.sector_id)
    JOIN selector_municipality sm ON (sm.cur_user = CURRENT_USER AND sm.muni_id = connec.muni_id);

CREATE OR REPLACE VIEW ve_pol_node
AS SELECT polygon.pol_id,
    polygon.feature_id,
    polygon.featurecat_id,
    polygon.state,
    polygon.sys_type,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN node ON polygon.feature_id::text = node.node_id::text
    JOIN selector_expl se ON (se.cur_user =CURRENT_USER AND se.expl_id = node.expl_id) or (se.cur_user = CURRENT_USER and se.expl_id = ANY(node.expl_visibility))
    JOIN selector_sector ss ON (ss.cur_user = CURRENT_USER AND ss.sector_id = node.sector_id)
    JOIN selector_municipality sm ON (sm.cur_user = CURRENT_USER AND sm.muni_id = node.muni_id);

CREATE OR REPLACE VIEW ve_pol_element
AS SELECT element.pol_id,
    element.element_id,
    polygon.the_geom,
    polygon.trace_featuregeom
    FROM polygon
    JOIN element ON polygon.feature_id::text = element.element_id::text
    JOIN selector_expl se ON (se.cur_user =CURRENT_USER AND se.expl_id = element.expl_id) or (se.cur_user = CURRENT_USER and se.expl_id = ANY(element.expl_visibility))
    JOIN selector_sector ss ON (ss.cur_user = CURRENT_USER AND ss.sector_id = element.sector_id)
    JOIN selector_municipality sm ON (sm.cur_user = CURRENT_USER AND sm.muni_id = element.muni_id);

CREATE OR REPLACE VIEW v_ui_element
AS SELECT element.element_id AS id,
    element.code,
    cat_feature.feature_class,
    cat_element.element_type,
    element.elementcat_id,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.num_elements,
    element.state,
    element.state_type,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.fluid_type,
    element.location_type,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.expl_id,
    element.the_geom,
    element.feature_type,
    element.created_at,
    element.created_by,
    element.updated_at,
    element.updated_by
   FROM element
     LEFT JOIN cat_element ON cat_element.id::text = element.elementcat_id::text
     JOIN cat_feature_element cfe ON cfe.id::text = cat_element.element_type::text
     JOIN cat_feature ON cat_feature.id::text = cfe.id::text;

CREATE OR REPLACE VIEW v_state_arc
AS WITH p AS (
         SELECT plan_psector_x_arc.arc_id,
            plan_psector_x_arc.psector_id,
            plan_psector_x_arc.state
           FROM plan_psector_x_arc
          WHERE plan_psector_x_arc.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), s AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), a AS (
         SELECT arc.arc_id,
            arc.state
           FROM arc
        )
(
         SELECT arc.arc_id
           FROM selector_state,
            arc
          WHERE arc.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.arc_id
           FROM s,
            p
          WHERE p.psector_id = s.psector_id AND p.state = 0
) UNION ALL
 SELECT DISTINCT p.arc_id
   FROM s,
    p
  WHERE p.psector_id = s.psector_id AND p.state = 1;

CREATE OR REPLACE VIEW v_state_node
AS WITH p AS (
         SELECT plan_psector_x_node.node_id,
            plan_psector_x_node.psector_id,
            plan_psector_x_node.state
           FROM plan_psector_x_node
          WHERE plan_psector_x_node.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), s AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), n AS (
         SELECT node.node_id,
            node.state
           FROM node
        )
(
         SELECT n.node_id
           FROM selector_state,
            n
          WHERE n.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.node_id
           FROM s,
            p,
            cf
          WHERE p.psector_id = s.psector_id AND p.state = 0 AND cf.value IS TRUE
) UNION ALL
 SELECT DISTINCT p.node_id
   FROM s,
    p,
    cf
  WHERE p.psector_id = s.psector_id AND p.state = 1 AND cf.value IS TRUE;


CREATE OR REPLACE VIEW v_state_link
AS WITH p AS (
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.psector_id,
            plan_psector_x_connec.state,
            plan_psector_x_connec.link_id
           FROM plan_psector_x_connec
          WHERE plan_psector_x_connec.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), sp AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), se AS (
         SELECT selector_expl.expl_id,
            selector_expl.cur_user
           FROM selector_expl
          WHERE selector_expl.cur_user = CURRENT_USER
        ), l AS (
         SELECT link.link_id,
            link.state,
            link.expl_id,
            link.expl_visibility
           FROM link
        )
        (
         SELECT l.link_id
           FROM selector_state,
            se,
            l
          WHERE l.state = selector_state.state_id AND (l.expl_id = se.expl_id OR l.expl_id = ANY(l.expl_visibility)) AND selector_state.cur_user = "current_user"()::text AND se.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.link_id
           FROM cf,
            sp,
            se,
            p
             JOIN l USING (link_id)
          WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 0 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value IS TRUE
        ) UNION ALL
        SELECT p.link_id
          FROM cf,
            sp,
            se,
            p
            JOIN l USING (link_id)
          WHERE p.psector_id = sp.psector_id AND sp.cur_user = "current_user"()::text AND p.state = 1 AND l.expl_id = se.expl_id AND se.cur_user = CURRENT_USER::text AND cf.value IS TRUE;

CREATE OR REPLACE VIEW v_state_element
AS SELECT element.element_id
   FROM selector_state,
    element
  WHERE element.state = selector_state.state_id AND selector_state.cur_user = CURRENT_USER;


CREATE OR REPLACE VIEW v_state_connec
AS WITH p AS (
         SELECT plan_psector_x_connec.connec_id,
            plan_psector_x_connec.psector_id,
            plan_psector_x_connec.state,
            plan_psector_x_connec.arc_id
           FROM plan_psector_x_connec
          WHERE plan_psector_x_connec.active
        ), cf AS (
         SELECT config_param_user.value::boolean AS value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'utils_psector_strategy'::text AND config_param_user.cur_user::text = CURRENT_USER
        ), s AS (
         SELECT selector_psector.psector_id,
            selector_psector.cur_user
           FROM selector_psector
          WHERE selector_psector.cur_user = CURRENT_USER
        ), c AS (
         SELECT connec.connec_id,
            connec.state,
            connec.arc_id
           FROM connec
        )
(
         SELECT c.connec_id,
            c.arc_id
           FROM selector_state,
            c
          WHERE c.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text
        EXCEPT ALL
         SELECT p.connec_id,
            p.arc_id
           FROM cf,
            s,
            p
          WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 0 AND cf.value IS TRUE
) UNION ALL
 SELECT DISTINCT ON (p.connec_id) p.connec_id,
    p.arc_id
   FROM cf,
    s,
    p
  WHERE p.psector_id = s.psector_id AND s.cur_user = "current_user"()::text AND p.state = 1 AND cf.value IS TRUE;


CREATE OR REPLACE VIEW v_ui_doc_x_element
AS SELECT doc_x_element.doc_id,
  doc_x_element.element_id,
  doc.name as doc_name,
  doc.doc_type,
  doc.path,
  doc.observ,
  doc.date,
  doc.user_name
FROM doc_x_element
  JOIN doc ON doc.id::text = doc_x_element.doc_id::text;
