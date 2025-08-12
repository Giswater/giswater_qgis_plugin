/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_state_arc;
DROP view IF EXISTS v_state_connec;
DROP VIEW IF EXISTS v_state_node;
DROP VIEW IF EXISTS v_state_link;
DROP VIEW IF EXISTS v_expl_connec;
DROP VIEW IF EXISTS v_audit_check_project;
DROP VIEW IF EXISTS vcv_times;
DROP VIEW IF EXISTS vcv_emitters;
DROP VIEW IF EXISTS v_polygon;

ALTER VIEW IF EXISTS v_ui_sys_style RENAME TO v_ui_style;

-- PSECTOR
DROP VIEW IF EXISTS v_edit_plan_psector;
DROP VIEW IF EXISTS v_ui_plan_psector;

DROP VIEW IF EXISTS v_plan_psector_arc;
DROP VIEW IF EXISTS v_plan_psector_connec;
DROP VIEW IF EXISTS v_plan_psector_link;
DROP VIEW IF EXISTS v_plan_psector_node;
DROP VIEW IF EXISTS v_plan_psector_all;

CREATE OR REPLACE VIEW ve_plan_psector
AS WITH sel_expl AS (
    SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.ext_code,
    plan_psector.status,
    plan_psector.text3,
    plan_psector.text4,
    plan_psector.text5,
    plan_psector.text6,
    plan_psector.num_value,
    plan_psector.workcat_id,
    plan_psector.workcat_id_plan,
    plan_psector.parent_id,
    plan_psector.creation_date
FROM plan_psector
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = plan_psector.expl_id);

CREATE OR REPLACE VIEW v_ui_plan_psector
AS WITH sel_expl AS (
    SELECT selector_expl.expl_id FROM selector_expl WHERE selector_expl.cur_user = CURRENT_USER
)
SELECT plan_psector.psector_id,
    plan_psector.ext_code,
    plan_psector.name,
    plan_psector.descript,
    p.idval AS priority,
    s.idval AS status,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.expl_id,
    t.idval AS psector_type,
    plan_psector.active,
    plan_psector.archived,
    plan_psector.workcat_id,
    plan_psector.workcat_id_plan,
    plan_psector.parent_id,
    plan_psector.creation_date
FROM plan_psector
LEFT JOIN plan_typevalue p ON p.id::text = plan_psector.priority::text AND p.typevalue = 'value_priority'::text
LEFT JOIN plan_typevalue s ON s.id::text = plan_psector.status::text AND s.typevalue = 'psector_status'::text
LEFT JOIN plan_typevalue t ON t.id::integer = plan_psector.psector_type AND t.typevalue = 'psector_type'::text
WHERE EXISTS (SELECT 1 FROM sel_expl WHERE sel_expl.expl_id = plan_psector.expl_id);

CREATE OR REPLACE VIEW v_plan_psector_arc
AS WITH sel_psector AS (
    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
)
SELECT row_number() OVER () AS rid,
    arc.arc_id,
    plan_psector_x_arc.psector_id,
    arc.code,
    arc.arccat_id,
    cat_arc.arc_type,
    cat_feature.feature_class,
    arc.state AS original_state,
    arc.state_type AS original_state_type,
    plan_psector_x_arc.state AS plan_state,
    plan_psector_x_arc.doable,
    plan_psector_x_arc.addparam::text AS addparam,
    plan_psector.priority AS psector_priority,
    arc.the_geom
FROM arc
JOIN plan_psector_x_arc USING (arc_id)
JOIN plan_psector USING (psector_id)
JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
WHERE EXISTS (SELECT 1 FROM sel_psector WHERE sel_psector.psector_id = plan_psector_x_arc.psector_id);

CREATE OR REPLACE VIEW v_plan_psector_connec
AS WITH sel_psector AS (
    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
)
SELECT row_number() OVER () AS rid,
    connec.connec_id,
    plan_psector_x_connec.psector_id,
    connec.code,
    connec.conneccat_id,
    cat_connec.connec_type,
    cat_feature.feature_class,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    plan_psector.priority AS psector_priority,
    connec.the_geom
