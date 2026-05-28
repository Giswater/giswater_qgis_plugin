/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"crm_number", "dataType":"text"}}$$);

ALTER TABLE plan_psector ADD COLUMN workcat_id_plan text;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_workcat_id_plan_fkey FOREIGN KEY (workcat_id_plan) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE;
CREATE INDEX idx_plan_psector_workcat_id_plan ON plan_psector(workcat_id_plan);

DROP RULE IF EXISTS insert_plan_psector_x_node ON node;
DROP RULE IF EXISTS insert_plan_psector_x_arc ON arc;

ALTER TABLE archived_psector_connec_traceability RENAME COLUMN tstamp TO created_at;
ALTER TABLE archived_psector_connec_traceability RENAME COLUMN insert_user TO created_by;
ALTER TABLE archived_psector_connec_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_connec_traceability RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE archived_psector_arc_traceability RENAME COLUMN tstamp TO created_at;
ALTER TABLE archived_psector_arc_traceability RENAME COLUMN insert_user TO created_by;
ALTER TABLE archived_psector_arc_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_arc_traceability RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE archived_psector_node_traceability RENAME COLUMN tstamp TO created_at;
ALTER TABLE archived_psector_node_traceability RENAME column insert_user TO created_by;
ALTER TABLE archived_psector_node_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_node_traceability RENAME COLUMN lastupdate_user TO updated_by;

ALTER TABLE archived_psector_link_traceability RENAME column insert_user TO created_by;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN lastupdate_user TO updated_by;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN exit_topelev TO top_elev2;
ALTER TABLE archived_psector_link_traceability RENAME COLUMN exit_elev TO depth2;
ALTER TABLE archived_psector_link_traceability RENAME column staticpressure TO staticpressure1;
ALTER TABLE archived_psector_link_traceability RENAME column conneccat_id TO linkcat_id;

ALTER TABLE archived_psector_link_traceability add column created_at varchar(50);
ALTER TABLE archived_psector_link_traceability add column staticpressure2 numeric(12,3);

ALTER TABLE archived_psector_node_traceability RENAME to archived_psector_node;
ALTER TABLE archived_psector_arc_traceability RENAME to archived_psector_arc;
ALTER TABLE archived_psector_connec_traceability RENAME to archived_psector_connec;
ALTER TABLE archived_psector_link_traceability RENAME to archived_psector_link;

ALTER TABLE plan_psector RENAME COLUMN tstamp TO created_at;
ALTER TABLE plan_psector RENAME column insert_user TO created_by;
ALTER TABLE plan_psector RENAME COLUMN lastupdate TO updated_at;
ALTER TABLE plan_psector RENAME COLUMN lastupdate_user TO updated_by;

ALTER SEQUENCE archived_psector_arc_traceability_id_seq RENAME TO archived_psector_arc_id_seq;
ALTER SEQUENCE archived_psector_node_traceability_id_seq RENAME TO archived_psector_node_id_seq;
ALTER SEQUENCE archived_psector_connec_traceability_id_seq RENAME TO archived_psector_connec_id_seq;
ALTER SEQUENCE archived_psector_link_traceability_id_seq RENAME TO archived_psector_link_id_seq;

ALTER TABLE archived_psector_arc RENAME CONSTRAINT audit_psector_arc_traceability_pkey TO archived_psector_arc_pkey;
ALTER TABLE archived_psector_connec RENAME CONSTRAINT audit_psector_connec_traceability_pkey TO archived_psector_connec_pkey;
ALTER TABLE archived_psector_node RENAME CONSTRAINT audit_psector_node_traceability_pkey TO archived_psector_node_pkey;
ALTER TABLE archived_psector_link RENAME CONSTRAINT archived_psector_link_traceability_pkey TO archived_psector_link_pkey;


ALTER TABLE archived_psector_node drop column streetname;
ALTER TABLE archived_psector_arc drop column streetname;
ALTER TABLE archived_psector_connec drop column streetname;

ALTER TABLE archived_psector_node drop column streetname2;
ALTER TABLE archived_psector_arc drop column streetname2;
ALTER TABLE archived_psector_connec drop column streetname2;

update sys_param_user set dv_querytext= 'SELECT cat_link.id, cat_link.id AS idval FROM cat_link' where id ='edit_linkcat_vdefault';
delete from sys_param_user where id = 'edit_connec_linkcat_vdefault';
update sys_param_user set id = 'edit_connec_linkcat_vdefault' where id = 'edit_linkcat_vdefault';

ALTER TABLE link DROP COLUMN IF EXISTS epa_type CASCADE;

DELETE FROM config_form_fields WHERE formname ilike '%link%' AND columnname = 'epa_type';

DROP TABLE IF EXISTS man_link;


UPDATE sys_foreignkey SET target_table='archived_psector_arc' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_arc_traceability' AND target_field='fluid_type';
UPDATE sys_foreignkey SET target_table='archived_psector_connec' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_connec_traceability' AND target_field='fluid_type';
UPDATE sys_foreignkey SET target_table='archived_psector_link' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_link_traceability' AND target_field='fluid_type';
UPDATE sys_foreignkey SET target_table='archived_psector_node' WHERE typevalue_table='om_typevalue' AND typevalue_name='fluid_type' AND target_table='archived_psector_node_traceability' AND target_field='fluid_type';

