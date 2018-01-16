/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

---------------------------------------------------------------
-- SPECIFIC SQL (UD)
---------------------------------------------------------------


DROP VIEW IF EXISTS "v_price_x_catarc1" CASCADE;
CREATE VIEW "v_price_x_catarc1" AS 
SELECT
	cat_arc.id,
	cat_arc.geom1,
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
	v_price_x_catarc1.geom1,
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
	cat_node.estimated_y,
	cat_node.cost_unit,
	v_price_compost.price AS cost
FROM (cat_node
JOIN v_price_compost ON (((cat_node."cost") = (v_price_compost.id))));




DROP VIEW IF EXISTS "v_price_x_node" CASCADE;
CREATE OR REPLACE VIEW v_price_x_node AS 
 SELECT 
 node.node_id, 
    node.nodecat_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price,
        CASE
            WHEN v_price_x_catnode.cost_unit = 'u' THEN NULL::numeric
            ELSE 
            CASE
                WHEN (node.ymax * 1::numeric) = 0::numeric THEN v_price_x_catnode.estimated_y
                ELSE node.ymax / 2::numeric
            END
        END::numeric(12,2) AS calculated_depth, 

        CASE
            WHEN v_price_x_catnode.cost_unit = 'u' THEN v_price_x_catnode.cost
            ELSE 
            CASE
                WHEN (node.ymax * 1::numeric) = 0::numeric THEN v_price_x_catnode.estimated_y
                ELSE (node.ymax / 2::numeric)::numeric(12,2)
            END * v_price_x_catnode.cost
        END::numeric(12,2) AS budget

   FROM v_node node
   LEFT JOIN v_price_x_catnode ON node.nodecat_id = v_price_x_catnode.id
   JOIN cat_node on cat_node.id=node.nodecat_id
   JOIN v_price_compost ON v_price_compost.id=cat_node.cost;





-- ----------------------------
-- View structure for v_plan_aux_arc_ml
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_aux_arc_ml" CASCADE;
CREATE VIEW "v_plan_aux_arc_ml" AS 
SELECT 
v_edit_arc..arc_id,
v_edit_arc.y1,
v_edit_arc..y2,
(CASE WHEN (v_edit_arc.y1*v_edit_arc.y2)=0::numeric OR (v_edit_arc.y1*v_edit_arc.y2) IS NULL THEN v_price_x_catarc.estimated_depth::numeric(12,2) ELSE ((v_edit_arc.y1+v_edit_arc.y2)/2)::numeric(12,2) END) AS mean_y,
v_edit_arc..arccat_id,
v_price_x_catarc.geom1,
v_price_x_catarc.z1,
v_price_x_catarc.z2,
v_price_x_catarc.area,
v_price_x_catarc.width,
v_price_x_catarc.bulk,
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
(v_price_x_catsoil.m3excess_cost)::numeric(12,2)AS m3excess_cost,
(v_price_x_catsoil.m2trenchl_cost)::numeric(12,2) AS m2trenchl_cost,
(CASE WHEN sum (v_price_x_catpavement.thickness*plan_arc_x_pavement.percent) IS NULL THEN 0::numeric(12,2) ELSE
sum (v_price_x_catpavement.thickness*plan_arc_x_pavement.percent)::numeric(12,2) END) AS thickness,
(CASE WHEN sum (v_price_x_catpavement.m2pav_cost) IS NULL THEN 0::numeric(12,2) ELSE
sum (v_price_x_catpavement.m2pav_cost::numeric(12,2)*plan_arc_x_pavement.percent) END) AS m2pav_cost,
v_edit_arc..state,
v_edit_arc.the_geom,
v_edit_arc.expl_id
FROM v_edit_arc
	LEFT JOIN v_price_x_catarc ON ((((v_edit_arc.arccat_id) = (v_price_x_catarc.id))))
	LEFT JOIN v_price_x_catsoil ON ((((v_edit_arc.soilcat_id) = (v_price_x_catsoil.id))))
	LEFT JOIN plan_arc_x_pavement ON ((((plan_arc_x_pavement.arc_id) = (v_edit_arc.arc_id))))
	LEFT JOIN v_price_x_catpavement ON ((((v_price_x_catpavement.pavcat_id) = (plan_arc_x_pavement.pavcat_id))))
	GROUP BY v_edit_arc.arc_id, v_edit_arc.y1, v_edit_arc.y2, mean_y,v_edit_arc.arccat_id, 
	v_price_x_catarc.geom1,v_price_x_catarc.z1,v_price_x_catarc.z2,v_price_x_catarc.area,
	v_price_x_catarc.width,v_price_x_catarc.bulk, cost_unit, arc_cost, m2bottom_cost, 
	m3protec_cost, v_price_x_catsoil.id, y_param, b, trenchlining, m3exc_cost, m3fill_cost, 
	m3excess_cost, m2trenchl_cost,v_edit_arc.state, v_edit_arc.the_geom, v_edit_arc.expl_id;
	

