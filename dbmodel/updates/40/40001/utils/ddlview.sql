/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
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
DROP VIEW IF EXISTS v_edit_inp_flwreg_pump CASCADE;
DROP VIEW IF EXISTS v_edit_inp_dscenario_flwreg_pump CASCADE;
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
DROP VIEW IF EXISTS vi_pollutants;
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
    cat_feature.link_path,
    cat_feature.descript,
    cat_feature.active
   FROM cat_feature
     JOIN cat_feature_element USING (id);


-- ====================

CREATE OR REPLACE VIEW v_edit_element AS
SELECT e.* FROM (
SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.element_type,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.top_elev,
    element.expl_id2,
    element.trace_featuregeom,
    element.muni_id,
    element.sector_id,
    element.lock_level,
    element.geometry_type
   FROM selector_expl, element
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) e
  LEFT JOIN selector_sector s USING (sector_id)
  LEFT JOIN selector_municipality m USING (muni_id)
  WHERE (s.cur_user = current_user OR s.sector_id IS NULL)
  AND (m.cur_user = current_user OR e.muni_id IS NULL);

CREATE OR REPLACE VIEW v_edit_genelement AS
SELECT e.* FROM (
SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.element_type,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.top_elev,
    element.expl_id2,
    element.trace_featuregeom,
    element.muni_id,
    element.sector_id,
    element.lock_level,
    element.geometry_type
   FROM selector_expl, element
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN man_genelement USING (element_id)
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text) e
  LEFT JOIN selector_sector s USING (sector_id)
  LEFT JOIN selector_municipality m USING (muni_id)
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
    JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = connec.expl_id) or (se.cur_user =current_user and se.expl_id = connec.expl_id2)
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
    JOIN selector_expl se ON (se.cur_user =current_user AND se.expl_id = node.expl_id) or (se.cur_user =current_user and se.expl_id = node.expl_id2)
    JOIN selector_sector sc ON (sc.cur_user = CURRENT_USER AND sc.sector_id = node.sector_id)
    JOIN selector_psector sp ON sp.cur_user = current_user AND sp.psector_id = pp.psector_id
    JOIN selector_state ss ON ss.cur_user = current_user AND node.state = ss.state_id;


CREATE OR REPLACE VIEW v_ui_element_x_link
AS SELECT
    element_x_link.link_id,
    element_x_link.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_link
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_link.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_node
AS SELECT
    element_x_node.node_id,
    element_x_node.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_node
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_node.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_connec
AS SELECT
    element_x_connec.connec_id,
    element_x_connec.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_connec
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_connec.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element_x_arc
AS SELECT
    element_x_arc.arc_id,
    element_x_arc.element_id,
    v_edit_element.elementcat_id,
    cat_element.descript,
    v_edit_element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    v_edit_element.observ,
    v_edit_element.comment,
    v_edit_element.location_type,
    v_edit_element.builtdate,
    v_edit_element.enddate,
    v_edit_element.link,
    v_edit_element.publish,
    v_edit_element.inventory
   FROM element_x_arc
     JOIN v_edit_element ON v_edit_element.element_id::text = element_x_arc.element_id::text
     JOIN value_state ON v_edit_element.state = value_state.id
     LEFT JOIN value_state_type ON v_edit_element.state_type = value_state_type.id
     LEFT JOIN man_type_location ON man_type_location.location_type::text = v_edit_element.location_type::text AND man_type_location.feature_type::text = 'ELEMENT'::text
     LEFT JOIN cat_element ON cat_element.id::text = v_edit_element.elementcat_id::text;

CREATE OR REPLACE VIEW v_ui_element
AS SELECT element.element_id AS id,
    element.code,
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
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.undelete,
    element.publish,
    element.inventory,
    element.expl_id,
    element.feature_type,
    element.tstamp
   FROM element;


CREATE OR REPLACE VIEW v_edit_flwreg AS
  SELECT element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.element_type,
    man_flwreg.nodarc_id,
    man_flwreg.order_id,
    man_flwreg.to_arc,
    man_flwreg.flwreg_length,
    element.brand_id,
    element.model_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    cat_element.link,
    element.verified,
    element.the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id,
    element.pol_id,
    element.lastupdate,
    element.lastupdate_user,
    element.top_elev,
    element.expl_id2,
    element.trace_featuregeom,
      element.muni_id,
      element.sector_id,
    element.lock_level
   FROM element
      JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
      JOIN man_flwreg ON element.element_id::text = man_flwreg.element_id::text
      LEFT JOIN selector_sector s USING (sector_id)
      LEFT JOIN selector_municipality m USING (muni_id)
      LEFT JOIN selector_expl e using (expl_id)
    WHERE element.expl_id = e.expl_id
    AND s.cur_user = "current_user"()::text AND m.cur_user = "current_user"()::text AND e.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_inp_flwreg_pump
AS SELECT 
    f.element_id,
    f.nodarc_id,
    f.order_id,
    f.to_arc,
    f.flwreg_length,
    p.curve_id,
    p.status,
    p.startup,
    p.shutoff,
    f.the_geom
    FROM v_edit_flwreg f
    JOIN inp_flwreg_pump p ON f.element_id::text = p.element_id::text;

CREATE OR REPLACE VIEW v_edit_inp_dscenario_flwreg_pump
AS SELECT s.dscenario_id,
    f.element_id,
    f.curve_id,
    f.status,
    f.startup,
    f.shutoff,
    n.the_geom
    FROM selector_inp_dscenario s, inp_dscenario_flwreg_pump f
    JOIN v_edit_inp_flwreg_pump n USING (element_id)
    WHERE s.dscenario_id = f.dscenario_id AND s.cur_user = CURRENT_USER::text;


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
