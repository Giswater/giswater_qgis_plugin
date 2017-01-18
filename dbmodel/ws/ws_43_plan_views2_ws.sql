/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- SPECIFIC SQL (WS)

-- ----------------------------
-- View structure for v_plan_ml_arc
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
JOIN v_price_compost ON (((cat_arc."cost")::text = (v_price_compost.id)::text)));


DROP VIEW IF EXISTS "v_price_x_catarc2" CASCADE;
CREATE VIEW "v_price_x_catarc2" AS 
SELECT
	cat_arc.id,
	v_price_compost.price AS m2bottom_cost
FROM (cat_arc
JOIN v_price_compost ON (((cat_arc."m2bottom_cost")::text = (v_price_compost.id)::text)));


DROP VIEW IF EXISTS "v_price_x_catarc3" CASCADE;
CREATE VIEW "v_price_x_catarc3" AS 
SELECT
	cat_arc.id,
	v_price_compost.price AS m3protec_cost
FROM (cat_arc
JOIN v_price_compost ON (((cat_arc."m3protec_cost")::text = (v_price_compost.id)::text)));


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
JOIN v_price_x_catarc2 ON (((v_price_x_catarc2.id)::text = (v_price_x_catarc1.id)::text))
JOIN v_price_x_catarc3 ON (((v_price_x_catarc3.id)::text = (v_price_x_catarc1.id)::text))
);


DROP VIEW IF EXISTS "v_price_x_catpavement" CASCADE;
CREATE VIEW "v_price_x_catpavement" AS 
SELECT
	cat_pavement.id AS pavcat_id,
	cat_pavement.thickness,
	v_price_compost.price AS m2pav_cost
FROM (cat_pavement
JOIN v_price_compost ON (((cat_pavement."m2_cost")::text = (v_price_compost.id)::text)));


DROP VIEW IF EXISTS "v_price_x_catnode" CASCADE;
CREATE VIEW "v_price_x_catnode" AS 
SELECT
	cat_node.id,
	cat_node.estimated_depth,
	cat_node.cost_unit,
	v_price_compost.price AS cost
FROM (cat_node
JOIN v_price_compost ON (((cat_node."cost")::text = (v_price_compost.id)::text)));



DROP VIEW IF EXISTS "v_price_x_node" CASCADE;
CREATE OR REPLACE VIEW v_price_x_node AS 
 SELECT 
 node.node_id, 
    node.nodecat_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price,
        CASE
            WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE 
            CASE
                WHEN (node.depth * 1::numeric) = 0::numeric THEN v_price_x_catnode.estimated_depth
                ELSE node.depth / 2::numeric
            END
        END::numeric(12,2) AS calculated_depth, 

        CASE
            WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN v_price_x_catnode.cost
            ELSE 
            CASE
                WHEN (node.depth * 1::numeric) = 0::numeric THEN v_price_x_catnode.estimated_depth
                ELSE (node.depth / 2::numeric)::numeric(12,2)
            END * v_price_x_catnode.cost
        END::numeric(12,2) AS budget

   FROM v_node node
   LEFT JOIN v_price_x_catnode ON node.nodecat_id::text = v_price_x_catnode.id::text
   JOIN cat_node on cat_node.id=node.nodecat_id
   JOIN v_price_compost ON v_price_compost.id=cat_node.cost;





DROP VIEW IF EXISTS "v_plan_ml_arc" CASCADE;
CREATE VIEW "v_plan_ml_arc" AS 
SELECT 
arc.arc_id,
v_arc_x_node.depth1,
v_arc_x_node.depth2,
(CASE WHEN (v_arc_x_node.depth1*v_arc_x_node.depth2) =0::numeric OR (v_arc_x_node.depth1*v_arc_x_node.depth2) IS NULL THEN v_price_x_catarc.estimated_depth::numeric(12,2) ELSE ((v_arc_x_node.depth1+v_arc_x_node.depth2)/2)::numeric(12,2) END) AS mean_depth,
arc.arccat_id,
v_price_x_catarc.dint/1000 AS dint,
v_price_x_catarc.z1,
v_price_x_catarc.z2,
v_price_x_catarc.area,
v_price_x_catarc.width,
v_price_x_catarc.bulk/1000 AS bulk,
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
sum (v_price_x_catpavement.thickness*plan_arc_x_pavement.percent)::numeric(12,2) AS thickness,
sum (v_price_x_catpavement.m2pav_cost::numeric(12,2)*plan_arc_x_pavement.percent) AS m2pav_cost,
arc.state,
arc.the_geom

