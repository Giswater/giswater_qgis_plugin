/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
DROP VIEW IF EXISTS v_plan_psector_arc;
CREATE OR REPLACE VIEW v_plan_psector_arc AS
SELECT arc.arc_id,
plan_psector_x_arc.psector_id,
arc.code, 
arc.arccat_id,
arc.state AS original_state,
arc.state_type AS original_state_type,
plan_psector_x_arc.state AS plan_state,
plan_psector_x_arc.doable,
plan_psector_x_arc.addparam,
arc.the_geom
FROM selector_psector, arc
JOIN plan_psector_x_arc USING (arc_id)
WHERE plan_psector_x_arc.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_node;
CREATE OR REPLACE VIEW v_plan_psector_node AS
SELECT node.node_id,
plan_psector_x_node.psector_id,
node.code, 
node.nodecat_id,
node.state AS original_state,
node.state_type AS original_state_type,
plan_psector_x_node.state AS plan_state,
plan_psector_x_node.doable,
node.the_geom
FROM selector_psector, node
JOIN plan_psector_x_node USING (node_id)
WHERE plan_psector_x_node.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_connec;
CREATE OR REPLACE VIEW v_plan_psector_connec AS
SELECT connec.connec_id,
plan_psector_x_connec.psector_id,
connec.code, 
connec.connecat_id,
connec.state AS original_state,
connec.state_type AS original_state_type,
plan_psector_x_connec.state AS plan_state,
plan_psector_x_connec.doable,
connec.the_geom
FROM selector_psector, connec
JOIN plan_psector_x_connec USING (connec_id)
WHERE plan_psector_x_connec.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_plan_psector_x_arc;
DROP VIEW IF EXISTS v_plan_psector_x_node;
DROP VIEW IF EXISTS v_plan_psector_x_other;

CREATE OR REPLACE v_plan_psector AS 
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
    FROM selector_psector, plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma, v_plan_psector_x_arc.psector_id FROM (
		SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,v_plan_arc.*, plan_psector_x_arc.* FROM v_plan_arc JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text 
		JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id ORDER BY plan_psector_x_arc.psector_id) 
		v_plan_psector_x_arc GROUP BY v_plan_psector_x_arc.psector_id) a 
		ON a.psector_id = plan_psector.psector_id

     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.budget) AS suma, v_plan_psector_x_node.psector_id FROM (
		SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid, v_plan_node.*, plan_psector_x_node.* FROM v_plan_node JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
		JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id ORDER BY plan_psector_x_node.psector_id
		) v_plan_psector_x_node GROUP BY v_plan_psector_x_node.psector_id) b 
		ON b.psector_id = plan_psector.psector_id

     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma, v_plan_psector_x_other.psector_id FROM ( 
		SELECT plan_psector_x_other.id, plan_psector_x_other.psector_id,  plan_psector.psector_type, v_price_compost.id AS price_id, v_price_compost.descript, v_price_compost.price, plan_psector_x_other.measurement,
		(plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget FROM plan_psector_x_other JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text 
		JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_other.psector_id ORDER BY plan_psector_x_other.psector_id
		) v_plan_psector_x_other GROUP BY v_plan_psector_x_other.psector_id) c 
		ON c.psector_id = plan_psector.psector_id

     WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;