-- ----------------------------
-- View structure for v_plan_aux_arc_cost
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_aux_arc_cost" CASCADE;
CREATE OR REPLACE VIEW "v_plan_aux_arc_cost" AS 

SELECT
v_plan_aux_arc_ml.arc_id,
v_plan_aux_arc_ml.arccat_id,
v_plan_aux_arc_ml.cost_unit,
v_plan_aux_arc_ml.arc_cost,
v_plan_aux_arc_ml.m2bottom_cost,
v_plan_aux_arc_ml.soilcat_id,
v_plan_aux_arc_ml.m3exc_cost,
v_plan_aux_arc_ml.m3fill_cost,
v_plan_aux_arc_ml.m3excess_cost,
v_plan_aux_arc_ml.m3protec_cost,
v_plan_aux_arc_ml.m2trenchl_cost,
v_plan_aux_arc_ml.m2pav_cost,

(2*((v_plan_aux_arc_ml.mean_y+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk)/v_plan_aux_arc_ml.y_param)+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)::numeric(12,3)							AS m2mlpavement,

((2*v_plan_aux_arc_ml.b)+(v_plan_aux_arc_ml.width))::numeric(12,3)  																												AS m2mlbase,

(v_plan_aux_arc_ml.mean_y+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)::numeric(12,3)																		AS calculed_y,

((v_plan_aux_arc_ml.trenchlining)*2*(v_plan_aux_arc_ml.mean_y+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness))::numeric(12,3)										AS m2mltrenchl,

((v_plan_aux_arc_ml.mean_y+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)																																								
*((2*((v_plan_aux_arc_ml.mean_y+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)/v_plan_aux_arc_ml.y_param)+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+									
v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width))/2)::numeric(12,3)																													AS m3mlexc,

((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.geom1+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)																	
*(((2*((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.geom1+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)/v_plan_aux_arc_ml.y_param)
+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+(v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width)))/2)
- v_plan_aux_arc_ml.area)::numeric(12,3)																																		AS m3mlprotec,

(((v_plan_aux_arc_ml.mean_y+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)																																								
*((2*((v_plan_aux_arc_ml.mean_y+v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.thickness)/v_plan_aux_arc_ml.y_param)+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+								
v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width))/2)
-((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.geom1+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)																	
*(((2*((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.geom1+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)/v_plan_aux_arc_ml.y_param)		
+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+(v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width)))/2)))::numeric(12,3)																	AS m3mlfill,

((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.geom1+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)																	
*(((2*((v_plan_aux_arc_ml.z1+v_plan_aux_arc_ml.geom1+v_plan_aux_arc_ml.bulk*2+v_plan_aux_arc_ml.z2)/v_plan_aux_arc_ml.y_param)
+(v_plan_aux_arc_ml.width)+v_plan_aux_arc_ml.b*2)+(v_plan_aux_arc_ml.b*2+(v_plan_aux_arc_ml.width)))/2))::numeric(12,3)																		AS m3mlexcess

FROM v_plan_aux_arc_ml;






-- ----------------------------
-- View structure for v_plan_aux_arc_connec
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_aux_arc_connec" CASCADE;
CREATE VIEW v_plan_aux_arc_connec as
select distinct on (connec.arc_id)
connec.arc_id,
sum(connec_length*(cost_mlconnec+cost_m3trench*connec_depth*0.333)+cost_ut)::numeric(12,2) AS connec_total_cost
from connec
join v_price_x_catconnec on id=connecat_id
join link on link.feature_id=connec_id 
group by connec.arc_id;
	



-- ----------------------------
-- View structure for v_plan_aux_arc_gully
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_aux_arc_gully" CASCADE;
CREATE VIEW v_plan_aux_arc_gully as
select distinct (arc_id)
arc_id,
sum(connec_length*(cost_mlconnec+cost_m3trench*connec_depth*0.333)+cost_ut*(1+ymax))::numeric(12,2) AS gully_total_cost
from gully
join v_price_x_catconnec on v_price_x_catconnec.id=connec_arccat_id
join v_price_x_catgrate on v_price_x_catgrate.id=gratecat_id
group by arc_id;



