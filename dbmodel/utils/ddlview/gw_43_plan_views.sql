/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

	
--------------------------------
-- View structure for v_plan_psector views
--------------------------------

-- view updated on 3.1.105
DROP VIEW IF EXISTS v_plan_psector_x_arc CASCADE;
CREATE VIEW "v_plan_psector_x_arc" AS 
SELECT 
	row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
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
   FROM selector_psector, v_plan_arc
    JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
    JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
    WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_psector_x_arc.psector_id 
	AND v_plan_arc.state = 2 AND plan_psector_x_arc.doable = true
	order by 2;
  
  
-- view updated on 3.1.105
DROP VIEW IF EXISTS v_plan_psector_x_node CASCADE;
CREATE VIEW "v_plan_psector_x_node" AS 
SELECT
row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
plan_psector_x_node.psector_id,
plan_psector.psector_type,
v_plan_node.node_id,
v_plan_node.nodecat_id,
v_plan_node.cost::numeric(12,2),
v_plan_node.measurement,
v_plan_node.budget as total_budget,
v_plan_node."state",
v_plan_node.expl_id,
plan_psector.atlas_id,
v_plan_node.the_geom
FROM selector_psector, v_plan_node
JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
WHERE selector_psector.cur_user="current_user"() AND selector_psector.psector_id=plan_psector_x_node.psector_id
AND v_plan_node.state=2 AND plan_psector_x_node.doable = true
order by 2;

  

DROP VIEW IF EXISTS v_plan_psector_x_other CASCADE;
CREATE VIEW "v_plan_psector_x_other" AS 
SELECT
plan_psector_x_other.id,
plan_psector_x_other.psector_id,
plan_psector.psector_type,
v_price_compost.id AS price_id,
v_price_compost.descript,
v_price_compost.price,
plan_psector_x_other.measurement,
(plan_psector_x_other.measurement*v_price_compost.price)::numeric(14,2) AS total_budget
FROM plan_psector_x_other 
JOIN v_price_compost ON v_price_compost.id = plan_psector_x_other.price_id
JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id
order by 2;



DROP VIEW IF EXISTS v_plan_psector CASCADE;
CREATE VIEW "v_plan_psector" AS 
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
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pem,
gexpenses,

(((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END)))::numeric(14,2) AS pec,

plan_psector.vat,

((((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END)))::numeric(14,2) AS pec_vat,


plan_psector.other,

((((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END)))::numeric(14,2) AS pca,

plan_psector.the_geom
FROM selector_psector, plan_psector
    LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_arc group by psector_id) a ON a.psector_id = plan_psector.psector_id
    LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_node group by psector_id) b ON b.psector_id = plan_psector.psector_id
    LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_other group by psector_id) c ON c.psector_id = plan_psector.psector_id
    WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;
	


DROP VIEW IF EXISTS v_plan_current_psector CASCADE;	
CREATE VIEW "v_plan_current_psector" AS 
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
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pem,
gexpenses,

((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pec,

plan_psector.vat,

(((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pec_vat,

plan_psector.other,

(((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pca,

plan_psector.the_geom
FROM plan_psector
	JOIN plan_psector_selector ON plan_psector.psector_id = plan_psector_selector.psector_id
    LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_arc group by psector_id) a ON a.psector_id = plan_psector.psector_id
    LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_node group by psector_id) b ON b.psector_id = plan_psector.psector_id
    LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_other group by psector_id) c ON c.psector_id = plan_psector.psector_id
    WHERE plan_psector_selector.cur_user = "current_user"()::text;	
	
	
	
DROP VIEW IF EXISTS v_plan_current_psector_budget CASCADE;
CREATE OR REPLACE VIEW "v_plan_current_psector_budget" AS
SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
psector_id,'arc'::text as feature_type, arccat_id featurecat_id, v_plan_arc.arc_id as feature_id, length, (total_budget/length)::numeric(14,2) as unitary_cost, total_budget
FROM v_plan_arc
JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id=v_plan_arc.arc_id
WHERE plan_psector_x_arc.doable = true
UNION
SELECT row_number() OVER (ORDER BY v_plan_node.node_id)+9999 AS rid, 
psector_id, 'node'::text, nodecat_id, v_plan_node.node_id, 1, budget, budget
FROM v_plan_node
JOIN plan_psector_x_node ON plan_psector_x_node.node_id=v_plan_node.node_id
WHERE plan_psector_x_node.doable = true
UNION
SELECT row_number() OVER (ORDER BY v_plan_psector_x_other.id)+19999 AS rid, 
psector_id, 'other'::text, price_id, descript, measurement, price, total_budget
FROM v_plan_psector_x_other
order by 1,2,4;



DROP VIEW IF EXISTS v_plan_current_psector_budget_detail CASCADE;
CREATE OR REPLACE VIEW "v_plan_current_psector_budget_detail" AS
SELECT   v_plan_arc.arc_id, psector_id, arccat_id,  soilcat_id,   y1,   y2,  arc_cost mlarc_cost,  m3mlexc,  exc_cost AS mlexc_cost,  m2mltrenchl,
trenchl_cost AS mltrench_cost,  m2mlbottom AS m2mlbase,  base_cost AS mlbase_cost  ,  m2mlpav,  pav_cost AS mlpav_cost,
m3mlprotec,  protec_cost AS mlprotec_cost ,  m3mlfill ,  fill_cost AS mlfill_cost ,  m3mlexcess,  excess_cost AS mlexcess_cost 
,cost AS mltotal_cost,  length,   budget   as other_budget  , total_budget 
FROM v_plan_arc
JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id=v_plan_arc.arc_id
where plan_psector_x_arc.doable = true
order by 2,4,3

	
	
	
