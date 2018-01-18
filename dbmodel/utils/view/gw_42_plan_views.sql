/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


	
	
--------------------------------
-- View structure for v_plan_psector views
--------------------------------

DROP VIEW IF EXISTS "v_plan_psector_x_arc" CASCADE;
CREATE VIEW "v_plan_psector_x_arc" AS 
SELECT 
	row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
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
 	row_number() OVER (ORDER BY plan_result_arc.arc_id) AS rid,
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
  AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = plan_result_arc.state
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id
  AND plan_selector_result.cur_user = "current_user"()::text AND plan_result_arc.result_id = plan_selector_result.result_id
UNION
 SELECT 
 	row_number() OVER (ORDER BY plan_result_reh_arc.arc_id) AS rid,
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
  AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = plan_result_reh_arc.state
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id 
  AND plan_selector_result_reh.cur_user = "current_user"()::text AND plan_result_reh_arc.result_id = plan_selector_result_reh.result_id;
  



DROP VIEW IF EXISTS "v_plan_psector_x_node" CASCADE;
CREATE VIEW "v_plan_psector_x_node" AS 
SELECT
row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
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
row_number() OVER (ORDER BY plan_result_node.node_id) AS rid,
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
  AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = plan_result_node.state
  AND selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_node_x_psector.psector_id
  AND plan_selector_result.cur_user = "current_user"()::text AND plan_result_node.result_id = plan_selector_result.result_id
UNION
SELECT 
row_number() OVER (ORDER BY plan_result_reh_node.node_id) AS rid,
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
  AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = plan_result_reh_node.state
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
SELECT plan_psector.psector_id,
plan_psector.psector_type,
plan_psector.descript,
plan_psector.priority,
sum(a.total_budget)::numeric(14,2) as total_arc,
sum(b.total_budget)::numeric(14,2) as total_node,
sum(c.total_budget)::numeric(14,2) as total_other,
plan_psector.text1,
plan_psector.text2,
plan_psector.observ,
plan_psector.rotation,
plan_psector.scale,
plan_psector.sector_id,
((CASE WHEN sum(a.total_budget) IS NULL THEN 0 ELSE sum(a.total_budget) END)+ 
(CASE WHEN sum(b.total_budget) IS NULL THEN 0 ELSE sum(b.total_budget) END)+ 
(CASE WHEN sum(c.total_budget) IS NULL THEN 0 ELSE sum(c.total_budget) END))::numeric(14,2) AS pem,
gexpenses,

((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * 
((CASE WHEN sum(a.total_budget) IS NULL THEN 0 ELSE sum(a.total_budget) END)+ 
(CASE WHEN sum(b.total_budget) IS NULL THEN 0 ELSE sum(b.total_budget) END)+ 
(CASE WHEN sum(c.total_budget) IS NULL THEN 0 ELSE sum(c.total_budget) END))::numeric(14,2) AS pec,

plan_psector.vat,

(((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * 
((CASE WHEN sum(a.total_budget) IS NULL THEN 0 ELSE sum(a.total_budget) END)+ 
(CASE WHEN sum(b.total_budget) IS NULL THEN 0 ELSE sum(b.total_budget) END)+ 
(CASE WHEN sum(c.total_budget) IS NULL THEN 0 ELSE sum(c.total_budget) END))::numeric(14,2) AS pec_vat,


plan_psector.other,

(((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * 
((CASE WHEN sum(a.total_budget) IS NULL THEN 0 ELSE sum(a.total_budget) END)+ 
(CASE WHEN sum(b.total_budget) IS NULL THEN 0 ELSE sum(b.total_budget) END)+ 
(CASE WHEN sum(c.total_budget) IS NULL THEN 0 ELSE sum(c.total_budget) END))::numeric(14,2) AS pca,

plan_psector.the_geom
FROM plan_psector
LEFT JOIN v_plan_psector_x_arc a ON a.psector_id = plan_psector.psector_id
LEFT JOIN v_plan_psector_x_node b ON b.psector_id = plan_psector.psector_id
LEFT JOIN v_plan_psector_x_other c ON c.psector_id = plan_psector.psector_id

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
