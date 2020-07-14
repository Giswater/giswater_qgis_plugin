/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/18


-- CREACIO DE LES VU
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
	presszone.name AS presszone_name,
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
	node.the_geom,
	node.adate,
	node.adescript,
	node.accessibility,
    dma.stylesheet->>'featureColor' AS dma_style,
    presszone.stylesheet->>'featureColor' AS presszone_style
	FROM node
	 LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_node.nodetype_id::text
	 LEFT JOIN dma ON node.dma_id = dma.dma_id
	 LEFT JOIN sector ON node.sector_id = sector.sector_id
	 LEFT JOIN exploitation ON node.expl_id = exploitation.expl_id
	 LEFT JOIN dqa ON node.dqa_id = dqa.dqa_id
	 LEFT JOIN presszone ON presszone.presszone_id = node.presszone_id
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
	presszone.name AS presszone_name,
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
	arc.the_geom,
	arc.depth,
	arc.adate,
	arc.adescript,
    dma.stylesheet->>'featureColor' AS dma_style,
    presszone.stylesheet->>'featureColor' AS presszone_style
	FROM arc
	 LEFT JOIN sector ON arc.sector_id = sector.sector_id
	 LEFT JOIN exploitation ON arc.expl_id = exploitation.expl_id
	 LEFT JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_arc.arctype_id::text
	 LEFT JOIN dma ON arc.dma_id = dma.dma_id
	 LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
	 LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
	 LEFT JOIN dqa ON arc.dqa_id = dqa.dqa_id
 	 LEFT JOIN presszone ON presszone.presszone_id = arc.presszone_id
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
	presszone.name AS presszone_name,
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
	connec.the_geom,
	connec.adate,
	connec.adescript,
	connec.accessibility,
    dma.stylesheet->>'featureColor' AS dma_style,
    presszone.stylesheet->>'featureColor' AS presszone_style
    FROM connec
	LEFT JOIN  (SELECT connec_1.connec_id, count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
				FROM selector_hydrometer, ext_rtc_hydrometer
				JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
				WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND cur_user = current_user
				GROUP BY connec_1.connec_id) a USING (connec_id)
	 JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
	 JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
	 LEFT JOIN dma ON connec.dma_id = dma.dma_id
	 LEFT JOIN sector ON connec.sector_id = sector.sector_id
	 LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
	 LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id
 	 LEFT JOIN presszone ON presszone.presszone_id = connec.presszone_id
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
the_geom,
adate,
adescript,
accessibility
FROM vu_connec
JOIN v_state_connec USING (connec_id);
	 
CREATE OR REPLACE VIEW v_edit_connec AS
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW ve_connec AS 
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW vp_basic_connec AS 
SELECT v_connec.connec_id AS nid,
v_connec.connectype_id AS custom_type
FROM v_connec;



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
   FROM selector_sector,v_connec connec
     JOIN inp_connec USING (connec_id)
  WHERE connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_times AS 
 SELECT a.idval AS parameter,
    b.value
   FROM sys_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['lyt_date_1'::text, 'lyt_date_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL;



CREATE OR REPLACE VIEW vi_options AS 
 SELECT a.parameter,
    a.value
   FROM ( SELECT a_1.idval AS parameter,
                CASE
                    WHEN a_1.idval = 'UNBALANCED'::text AND b.value = 'CONTINUE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_unbalanced_n'::text AND config_param_user.cur_user::name = "current_user"()))
                    WHEN a_1.idval = 'QUALITY'::text AND b.value = 'TRACE'::text THEN concat(b.value, ' ', ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_node_id'::text AND config_param_user.cur_user::name = "current_user"()))
                    WHEN a_1.idval = 'HYDRAULICS'::text AND (b.value = 'USE'::text OR b.value = 'SAVE'::text) THEN concat(b.value, ' ', ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_hydraulics_fname'::text AND config_param_user.cur_user::name = "current_user"()))
                    WHEN a_1.idval = 'HYDRAULICS'::text AND b.value = 'NONE'::text THEN NULL::text
                    ELSE b.value
                END AS value
           FROM sys_param_user a_1
             JOIN config_param_user b ON a_1.id = b.parameter::text
          WHERE (a_1.layoutname = ANY (ARRAY['lyt_general_1'::text, 'lyt_general_2'::text, 'lyt_hydraulics_1'::text, 'lyt_hydraulics_2'::text])) AND (a_1.idval <> ALL (ARRAY['UNBALANCED_N'::text, 'NODE_ID'::text, 'HYDRAULICS_FNAME'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL AND b.parameter::text <> 'PATTERN'::text AND b.value <> 'NULLVALUE'::text) a
  WHERE a.parameter <> 'HYDRAULICS'::text OR a.parameter = 'HYDRAULICS'::text AND a.value IS NOT NULL;


CREATE OR REPLACE VIEW vi_report AS 
 SELECT a.idval AS parameter,
    b.value
   FROM sys_param_user a
     JOIN config_param_user b ON a.id = b.parameter::text
  WHERE (a.layoutname = ANY (ARRAY['lyt_reports_1'::text, 'lyt_reports_2'::text])) AND b.cur_user::name = "current_user"() AND b.value IS NOT NULL;