UPDATE sys_table SET descript='archived_psector_arc', id='archived_psector_arc' WHERE id='archived_psector_arc_traceability';
UPDATE sys_table SET descript='archived_psector_node', id='archived_psector_node' WHERE id='archived_psector_node_traceability';
UPDATE sys_table SET descript='archived_psector_connec', id='archived_psector_connec' WHERE id='archived_psector_connec_traceability';
UPDATE sys_table SET descript='archived_psector_link', id='archived_psector_link' WHERE id='archived_psector_link_traceability';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"man_valve", "column":"flowsetting", "dataType":"numeric(12,3)"}}$$);


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
CREATE OR REPLACE VIEW ve_man_frelem AS
  SELECT ve_element.element_id,
    ve_element.code,
    ve_element.sys_code,
    ve_element.top_elev,
    ve_element.element_type,
    ve_element.elementcat_id,
    ve_element.num_elements,
    ve_element.epa_type,
    ve_element.state,
    ve_element.state_type,
    ve_element.expl_id,
    ve_element.muni_id,
    ve_element.sector_id,
    ve_element.omzone_id,
    ve_element.function_type,
    ve_element.category_type,
    ve_element.location_type,
    ve_element.observ,
    ve_element.comment,
    ve_element.link,
    ve_element.workcat_id,
    ve_element.workcat_id_end,
    ve_element.builtdate,
    ve_element.enddate,
    ve_element.ownercat_id,
    ve_element.brand_id,
    ve_element.model_id,
    ve_element.serial_number,
    ve_element.asset_id,
    ve_element.verified,
    ve_element.datasource,
    ve_element.label_x,
    ve_element.label_y,
    ve_element.label_rotation,
    ve_element.rotation,
    ve_element.inventory,
    ve_element.publish,
    ve_element.trace_featuregeom,
    ve_element.lock_level,
    ve_element.expl_visibility,
    man_frelem.node_id,
    man_frelem.order_id,
    concat(man_frelem.node_id, '_FR', man_frelem.order_id) AS nodarc_id,
    man_frelem.to_arc,
    man_frelem.flwreg_length,
    ve_element.created_at,
    ve_element.created_by,
    ve_element.updated_at,
    ve_element.updated_by,
        CASE
            WHEN man_frelem.node_id = a.node_1 THEN st_setsrid(st_makeline(node.the_geom, st_lineinterpolatepoint(a.the_geom, man_frelem.flwreg_length::double precision / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE)
            WHEN man_frelem.node_id = a.node_2 THEN st_setsrid(st_makeline(node.the_geom, st_lineinterpolatepoint(a.the_geom, 1::double precision - man_frelem.flwreg_length::double precision / st_length(a.the_geom))), SRID_VALUE)::geometry(LineString,SRID_VALUE)
            ELSE NULL::geometry(LineString,SRID_VALUE)
        END AS the_geom
   FROM ve_element
     JOIN man_frelem ON ve_element.element_id = man_frelem.element_id
     JOIN arc a ON a.arc_id = man_frelem.to_arc
     JOIN node USING (node_id);

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

UPDATE sys_function SET descript='Check topology assistant. Analyze and validate the length of arcs for potential inconsistencies or errors.' WHERE id=3052;

UPDATE sys_table SET project_template='{"template": [1], "visibility": true, "levels_to_read": 3}'::jsonb WHERE id='ve_genelem';
UPDATE sys_table SET addparam = NULL WHERE id ilike '%elem%';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3482, 'gw_fct_graphanalytics_macromapzones', 'utils', 'function', 'json', 'json', 'Function to analyze network as a macro graph.', 'role_om', NULL, 'core', NULL);

DELETE FROM config_form_fields WHERE columnname='undelete';

UPDATE config_toolbox SET inputparams='[{"label":"Direct insert into node table:","value":null,"datatype":"boolean","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"insertIntoNode","widgettype":"check","layoutorder":1},{"label":"Node tolerance:","value":null,"datatype":"float","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"nodeTolerance","widgettype":"spinbox","layoutorder":2},{"label":"Exploitation ids:","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"exploitation","widgettype":"combo","dvQueryText":"select expl_id as id, name as idval from exploitation where active is not false order by name","layoutorder":3},{"label":"State:","value":null,"datatype":"integer","isparent":"true","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"stateType","widgettype":"combo","dvQueryText":"select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id","layoutorder":4},{"label":"Workcat:","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"workcatId","widgettype":"combo","dvQueryText":"select id as id, id as idval from cat_work where id is not null","isNullValue":true,"layoutorder":5},{"label":"Builtdate:","value":null,"datatype":"date","layoutname":"grl_option_parameters","selectedId":null,"widgetname":"builtdate","widgettype":"datetime","layoutorder":6},{"label":"Node type:","isparent":true,"value":null,"datatype":"text","iseditable":true,"layoutname":"grl_option_parameters","selectedId":"$userNodetype","widgetname":"nodeType","widgettype":"combo","dvQueryText":"select distinct cfn.id as id, cfn.id as idval from cat_feature_node cfn JOIN cat_node cn ON cn.node_type=cfn.id where cfn.id is not null","layoutorder":7},{"label":"Node catalog:","dvparentid":"node_type","dvquerytext_filterc":" AND value_state_type.state","value":null,"datatype":"text","layoutname":"grl_option_parameters","selectedId":"$userNodecat","widgetname":"nodeCat","widgettype":"combo","dvQueryText":"select distinct id as id, id as idval from cat_node order by id","parentname":"nodeType","filterquery":"select distinct id as id, id as idval from cat_node where node_type = ''{parent_value}'' order by id","layoutorder":8}]'::json WHERE id=2118;

INSERT INTO sys_message (id,error_message,hint_message,log_level,show_user,project_type,"source",message_type)
VALUES (4140,'The specified feature type is not supported: %feature_type%','Must be ''FEATURE'' or ''ELEMENT''',2,true,'utils','core','UI');

UPDATE config_param_system
	SET value = jsonb_set(value::jsonb, '{sys_query_text_add}', '"SELECT distinct(concat(s.name, '''', '''', m.name, '''', '''', a.postnumber)) as \"displayName\" FROM v_ext_streetaxis s join ext_municipality m using(muni_id) join v_ext_address a on s.id = a.streetaxis_id WHERE concat(s.name, '''', '''', m.name, '''', '''', a.postnumber) ILIKE "')
	WHERE parameter='basic_search_v2_tab_address';

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3484, 'gw_fct_getfeatures', 'utils', 'function', 'json', 'json', 'Function for getting features filtering by sys_type and mapzone, with optional ordering by parameter.', NULL, NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3486, 'gw_fct_getdmas', 'utils', 'function', 'json', 'json', 'Function to get a list of DMAs.', 'role_basic', NULL, 'core', NULL);

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3488, 'gw_fct_getdmahydrometers', 'utils', 'function', 'json', 'json', 'Function to get DMA hydrometers.', 'role_om', NULL, 'core', NULL);

