/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP VIEW IF EXISTS v_ui_om_visit_x_node CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visit_x_node AS 
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second', om_visit_event.tstamp) AS tstamp,
    om_visit_x_node.node_id,
    om_visit_event.parameter_id,
    om_visit_parameter.parameter_type,
    om_visit_parameter.feature_type,
    om_visit_parameter.form_type,
    om_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
    FROM om_visit
    JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
    JOIN om_visit_x_node ON om_visit_x_node.visit_id = om_visit.id
    LEFT JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
    LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
    LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
    ORDER BY om_visit_x_node.node_id;


DROP VIEW IF EXISTS v_ui_om_visit_x_arc CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visit_x_arc AS 
SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second', om_visit_event.tstamp) AS tstamp,
    om_visit_x_arc.arc_id,
    om_visit_event.parameter_id,
    om_visit_parameter.parameter_type,
    om_visit_parameter.feature_type,
    om_visit_parameter.form_type,
    om_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
    FROM om_visit
    JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
    JOIN om_visit_x_arc ON om_visit_x_arc.visit_id = om_visit.id
    LEFT JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
    JOIN arc ON arc.arc_id::text = om_visit_x_arc.arc_id::text
    LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
    LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id                   
    ORDER BY om_visit_x_arc.arc_id;


DROP VIEW IF EXISTS v_ui_om_visit_x_connec CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visit_x_connec AS 
SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code AS code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second', om_visit_event.tstamp) AS tstamp,
    om_visit_x_connec.connec_id,
    om_visit_event.parameter_id,
    om_visit_parameter.parameter_type,
    om_visit_parameter.feature_type,
    om_visit_parameter.form_type,
    om_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document
    FROM om_visit
    JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
    JOIN om_visit_x_connec ON om_visit_x_connec.visit_id = om_visit.id
    JOIN om_visit_parameter ON om_visit_parameter.id::text = om_visit_event.parameter_id::text
    LEFT JOIN connec ON connec.connec_id::text = om_visit_x_connec.connec_id::text
    LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
    LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
    ORDER BY om_visit_x_connec.connec_id;

    
  
  
DROP VIEW IF EXISTS v_ui_om_visitman_x_arc CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visitman_x_arc AS 
SELECT DISTINCT ON (v_ui_om_visit_x_arc.visit_id) v_ui_om_visit_x_arc.visit_id,
    v_ui_om_visit_x_arc.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_arc.arc_id,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_arc.visit_end) AS visit_end,
    v_ui_om_visit_x_arc.user_name,
    v_ui_om_visit_x_arc.is_done,
    v_ui_om_visit_x_arc.feature_type,
    v_ui_om_visit_x_arc.form_type
    FROM v_ui_om_visit_x_arc
    JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_arc.visitcat_id;


DROP VIEW IF EXISTS v_ui_om_visitman_x_node CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visitman_x_node AS 
SELECT DISTINCT ON (v_ui_om_visit_x_node.visit_id) v_ui_om_visit_x_node.visit_id,
    v_ui_om_visit_x_node.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_node.node_id,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_node.visit_end) AS visit_end,
    v_ui_om_visit_x_node.user_name,
    v_ui_om_visit_x_node.is_done,
    v_ui_om_visit_x_node.feature_type,
    v_ui_om_visit_x_node.form_type
    FROM v_ui_om_visit_x_node
    JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_node.visitcat_id;


DROP VIEW IF EXISTS v_ui_om_visitman_x_connec CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visitman_x_connec AS 
 SELECT DISTINCT ON (v_ui_om_visit_x_connec.visit_id) v_ui_om_visit_x_connec.visit_id,
    v_ui_om_visit_x_connec.code,
    om_visit_cat.name AS visitcat_name,
    v_ui_om_visit_x_connec.connec_id,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_start) AS visit_start,
    date_trunc('second'::text, v_ui_om_visit_x_connec.visit_end) AS visit_end,
    v_ui_om_visit_x_connec.user_name,
    v_ui_om_visit_x_connec.is_done,
    v_ui_om_visit_x_connec.feature_type,
    v_ui_om_visit_x_connec.form_type
    FROM v_ui_om_visit_x_connec
    JOIN om_visit_cat ON om_visit_cat.id = v_ui_om_visit_x_connec.visitcat_id;


