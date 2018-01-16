/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


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
WHERE plan_result_node.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() 
AND plan_result_node.result_id::text=plan_selector_result.result_id::text AND plan_selector_result.cur_user="current_user"() 
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
calculated_depth,
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
FROM plan_selector_result, plan_result_arc
WHERE plan_result_arc.result_id::text=plan_selector_result.result_id::text AND plan_selector_result.cur_user="current_user"() 
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



	
	
--------------------------------
-- View structure for v_plan_psector views
--------------------------------

DROP VIEW IF EXISTS "v_plan_psector_x_arc" CASCADE;
CREATE VIEW "v_plan_psector_x_arc" AS 
SELECT 
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    plan_arc_x_psector.psector_id,
    plan_psector.psector_type,
    v_plan_arc.state,
     plan_psector.expl_id,
    plan_psector.atlas_id,
    v_plan_arc.the_geom
   FROM selector_psector, v_plan_arc
     JOIN plan_arc_x_psector ON plan_arc_x_psector.arc_id::text = v_plan_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_arc_x_psector.psector_id
     JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
  WHERE plan_psector.psector_type = 1 
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id AND v_plan_arc.state = 2 
  AND plan_arc_x_psector.doable = true
UNION
 SELECT 
     plan_result_arc.arc_id,
    plan_result_arc.arccat_id,
    plan_result_arc.cost_unit::character varying(3) AS cost_unit,
    plan_result_arc.cost::numeric(14,2) AS cost,
    plan_result_arc.length::numeric(12,2) AS length,
    plan_result_arc.budget::numeric(14,2) AS budget,
    plan_result_arc.other_budget,
    plan_result_arc.total_budget::numeric(14,2) AS total_budget,
    plan_arc_x_psector.psector_id,
    plan_psector.psector_type,
    plan_result_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_result_arc.the_geom
   FROM selector_expl, selector_state, selector_psector, plan_selector_result, plan_result_arc
     JOIN plan_arc_x_psector ON plan_arc_x_psector.arc_id::text = plan_result_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_arc_x_psector.psector_id
     JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
  WHERE plan_psector.psector_type = 2 
  AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = plan_result_arc.expl_id
  AND selector_state.cur_user = "current_user"()::text AND selector_state.id = plan_result_arc.state
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id
  AND plan_selector_result.cur_user = "current_user"()::text AND plan_result_arc.result_id = plan_selector_result.result_id
UNION
 SELECT 
    plan_result_reh_arc.arc_id,
    plan_result_reh_arc.arccat_id,
    NULL::character varying(3) AS cost_unit,
    NULL::numeric(14,2) AS cost,
    null AS length,
    plan_result_reh_arc.total_budget::numeric(14,2) AS budget,
    NULL::numeric(12,2) AS other_budget,
    plan_result_reh_arc.total_budget::numeric(14,2) AS total_budget,
    plan_arc_x_psector.psector_id,
    plan_psector.psector_type,
    plan_result_reh_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    plan_result_reh_arc.the_geom
   FROM selector_expl, selector_state, selector_psector, plan_selector_result_reh, plan_result_reh_arc
     JOIN plan_arc_x_psector ON plan_arc_x_psector.arc_id::text = plan_result_reh_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_arc_x_psector.psector_id
     JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
  WHERE plan_psector.psector_type = 3 
  AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = plan_result_reh_arc.expl_id
  AND selector_state.cur_user = "current_user"()::text AND selector_state.id = plan_result_reh_arc.state
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id 
  AND plan_selector_result_reh.cur_user = "current_user"()::text AND plan_result_reh_arc.result_id = plan_selector_result_reh.result_id;
  



DROP VIEW IF EXISTS "v_plan_psector_x_node" CASCADE;
CREATE VIEW "v_plan_psector_x_node" AS 
SELECT
v_plan_node.node_id,
v_plan_node.nodecat_id,
v_plan_node.cost::numeric(12,2),
v_plan_node.calculated_depth,
v_plan_node.budget as total_budget,
plan_node_x_psector.psector_id,
plan_psector.psector_type,
v_plan_node."state",
v_plan_node.expl_id,
plan_psector.atlas_id,
v_plan_node.the_geom
FROM selector_psector, v_plan_node
JOIN plan_node_x_psector ON plan_node_x_psector.node_id = v_plan_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_node_x_psector.psector_id
JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
WHERE plan_psector.psector_type = 1
AND selector_psector.cur_user="current_user"() AND selector_psector.psector_id=plan_node_x_psector.psector_id
AND v_plan_node.state=2
UNION
SELECT
plan_result_node.node_id,
plan_result_node.nodecat_id,
plan_result_node.cost::numeric(12,2),
plan_result_node.calculated_depth,
plan_result_node.budget as total_budget,
plan_node_x_psector.psector_id,
plan_psector.psector_type,
plan_result_node."state",
plan_result_node.expl_id,
plan_psector.atlas_id,
plan_result_node.the_geom
FROM selector_expl, selector_state, selector_psector, plan_selector_result, plan_result_node
JOIN plan_node_x_psector ON plan_node_x_psector.node_id = plan_result_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_node_x_psector.psector_id
JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
WHERE plan_psector.psector_type = 2
  AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = plan_result_node.expl_id
  AND selector_state.cur_user = "current_user"()::text AND selector_state.id = plan_result_node.state
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_node_x_psector.psector_id
  AND plan_selector_result.cur_user = "current_user"()::text AND plan_result_node.result_id = plan_selector_result.result_id