UPDATE sys_table SET alias = 'Node' WHERE id='v_edit_node' AND alias='Node (parent)';
UPDATE sys_table SET alias = 'Arc' WHERE id='v_edit_arc' AND alias='Arc (parent)';
UPDATE sys_table SET alias = 'Connec' WHERE id='v_edit_connec' AND alias='Connec (parent)';
UPDATE sys_table SET alias = 'Link' WHERE id='v_edit_link' AND alias='Link (parent)';
UPDATE sys_table SET alias = 'Gully' WHERE id='v_edit_gully' AND alias='Gully (parent)';
UPDATE sys_table SET alias = 'FRElement' WHERE id='ve_frelem';
UPDATE sys_table SET alias = 'GenElement', context='{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}', orderby=1 WHERE id='ve_genelem';
UPDATE sys_table SET alias = 'Municipality' WHERE id='v_ext_municipality';

UPDATE config_form_fields SET dv_querytext='SELECT element_id as id, element_id as idval FROM v_ui_element WHERE element_id IS NOT NULL', widgetfunction='{"functionName": "filter_table", "parameters":{"columnfind":"element_id"}}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='element_id' AND tabname='tab_none';
UPDATE config_form_fields SET widgetfunction='{"functionName":"open_selected_manager_item", "parameters":{"columnfind":"element_id"}}'::json WHERE formname='element_manager' AND formtype='form_element' AND columnname='tbl_element' AND tabname='tab_none';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES (4320, 'The element is already linked to a node: %node_id%', 'Unlink the element from the node first', 1, true, 'utils', 'core', 'UI');

UPDATE config_form_fields SET dv_querytext='SELECT id, id AS idval FROM cat_feature_element WHERE id IS NOT NULL' WHERE formname='cat_element' AND formtype='form_feature' AND columnname='elementtype_id' AND tabname='tab_none';

UPDATE sys_table SET alias='Element feature catalog' WHERE id='v_edit_cat_feature_element';

INSERT INTO sys_fprocess (fid, fprocess_name) VALUES (-1, 'There is');
INSERT INTO sys_fprocess (fid, fprocess_name) VALUES (-2, 'There are');

DELETE FROM sys_table WHERE id = 'v_edit_raingage';

UPDATE sys_table SET id = REPLACE(id, 'v_edit_', 've_') WHERE id ILIKE '%v_edit_%';

UPDATE sys_style SET layername = REPLACE(layername, 'v_edit_', 've_') WHERE layername ILIKE '%v_edit_%';

UPDATE cat_feature SET parent_layer = REPLACE(parent_layer, 'v_edit_', 've_') WHERE parent_layer ILIKE '%v_edit_%';

UPDATE config_table SET id= REPLACE(id, 'v_edit_', 've_') WHERE id ILIKE '%v_edit_%';

UPDATE config_info_layer SET layer_id = REPLACE(layer_id, 'v_edit_', 've_') WHERE layer_id ILIKE '%v_edit_%';

UPDATE config_form_tabs SET formname = REPLACE(formname, 'v_edit_', 've_') WHERE formname ILIKE '%v_edit_%';

ALTER TABLE config_form_fields DISABLE TRIGGER gw_trg_config_control;
UPDATE config_form_fields SET dv_querytext = REPLACE(dv_querytext, 'v_edit_', 've_') WHERE dv_querytext ILIKE '%v_edit_%';
ALTER TABLE config_form_fields ENABLE TRIGGER gw_trg_config_control;