-- ----------------------------
-- View structure for v_plan_arc
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_arc" CASCADE;
CREATE VIEW "v_plan_arc" AS 
SELECT
v_plan_aux_arc_ml.arc_id,
node_1,
node_2,
arc_type,
v_plan_aux_arc_ml.arccat_id,
epa_type,
sector_id,
v_plan_aux_arc_ml."state",
annotation,
v_plan_aux_arc_ml.soilcat_id,
v_plan_aux_arc_ml.y1,
v_plan_aux_arc_ml.y2,
v_plan_aux_arc_ml.mean_y,
v_plan_aux_arc_ml.z1,
v_plan_aux_arc_ml.z2,
v_plan_aux_arc_ml.thickness,
v_plan_aux_arc_ml.width,
v_plan_aux_arc_ml.b,
v_plan_aux_arc_ml.bulk,
v_plan_aux_arc_ml.geom1,
v_plan_aux_arc_ml.area,
v_plan_aux_arc_ml.y_param,
(v_plan_aux_arc_cost.calculed_y+v_plan_aux_arc_ml.thickness)::numeric(12,2) as total_y,
(v_plan_aux_arc_cost.calculed_y-2*v_plan_aux_arc_ml.bulk-v_plan_aux_arc_ml.z1-v_plan_aux_arc_ml.z2-v_plan_aux_arc_ml.geom1)::numeric(12,2) as rec_y,
(v_plan_aux_arc_ml.geom1+2*v_plan_aux_arc_ml.bulk)::numeric(12,2) as geom1_ext,

v_plan_aux_arc_cost.calculed_y,
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
v_plan_aux_arc_ml.cost_unit,

(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m2mlpavement*v_plan_aux_arc_cost.m2pav_cost) END)::numeric(12,3) 	AS pav_cost,
(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlexc*v_plan_aux_arc_cost.m3exc_cost) END)::numeric(12,3) 		AS exc_cost,
(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m2mltrenchl*v_plan_aux_arc_cost.m2trenchl_cost) END)::numeric(12,3)	AS trenchl_cost,
(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m2mlbase*v_plan_aux_arc_cost.m2bottom_cost)END)::numeric(12,3) 		AS base_cost,
(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlprotec*v_plan_aux_arc_cost.m3protec_cost) END)::numeric(12,3) 	AS protec_cost,
(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlfill*v_plan_aux_arc_cost.m3fill_cost) END)::numeric(12,3) 		AS fill_cost,
(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE
(v_plan_aux_arc_cost.m3mlexcess*v_plan_aux_arc_cost.m3excess_cost) END)::numeric(12,3) 	AS excess_cost,
(v_plan_aux_arc_cost.arc_cost)::numeric(12,3)									AS arc_cost,
(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN v_plan_aux_arc_ml.arc_cost ELSE
(v_plan_aux_arc_cost.m3mlexc*v_plan_aux_arc_cost.m3exc_cost
+ v_plan_aux_arc_cost.m2mlbase*v_plan_aux_arc_cost.m2bottom_cost
+ v_plan_aux_arc_cost.m2mltrenchl*v_plan_aux_arc_cost.m2trenchl_cost
+ v_plan_aux_arc_cost.m3mlprotec*v_plan_aux_arc_cost.m3protec_cost
+ v_plan_aux_arc_cost.m3mlfill*v_plan_aux_arc_cost.m3fill_cost
+ v_plan_aux_arc_cost.m3mlexcess*v_plan_aux_arc_cost.m3excess_cost
+ v_plan_aux_arc_cost.m2mlpavement*v_plan_aux_arc_cost.m2pav_cost
+ v_plan_aux_arc_cost.arc_cost) END)::numeric(12,2)							AS cost,

(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN NULL ELSE (st_length2d(v_plan_aux_arc_ml.the_geom)) END)::numeric(12,2)							AS length,