FROM v_arc arc
	JOIN v_arc_x_node ON ((((arc.arc_id)::text = (v_arc_x_node.arc_id)::text)))
	LEFT JOIN v_price_x_catarc ON ((((arc.arccat_id)::text = (v_price_x_catarc.id)::text)))
	LEFT JOIN v_price_x_catsoil ON ((((arc.soilcat_id)::text = (v_price_x_catsoil.id)::text)))
	LEFT JOIN plan_arc_x_pavement ON ((((plan_arc_x_pavement.arc_id)::text = (arc.arc_id)::text)))
	LEFT JOIN v_price_x_catpavement ON ((((v_price_x_catpavement.pavcat_id)::text = (plan_arc_x_pavement.pavcat_id)::text)))
	GROUP BY arc.arc_id, v_arc_x_node.depth1, v_arc_x_node.depth2, mean_depth,arc.arccat_id, dint,z1,z2,area,width,bulk, cost_unit, arc_cost, m2bottom_cost,m3protec_cost,v_price_x_catsoil.id, y_param, b, trenchlining, m3exc_cost, m3fill_cost, m3excess_cost, m2trenchl_cost,arc.state, arc.the_geom;
	
	

-- ----------------------------
-- View structure for v_plan_mlcost_arc
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_mlcost_arc" CASCADE;
CREATE OR REPLACE VIEW "v_plan_mlcost_arc" AS 

SELECT
v_plan_ml_arc.arc_id,
v_plan_ml_arc.arccat_id,
v_plan_ml_arc.cost_unit,
v_plan_ml_arc.arc_cost,
v_plan_ml_arc.m2bottom_cost,
v_plan_ml_arc.soilcat_id,
v_plan_ml_arc.m3exc_cost,
v_plan_ml_arc.m3fill_cost,
v_plan_ml_arc.m3excess_cost,
v_plan_ml_arc.m3protec_cost,
v_plan_ml_arc.m2trenchl_cost,
v_plan_ml_arc.m2pav_cost,

(2*((v_plan_ml_arc.mean_depth+v_plan_ml_arc.z1+v_plan_ml_arc.bulk)/v_plan_ml_arc.y_param)+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)::numeric(12,3)							AS m2mlpavement,

((2*v_plan_ml_arc.b)+(v_plan_ml_arc.width))::numeric(12,3)  																												AS m2mlbase,

(v_plan_ml_arc.mean_depth+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)::numeric(12,3)																		AS calculed_depth,

((v_plan_ml_arc.trenchlining)*2*(v_plan_ml_arc.mean_depth+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness))::numeric(12,3)										AS m2mltrenchl,