UPDATE config_param_system SET value = REPLACE(value, 'v_edit_', 've_') WHERE value ILIKE '%v_edit_%';

UPDATE sys_param_user SET dv_querytext = REPLACE(dv_querytext, 'v_edit_', 've_') WHERE dv_querytext ILIKE '%v_edit_%';

UPDATE config_function SET layermanager = REPLACE(layermanager::text, 'v_edit_', 've_')::json WHERE layermanager::text ILIKE '%v_edit_%';

UPDATE config_form_list SET query_text = REPLACE(query_text, 'v_edit_', 've_') WHERE query_text ILIKE '%v_edit_%';
UPDATE config_form_list SET listname = REPLACE(listname, 'v_edit_', 've_') WHERE listname ILIKE '%v_edit_%';

UPDATE config_report SET query_text = REPLACE(query_text, 'v_edit_', 've_') WHERE query_text ILIKE '%v_edit_%';

DELETE FROM config_form_fields WHERE formname='ve_genelem_estep' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_ecover' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_egate' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_eiot_sensor' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';
DELETE FROM config_form_fields WHERE formname='ve_genelem_eprotector' AND formtype='form_feature' AND columnname='epa_type' AND tabname='tab_data';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4322, '%v_count_feature% link(s) have been downgraded', NULL, 0, true, 'utils', 'core', 'AUDIT');
INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4324, '%v_count_feature% element(s) have been downgraded', NULL, 0, true, 'utils', 'core', 'AUDIT');

UPDATE config_toolbox SET inputparams='[
  {
    "label": "Direct insert into node table:",
    "value": null,
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "insertIntoNode",
    "widgettype": "check",
    "layoutorder": 1
  },
  {
    "label": "Node tolerance:",
    "value": null,
    "datatype": "float",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "nodeTolerance",
    "widgettype": "spinbox",
    "layoutorder": 2
  },
  {
    "label": "Exploitation ids:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "select expl_id as id, name as idval from exploitation where active is not False order by name",
    "layoutorder": 3
  },
  {
    "label": "State:",
    "value": null,
    "datatype": "integer",
    "isparent": "True",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "stateType",
    "widgettype": "combo",
    "dvQueryText": "select value_state_type.id as id, concat(''state: '',value_state.name,'' state type: '', value_state_type.name) as idval from value_state_type join value_state on value_state.id = state where value_state_type.id is not null order by  CASE WHEN state=1 THEN 1 WHEN state=2 THEN 2 WHEN state=0 THEN 3 END, id",
    "layoutorder": 4
  },
  {
    "label": "Workcat:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "workcatId",
    "widgettype": "combo",
    "dvQueryText": "select id as id, id as idval from cat_work where id is not null",
    "isNullValue": true,
    "layoutorder": 5
  },
  {
    "label": "Builtdate:",
    "value": null,
    "datatype": "date",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "builtdate",
    "widgettype": "datetime",
    "layoutorder": 6
  },
  {
    "label": "Node type:",
    "isparent": true,
    "value": null,
    "datatype": "text",
    "iseditable": true,
    "layoutname": "grl_option_parameters",
    "selectedId": "$userNodetype",
    "widgetname": "nodeType",
    "widgettype": "combo",
    "dvQueryText": "select distinct cfn.id as id, cfn.id as idval from cat_feature_node cfn JOIN cat_node cn ON cn.node_type=cfn.id where cfn.id is not null",
    "layoutorder": 7
  },
  {
    "label": "Node catalog:",
    "dvparentid": "node_type",
    "dvquerytext_filterc": " AND value_state_type.state",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": "$userNodecat",
    "widgetname": "nodeCat",
    "widgettype": "combo",
    "dvQueryText": "select distinct id as id, id as idval from cat_node order by id",
    "parentname": "nodeType",
    "filterquery": "select distinct id as id, id as idval from cat_node where node_type = ''{parent_value}'' order by id",
    "layoutorder": 8
  }
]'::json WHERE id=2118;

INSERT INTO config_param_system ("parameter", value, descript, "label", dv_querytext, dv_filterbyfield, isenabled, layoutorder, project_type, dv_isparent, isautoupdate, "datatype", widgettype, ismandatory, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, widgetcontrols, placeholder, standardvalue, layoutname)
VALUES('mapzones_config', '{"version" : "1"}', 'Mapzones system config. version - Mapzones version;', 'Mapzones system config', NULL, NULL, true, 17, 'utils', false, false, 'json', 'linetext', true, true, NULL, NULL, NULL, NULL, NULL, NULL, 'lyt_admin_other')
ON CONFLICT (parameter) DO NOTHING;

UPDATE config_toolbox SET functionparams = REPLACE(functionparams::text, 'v_edit_', 've_')::json WHERE functionparams::text ILIKE '%v_edit_%';
UPDATE config_toolbox SET inputparams = REPLACE(inputparams::text, 'v_edit_', 've_')::json WHERE inputparams::text ILIKE '%v_edit_%';

UPDATE sys_function SET function_name = 'gw_fct_checktopologypsector' where function_name = 'gw_fct_setplan';