DROP VIEW IF EXISTS v_om_psector_x_arc CASCADE;
CREATE VIEW "v_om_psector_x_arc" AS 
 SELECT 
 	row_number() OVER (ORDER BY om_rec_result_arc.arc_id) AS rid,
    om_psector_x_arc.psector_id,
	om_psector.psector_type,
    om_rec_result_arc.arc_id,
    om_rec_result_arc.arccat_id,
    om_rec_result_arc.cost_unit::character varying(3) AS cost_unit,
    om_rec_result_arc.cost::numeric(14,2) AS cost,
    om_rec_result_arc.length::numeric(12,2) AS length,
    om_rec_result_arc.budget::numeric(14,2) AS budget,
    om_rec_result_arc.other_budget,
    om_rec_result_arc.total_budget::numeric(14,2) AS total_budget,
	om_psector.result_id,
    om_rec_result_arc.state,
    om_psector.expl_id,
    om_psector.atlas_id,
	om_psector.active,
    om_rec_result_arc.the_geom
   FROM selector_expl, selector_state, om_rec_result_arc
     JOIN om_psector_x_arc ON om_psector_x_arc.arc_id::text = om_rec_result_arc.arc_id::text
     JOIN om_psector ON om_psector.psector_id = om_psector_x_arc.psector_id
     JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
     JOIN om_psector_cat_type ON om_psector_cat_type.id = om_psector.psector_type
  WHERE om_psector.psector_type = 1 
  AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = om_rec_result_arc.expl_id
  AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = om_rec_result_arc.state
  AND om_psector_selector.cur_user = "current_user"()::text
  AND om_rec_result_arc.result_id=om_psector.result_id
UNION
 SELECT 
 	row_number() OVER (ORDER BY om_reh_result_arc.arc_id) AS rid,
	om_psector_x_arc.psector_id,
	om_psector.psector_type,
    om_reh_result_arc.arc_id,
    om_reh_result_arc.arccat_id,
    NULL::character varying(3) AS cost_unit,
    NULL::numeric(14,2) AS cost,
    null AS length,
    om_reh_result_arc.budget::numeric(14,2),
    NULL::numeric(12,2) AS other_budget,
    om_reh_result_arc.budget::numeric(14,2) AS total_budget,
	om_psector.result_id,
    om_reh_result_arc.state,
    om_psector.expl_id,
    om_psector.atlas_id,
	om_psector.active,
    om_reh_result_arc.the_geom
   FROM selector_expl, selector_state, om_reh_result_arc
     JOIN om_psector_x_arc ON om_psector_x_arc.arc_id::text = om_reh_result_arc.arc_id::text
     JOIN om_psector ON om_psector.psector_id = om_psector_x_arc.psector_id
     JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
     JOIN om_psector_cat_type ON om_psector_cat_type.id = om_psector.psector_type
  WHERE om_psector.psector_type = 2 
  AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = om_reh_result_arc.expl_id
  AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = om_reh_result_arc.state
  AND om_psector_selector.cur_user = "current_user"()::text
  AND om_reh_result_arc.result_id=om_psector.result_id
  ORDER BY 2;
  
  
  