((v_plan_ml_arc.mean_depth+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)																																								
*((2*((v_plan_ml_arc.mean_depth+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)/v_plan_ml_arc.y_param)+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+									
v_plan_ml_arc.b*2+(v_plan_ml_arc.width))/2)::numeric(12,3)																													AS m3mlexc,

((v_plan_ml_arc.z1+v_plan_ml_arc.dint+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)																	
*(((2*((v_plan_ml_arc.z1+v_plan_ml_arc.dint+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)/v_plan_ml_arc.y_param)
+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+(v_plan_ml_arc.b*2+(v_plan_ml_arc.width)))/2)
- v_plan_ml_arc.area)::numeric(12,3)																																		AS m3mlprotec,

(((v_plan_ml_arc.mean_depth+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)																																								
*((2*((v_plan_ml_arc.mean_depth+v_plan_ml_arc.z1+v_plan_ml_arc.bulk-v_plan_ml_arc.thickness)/v_plan_ml_arc.y_param)+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+								
v_plan_ml_arc.b*2+(v_plan_ml_arc.width))/2)
-((v_plan_ml_arc.z1+v_plan_ml_arc.dint+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)																	
*(((2*((v_plan_ml_arc.z1+v_plan_ml_arc.dint+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)/v_plan_ml_arc.y_param)		
+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+(v_plan_ml_arc.b*2+(v_plan_ml_arc.width)))/2)))::numeric(12,3)																	AS m3mlfill,

((v_plan_ml_arc.z1+v_plan_ml_arc.dint+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)																	
*(((2*((v_plan_ml_arc.z1+v_plan_ml_arc.dint+v_plan_ml_arc.bulk*2+v_plan_ml_arc.z2)/v_plan_ml_arc.y_param)
+(v_plan_ml_arc.width)+v_plan_ml_arc.b*2)+(v_plan_ml_arc.b*2+(v_plan_ml_arc.width)))/2))::numeric(12,3)																		AS m3mlexcess

FROM v_plan_ml_arc;


-- ----------------------------
-- View structure for v_plan_cost_arc
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_cost_arc" CASCADE;
CREATE VIEW "v_plan_cost_arc" AS 
SELECT
v_plan_ml_arc.arc_id,
v_plan_ml_arc.arccat_id,
v_plan_ml_arc.soilcat_id,
v_plan_ml_arc.depth1,
v_plan_ml_arc.depth2,
v_plan_ml_arc.mean_depth,
v_plan_ml_arc.z1,
v_plan_ml_arc.z2,
v_plan_ml_arc.thickness,
v_plan_ml_arc.width,
v_plan_ml_arc.b,
v_plan_ml_arc.bulk,
v_plan_ml_arc.dint,
v_plan_ml_arc.area,
v_plan_ml_arc.y_param,
(v_plan_mlcost_arc.calculed_depth+v_plan_ml_arc.thickness)::numeric(12,2) as total_y,
(v_plan_mlcost_arc.calculed_depth-2*v_plan_ml_arc.bulk-v_plan_ml_arc.z1-v_plan_ml_arc.z2-v_plan_ml_arc.dint)::numeric(12,2) as rec_y,
(v_plan_ml_arc.dint+2*v_plan_ml_arc.bulk)::numeric(12,2) as dext,

v_plan_mlcost_arc.calculed_depth,
v_plan_mlcost_arc.m3mlexc,
v_plan_mlcost_arc.m2mltrenchl,
v_plan_mlcost_arc.m2mlbase AS m2mlbottom,
v_plan_mlcost_arc.m2mlpavement AS m2mlpav,
v_plan_mlcost_arc.m3mlprotec,
v_plan_mlcost_arc.m3mlfill,
v_plan_mlcost_arc.m3mlexcess,

v_plan_mlcost_arc.m3exc_cost::numeric(12,2),
v_plan_mlcost_arc.m2trenchl_cost::numeric(12,2),
v_plan_mlcost_arc.m2bottom_cost::numeric(12,2),
v_plan_mlcost_arc.m2pav_cost::numeric(12,2),
v_plan_mlcost_arc.m3protec_cost::numeric(12,2),
v_plan_mlcost_arc.m3fill_cost::numeric(12,2),
v_plan_mlcost_arc.m3excess_cost::numeric(12,2),
v_plan_ml_arc.cost_unit,

(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost) END)::numeric(12,3) 	AS pav_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost) END)::numeric(12,3) 		AS exc_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost) END)::numeric(12,3)	AS trenchl_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost)END)::numeric(12,3) 		AS base_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost) END)::numeric(12,3) 	AS protec_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost) END)::numeric(12,3) 		AS fill_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE
(v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost) END)::numeric(12,3) 	AS excess_cost,
(v_plan_mlcost_arc.arc_cost)::numeric(12,3)									AS arc_cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN v_plan_ml_arc.arc_cost ELSE
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost
+ v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost
+ v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost
+ v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost
+ v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost
+ v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost
+ v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost
+ v_plan_mlcost_arc.arc_cost) END)::numeric(12,2)							AS cost

FROM v_plan_ml_arc
	JOIN v_plan_mlcost_arc ON ((((v_plan_ml_arc.arc_id)::text = (v_plan_mlcost_arc.arc_id)::text)))
	JOIN plan_selector_state ON (((v_plan_ml_arc."state")::text = (plan_selector_state.id)::text));

	