UPDATE config_form_fields SET widgetcontrols = jsonb_set(COALESCE(widgetcontrols::jsonb, '{}'::jsonb), '{labelSize}', '58')
WHERE formtype = 'psector' and columnname IN ('name', 'ext_code', 'status','workcat_id') and tabname='tab_general';
DELETE FROM config_form_fields WHERE formname='generic' AND formtype='psector' AND columnname='spacer_1' AND tabname='tab_general';

UPDATE config_form_fields SET label='Show obsolete:' WHERE formname='generic' AND formtype='psector' AND columnname='chk_enable_all' AND tabname='tab_general';
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'active', 'lyt_general_7', 2, 'boolean', 'check', 'Active:', 'Active:', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{
  "setMultiline": true
}'::json, NULL, NULL, false, 2);
UPDATE config_form_fields SET layoutorder=3, web_layoutorder=3 WHERE formname='generic' AND formtype='psector' AND columnname='creation_date' AND tabname='tab_general';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) VALUES(4328, 'It is not allowed to downgrade planified links (state=2)', 'Review your data.', 2, true, 'utils', 'core', 'AUDIT');

UPDATE plan_psector SET workcat_id_plan = workcat_id WHERE workcat_id IS NOT NULL AND status IN (1, 2, 3);

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4330, 'Input parameter: "%parameter%" is required', 'You need to pass correct parameters.', 2, true, 'utils', 'core', 'UI');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4332, 'Unknown %parameter%', 'You need to pass correct parameters.', 2, true, 'utils', 'core', 'UI');

UPDATE sys_function SET function_name = 'gw_fct_set_toggle_current' WHERE function_name = 'gw_fct_set_current';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4334, 'You can not desactivate the %mapzone_name%, because have objects linked to it', 'First you need to change the objects to another mapzone. EX: Undefined', 2, true, 'utils', 'core', 'UI');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3496, 'gw_fct_check_linked_mapzones', 'utils', 'function', 'json', 'json', 'Check if there are objects linked to the mapzone', NULL, NULL, 'core', NULL);

UPDATE config_form_fields SET layoutname='lyt_general_1', layoutorder=1, web_layoutorder=1, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='psector_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_1', layoutorder=2, web_layoutorder=2, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='ext_code' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_7', layoutorder=4, web_layoutorder=2, widgetcontrols='{"setMultiline":false}'::json WHERE formname='generic' AND formtype='psector' AND columnname='parent_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_4', layoutorder=0, web_layoutorder=0, widgetcontrols='{"setMultiline": false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='status' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_4', layoutorder=1, web_layoutorder=1, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='priority' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_3', layoutorder=0, dv_isnullvalue=true, web_layoutorder=0, widgetcontrols='{"setMultiline": false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='workcat_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_3', layoutorder=2, web_layoutorder=2, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='expl_id' AND tabname='tab_general';
UPDATE config_form_fields SET layoutname='lyt_general_4', layoutorder=2, web_layoutorder=2, widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='psector_type' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline": false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname='name' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline": true}'::json WHERE formname='generic' AND formtype='psector' AND columnname='chk_enable_all' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline": true}'::json WHERE formname='generic' AND formtype='psector' AND columnname='active' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false}'::json WHERE formname='generic' AND formtype='psector' AND columnname='creation_date' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json, label='Observation:' WHERE formname='generic' AND formtype='psector' AND columnname='observ' AND tabname='tab_general';
UPDATE config_form_fields SET widgetcontrols='{"setMultiline":false, "labelPosition":"top"}'::json WHERE formname='generic' AND formtype='psector' AND columnname IN ('descript', 'text1', 'text2', 'scale', 'rotation', 'atlas_id') AND tabname='tab_general';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('generic', 'psector', 'tab_general', 'workcat_id_plan', 'lyt_general_3', 1, 'string', 'combo', 'Worcat id plan:', 'Worcat id plan', NULL, false, false, false, false, false, 'SELECT id, id as idval  FROM cat_work', NULL, false, NULL, NULL, NULL, '{"setMultiline":false, "labelPosition":"top"}'::json, NULL, NULL, false, 1);

UPDATE sys_param_user SET formname = 'dynamic'  WHERE id = 'edit_state_vdefault';

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4336, 'It''s not possible to set this psector to active because it has topological inconsistencies.', 'Fix topological errors first.', 2, true, 'utils', 'core', 'UI');

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3498, 'gw_fct_cm_setarcdivide', 'utils', 'function', 'json', 'json', 'Divides an existing arc at a specified node location. Finds the nearest arc within tolerance, splits it into two new arcs at the node position, and deletes the original arc while maintaining all attributes and topological connections.', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3500, 'gw_trg_cm_topocontrol_arc', 'utils', 'trigger', 'trigger', 'trigger', 'Trigger function that automatically connects campaign arc endpoints to the nearest nodes. Validates topology rules, snaps geometry to node coordinates, and sets proper node_1/node_2 connections while prioritizing division nodes.', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3502, 'gw_fct_cm_admin_manage_role', 'utils', 'function', 'json', 'json', 'Synchronizes users with CM roles to the cat_user table. Automatically finds users that have role_cm permissions but are not yet in the cat_user catalog, and inserts them with proper team assignments.', NULL, NULL, 'core', NULL);
INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3504, 'gw_fct_cm_check_catalogs', 'utils', 'function', 'json', 'json', 'Validates catalog combinations for campaign and lot features. Checks if arc and node feature combinations exist in cat_arc and cat_node tables, identifies missing catalog entries, and reports which combinations will need new catalog creation when added to production.', NULL, NULL, 'core', NULL);


