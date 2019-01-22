/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



-------------------------------------------------------
-- STATE VIEWS & JOINED WITH MASTERPLAN (ALTERNATIVES)
-------------------------------------------------------
----------------------------------------------------

	
DROP VIEW IF EXISTS v_state_element CASCADE;
CREATE VIEW v_state_element AS
SELECT 
	element_id
	FROM selector_state,element
	WHERE element.state=selector_state.state_id
	AND selector_state.cur_user=current_user;

	
DROP VIEW IF EXISTS v_state_samplepoint CASCADE;
CREATE VIEW v_state_samplepoint AS
SELECT 
	sample_id
	FROM selector_state,samplepoint
	WHERE samplepoint.state=selector_state.state_id
	AND selector_state.cur_user=current_user;


DROP VIEW IF EXISTS v_state_arc CASCADE;
CREATE VIEW v_state_arc AS
SELECT 
	arc_id
	FROM selector_state,selector_expl, arc
	WHERE arc.state=selector_state.state_id AND arc.expl_id=selector_expl.expl_id
	AND selector_state.cur_user=current_user
	AND selector_expl.cur_user=current_user
EXCEPT SELECT
	arc_id
	FROM selector_psector,plan_psector_x_arc,selector_expl
	WHERE plan_psector_x_arc.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0
	AND selector_expl.cur_user=current_user


UNION SELECT
	arc_id
	FROM selector_psector,plan_psector_x_arc,selector_expl
	WHERE plan_psector_x_arc.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1
	AND selector_expl.cur_user=current_user
;
	


DROP VIEW IF EXISTS v_state_node CASCADE;
CREATE VIEW v_state_node AS
SELECT 
	node_id
	FROM selector_state,selector_expl, node
	WHERE node.state=selector_state.state_id AND node.expl_id=selector_expl.expl_id
	AND selector_state.cur_user=current_user
	AND selector_expl.cur_user = "current_user"()::text


EXCEPT SELECT
	node_id
	FROM selector_psector,plan_psector_x_node,selector_expl
	WHERE plan_psector_x_node.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0

UNION SELECT
	node_id
	FROM selector_psector,plan_psector_x_node,selector_expl
	WHERE plan_psector_x_node.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1;
	
	
	

DROP VIEW IF EXISTS v_state_connec CASCADE;
CREATE VIEW v_state_connec AS
SELECT 
	connec_id
	FROM selector_state,selector_expl, connec
	WHERE connec.state=selector_state.state_id
	AND selector_state.cur_user=current_user AND connec.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user = "current_user"()::text
;



	
-------------------------------------------------------
-- AUX VIEWS
-------------------------------------------------------
----------------------------------------------------

DROP VIEW IF EXISTS v_node CASCADE;
CREATE VIEW v_node AS SELECT
node.node_id, 
code,
elevation, 
depth, 
nodetype_id,
type as sys_type,
nodecat_id,
matcat_id as cat_matcat_id,
pnom as cat_pnom,
dnom as cat_dnom,
epa_type,
node.sector_id,
sector.macrosector_id,
arc_id,
parent_id, 
state, 
state_type,
annotation, 
observ, 
comment,
node.dma_id,
presszonecat_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
buildercat_id,
workcat_id_end,
builtdate,
enddate,
ownercat_id,
muni_id ,
postcode,
streetaxis_id,
postnumber,
postcomplement,
postcomplement2,
streetaxis2_id,
postnumber2,
node.descript,
cat_node.svg AS svg,
rotation,
concat(node_type.link_path,node.link) AS link,
verified,
node.the_geom,
node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
dma.macrodma_id,
node.expl_id,
hemisphere,
num_value
FROM node
	JOIN v_state_node on v_state_node.node_id=node.node_id
	LEFT JOIN cat_node on id=nodecat_id
	JOIN node_type on node_type.id=nodetype_id
	LEFT JOIN dma ON node.dma_id=dma.dma_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id;


DROP VIEW IF EXISTS vu_node CASCADE;
CREATE VIEW vu_node AS SELECT
node.node_id, 
code,
elevation, 
depth, 
nodetype_id,
type as sys_type,
nodecat_id,
matcat_id as cat_matcat_id,
pnom as cat_pnom,
dnom as cat_dnom,
epa_type,
node.sector_id,
sector.macrosector_id,
arc_id,
parent_id, 
state, 
state_type,
annotation, 
observ, 
comment,
node.dma_id,
presszonecat_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
buildercat_id,
workcat_id_end,
builtdate,
enddate,
ownercat_id,
muni_id ,
postcode,
streetaxis_id,
postnumber,
postcomplement,
postcomplement2,
streetaxis2_id,
postnumber2,
node.descript,
cat_node.svg AS svg,
rotation,
concat(node_type.link_path,node.link) AS link,
verified,
node.the_geom,
node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
dma.macrodma_id,
node.expl_id,
hemisphere,
num_value
FROM node
	LEFT JOIN cat_node on id=nodecat_id
	JOIN node_type on node_type.id=nodetype_id
	LEFT JOIN dma ON node.dma_id=dma.dma_id
	LEFT JOIN sector ON node.sector_id = sector.sector_id;

	
	
	
