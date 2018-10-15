/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- SPECIFIC SQL (WS)

-- ----------------------------
-- View structure for v_price_x_catarc1
-- ----------------------------

DROP VIEW IF EXISTS "v_price_x_catarc1" CASCADE;
CREATE VIEW "v_price_x_catarc1" AS 
SELECT
	cat_arc.id,
	cat_arc.dint,
	cat_arc.z1,
	cat_arc.z2,
	cat_arc.width,
	cat_arc.area,
	cat_arc.bulk,
	cat_arc.estimated_depth,
	cat_arc.cost_unit,
	v_price_compost.price AS cost
FROM (cat_arc
JOIN v_price_compost ON (((cat_arc."cost") = (v_price_compost.id))));


DROP VIEW IF EXISTS "v_price_x_catarc2" CASCADE;
CREATE VIEW "v_price_x_catarc2" AS 
SELECT
	cat_arc.id,
	v_price_compost.price AS m2bottom_cost
FROM (cat_arc
JOIN v_price_compost ON (((cat_arc."m2bottom_cost") = (v_price_compost.id))));


DROP VIEW IF EXISTS "v_price_x_catarc3" CASCADE;
CREATE VIEW "v_price_x_catarc3" AS 
SELECT
	cat_arc.id,
	v_price_compost.price AS m3protec_cost
FROM (cat_arc
JOIN v_price_compost ON (((cat_arc."m3protec_cost") = (v_price_compost.id))));


DROP VIEW IF EXISTS "v_price_x_catarc" CASCADE;
CREATE VIEW "v_price_x_catarc" AS 
SELECT
	v_price_x_catarc1.id,
	v_price_x_catarc1.dint,
	v_price_x_catarc1.z1,
	v_price_x_catarc1.z2,
	v_price_x_catarc1.width,
	v_price_x_catarc1.area,
	v_price_x_catarc1.bulk,
	v_price_x_catarc1.estimated_depth,
	v_price_x_catarc1.cost_unit,
	v_price_x_catarc1.cost,
	v_price_x_catarc2.m2bottom_cost,
	v_price_x_catarc3.m3protec_cost
FROM (v_price_x_catarc1
JOIN v_price_x_catarc2 ON (((v_price_x_catarc2.id) = (v_price_x_catarc1.id)))
JOIN v_price_x_catarc3 ON (((v_price_x_catarc3.id) = (v_price_x_catarc1.id)))
);


DROP VIEW IF EXISTS "v_price_x_catpavement" CASCADE;
CREATE VIEW "v_price_x_catpavement" AS 
SELECT
	cat_pavement.id AS pavcat_id,
	cat_pavement.thickness,
	v_price_compost.price AS m2pav_cost
FROM (cat_pavement
JOIN v_price_compost ON (((cat_pavement."m2_cost") = (v_price_compost.id))));


DROP VIEW IF EXISTS "v_price_x_catnode" CASCADE;
CREATE VIEW "v_price_x_catnode" AS 
SELECT
	cat_node.id,
	cat_node.estimated_depth,
	cat_node.cost_unit,
	v_price_compost.price AS cost
FROM (cat_node
JOIN v_price_compost ON (((cat_node."cost") = (v_price_compost.id))));



-- ----------------------------
-- View structure for v_plan_node
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_node" CASCADE;
CREATE VIEW "v_plan_node" AS 
SELECT
v_edit_node.node_id,
nodecat_id,
sys_type AS node_type,
elevation AS top_elev,
elevation-depth as elev,
epa_type,
sector_id,
state,
annotation,
the_geom,
v_price_x_catnode.cost_unit,
v_price_compost.descript,
v_price_compost.price as cost,
CASE WHEN v_price_x_catnode.cost_unit::text = 'u' THEN (CASE WHEN sys_type='PUMP' THEN (CASE WHEN pump_number IS NOT NULL THEN pump_number ELSE 1 END) ELSE 1 END)
     WHEN v_price_x_catnode.cost_unit::text = 'm3' THEN (CASE WHEN sys_type='TANK' THEN vmax ELSE NULL END)
     WHEN v_price_x_catnode.cost_unit::text = 'm' THEN (CASE WHEN v_edit_node.depth = 0 THEN v_price_x_catnode.estimated_depth 
															 WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth ELSE v_edit_node.depth END)