-- ----------------------------
-- View structure for v_plan_arc
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_arc" CASCADE;
CREATE VIEW "v_plan_arc" AS 
SELECT
v_plan_ml_arc.arc_id,
v_plan_ml_arc.arccat_id,
v_plan_ml_arc.cost_unit,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN v_plan_ml_arc.arc_cost ELSE
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost
+ v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost
+ v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost
+ v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost
+ v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost
+ v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost
+ v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost
+ v_plan_mlcost_arc.arc_cost) END)::numeric(12,2)							AS cost,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN NULL ELSE (st_length2d(v_plan_ml_arc.the_geom)) END)::numeric(12,2)							AS length,
(CASE WHEN (v_plan_ml_arc.cost_unit='u'::text) THEN v_plan_ml_arc.arc_cost ELSE((st_length2d(v_plan_ml_arc.the_geom))::numeric(12,2)*
(v_plan_mlcost_arc.m3mlexc*v_plan_mlcost_arc.m3exc_cost
+ v_plan_mlcost_arc.m2mlbase*v_plan_mlcost_arc.m2bottom_cost
+ v_plan_mlcost_arc.m2mltrenchl*v_plan_mlcost_arc.m2trenchl_cost
+ v_plan_mlcost_arc.m3mlprotec*v_plan_mlcost_arc.m3protec_cost
+ v_plan_mlcost_arc.m3mlfill*v_plan_mlcost_arc.m3fill_cost
+ v_plan_mlcost_arc.m3mlexcess*v_plan_mlcost_arc.m3excess_cost
+ v_plan_mlcost_arc.m2mlpavement*v_plan_mlcost_arc.m2pav_cost
+ v_plan_mlcost_arc.arc_cost)::numeric(14,2)) END)::numeric (14,2)						AS budget,
v_plan_ml_arc."state",
v_plan_ml_arc.the_geom

FROM v_plan_ml_arc
	JOIN v_plan_mlcost_arc ON ((((v_plan_ml_arc.arc_id)::text = (v_plan_mlcost_arc.arc_id)::text)))
	JOIN plan_selector_state ON (((v_plan_ml_arc."state")::text = (plan_selector_state.id)::text));



-- ----------------------------
-- View structure for v_plan_node
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_node" CASCADE;
CREATE VIEW "v_plan_node" AS 
SELECT

node.node_id,
node.node_type,
node.depth,
v_price_x_catnode.cost_unit,
(CASE WHEN (v_price_x_catnode.cost_unit='u'::text) THEN NULL ELSE ((CASE WHEN (node.depth*1=0::numeric) THEN v_price_x_catnode.estimated_depth::numeric(12,2) ELSE ((node.depth)/2)END)) END)::numeric(12,2) AS calculated_depth,
v_price_x_catnode.cost,
(CASE WHEN (v_price_x_catnode.cost_unit='u'::text) THEN v_price_x_catnode.cost ELSE ((CASE WHEN (node.depth*1=0::numeric) THEN v_price_x_catnode.estimated_depth::numeric(12,2) ELSE ((node.depth)/2)::numeric(12,2) END)*v_price_x_catnode.cost) END)::numeric(12,2) AS budget,
node."state",
node.the_geom

FROM (v_node node
LEFT JOIN v_price_x_catnode ON ((((node.nodecat_id)::text = (v_price_x_catnode.id)::text))))
JOIN plan_selector_state ON (((node."state")::text = (plan_selector_state.id)::text));



-- ----------------------------
-- View structure for v_plan_arc_x_psector
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_arc_x_psector" CASCADE;
CREATE VIEW "v_plan_arc_x_psector" AS 
SELECT

arc.arc_id,
arc.arccat_id,
v_plan_arc.cost_unit,
(v_plan_arc.cost)::numeric (14,2) AS cost,
v_plan_arc.length,
v_plan_arc.budget,
plan_arc_x_psector.psector_id,
arc."state",
plan_arc_x_psector.atlas_id,
arc.the_geom

FROM (((arc 
JOIN cat_arc ON ((((arc.arccat_id)::text = (cat_arc.id)::text))))
JOIN plan_arc_x_psector ON ((((plan_arc_x_psector.arc_id)::text = (arc.arc_id)::text))))
JOIN v_plan_arc ON ((((arc.arc_id)::text = (v_plan_arc.arc_id)::text))))
ORDER BY arccat_id;



-- ----------------------------
-- View structure for v_plan_node_x_psector
-- ----------------------------

DROP VIEW IF EXISTS "v_plan_node_x_psector" CASCADE;
CREATE VIEW "v_plan_node_x_psector" AS 
SELECT

node.node_id,
node.node_type,
plan_node_x_psector.descript,
(v_price_x_catnode.cost)::numeric(12,2) AS budget,
plan_node_x_psector.psector_id,
node."state",
plan_node_x_psector.atlas_id,
node.the_geom