FROM connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN plan_psector USING (psector_id)
JOIN cat_connec ON cat_connec.id::text = connec.conneccat_id::text
JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
WHERE EXISTS (SELECT 1 FROM sel_psector WHERE sel_psector.psector_id = plan_psector_x_connec.psector_id);


CREATE OR REPLACE VIEW v_plan_psector_link
AS WITH sel_psector AS (
    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
)
SELECT row_number() OVER () AS rid,
    link.link_id,
    plan_psector_x_connec.psector_id,
    connec.connec_id,
    connec.state AS original_state,
    connec.state_type AS original_state_type,
    plan_psector_x_connec.state AS plan_state,
    plan_psector_x_connec.doable,
    plan_psector.priority AS psector_priority,
    link.the_geom
FROM connec
JOIN plan_psector_x_connec USING (connec_id)
JOIN plan_psector USING (psector_id)
JOIN link ON link.feature_id = connec.connec_id
WHERE EXISTS (SELECT 1 FROM sel_psector WHERE sel_psector.psector_id = plan_psector_x_connec.psector_id);

CREATE OR REPLACE VIEW v_plan_psector_node
AS WITH sel_psector AS (
    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
)
SELECT row_number() OVER () AS rid,
    node.node_id,
    plan_psector_x_node.psector_id,
    node.code,
    node.nodecat_id,
    cat_node.node_type,
    cat_feature.feature_class,
    node.state AS original_state,
    node.state_type AS original_state_type,
    plan_psector_x_node.state AS plan_state,
    plan_psector_x_node.doable,
    plan_psector.priority AS psector_priority,
    node.the_geom
FROM node
JOIN plan_psector_x_node USING (node_id)
JOIN plan_psector USING (psector_id)
JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
WHERE EXISTS (SELECT 1 FROM sel_psector WHERE sel_psector.psector_id = plan_psector_x_node.psector_id);