END::numeric(12,2) AS measurement,
CASE WHEN v_price_x_catnode.cost_unit::text = 'u' THEN (CASE WHEN sys_type='PUMP' THEN (CASE WHEN pump_number IS NOT NULL THEN pump_number ELSE 1 END) ELSE 1 END)*v_price_x_catnode.cost
     WHEN v_price_x_catnode.cost_unit::text = 'm3' THEN (CASE WHEN sys_type='TANK' THEN vmax ELSE NULL END)*v_price_x_catnode.cost
     WHEN v_price_x_catnode.cost_unit::text = 'm' THEN (CASE WHEN v_edit_node.depth = 0 THEN v_price_x_catnode.estimated_depth
															 WHEN v_edit_node.depth IS NULL THEN v_price_x_catnode.estimated_depth ELSE v_edit_node.depth END)*v_price_x_catnode.cost
END::numeric(12,2) AS budget,
expl_id
FROM v_edit_node
LEFT JOIN v_price_x_catnode ON v_edit_node.nodecat_id::text = v_price_x_catnode.id::text
LEFT JOIN man_tank ON man_tank.node_id=v_edit_node.node_id
LEFT JOIN man_pump ON man_pump.node_id=v_edit_node.node_id
JOIN cat_node ON cat_node.id::text = v_edit_node.nodecat_id::text
JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text;





DROP VIEW IF EXISTS "v_plan_aux_arc_pavement" CASCADE;
CREATE VIEW "v_plan_aux_arc_pavement" AS 
SELECT
arc_id, 
CASE
   WHEN sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent) IS NULL THEN 0::numeric(12,2)
   ELSE sum(v_price_x_catpavement.thickness * plan_arc_x_pavement.percent)::numeric(12,2)
END AS thickness,
   CASE
   WHEN sum(v_price_x_catpavement.m2pav_cost) IS NULL THEN 0::numeric(12,2)
   ELSE sum(v_price_x_catpavement.m2pav_cost::numeric(12,2) * plan_arc_x_pavement.percent)
END AS m2pav_cost
FROM plan_arc_x_pavement
	LEFT JOIN v_price_x_catpavement ON ((((v_price_x_catpavement.pavcat_id) = (plan_arc_x_pavement.pavcat_id))))
        GROUP by arc_id;


DROP VIEW IF EXISTS "v_plan_aux_arc_ml" CASCADE;
CREATE VIEW "v_plan_aux_arc_ml" AS 
SELECT 
v_arc.arc_id,
v_arc.depth1,
v_arc.depth2,
(CASE WHEN (v_arc.depth1*v_arc.depth2) =0::numeric OR (v_arc.depth1*v_arc.depth2) IS NULL THEN v_price_x_catarc.estimated_depth::numeric(12,2) ELSE ((v_arc.depth1+v_arc.depth2)/2)::numeric(12,2) END) AS mean_depth,
v_arc.arccat_id,
(v_price_x_catarc.dint/1000)::numeric(12,4) AS dint,
v_price_x_catarc.z1,
v_price_x_catarc.z2,
v_price_x_catarc.area,
v_price_x_catarc.width,
(v_price_x_catarc.bulk/1000)::numeric(12,4) AS bulk,
v_price_x_catarc.cost_unit,
(v_price_x_catarc.cost)::numeric(12,2) AS arc_cost,
(v_price_x_catarc.m2bottom_cost)::numeric(12,2) AS m2bottom_cost,
(v_price_x_catarc.m3protec_cost)::numeric(12,2) AS m3protec_cost,
v_price_x_catsoil.id AS soilcat_id,
v_price_x_catsoil.y_param,
v_price_x_catsoil.b,
v_price_x_catsoil.trenchlining,
(v_price_x_catsoil.m3exc_cost)::numeric(12,2) AS m3exc_cost,
(v_price_x_catsoil.m3fill_cost)::numeric(12,2) AS m3fill_cost,
(v_price_x_catsoil.m3excess_cost)::numeric(12,2) AS m3excess_cost,
(v_price_x_catsoil.m2trenchl_cost)::numeric(12,2) AS m2trenchl_cost,
 thickness,
 m2pav_cost,
v_arc.state,
v_arc.the_geom,
v_arc.expl_id
FROM v_arc
	LEFT JOIN v_price_x_catarc ON ((((v_arc.arccat_id) = (v_price_x_catarc.id))))
	LEFT JOIN v_price_x_catsoil ON ((((v_arc.soilcat_id) = (v_price_x_catsoil.id))))
	LEFT JOIN plan_arc_x_pavement ON ((((plan_arc_x_pavement.arc_id) = (v_arc.arc_id))))
	LEFT JOIN v_plan_aux_arc_pavement ON v_plan_aux_arc_pavement.arc_id=v_arc.arc_id;
	
	