FROM ((node 
JOIN v_price_x_catnode ON ((((node.nodecat_id)::text = (v_price_x_catnode.id)::text))))
JOIN plan_node_x_psector ON ((((plan_node_x_psector.node_id)::text = (node.node_id)::text))))
ORDER BY node_type;



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
sum(v_plan_arc.budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(v_plan_arc.budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(v_plan_arc.budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(v_plan_arc.budget)))::numeric(14,2) AS pca,
plan_psector.the_geom

FROM (((((plan_psector
JOIN plan_arc_x_psector ON (plan_arc_x_psector.psector_id)::text = (plan_psector.psector_id)::text))
JOIN v_plan_arc ON ((v_plan_arc.arc_id)::text) = ((plan_arc_x_psector.arc_id)::text))
JOIN arc ON ((arc.arc_id)::text) = ((plan_arc_x_psector.arc_id)::text)))

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
sum(v_plan_node.budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(v_plan_node.budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(v_plan_node.budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(v_plan_node.budget)))::numeric(14,2) AS pca,
plan_psector.the_geom

FROM (((((plan_psector
JOIN plan_node_x_psector ON (plan_node_x_psector.psector_id)::text = (plan_psector.psector_id)::text))
JOIN v_plan_node ON ((v_plan_node.node_id)::text) = ((plan_node_x_psector.node_id)::text))
JOIN node ON ((node.node_id)::text) = ((plan_node_x_psector.node_id)::text)))

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


DROP VIEW IF EXISTS  "v_plan_psector_other" CASCADE;

DROP VIEW IF EXISTS "v_plan_other_x_psector";
CREATE VIEW "v_plan_other_x_psector" AS 
SELECT
plan_other_x_psector.id,
plan_other_x_psector.psector_id,
v_price_compost.id AS price_id,
v_price_compost.descript,
v_price_compost.price,
plan_other_x_psector.measurement,
(plan_other_x_psector.measurement*v_price_compost.price)::numeric(14,2) AS budget

FROM (plan_other_x_psector 
JOIN v_price_compost ON ((((v_price_compost.id)::text = (plan_other_x_psector.price_id)::text))))
ORDER BY psector_id;


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
sum(v_plan_other_x_psector.budget::numeric(14,2)) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(v_plan_other_x_psector.budget)))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(v_plan_other_x_psector.budget)))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*(sum(v_plan_other_x_psector.budget)))::numeric(14,2) AS pca,
plan_psector.the_geom


FROM (((plan_psector
JOIN v_plan_other_x_psector  ON (v_plan_other_x_psector.psector_id)::text = (plan_psector.psector_id)::text)))

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
				   
				GROUP BY wtotal.psector_id, wtotal.the_geom;


				
DROP VIEW IF EXISTS v_plan_psector_filtered CASCADE;			
 CREATE OR REPLACE VIEW v_plan_psector_filtered AS 
 SELECT wtotal.psector_id,
	sum(wtotal.pem::numeric(12,2)) AS pem,
    sum(wtotal.pec::numeric(12,2)) AS pec,
	sum(wtotal.pec_vat::numeric(12,2)) AS pec_vat,
    sum(wtotal.pca::numeric(12,2)) AS pca,
    wtotal.the_geom
   FROM (         SELECT v_plan_psector_arc.psector_id,
					v_plan_psector_arc.pem,
                    v_plan_psector_arc.pec,
					v_plan_psector_arc.pec_vat,
                    v_plan_psector_arc.pca,
                    v_plan_psector_arc.the_geom
                   FROM v_plan_psector_arc
				   JOIN plan_selector_psector  ON (plan_selector_psector.id)::text = (v_plan_psector_arc.psector_id)::text
        UNION
                 SELECT v_plan_psector_node.psector_id,
					v_plan_psector_node.pem,
                    v_plan_psector_node.pec,
					v_plan_psector_node.pec_vat,
                    v_plan_psector_node.pca,
                    v_plan_psector_node.the_geom
                   FROM v_plan_psector_node
				   JOIN plan_selector_psector  ON (plan_selector_psector.id)::text = (v_plan_psector_node.psector_id)::text
		UNION
                 SELECT v_plan_psector_other.psector_id,
					v_plan_psector_other.pem,
                    v_plan_psector_other.pec,
					v_plan_psector_other.pec_vat,
                    v_plan_psector_other.pca,
                    v_plan_psector_other.the_geom
                   FROM v_plan_psector_other
                   JOIN plan_selector_psector  ON (plan_selector_psector.id)::text = (v_plan_psector_other.psector_id)::text) wtotal
				   				   
				GROUP BY wtotal.psector_id, wtotal.the_geom;
				
				