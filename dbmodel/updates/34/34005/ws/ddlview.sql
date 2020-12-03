/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/18

SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE"}}$$);


-- independent
DROP VIEW IF EXISTS v_ext_address;
CREATE OR REPLACE VIEW v_ext_address AS 
 SELECT ext_address.id,
	ext_address.muni_id,
	ext_address.postcode,
	ext_address.streetaxis_id,
	ext_address.postnumber,
	ext_address.plot_id,
	ext_address.expl_id,
	ext_streetaxis.name,
	ext_address.the_geom
   FROM selector_expl,  ext_address
   LEFT JOIN ext_streetaxis ON ext_streetaxis.id = ext_address.streetaxis_id
  WHERE ext_address.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


-- drop unused views
--------------------
DROP VIEW IF EXISTS v_arc_dattrib;
DROP VIEW IF EXISTS v_node_dattrib;
DROP VIEW IF EXISTS v_connec_dattrib;
DROP VIEW IF EXISTS vi_parent_node;


-- drop dependence views from arc
---------------------------------
DROP VIEW IF EXISTS v_ui_arc_x_relations;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;
DROP VIEW IF EXISTS v_arc_x_vnode;

DROP VIEW IF EXISTS v_edit_inp_virtualvalve;
DROP VIEW IF EXISTS v_edit_inp_pipe;

DROP VIEW IF EXISTS v_edit_inp_connec;
DROP VIEW IF EXISTS v_edit_inp_inlet;
DROP VIEW IF EXISTS v_edit_inp_junction;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_reservoir;
DROP VIEW IF EXISTS v_edit_inp_shortpipe;
DROP VIEW IF EXISTS v_edit_inp_tank;
DROP VIEW IF EXISTS v_edit_inp_valve;

DROP VIEW IF EXISTS vp_basic_arc;
DROP VIEW IF EXISTS vi_parent_dma;
DROP VIEW IF EXISTS vi_parent_arc;
DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS ve_arc;

DROP VIEW IF EXISTS v_edit_man_varc;
DROP VIEW IF EXISTS v_edit_man_pipe;


DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_current_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_current_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_x_arc;
DROP VIEW IF EXISTS v_result_arc;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;
DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_plan_aux_arc_cost;
DROP VIEW IF EXISTS v_plan_aux_arc_ml;
DROP VIEW IF EXISTS v_ui_arc_x_node;
DROP VIEW IF EXISTS v_arc;
DROP VIEW IF EXISTS vu_arc;


-- drop dependecy views from node
---------------------------------
DROP VIEW IF EXISTS v_ui_node_x_relations;
DROP VIEW IF EXISTS v_ui_plan_node_cost;
DROP VIEW IF EXISTS v_plan_result_node;
DROP VIEW IF EXISTS v_plan_psector_x_node;
DROP VIEW IF EXISTS v_plan_node;
DROP VIEW IF EXISTS vp_basic_node;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS ve_node;


DROP VIEW IF EXISTS v_plan_aux_arc_connec;
DROP VIEW IF EXISTS v_price_x_catconnec;
DROP VIEW IF EXISTS v_price_x_catconnec1;
DROP VIEW IF EXISTS v_price_x_catconnec2;
DROP VIEW IF EXISTS v_price_x_catconnec3;
DROP VIEW IF EXISTS v_price_x_catarc;
DROP VIEW IF EXISTS v_price_x_catarc1;
DROP VIEW IF EXISTS v_price_x_catarc2;
DROP VIEW IF EXISTS v_price_x_catarc3;
DROP VIEW IF EXISTS v_price_x_catsoil;
DROP VIEW IF EXISTS v_price_x_catsoil1;
DROP VIEW IF EXISTS v_price_x_catsoil2;
DROP VIEW IF EXISTS v_price_x_catsoil3;

DROP VIEW IF EXISTS v_edit_man_expansiontank;
DROP VIEW IF EXISTS v_edit_man_filter;
DROP VIEW IF EXISTS v_edit_man_flexunion;
DROP VIEW IF EXISTS v_edit_man_hydrant;
DROP VIEW IF EXISTS v_edit_man_junction;
DROP VIEW IF EXISTS v_edit_man_meter;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_edit_man_netsamplepoint;
DROP VIEW IF EXISTS v_edit_man_netwjoin;
DROP VIEW IF EXISTS v_edit_man_pump;
DROP VIEW IF EXISTS v_edit_man_reduction;
DROP VIEW IF EXISTS v_edit_man_register;
DROP VIEW IF EXISTS v_edit_man_source;
DROP VIEW IF EXISTS v_edit_man_tank;
DROP VIEW IF EXISTS v_anl_mincut_selected_valve;
DROP VIEW IF EXISTS v_edit_man_valve;
DROP VIEW IF EXISTS v_edit_man_waterwell;
DROP VIEW IF EXISTS v_edit_man_manhole;
DROP VIEW IF EXISTS v_edit_man_wtp;

DROP VIEW IF EXISTS v_edit_man_register_pol;
DROP VIEW IF EXISTS v_edit_man_tank_pol;
DROP VIEW IF EXISTS v_edit_field_valve;
DROP VIEW IF EXISTS v_edit_inp_demand;

DROP VIEW IF EXISTS ve_pol_fountain;
DROP VIEW IF EXISTS ve_pol_register;
DROP VIEW IF EXISTS ve_pol_tank;

DROP VIEW IF EXISTS v_node;
DROP VIEW IF EXISTS vu_node;


-- drop depedency views from connec
-----------------------------------
DROP VIEW IF EXISTS vi_parent_hydrometer;
DROP VIEW IF EXISTS v_rtc_interval_nodepattern;
DROP VIEW IF EXISTS v_rtc_period_dma;
DROP VIEW IF EXISTS v_rtc_period_nodepattern;
DROP VIEW IF EXISTS v_rtc_period_node;
DROP VIEW IF EXISTS v_rtc_period_pjoint;
DROP VIEW IF EXISTS v_rtc_period_pjointpattern;
DROP VIEW IF EXISTS v_rtc_period_hydrometer;
DROP VIEW IF EXISTS vi_parent_connec;
DROP VIEW IF EXISTS vp_basic_connec;
DROP VIEW IF EXISTS v_edit_connec;
DROP VIEW IF EXISTS ve_connec;
DROP VIEW IF EXISTS v_connec;
DROP VIEW IF EXISTS vu_connec;

DROP VIEW IF EXISTS v_edit_man_fountain;
DROP VIEW IF EXISTS v_edit_man_tap;
DROP VIEW IF EXISTS v_edit_man_greentap;
DROP VIEW IF EXISTS v_edit_man_wjoin;

--change type of description columns
ALTER TABLE connec ALTER COLUMN observ TYPE text;
ALTER TABLE connec ALTER COLUMN descript TYPE text;
ALTER TABLE connec ALTER COLUMN annotation TYPE text;
ALTER TABLE connec ALTER COLUMN comment TYPE text;

-- CREACIO DE LES VU
--------------------
DROP VIEW IF EXISTS vu_node;
CREATE OR REPLACE VIEW vu_node AS 
 SELECT node.node_id,
	node.code,
	node.elevation,
	node.depth,
	cat_node.nodetype_id AS node_type,
	cat_feature.system_id AS sys_type,
	node.nodecat_id,
	cat_node.matcat_id AS cat_matcat_id,
	cat_node.pnom AS cat_pnom,
	cat_node.dnom AS cat_dnom,
	node.epa_type,
	node.expl_id,
	exploitation.macroexpl_id,
	node.sector_id,
	sector.name AS sector_name,
	sector.macrosector_id,
	node.arc_id,
	node.parent_id,
	node.state,
	node.state_type,
	node.annotation,
	node.observ,
	node.comment,
	node.minsector_id,    
	node.dma_id,
	dma.name AS dma_name,
	dma.macrodma_id,
	node.presszone_id,
	cat_presszone.name AS presszone_name,
	node.staticpressure,
	node.dqa_id,
	dqa.name AS dqa_name,
	dqa.macrodqa_id,
	node.soilcat_id,
	node.function_type,
	node.category_type,
	node.fluid_type,
	node.location_type,
	node.workcat_id,
	node.workcat_id_end,
	node.builtdate,
	node.enddate,
	node.buildercat_id,
	node.ownercat_id,
	node.muni_id,
	node.postcode,
	node.district_id,
	a.name AS streetname,
	node.postnumber,
	node.postcomplement,
	b.name AS streetname2,
	node.postnumber2,
	node.postcomplement2,
	node.descript,
	cat_node.svg,
	node.rotation,
	concat(cat_feature.link_path, node.link) AS link,
	node.verified,
	node.undelete,
	cat_node.label,
	node.label_x,
	node.label_y,
	node.label_rotation,
	node.publish,
	node.inventory,
	node.hemisphere,
	node.num_value,
	cat_node.nodetype_id,   
	date_trunc('second'::text, node.tstamp) AS tstamp,
	node.insert_user,
	date_trunc('second'::text, lastupdate) AS lastupdate,
	node.lastupdate_user,
	node.the_geom
	FROM node
	 LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_node.nodetype_id::text
	 LEFT JOIN dma ON node.dma_id = dma.dma_id
	 LEFT JOIN sector ON node.sector_id = sector.sector_id
	 LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
	 LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id
	 LEFT JOIN cat_presszone ON cat_presszone.id = node.presszone_id
	 LEFT JOIN ext_streetaxis a ON a.id::text = node.streetaxis_id::text
	 LEFT JOIN ext_streetaxis b ON b.id::text = node.streetaxis2_id::text;


CREATE OR REPLACE VIEW vu_arc AS 
 SELECT arc.arc_id,
	arc.code,
	arc.node_1,
	arc.node_2,
	a.elevation AS elevation1,
	a.depth AS depth1,
	b.elevation AS elevation2,
	b.depth AS depth2,
	arc.arccat_id,
	cat_arc.arctype_id AS arc_type,
	cat_feature.system_id AS sys_type,
	cat_arc.matcat_id as cat_matcat_id,
	cat_arc.pnom as cat_pnom,
	cat_arc.dnom as cat_dnom,
	arc.epa_type,
	arc.expl_id,
	exploitation.macroexpl_id,
	arc.sector_id,
	sector.name AS sector_name,
	sector.macrosector_id,
	arc.state,
	arc.state_type,
	arc.annotation,
	arc.observ,
	arc.comment,
	st_length2d(arc.the_geom)::numeric(12,2) AS gis_length,
	arc.custom_length,
	arc.minsector_id,
	arc.dma_id,
	dma.name AS dma_name,
	dma.macrodma_id,
	arc.presszone_id,
	cat_presszone.name AS presszone_name,
	arc.dqa_id,
	dqa.name AS dqa_name,
	dqa.macrodqa_id,
	arc.soilcat_id,
	arc.function_type,
	arc.category_type,
	arc.fluid_type,
	arc.location_type,
	arc.workcat_id,
	arc.workcat_id_end,
	arc.buildercat_id,
	arc.builtdate,
	arc.enddate,
	arc.ownercat_id,
	arc.muni_id,
	arc.postcode,
	arc.district_id,
	c.name as streetname,
	arc.postnumber,
	arc.postcomplement,
	d.name as streetname2,
	arc.postnumber2,
	arc.postcomplement2,
	arc.descript,
	concat(cat_feature.link_path, arc.link) AS link,
	arc.verified,
	arc.undelete,
	cat_arc.label,
	arc.label_x,
	arc.label_y,
	arc.label_rotation,
	arc.publish,
	arc.inventory,   
	arc.num_value,
	cat_arc.arctype_id as cat_arctype_id,
	a.nodetype_id AS nodetype_1,
	a.staticpressure AS staticpress1,
	b.nodetype_id AS nodetype_2,
	b.staticpressure AS staticpress2,
	date_trunc('second'::text, arc.tstamp) AS tstamp,
	arc.insert_user,
	date_trunc('second'::text, arc.lastupdate) AS lastupdate,
	arc.lastupdate_user,
	arc.the_geom
	FROM arc
	 LEFT JOIN sector ON arc.sector_id = sector.sector_id
	 LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
	 LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
	 LEFT JOIN dma ON arc.dma_id = dma.dma_id
	 LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
	 LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
	 LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
 	 LEFT JOIN cat_presszone ON cat_presszone.id = arc.presszone_id
	 LEFT JOIN ext_streetaxis c ON c.id = arc.streetaxis_id
	 LEFT JOIN ext_streetaxis d ON d.id = arc.streetaxis2_id;



CREATE OR REPLACE VIEW vu_connec AS 
 SELECT connec.connec_id,
	connec.code,
	connec.elevation,
	connec.depth,
	cat_connec.connectype_id AS connec_type,
	cat_feature.system_id AS sys_type,
	connec.connecat_id,
	connec.expl_id,
	exploitation.macroexpl_id,
	connec.sector_id,
	sector.name AS sector_name,
	sector.macrosector_id,
	connec.customer_code,
	cat_connec.matcat_id AS cat_matcat_id,
	cat_connec.pnom AS cat_pnom,
	cat_connec.dnom AS cat_dnom,
	connec.connec_length,
	connec.state,
	connec.state_type,
	a.n_hydrometer,
	connec.arc_id,
	connec.annotation,
	connec.observ,
	connec.comment,
	connec.minsector_id,
	connec.dma_id,
	dma.name AS dma_name,
	dma.macrodma_id,
	connec.presszone_id,
	cat_presszone.name AS presszone_name,
	connec.staticpressure,
	connec.dqa_id,
	dqa.name AS dqa_name,
	dqa.macrodqa_id,
	connec.soilcat_id,
	connec.function_type,
	connec.category_type,
	connec.fluid_type,
	connec.location_type,
	connec.workcat_id,
	connec.workcat_id_end,
	connec.buildercat_id,
	connec.builtdate,
	connec.enddate,
	connec.ownercat_id,
	connec.muni_id,
	connec.postcode,
	connec.district_id,
	c.name AS streetname,
	connec.postnumber,
	connec.postcomplement,
	b.name AS streetname2,
	connec.postnumber2,
	connec.postcomplement2,
	connec.descript,
	cat_connec.svg,
	connec.rotation,
	concat(cat_feature.link_path, connec.link) AS link,
	connec.verified,
	connec.undelete,
	cat_connec.label,
	connec.label_x,
	connec.label_y,
	connec.label_rotation,
	connec.publish,
	connec.inventory,
	connec.num_value,
	cat_connec.connectype_id,
	connec.feature_id,
	connec.featurecat_id,
	connec.pjoint_id,
	connec.pjoint_type,
	date_trunc('second'::text, connec.tstamp) AS tstamp,
	connec.insert_user,
	date_trunc('second'::text, lastupdate) AS lastupdate,
	connec.lastupdate_user,
	connec.the_geom
   FROM connec
	 LEFT JOIN (SELECT connec_1.connec_id,
			count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		   FROM ext_rtc_hydrometer
			 JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
		  GROUP BY connec_1.connec_id) a USING (connec_id)
	 JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
	 LEFT JOIN dma ON connec.dma_id = dma.dma_id
	 LEFT JOIN sector ON connec.sector_id = sector.sector_id
	 LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
	 LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id
 	 LEFT JOIN cat_presszone ON cat_presszone.id = connec.presszone_id
	 LEFT JOIN ext_streetaxis c ON c.id = streetaxis_id
	 LEFT JOIN ext_streetaxis b ON b.id = streetaxis2_id;


	 