-- ----------------------------
-- View structure for v_plan_aux_arc_cost
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_aux_arc_cost" CASCADE;
CREATE OR REPLACE VIEW "v_plan_aux_arc_cost" AS 

SELECT
v_plan_aux_arc_ml.*,

(2*((v_plan_aux_arc_ml.mean_depth+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk)/v_plan_aux_arc_ml.y_param)+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)::numeric(12,3) AS m2mlpavement,

((2*v_plan_aux_arc_ml.b)+(v_plan_aux_arc_ml.width))::numeric(12,3) AS m2mlbase,

(v_plan_aux_arc_ml.mean_depth+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_depth,

((v_plan_aux_arc_ml.trenchlining)*2*(v_plan_aux_arc_ml.mean_depth+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,

((v_plan_aux_arc_ml.mean_depth+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)																																								
*((2*((v_plan_aux_arc_ml.mean_depth+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)/v_plan_aux_arc_ml.y_param)+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+									
v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width))/2)::numeric(12,3) AS m3mlexc,

((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.dint+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)																	
*(((2*((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.dint+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)/v_plan_aux_arc_ml.y_param)
+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+(v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width)))/2)
- v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,

(((v_plan_aux_arc_ml.mean_depth+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)																																								
*((2*((v_plan_aux_arc_ml.mean_depth+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)/v_plan_aux_arc_ml.y_param)+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+								
v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width))/2)
-((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.dint+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)																	
*(((2*((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.dint+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)/v_plan_aux_arc_ml.y_param)		
+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+(v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width)))/2)))::numeric(12,3) AS m3mlfill,

((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.dint+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)																	
*(((2*((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.dint+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)/v_plan_aux_arc_ml.y_param)
+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+(v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width)))/2))::numeric(12,3)	AS m3mlexcess

FROM v_plan_aux_arc_ml;

 

-- ----------------------------
-- View structure for v_plan_aux_arc_connec
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_aux_arc_connec" CASCADE;
CREATE VIEW v_plan_aux_arc_connec as
select distinct on (connec.arc_id)
arc_id,
sum(connec_length*(cost_mlconnec+cost_m3trench*depth*0.333)+cost_ut)::numeric(12,2) AS connec_total_cost
from connec
join v_price_x_catconnec on id=connecat_id
group by arc_id;





-- ----------------------------
-- View structure for v_plan_arc
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_arc" CASCADE;
CREATE VIEW "v_plan_arc" AS 
SELECT
v_plan_aux_arc_cost.arc_id,
node_1,
node_2,
v_plan_aux_arc_cost.arccat_id as arc_type,
v_plan_aux_arc_cost.arccat_id,
epa_type,
sector_id,
v_plan_aux_arc_cost."state",
annotation,
v_plan_aux_arc_cost.soilcat_id,
v_plan_aux_arc_cost.depth1 as y1,
v_plan_aux_arc_cost.depth2 as y2,
v_plan_aux_arc_cost.mean_depth as mean_y,
v_plan_aux_arc_cost.z1,
v_plan_aux_arc_cost.z2,
v_plan_aux_arc_cost.thickness,
v_plan_aux_arc_cost.width,
v_plan_aux_arc_cost.b,
v_plan_aux_arc_cost.bulk,
v_plan_aux_arc_cost.dint as geom1,
v_plan_aux_arc_cost.area,
v_plan_aux_arc_cost.y_param,
(v_plan_aux_arc_cost.calculed_depth+v_plan_aux_arc_cost.thickness)::numeric(12,2) as total_y,
(v_plan_aux_arc_cost.calculed_depth-2*v_plan_aux_arc_cost.bulk-v_plan_aux_arc_cost.z1-v_plan_aux_arc_cost.z2-v_plan_aux_arc_cost.dint)::numeric(12,2) as rec_y,
(v_plan_aux_arc_cost.dint+2*v_plan_aux_arc_cost.bulk)::numeric(12,2) as geom1_ext,

v_plan_aux_arc_cost.calculed_depth as calculed_y,
v_plan_aux_arc_cost.m3mlexc,
v_plan_aux_arc_cost.m2mltrenchl,
v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
v_plan_aux_arc_cost.m3mlprotec,
v_plan_aux_arc_cost.m3mlfill,
v_plan_aux_arc_cost.m3mlexcess,

v_plan_aux_arc_cost.m3exc_cost::numeric(12,2),
v_plan_aux_arc_cost.m2trenchl_cost::numeric(12,2),
v_plan_aux_arc_cost.m2bottom_cost::numeric(12,2),
v_plan_aux_arc_cost.m2pav_cost::numeric(12,2),
v_plan_aux_arc_cost.m3protec_cost::numeric(12,2),
v_plan_aux_arc_cost.m3fill_cost::numeric(12,2),
v_plan_aux_arc_cost.m3excess_cost::numeric(12,2),
v_plan_aux_arc_cost.cost_unit,

(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m2mlpavement*v_plan_aux_arc_cost.m2pav_cost) END)::numeric(12,3) 	AS pav_cost,
(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlexc*v_plan_aux_arc_cost.m3exc_cost) END)::numeric(12,3) 		AS exc_cost,
(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m2mltrenchl*v_plan_aux_arc_cost.m2trenchl_cost) END)::numeric(12,3)	AS trenchl_cost,
(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m2mlbase*v_plan_aux_arc_cost.m2bottom_cost)END)::numeric(12,3) 		AS base_cost,
(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlprotec*v_plan_aux_arc_cost.m3protec_cost) END)::numeric(12,3) 	AS protec_cost,
(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlfill*v_plan_aux_arc_cost.m3fill_cost) END)::numeric(12,3) 		AS fill_cost,
(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlexcess*v_plan_aux_arc_cost.m3excess_cost) END)::numeric(12,3) 	AS excess_cost,
(v_plan_aux_arc_cost.arc_cost)::numeric(12,3)									AS arc_cost,
(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN v_plan_aux_arc_cost.arc_cost ELSE
(v_plan_aux_arc_cost.m3mlexc*v_plan_aux_arc_cost.m3exc_cost
+ v_plan_aux_arc_cost.m2mlbase*v_plan_aux_arc_cost.m2bottom_cost
+ v_plan_aux_arc_cost.m2mltrenchl*v_plan_aux_arc_cost.m2trenchl_cost
+ v_plan_aux_arc_cost.m3mlprotec*v_plan_aux_arc_cost.m3protec_cost
+ v_plan_aux_arc_cost.m3mlfill*v_plan_aux_arc_cost.m3fill_cost
+ v_plan_aux_arc_cost.m3mlexcess*v_plan_aux_arc_cost.m3excess_cost
+ v_plan_aux_arc_cost.m2mlpavement*v_plan_aux_arc_cost.m2pav_cost
+ v_plan_aux_arc_cost.arc_cost) END)::numeric(12,2)							AS cost,