CREATE OR REPLACE VIEW v_plan_psector_all
AS WITH sel_psector AS (
    SELECT selector_psector.psector_id FROM selector_psector WHERE selector_psector.cur_user = CURRENT_USER
)
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
    ((((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
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
        END)::double precision)::numeric(14,2)::double precision + ((100::numeric + plan_psector.vat) / 100::numeric * (plan_psector.other / 100::numeric))::double precision * (
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
   FROM plan_psector
   LEFT JOIN (
        SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
        FROM (
            SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
                v_plan_arc.arc_id,
                v_plan_arc.node_1,
                v_plan_arc.node_2,
                v_plan_arc.arc_type,
                v_plan_arc.arccat_id,
                v_plan_arc.epa_type,
                v_plan_arc.state,
                v_plan_arc.sector_id,
                v_plan_arc.expl_id,
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
                plan_psector_x_arc.id,
                plan_psector_x_arc.arc_id,
                plan_psector_x_arc.psector_id,
                plan_psector_x_arc.state,
                plan_psector_x_arc.doable,
                plan_psector_x_arc.descript,
                plan_psector_x_arc.addparam
            FROM v_plan_arc
            JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id = v_plan_arc.arc_id
            JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_arc.psector_id
            ORDER BY plan_psector_x_arc.psector_id) v_plan_psector_x_arc(rid, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, state, sector_id, expl_id, annotation, soilcat_id, y1, y2, mean_y, z1, z2, thickness, width, b, bulk, geom1, area, y_param, total_y, rec_y, geom1_ext, calculed_y, m3mlexc, m2mltrenchl, m2mlbottom, m2mlpav, m3mlprotec, m3mlfill, m3mlexcess, m3exc_cost, m2trenchl_cost, m2bottom_cost, m2pav_cost, m3protec_cost, m3fill_cost, m3excess_cost, cost_unit, pav_cost, exc_cost, trenchl_cost, base_cost, protec_cost, fill_cost, excess_cost, arc_cost, cost, length, budget, other_budget, total_budget, the_geom, id, arc_id_1, psector_id, state_1, doable, descript, addparam)
          GROUP BY v_plan_psector_x_arc.psector_id
          ) a ON a.psector_id = plan_psector.psector_id
    LEFT JOIN (
        SELECT sum(v_plan_psector_x_node.budget) AS suma,
            v_plan_psector_x_node.psector_id
        FROM (
            SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
                v_plan_node.node_id,
                v_plan_node.nodecat_id,
                v_plan_node.node_type,
                v_plan_node.top_elev,
                v_plan_node.elev,
                v_plan_node.epa_type,
                v_plan_node.state,
                v_plan_node.sector_id,
                v_plan_node.expl_id,
                v_plan_node.annotation,
                v_plan_node.cost_unit,
                v_plan_node.descript,
                v_plan_node.cost,
                v_plan_node.measurement,
                v_plan_node.budget,
                v_plan_node.the_geom,
                plan_psector_x_node.id,
                plan_psector_x_node.node_id,
                plan_psector_x_node.psector_id,
                plan_psector_x_node.state,
                plan_psector_x_node.doable,
                plan_psector_x_node.descript
            FROM v_plan_node
            JOIN plan_psector_x_node ON plan_psector_x_node.node_id = v_plan_node.node_id
            JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_node.psector_id
            ORDER BY plan_psector_x_node.psector_id) v_plan_psector_x_node(rid, node_id, nodecat_id, node_type, top_elev, elev, epa_type, state, sector_id, expl_id, annotation, cost_unit, descript, cost, measurement, budget, the_geom, id, node_id_1, psector_id, state_1, doable, descript_1)
          GROUP BY v_plan_psector_x_node.psector_id
        ) b ON b.psector_id = plan_psector.psector_id
    LEFT JOIN (
        SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
        FROM (
            SELECT plan_psector_x_other.id,
                plan_psector_x_other.psector_id,
                plan_psector_1.psector_type,
                v_price_compost.id AS price_id,
                v_price_compost.descript,
                v_price_compost.price,
                plan_psector_x_other.measurement,
                (plan_psector_x_other.measurement * v_price_compost.price)::numeric(14,2) AS total_budget
            FROM plan_psector_x_other
            JOIN v_price_compost ON v_price_compost.id::text = plan_psector_x_other.price_id::text
            JOIN plan_psector plan_psector_1 ON plan_psector_1.psector_id = plan_psector_x_other.psector_id
            ORDER BY plan_psector_x_other.psector_id) v_plan_psector_x_other
            GROUP BY v_plan_psector_x_other.psector_id
        ) c ON c.psector_id = plan_psector.psector_id
WHERE EXISTS (SELECT 1 FROM sel_psector WHERE sel_psector.psector_id = plan_psector.psector_id);

DROP VIEW IF EXISTS vcv_emitters;

-- Rename views to element
ALTER VIEW ve_frelem RENAME TO ve_man_frelem;
ALTER VIEW ve_genelem RENAME TO ve_man_genelem;

DO $$
DECLARE
  rec record;
BEGIN
-- frelem
  FOR rec IN (SELECT table_schema, table_name FROM information_schema.views WHERE table_name LIKE '%frelem_%')
  LOOP
    EXECUTE format( 'ALTER VIEW %I.%I RENAME TO %I', rec.table_schema, rec.table_name, replace(rec.table_name, 'frelem', 'element')  );
  END LOOP;
  -- genelem
  FOR rec IN (SELECT table_schema, table_name FROM information_schema.views WHERE table_name LIKE '%genelem_%')
  LOOP
    EXECUTE format( 'ALTER VIEW %I.%I RENAME TO %I', rec.table_schema, rec.table_name, replace(rec.table_name, 'genelem', 'element')  );
  END LOOP;
END $$;