DROP VIEW IF EXISTS v_om_psector_x_node CASCADE;
CREATE VIEW "v_om_psector_x_node" AS 
SELECT
row_number() OVER (ORDER BY om_rec_result_node.node_id) AS rid,
om_psector_x_node.psector_id,
om_psector.psector_type,
om_rec_result_node.node_id,
om_rec_result_node.nodecat_id,
om_rec_result_node.cost::numeric(12,2),
om_rec_result_node.measurement,
om_rec_result_node.budget as total_budget,
om_psector.result_id,
om_rec_result_node."state",
om_rec_result_node.expl_id,
om_psector.atlas_id,
om_psector.active,
om_rec_result_node.the_geom
FROM selector_expl, selector_state, om_rec_result_node
JOIN om_psector_x_node ON om_psector_x_node.node_id = om_rec_result_node.node_id
JOIN om_psector ON om_psector.psector_id = om_psector_x_node.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
JOIN om_psector_cat_type ON om_psector_cat_type.id = om_psector.psector_type
WHERE om_psector.psector_type = 1
AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = om_rec_result_node.expl_id
AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = om_rec_result_node.state
AND om_psector_selector.cur_user = "current_user"()::text
AND om_rec_result_node.result_id=om_psector.result_id
UNION
SELECT 
row_number() OVER (ORDER BY om_reh_result_node.node_id) AS rid,
om_psector_x_node.psector_id,
om_psector.psector_type,
om_reh_result_node.node_id,
om_reh_result_node.nodecat_id,
NULL::numeric(12,2) AS cost,
NULL::numeric(12,2) AS measurement,
om_reh_result_node.budget,
om_psector.result_id,
om_reh_result_node."state",
om_reh_result_node.expl_id,
om_psector.atlas_id,
om_psector.active,
om_reh_result_node.the_geom
FROM selector_expl, selector_state, om_reh_result_node
JOIN om_psector_x_node ON om_psector_x_node.node_id = om_reh_result_node.node_id
JOIN om_psector ON om_psector.psector_id = om_psector_x_node.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
JOIN om_psector_cat_type ON om_psector_cat_type.id = om_psector.psector_type
WHERE om_psector.psector_type = 2
AND selector_expl.cur_user = "current_user"()::text AND selector_expl.expl_id = om_reh_result_node.expl_id
AND selector_state.cur_user = "current_user"()::text AND selector_state.state_id = om_reh_result_node.state
AND om_psector_selector.cur_user = "current_user"()::text
AND om_reh_result_node.result_id=om_psector.result_id
ORDER BY 2;
  
  
DROP VIEW IF EXISTS v_om_psector_x_other CASCADE;
CREATE VIEW "v_om_psector_x_other" AS 
SELECT
om_psector_x_other.id,
om_psector_x_other.psector_id,
om_psector.psector_type,
v_price_compost.id AS price_id,
v_price_compost.descript,
v_price_compost.price,
om_psector_x_other.measurement,
(om_psector_x_other.measurement*v_price_compost.price)::numeric(14,2) AS total_budget
FROM om_psector_x_other 
JOIN v_price_compost ON v_price_compost.id = om_psector_x_other.price_id
JOIN om_psector ON om_psector.psector_id = om_psector_x_other.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
WHERE om_psector_selector.cur_user = "current_user"()::text
ORDER BY psector_id;


DROP VIEW IF EXISTS v_om_current_psector CASCADE;
CREATE VIEW "v_om_current_psector" AS 
SELECT om_psector.psector_id,
om_psector.name,
om_psector.psector_type,
om_psector.descript,
om_psector.priority,
om_result_cat.pricecat_id,
om_psector.result_id,
om_result_cat.tstamp::date AS result_date,
(select value from SCHEMA_NAME.config_param_system where parameter='inventory_update_date') as inventory_update_date,
a.suma::numeric(14,2) AS total_arc,
b.suma::numeric(14,2) AS total_node,
c.suma::numeric(14,2) AS total_other,
om_psector.text1,
om_psector.text2,
om_psector.observ,
om_psector.rotation,
om_psector.scale,
om_psector.sector_id,
om_psector.active,
tstamp::date as date_price,
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pem,
gexpenses,

((100::numeric + om_psector.gexpenses) / 100::numeric)::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pec,