-- Delete element from element_manager
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "delete_manager_item",
  "parameters": {
    "sourcetable": "v_ui_element",
    "targetwidget": "tab_none_tbl_element",
    "field_object_id": "element_id"
  }
}'::json
	WHERE formname='element_manager' AND formtype='form_element' AND columnname='delete' AND tabname='tab_none';


DELETE FROM sys_table WHERE id ilike 'v_state_%';
DELETE FROM sys_table WHERE id ilike 'vu_element_x_%';

DELETE FROM sys_table WHERE id in ('v_expl_gully', 'v_man_gully', 'vi_pollutants');
DELETE FROM sys_table WHERE id in ('v_inp_pjointpattern', 'v_minsector_graph');

DELETE FROM sys_table WHERE id ='v_audit_check_project';

DELETE FROM sys_table WHERE id = 'v_polygon';

DELETE FROM sys_table WHERE id in ('vcv_demands', 'vcv_patterns', 'vcv_times', 'v_rtc_period_hydrometer');

UPDATE sys_fprocess SET query_text='with q_arc as (
WITH v_state_arc AS (
SELECT arc_id FROM selector_state, arc
WHERE arc.state = selector_state.state_id AND selector_state.cur_user = CURRENT_USER
)
select * from arc JOIN v_state_arc USING (arc_id))
SELECT b.* FROM (
WITH v_state_node AS (SELECT node_id FROM selector_state, node
WHERE node.state = selector_state.state_id AND selector_state.cur_user = CURRENT_USER)
SELECT n1.node_id, n1.nodecat_id, n1.sector_id, n1.expl_id, n1.state, n1.the_geom  FROM q_arc, 
(select * from node JOIN v_state_node USING (node_id)) n1 
JOIN (SELECT node_1 node_id from q_arc UNION 
select node_2 FROM q_arc) b USING (node_id) 
WHERE st_dwithin(q_arc.the_geom, n1.the_geom,0.01) AND n1.node_id NOT IN 
(node_1, node_2)
)b, selector_expl e 
where e.expl_id= b.expl_id AND cur_user=current_user' WHERE fid=432; -- t-candidates


UPDATE sys_fprocess SET query_text='SELECT arc_id, arccat_id, state1, arc_id_aux, node_1, node_2, expl_id, the_geom FROM (
	WITH v_state_arc AS (
         SELECT arc_id FROM selector_state, arc
          WHERE arc.state = selector_state.state_id AND selector_state.cur_user = CURRENT_USER
          ), q_arc AS (SELECT * FROM arc JOIN v_state_arc using (arc_id)) 
 SELECT DISTINCT t1.arc_id, t1.arccat_id, t1.state as state1, t2.arc_id as arc_id_aux,
 t2.state as state2, t1.node_1, t1.node_2, t1.expl_id, t1.the_geom 
 FROM q_arc AS t1 JOIN q_arc AS t2 USING(the_geom) JOIN arc v ON t1.arc_id = v.arc_id
 WHERE t1.arc_id != t2.arc_id ORDER BY t1.arc_id )a
 where a.state1 > 0 AND a.state2 > 0' WHERE fid=479; -- arcs dupl

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3506, 'gw_trg_insert_psector_x_feature', 'utils', 'trigger', NULL, NULL, 'Insert psector_x_feature when a feature is inserted with state=2', NULL, NULL, 'core', NULL);

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'linkcat_id', 'lyt_top_1', 2, 'string', 'typeahead', 'Linkcat ID:', 'linkcat_id - To be selected from the catalog of arcs. It is independent of the type of arch', NULL, true, false, true, false, NULL, 'SELECT id, id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, NULL, 'link_type', ' AND cat_link.link_type IS NULL OR cat_link.link_type', NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "cat_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 3);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_link_link', 'form_feature', 'tab_data', 'link_type', 'lyt_top_1', 1, 'string', 'combo', 'Link Type:', 'Type of link. It is auto-populated based on the linkcat_id', NULL, true, true, false, false, NULL, 'SELECT id, id as idval FROM cat_feature_link WHERE id IS NOT NULL', true, false, NULL, NULL, NULL, '{"setMultiline": false, "labelPosition": "top", "valueRelation": {"layer": "ve_cat_feature_link", "activated": true, "keyColumn": "id", "nullValue": false, "valueColumn": "id", "filterExpression": null}}'::json, NULL, NULL, false, 2);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"plan_psector_x_arc", "column":"active", "dataType":"boolean"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"plan_psector_x_node", "column":"active", "dataType":"boolean"}}$$);

UPDATE sys_table SET id = 've_connec_hydro_data' WHERE id = 've_rtc_hydro_data_x_connec';
UPDATE sys_table SET id = 'v_hydrometer_x_connec' WHERE id = 'v_rtc_hydrometer_x_connec';


UPDATE sys_param_user SET isenabled = false where id = 'plan_psector_current';

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"plan_psector_x_node", "column":"active", "dataType":"boolean"}}$$);