(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN NULL ELSE (st_length2d(v_plan_aux_arc_cost.the_geom)) END)::numeric(12,2)		AS length,

(CASE WHEN (v_plan_aux_arc_cost.cost_unit='u') THEN v_plan_aux_arc_cost.arc_cost ELSE((st_length2d(v_plan_aux_arc_cost.the_geom))::numeric(12,2)*
(v_plan_aux_arc_cost.m3mlexc*v_plan_aux_arc_cost.m3exc_cost
+ v_plan_aux_arc_cost.m2mlbase*v_plan_aux_arc_cost.m2bottom_cost
+ v_plan_aux_arc_cost.m2mltrenchl*v_plan_aux_arc_cost.m2trenchl_cost
+ v_plan_aux_arc_cost.m3mlprotec*v_plan_aux_arc_cost.m3protec_cost
+ v_plan_aux_arc_cost.m3mlfill*v_plan_aux_arc_cost.m3fill_cost
+ v_plan_aux_arc_cost.m3mlexcess*v_plan_aux_arc_cost.m3excess_cost
+ v_plan_aux_arc_cost.m2mlpavement*v_plan_aux_arc_cost.m2pav_cost
+ v_plan_aux_arc_cost.arc_cost)::numeric(14,2)) END)::numeric (14,2)						AS budget,

connec_total_cost as other_budget,

CASE
    WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text 
    THEN v_plan_aux_arc_cost.arc_cost+(CASE WHEN connec_total_cost IS NULL THEN 0 ELSE connec_total_cost END)
    ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * 
    v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * 
    v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * 
    v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) + 
    (CASE WHEN connec_total_cost IS NULL THEN 0 ELSE connec_total_cost END)
    END::numeric(14,2) AS total_budget, 