--creacio de les main
---------------------
CREATE OR REPLACE VIEW v_arc AS 
SELECT * FROM vu_arc    
JOIN v_state_arc USING (arc_id);

CREATE OR REPLACE VIEW vp_basic_arc AS 
SELECT v_arc.arc_id AS nid,
v_arc.arc_type AS custom_type
FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW v_node AS 
SELECT * 
FROM vu_node
JOIN v_state_node USING (node_id);

CREATE OR REPLACE VIEW v_edit_node AS 
SELECT * FROM v_node;

CREATE OR REPLACE VIEW vp_basic_node AS 
SELECT v_node.node_id AS nid,
v_node.nodetype_id AS custom_type
FROM v_node;

CREATE OR REPLACE VIEW ve_node AS 
SELECT * FROM v_node;


CREATE OR REPLACE VIEW v_connec AS 
SELECT 
connec_id,
code,
elevation,
depth,
connec_type,
sys_type,
connecat_id,
expl_id,
macroexpl_id,
sector_id,
sector_name,
macrosector_id,
customer_code,
cat_matcat_id,
cat_pnom,
cat_dnom,
connec_length,
state,
state_type,
n_hydrometer,
v_state_connec.arc_id,
annotation,
observ,
comment,
minsector_id,
dma_id,
dma_name,
macrodma_id,
presszone_id,
presszone_name,
staticpressure,
dqa_id,
dqa_name,
macrodqa_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
district_id,
streetname,
postnumber,
postcomplement,
streetname2,
postnumber2,
postcomplement2,
descript,
svg,
rotation,
link,
verified,
undelete,
label,
label_x,
label_y,
label_rotation,
publish,
inventory,
num_value,
connectype_id,
feature_id,
featurecat_id,
pjoint_id,
pjoint_type,
tstamp,
insert_user,
lastupdate,
lastupdate_user,
the_geom
FROM vu_connec
JOIN v_state_connec USING (connec_id);
	 
CREATE VIEW v_edit_connec AS
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW ve_connec AS 
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW vp_basic_connec AS 
SELECT v_connec.connec_id AS nid,
v_connec.connectype_id AS custom_type
FROM v_connec;


SELECT gw_fct_admin_manage_child_views($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "multi_create":"True" }}$$);


-- creacio de les pol
CREATE OR REPLACE VIEW ve_pol_fountain AS 
 SELECT man_fountain.pol_id,
	connec.connec_id,
	polygon.the_geom
   FROM connec
	 JOIN man_fountain ON man_fountain.connec_id::text = connec.connec_id::text
	 JOIN polygon ON polygon.pol_id::text = man_fountain.pol_id::text;

CREATE OR REPLACE VIEW ve_pol_register AS 
 SELECT man_register.pol_id,
	v_node.node_id,
	polygon.the_geom
   FROM v_node
	 JOIN man_register ON v_node.node_id::text = man_register.node_id::text
	 JOIN polygon ON polygon.pol_id::text = man_register.pol_id::text;

CREATE OR REPLACE VIEW ve_pol_tank AS 
 SELECT man_tank.pol_id,
	v_node.node_id,
	polygon.the_geom
   FROM v_node
	 JOIN man_tank ON man_tank.node_id::text = v_node.node_id::text
	 JOIN polygon ON polygon.pol_id::text = man_tank.pol_id::text;

	 
--- linked
----------
CREATE OR REPLACE VIEW  v_ui_arc_x_relations AS 
 SELECT row_number() OVER (ORDER BY v_node.node_id) + 1000000 AS rid,
	v_node.arc_id,
	v_node.nodetype_id AS featurecat_id,
	v_node.nodecat_id AS catalog,
	v_node.node_id AS feature_id,
	v_node.code AS feature_code,
	v_node.sys_type,
	v_arc.state AS arc_state,
	v_node.state AS feature_state,
	st_x(v_node.the_geom) AS x,
	st_y(v_node.the_geom) AS y
   FROM v_node
	 JOIN v_arc ON v_arc.arc_id::text = v_node.arc_id::text
  WHERE v_node.arc_id IS NOT NULL
UNION
 SELECT row_number() OVER () + 2000000 AS rid,
	v_arc.arc_id,
	v_connec.connectype_id AS featurecat_id,
	v_connec.connecat_id AS catalog,
	v_connec.connec_id AS feature_id,
	v_connec.code AS feature_code,
	v_connec.sys_type,
	v_arc.state AS arc_state,
	v_connec.state AS feature_state,
	st_x(v_connec.the_geom) AS x,
	st_y(v_connec.the_geom) AS y
   FROM v_connec
	 JOIN v_arc ON v_arc.arc_id::text = v_connec.arc_id::text
  WHERE v_connec.arc_id IS NOT NULL;



CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end AS 
 SELECT row_number() OVER (ORDER BY v_arc.arc_id) + 1000000 AS rid,
	'ARC'::character varying AS feature_type,
	v_arc.arccat_id AS featurecat_id,
	v_arc.arc_id AS feature_id,
	v_arc.code,
	exploitation.name AS expl_name,
	v_arc.workcat_id_end AS workcat_id,
	exploitation.expl_id
   FROM v_arc
	 JOIN exploitation ON exploitation.expl_id = v_arc.expl_id
  WHERE v_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_node.node_id) + 2000000 AS rid,
	'NODE'::character varying AS feature_type,
	v_node.nodecat_id AS featurecat_id,
	v_node.node_id AS feature_id,
	v_node.code,
	exploitation.name AS expl_name,
	v_node.workcat_id_end AS workcat_id,
	exploitation.expl_id
   FROM v_node
	 JOIN exploitation ON exploitation.expl_id = v_node.expl_id
  WHERE v_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_connec.connec_id) + 3000000 AS rid,
	'CONNEC'::character varying AS feature_type,
	v_connec.connecat_id AS featurecat_id,
	v_connec.connec_id AS feature_id,
	v_connec.code,
	exploitation.name AS expl_name,
	v_connec.workcat_id_end AS workcat_id,
	exploitation.expl_id
   FROM v_connec
	 JOIN exploitation ON exploitation.expl_id = v_connec.expl_id
  WHERE v_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000 AS rid,
	'ELEMENT'::character varying AS feature_type,
	v_edit_element.elementcat_id AS featurecat_id,
	v_edit_element.element_id AS feature_id,
	v_edit_element.code,
	exploitation.name AS expl_name,
	v_edit_element.workcat_id_end AS workcat_id,
	exploitation.expl_id
   FROM v_edit_element
	 JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0;


CREATE OR REPLACE VIEW v_arc_x_vnode AS 
 SELECT a.vnode_id,
	a.arc_id,
	a.feature_type,
	a.feature_id,
	a.node_1,
	a.node_2,
	(a.length * a.locate::double precision)::numeric(12,3) AS vnode_distfromnode1,
	(a.length * (1::numeric - a.locate)::double precision)::numeric(12,3) AS vnode_distfromnode2,
	(a.elevation1 - a.locate * (a.elevation1 - a.elevation2))::numeric(12,3) AS vnode_elevation
   FROM ( SELECT vnode.vnode_id,
			v_arc.arc_id,
			a_1.feature_type,
			a_1.feature_id,
			st_length(v_arc.the_geom) AS length,
			st_linelocatepoint(v_arc.the_geom, vnode.the_geom)::numeric(12,3) AS locate,
			v_arc.node_1,
			v_arc.node_2,
			v_arc.elevation1,
			v_arc.elevation2
		   FROM v_arc,
			vnode
			 JOIN v_edit_link a_1 ON vnode.vnode_id = a_1.exit_id::integer
		  WHERE st_dwithin(v_arc.the_geom, vnode.the_geom, 0.01::double precision) AND v_arc.state > 0 AND vnode.state > 0) a
  ORDER BY a.arc_id, a.node_2 DESC;


CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
 SELECT row_number() OVER (ORDER BY v_node.node_id) AS rid,
	v_node.parent_id AS node_id,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.node_id AS child_id,
	v_node.code,
	v_node.sys_type
   FROM v_node
  WHERE v_node.parent_id IS NOT NULL;




CREATE OR REPLACE VIEW vi_parent_arc AS 
 SELECT v_arc.*
   FROM v_arc,
	inp_selector_sector
  WHERE v_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_parent_dma AS 
 SELECT DISTINCT ON (dma.dma_id) dma.dma_id,
	dma.name,
	dma.expl_id,
	dma.macrodma_id,
	dma.descript,
	dma.undelete,
	dma.minc,
	dma.maxc,
	dma.effc,
	dma.pattern_id,
	dma.link,
	dma.grafconfig,
	dma.the_geom
   FROM dma
	 JOIN vi_parent_arc USING (dma_id);


CREATE OR REPLACE VIEW v_edit_inp_connec AS 
 SELECT connec.connec_id,
    connec.elevation,
    connec.depth,
    connec.connecat_id,
    connec.arc_id,
    connec.sector_id,
	connec.dma_id,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.expl_id,
	connec.pjoint_type,
    connec.pjoint_id,
    inp_connec.demand,
    inp_connec.pattern_id,
    connec.the_geom
   FROM inp_selector_sector, connec
     JOIN inp_connec USING (connec_id)
  WHERE connec.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

CREATE TRIGGER gw_trg_edit_inp_connec
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_connec
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_connec();

	 
CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT n.node_id,
	elevation,
	depth,
	nodecat_id,
	n.sector_id,
	macrosector_id,
	dma_id,
	state,
	state_type,
	annotation,
	expl_id,
	initlevel,
	minlevel,
	maxlevel,
	diameter,
	minvol,
	curve_id,
	pattern_id,
	the_geom
   FROM inp_selector_sector, v_node n
   JOIN inp_inlet USING (node_id)
   WHERE n.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE TRIGGER gw_trg_edit_inp_node_inlet
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_inlet
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_inlet');


CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT n.node_id,
	elevation,
	depth,
	nodecat_id,
	n.sector_id,
	macrosector_id,
	dma_id,
	state,
	state_type,
	annotation,
	demand,
	pattern_id,
	the_geom
   FROM inp_selector_sector, v_node n
   JOIN inp_junction USING (node_id)
   WHERE n.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

 
CREATE TRIGGER gw_trg_edit_inp_node_junction
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_junction
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_junction');


CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT n.node_id,
	elevation,
	depth,
	nodecat_id,
	n.sector_id,
	macrosector_id,
	state,
	state_type,
	annotation,
	expl_id,
	dma_id,
	power,
	curve_id,
	speed,
	pattern,
	to_arc,
	status,
	pump_type,
	the_geom
    FROM inp_selector_sector, v_node n
   JOIN inp_pump USING (node_id)
   WHERE n.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE TRIGGER gw_trg_edit_inp_node_pump
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_pump
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_pump');



CREATE OR REPLACE VIEW v_edit_inp_reservoir AS 
 SELECT n.node_id,
	n.elevation,
	n.depth,
	n.nodecat_id,
	n.sector_id,
	macrosector_id,
	dma_id,
	state,
	state_type,
	annotation,
	expl_id,
	pattern_id,
	the_geom
    FROM inp_selector_sector, v_node n
   JOIN inp_reservoir USING (node_id)
   WHERE n.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

 CREATE TRIGGER gw_trg_edit_inp_node_reservoir
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_reservoir
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_reservoir');

  
CREATE OR REPLACE VIEW v_edit_inp_tank AS 
 SELECT n.node_id,
	elevation,
	depth,
	nodecat_id,
	n.sector_id,
	macrosector_id,
	dma_id,
	state,
	state_type,
	annotation,
	expl_id,
	initlevel,
	minlevel,
	maxlevel,
	diameter,
	minvol,
	curve_id,
	the_geom
       FROM inp_selector_sector, v_node n
   JOIN inp_tank USING (node_id)
   WHERE n.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

CREATE TRIGGER gw_trg_edit_inp_node_tank
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_tank
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_tank');

    
CREATE OR REPLACE VIEW v_edit_inp_shortpipe AS 
 SELECT n.node_id,
	elevation,
	depth,
	nodecat_id,
	n.sector_id,
	macrosector_id,
	dma_id,
	state,
	state_type,
	annotation,
	expl_id,
	minorloss,
	to_arc,
	status,
	the_geom
       FROM inp_selector_sector, v_node n
   JOIN inp_shortpipe USING (node_id)
   WHERE n.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

CREATE TRIGGER gw_trg_edit_inp_node_shortpipe
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_shortpipe
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_node('inp_shortpipe');
  

CREATE OR REPLACE VIEW v_edit_inp_pipe AS 
 SELECT arc.arc_id,
	arc.node_1,
	arc.node_2,
	arc.arccat_id,
	arc.sector_id,
	arc.macrosector_id,
	dma_id,
	arc.state,
	arc.state_type,
	arc.annotation,
	arc.expl_id,
	arc.custom_length,
	inp_pipe.minorloss,
	inp_pipe.status,
	inp_pipe.custom_roughness,
	inp_pipe.custom_dint,
	arc.the_geom
   FROM inp_selector_sector, v_arc arc
   JOIN inp_pipe USING (arc_id)
   WHERE arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

CREATE TRIGGER gw_trg_edit_inp_arc_pipe
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_pipe
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_pipe');
  

CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
 SELECT v_arc.arc_id,
	v_arc.node_1,
	v_arc.node_2,
	(v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
	(v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
	v_arc.arccat_id,
	v_arc.sector_id,
	v_arc.macrosector_id,
	dma_id,
	v_arc.state,
	v_arc.state_type,
	v_arc.annotation,
	v_arc.expl_id,
	inp_virtualvalve.valv_type,
	inp_virtualvalve.pressure,
	inp_virtualvalve.flow,
	inp_virtualvalve.coef_loss,
	inp_virtualvalve.curve_id,
	inp_virtualvalve.minorloss,
	inp_virtualvalve.to_arc,
	inp_virtualvalve.status,
	v_arc.the_geom
   FROM inp_selector_sector, v_arc
	 JOIN inp_virtualvalve USING (arc_id)
  WHERE v_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

CREATE TRIGGER gw_trg_edit_inp_arc_virtualvalve
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON v_edit_inp_virtualvalve
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_edit_inp_arc('inp_virtualvalve');

  
CREATE OR REPLACE VIEW v_rtc_period_hydrometer AS 
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
	v_connec.connec_id,
	NULL::character varying(16) AS pjoint_id,
	rpt_inp_arc.node_1,
	rpt_inp_arc.node_2,
	ext_cat_period.id AS period_id,
	ext_cat_period.period_seconds,
	c.dma_id,
	c.effc::numeric(5,4) AS effc,
	c.minc,
	c.maxc,
		CASE
			WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
			ELSE ext_rtc_hydrometer_x_data.sum
		END AS m3_total_period,
		CASE
			WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
			ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
		END AS lps_avg,
	ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
	 JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
	 JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
	 JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
	 JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
	 JOIN rpt_inp_arc ON v_connec.arc_id::text = rpt_inp_arc.arc_id::text
	 JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
		   FROM config_param_user
		  WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_arc.result_id::text = ((( SELECT inp_selector_result.result_id
		   FROM inp_selector_result
		  WHERE inp_selector_result.cur_user = "current_user"()::text))::text)
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
	v_connec.connec_id,
	rpt_inp_node.node_id AS pjoint_id,
	NULL::character varying AS node_1,
	NULL::character varying AS node_2,
	ext_cat_period.id AS period_id,
	ext_cat_period.period_seconds,
	c.dma_id,
	c.effc::numeric(5,4) AS effc,
	c.minc,
	c.maxc,
		CASE
			WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
			ELSE ext_rtc_hydrometer_x_data.sum
		END AS m3_total_period,
		CASE
			WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
			ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
		END AS lps_avg,
	ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
	 JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
	 JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
	 JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
	 LEFT JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
	 JOIN rpt_inp_node ON concat('VN', v_connec.pjoint_id) = rpt_inp_node.node_id::text
	 JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_connec.dma_id::text = c.dma_id::text
  WHERE v_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
		   FROM config_param_user
		  WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_node.result_id::text = ((( SELECT inp_selector_result.result_id
		   FROM inp_selector_result
		  WHERE inp_selector_result.cur_user = "current_user"()::text))::text)
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
	v_connec.connec_id,
	rpt_inp_node.node_id AS pjoint_id,
	NULL::character varying AS node_1,
	NULL::character varying AS node_2,
	ext_cat_period.id AS period_id,
	ext_cat_period.period_seconds,
	c.dma_id,
	c.effc::numeric(5,4) AS effc,
	c.minc,
	c.maxc,
		CASE
			WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
			ELSE ext_rtc_hydrometer_x_data.sum
		END AS m3_total_period,
		CASE
			WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
			ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
		END AS lps_avg,
	ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
	 JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
	 JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
	 JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
	 LEFT JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
	 JOIN rpt_inp_node ON v_connec.pjoint_id::text = rpt_inp_node.node_id::text
	 JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_connec.dma_id::text = c.dma_id::text
  WHERE v_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
		   FROM config_param_user
		  WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_node.result_id::text = ((( SELECT inp_selector_result.result_id
		   FROM inp_selector_result
		  WHERE inp_selector_result.cur_user = "current_user"()::text))::text);





CREATE OR REPLACE VIEW v_rtc_period_nodepattern AS 
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
	( SELECT config_param_user.value
		   FROM config_param_user
		  WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text) AS period_id,
	a.idrow,
	a.pattern_id,
	sum(a.factor_1)::numeric(10,8) AS factor_1,
	sum(a.factor_2)::numeric(10,8) AS factor_2,
	sum(a.factor_3)::numeric(10,8) AS factor_3,
	sum(a.factor_4)::numeric(10,8) AS factor_4,
	sum(a.factor_5)::numeric(10,8) AS factor_5,
	sum(a.factor_6)::numeric(10,8) AS factor_6,
	sum(a.factor_7)::numeric(10,8) AS factor_7,
	sum(a.factor_8)::numeric(10,8) AS factor_8,
	sum(a.factor_9)::numeric(10,8) AS factor_9,
	sum(a.factor_10)::numeric(10,8) AS factor_10,
	sum(a.factor_11)::numeric(10,8) AS factor_11,
	sum(a.factor_12)::numeric(10,8) AS factor_12,
	sum(a.factor_13)::numeric(10,8) AS factor_13,
	sum(a.factor_14)::numeric(10,8) AS factor_14,
	sum(a.factor_15)::numeric(10,8) AS factor_15,
	sum(a.factor_16)::numeric(10,8) AS factor_16,
	sum(a.factor_17)::numeric(10,8) AS factor_17,
	sum(a.factor_18)::numeric(10,8) AS factor_18
   FROM ( SELECT
				CASE
					WHEN b.id = (( SELECT min(sub.id) AS min
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
					WHEN b.id = (( SELECT min(sub.id) + 1
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
					WHEN b.id = (( SELECT min(sub.id) + 2
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
					WHEN b.id = (( SELECT min(sub.id) + 3
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
					WHEN b.id = (( SELECT min(sub.id) + 4
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
					WHEN b.id = (( SELECT min(sub.id) + 5
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
					WHEN b.id = (( SELECT min(sub.id) + 6
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
					WHEN b.id = (( SELECT min(sub.id) + 7
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
					WHEN b.id = (( SELECT min(sub.id) + 8
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
					WHEN b.id = (( SELECT min(sub.id) + 9
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
					WHEN b.id = (( SELECT min(sub.id) + 10
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
					WHEN b.id = (( SELECT min(sub.id) + 11
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
					WHEN b.id = (( SELECT min(sub.id) + 12
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
					WHEN b.id = (( SELECT min(sub.id) + 13
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
					WHEN b.id = (( SELECT min(sub.id) + 14
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
					WHEN b.id = (( SELECT min(sub.id) + 15
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
					WHEN b.id = (( SELECT min(sub.id) + 16
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
					WHEN b.id = (( SELECT min(sub.id) + 17
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
					WHEN b.id = (( SELECT min(sub.id) + 18
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
					WHEN b.id = (( SELECT min(sub.id) + 19
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
					WHEN b.id = (( SELECT min(sub.id) + 20
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
					WHEN b.id = (( SELECT min(sub.id) + 21
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
					WHEN b.id = (( SELECT min(sub.id) + 22
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
					WHEN b.id = (( SELECT min(sub.id) + 23
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
					WHEN b.id = (( SELECT min(sub.id) + 24
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
					WHEN b.id = (( SELECT min(sub.id) + 25
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
					WHEN b.id = (( SELECT min(sub.id) + 26
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
					WHEN b.id = (( SELECT min(sub.id) + 27
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
					WHEN b.id = (( SELECT min(sub.id) + 28
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
					WHEN b.id = (( SELECT min(sub.id) + 29
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
					ELSE NULL::integer
				END AS idrow,
			a_1.node_1 AS pattern_id,
			sum(a_1.lps_avg * b.factor_1::double precision * 0.5::double precision) AS factor_1,
			sum(a_1.lps_avg * b.factor_2::double precision * 0.5::double precision) AS factor_2,
			sum(a_1.lps_avg * b.factor_3::double precision * 0.5::double precision) AS factor_3,
			sum(a_1.lps_avg * b.factor_4::double precision * 0.5::double precision) AS factor_4,
			sum(a_1.lps_avg * b.factor_5::double precision * 0.5::double precision) AS factor_5,
			sum(a_1.lps_avg * b.factor_6::double precision * 0.5::double precision) AS factor_6,
			sum(a_1.lps_avg * b.factor_7::double precision * 0.5::double precision) AS factor_7,
			sum(a_1.lps_avg * b.factor_8::double precision * 0.5::double precision) AS factor_8,
			sum(a_1.lps_avg * b.factor_9::double precision * 0.5::double precision) AS factor_9,
			sum(a_1.lps_avg * b.factor_10::double precision * 0.5::double precision) AS factor_10,
			sum(a_1.lps_avg * b.factor_11::double precision * 0.5::double precision) AS factor_11,
			sum(a_1.lps_avg * b.factor_12::double precision * 0.5::double precision) AS factor_12,
			sum(a_1.lps_avg * b.factor_13::double precision * 0.5::double precision) AS factor_13,
			sum(a_1.lps_avg * b.factor_14::double precision * 0.5::double precision) AS factor_14,
			sum(a_1.lps_avg * b.factor_15::double precision * 0.5::double precision) AS factor_15,
			sum(a_1.lps_avg * b.factor_16::double precision * 0.5::double precision) AS factor_16,
			sum(a_1.lps_avg * b.factor_17::double precision * 0.5::double precision) AS factor_17,
			sum(a_1.lps_avg * b.factor_18::double precision * 0.5::double precision) AS factor_18
		   FROM v_rtc_period_hydrometer a_1
			 JOIN inp_pattern_value b USING (pattern_id)
		  GROUP BY a_1.node_1, (
				CASE
					WHEN b.id = (( SELECT min(sub.id) AS min
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
					WHEN b.id = (( SELECT min(sub.id) + 1
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
					WHEN b.id = (( SELECT min(sub.id) + 2
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
					WHEN b.id = (( SELECT min(sub.id) + 3
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
					WHEN b.id = (( SELECT min(sub.id) + 4
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
					WHEN b.id = (( SELECT min(sub.id) + 5
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
					WHEN b.id = (( SELECT min(sub.id) + 6
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
					WHEN b.id = (( SELECT min(sub.id) + 7
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
					WHEN b.id = (( SELECT min(sub.id) + 8
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
					WHEN b.id = (( SELECT min(sub.id) + 9
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
					WHEN b.id = (( SELECT min(sub.id) + 10
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
					WHEN b.id = (( SELECT min(sub.id) + 11
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
					WHEN b.id = (( SELECT min(sub.id) + 12
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
					WHEN b.id = (( SELECT min(sub.id) + 13
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
					WHEN b.id = (( SELECT min(sub.id) + 14
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
					WHEN b.id = (( SELECT min(sub.id) + 15
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
					WHEN b.id = (( SELECT min(sub.id) + 16
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
					WHEN b.id = (( SELECT min(sub.id) + 17
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
					WHEN b.id = (( SELECT min(sub.id) + 18
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
					WHEN b.id = (( SELECT min(sub.id) + 19
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
					WHEN b.id = (( SELECT min(sub.id) + 20
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
					WHEN b.id = (( SELECT min(sub.id) + 21
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
					WHEN b.id = (( SELECT min(sub.id) + 22
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
					WHEN b.id = (( SELECT min(sub.id) + 23
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
					WHEN b.id = (( SELECT min(sub.id) + 24
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
					WHEN b.id = (( SELECT min(sub.id) + 25
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
					WHEN b.id = (( SELECT min(sub.id) + 26
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
					WHEN b.id = (( SELECT min(sub.id) + 27
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
					WHEN b.id = (( SELECT min(sub.id) + 28
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
					WHEN b.id = (( SELECT min(sub.id) + 29
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
					ELSE NULL::integer
				END)
		UNION
		 SELECT
				CASE
					WHEN b.id = (( SELECT min(sub.id) AS min
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
					WHEN b.id = (( SELECT min(sub.id) + 1
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
					WHEN b.id = (( SELECT min(sub.id) + 2
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
					WHEN b.id = (( SELECT min(sub.id) + 3
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
					WHEN b.id = (( SELECT min(sub.id) + 4
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
					WHEN b.id = (( SELECT min(sub.id) + 5
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
					WHEN b.id = (( SELECT min(sub.id) + 6
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
					WHEN b.id = (( SELECT min(sub.id) + 7
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
					WHEN b.id = (( SELECT min(sub.id) + 8
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
					WHEN b.id = (( SELECT min(sub.id) + 9
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
					WHEN b.id = (( SELECT min(sub.id) + 10
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
					WHEN b.id = (( SELECT min(sub.id) + 11
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
					WHEN b.id = (( SELECT min(sub.id) + 12
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
					WHEN b.id = (( SELECT min(sub.id) + 13
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
					WHEN b.id = (( SELECT min(sub.id) + 14
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
					WHEN b.id = (( SELECT min(sub.id) + 15
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
					WHEN b.id = (( SELECT min(sub.id) + 16
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
					WHEN b.id = (( SELECT min(sub.id) + 17
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
					WHEN b.id = (( SELECT min(sub.id) + 18
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
					WHEN b.id = (( SELECT min(sub.id) + 19
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
					WHEN b.id = (( SELECT min(sub.id) + 20
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
					WHEN b.id = (( SELECT min(sub.id) + 21
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
					WHEN b.id = (( SELECT min(sub.id) + 22
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
					WHEN b.id = (( SELECT min(sub.id) + 23
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
					WHEN b.id = (( SELECT min(sub.id) + 24
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
					WHEN b.id = (( SELECT min(sub.id) + 25
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
					WHEN b.id = (( SELECT min(sub.id) + 26
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
					WHEN b.id = (( SELECT min(sub.id) + 27
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
					WHEN b.id = (( SELECT min(sub.id) + 28
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
					WHEN b.id = (( SELECT min(sub.id) + 29
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
					ELSE NULL::integer
				END AS idrow,
			a_1.node_2,
			sum(a_1.lps_avg * b.factor_1::double precision * 0.5::double precision) AS factor_1,
			sum(a_1.lps_avg * b.factor_2::double precision * 0.5::double precision) AS factor_2,
			sum(a_1.lps_avg * b.factor_3::double precision * 0.5::double precision) AS factor_3,
			sum(a_1.lps_avg * b.factor_4::double precision * 0.5::double precision) AS factor_4,
			sum(a_1.lps_avg * b.factor_5::double precision * 0.5::double precision) AS factor_5,
			sum(a_1.lps_avg * b.factor_6::double precision * 0.5::double precision) AS factor_6,
			sum(a_1.lps_avg * b.factor_7::double precision * 0.5::double precision) AS factor_7,
			sum(a_1.lps_avg * b.factor_8::double precision * 0.5::double precision) AS factor_8,
			sum(a_1.lps_avg * b.factor_9::double precision * 0.5::double precision) AS factor_9,
			sum(a_1.lps_avg * b.factor_10::double precision * 0.5::double precision) AS factor_10,
			sum(a_1.lps_avg * b.factor_11::double precision * 0.5::double precision) AS factor_11,
			sum(a_1.lps_avg * b.factor_12::double precision * 0.5::double precision) AS factor_12,
			sum(a_1.lps_avg * b.factor_13::double precision * 0.5::double precision) AS factor_13,
			sum(a_1.lps_avg * b.factor_14::double precision * 0.5::double precision) AS factor_14,
			sum(a_1.lps_avg * b.factor_15::double precision * 0.5::double precision) AS factor_15,
			sum(a_1.lps_avg * b.factor_16::double precision * 0.5::double precision) AS factor_16,
			sum(a_1.lps_avg * b.factor_17::double precision * 0.5::double precision) AS factor_17,
			sum(a_1.lps_avg * b.factor_18::double precision * 0.5::double precision) AS factor_18
		   FROM v_rtc_period_hydrometer a_1
			 JOIN inp_pattern_value b USING (pattern_id)
		  GROUP BY a_1.node_2, (
				CASE
					WHEN b.id = (( SELECT min(sub.id) AS min
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
					WHEN b.id = (( SELECT min(sub.id) + 1
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
					WHEN b.id = (( SELECT min(sub.id) + 2
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
					WHEN b.id = (( SELECT min(sub.id) + 3
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
					WHEN b.id = (( SELECT min(sub.id) + 4
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
					WHEN b.id = (( SELECT min(sub.id) + 5
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
					WHEN b.id = (( SELECT min(sub.id) + 6
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
					WHEN b.id = (( SELECT min(sub.id) + 7
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
					WHEN b.id = (( SELECT min(sub.id) + 8
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
					WHEN b.id = (( SELECT min(sub.id) + 9
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
					WHEN b.id = (( SELECT min(sub.id) + 10
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
					WHEN b.id = (( SELECT min(sub.id) + 11
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
					WHEN b.id = (( SELECT min(sub.id) + 12
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
					WHEN b.id = (( SELECT min(sub.id) + 13
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
					WHEN b.id = (( SELECT min(sub.id) + 14
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
					WHEN b.id = (( SELECT min(sub.id) + 15
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
					WHEN b.id = (( SELECT min(sub.id) + 16
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
					WHEN b.id = (( SELECT min(sub.id) + 17
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
					WHEN b.id = (( SELECT min(sub.id) + 18
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
					WHEN b.id = (( SELECT min(sub.id) + 19
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
					WHEN b.id = (( SELECT min(sub.id) + 20
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
					WHEN b.id = (( SELECT min(sub.id) + 21
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
					WHEN b.id = (( SELECT min(sub.id) + 22
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
					WHEN b.id = (( SELECT min(sub.id) + 23
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
					WHEN b.id = (( SELECT min(sub.id) + 24
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
					WHEN b.id = (( SELECT min(sub.id) + 25
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
					WHEN b.id = (( SELECT min(sub.id) + 26
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
					WHEN b.id = (( SELECT min(sub.id) + 27
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
					WHEN b.id = (( SELECT min(sub.id) + 28
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
					WHEN b.id = (( SELECT min(sub.id) + 29
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
					ELSE NULL::integer
				END)
  ORDER BY 2) a
  GROUP BY a.idrow, a.pattern_id;


CREATE OR REPLACE VIEW v_rtc_interval_nodepattern AS 
 SELECT v_rtc_period_nodepattern.id,
	v_rtc_period_nodepattern.period_id,
	v_rtc_period_nodepattern.idrow,
	v_rtc_period_nodepattern.pattern_id,
	v_rtc_period_nodepattern.factor_1,
	v_rtc_period_nodepattern.factor_2,
	v_rtc_period_nodepattern.factor_3,
	v_rtc_period_nodepattern.factor_4,
	v_rtc_period_nodepattern.factor_5,
	v_rtc_period_nodepattern.factor_6,
	v_rtc_period_nodepattern.factor_7,
	v_rtc_period_nodepattern.factor_8,
	v_rtc_period_nodepattern.factor_9,
	v_rtc_period_nodepattern.factor_10,
	v_rtc_period_nodepattern.factor_11,
	v_rtc_period_nodepattern.factor_12,
	v_rtc_period_nodepattern.factor_13,
	v_rtc_period_nodepattern.factor_14,
	v_rtc_period_nodepattern.factor_15,
	v_rtc_period_nodepattern.factor_16,
	v_rtc_period_nodepattern.factor_17,
	v_rtc_period_nodepattern.factor_18
   FROM v_rtc_period_nodepattern;



CREATE OR REPLACE VIEW v_rtc_period_dma AS 
 SELECT v_rtc_period_hydrometer.dma_id::integer AS dma_id,
	v_rtc_period_hydrometer.period_id,
	sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period,
	a.pattern_id
   FROM v_rtc_period_hydrometer
	 JOIN ext_rtc_dma_period a ON a.dma_id::text = v_rtc_period_hydrometer.dma_id::text AND v_rtc_period_hydrometer.period_id::text = a.cat_period_id::text
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;



CREATE OR REPLACE VIEW v_rtc_interval_nodepattern AS 
 SELECT v_rtc_period_nodepattern.id,
	v_rtc_period_nodepattern.period_id,
	v_rtc_period_nodepattern.idrow,
	v_rtc_period_nodepattern.pattern_id,
	v_rtc_period_nodepattern.factor_1,
	v_rtc_period_nodepattern.factor_2,
	v_rtc_period_nodepattern.factor_3,
	v_rtc_period_nodepattern.factor_4,
	v_rtc_period_nodepattern.factor_5,
	v_rtc_period_nodepattern.factor_6,
	v_rtc_period_nodepattern.factor_7,
	v_rtc_period_nodepattern.factor_8,
	v_rtc_period_nodepattern.factor_9,
	v_rtc_period_nodepattern.factor_10,
	v_rtc_period_nodepattern.factor_11,
	v_rtc_period_nodepattern.factor_12,
	v_rtc_period_nodepattern.factor_13,
	v_rtc_period_nodepattern.factor_14,
	v_rtc_period_nodepattern.factor_15,
	v_rtc_period_nodepattern.factor_16,
	v_rtc_period_nodepattern.factor_17,
	v_rtc_period_nodepattern.factor_18
   FROM v_rtc_period_nodepattern;


CREATE OR REPLACE VIEW v_rtc_period_node AS 
 SELECT a.node_id,
	a.dma_id,
	a.period_id,
	sum(a.lps_avg) AS lps_avg,
	a.effc,
	sum(a.lps_avg_real) AS lps_avg_real,
	a.minc,
	sum(a.lps_min) AS lps_min,
	a.maxc,
	sum(a.lps_max) AS lps_max,
	sum(a.m3_total_period) AS m3_total_period
   FROM ( SELECT v_rtc_period_hydrometer.node_1 AS node_id,
			v_rtc_period_hydrometer.dma_id,
			v_rtc_period_hydrometer.period_id,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
			v_rtc_period_hydrometer.effc,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
			v_rtc_period_hydrometer.minc,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
			v_rtc_period_hydrometer.maxc,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
			sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
		   FROM v_rtc_period_hydrometer
		  WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
		  GROUP BY v_rtc_period_hydrometer.node_1, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc
		UNION
		 SELECT v_rtc_period_hydrometer.node_2 AS node_id,
			v_rtc_period_hydrometer.dma_id,
			v_rtc_period_hydrometer.period_id,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
			v_rtc_period_hydrometer.effc,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
			v_rtc_period_hydrometer.minc,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
			v_rtc_period_hydrometer.maxc,
			sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
			sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
		   FROM v_rtc_period_hydrometer
		  WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
		  GROUP BY v_rtc_period_hydrometer.node_2, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc) a
  GROUP BY a.node_id, a.period_id, a.dma_id, a.effc, a.minc, a.maxc;



CREATE OR REPLACE VIEW v_rtc_period_pjoint AS 
 SELECT v_rtc_period_hydrometer.pjoint_id,
	v_rtc_period_hydrometer.dma_id,
	v_rtc_period_hydrometer.period_id,
	sum(v_rtc_period_hydrometer.lps_avg) AS lps_avg,
	v_rtc_period_hydrometer.effc,
	sum(v_rtc_period_hydrometer.lps_avg / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
	v_rtc_period_hydrometer.minc,
	sum(v_rtc_period_hydrometer.lps_avg / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
	v_rtc_period_hydrometer.maxc,
	sum(v_rtc_period_hydrometer.lps_avg / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
	sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period
   FROM v_rtc_period_hydrometer
  WHERE v_rtc_period_hydrometer.pjoint_id IS NOT NULL
  GROUP BY v_rtc_period_hydrometer.pjoint_id, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc;



CREATE OR REPLACE VIEW v_rtc_period_pjointpattern AS 
 SELECT row_number() OVER (ORDER BY a.pattern_id, a.idrow) AS id,
	a.period_id,
	a.idrow,
	a.pattern_id,
	sum(a.factor_1)::numeric(10,8) AS factor_1,
	sum(a.factor_2)::numeric(10,8) AS factor_2,
	sum(a.factor_3)::numeric(10,8) AS factor_3,
	sum(a.factor_4)::numeric(10,8) AS factor_4,
	sum(a.factor_5)::numeric(10,8) AS factor_5,
	sum(a.factor_6)::numeric(10,8) AS factor_6,
	sum(a.factor_7)::numeric(10,8) AS factor_7,
	sum(a.factor_8)::numeric(10,8) AS factor_8,
	sum(a.factor_9)::numeric(10,8) AS factor_9,
	sum(a.factor_10)::numeric(10,8) AS factor_10,
	sum(a.factor_11)::numeric(10,8) AS factor_11,
	sum(a.factor_12)::numeric(10,8) AS factor_12,
	sum(a.factor_13)::numeric(10,8) AS factor_13,
	sum(a.factor_14)::numeric(10,8) AS factor_14,
	sum(a.factor_15)::numeric(10,8) AS factor_15,
	sum(a.factor_16)::numeric(10,8) AS factor_16,
	sum(a.factor_17)::numeric(10,8) AS factor_17,
	sum(a.factor_18)::numeric(10,8) AS factor_18
   FROM ( SELECT
				CASE
					WHEN b.id = (( SELECT min(sub.id) AS min
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
					WHEN b.id = (( SELECT min(sub.id) + 1
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
					WHEN b.id = (( SELECT min(sub.id) + 2
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
					WHEN b.id = (( SELECT min(sub.id) + 3
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
					WHEN b.id = (( SELECT min(sub.id) + 4
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
					WHEN b.id = (( SELECT min(sub.id) + 5
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
					WHEN b.id = (( SELECT min(sub.id) + 6
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
					WHEN b.id = (( SELECT min(sub.id) + 7
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
					WHEN b.id = (( SELECT min(sub.id) + 8
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
					WHEN b.id = (( SELECT min(sub.id) + 9
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
					WHEN b.id = (( SELECT min(sub.id) + 10
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
					WHEN b.id = (( SELECT min(sub.id) + 11
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
					WHEN b.id = (( SELECT min(sub.id) + 12
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
					WHEN b.id = (( SELECT min(sub.id) + 13
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
					WHEN b.id = (( SELECT min(sub.id) + 14
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
					WHEN b.id = (( SELECT min(sub.id) + 15
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
					WHEN b.id = (( SELECT min(sub.id) + 16
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
					WHEN b.id = (( SELECT min(sub.id) + 17
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
					WHEN b.id = (( SELECT min(sub.id) + 18
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
					WHEN b.id = (( SELECT min(sub.id) + 19
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
					WHEN b.id = (( SELECT min(sub.id) + 20
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
					WHEN b.id = (( SELECT min(sub.id) + 21
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
					WHEN b.id = (( SELECT min(sub.id) + 22
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
					WHEN b.id = (( SELECT min(sub.id) + 23
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
					WHEN b.id = (( SELECT min(sub.id) + 24
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
					WHEN b.id = (( SELECT min(sub.id) + 25
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
					WHEN b.id = (( SELECT min(sub.id) + 26
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
					WHEN b.id = (( SELECT min(sub.id) + 27
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
					WHEN b.id = (( SELECT min(sub.id) + 28
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
					WHEN b.id = (( SELECT min(sub.id) + 29
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
					ELSE NULL::integer
				END AS idrow,
			v_rtc_period_hydrometer.pjoint_id AS pattern_id,
			v_rtc_period_hydrometer.period_id,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_1::double precision) AS factor_1,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_2::double precision) AS factor_2,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_3::double precision) AS factor_3,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_4::double precision) AS factor_4,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_5::double precision) AS factor_5,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_6::double precision) AS factor_6,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_7::double precision) AS factor_7,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_8::double precision) AS factor_8,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_9::double precision) AS factor_9,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_10::double precision) AS factor_10,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_11::double precision) AS factor_11,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_12::double precision) AS factor_12,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_13::double precision) AS factor_13,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_14::double precision) AS factor_14,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_15::double precision) AS factor_15,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_16::double precision) AS factor_16,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_17::double precision) AS factor_17,
			sum(v_rtc_period_hydrometer.lps_avg * b.factor_18::double precision) AS factor_18
		   FROM v_rtc_period_hydrometer
			 JOIN inp_pattern_value b USING (pattern_id)
		  GROUP BY v_rtc_period_hydrometer.pjoint_id, (
				CASE
					WHEN b.id = (( SELECT min(sub.id) AS min
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 1
					WHEN b.id = (( SELECT min(sub.id) + 1
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 2
					WHEN b.id = (( SELECT min(sub.id) + 2
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 3
					WHEN b.id = (( SELECT min(sub.id) + 3
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 4
					WHEN b.id = (( SELECT min(sub.id) + 4
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 5
					WHEN b.id = (( SELECT min(sub.id) + 5
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 6
					WHEN b.id = (( SELECT min(sub.id) + 6
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 7
					WHEN b.id = (( SELECT min(sub.id) + 7
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 8
					WHEN b.id = (( SELECT min(sub.id) + 8
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 9
					WHEN b.id = (( SELECT min(sub.id) + 9
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 10
					WHEN b.id = (( SELECT min(sub.id) + 10
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 11
					WHEN b.id = (( SELECT min(sub.id) + 11
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 12
					WHEN b.id = (( SELECT min(sub.id) + 12
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 13
					WHEN b.id = (( SELECT min(sub.id) + 13
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 14
					WHEN b.id = (( SELECT min(sub.id) + 14
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 15
					WHEN b.id = (( SELECT min(sub.id) + 15
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 16
					WHEN b.id = (( SELECT min(sub.id) + 16
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 17
					WHEN b.id = (( SELECT min(sub.id) + 17
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 18
					WHEN b.id = (( SELECT min(sub.id) + 18
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 19
					WHEN b.id = (( SELECT min(sub.id) + 19
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 20
					WHEN b.id = (( SELECT min(sub.id) + 20
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 21
					WHEN b.id = (( SELECT min(sub.id) + 21
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 22
					WHEN b.id = (( SELECT min(sub.id) + 22
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 23
					WHEN b.id = (( SELECT min(sub.id) + 23
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 24
					WHEN b.id = (( SELECT min(sub.id) + 24
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 25
					WHEN b.id = (( SELECT min(sub.id) + 25
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 26
					WHEN b.id = (( SELECT min(sub.id) + 26
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 27
					WHEN b.id = (( SELECT min(sub.id) + 27
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 28
					WHEN b.id = (( SELECT min(sub.id) + 28
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 29
					WHEN b.id = (( SELECT min(sub.id) + 29
					   FROM inp_pattern_value sub
					  WHERE sub.pattern_id::text = b.pattern_id::text)) THEN 30
					ELSE NULL::integer
				END), v_rtc_period_hydrometer.period_id) a
  WHERE a.pattern_id IS NOT NULL
  GROUP BY a.period_id, a.idrow, a.pattern_id;


		  
CREATE OR REPLACE VIEW vi_parent_connec AS 
 SELECT ve_connec.*
   FROM ve_connec,
	inp_selector_sector
  WHERE ve_connec.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_parent_hydrometer AS 
 SELECT v_rtc_hydrometer.hydrometer_id,
	v_rtc_hydrometer.hydrometer_customer_code,
	v_rtc_hydrometer.connec_id,
	v_rtc_hydrometer.connec_customer_code,
	v_rtc_hydrometer.state,
	v_rtc_hydrometer.muni_name,
	v_rtc_hydrometer.expl_id,
	v_rtc_hydrometer.expl_name,
	v_rtc_hydrometer.plot_code,
	v_rtc_hydrometer.priority_id,
	v_rtc_hydrometer.catalog_id,
	v_rtc_hydrometer.category_id,
	v_rtc_hydrometer.hydro_number,
	v_rtc_hydrometer.hydro_man_date,
	v_rtc_hydrometer.crm_number,
	v_rtc_hydrometer.customer_name,
	v_rtc_hydrometer.address1,
	v_rtc_hydrometer.address2,
	v_rtc_hydrometer.address3,
	v_rtc_hydrometer.address2_1,
	v_rtc_hydrometer.address2_2,
	v_rtc_hydrometer.address2_3,
	v_rtc_hydrometer.m3_volume,
	v_rtc_hydrometer.start_date,
	v_rtc_hydrometer.end_date,
	v_rtc_hydrometer.update_date,
	v_rtc_hydrometer.hydrometer_link
   FROM v_rtc_hydrometer
	 JOIN ve_connec USING (connec_id);


CREATE OR REPLACE VIEW v_price_x_catarc AS 
SELECT cat_arc.id,
cat_arc.dint,
cat_arc.z1,
cat_arc.z2,
cat_arc.width,
cat_arc.area,
cat_arc.bulk,
cat_arc.estimated_depth,
cat_arc.cost_unit,
price_cost.price AS cost,
price_m2bottom.price AS m2bottom_cost,
price_m3protec.price AS m3protec_cost
FROM cat_arc
JOIN v_price_compost price_cost ON cat_arc.cost::text = price_cost.id::text
JOIN v_price_compost price_m2bottom ON cat_arc.m2bottom_cost::text = price_m2bottom.id::text
JOIN v_price_compost price_m3protec ON cat_arc.m3protec_cost::text = price_m3protec.id::text;


CREATE OR REPLACE VIEW v_price_x_catconnec AS 
SELECT cat_connec.id,
price_cost.price AS cost_ut,
price_m3.price AS cost_m3trench,
price_m1.price AS cost_mlconnec
FROM cat_connec
JOIN v_price_compost price_cost ON cat_connec.cost_ut::text = price_cost.id::text
JOIN v_price_compost price_m3 ON cat_connec.cost_m3::text = price_m3.id::text
JOIN v_price_compost price_m1 ON cat_connec.cost_ml::text = price_m1.id::text;

CREATE OR REPLACE VIEW v_price_x_catsoil AS 
SELECT cat_soil.id,
cat_soil.y_param,
cat_soil.b,
cat_soil.trenchlining,
price_m3exc.price AS m3exc_cost,
price_m3fill.price AS m3fill_cost,
price_m3excess.price AS m3excess_cost,
price_m2trenchl.price AS m2trenchl_cost
FROM cat_soil
JOIN v_price_compost price_m3exc ON cat_soil.m3exc_cost::text = price_m3exc.id::text
JOIN v_price_compost price_m3fill ON cat_soil.m3fill_cost::text = price_m3fill.id::text
JOIN v_price_compost price_m3excess ON cat_soil.m3excess_cost::text = price_m3excess.id::text
JOIN v_price_compost price_m2trenchl ON cat_soil.m2trenchl_cost::text = price_m2trenchl.id::text
WHERE cat_soil.m2trenchl_cost::text = price_m2trenchl.id::text OR cat_soil.m2trenchl_cost::text = NULL::text;


 
CREATE OR REPLACE VIEW v_plan_node AS 
SELECT *
FROM (
 SELECT v_node.node_id,
	v_node.nodecat_id,
	v_node.sys_type AS node_type,
	v_node.elevation AS top_elev,
	v_node.elevation - v_node.depth AS elev,
	v_node.epa_type,
	v_node.state,
	v_node.sector_id,
	v_node.expl_id,		
	v_node.annotation,
	v_price_x_catnode.cost_unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
		CASE
			WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
			CASE
				WHEN v_node.sys_type::text = 'PUMP'::text THEN
				CASE
					WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
					ELSE 1
				END
				ELSE 1
			END::numeric
			WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
			CASE
				WHEN v_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
				ELSE NULL::numeric
			END
			WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
			CASE
				WHEN v_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
				WHEN v_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
				ELSE v_node.depth
			END
			ELSE NULL::numeric
		END::numeric(12,2) AS measurement,
		CASE
			WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN
			CASE
				WHEN v_node.sys_type::text = 'PUMP'::text THEN
				CASE
					WHEN man_pump.pump_number IS NOT NULL THEN man_pump.pump_number
					ELSE 1
				END
				ELSE 1
			END::numeric * v_price_x_catnode.cost
			WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
			CASE
				WHEN v_node.sys_type::text = 'TANK'::text THEN man_tank.vmax
				ELSE NULL::numeric
			END * v_price_x_catnode.cost
			WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
			CASE
				WHEN v_node.depth = 0::numeric THEN v_price_x_catnode.estimated_depth
				WHEN v_node.depth IS NULL THEN v_price_x_catnode.estimated_depth
				ELSE v_node.depth
			END * v_price_x_catnode.cost
			ELSE NULL::numeric
		END::numeric(12,2) AS budget,
	v_node.the_geom
   FROM v_node
	 LEFT JOIN v_price_x_catnode ON v_node.nodecat_id::text = v_price_x_catnode.id::text
	 LEFT JOIN man_tank ON man_tank.node_id::text = v_node.node_id::text
	 LEFT JOIN man_pump ON man_pump.node_id::text = v_node.node_id::text
 	 LEFT JOIN cat_node ON cat_node.id = v_node.nodecat_id
	 LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text)a;




CREATE OR REPLACE VIEW v_plan_psector_x_node AS 
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
	plan_psector_x_node.psector_id,
	plan_psector.psector_type,
	v_plan_node.node_id,
	v_plan_node.nodecat_id,
	v_plan_node.cost::numeric(12,2) AS cost,
	v_plan_node.measurement,
	v_plan_node.budget AS total_budget,
	v_plan_node.state,
	v_plan_node.expl_id,
	plan_psector.atlas_id,
	v_plan_node.the_geom
   FROM selector_psector,
	v_plan_node
	 JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
	 JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
  WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_psector_x_node.psector_id AND plan_psector_x_node.doable = true
  ORDER BY plan_psector_x_node.psector_id;



CREATE OR REPLACE VIEW v_plan_result_node AS 
 SELECT om_rec_result_node.node_id,
	om_rec_result_node.nodecat_id,
	om_rec_result_node.node_type,
	om_rec_result_node.top_elev,
	om_rec_result_node.elev,
	om_rec_result_node.epa_type,
	om_rec_result_node.state,
	om_rec_result_node.sector_id,
	om_rec_result_node.expl_id,
	om_rec_result_node.cost_unit,
	om_rec_result_node.descript,
	om_rec_result_node.measurement,
	om_rec_result_node.cost,
	om_rec_result_node.budget,
	om_rec_result_node.the_geom,
	om_rec_result_node.builtcost,
	om_rec_result_node.builtdate,
	om_rec_result_node.age,
	om_rec_result_node.acoeff,
	om_rec_result_node.aperiod,
	om_rec_result_node.arate,
	om_rec_result_node.amortized,
	om_rec_result_node.pending
   FROM selector_expl,
	plan_result_selector,
	om_rec_result_node
  WHERE om_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND om_rec_result_node.result_id::text = plan_result_selector.result_id::text AND plan_result_selector.cur_user = "current_user"()::text AND om_rec_result_node.state = 1
UNION
 SELECT v_plan_node.node_id,
	v_plan_node.nodecat_id,
	v_plan_node.node_type,
	v_plan_node.top_elev,
	v_plan_node.elev,
	v_plan_node.epa_type,
	v_plan_node.state,
	v_plan_node.sector_id,
	v_plan_node.expl_id,
	v_plan_node.cost_unit,
	v_plan_node.descript,
	v_plan_node.measurement,
	v_plan_node.cost,
	v_plan_node.budget,
	v_plan_node.the_geom,
	null as builtcost,
	null as builtdate,
	null as age,
	null as acoeff,
	null as aperiod,
	null as arate,
	null as amortized,
	null as pending
   FROM v_plan_node
  WHERE v_plan_node.state = 2;


CREATE OR REPLACE VIEW v_ui_plan_node_cost AS 
 SELECT node.node_id,
	1 AS orderby,
	'element'::text AS identif,
	cat_node.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	1 AS measurement,
	1::numeric * v_price_compost.price AS total_cost
   FROM node
	 JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
	 JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
	 JOIN v_plan_node ON node.node_id::text = v_plan_node.node_id::text;




CREATE OR REPLACE VIEW v_edit_man_varc AS 
 SELECT v_arc.arc_id,
	v_arc.code,
	v_arc.node_1,
	v_arc.node_2,
	v_arc.arccat_id,
	cat_arctype_id,
	v_arc.cat_matcat_id,
	v_arc.cat_pnom,   
	v_arc.cat_dnom,
	v_arc.epa_type,
	v_arc.sector_id,
	v_arc.macrosector_id,
	v_arc.state,
	v_arc.state_type,
	v_arc.annotation,
	v_arc.observ,
	v_arc.comment,
	v_arc.gis_length,
	v_arc.custom_length,
	v_arc.dma_id,
	v_arc.presszone_id,
	v_arc.soilcat_id,
	v_arc.function_type,
	v_arc.category_type,
	v_arc.fluid_type,
	v_arc.location_type,
	v_arc.workcat_id,
	v_arc.workcat_id_end,
	v_arc.buildercat_id,
	v_arc.builtdate,
	v_arc.enddate,
	v_arc.ownercat_id,
	v_arc.muni_id,
	v_arc.postcode,
	v_arc.district_id,
	v_arc. streetname,
	v_arc.postnumber,
	v_arc.postcomplement,
	v_arc.postcomplement2,
	v_arc. streetname2,
	v_arc.postnumber2,
	v_arc.descript,
	v_arc.link,
	v_arc.verified,
	v_arc.undelete,
	v_arc.label_x,
	v_arc.label_y,
	v_arc.label_rotation,
	v_arc.publish,
	v_arc.inventory,
	v_arc.macrodma_id,
	v_arc.expl_id,
	v_arc.num_value,
	v_arc.the_geom
   FROM v_arc
	 JOIN man_varc ON man_varc.arc_id::text = v_arc.arc_id::text;



CREATE OR REPLACE VIEW v_edit_man_pipe AS 
 SELECT v_arc.arc_id,
	v_arc.code,
	v_arc.node_1,
	v_arc.node_2,
	v_arc.arccat_id,
	cat_arctype_id,
	v_arc.cat_matcat_id,
	v_arc.cat_pnom,
	v_arc.cat_dnom,
	v_arc.epa_type,
	v_arc.sector_id,
	v_arc.macrosector_id,
	v_arc.state,
	v_arc.state_type,
	v_arc.annotation,
	v_arc.observ,
	v_arc.comment,
	v_arc.gis_length,
	v_arc.custom_length,
	v_arc.dma_id,
	v_arc.presszone_id,
	v_arc.soilcat_id,
	v_arc.function_type,
	v_arc.category_type,
	v_arc.fluid_type,
	v_arc.location_type,
	v_arc.workcat_id,
	v_arc.workcat_id_end,
	v_arc.buildercat_id,
	v_arc.builtdate,
	v_arc.enddate,
	v_arc.ownercat_id,
	v_arc.muni_id,
	v_arc.postcode,
	v_arc.district_id,
	v_arc. streetname,
	v_arc.postnumber,
	v_arc.postcomplement,
	v_arc.postcomplement2,
	v_arc. streetname2,
	v_arc.postnumber2,
	v_arc.descript,
	v_arc.link,
	v_arc.verified,
	v_arc.undelete,
	v_arc.label_x,
	v_arc.label_y,
	v_arc.label_rotation,
	v_arc.publish,
	v_arc.inventory,
	v_arc.macrodma_id,
	v_arc.expl_id,
	v_arc.num_value,
	v_arc.the_geom
   FROM v_arc
	 JOIN man_pipe ON man_pipe.arc_id::text = v_arc.arc_id::text;


CREATE VIEW v_plan_arc AS 
SELECT *
 FROM (
WITH v_plan_aux_arc_cost AS 
	(WITH v_plan_aux_arc_ml AS
		(SELECT v_arc.arc_id,
		v_arc.depth1,
		v_arc.depth2,
			CASE
				WHEN (v_arc.depth1 * v_arc.depth2) = 0::numeric OR (v_arc.depth1 * v_arc.depth2) IS NULL THEN v_price_x_catarc.estimated_depth
				ELSE ((v_arc.depth1 + v_arc.depth2) / 2::numeric)::numeric(12,2)
			END AS mean_depth,
		v_arc.arccat_id,
		(v_price_x_catarc.dint / 1000::numeric)::numeric(12,4) AS dint,
		v_price_x_catarc.z1,
		v_price_x_catarc.z2,
		v_price_x_catarc.area,
		v_price_x_catarc.width,
		(v_price_x_catarc.bulk / 1000::numeric)::numeric(12,4) AS bulk,
		v_price_x_catarc.cost_unit,
		v_price_x_catarc.cost::numeric(12,2) AS arc_cost,
		v_price_x_catarc.m2bottom_cost::numeric(12,2) AS m2bottom_cost,
		v_price_x_catarc.m3protec_cost::numeric(12,2) AS m3protec_cost,
		v_price_x_catsoil.id AS soilcat_id,
		v_price_x_catsoil.y_param,
		v_price_x_catsoil.b,
		v_price_x_catsoil.trenchlining,
		v_price_x_catsoil.m3exc_cost::numeric(12,2) AS m3exc_cost,
		v_price_x_catsoil.m3fill_cost::numeric(12,2) AS m3fill_cost,
		v_price_x_catsoil.m3excess_cost::numeric(12,2) AS m3excess_cost,
		v_price_x_catsoil.m2trenchl_cost::numeric(12,2) AS m2trenchl_cost,
		v_plan_aux_arc_pavement.thickness,
		v_plan_aux_arc_pavement.m2pav_cost,
		v_arc.state,
		v_arc.expl_id,
		v_arc.the_geom
		FROM v_arc
		 LEFT JOIN v_price_x_catarc ON v_arc.arccat_id::text = v_price_x_catarc.id::text
		 LEFT JOIN v_price_x_catsoil ON v_arc.soilcat_id::text = v_price_x_catsoil.id::text
		 LEFT JOIN plan_arc_x_pavement ON plan_arc_x_pavement.arc_id::text = v_arc.arc_id::text
		 LEFT JOIN (
			SELECT plan_arc_x_pavement.arc_id,
				CASE
				WHEN sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent) IS NULL THEN 0::numeric(12,2)
				ELSE sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)::numeric(12,2)
				END AS thickness,
				CASE
				WHEN sum(v_price_x_catpavement.m2pav_cost) IS NULL THEN 0::numeric(12,2)
				ELSE sum(v_price_x_catpavement.m2pav_cost::numeric(12,2) * plan_arc_x_pavement.percent)
				END AS m2pav_cost
			FROM plan_arc_x_pavement
			LEFT JOIN v_price_x_catpavement ON v_price_x_catpavement.pavcat_id::text = plan_arc_x_pavement.pavcat_id::text
			GROUP BY plan_arc_x_pavement.arc_id) v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id::text = v_arc.arc_id::text
		)
	SELECT v_plan_aux_arc_ml.arc_id,
	v_plan_aux_arc_ml.depth1,
	v_plan_aux_arc_ml.depth2,
	v_plan_aux_arc_ml.mean_depth,
	v_plan_aux_arc_ml.arccat_id,
	v_plan_aux_arc_ml.dint,
	v_plan_aux_arc_ml.z1,
	v_plan_aux_arc_ml.z2,
	v_plan_aux_arc_ml.area,
	v_plan_aux_arc_ml.width,
	v_plan_aux_arc_ml.bulk,
	v_plan_aux_arc_ml.cost_unit,
	v_plan_aux_arc_ml.arc_cost,
	v_plan_aux_arc_ml.m2bottom_cost,
	v_plan_aux_arc_ml.m3protec_cost,
	v_plan_aux_arc_ml.soilcat_id,
	v_plan_aux_arc_ml.y_param,
	v_plan_aux_arc_ml.b,
	v_plan_aux_arc_ml.trenchlining,
	v_plan_aux_arc_ml.m3exc_cost,
	v_plan_aux_arc_ml.m3fill_cost,
	v_plan_aux_arc_ml.m3excess_cost,
	v_plan_aux_arc_ml.m2trenchl_cost,
	v_plan_aux_arc_ml.thickness,
	v_plan_aux_arc_ml.m2pav_cost,
	v_plan_aux_arc_ml.state,
	v_plan_aux_arc_ml.expl_id,
	(2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
	(2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
	(v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_depth,
	(v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
	((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
	((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
	((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_depth + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
	((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.dint + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess,
	v_plan_aux_arc_ml.the_geom
   FROM v_plan_aux_arc_ml)
 SELECT v_plan_aux_arc_cost.arc_id,
	arc.node_1,
	arc.node_2,
	v_plan_aux_arc_cost.arccat_id AS arc_type,
	v_plan_aux_arc_cost.arccat_id,
	arc.epa_type,
	v_plan_aux_arc_cost.state,
	arc.sector_id,
	v_plan_aux_arc_cost.expl_id,
	arc.annotation,
	v_plan_aux_arc_cost.soilcat_id,
	v_plan_aux_arc_cost.depth1 AS y1,
	v_plan_aux_arc_cost.depth2 AS y2,
	v_plan_aux_arc_cost.mean_depth AS mean_y,
	v_plan_aux_arc_cost.z1,
	v_plan_aux_arc_cost.z2,
	v_plan_aux_arc_cost.thickness,
	v_plan_aux_arc_cost.width,
	v_plan_aux_arc_cost.b,
	v_plan_aux_arc_cost.bulk,
	v_plan_aux_arc_cost.dint AS geom1,
	v_plan_aux_arc_cost.area,
	v_plan_aux_arc_cost.y_param,
	(v_plan_aux_arc_cost.calculed_depth + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
	(v_plan_aux_arc_cost.calculed_depth - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.dint)::numeric(12,2) AS rec_y,
	(v_plan_aux_arc_cost.dint + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
	v_plan_aux_arc_cost.calculed_depth AS calculed_y,
	v_plan_aux_arc_cost.m3mlexc,
	v_plan_aux_arc_cost.m2mltrenchl,
	v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
	v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
	v_plan_aux_arc_cost.m3mlprotec,
	v_plan_aux_arc_cost.m3mlfill,
	v_plan_aux_arc_cost.m3mlexcess,
	v_plan_aux_arc_cost.m3exc_cost,
	v_plan_aux_arc_cost.m2trenchl_cost,
	v_plan_aux_arc_cost.m2bottom_cost,
	v_plan_aux_arc_cost.m2pav_cost::numeric(12,2) AS m2pav_cost,
	v_plan_aux_arc_cost.m3protec_cost,
	v_plan_aux_arc_cost.m3fill_cost,
	v_plan_aux_arc_cost.m3excess_cost,
	v_plan_aux_arc_cost.cost_unit,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
			ELSE v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost
		END::numeric(12,3) AS pav_cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
			ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost
		END::numeric(12,3) AS exc_cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
			ELSE v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost
		END::numeric(12,3) AS trenchl_cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
			ELSE v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost
		END::numeric(12,3) AS base_cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
			ELSE v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost
		END::numeric(12,3) AS protec_cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
			ELSE v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost
		END::numeric(12,3) AS fill_cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
			ELSE v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost
		END::numeric(12,3) AS excess_cost,
	v_plan_aux_arc_cost.arc_cost::numeric(12,3) AS arc_cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
			ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost
		END::numeric(12,2) AS cost,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::double precision
			ELSE st_length2d(v_plan_aux_arc_cost.the_geom)
		END::numeric(12,2) AS length,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
			ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2)
		END::numeric(14,2) AS budget,
	v_plan_aux_arc_connec.connec_total_cost AS other_budget,
		CASE
			WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost +
			CASE
				WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
				ELSE v_plan_aux_arc_connec.connec_total_cost
			END
			ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) +
			CASE
				WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
				ELSE v_plan_aux_arc_connec.connec_total_cost
			END
		END::numeric(14,2) AS total_budget,
	v_plan_aux_arc_cost.the_geom
   FROM v_plan_aux_arc_cost
	 JOIN arc ON arc.arc_id::text = v_plan_aux_arc_cost.arc_id::text
	 LEFT JOIN (
		SELECT DISTINCT ON (connec.arc_id) connec.arc_id,
		sum(connec.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * connec.depth * 0.333) + v_price_x_catconnec.cost_ut)::numeric(12,2) AS connec_total_cost
		FROM connec
		JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = connec.connecat_id::text
		GROUP BY connec.arc_id
		 ) v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text)d;



CREATE OR REPLACE VIEW v_plan_result_arc AS 
 SELECT om_rec_result_arc.arc_id,
	om_rec_result_arc.node_1,
	om_rec_result_arc.node_2,
	om_rec_result_arc.arc_type,
	om_rec_result_arc.arccat_id,
	om_rec_result_arc.epa_type,
	om_rec_result_arc.sector_id,
	om_rec_result_arc.expl_id,
	om_rec_result_arc.state,
	om_rec_result_arc.annotation,
	om_rec_result_arc.soilcat_id,
	om_rec_result_arc.y1,
	om_rec_result_arc.y2,
	om_rec_result_arc.mean_y,
	om_rec_result_arc.z1,
	om_rec_result_arc.z2,
	om_rec_result_arc.thickness,
	om_rec_result_arc.width,
	om_rec_result_arc.b,
	om_rec_result_arc.bulk,
	om_rec_result_arc.geom1,
	om_rec_result_arc.area,
	om_rec_result_arc.y_param,
	om_rec_result_arc.total_y,
	om_rec_result_arc.rec_y,
	om_rec_result_arc.geom1_ext,
	om_rec_result_arc.calculed_y,
	om_rec_result_arc.m3mlexc,
	om_rec_result_arc.m2mltrenchl,
	om_rec_result_arc.m2mlbottom,
	om_rec_result_arc.m2mlpav,
	om_rec_result_arc.m3mlprotec,
	om_rec_result_arc.m3mlfill,
	om_rec_result_arc.m3mlexcess,
	om_rec_result_arc.m3exc_cost,
	om_rec_result_arc.m2trenchl_cost,
	om_rec_result_arc.m2bottom_cost,
	om_rec_result_arc.m2pav_cost,
	om_rec_result_arc.m3protec_cost,
	om_rec_result_arc.m3fill_cost,
	om_rec_result_arc.m3excess_cost,
	om_rec_result_arc.cost_unit,
	om_rec_result_arc.pav_cost,
	om_rec_result_arc.exc_cost,
	om_rec_result_arc.trenchl_cost,
	om_rec_result_arc.base_cost,
	om_rec_result_arc.protec_cost,
	om_rec_result_arc.fill_cost,
	om_rec_result_arc.excess_cost,
	om_rec_result_arc.arc_cost,
	om_rec_result_arc.cost,
	om_rec_result_arc.length,
	om_rec_result_arc.budget,
	om_rec_result_arc.other_budget,
	om_rec_result_arc.total_budget,
	om_rec_result_arc.the_geom,
	om_rec_result_arc.builtcost,
	om_rec_result_arc.builtdate,
	om_rec_result_arc.age,
	om_rec_result_arc.acoeff,
	om_rec_result_arc.aperiod,
	om_rec_result_arc.arate,
	om_rec_result_arc.amortized,
	om_rec_result_arc.pending
   FROM plan_result_selector,
	om_rec_result_arc
  WHERE om_rec_result_arc.result_id::text = plan_result_selector.result_id::text AND plan_result_selector.cur_user = "current_user"()::text AND om_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
	v_plan_arc.node_1,
	v_plan_arc.node_2,
	v_plan_arc.arc_type,
	v_plan_arc.arccat_id,
	v_plan_arc.epa_type,
	v_plan_arc.sector_id,
	v_plan_arc.expl_id,
	v_plan_arc.state,
	v_plan_arc.annotation,
	v_plan_arc.soilcat_id,
	v_plan_arc.y1,
	v_plan_arc.y2,
	v_plan_arc.mean_y,
	v_plan_arc.z1,
	v_plan_arc.z2,
	v_plan_arc.thickness,
	v_plan_arc.width,
	v_plan_arc.b,
	v_plan_arc.bulk,
	v_plan_arc.geom1,
	v_plan_arc.area,
	v_plan_arc.y_param,
	v_plan_arc.total_y,
	v_plan_arc.rec_y,
	v_plan_arc.geom1_ext,
	v_plan_arc.calculed_y,
	v_plan_arc.m3mlexc,
	v_plan_arc.m2mltrenchl,
	v_plan_arc.m2mlbottom,
	v_plan_arc.m2mlpav,
	v_plan_arc.m3mlprotec,
	v_plan_arc.m3mlfill,
	v_plan_arc.m3mlexcess,
	v_plan_arc.m3exc_cost,
	v_plan_arc.m2trenchl_cost,
	v_plan_arc.m2bottom_cost,
	v_plan_arc.m2pav_cost,
	v_plan_arc.m3protec_cost,
	v_plan_arc.m3fill_cost,
	v_plan_arc.m3excess_cost,
	v_plan_arc.cost_unit,
	v_plan_arc.pav_cost,
	v_plan_arc.exc_cost,
	v_plan_arc.trenchl_cost,
	v_plan_arc.base_cost,
	v_plan_arc.protec_cost,
	v_plan_arc.fill_cost,
	v_plan_arc.excess_cost,
	v_plan_arc.arc_cost,
	v_plan_arc.cost,
	v_plan_arc.length,
	v_plan_arc.budget,
	v_plan_arc.other_budget,
	v_plan_arc.total_budget,
	v_plan_arc.the_geom,
	null as builtcost,
	null as builtdate,
	null as age,
	null as acoeff,
	null as aperiod,
	null as arate,
	null as amortized,
	null as pending
	FROM v_plan_arc
  WHERE v_plan_arc.state = 2;



CREATE OR REPLACE VIEW v_plan_psector_x_arc AS 
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
	plan_psector_x_arc.psector_id,
	plan_psector.psector_type,
	v_plan_arc.arc_id,
	v_plan_arc.arccat_id,
	v_plan_arc.cost_unit,
	v_plan_arc.cost::numeric(14,2) AS cost,
	v_plan_arc.length,
	v_plan_arc.budget,
	v_plan_arc.other_budget,
	v_plan_arc.total_budget,
	v_plan_arc.state,
	plan_psector.expl_id,
	plan_psector.atlas_id,
	v_plan_arc.the_geom
   FROM selector_psector,
	v_plan_arc
	 JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
	 JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_psector_x_arc.psector_id AND plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id;



CREATE OR REPLACE VIEW v_plan_current_psector_budget AS 
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
	plan_psector_x_arc.psector_id,
	'arc'::text AS feature_type,
	v_plan_arc.arccat_id AS featurecat_id,
	v_plan_arc.arc_id AS feature_id,
	v_plan_arc.length,
	(v_plan_arc.total_budget / v_plan_arc.length)::numeric(14,2) AS unitary_cost,
	v_plan_arc.total_budget
   FROM v_plan_arc
	 JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) + 9999 AS rid,
	plan_psector_x_node.psector_id,
	'node'::text AS feature_type,
	v_plan_node.nodecat_id AS featurecat_id,
	v_plan_node.node_id AS feature_id,
	1 AS length,
	v_plan_node.budget AS unitary_cost,
	v_plan_node.budget AS total_budget
   FROM v_plan_node
	 JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_psector_x_other.id) + 19999 AS rid,
	v_plan_psector_x_other.psector_id,
	'other'::text AS feature_type,
	v_plan_psector_x_other.price_id AS featurecat_id,
	v_plan_psector_x_other.descript AS feature_id,
	v_plan_psector_x_other.measurement AS length,
	v_plan_psector_x_other.price AS unitary_cost,
	v_plan_psector_x_other.total_budget
   FROM v_plan_psector_x_other
  ORDER BY 1, 2, 4;


CREATE OR REPLACE VIEW v_plan_current_psector AS 
 SELECT plan_psector.psector_id,
	plan_psector.name,
	plan_psector.psector_type,
	plan_psector.descript,
	plan_psector.priority,
	a.suma::numeric(14,2) AS total_arc,
	b.suma::numeric(14,2) AS total_node,
	c.suma::numeric(14,2) AS total_other,
	plan_psector.text1,
	plan_psector.text2,
	plan_psector.observ,
	plan_psector.rotation,
	plan_psector.scale,
	plan_psector.sector_id,
	plan_psector.active,
	(
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::numeric(14,2) AS pem,
	plan_psector.gexpenses,
	((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::numeric(14,2) AS pec,
	plan_psector.vat,
	((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::numeric(14,2) AS pec_vat,
	plan_psector.other,
	((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::numeric(14,2) AS pca,
	plan_psector.the_geom
   FROM plan_psector
	 JOIN plan_psector_selector ON plan_psector.psector_id = plan_psector_selector.psector_id
	 LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
			v_plan_psector_x_arc.psector_id
		   FROM v_plan_psector_x_arc
		  GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
	 LEFT JOIN ( SELECT sum(v_plan_psector_x_node.total_budget) AS suma,
			v_plan_psector_x_node.psector_id
		   FROM v_plan_psector_x_node
		  GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
	 LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
			v_plan_psector_x_other.psector_id
		   FROM v_plan_psector_x_other
		  GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector_selector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_plan_current_psector_budget_detail AS 
 SELECT v_plan_arc.arc_id,
	plan_psector_x_arc.psector_id,
	v_plan_arc.arccat_id,
	v_plan_arc.soilcat_id,
	v_plan_arc.y1,
	v_plan_arc.y2,
	v_plan_arc.arc_cost AS mlarc_cost,
	v_plan_arc.m3mlexc,
	v_plan_arc.exc_cost AS mlexc_cost,
	v_plan_arc.m2mltrenchl,
	v_plan_arc.trenchl_cost AS mltrench_cost,
	v_plan_arc.m2mlbottom AS m2mlbase,
	v_plan_arc.base_cost AS mlbase_cost,
	v_plan_arc.m2mlpav,
	v_plan_arc.pav_cost AS mlpav_cost,
	v_plan_arc.m3mlprotec,
	v_plan_arc.protec_cost AS mlprotec_cost,
	v_plan_arc.m3mlfill,
	v_plan_arc.fill_cost AS mlfill_cost,
	v_plan_arc.m3mlexcess,
	v_plan_arc.excess_cost AS mlexcess_cost,
	v_plan_arc.cost AS mltotal_cost,
	v_plan_arc.length,
	v_plan_arc.budget AS other_budget,
	v_plan_arc.total_budget
   FROM v_plan_arc
	 JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


CREATE OR REPLACE VIEW v_plan_psector AS 
 SELECT plan_psector.psector_id,
	plan_psector.name,
	plan_psector.psector_type,
	plan_psector.descript,
	plan_psector.priority,
	a.suma::numeric(14,2) AS total_arc,
	b.suma::numeric(14,2) AS total_node,
	c.suma::numeric(14,2) AS total_other,
	plan_psector.text1,
	plan_psector.text2,
	plan_psector.observ,
	plan_psector.rotation,
	plan_psector.scale,
	plan_psector.sector_id,
	(
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::numeric(14,2) AS pem,
	plan_psector.gexpenses,
	(((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::double precision)::numeric(14,2) AS pec,
	plan_psector.vat,
	(((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::double precision)::numeric(14,2) AS pec_vat,
	plan_psector.other,
	(((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::double precision * (
		CASE
			WHEN a.suma IS NULL THEN 0::numeric
			ELSE a.suma
		END +
		CASE
			WHEN b.suma IS NULL THEN 0::numeric
			ELSE b.suma
		END +
		CASE
			WHEN c.suma IS NULL THEN 0::numeric
			ELSE c.suma
		END)::double precision)::numeric(14,2) AS pca,
	plan_psector.the_geom
   FROM selector_psector,
	plan_psector
	 LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
			v_plan_psector_x_arc.psector_id
		   FROM v_plan_psector_x_arc
		  GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
	 LEFT JOIN ( SELECT sum(v_plan_psector_x_node.total_budget) AS suma,
			v_plan_psector_x_node.psector_id
		   FROM v_plan_psector_x_node
		  GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
	 LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
			v_plan_psector_x_other.psector_id
		   FROM v_plan_psector_x_other
		  GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_ui_plan_arc_cost AS 
 SELECT arc.arc_id,
	1 AS orderby,
	'element'::text AS identif,
	cat_arc.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	1 AS measurement,
	1::numeric * v_price_compost.price AS total_cost
   FROM arc
	 JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
	 JOIN v_price_compost ON cat_arc.cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
	2 AS orderby,
	'm2bottom'::text AS identif,
	cat_arc.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	v_plan_arc.m2mlbottom AS measurement,
	v_plan_arc.m2mlbottom * v_price_compost.price AS total_cost
   FROM arc
	 JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
	 JOIN v_price_compost ON cat_arc.m2bottom_cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
	3 AS orderby,
	'm3protec'::text AS identif,
	cat_arc.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	v_plan_arc.m3mlprotec AS measurement,
	v_plan_arc.m3mlprotec * v_price_compost.price AS total_cost
   FROM arc
	 JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
	 JOIN v_price_compost ON cat_arc.m3protec_cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
	4 AS orderby,
	'm3exc'::text AS identif,
	cat_soil.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	v_plan_arc.m3mlexc AS measurement,
	v_plan_arc.m3mlexc * v_price_compost.price AS total_cost
   FROM arc
	 JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
	 JOIN v_price_compost ON cat_soil.m3exc_cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
	5 AS orderby,
	'm3fill'::text AS identif,
	cat_soil.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	v_plan_arc.m3mlfill AS measurement,
	v_plan_arc.m3mlfill * v_price_compost.price AS total_cost
   FROM arc
	 JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
	 JOIN v_price_compost ON cat_soil.m3fill_cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
	6 AS orderby,
	'm3excess'::text AS identif,
	cat_soil.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	v_plan_arc.m3mlexcess AS measurement,
	v_plan_arc.m3mlexcess * v_price_compost.price AS total_cost
   FROM arc
	 JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
	 JOIN v_price_compost ON cat_soil.m3excess_cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
	7 AS orderby,
	'm2trenchl'::text AS identif,
	cat_soil.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	v_plan_arc.m2mltrenchl AS measurement,
	v_plan_arc.m2mltrenchl * v_price_compost.price AS total_cost
   FROM arc
	 JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
	 JOIN v_price_compost ON cat_soil.m2trenchl_cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
	8 AS orderby,
	'pavement'::text AS identif,
	cat_pavement.id AS catalog_id,
	v_price_compost.id AS price_id,
	v_price_compost.unit,
	v_price_compost.descript,
	v_price_compost.price AS cost,
	v_plan_arc.m2mlpav * plan_arc_x_pavement.percent AS measurement,
	v_plan_arc.m2mlpav * plan_arc_x_pavement.percent * v_price_compost.price AS total_cost
   FROM arc
	 JOIN plan_arc_x_pavement ON plan_arc_x_pavement.arc_id::text = arc.arc_id::text
	 JOIN cat_pavement ON cat_pavement.id::text = plan_arc_x_pavement.pavcat_id::text
	 JOIN v_price_compost ON cat_pavement.m2_cost::text = v_price_compost.id::text
	 JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT connec.arc_id,
	9 AS orderby,
	'connec'::text AS identif,
	'Various catalog'::character varying AS catalog_id,
	'Various prices'::character varying AS price_id,
	'ut'::character varying AS unit,
	'Sumatory of connecs cost related to arc. The cost is calculated in combination of parameters depth/length from connec table and catalog price from cat_connec table'::character varying AS descript,
	NULL::numeric AS cost,
	count(connec.connec_id) AS measurement,
	sum(connec.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * connec.depth * 0.333) + v_price_x_catconnec.cost_ut)::numeric(12,2) AS total_cost
   FROM connec
	 JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = connec.connecat_id::text
  GROUP BY connec.arc_id
  ORDER BY 1, 2;

  
-- View: v_ui_arc_x_node

CREATE OR REPLACE VIEW v_ui_arc_x_node AS 
 SELECT v_arc.arc_id,
	v_arc.node_1,
	st_x(a.the_geom) AS x1,
	st_y(a.the_geom) AS y1,
	v_arc.node_2,
	st_x(b.the_geom) AS x2,
	st_y(b.the_geom) AS y2
   FROM v_arc
	 LEFT JOIN node a ON a.node_id::text = v_arc.node_1::text
	 LEFT JOIN node b ON b.node_id::text = v_arc.node_2::text;


CREATE OR REPLACE VIEW v_edit_man_expansiontank AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom
   FROM v_node
	 JOIN man_expansiontank ON v_node.node_id::text = man_expansiontank.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_filter AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom
   FROM v_node
	 JOIN man_filter ON v_node.node_id::text = man_filter.node_id::text;



CREATE OR REPLACE VIEW v_edit_man_flexunion AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom
   FROM v_node
	 JOIN man_flexunion ON v_node.node_id::text = man_flexunion.node_id::text;



CREATE OR REPLACE VIEW v_edit_man_fountain AS 
 SELECT connec.connec_id,
	connec.code,
	connec.elevation,
	connec.depth,
	cat_connec.connectype_id,
	connec.connecat_id,
	cat_connec.matcat_id,
	cat_connec.pnom,
	cat_connec.dnom,
	connec.sector_id,
	sector.macrosector_id,
	connec.customer_code,
	a.n_hydrometer,
	connec.state,
	connec.state_type,
	connec.annotation,
	connec.observ,
	connec.comment,
	connec.dma_id,
	connec.presszone_id,
	connec.soilcat_id,
	connec.function_type,
	connec.category_type,
	connec.fluid_type,
	connec.location_type,
	connec.workcat_id,
	connec.workcat_id_end,
	connec.buildercat_id,
	connec.builtdate,
	connec.enddate,
	connec.ownercat_id,
	connec.muni_id,
	connec.postcode,
	connec.district_id,
	connec.streetaxis_id,
	connec.postnumber,
	connec.postcomplement,
	connec.streetaxis2_id,
	connec.postnumber2,
	connec.postcomplement2,
	connec.descript,
	connec.arc_id,
	cat_connec.svg,
	connec.rotation,
	connec.label_x,
	connec.label_y,
	connec.label_rotation,
	concat(cat_feature.link_path, connec.link) AS link,
	connec.connec_length,
	connec.verified,
	connec.undelete,
	connec.publish,
	connec.inventory,
	dma.macrodma_id,
	connec.expl_id,
	connec.num_value,
	connec.the_geom,
	man_fountain.pol_id,
	man_fountain.linked_connec,
	man_fountain.vmax,
	man_fountain.vtotal,
	man_fountain.container_number,
	man_fountain.pump_number,
	man_fountain.power,
	man_fountain.regulation_tank,
	man_fountain.chlorinator,
	man_fountain.arq_patrimony,
	man_fountain.name
   FROM connec
	 LEFT JOIN ( SELECT connec_1.connec_id,
			count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		   FROM ext_rtc_hydrometer
			 JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
		  GROUP BY connec_1.connec_id) a USING (connec_id)
	 LEFT JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
	 JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
	 JOIN dma ON connec.dma_id = dma.dma_id
	 LEFT JOIN sector ON connec.sector_id = sector.sector_id
	 JOIN man_fountain ON man_fountain.connec_id::text = connec.connec_id::text;


	 
CREATE OR REPLACE VIEW v_edit_man_greentap AS 
 SELECT connec.connec_id,
	connec.code,
	connec.elevation,
	connec.depth,
	cat_connec.connectype_id,
	connec.connecat_id,
	cat_connec.matcat_id,
	cat_connec.pnom,
	cat_connec.dnom,
	connec.sector_id,
	sector.macrosector_id,
	connec.customer_code,
	a.n_hydrometer,
	connec.state,
	connec.state_type,
	connec.annotation,
	connec.observ,
	connec.comment,
	connec.dma_id,
	connec.presszone_id,
	connec.soilcat_id,
	connec.function_type,
	connec.category_type,
	connec.fluid_type,
	connec.location_type,
	connec.workcat_id,
	connec.workcat_id_end,
	connec.buildercat_id,
	connec.builtdate,
	connec.enddate,
	connec.ownercat_id,
	connec.muni_id,
	connec.postcode,
	connec.district_id,
	connec.streetaxis_id,
	connec.postnumber,
	connec.postcomplement,
	connec.streetaxis2_id,
	connec.postnumber2,
	connec.postcomplement2,
	connec.descript,
	connec.arc_id,
	cat_connec.svg,
	connec.rotation,
	connec.label_x,
	connec.label_y,
	connec.label_rotation,
	concat(cat_feature.link_path, connec.link) AS link,
	connec.connec_length,
	connec.verified,
	connec.undelete,
	connec.publish,
	connec.inventory,
	dma.macrodma_id,
	connec.expl_id,
	connec.num_value,
	connec.the_geom,
	man_greentap.linked_connec
   FROM connec
	 LEFT JOIN ( SELECT connec_1.connec_id,
			count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		   FROM ext_rtc_hydrometer
			 JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
		  GROUP BY connec_1.connec_id) a USING (connec_id)
	 JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
	 JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
	 LEFT JOIN dma ON connec.dma_id = dma.dma_id
	 LEFT JOIN sector ON connec.sector_id = sector.sector_id
	 JOIN man_greentap ON man_greentap.connec_id::text = connec.connec_id::text;


CREATE OR REPLACE VIEW v_edit_man_wjoin AS 
 SELECT connec.connec_id,
	connec.code,
	connec.elevation,
	connec.depth,
	cat_connec.connectype_id,
	connec.connecat_id,
	cat_connec.matcat_id,
	cat_connec.pnom,
	cat_connec.dnom,
	connec.sector_id,
	sector.macrosector_id,
	connec.customer_code,
	a.n_hydrometer,
	connec.state,
	connec.state_type,
	connec.annotation,
	connec.observ,
	connec.comment,
	connec.dma_id,
	connec.presszone_id,
	connec.soilcat_id,
	connec.function_type,
	connec.category_type,
	connec.fluid_type,
	connec.location_type,
	connec.workcat_id,
	connec.workcat_id_end,
	connec.buildercat_id,
	connec.builtdate,
	connec.enddate,
	connec.ownercat_id,
	connec.muni_id,
	connec.postcode,
	connec.district_id,
	connec.streetaxis_id,
	connec.postnumber,
	connec.postcomplement,
	connec.streetaxis2_id,
	connec.postnumber2,
	connec.postcomplement2,
	connec.descript,
	connec.arc_id,
	cat_connec.svg,
	connec.rotation,
	connec.label_x,
	connec.label_y,
	connec.label_rotation,
	concat(cat_feature.link_path, connec.link) AS link,
	connec.connec_length,
	connec.verified,
	connec.undelete,
	connec.publish,
	connec.inventory,
	dma.macrodma_id,
	connec.expl_id,
	connec.num_value,
	connec.the_geom,
	man_wjoin.top_floor,
	man_wjoin.cat_valve
   FROM connec
	 LEFT JOIN ( SELECT connec_1.connec_id,
			count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		   FROM ext_rtc_hydrometer
			 JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
		  GROUP BY connec_1.connec_id) a USING (connec_id)
	 JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
	 JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
	 LEFT JOIN dma ON connec.dma_id = dma.dma_id
	 LEFT JOIN sector ON connec.sector_id = sector.sector_id
	 JOIN man_wjoin ON man_wjoin.connec_id::text = connec.connec_id::text;

CREATE OR REPLACE VIEW v_edit_man_hydrant AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.num_value,
	v_node.hemisphere,
	v_node.the_geom,
	man_hydrant.fire_code,
	man_hydrant.communication,
	man_hydrant.valve
   FROM v_node
	 JOIN man_hydrant ON man_hydrant.node_id::text = v_node.node_id::text;


	 
CREATE OR REPLACE VIEW v_edit_man_junction AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom
   FROM v_node
	 JOIN man_junction ON v_node.node_id::text = man_junction.node_id::text;


	 
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_manhole.name
   FROM v_node
	 JOIN man_manhole ON v_node.node_id::text = man_manhole.node_id::text;


	 CREATE OR REPLACE VIEW v_edit_man_meter AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.verified,
	v_node.undelete,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom
   FROM v_node
	 JOIN man_meter ON man_meter.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_netelement AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_netelement.serial_number
   FROM v_node
	 JOIN man_netelement ON v_node.node_id::text = man_netelement.node_id::text;


	 
CREATE OR REPLACE VIEW v_edit_man_netsamplepoint AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_netsamplepoint.lab_code
   FROM v_node
	 JOIN man_netsamplepoint ON v_node.node_id::text = man_netsamplepoint.node_id::text;



	 
CREATE OR REPLACE VIEW v_edit_man_netwjoin AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_netwjoin.customer_code,
	man_netwjoin.top_floor,
	man_netwjoin.cat_valve
   FROM v_node
	 JOIN man_netwjoin ON v_node.node_id::text = man_netwjoin.node_id::text;



CREATE OR REPLACE VIEW v_edit_man_pump AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_pump.max_flow,
	man_pump.min_flow,
	man_pump.nom_flow,
	man_pump.power,
	man_pump.pressure,
	man_pump.elev_height,
	man_pump.name,
	man_pump.pump_number
   FROM v_node
	 JOIN man_pump ON man_pump.node_id::text = v_node.node_id::text;


	 
CREATE OR REPLACE VIEW v_edit_man_reduction AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_reduction.diam1,
	man_reduction.diam2
   FROM v_node
	 JOIN man_reduction ON man_reduction.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_register AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_register.pol_id
   FROM v_node
	 JOIN man_register ON v_node.node_id::text = man_register.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_source AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_source.name
   FROM v_node
	 JOIN man_source ON v_node.node_id::text = man_source.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_tank AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_tank.pol_id,
	man_tank.vmax,
	man_tank.vutil,
	man_tank.area,
	man_tank.chlorination,
	man_tank.name
   FROM v_node
	 JOIN man_tank ON man_tank.node_id::text = v_node.node_id::text;


	 
CREATE OR REPLACE VIEW v_edit_man_tap AS 
 SELECT connec.connec_id,
	connec.code,
	connec.elevation,
	connec.depth,
	cat_connec.connectype_id,
	connec.connecat_id,
	cat_connec.matcat_id,
	cat_connec.pnom,
	cat_connec.dnom,
	connec.sector_id,
	sector.macrosector_id,
	connec.customer_code,
	a.n_hydrometer,
	connec.state,
	connec.state_type,
	connec.annotation,
	connec.observ,
	connec.comment,
	connec.dma_id,
	connec.presszone_id,
	connec.soilcat_id,
	connec.function_type,
	connec.category_type,
	connec.fluid_type,
	connec.location_type,
	connec.workcat_id,
	connec.workcat_id_end,
	connec.buildercat_id,
	connec.builtdate,
	connec.enddate,
	connec.ownercat_id,
	connec.muni_id,
	connec.postcode,
	connec.district_id,
	connec.streetaxis_id,
	connec.postnumber,
	connec.postcomplement,
	connec.streetaxis2_id,
	connec.postnumber2,
	connec.postcomplement2,
	connec.descript,
	connec.arc_id,
	cat_connec.svg,
	connec.rotation,
	connec.label_x,
	connec.label_y,
	connec.label_rotation,
	concat(cat_feature.link_path, connec.link) AS link,
	connec.connec_length,
	connec.verified,
	connec.undelete,
	connec.publish,
	connec.inventory,
	dma.macrodma_id,
	connec.expl_id,
	connec.num_value,
	connec.the_geom,
	man_tap.linked_connec,
	man_tap.cat_valve,
	man_tap.drain_diam,
	man_tap.drain_exit,
	man_tap.drain_gully,
	man_tap.drain_distance,
	man_tap.arq_patrimony,
	man_tap.com_state
   FROM connec
	 LEFT JOIN ( SELECT connec_1.connec_id,
			count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
		   FROM ext_rtc_hydrometer
			 JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
		  GROUP BY connec_1.connec_id) a USING (connec_id)
	 JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
	 JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
	 LEFT JOIN dma ON connec.dma_id = dma.dma_id
	 LEFT JOIN sector ON connec.sector_id = sector.sector_id
	 JOIN man_tap ON man_tap.connec_id::text = connec.connec_id::text;


	 
CREATE OR REPLACE VIEW v_edit_man_valve AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_valve.closed,
	man_valve.broken,
	man_valve.buried,
	man_valve.irrigation_indicator,
	man_valve.pression_entry,
	man_valve.pression_exit,
	man_valve.depth_valveshaft,
	man_valve.regulator_situation,
	man_valve.regulator_location,
	man_valve.regulator_observ,
	man_valve.lin_meters,
	man_valve.exit_type,
	man_valve.exit_code,
	man_valve.drive_type,
	man_valve.cat_valve2,
	man_valve.ordinarystatus
   FROM v_node
	 JOIN man_valve ON man_valve.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_waterwell AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_waterwell.name
   FROM v_node
	 JOIN man_waterwell ON v_node.node_id::text = man_waterwell.node_id::text;

	 
CREATE OR REPLACE VIEW v_edit_man_wtp AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_wtp.name
   FROM v_node
	 JOIN man_wtp ON v_node.node_id::text = man_wtp.node_id::text;

	 CREATE OR REPLACE VIEW v_anl_mincut_selected_valve AS 
 SELECT v_node.node_id,
	v_node.nodetype_id,
	man_valve.closed,
	man_valve.broken,
	v_node.the_geom
   FROM v_node
	 JOIN man_valve ON v_node.node_id::text = man_valve.node_id::text
	 JOIN anl_mincut_selector_valve ON v_node.nodetype_id::text = anl_mincut_selector_valve.id::text;

CREATE OR REPLACE VIEW v_edit_man_register_pol AS 
 SELECT man_register.pol_id,
	v_node.node_id,
	polygon.the_geom
   FROM v_node
	 JOIN man_register ON v_node.node_id::text = man_register.node_id::text
	 JOIN polygon ON polygon.pol_id::text = man_register.pol_id::text;


	 CREATE OR REPLACE VIEW v_edit_man_tank_pol AS 
 SELECT man_tank.pol_id,
	v_node.node_id,
	polygon.the_geom
   FROM v_node
	 JOIN man_tank ON man_tank.node_id::text = v_node.node_id::text
	 JOIN polygon ON polygon.pol_id::text = man_tank.pol_id::text;



CREATE OR REPLACE VIEW v_edit_field_valve AS 
 SELECT v_node.node_id,
	v_node.code,
	v_node.elevation,
	v_node.depth,
	v_node.nodetype_id,
	v_node.nodecat_id,
	v_node.cat_matcat_id,
	v_node.cat_pnom,
	v_node.cat_dnom,
	v_node.epa_type,
	v_node.sector_id,
	v_node.macrosector_id,
	v_node.arc_id,
	v_node.parent_id,
	v_node.state,
	v_node.state_type,
	v_node.annotation,
	v_node.observ,
	v_node.comment,
	v_node.dma_id,
	v_node.presszone_id,
	v_node.soilcat_id,
	v_node.function_type,
	v_node.category_type,
	v_node.fluid_type,
	v_node.location_type,
	v_node.workcat_id,
	v_node.workcat_id_end,
	v_node.buildercat_id,
	v_node.builtdate,
	v_node.enddate,
	v_node.ownercat_id,
	v_node.muni_id,
	v_node.postcode,
	v_node.district_id,
	v_node.streetname,
	v_node.postnumber,
	v_node.postcomplement,
	v_node.postcomplement2,
	v_node.streetname2,
	v_node.postnumber2,
	v_node.descript,
	v_node.svg,
	v_node.rotation,
	v_node.link,
	v_node.verified,
	v_node.undelete,
	v_node.label_x,
	v_node.label_y,
	v_node.label_rotation,
	v_node.publish,
	v_node.inventory,
	v_node.macrodma_id,
	v_node.expl_id,
	v_node.hemisphere,
	v_node.num_value,
	v_node.the_geom,
	man_valve.closed,
	man_valve.broken,
	man_valve.buried,
	man_valve.irrigation_indicator,
	man_valve.pression_entry,
	man_valve.pression_exit,
	man_valve.depth_valveshaft,
	man_valve.regulator_situation,
	man_valve.regulator_location,
	man_valve.regulator_observ,
	man_valve.lin_meters,
	man_valve.exit_type,
	man_valve.exit_code,
	man_valve.drive_type,
	man_valve.cat_valve2,
	man_valve.ordinarystatus
   FROM v_node
	 JOIN man_valve ON man_valve.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_inp_demand AS 
 SELECT inp_demand.id,
	node.node_id,
	inp_demand.demand,
	inp_demand.pattern_id,
	inp_demand.deman_type,
	inp_demand.dscenario_id
   FROM inp_selector_sector,
	inp_selector_dscenario,
	node
	 JOIN v_node ON v_node.node_id::text = node.node_id::text
	 JOIN inp_demand ON inp_demand.node_id::text = node.node_id::text
  WHERE node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text AND inp_demand.dscenario_id = inp_selector_dscenario.dscenario_id AND inp_selector_dscenario.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_valve AS 
 SELECT DISTINCT ON (a.node_id) a.node_id,
	a.elevation,
	a.depth,
	a.nodecat_id,
	a.sector_id,
	a.macrosector_id,
	a.state,
	a.state_type,
	a.annotation,
	a.expl_id,
	a.valv_type,
	a.pressure,
	a.flow,
	a.coef_loss,
	a.curve_id,
	a.minorloss,
	a.to_arc,
	a.status,
	a.the_geom
   FROM ( SELECT v_node.node_id,
			v_node.elevation,
			v_node.depth,
			v_node.nodecat_id,
			v_node.sector_id,
			v_node.macrosector_id,
			v_node.state,
			v_node.state_type,
			v_node.annotation,
			v_node.expl_id,
			inp_valve.valv_type,
			inp_valve.pressure,
			inp_valve.flow,
			inp_valve.coef_loss,
			inp_valve.curve_id,
			inp_valve.minorloss,
			inp_valve.to_arc,
			inp_valve.status,
			v_node.the_geom
		   FROM v_node
			 JOIN inp_valve USING (node_id)
			 JOIN vi_parent_arc a_1 ON a_1.node_1::text = v_node.node_id::text
		UNION
		 SELECT v_node.node_id,
			v_node.elevation,
			v_node.depth,
			v_node.nodecat_id,
			v_node.sector_id,
			v_node.macrosector_id,
			v_node.state,
			v_node.state_type,
			v_node.annotation,
			v_node.expl_id,
			inp_valve.valv_type,
			inp_valve.pressure,
			inp_valve.flow,
			inp_valve.coef_loss,
			inp_valve.curve_id,
			inp_valve.minorloss,
			inp_valve.to_arc,
			inp_valve.status,
			v_node.the_geom
		   FROM v_node
			 JOIN inp_valve USING (node_id)
			 JOIN vi_parent_arc a_1 ON a_1.node_2::text = v_node.node_id::text) a;