(CASE WHEN (v_plan_aux_arc_ml.cost_unit='u') THEN v_plan_aux_arc_ml.arc_cost ELSE((st_length2d(v_plan_aux_arc_ml.the_geom))::numeric(12,2)*
(v_plan_aux_arc_cost.m3mlexc*v_plan_aux_arc_cost.m3exc_cost
+ v_plan_aux_arc_cost.m2mlbase*v_plan_aux_arc_cost.m2bottom_cost
+ v_plan_aux_arc_cost.m2mltrenchl*v_plan_aux_arc_cost.m2trenchl_cost
+ v_plan_aux_arc_cost.m3mlprotec*v_plan_aux_arc_cost.m3protec_cost
+ v_plan_aux_arc_cost.m3mlfill*v_plan_aux_arc_cost.m3fill_cost
+ v_plan_aux_arc_cost.m3mlexcess*v_plan_aux_arc_cost.m3excess_cost
+ v_plan_aux_arc_cost.m2mlpavement*v_plan_aux_arc_cost.m2pav_cost
+ v_plan_aux_arc_cost.arc_cost)::numeric(14,2)) END)::numeric (14,2)						AS budget,

connec_total_cost+gully_total_cost as other_budget,

CASE
    WHEN v_plan_aux_arc_ml.cost_unit::text = 'u'::text 
    THEN v_plan_aux_arc_ml.arc_cost+(CASE WHEN connec_total_cost IS NULL THEN 0 ELSE connec_total_cost END)
    ELSE st_length2d(v_plan_aux_arc_ml.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * 
    v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * 
    v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * 
    v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) + 
    (CASE WHEN connec_total_cost IS NULL THEN 0 ELSE connec_total_cost END)
    END::numeric(14,2) AS total_budget, 

v_plan_aux_arc_ml.the_geom,
v_plan_aux_arc_ml.expl_id

FROM selector_expl, v_plan_aux_arc_ml
	JOIN v_plan_aux_arc_cost ON v_plan_aux_arc_ml.arc_id = v_plan_aux_arc_cost.arc_id
	JOIN v_edit_arc ON v_plan_aux_arc_ml.arc_id=v_edit_arc.arc_id
	LEFT JOIN v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id = v_plan_aux_arc_cost.arc_id
	LEFT JOIN v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id = v_plan_aux_arc_cost.arc_id
	WHERE v_plan_aux_arc_ml.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"() ;


-- ----------------------------
-- View structure for v_plan_node
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_node" CASCADE;
CREATE VIEW "v_plan_node" AS 
SELECT
v_edit_node.node_id,
v_edit_node.nodecat_id,
node_type,
top_elev,
elev,
epa_type,
sector_id,
state,
annotation,
the_geom,
v_price_x_catnode.cost_unit,
v_price_x_node.descript,
(CASE WHEN (v_price_x_catnode.cost_unit='u') THEN NULL ELSE ((CASE WHEN (ymax*1=0::numeric) 
THEN v_price_x_catnode.estimated_y::numeric(12,2) ELSE ((ymax)/2)END)) END)::numeric(12,2) AS calculated_depth,
v_price_x_catnode.cost,
(CASE WHEN (v_price_x_catnode.cost_unit='u') THEN v_price_x_catnode.cost ELSE ((CASE WHEN (ymax*1=0::numeric) 
THEN v_price_x_catnode.estimated_y::numeric(12,2) ELSE ((ymax)/2)::numeric(12,2) END)*v_price_x_catnode.cost) END)::numeric(12,2) AS budget,
v_edit_node.expl_id
FROM selector_expl, v_edit_node
	LEFT JOIN v_price_x_catnode ON nodecat_id = v_price_x_catnode.id
	JOIN v_price_x_node ON v_edit_node.node_id = v_price_x_node.node_id
	WHERE v_edit_node.expl_id=selector_expl.expl_id
	AND selector_expl.cur_user="current_user"() ;







--------------------------------
-- plan result views
--------------------------------
DROP VIEW IF EXISTS "v_plan_result_node" CASCADE;			
CREATE OR REPLACE VIEW "v_plan_result_node" AS
SELECT
plan_result_node.node_id,
plan_result_node.nodecat_id,
plan_result_node.node_type,
plan_result_node.top_elev,
plan_result_node.elev,
plan_result_node.epa_type,
plan_result_node.sector_id,
cost_unit,
plan_result_node.descript,
plan_result_node.calculated_depth,
cost,
plan_result_node.budget,
plan_result_node.state,
plan_result_node.the_geom,
plan_result_node.expl_id
FROM selector_expl, plan_selector_result, plan_result_node
JOIN v_edit_node ON v_edit_node.node_id=plan_result_node.node_id
JOIN v_price_x_node ON v_price_x_node.node_id=plan_result_node.node_id
WHERE plan_result_node.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() 
AND plan_result_node.result_id=plan_selector_result.result_id AND plan_selector_result.cur_user="current_user"() 
AND v_edit_node.state=1


