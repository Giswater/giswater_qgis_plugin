/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS ve_lot_x_gully;
CREATE OR REPLACE VIEW ve_lot_x_gully AS 
 SELECT row_number() OVER (ORDER BY om_visit_lot_x_gully.lot_id, gully.gully_id) AS rid,
    gully.gully_id,
    lower(gully.feature_type::text) AS feature_type,
    gully.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_gully.lot_id,
    om_visit_lot_x_gully.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_gully.observ,
    gully.the_geom
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_gully ON om_visit_lot_x_gully.lot_id = om_visit_lot.id
     JOIN gully ON gully.gully_id::text = om_visit_lot_x_gully.gully_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id = om_visit_lot_x_gully.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;


  
CREATE OR REPLACE VIEW v_edit_inp_junction AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
elev AS sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node.state, 
v_node.the_geom,
v_node.annotation, 
inp_junction.y0, 
inp_junction.ysur,
inp_junction.apond
FROM inp_selector_sector, v_node
     JOIN inp_junction ON inp_junction.node_id = v_node.node_id
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_edit_inp_divider AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node.state, 
v_node.annotation, 
v_node.the_geom,
inp_divider.divider_type, 
inp_divider.arc_id, 
inp_divider.curve_id, 
inp_divider.qmin, 
inp_divider.ht, 
inp_divider.cd, 
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond
FROM inp_selector_sector, v_node
     JOIN inp_divider ON (((v_node.node_id) = (inp_divider.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_outfall AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation, 
inp_outfall.outfall_type, 
inp_outfall.stage, 
inp_outfall.curve_id, 
inp_outfall.timser_id,
inp_outfall.gate
FROM inp_selector_sector, v_node
     JOIN inp_outfall ON (((v_node.node_id) = (inp_outfall.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_storage AS
SELECT 
v_node.node_id, 
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
nodecat_id, 
v_node.sector_id, 
v_node.macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation,
inp_storage.storage_type, 
inp_storage.curve_id, 
inp_storage.a1, 
inp_storage.a2,
inp_storage.a0, 
inp_storage.fevap, 
inp_storage.sh, 
inp_storage.hc, 
inp_storage.imd, 
inp_storage.y0, 
inp_storage.ysur,
inp_storage.apond
FROM inp_selector_sector, v_node
     JOIN inp_storage ON (((v_node.node_id) = (inp_storage.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)
     WHERE a.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
