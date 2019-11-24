/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 22/11/2019

CREATE OR REPLACE VIEW vi_parent_arc AS 
 SELECT ve_arc.arc_id,
    ve_arc.code,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.y1,
    ve_arc.custom_y1,
    ve_arc.sys_y1,
    ve_arc.elev1,
    ve_arc.custom_elev1,
    ve_arc.sys_elev1,
    ve_arc.y2,
    ve_arc.custom_y2,
    ve_arc.sys_y2,
    ve_arc.elev2,
    ve_arc.custom_elev2,
    ve_arc.sys_elev2,
    ve_arc.z1,
    ve_arc.z2,
    ve_arc.r1,
    ve_arc.r2,
    ve_arc.slope,
    ve_arc.arc_type,
    ve_arc.sys_type,
    ve_arc.arccat_id,
    ve_arc.cat_matcat_id,
    ve_arc.cat_shape,
    ve_arc.cat_geom1,
    ve_arc.cat_geom2,
    ve_arc.gis_length,
    ve_arc.epa_type,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.annotation,
    ve_arc.observ,
    ve_arc.comment,
    ve_arc.label,
    ve_arc.inverted_slope,
    ve_arc.custom_length,
    ve_arc.dma_id,
    ve_arc.soilcat_id,
    ve_arc.function_type,
    ve_arc.category_type,
    ve_arc.fluid_type,
    ve_arc.location_type,
    ve_arc.workcat_id,
    ve_arc.workcat_id_end,
    ve_arc.buildercat_id,
    ve_arc.builtdate,
    ve_arc.enddate,
    ve_arc.ownercat_id,
    ve_arc.muni_id,
    ve_arc.postcode,
    ve_arc.streetaxis_id,
    ve_arc.postnumber,
    ve_arc.postcomplement,
    ve_arc.postcomplement2,
    ve_arc.streetaxis2_id,
    ve_arc.postnumber2,
    ve_arc.descript,
    ve_arc.link,
    ve_arc.verified,
    ve_arc.the_geom,
    ve_arc.undelete,
    ve_arc.label_x,
    ve_arc.label_y,
    ve_arc.label_rotation,
    ve_arc.publish,
    ve_arc.inventory,
    ve_arc.uncertain,
    ve_arc.macrodma_id,
    ve_arc.expl_id,
    ve_arc.num_value,
    ve_arc.lastupdate,
    ve_arc.lastupdate_user,
    ve_arc.insert_user
   FROM inp_selector_sector, ve_arc
   JOIN value_state_type ON id=ve_arc.state_type
  WHERE ve_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
  AND is_operative IS TRUE;


   
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam
   FROM node v_node
     JOIN inp_junction ON inp_junction.node_id::text = v_node.node_id::text
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text
UNION
SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam
   FROM node v_node
     JOIN inp_junction ON inp_junction.node_id::text = v_node.node_id::text
     JOIN vi_parent_arc a ON a.node_2::text = v_node.node_id::text;



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
macrosector_id,
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
FROM node v_node
     JOIN inp_divider ON (((v_node.node_id) = (inp_divider.node_id)))
     JOIN vi_parent_arc a ON a.node_1=v_node.node_id
UNION
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
macrosector_id,
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
FROM node v_node
     JOIN inp_divider ON (((v_node.node_id) = (inp_divider.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id);

     

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
macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation, 
inp_outfall.outfall_type, 
inp_outfall.stage, 
inp_outfall.curve_id, 
inp_outfall.timser_id,
inp_outfall.gate
FROM node v_node
     JOIN inp_outfall ON (((v_node.node_id) = (inp_outfall.node_id)))
     JOIN vi_parent_arc a ON a.node_1=v_node.node_id
UNION
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
macrosector_id,
v_node."state", 
v_node.the_geom,
v_node.annotation, 
inp_outfall.outfall_type, 
inp_outfall.stage, 
inp_outfall.curve_id, 
inp_outfall.timser_id,
inp_outfall.gate
FROM node v_node
     JOIN inp_outfall ON (((v_node.node_id) = (inp_outfall.node_id)))
     JOIN vi_parent_arc a ON a.node_2=v_node.node_id;


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
macrosector_id,
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
FROM node v_node
     JOIN inp_storage ON (((v_node.node_id) = (inp_storage.node_id)))
     JOIN vi_parent_arc a ON a.node_1=v_node.node_id
 UNION
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
macrosector_id,
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
FROM node v_node
     JOIN inp_storage ON (((v_node.node_id) = (inp_storage.node_id)))
     JOIN vi_parent_arc a ON a.node_2=v_node.node_id;