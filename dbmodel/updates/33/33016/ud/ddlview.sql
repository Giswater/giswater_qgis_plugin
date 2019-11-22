/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 21/11/2019
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT DISTINCT ON (v_node.node_id) v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam
   FROM v_node
     JOIN inp_junction ON inp_junction.node_id::text = v_node.node_id::text
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text OR a.node_2::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_inp_divider AS
SELECT DISTINCT ON (node_id) 
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
FROM v_node
     JOIN inp_divider ON (((v_node.node_id) = (inp_divider.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id);
	 

CREATE OR REPLACE VIEW v_edit_inp_outfall AS
SELECT DISTINCT ON (node_id)
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
FROM v_node
     JOIN inp_outfall ON (((v_node.node_id) = (inp_outfall.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id);
	 

CREATE OR REPLACE VIEW v_edit_inp_storage AS
SELECT DISTINCT ON (node_id) 
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
FROM v_node
     JOIN inp_storage ON (((v_node.node_id) = (inp_storage.node_id)))
     JOIN vi_parent_arc a ON (a.node_1=v_node.node_id OR a.node_2=v_node.node_id)	 
	 