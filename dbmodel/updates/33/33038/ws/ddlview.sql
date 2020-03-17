/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arccat_id,
    arc.sector_id,
    arc.macrosector_id,
    arc.state,
    arc.annotation,
    arc.custom_length,
    arc.the_geom,
    inp_pipe.minorloss,
    inp_pipe.status,
    inp_pipe.custom_roughness,
    inp_pipe.custom_dint,
    arc.state_type
   FROM inp_selector_sector, v_arc arc
     JOIN inp_pipe USING (arc_id)
  WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    (v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
    (v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
    v_arc.arccat_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.the_geom,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.to_arc,
    inp_virtualvalve.status,
    v_arc.state_type
   FROM inp_selector_sector, v_arc
     JOIN inp_virtualvalve USING (arc_id)
  WHERE v_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_parent_arc AS 
 SELECT ve_arc.arc_id,
    ve_arc.code,
    ve_arc.node_1,
    ve_arc.node_2,
    ve_arc.arccat_id,
    ve_arc.cat_arctype_id,
    ve_arc.sys_type,
    ve_arc.cat_matcat_id,
    ve_arc.cat_pnom,
    ve_arc.cat_dnom,
    ve_arc.epa_type,
    ve_arc.sector_id,
    ve_arc.macrosector_id,
    ve_arc.state,
    ve_arc.state_type,
    ve_arc.annotation,
    ve_arc.observ,
    ve_arc.comment,
    ve_arc.label,
    ve_arc.gis_length,
    ve_arc.custom_length,
    ve_arc.dma_id,
    ve_arc.presszonecat_id,
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
    ve_arc.macrodma_id,
    ve_arc.expl_id,
    ve_arc.num_value,
    ve_arc.minsector_id,
    ve_arc.dqa_id,
    ve_arc.macrodqa_id,
    ve_arc.arc_type,
    ve_arc.nodetype_1,
    ve_arc.elevation1,
    ve_arc.depth1,
    ve_arc.staticpress1,
    ve_arc.nodetype_2,
    ve_arc.elevation2,
    ve_arc.depth2,
    ve_arc.staticpress2,
    ve_arc.lastupdate,
    ve_arc.lastupdate_user,
    ve_arc.insert_user
   FROM inp_selector_sector, ve_arc
  WHERE ve_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
