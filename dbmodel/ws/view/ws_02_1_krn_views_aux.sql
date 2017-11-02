SET search_path = "SCHEMA_NAME", public, pg_catalog;



-------------------------------------------------------
-- STATE VIEWS & JOINED WITH MASTERPLAN (ALTERNATIVES)
-------------------------------------------------------
----------------------------------------------------

DROP VIEW IF EXISTS v_state_arc CASCADE;;
CREATE VIEW v_state_arc AS
SELECT 
	arc_id
	FROM selector_state,arc
	WHERE arc.state=selector_state.state_id
	AND selector_state.cur_user=current_user

EXCEPT SELECT
	arc_id
	FROM selector_psector,plan_arc_x_psector
	WHERE plan_arc_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0

UNION SELECT
	arc_id
	FROM selector_psector,plan_arc_x_psector
	WHERE plan_arc_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1;
	


DROP VIEW IF EXISTS v_state_node CASCADE;;
CREATE VIEW v_state_node AS
SELECT 
	node_id
	FROM selector_state,node
	WHERE node.state=selector_state.state_id
	AND selector_state.cur_user=current_user

EXCEPT SELECT
	node_id
	FROM selector_psector,plan_node_x_psector
	WHERE plan_node_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=0

UNION SELECT
	node_id
	FROM selector_psector,plan_node_x_psector
	WHERE plan_node_x_psector.psector_id=selector_psector.psector_id
	AND selector_psector.cur_user=current_user AND state=1;
	
	
	

DROP VIEW IF EXISTS v_state_connec CASCADE;;
CREATE VIEW v_state_connec AS
SELECT 
	connec_id
	FROM selector_state,connec
	WHERE connec.state=selector_state.state_id
	AND selector_state.cur_user=current_user;



	
-------------------------------------------------------
-- AUX VIEWS
-------------------------------------------------------
----------------------------------------------------

DROP VIEW IF EXISTS v_node CASCADE;;
CREATE VIEW v_node AS SELECT
node.node_id, 
code,
elevation, 
depth, 
nodetype_id,
nodecat_id,
matcat_id as cat_matcat_id,
pnom as cat_pnom,
dnom as cat_dnom,
epa_type,
sector_id, 
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
address_01,
address_02,
address_03,
node.descript,
cat_node.svg AS cat_svg,
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
	JOIN cat_node on id=nodecat_id
	JOIN node_type on node_type.id=nodetype_id
	LEFT JOIN dma ON node.dma_id=dma.dma_id;

	
	
	
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
cat_arc.matcat_id,
cat_arc.pnom,
cat_arc.dnom,
arc.epa_type, 
arc.sector_id, 
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
arc.address_01,
arc.address_02,
arc.address_03,
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
CASE
	WHEN arc.builtdate IS NOT NULL THEN arc.builtdate
	ELSE '1900-01-01'::date
	END AS builtdate, 
CASE
	WHEN arc.custom_length IS NOT NULL THEN arc.custom_length::numeric(12,3)
	ELSE st_length2d(arc.the_geom)::numeric(12,3)
	END AS length, 
arc.the_geom
FROM arc
	JOIN v_state_arc ON arc.arc_id=v_state_arc.arc_id
	JOIN cat_arc ON arc.arccat_id = cat_arc.id
	JOIN arc_type ON arc_type.id=arctype_id
	LEFT JOIN dma ON (((arc.dma_id) = (dma.dma_id)))
	LEFT JOIN node a ON a.node_id=node_1
    LEFT JOIN node b ON b.node_id=node_2;