UPDATE sys_table SET id = 'v_ui_style' WHERE id = 'v_ui_sys_style';

DELETE FROM sys_table WHERE id in ('vcp_pipes', 'vcv_dma', 'vcv_dma_log', 'vcv_emitters_log', 'vcv_junction', 'vcv_emitters');

INSERT INTO sys_param_user(id, formname, descript, sys_role,
project_type, datatype, ismandatory, vdefault, source)
VALUES ('plan_psector_disable_checktopology_trigger', 'dynamic', 'Variable to disable the control for checktopology on trigger plan_psector', 'role_edit',
'utils', 'boolean', true, 'false', 'core') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4340, 'You have at least 1 connec in different selected psectors which is connected to different arcs',null, 1, true, 'utils', 'core', 'UI');

UPDATE plan_typevalue SET idval='PLANIFIED' WHERE typevalue='psector_type' AND id='1';

UPDATE config_form_fields SET layoutorder=4 WHERE formname='new_dma' AND formtype='form_catalog' AND columnname='expl_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=5 WHERE formname='new_dma' AND formtype='form_catalog' AND columnname='macrodma_id' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=6 WHERE formname='new_dma' AND formtype='form_catalog' AND columnname='descript' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=7 WHERE formname='new_dma' AND formtype='form_catalog' AND columnname='link' AND tabname='tab_none';
UPDATE config_form_fields SET layoutorder=8 WHERE formname='new_dma' AND formtype='form_catalog' AND columnname='stylesheet' AND tabname='tab_none';

-- Create menu element from element_manager
UPDATE config_form_fields
	SET widgetfunction='{
  "functionName": "manage_element_menu",
  "parameters": {
    "sourcetable": "v_ui_element",
    "targetwidget": "tbl_element",
    "field_object_id": "id",
    "linked_feature": false  }
}'::json
	WHERE formname='element_manager' AND formtype='form_element' AND columnname='create' AND tabname='tab_none';

-- Make element menu work in info
DO $$
DECLARE
  v_widgetfucntion jsonb;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='new_element' AND tabname='tab_elements'
  LOOP
    v_widgetfucntion := rec.widgetfunction;
    v_widgetfucntion := jsonb_set(v_widgetfucntion, '{parameters, linked_feature}', 'true');
    UPDATE config_form_fields
      SET widgetfunction=v_widgetfucntion
      WHERE formname=rec.formname AND formtype=rec.formtype AND columnname=rec.columnname AND tabname=rec.tabname;
  END LOOP;
END $$;

-- Update table from element_manager
UPDATE config_form_fields
	SET widgetfunction='{"functionName":"open_selected_manager_item", "parameters":{"columnfind":"element_id", "elem_manager": true, "sourcetable": "v_ui_element"}}'::json
	WHERE formname='element_manager' AND formtype='form_element' AND columnname='tbl_element' AND tabname='tab_none';

-- Update element views names in sys_table
UPDATE sys_table SET id = 've_man_frelem' WHERE id = 've_frelem';
UPDATE sys_table SET id = 've_man_genelem' WHERE id = 've_genelem';
INSERT INTO sys_table (id, sys_role, descript, project_template, context, alias, orderby, source) VALUES
('ve_element', 'role_edit', 'Shows information about elements', '{"template": [1], "visibility": true, "levels_to_read": 2}', '{"levels": ["INVENTORY", "NETWORK", "ELEMENT"]}', 'Elements', 5, 'core');

-- Open correctly the forms
DELETE FROM config_info_layer WHERE layer_id IN ('ve_frelem', 've_genelem');
INSERT INTO config_info_layer (layer_id,is_parent,is_editable,formtemplate,headertext,orderby)
	VALUES ('ve_element',true,true,'info_feature','Element',4);

INSERT INTO config_info_layer (layer_id,is_parent,is_editable,formtemplate,headertext,orderby)
	VALUES ('ve_man_frelem',true,true,'info_feature','FR. Element',4);

-- Make element menu work in info
DO $$
DECLARE
  v_widgetfucntion jsonb;
  v_table text;
  rec record;
BEGIN
  FOR rec IN SELECT * FROM config_form_fields WHERE formtype='form_feature' AND columnname='tbl_elements' AND tabname='tab_elements'
  LOOP
    v_widgetfucntion := rec.widgetfunction;
    IF rec.formname LIKE '%link%' THEN
      v_table := 'v_ui_element_x_link';
    ELSE
      v_table := 'v_ui_element_x_' || rec.formname;
    END IF;
    v_widgetfucntion := jsonb_set(v_widgetfucntion, '{parameters, sourcetable}', to_jsonb(v_table));
    UPDATE config_form_fields
      SET widgetfunction=v_widgetfucntion
      WHERE formname=rec.formname AND formtype=rec.formtype AND columnname=rec.columnname AND tabname=rec.tabname;
  END LOOP;
END $$;

UPDATE config_toolbox SET inputparams = replace(inputparams::text, 'v_edit_', 've_')::json WHERE inputparams::text ilike '%v_edit_%';

DO $$
DECLARE
  rec record;