UNION
SELECT
v_plan_node.node_id,
v_plan_node.nodecat_id,
node_type,
top_elev,
elev,
epa_type,
sector_id,
cost_unit,
v_plan_node.descript,
v_plan_node.calculated_depth,
cost,
v_plan_node.budget,
state,
the_geom,
v_plan_node.expl_id
FROM selector_expl, v_plan_node
WHERE state=2;





DROP VIEW IF EXISTS "v_plan_result_arc" CASCADE;			
CREATE OR REPLACE VIEW "v_plan_result_arc" AS
SELECT
plan_result_arc.arc_id,
plan_result_arc.node_1,
plan_result_arc.node_2,
plan_result_arc.arc_type ,
plan_result_arc.arccat_id ,
plan_result_arc.epa_type ,
plan_result_arc.sector_id,
plan_result_arc.state,
plan_result_arc.annotation,
plan_result_arc.soilcat_id,
plan_result_arc.y1 ,
plan_result_arc.y2 ,
mean_y ,
plan_result_arc.z1 ,
plan_result_arc.z2 ,
thickness ,
width ,
b ,
bulk ,
plan_result_arc.geom1 ,
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
plan_result_arc.the_geom,
plan_result_arc.expl_id
FROM selector_expl, plan_selector_result, plan_result_arc
JOIN v_edit_arc ON v_edit_arc.arc_id=plan_result_arc.arc_id
WHERE plan_result_arc.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() 
AND plan_result_arc.result_id=plan_selector_result.result_id AND plan_selector_result.cur_user="current_user"() 
AND v_edit_arc.state=1

UNION
SELECT
v_plan_arc.*
FROM v_plan_arc
JOIN v_edit_arc ON v_edit_arc.arc_id=v_plan_arc.arc_id
WHERE v_edit_arc.state=2;



	
-- ----------------------------
-- View structure for v_plan_psector_x_arc
-- ----------------------------
DROP VIEW IF EXISTS "v_plan_psector_x_arc" CASCADE;
CREATE VIEW "v_plan_psector_x_arc" AS 
SELECT v_edit_arc.arc_id,
    v_edit_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    plan_arc_x_psector.psector_id,
    plan_psector.psector_type,
    v_edit_arc.state,
    plan_psector.atlas_id,
    v_edit_arc.the_geom
   FROM SCHEMA_NAME.selector_expl,    selector_psector,    v_edit_arc
     JOIN plan_arc_x_psector ON plan_arc_x_psector.arc_id::text = v_edit_arc.arc_id::text
     JOIN v_plan_arc ON v_edit_arc.arc_id::text = v_plan_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_arc_x_psector.psector_id
     JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
  WHERE plan_psector.psector_type = 1 AND v_edit_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id AND v_edit_arc.state = 2 
  AND plan_arc_x_psector.doable = true
UNION
 SELECT v_edit_arc.arc_id,
    v_edit_arc.arccat_id,
    v_plan_result_arc.cost_unit::character varying(3) AS cost_unit,
    v_plan_result_arc.cost::numeric(14,2) AS cost,
    v_plan_result_arc.length::numeric(12,2) AS length,
    v_plan_result_arc.budget::numeric(14,2) AS budget,
    v_plan_result_arc.other_budget,
    v_plan_result_arc.total_budget::numeric(14,2) AS total_budget,
    plan_arc_x_psector.psector_id,
	plan_psector.psector_type,
    v_edit_arc.state,
    plan_psector.atlas_id,
    v_edit_arc.the_geom
   FROM selector_expl,
    selector_psector,
    v_edit_arc
     JOIN plan_arc_x_psector ON plan_arc_x_psector.arc_id::text = v_edit_arc.arc_id::text
     JOIN v_plan_result_arc ON v_edit_arc.arc_id::text = v_plan_result_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_arc_x_psector.psector_id
     JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
  WHERE plan_psector.psector_type = 2 
  AND v_edit_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text 
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id 
  AND v_edit_arc.state = 1