om_psector.vat,

(((100::numeric + om_psector.gexpenses) / 100::numeric) * ((100::numeric + om_psector.vat) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pec_vat,


om_psector.other,

(((100::numeric + om_psector.gexpenses) / 100::numeric) * ((100::numeric + om_psector.vat) / 100::numeric) * ((100::numeric + om_psector.other) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pca,

om_psector.the_geom
FROM om_psector
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
JOIN om_result_cat ON om_result_cat.result_id=om_psector.result_id
LEFT JOIN (select sum(total_budget)as suma,psector_id from v_om_psector_x_arc group by psector_id) a ON a.psector_id = om_psector.psector_id
LEFT JOIN (select sum(total_budget)as suma,psector_id from v_om_psector_x_node group by psector_id) b ON b.psector_id = om_psector.psector_id
LEFT JOIN (select sum(total_budget)as suma,psector_id from v_om_psector_x_other group by psector_id) c ON c.psector_id = om_psector.psector_id
WHERE om_psector_selector.cur_user = "current_user"()::text;
	

DROP VIEW IF EXISTS v_om_current_psector_budget CASCADE;
CREATE OR REPLACE VIEW "v_om_current_psector_budget" AS
SELECT     row_number() OVER (ORDER BY a.arc_id) AS rid, 
om_psector.psector_id, 'arc'::text as feature_type, arccat_id as featurecat_id, a.arc_id as feature_id, length::numeric(12,2) AS measurement, (total_budget/length)::numeric(14,2) as unitary_cost, total_budget::numeric(12,2)
FROM arc
JOIN om_psector_x_arc ON om_psector_x_arc.arc_id=arc.arc_id
JOIN om_psector ON om_psector.psector_id=om_psector_x_arc.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
JOIN (SELECT arc_id, length, result_id, sum(budget) as total_budget FROM om_reh_result_arc group by arc_id, result_id, length) a ON a.arc_id=arc.arc_id
WHERE om_psector.result_id=a.result_id
AND om_psector_selector.cur_user = "current_user"()::text
UNION
SELECT      row_number() OVER (ORDER BY om_reh_result_node.node_id)+9000 AS rid,
om_psector.psector_id, 'node'::text, nodecat_id, om_reh_result_node.node_id, 1::numeric(12,2), budget::numeric(12,2), budget::numeric(12,2)
FROM om_reh_result_node
JOIN om_psector_x_node ON om_psector_x_node.node_id=om_reh_result_node.node_id
JOIN om_psector ON om_psector.psector_id=om_psector_x_node.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
WHERE om_psector.result_id=om_reh_result_node.result_id
AND om_psector_selector.cur_user = "current_user"()::text
UNION
SELECT     row_number() OVER (ORDER BY om_rec_result_arc.arc_id)+19000 AS rid,
om_psector.psector_id, 'arc'::text as feature_type, arccat_id featurecat_id, om_rec_result_arc.arc_id as feature_id, length::numeric(12,2), (total_budget/length)::numeric(14,2) as unitary_cost, total_budget::numeric(12,2)
FROM om_rec_result_arc
JOIN om_psector_x_arc ON om_psector_x_arc.arc_id=om_rec_result_arc.arc_id
JOIN om_psector ON om_psector.psector_id=om_psector_x_arc.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
WHERE om_psector.result_id=om_rec_result_arc.result_id
AND om_psector_selector.cur_user = "current_user"()::text
UNION
SELECT      row_number() OVER (ORDER BY om_rec_result_node.node_id)+29000 AS rid,
om_psector.psector_id, 'node'::text, nodecat_id, om_rec_result_node.node_id,  1::numeric(12,2), budget::numeric(12,2), budget::numeric(12,2)
FROM om_rec_result_node
JOIN om_psector_x_node ON om_psector_x_node.node_id=om_rec_result_node.node_id
JOIN om_psector ON om_psector.psector_id=om_psector_x_node.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
WHERE om_psector.result_id=om_rec_result_node.result_id
AND om_psector_selector.cur_user = "current_user"()::text
UNION
SELECT row_number() OVER (ORDER BY v_om_psector_x_other.id)+39000 AS rid, 
psector_id, 'other'::text, price_id, descript, measurement::numeric(12,2), price::numeric(12,2), total_budget::numeric(12,2)
FROM v_om_psector_x_other
order by 1,2,3;


DROP VIEW IF EXISTS v_om_current_psector_budget_detail_rec CASCADE;
CREATE OR REPLACE VIEW "v_om_current_psector_budget_detail_rec" AS
SELECT om_reh_result_arc.id, om_psector.psector_id, om_psector_x_arc.arc_id, arccat_id, init_condition, end_condition, parameter_id, work_id, loc_condition, pcompost_id, measurement::numeric(12,2), cost::numeric(12,2), budget::numeric(12,2)
FROM om_reh_result_arc
JOIN om_psector_x_arc ON om_psector_x_arc.arc_id=om_reh_result_arc.arc_id
JOIN om_psector ON om_psector.psector_id=om_psector_x_arc.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
WHERE om_psector.result_id=om_reh_result_arc.result_id
AND om_psector_selector.cur_user = "current_user"()::text
order by 2,4,3,1;


DROP VIEW IF EXISTS v_om_current_psector_budget_detail_rec CASCADE;
CREATE OR REPLACE VIEW "v_om_current_psector_budget_detail_rec" AS
SELECT om_rec_result_arc.id, om_psector.psector_id, om_psector_x_arc.arc_id, arccat_id,  soilcat_id,   y1,   y2,  arc_cost mlarc_cost,  m3mlexc,  exc_cost AS mlexc_cost,  m2mltrenchl,
trenchl_cost AS mltrench_cost,  m2mlbottom AS m2mlbase,  base_cost AS mlbase_cost  ,  m2mlpav,  pav_cost AS mlpav_cost,
m3mlprotec,  protec_cost AS mlprotec_cost ,  m3mlfill ,  fill_cost AS mlfill_cost ,  m3mlexcess,  excess_cost AS mlexcess_cost 
,cost AS mltotal_cost,  length,   budget   as other_budget  , total_budget 
FROM om_rec_result_arc
JOIN om_psector_x_arc ON om_psector_x_arc.arc_id=om_rec_result_arc.arc_id
JOIN om_psector ON om_psector.psector_id=om_psector_x_arc.psector_id
JOIN om_psector_selector ON om_psector.psector_id=om_psector_selector.psector_id
WHERE om_psector.result_id=om_rec_result_arc.result_id
AND om_psector_selector.cur_user = "current_user"()::text
order by 2,4,3,1;
 
  
DROP VIEW IF EXISTS v_om_psector CASCADE;
CREATE VIEW "v_om_psector" AS 
SELECT *
FROM om_psector;

  
DROP VIEW IF EXISTS v_ui_om_result_cat CASCADE;
CREATE OR REPLACE VIEW v_ui_om_result_cat AS 
 SELECT om_result_cat.result_id,
    om_result_cat.name,
    plan_result_type.name as result_type,
    om_result_cat.pricecat_id,
    om_result_cat.network_price_coeff,
    om_result_cat.descript,
    om_result_cat.tstamp,
    om_result_cat.cur_user
   FROM om_result_cat
   JOIN plan_result_type ON id=result_type;

DROP VIEW IF EXISTS v_ui_om_visit CASCADE;
CREATE OR REPLACE VIEW v_ui_om_visit AS 
 SELECT om_visit.id,
    om_visit_cat.name as visit_catalog,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    exploitation.name as exploitation,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done
   FROM om_visit
   JOIN om_visit_cat ON visitcat_id=om_visit_cat.id
   LEFT JOIN exploitation on exploitation.expl_id=om_visit.expl_id;

  
  

   