v_plan_aux_arc_cost.the_geom,
v_plan_aux_arc_cost.expl_id
FROM v_plan_aux_arc_cost
	JOIN arc ON arc.arc_id=v_plan_aux_arc_cost.arc_id
    LEFT JOIN v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id = v_plan_aux_arc_cost.arc_id;

	


--------------------------------
-- plan result views
--------------------------------
DROP VIEW IF EXISTS "v_plan_result_node" CASCADE;			
CREATE OR REPLACE VIEW "v_plan_result_node" AS
SELECT
om_rec_result_node.node_id,
om_rec_result_node.nodecat_id,
om_rec_result_node.node_type,
om_rec_result_node.top_elev,
om_rec_result_node.elev,
om_rec_result_node.epa_type,
om_rec_result_node.sector_id,
cost_unit,
om_rec_result_node.descript,
om_rec_result_node.measurement,
cost,
om_rec_result_node.budget,
om_rec_result_node.state,
om_rec_result_node.the_geom,
om_rec_result_node.expl_id
FROM selector_expl, plan_result_selector, om_rec_result_node
WHERE om_rec_result_node.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() 
AND om_rec_result_node.result_id::text=plan_result_selector.result_id::text AND plan_result_selector.cur_user="current_user"() 
AND state=1
UNION
SELECT
node_id,
nodecat_id,
node_type,
top_elev,
elev,
epa_type,
sector_id,
cost_unit,
descript,
measurement,
cost,
budget,
state,
the_geom,
expl_id
FROM v_plan_node
WHERE state=2;




DROP VIEW IF EXISTS "v_plan_result_arc" CASCADE;			
CREATE OR REPLACE VIEW "v_plan_result_arc" AS
SELECT
om_rec_result_arc.arc_id,
om_rec_result_arc.node_1,
om_rec_result_arc.node_2,
om_rec_result_arc.arc_type ,
om_rec_result_arc.arccat_id ,
om_rec_result_arc.epa_type ,
om_rec_result_arc.sector_id,
om_rec_result_arc.state,
om_rec_result_arc.annotation,
om_rec_result_arc.soilcat_id,
om_rec_result_arc.y1 ,
om_rec_result_arc.y2 ,
mean_y ,
om_rec_result_arc.z1 ,
om_rec_result_arc.z2 ,
thickness ,
width ,
b ,
bulk ,
om_rec_result_arc.geom1 ,
area ,
y_param ,
total_y ,
rec_y ,
geom1_ext ,
calculed_y ,
m3mlexc ,
m2mltrenchl ,
m2mlbottom ,
m2mlpav ,
m3mlprotec ,
m3mlfill ,
m3mlexcess ,
m3exc_cost ,
m2trenchl_cost ,
m2bottom_cost ,
m2pav_cost ,
m3protec_cost ,
m3fill_cost ,
m3excess_cost ,
cost_unit ,
pav_cost ,
exc_cost ,
trenchl_cost ,
base_cost ,
protec_cost ,
fill_cost ,
excess_cost,
arc_cost ,
cost  ,
length,
budget ,
other_budget ,
total_budget ,
om_rec_result_arc.the_geom,
om_rec_result_arc.expl_id
FROM plan_result_selector, om_rec_result_arc
WHERE om_rec_result_arc.result_id::text=plan_result_selector.result_id::text AND plan_result_selector.cur_user="current_user"() 
AND state=1

UNION
SELECT
arc_id,
node_1,
node_2,
arc_type ,
arccat_id ,
epa_type ,
sector_id,
state,
annotation,
soilcat_id,
y1 ,
y2 ,
mean_y ,
z1 ,
z2 ,
thickness ,
width ,
b ,
bulk ,
geom1 ,
area ,
y_param ,
total_y ,
rec_y ,
geom1_ext ,
calculed_y ,
m3mlexc ,
m2mltrenchl ,
m2mlbottom ,
m2mlpav ,
m3mlprotec ,
m3mlfill ,
m3mlexcess ,
m3exc_cost ,
m2trenchl_cost ,
m2bottom_cost ,
m2pav_cost ,
m3protec_cost ,
m3fill_cost ,
m3excess_cost ,
cost_unit ,
pav_cost ,
exc_cost ,
trenchl_cost ,
base_cost ,
protec_cost ,
fill_cost ,
excess_cost,
arc_cost ,
cost  ,
length,
budget ,
other_budget ,
total_budget ,
the_geom,
expl_id
FROM v_plan_arc
WHERE state=2;