UNION
 SELECT v_edit_arc.arc_id,
    v_edit_arc.arccat_id,
    NULL::character varying(3) AS cost_unit,
    NULL::numeric(14,2) AS cost,
    NULL::numeric(12,2) AS length,
    v_plan_result_reh_arc.total_budget::numeric(14,2) AS budget,
    NULL::numeric(12,2) AS other_budget,
    v_plan_result_reh_arc.total_budget::numeric(14,2) AS total_budget,
    plan_arc_x_psector.psector_id,
	plan_psector.psector_type,
    v_edit_arc.state,
    plan_psector.atlas_id,
    v_edit_arc.the_geom
   FROM selector_expl,
    selector_psector,
    v_edit_arc
     JOIN plan_arc_x_psector ON plan_arc_x_psector.arc_id::text = v_edit_arc.arc_id::text
     JOIN v_plan_result_reh_arc ON v_edit_arc.arc_id::text = v_plan_result_reh_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_arc_x_psector.psector_id
     JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
  WHERE plan_psector.psector_type = 3 AND v_edit_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text 
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id 
  AND v_edit_arc.state = 1;



-- ----------------------------
-- View structure for v_plan_psector_x_node
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_psector_x_node" CASCADE;
CREATE VIEW "v_plan_psector_x_node" AS 
SELECT
v_edit_node.node_id,
v_edit_node.node_type,
plan_node_x_psector.descript,
v_plan_node.calculated_depth,
v_price_x_catnode.cost::numeric(12,2),
v_plan_node.budget as total_budget,
plan_node_x_psector.psector_id,
v_edit_node"state",
plan_psector.atlas_id,
v_edit_node.the_geom,
v_edit_node.expl_id
FROM selector_expl, selector_psector, v_edit_node
JOIN v_price_x_catnode ON v_edit_node.nodecat_id = v_price_x_catnode.id
JOIN plan_node_x_psector ON plan_node_x_psector.node_id = v_edit_node.node_id
JOIN v_plan_node ON v_plan_node.node_id = v_edit_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_node_x_psector.psector_id
JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
WHERE plan_psector.psector_type = 1
AND v_edit_node.expl_id=selector_expl.expl_id
AND selector_expl.cur_user="current_user"()
AND selector_psector.cur_user="current_user"()
AND selector_psector.psector_id=plan_node_x_psector.psector_id
AND v_edit_node.state=2

UNION

SELECT
v_edit_node.node_id,
v_edit_node.node_type as node_type,
plan_node_x_psector.descript,
v_plan_result_node.calculated_depth,
v_price_x_catnode.cost::numeric(12,2),
v_plan_result_node.budget as total_budget,
plan_node_x_psector.psector_id,
v_edit_node"state",
plan_psector.atlas_id,
v_edit_node.the_geom,
v_edit_node.expl_id
FROM selector_expl, selector_psector, v_edit_node
JOIN v_price_x_catnode ON v_edit_node.nodecat_id = v_price_x_catnode.id
JOIN plan_node_x_psector ON plan_node_x_psector.node_id = v_edit_node.node_id
JOIN v_plan_result_node ON v_plan_result_node.node_id = v_edit_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_node_x_psector.psector_id
JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
WHERE plan_psector.psector_type = 2
AND v_edit_node.expl_id=selector_expl.expl_id
AND selector_expl.cur_user="current_user"()
AND selector_psector.cur_user="current_user"()
AND selector_psector.psector_id=plan_node_x_psector.psector_id
AND v_edit_node.state=1

UNION

SELECT 
v_edit_node.node_id,
v_edit_node.node_type as node_type,
plan_node_x_psector.descript,
NULL::numeric(12,2) AS calculated_depth,
NULL::numeric(12,2) AS cost,
v_plan_result_reh_node.total_budget,
plan_node_x_psector.psector_id,
v_edit_node"state",
plan_psector.atlas_id,
v_edit_node.the_geom,
v_edit_node.expl_id
FROM selector_expl, selector_psector, v_edit_node
JOIN v_price_x_catnode ON v_edit_node.nodecat_id = v_price_x_catnode.id
JOIN plan_node_x_psector ON plan_node_x_psector.node_id = v_edit_node.node_id
JOIN v_plan_result_reh_node ON v_plan_result_reh_node.node_id = v_edit_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_node_x_psector.psector_id
JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
WHERE plan_psector.psector_type = 3
AND v_edit_node.expl_id=selector_expl.expl_id
AND selector_expl.cur_user="current_user"()
AND selector_psector.cur_user="current_user"()
AND selector_psector.psector_id=plan_node_x_psector.psector_id
AND v_edit_node.state=1;




