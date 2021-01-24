/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
CREATE OR REPLACE VIEW v_plan_psector_arc AS
SELECT arc.arc_id,
plan_psector_x_arc.psector_id,
arc.code, 
arc.arccat_id,
cat_arc.arc_type,
cat_feature.system_id,
arc.state AS original_state,
arc.state_type AS original_state_type,
plan_psector_x_arc.state AS plan_state,
plan_psector_x_arc.doable,
plan_psector_x_arc.addparam,
arc.the_geom
FROM selector_psector, arc
JOIN plan_psector_x_arc USING (arc_id)
JOIN cat_arc ON cat_arc.id=arc.arccat_id
JOIN cat_feature ON cat_feature.id=cat_arc.arc_type
WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_plan_psector_node AS
SELECT node.node_id,
plan_psector_x_node.psector_id,
node.code, 
node.nodecat_id,
cat_node.node_type,
cat_feature.system_id,
node.state AS original_state,
node.state_type AS original_state_type,
plan_psector_x_node.state AS plan_state,
plan_psector_x_node.doable,
node.the_geom
FROM selector_psector, node
JOIN plan_psector_x_node USING (node_id)
JOIN cat_node ON cat_node.id=node.nodecat_id
JOIN cat_feature ON cat_feature.id=cat_node.node_type
WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_plan_psector_connec AS
SELECT connec.connec_id,
plan_psector_x_connec.psector_id,
connec.code, 
connec.connecat_id,
cat_connec.connec_type,
cat_feature.system_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
connec.the_geom
FROM selector_psector, connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN cat_connec ON cat_connec.id=connec.connecat_id
JOIN cat_feature ON cat_feature.id=cat_connec.connec_type
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_plan_psector_gully AS
SELECT gully.gully_id,
plan_psector_x_gully.psector_id,
gully.code, 
gully.gratecat_id,
cat_grate.gully_type,
cat_feature.system_id,
gully.state AS original_state,
gully.state_type AS original_state_type,
plan_psector_x_gully.state AS plan_state,
plan_psector_x_gully.doable,
gully.the_geom
FROM selector_psector, gully
JOIN plan_psector_x_gully USING (gully_id)
JOIN cat_grate ON cat_grate.id=gully.gratecat_id
JOIN cat_feature ON cat_feature.id=cat_grate.gully_type
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_plan_psector_link AS 
SELECT link.link_id,
plan_psector_x_connec.psector_id,
connec.connec_id AS feature_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
link.the_geom
FROM selector_psector,connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN link ON link.feature_id=connec.connec_id
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text
UNION 
SELECT link.link_id,
plan_psector_x_gully.psector_id,
gully.gully_id AS feature_id,
gully.state AS original_state,
gully.state_type AS original_state_type,
plan_psector_x_gully.state AS plan_state,
plan_psector_x_gully.doable,
link.the_geom
FROM selector_psector,gully
JOIN plan_psector_x_gully USING (gully_id)
JOIN link ON link.feature_id=gully.gully_id
WHERE plan_psector_x_gully.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT node.node_id,
    node.top_elev,
    node.custom_top_elev,
    node.ymax,
    node.custom_ymax,
    node.elev,
    node.custom_elev,
    node.elev AS sys_elev,
    node.nodecat_id,
    node.sector_id,
    macrosector_id,
    node.state,
    node.state_type,
    node.annotation,
    node.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam,
    node.the_geom
   FROM selector_sector,
    node
     JOIN inp_junction USING (node_id)
     JOIN vi_parent_arc a ON node_1 = node_id

  WHERE node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text
UNION
 SELECT node.node_id,
    node.top_elev,
    node.custom_top_elev,
    node.ymax,
    node.custom_ymax,
    node.elev,
    node.custom_elev,
    node.elev AS sys_elev,
    node.nodecat_id,
    node.sector_id,
    macrosector_id,
    node.state,
    node.state_type,
    node.annotation,
    node.expl_id,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam,
    node.the_geom
   FROM selector_sector,
    node
     JOIN inp_junction USING (node_id)
     JOIN vi_parent_arc a ON node_2 = node_id
  WHERE node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


-- 2021/01/08
CREATE OR REPLACE VIEW vi_curves AS 
 SELECT inp_curve_value.curve_id,
    CASE WHEN inp_curve_value.id = (( SELECT min(sub.id) AS min FROM inp_curve_value sub  
	WHERE sub.curve_id::text = inp_curve_value.curve_id::text)) THEN inp_typevalue.idval ELSE NULL::character varying 
	END AS curve_type,
    inp_curve_value.x_value,
    inp_curve_value.y_value
   FROM inp_curve_value
     JOIN inp_curve ON inp_curve.id::text = inp_curve_value.curve_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_curve.curve_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_curve'::text
  ORDER BY inp_curve_value.id;


-- 2021/01/09
CREATE OR REPLACE VIEW vi_files AS 
 SELECT inp_files.actio_type,
    inp_files.file_type,
    inp_files.fname
   FROM inp_files
   where active is true;