BEGIN
  FOR rec IN (SELECT child_layer FROM cat_feature WHERE feature_class = 'VALVE')
  LOOP
    INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder,
    "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter,
    dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc,
    stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
    VALUES(rec.child_layer, 'form_feature', 'tab_data', 'flowsetting', 'lyt_data_2', (SELECT max(layoutorder) + 1 AS layoutorder FROM config_form_fields WHERE formname = rec.child_layer AND tabname = 'tab_data' AND layoutname = 'lyt_data_2'),
    'numeric', 'text', 'Flow Setting:', 'Flow Setting:', NULL, false, false, true, false, NULL,
    NULL, NULL, NULL, NULL, NULL,
    NULL, NULL, NULL, NULL, true, NULL)
    ON CONFLICT (formname, formtype, tabname, columnname) DO UPDATE SET
    layoutorder = EXCLUDED.layoutorder,
    datatype = EXCLUDED.datatype,
    widgettype = EXCLUDED.widgettype,
    label = EXCLUDED.label,
    dv_querytext = EXCLUDED.dv_querytext,
    dv_orderby_id = EXCLUDED.dv_orderby_id,
    dv_isnullvalue = EXCLUDED.dv_isnullvalue,
    dv_parent_id = EXCLUDED.dv_parent_id,
    dv_querytext_filterc = EXCLUDED.dv_querytext_filterc,
    hidden = EXCLUDED.hidden;
  END LOOP;
END $$;

INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'psector_id', 0, true, NULL, 'psector_id', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'ext_code', 1, true, NULL, 'ext_code', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'name', 2, true, NULL, 'name', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'descript', 3, true, NULL, 'descript', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'priority', 4, true, NULL, 'priority', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'psector_type', 5, true, NULL, 'psector_type', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'status', 6, true, NULL, 'status', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'active', 7, true, NULL, 'active', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'archived', 8, true, NULL, 'archived', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'expl_id', 9, true, NULL, 'expl_id', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'text1', 10, true, NULL, 'text1', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'observ', 11, true, NULL, 'observ', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'text2', 11, true, NULL, 'text2', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'vat', 13, true, NULL, 'vat', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'other', 14, true, NULL, 'other', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'workcat_id', 15, true, NULL, 'workcat_id', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'workcat_id_plan', 16, true, NULL, 'workcat_id_plan', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'parent_id', 17, true, NULL, 'parent_id', NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam) VALUES('plan toolbar', 'utils', 'v_ui_plan_psector', 'creation_date', 18, true, NULL, 'creation_date', NULL, NULL);

INSERT INTO sys_param_user (id, formname, descript, sys_role, idval, "label", dv_querytext, dv_parent_id, isenabled, layoutorder, project_type, isparent, dv_querytext_filterc, feature_field_id, feature_dv_parent_value, isautoupdate, "datatype", widgettype, ismandatory, widgetcontrols, vdefault, layoutname, iseditable, dv_orderby_id, dv_isnullvalue, stylesheet, placeholder, "source")
VALUES('edit_linkcat_vdefault', 'config', 'Default value of link catalog', 'role_edit', NULL, 'Link catalog for automatic inserts:', 'SELECT cat_link.id AS id, cat_link.id as idval FROM cat_link WHERE id IS NOT NULL AND active IS TRUE ', NULL, true, 1, 'utils', false, NULL, 'linkcat_id', NULL, false, 'string', 'combo', false, NULL, NULL, 'lyt_link', true, NULL, NULL, NULL, NULL, 'core');

UPDATE config_form_fields SET placeholder='Optional value for max distance: 100', ismandatory=false WHERE formname='generic' AND columnname='max_distance' AND tabname='tab_none';
UPDATE config_form_fields SET placeholder='Optional value for max pipe diameter: 150', ismandatory=false WHERE formname='generic' AND columnname='pipe_diameter' AND tabname='tab_none';

CREATE TRIGGER gw_trg_edit_frelem_x_node BEFORE INSERT ON element_x_node
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_frelem_x_node();

CREATE TRIGGER gw_trg_edit_municipality INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ext_municipality
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_municipality();

CREATE TRIGGER gw_trg_ui_rpt_cat_result INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_rpt_cat_result
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_rpt_cat_result();

-- PSECTOR
CREATE TRIGGER gw_trg_edit_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON ve_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_edit_psector('plan');

CREATE TRIGGER gw_trg_ui_plan_psector INSTEAD OF INSERT OR DELETE OR UPDATE ON v_ui_plan_psector
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_plan_psector();

CREATE TRIGGER gw_trg_plan_psector_after_node AFTER INSERT ON node
FOR EACH ROW
WHEN (NEW.state = 2)
EXECUTE FUNCTION gw_trg_insert_psector_x_feature('node');

CREATE TRIGGER gw_trg_plan_psector_after_arc AFTER INSERT ON arc
FOR EACH ROW
WHEN (NEW.state = 2)
EXECUTE FUNCTION gw_trg_insert_psector_x_feature('arc');

CREATE TRIGGER gw_trg_plan_psector_after_connec AFTER INSERT ON connec
FOR EACH ROW
WHEN (NEW.state = 2)
EXECUTE FUNCTION gw_trg_insert_psector_x_feature('connec');

drop trigger if exists gw_trg_psector_selector on plan_psector;

DROP FUNCTION IF EXISTS gw_trg_psector_selector();
DELETE FROM sys_function WHERE function_name = 'gw_trg_psector_selector';