DROP VIEW IF EXISTS v_arc CASCADE;
CREATE OR REPLACE VIEW v_arc AS 
SELECT 
arc.arc_id, 
arc.code,
arc.node_1, 
arc.node_2, 
a.elevation as elevation1,
a.depth as depth1,
b.elevation as elevation2,
b.depth as depth2,
arc.arccat_id, 
cat_arc.arctype_id,
type as sys_type,
cat_arc.matcat_id,
cat_arc.pnom,
cat_arc.dnom,
arc.epa_type, 
arc.sector_id,
sector.macrosector_id,
arc.state, 
arc.state_type,
arc.annotation, 
arc.observ, 
arc."comment",
st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
arc.custom_length,
arc.dma_id,
arc.presszonecat_id,
arc.soilcat_id,
arc.function_type,
arc.category_type,
arc.fluid_type,
arc.location_type,
arc.workcat_id,
arc.workcat_id_end,
arc.buildercat_id,
arc.enddate,
arc.ownercat_id,
arc.muni_id ,
arc.postcode,
arc.streetaxis_id,
arc.postnumber,
arc.postcomplement,
arc.postcomplement2,
arc.streetaxis2_id,
arc.postnumber2,
arc.descript,
concat(arc_type.link_path,arc.link) as link,
arc.verified,
arc.undelete,
arc.label_x,
arc.label_y,
arc.label_rotation,
arc.publish,
arc.inventory,
dma.macrodma_id,
arc.expl_id,
arc.num_value,
arc.builtdate, 
CASE
	WHEN arc.custom_length IS NOT NULL THEN arc.custom_length::numeric(12,3)
	ELSE st_length2d(arc.the_geom)::numeric(12,3)
	END AS length, 
arc.the_geom
FROM arc
	LEFT JOIN sector ON arc.sector_id = sector.sector_id
	JOIN v_state_arc ON arc.arc_id=v_state_arc.arc_id
	LEFT JOIN cat_arc ON arc.arccat_id = cat_arc.id
	JOIN arc_type ON arc_type.id=arctype_id
	LEFT JOIN dma ON (((arc.dma_id) = (dma.dma_id)))
	LEFT JOIN vu_node a ON a.node_id=node_1
    LEFT JOIN vu_node b ON b.node_id=node_2;

	
DROP VIEW IF EXISTS vu_arc CASCADE;
CREATE OR REPLACE VIEW vu_arc AS 
SELECT 
arc.arc_id, 
arc.code,
arc.node_1, 
arc.node_2, 
a.elevation as elevation1,
a.depth as depth1,
b.elevation as elevation2,
b.depth as depth2,
arc.arccat_id, 
cat_arc.arctype_id,
type as sys_type,
cat_arc.matcat_id,
cat_arc.pnom,
cat_arc.dnom,
arc.epa_type, 
arc.sector_id,
sector.macrosector_id,
arc.state, 
arc.state_type,
arc.annotation, 
arc.observ, 
arc."comment",
st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
arc.custom_length,
arc.dma_id,
arc.presszonecat_id,
arc.soilcat_id,
arc.function_type,
arc.category_type,
arc.fluid_type,
arc.location_type,
arc.workcat_id,
arc.workcat_id_end,
arc.buildercat_id,
arc.enddate,
arc.ownercat_id,
arc.muni_id ,
arc.postcode,
arc.streetaxis_id,
arc.postnumber,
arc.postcomplement,
arc.postcomplement2,
arc.streetaxis2_id,
arc.postnumber2,
arc.descript,
concat(arc_type.link_path,arc.link) as link,
arc.verified,
arc.undelete,
arc.label_x,
arc.label_y,
arc.label_rotation,
arc.publish,
arc.inventory,
dma.macrodma_id,
arc.expl_id,
arc.num_value,
arc.builtdate, 
CASE
	WHEN arc.custom_length IS NOT NULL THEN arc.custom_length::numeric(12,3)
	ELSE st_length2d(arc.the_geom)::numeric(12,3)
	END AS length, 
arc.the_geom
FROM arc
	LEFT JOIN sector ON arc.sector_id = sector.sector_id
	LEFT JOIN cat_arc ON arc.arccat_id = cat_arc.id
	JOIN arc_type ON arc_type.id=arctype_id
	LEFT JOIN dma ON (((arc.dma_id) = (dma.dma_id)))
	LEFT JOIN vu_node a ON a.node_id=node_1
    LEFT JOIN vu_node b ON b.node_id=node_2;