UNION
SELECT 
plan_result_reh_node.node_id,
plan_result_reh_node.nodecat_id,
NULL::numeric(12,2) AS cost,
NULL::numeric(12,2) AS calculated_depth,
plan_result_reh_node.total_budget,
plan_node_x_psector.psector_id,
plan_psector.psector_type,
plan_result_reh_node."state",
plan_result_reh_node.expl_id,
plan_psector.atlas_id,
plan_result_reh_node.the_geom
FROM selector_expl, selector_state, selector_psector, plan_selector_result_reh, plan_result_reh_node
JOIN plan_node_x_psector ON plan_node_x_psector.node_id = plan_result_reh_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_node_x_psector.psector_id
JOIN plan_value_psector_type ON plan_value_psector_type.id = plan_psector.psector_type
  WHERE plan_psector.psector_type = 3 
  AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = plan_result_reh_node.expl_id
  AND selector_state.cur_user = "current_user"()::text AND selector_state.id = plan_result_reh_node.state
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_node_x_psector.psector_id 
  AND plan_selector_result_reh.cur_user = "current_user"()::text AND plan_result_reh_node.result_id = plan_selector_result_reh.result_id;
  


DROP VIEW IF EXISTS  "v_plan_psector_x_other" CASCADE;
DROP VIEW IF EXISTS "v_plan_psector_x_other";
CREATE VIEW "v_plan_psector_x_other" AS 
SELECT
plan_other_x_psector.id,
plan_other_x_psector.psector_id,
plan_psector.psector_type,
v_price_compost.id AS price_id,
v_price_compost.descript,
v_price_compost.price,
plan_other_x_psector.measurement,
(plan_other_x_psector.measurement*v_price_compost.price)::numeric(14,2) AS total_budget
FROM plan_other_x_psector 
JOIN v_price_compost ON v_price_compost.id = plan_other_x_psector.price_id
JOIN plan_psector ON plan_psector.psector_id = plan_other_x_psector.psector_id
ORDER BY psector_id;




DROP VIEW IF EXISTS "v_plan_psector";
CREATE VIEW "v_plan_psector" AS 
SELECT 
plan_psector.psector_id,
plan_psector.psector_type,
plan_psector.descript,
plan_psector.priority,
plan_psector.text1, 
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
(sum(a.total_budget::numeric(14,2))+sum(n.total_budget::numeric(14,2))+sum(o.total_budget::numeric(14,2))) AS pem,
plan_psector.gexpenses,
(((100+plan_psector.gexpenses)/100)*(sum(a.total_budget::numeric(14,2))+sum(n.total_budget::numeric(14,2))
+sum(o.total_budget::numeric(14,2))))::numeric(14,2) AS pec,
plan_psector.vat,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*(sum(a.total_budget::numeric(14,2))
+sum(n.total_budget::numeric(14,2))+sum(o.total_budget::numeric(14,2))))::numeric(14,2) AS pec_vat,
plan_psector.other,
(((100+plan_psector.gexpenses)/100)*((100+plan_psector.vat)/100)*((100+plan_psector.other)/100)*
(sum(a.total_budget::numeric(14,2))+sum(n.total_budget::numeric(14,2))+sum(o.total_budget::numeric(14,2))))::numeric(14,2) AS pca,
plan_psector.the_geom
FROM plan_psector
JOIN v_plan_psector_x_arc a ON a.psector_id=plan_psector.psector_id
JOIN v_plan_psector_x_node n ON n.psector_id=plan_psector.psector_id
JOIN v_plan_psector_x_other o ON o.psector_id=plan_psector.psector_id

GROUP BY
plan_psector.psector_id,
plan_psector.psector_type,
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