DROP VIEW IF EXISTS  "v_plan_psector_x_other" CASCADE;

DROP VIEW IF EXISTS "v_plan_psector_x_other";
CREATE VIEW "v_plan_psector_x_other" AS 
SELECT
plan_other_x_psector.id,
plan_other_x_psector.psector_id,
v_price_compost.id AS price_id,
v_price_compost.descript,
v_price_compost.price,
plan_other_x_psector.measurement,
(plan_other_x_psector.measurement*v_price_compost.price)::numeric(14,2) AS total_budget
FROM plan_other_x_psector 
JOIN v_price_compost ON v_price_compost.id = plan_other_x_psector.price_id
ORDER BY psector_id;


-- ----------------------------
-- View structure for v_plan_psector_arc
-- ----------------------------
 
DROP VIEW IF EXISTS "v_plan_psector_arc" CASCADE;
CREATE VIEW "v_plan_psector_arc" AS 
SELECT 
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
sum(total_budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(total_budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(total_budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(total_budget)))::numeric(14,2) AS pca,
plan_psector.the_geom
FROM v_plan_psector_x_arc
JOIN plan_psector ON v_plan_psector_x_arc.psector_id=plan_psector.psector_id

GROUP BY
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
plan_psector.the_geom,
plan_psector.gexpenses,
plan_psector.vat,
plan_psector.other;



-- ----------------------------
-- View structure for v_plan_psector_node
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_psector_node" CASCADE;
CREATE VIEW "v_plan_psector_node" AS 
SELECT 
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
sum(total_budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(total_budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(total_budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(total_budget)))::numeric(14,2) AS pca,
plan_psector.the_geom

FROM v_plan_psector_x_node
JOIN plan_psector ON v_plan_psector_x_node.psector_id=plan_psector.psector_id

GROUP BY
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
plan_psector.the_geom,
plan_psector.gexpenses,
plan_psector.vat,
plan_psector.other;




DROP VIEW IF EXISTS "v_plan_psector_other" CASCADE;
CREATE VIEW "v_plan_psector_other" AS 
SELECT 
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
sum(v_plan_psector_x_other.total_budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(v_plan_psector_x_other.total_budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(v_plan_psector_x_other.total_budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(v_plan_psector_x_other.total_budget)))::numeric(14,2) AS pca,
plan_psector.the_geom


FROM (((plan_psector
JOIN v_plan_psector_x_other  ON (v_plan_psector_x_other.psector_id) = (plan_psector.psector_id))))

GROUP BY
plan_psector.psector_id,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
plan_psector.the_geom,
plan_psector.gexpenses,
plan_psector.vat,
plan_psector.other;


DROP VIEW IF EXISTS v_plan_psector CASCADE;
 CREATE OR REPLACE VIEW v_plan_psector AS 
 SELECT wtotal.psector_id,
	sum(wtotal.pem::numeric(12,2)) AS pem,
    sum(wtotal.pec::numeric(12,2)) AS pec,
	sum(wtotal.pec_vat::numeric(12,2)) AS pec_vat,
    sum(wtotal.pca::numeric(12,2)) AS pca,
	plan_psector.atlas_id,
    wtotal.the_geom
   FROM (         SELECT v_plan_psector_arc.psector_id,
					v_plan_psector_arc.pem,
                    v_plan_psector_arc.pec,
					v_plan_psector_arc.pec_vat,
                    v_plan_psector_arc.pca,
                    v_plan_psector_arc.the_geom
                   FROM v_plan_psector_arc
        UNION
                 SELECT v_plan_psector_node.psector_id,
					v_plan_psector_node.pem,
                    v_plan_psector_node.pec,
					v_plan_psector_node.pec_vat,
                    v_plan_psector_node.pca,
                    v_plan_psector_node.the_geom
                   FROM v_plan_psector_node
		UNION
                 SELECT v_plan_psector_other.psector_id,
					v_plan_psector_other.pem,
                    v_plan_psector_other.pec,
					v_plan_psector_other.pec_vat,
                    v_plan_psector_other.pca,
                    v_plan_psector_other.the_geom
                   FROM v_plan_psector_other) wtotal	  
		JOIN plan_psector ON plan_psector.psector_id=wtotal.psector_id		   
				GROUP BY wtotal.psector_id, plan_psector.atlas_id, wtotal.the_geom;
