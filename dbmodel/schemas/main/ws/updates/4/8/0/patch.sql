/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_ui_doc;
DROP VIEW IF EXISTS v_ui_doc_x_psector;
DROP VIEW IF EXISTS v_ui_doc_x_visit;
DROP VIEW IF EXISTS v_ui_doc_x_workcat;
DROP VIEW IF EXISTS v_ui_doc_x_node;
DROP VIEW IF EXISTS v_ui_doc_x_arc;
DROP VIEW IF EXISTS v_ui_doc_x_connec;
DROP VIEW IF EXISTS v_ui_doc_x_link;
DROP VIEW IF EXISTS v_ui_doc_x_element;
DROP VIEW IF EXISTS v_ui_om_visit_x_doc;
ALTER TABLE doc ADD COLUMN code varchar(30);
UPDATE doc SET code = id;
-- ALTER SEQUENCE doc_seq RESTART WITH 1;
SELECT setval('doc_seq', (SELECT max(id::bigint)
FROM doc
WHERE id::text ~ '^[0-9]+(\.[0-9]+)?$'));

UPDATE doc SET id = nextval('doc_seq'::regclass); 



ALTER TABLE doc_x_link DROP CONSTRAINT doc_x_link_doc_id_fkey;
ALTER TABLE doc_x_psector DROP CONSTRAINT doc_x_psector_doc_id_fkey;
ALTER TABLE doc_x_workcat DROP CONSTRAINT doc_x_workcat_doc_id_fkey;
ALTER TABLE doc_x_visit DROP CONSTRAINT doc_x_visit_doc_id_fkey;
ALTER TABLE doc_x_node DROP CONSTRAINT doc_x_node_doc_id_fkey;
ALTER TABLE doc_x_arc DROP CONSTRAINT doc_x_arc_doc_id_fkey;
ALTER TABLE doc_x_connec DROP CONSTRAINT doc_x_connec_doc_id_fkey;
ALTER TABLE doc_x_element DROP CONSTRAINT doc_x_element_fkey_doc_id;



ALTER TABLE doc_x_link ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_psector ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_workcat ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_visit ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_node ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_arc ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_connec ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_element ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc ALTER COLUMN id TYPE int4 USING id::int4;



SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"head", "dataType":"float8", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"demand", "dataType":"numeric(12, 6)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"demand_pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_valve", "column":"emitter_coeff", "dataType":"float8", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"head", "dataType":"float8", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"demand", "dataType":"numeric(12, 6)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"demand_pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_shortpipe", "column":"emitter_coeff", "dataType":"float8", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"head", "dataType":"float8", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"demand", "dataType":"numeric(12, 6)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"demand_pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_valve", "column":"emitter_coeff", "dataType":"float8", "isUtils":"False"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"head", "dataType":"float8", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"demand", "dataType":"numeric(12, 6)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"demand_pattern_id", "dataType":"varchar(16)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"inp_dscenario_shortpipe", "column":"emitter_coeff", "dataType":"float8", "isUtils":"False"}}$$);

CREATE OR REPLACE VIEW ve_connec
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
        ), sector_table AS (
         SELECT sector.sector_id,
            sector.macrosector_id,
            sector.stylesheet,
            t.id::character varying(16) AS sector_type
           FROM sector
             LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
        ), dma_table AS (
         SELECT dma.dma_id,
            dma.macrodma_id,
            dma.stylesheet,
            t.id::character varying(16) AS dma_type
           FROM dma
             LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
        ), presszone_table AS (
         SELECT presszone.presszone_id,
            presszone.head AS presszone_head,
            presszone.stylesheet,
            t.id::character varying(16) AS presszone_type
           FROM presszone
             LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
        ), dqa_table AS (
         SELECT dqa.dqa_id,
            dqa.stylesheet,
            t.id::character varying(16) AS dqa_type,
            dqa.macrodqa_id
           FROM dqa
             LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
        ), supplyzone_table AS (
         SELECT supplyzone.supplyzone_id,
            supplyzone.stylesheet,
            t.id::character varying(16) AS supplyzone_type
           FROM supplyzone
             LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
        ), omzone_table AS (
         SELECT omzone.omzone_id,
            t.id::character varying(16) AS omzone_type,
            omzone.macroomzone_id
           FROM omzone
             LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
        ), inp_network_mode AS (
         SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
        )
 SELECT c.connec_id,
    c.code,
    c.sys_code,
    c.top_elev,
    c.depth,
    cat_connec.connec_type,
    cat_feature.feature_class AS sys_type,
    c.conneccat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    cat_connec.dint AS cat_dint,
    c.customer_code,
    c.connec_length,
    c.epa_type,
    c.state,
    c.state_type,
    COALESCE(pp.arc_id, c.arc_id) AS arc_id,
    c.expl_id,
    exploitation.macroexpl_id,
    c.muni_id,
    c.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    supplyzone_table.supplyzone_id,
    supplyzone_table.supplyzone_type,
    presszone_table.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    dma_table.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type::character varying AS dma_type,
    dqa_table.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    omzone_table.omzone_id,
    omzone_table.omzone_type,
    c.crmzone_id,
    crmzone.macrocrmzone_id,
    crmzone.name AS crmzone_name,
    c.minsector_id,
    c.soilcat_id,
    c.function_type,
    c.category_type,
    c.location_type,
    c.fluid_type,
    c.n_hydrometer,
    c.n_inhabitants,
    c.staticpressure,
    c.descript,
    c.annotation,
    c.observ,
    c.comment,
    concat(cat_feature.link_path, c.link) AS link,
    c.num_value,
    c.district_id,
    c.postcode,
    c.streetaxis_id,
    c.postnumber,
    c.postcomplement,
    c.streetaxis2_id,
    c.postnumber2,
    c.postcomplement2,
    mu.region_id,
    mu.province_id,
    c.block_code,
    c.plot_code,
    c.workcat_id,
    c.workcat_id_end,
    c.workcat_id_plan,
    c.builtdate,
    c.enddate,
    c.ownercat_id,
    COALESCE(pp.exit_id, c.pjoint_id) AS pjoint_id,
    COALESCE(pp.exit_type, c.pjoint_type) AS pjoint_type,
    c.om_state,
    c.conserv_state,
    c.accessibility,
    c.access_type,
    c.placement_type,
    c.priority,
    COALESCE(c.brand_id, cat_connec.brand_id) AS brand_id,
    COALESCE(c.model_id, cat_connec.model_id) AS model_id,
    c.serial_number,
    c.asset_id,
    c.adate,
    c.adescript,
    c.verified,
    c.datasource,
    cat_connec.label,
    c.label_x,
    c.label_y,
    c.label_rotation,
    c.rotation,
    c.label_quadrant,
    cat_connec.svg,
    c.inventory,
    c.publish,
    vst.is_operative,
        CASE
            WHEN c.sector_id > 0 AND vst.is_operative = true AND c.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN c.epa_type::character varying::text
            ELSE NULL::text
        END AS inp_type,
    connec_add.demand_base,
    connec_add.demand_max,
    connec_add.demand_min,
    connec_add.demand_avg,
    connec_add.press_max,
    connec_add.press_min,
    connec_add.press_avg,
    connec_add.quality_max,
    connec_add.quality_min,
    connec_add.quality_avg,
    connec_add.flow_max,
    connec_add.flow_min,
    connec_add.flow_avg,
    connec_add.vel_max,
    connec_add.vel_min,
    connec_add.vel_avg,
    connec_add.result_id,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
    dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
    supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
    c.lock_level,
    c.expl_visibility,
    ( SELECT st_x(c.the_geom) AS st_x) AS xcoord,
    ( SELECT st_y(c.the_geom) AS st_y) AS ycoord,
    ( SELECT st_y(st_transform(c.the_geom, 4326)) AS st_y) AS lat,
    ( SELECT st_x(st_transform(c.the_geom, 4326)) AS st_x) AS long,
    date_trunc('second'::text, c.created_at) AS created_at,
    c.created_by,
    date_trunc('second'::text, c.updated_at) AS updated_at,
    c.updated_by,
    c.the_geom,
    COALESCE(pp.state, c.state) AS p_state,
    c.uuid,
    c.uncertain,
    c.xyz_date
   FROM connec c
     LEFT JOIN LATERAL ( SELECT pp_1.state,
            pp_1.arc_id,
            l.exit_id,
            l.exit_type            
           FROM plan_psector_x_connec pp_1
           JOIN link l ON l.link_id = pp_1.link_id
          WHERE pp_1.connec_id = c.connec_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC, pp_1.state DESC
         LIMIT 1) pp ON true
     JOIN cat_connec ON cat_connec.id::text = c.conneccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connec_type::text
     JOIN exploitation ON c.expl_id = exploitation.expl_id
     JOIN ext_municipality mu ON c.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = c.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = c.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = c.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = c.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = c.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = c.omzone_id
     LEFT JOIN crmzone ON crmzone.id::text = c.crmzone_id::text
     LEFT JOIN connec_add ON connec_add.connec_id = c.connec_id
     LEFT JOIN value_state_type vst ON vst.id = c.state_type
     LEFT JOIN inp_network_mode ON true
  WHERE (EXISTS ( SELECT 1
           FROM selector_state ss
          WHERE ss.state_id = COALESCE(pp.state, c.state) AND ss.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_sector ssec
          WHERE ssec.sector_id = c.sector_id AND ssec.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_municipality sm
          WHERE sm.muni_id = c.muni_id AND sm.cur_user = CURRENT_USER)) AND (EXISTS ( SELECT 1
           FROM selector_expl se
          WHERE (se.expl_id = ANY (array_append(c.expl_visibility::integer[], c.expl_id))) AND se.cur_user = CURRENT_USER));

DROP VIEW IF EXISTS v_rpt_compare_node;
CREATE OR REPLACE VIEW v_rpt_comp_node_stats
AS SELECT r.node_id,
    r.result_id,
    r.node_type,
    r.sector_id,
    r.nodecat_id,
    r.top_elev AS elevation,
    r.demand_max,
    r.demand_min,
    r.demand_avg,
    r.head_max,
    r.head_min,
    r.head_avg,
    r.press_max,
    r.press_min,
    r.press_avg,
    r.quality_max,
    r.quality_min,
    r.quality_avg,
    r.the_geom
   FROM rpt_node_stats r,
    selector_rpt_compare s
     JOIN selector_rpt_compare USING (result_id);

CREATE OR REPLACE VIEW v_ui_doc
AS SELECT id,
    name,
    observ,
    doc_type,
    path,
    date,
    user_name,
    tstamp
   FROM doc;

CREATE OR REPLACE VIEW v_ui_doc_x_psector
AS SELECT doc_x_psector.doc_id,
    plan_psector.name AS psector_name,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_psector
     JOIN doc ON doc.id::text = doc_x_psector.doc_id::text
     JOIN plan_psector ON plan_psector.psector_id::text = doc_x_psector.psector_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_visit
AS SELECT doc_x_visit.doc_id,
    doc_x_visit.visit_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_visit
     JOIN doc ON doc.id::text = doc_x_visit.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_workcat
AS SELECT doc_x_workcat.doc_id,
    doc_x_workcat.workcat_id,
    doc.name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name
   FROM doc_x_workcat
     JOIN doc ON doc.id::text = doc_x_workcat.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_node
AS SELECT doc_x_node.doc_id,
    doc_x_node.node_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_node.node_uuid
   FROM doc_x_node
     JOIN doc ON doc.id::text = doc_x_node.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_arc
AS SELECT doc_x_arc.doc_id,
    doc_x_arc.arc_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_arc.arc_uuid
   FROM doc_x_arc
     JOIN doc ON doc.id::text = doc_x_arc.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_connec
AS SELECT doc_x_connec.doc_id,
    doc_x_connec.connec_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_connec.connec_uuid
   FROM doc_x_connec
     JOIN doc ON doc.id::text = doc_x_connec.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_link
AS SELECT doc_x_link.doc_id,
    doc_x_link.link_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_link.link_uuid
   FROM doc_x_link
     JOIN doc ON doc.id::text = doc_x_link.doc_id::text;


CREATE OR REPLACE VIEW v_ui_doc_x_element
AS SELECT doc_x_element.doc_id,
    doc_x_element.element_id,
    doc.name AS doc_name,
    doc.doc_type,
    doc.path,
    doc.observ,
    doc.date,
    doc.user_name,
    doc_x_element.element_uuid
   FROM doc_x_element
     JOIN doc ON doc.id::text = doc_x_element.doc_id::text;


CREATE OR REPLACE VIEW v_ui_om_visit_x_doc
AS SELECT doc_id,
    visit_id
   FROM doc_x_visit;


DROP VIEW IF EXISTS ve_inp_valve;
CREATE OR REPLACE VIEW ve_inp_valve
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_valve.valve_type,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.broken IS FALSE AND v.to_arc IS NOT NULL THEN 'ACTIVE'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    n.cat_dint,
    inp_valve.custom_dint,
    inp_valve.add_settings,
    inp_valve.init_quality,
    inp_valve.head,
    inp_valve.pattern_id,
    inp_valve.demand,
    inp_valve.demand_pattern_id,
    inp_valve.emitter_coeff,
    n.the_geom
   FROM ve_node n
     JOIN inp_valve USING (node_id)
     JOIN man_valve v USING (node_id)
  WHERE n.is_operative IS TRUE;



DROP VIEW IF EXISTS ve_epa_valve;
CREATE OR REPLACE VIEW ve_epa_valve
AS SELECT inp_valve.node_id,
    inp_valve.valve_type,
    cat_node.dint,
    inp_valve.custom_dint,
    inp_valve.setting,
    inp_valve.curve_id,
    inp_valve.minorloss,
    v.to_arc,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.broken IS FALSE AND v.to_arc IS NOT NULL THEN 'ACTIVE'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    inp_valve.add_settings,
    inp_valve.init_quality,
    inp_valve.head,
    inp_valve.pattern_id,
    inp_valve.demand,
    inp_valve.demand_pattern_id,
    inp_valve.emitter_coeff,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM node
     JOIN inp_valve USING (node_id)
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     LEFT JOIN v_rpt_arc_stats ON concat(inp_valve.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id = inp_valve.node_id;


DROP VIEW IF EXISTS ve_inp_dscenario_valve;
CREATE OR REPLACE VIEW ve_inp_dscenario_valve
AS SELECT d.dscenario_id,
    p.node_id,
    concat(p.node_id, '_n2a') AS nodarc_id,
    p.valve_type,
    p.setting,
    p.curve_id,
    p.minorloss,
    p.status,
    p.add_settings,
    p.init_quality,
    p.to_arc,
    p.head,
    p.pattern_id,
    p.demand,
    p.demand_pattern_id,
    p.emitter_coeff,
    n.the_geom
   FROM selector_inp_dscenario,
    ve_node n
     JOIN inp_dscenario_valve p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER AND n.is_operative IS TRUE;


DROP VIEW IF EXISTS ve_inp_shortpipe;
CREATE OR REPLACE VIEW ve_inp_shortpipe
AS SELECT n.node_id,
    n.top_elev,
    n.custom_top_elev,
    n.depth,
    n.nodecat_id,
    n.expl_id,
    n.sector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    concat(n.node_id, '_n2a') AS nodarc_id,
    inp_shortpipe.minorloss,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.broken IS FALSE AND v.to_arc IS NOT NULL THEN 'CV'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    inp_shortpipe.head,
    inp_shortpipe.pattern_id,
    inp_shortpipe.demand,
    inp_shortpipe.demand_pattern_id,
    inp_shortpipe.emitter_coeff,
    n.the_geom
   FROM ve_node n
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN man_valve v ON v.node_id = n.node_id
  WHERE n.is_operative IS TRUE;


DROP VIEW IF EXISTS ve_inp_dscenario_shortpipe;
CREATE OR REPLACE VIEW ve_inp_dscenario_shortpipe
AS SELECT d.dscenario_id,
    p.node_id,
    p.minorloss,
    p.status,
    p.bulk_coeff,
    p.wall_coeff,
    p.to_arc,
    p.head,
    p.pattern_id,
    p.demand,
    p.demand_pattern_id,
    p.emitter_coeff,
    n.the_geom
   FROM selector_inp_dscenario,
    ve_node n
     JOIN inp_dscenario_shortpipe p USING (node_id)
     JOIN cat_dscenario d USING (dscenario_id)
  WHERE p.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = CURRENT_USER AND n.is_operative IS TRUE;


DROP VIEW IF EXISTS ve_epa_shortpipe;
CREATE OR REPLACE VIEW ve_epa_shortpipe
AS SELECT inp_shortpipe.node_id,
    inp_shortpipe.minorloss,
    cat_node.dint,
    inp_shortpipe.custom_dint,
    v.to_arc,
        CASE
            WHEN v.closed IS TRUE THEN 'CLOSED'::character varying(12)
            WHEN v.broken IS FALSE AND v.to_arc IS NOT NULL THEN 'CV'::character varying(12)
            ELSE 'OPEN'::character varying(12)
        END AS status,
    inp_shortpipe.bulk_coeff,
    inp_shortpipe.wall_coeff,
    inp_shortpipe.head,
    inp_shortpipe.pattern_id,
    inp_shortpipe.demand,
    inp_shortpipe.demand_pattern_id,
    inp_shortpipe.emitter_coeff,
    v_rpt_arc_stats.result_id,
    v_rpt_arc_stats.flow_max AS flowmax,
    v_rpt_arc_stats.flow_min AS flowmin,
    v_rpt_arc_stats.flow_avg AS flowavg,
    v_rpt_arc_stats.vel_max AS velmax,
    v_rpt_arc_stats.vel_min AS velmin,
    v_rpt_arc_stats.vel_avg AS velavg,
    v_rpt_arc_stats.headloss_max,
    v_rpt_arc_stats.headloss_min,
    v_rpt_arc_stats.setting_max,
    v_rpt_arc_stats.setting_min,
    v_rpt_arc_stats.reaction_max,
    v_rpt_arc_stats.reaction_min,
    v_rpt_arc_stats.ffactor_max,
    v_rpt_arc_stats.ffactor_min
   FROM node
     LEFT JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN inp_shortpipe USING (node_id)
     LEFT JOIN v_rpt_arc_stats ON concat(inp_shortpipe.node_id, '_n2a') = v_rpt_arc_stats.arc_id::text
     LEFT JOIN man_valve v ON v.node_id = inp_shortpipe.node_id;

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_connec', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_frpump', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_frshortpipe', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_frvalve', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_inlet', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_junction', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_link', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_pipe', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_pump', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_reservoir', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_tank', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_virtualpump', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('ve_epa_virtualvalve', 'form_feature', 'tab_epa', 'dscenario_web_id', 'lyt_epa_data_1', NULL, 'string', 'combo', 'Dscenario id:', 'Dscenario id', NULL, false, false, true, false, NULL, 'SELECT dscenario_id AS id, name AS idval FROM cat_dscenario WHERE active = true', NULL, true, NULL, NULL, NULL, '{"setMultiline": false}'::json, NULL, NULL, false, 0) ON CONFLICT DO NOTHING;

-- Update weblayoutorder for all fields
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='demand' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='tbl_inp_connec' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='peak_factor' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='emitter_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_connec' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='power' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='pump_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='energy_price' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='usage_fact' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='energy_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='avg_effic' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='kwhr_mgal' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='effic_curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='avg_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='peak_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frpump' AND formtype='form_feature' AND columnname='cost_day' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='tbl_inp_shortpipe' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='bulk_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='wall_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_frshortpipe' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='tbl_inp_valve' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='setting' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='uheadloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='uheadloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='add_settings' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='cat_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_frvalve' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='initlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='tbl_inp_inlet' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='minlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='maxlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='diameter' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='minvol' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='overflow' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='mixing_model' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='mixing_fraction' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='reaction_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='head' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demand' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=18
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='demand_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=19
WHERE formname='ve_epa_inlet' AND formtype='form_feature' AND columnname='emitter_coeff' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='demand' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='tbl_inp_junction' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='emitter_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_junction' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='custom_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='custom_length' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='cat_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='flow_avg' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='vel_avg' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='seetting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=18
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=19
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=20
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=21
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='total_headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=22
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='total_headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=23
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=24
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=25
WHERE formname='ve_epa_link' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tbl_inp_pipe' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='matcat_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='builtdate' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='cat_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='custom_roughness' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reactionparam' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reactionvalue' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='bulk_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='wall_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=18
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=19
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=20
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=21
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tot_headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=22
WHERE formname='ve_epa_pipe' AND formtype='form_feature' AND columnname='tot_headloss_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='power' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='tbl_inp_pump' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='pump_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='usage_fact' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='energy_price' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='energy_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='avg_effic' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='effic_curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='kwhr_mgal' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='avg_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='peak_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_pump' AND formtype='form_feature' AND columnname='cost_day' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='tbl_inp_reservoir' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='head' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_reservoir' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='nodarc_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='tbl_inp_shortpipe' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='bulk_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='wall_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_shortpipe' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='initlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='tbl_inp_tank' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='minlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='demandmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='demandmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='maxlevel' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='diameter' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='minvol' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='headmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='headmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='headavg' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='overflow' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='pressmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='mixing_model' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='pressmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='mixing_fraction' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='reaction_coeff' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='qualmax' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='qualmin' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_tank' AND formtype='form_feature' AND columnname='source_pattern_id' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='nodarc_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='tbl_inp_valve' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='setting' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='uheadloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='uheadloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='add_settings' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='custom_dint' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_valve' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='power' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='tbl_inp_virtualpump' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='speed' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='usage_fact' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='pump_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='hspacer_lyt_epa' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='effic_curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='avg_effic' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='energy_price' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='kwhr_mgal' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='energy_pattern_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='avg_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='peak_kw' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_virtualpump' AND formtype='form_feature' AND columnname='cost_day' AND tabname='tab_epa';

UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='tbl_inp_virtualvalve' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='nodarc_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='add_to_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=1
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='result_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='flow_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='remove_from_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=2
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='valve_type' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='edit_dscenario' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='flow_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=3
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='setting' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='hspacer_epa_1' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=4
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='diameter' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=5
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='vel_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=6
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='vel_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=7
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='curve_id' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='minorloss' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=8
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='headloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='status' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=9
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='headloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=10
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='uheadloss_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='uheadloss_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=11
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='init_quality' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=12
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='setting_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=13
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='setting_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=14
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='reaction_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=15
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='reaction_min' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=16
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='ffactor_max' AND tabname='tab_epa';
UPDATE config_form_fields SET web_layoutorder=17
WHERE formname='ve_epa_virtualvalve' AND formtype='form_feature' AND columnname='ffactor_min' AND tabname='tab_epa';


INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,iseditable,hidden,web_layoutorder)
VALUES ('generic','go2epa','tab_data','export_frost','lyt_go2epa_data_2',2,'boolean','check','Export to Frost:','Export inp in Frost',false,true,false,15);


UPDATE config_function SET "style"='{"style": {"polygon": {"style": "qml", "id": "101"}}}'::json WHERE id=2706;

INSERT INTO sys_style (layername, styleconfig_id, styletype, stylevalue, active) VALUES('Temp Minsector', 101, 'qml', '<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.9-Bratislava" styleCategories="Symbology">
  <renderer-v2 type="singleSymbol" symbollevels="0" enableorderby="0" forceraster="0" referencescale="-1">
    <symbols>
      <symbol type="fill" frame_rate="10" name="0" clip_to_extent="1" is_animated="0" force_rhr="0" alpha="0.6">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" id="{27f77253-c08f-4e81-911a-d84d608e2a75}" class="SimpleFill">
          <Option type="Map">
            <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="color" value="74,218,98,255,hsv:0.3611111111111111,0.6588235294117647,0.85490196078431369,1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0.26"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="style" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="fillColor">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="expression" value="''#FF'' ||&#xd;&#xa;right(''00'' || format(''%1'', (((&quot;minsector_id&quot; * 123) % 256)), ''X''), 2) ||   -- Red&#xd;&#xa;right(''00'' || format(''%1'', (((&quot;minsector_id&quot; * 45) % 256)), ''X''), 2) ||    -- Green&#xd;&#xa;right(''00'' || format(''%1'', (((&quot;minsector_id&quot; * 67) % 256)), ''X''), 2)       -- Blue"/>
                  <Option type="int" name="type" value="3"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol type="fill" frame_rate="10" name="" clip_to_extent="1" is_animated="0" force_rhr="0" alpha="0">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" id="{d77627be-48c9-4a05-8439-16d058d08f39}" class="SimpleFill">
          <Option type="Map">
            <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="color" value="0,0,255,255,rgb:0,0,1,1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0.26"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="style" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>2</layerGeometryType>
</qgis>
', true);

UPDATE sys_style
	SET stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis version="3.40.9-Bratislava" styleCategories="Symbology">
  <renderer-v2 type="singleSymbol" symbollevels="0" enableorderby="0" forceraster="0" referencescale="-1">
    <symbols>
      <symbol type="fill" frame_rate="10" name="0" clip_to_extent="1" is_animated="0" force_rhr="0" alpha="0.75">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" id="{27f77253-c08f-4e81-911a-d84d608e2a75}" class="SimpleFill">
          <Option type="Map">
            <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="color" value="74,218,98,255,hsv:0.3611111111111111,0.6588235294117647,0.85490196078431369,1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0.26"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="style" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option type="Map" name="properties">
                <Option type="Map" name="fillColor">
                  <Option type="bool" name="active" value="true"/>
                  <Option type="QString" name="expression" value="''#FF'' ||&#xd;&#xa;right(''00'' || format(''%1'', (((&quot;minsector_id&quot; * 123) % 256)), ''X''), 2) ||   -- Red&#xd;&#xa;right(''00'' || format(''%1'', (((&quot;minsector_id&quot; * 45) % 256)), ''X''), 2) ||    -- Green&#xd;&#xa;right(''00'' || format(''%1'', (((&quot;minsector_id&quot; * 67) % 256)), ''X''), 2)       -- Blue"/>
                  <Option type="int" name="type" value="3"/>
                </Option>
              </Option>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <rotation/>
    <sizescale/>
    <data-defined-properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol type="fill" frame_rate="10" name="" clip_to_extent="1" is_animated="0" force_rhr="0" alpha="1">
        <data_defined_properties>
          <Option type="Map">
            <Option type="QString" name="name" value=""/>
            <Option name="properties"/>
            <Option type="QString" name="type" value="collection"/>
          </Option>
        </data_defined_properties>
        <layer pass="0" locked="0" enabled="1" id="{d77627be-48c9-4a05-8439-16d058d08f39}" class="SimpleFill">
          <Option type="Map">
            <Option type="QString" name="border_width_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="color" value="0,0,255,255,rgb:0,0,1,1"/>
            <Option type="QString" name="joinstyle" value="bevel"/>
            <Option type="QString" name="offset" value="0,0"/>
            <Option type="QString" name="offset_map_unit_scale" value="3x:0,0,0,0,0,0"/>
            <Option type="QString" name="offset_unit" value="MM"/>
            <Option type="QString" name="outline_color" value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1"/>
            <Option type="QString" name="outline_style" value="solid"/>
            <Option type="QString" name="outline_width" value="0.26"/>
            <Option type="QString" name="outline_width_unit" value="MM"/>
            <Option type="QString" name="style" value="solid"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option type="QString" name="name" value=""/>
              <Option name="properties"/>
              <Option type="QString" name="type" value="collection"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>2</layerGeometryType>
</qgis>
'
WHERE layername='ve_minsector' AND styleconfig_id=101;

UPDATE config_param_system
SET value = jsonb_set(
    value::jsonb,
    '{MINSECTOR,mode}',
    '"Disable"',
    true
)::text
WHERE "parameter" = 'utils_graphanalytics_style';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('plan_netscenario_presszone', 'form_feature', 'tab_none', 'expl_id', 'lyt_data_1', 8, 'text', 'multiple_option', 'Expl id:', 'Expl_id', 'Ex: {1,2}', true, false, true, false, NULL, 'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation": {"layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('plan_netscenario_presszone', 'form_feature', 'tab_none', 'muni_id', 'lyt_data_1', 10, 'text', 'multiple_option', 'Muni id:', 'Muni_id', NULL, false, false, false, false, NULL, 'select muni_id AS id, name AS idval from v_ext_municipality where muni_id > 0', NULL, NULL, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation": {"layer": "v_ext_municipality", "activated": true, "keyColumn": "muni_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('plan_netscenario_presszone', 'form_feature', 'tab_none', 'sector_id', 'lyt_data_1', 9, 'integer', 'multiple_option', 'Sector id:', 'Sector_id', NULL, false, false, false, false, NULL, 'select sector_id AS id, name AS idval from ve_sector where sector_id > 0', NULL, NULL, NULL, NULL, '{"label":"color:red; font-weight:bold"}'::json, '{"setMultiline": false, "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json, NULL, NULL, false, NULL);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,stylesheet,widgetcontrols,hidden)
VALUES ('plan_netscenario_dma','form_feature','tab_none','sector_id','lyt_data_1',9,'integer','multiple_option','Sector id:','Sector_id',false,false,false,false,'select sector_id AS id, name AS idval from ve_sector where sector_id > 0','{"label":"color:red; font-weight:bold"}'::json,'{"setMultiline": false, "valueRelation": {"layer": "ve_sector", "activated": true, "keyColumn": "sector_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,placeholder,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
VALUES ('plan_netscenario_dma','form_feature','tab_none','expl_id','lyt_data_1',8,'text','multiple_option','Expl id:','Expl_id','Ex: {1,2}',true,false,true,false,'select expl_id AS id, name AS idval from ve_exploitation where expl_id > 0','{"setMultiline": false, "valueRelation": {"layer": "ve_exploitation", "activated": true, "keyColumn": "expl_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json,false);
INSERT INTO config_form_fields (formname,formtype,tabname,columnname,layoutname,layoutorder,"datatype",widgettype,"label",tooltip,ismandatory,isparent,iseditable,isautoupdate,dv_querytext,widgetcontrols,hidden)
VALUES ('plan_netscenario_dma','form_feature','tab_none','muni_id','lyt_data_1',10,'text','multiple_option','Muni id:','Muni_id',false,false,false,false,'select muni_id AS id, name AS idval from v_ext_municipality where muni_id > 0','{"setMultiline": false, "valueRelation": {"layer": "v_ext_municipality", "activated": true, "keyColumn": "muni_id", "nullValue": false, "allowMulti": true, "nofColumns": 2, "valueColumn": "name", "filterExpression": null}}'::json,false);

UPDATE sys_table SET context = 12 WHERE id = 've_minsector';

INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder)
VALUES('v_om_mincut_valve', 'form_feature', 'tab_none', 'changestatus', NULL, NULL, 'boolean', 'check', 'Change status:', 'Change status', NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL);


INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'netscenario_id', 0, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'name', 1, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'descript', 2, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'netscenario_type', 3, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'parent_id', 4, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'expl_id', 5, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'active', 6, true, NULL, NULL, NULL, NULL);
INSERT INTO config_form_tableview (location_type, project_type, objectname, columnname, columnindex, visible, width, alias, "style", addparam)
VALUES('netscenariomanager_form', 'ws', 'v_ui_plan_netscenario', 'log', 7, true, NULL, NULL, NULL, NULL);



UPDATE config_form_fields SET "datatype"='datetime' WHERE formname='mincut' AND formtype='form_mincut' AND columnname='exec_start' AND tabname='tab_mincut';



INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'pattern_id', 'lyt_epa_data_1', 19, 'string', 'combo', 'Patrón:', 'Patrón', NULL, false, false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'head', 'lyt_epa_data_1', 18, 'string', 'text', 'Carga hidráulica:', 'Cabeza', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'emitter_coeff', 'lyt_epa_data_1', 22, 'string', 'text', 'Coeficiente emisor:', 'Coeficiente del emisor', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'demand_pattern_id', 'lyt_epa_data_1', 21, 'string', 'combo', 'Id del patrón:', 'Id de patrón', NULL, false, false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_valve', 'form_feature', 'tab_epa', 'demand', 'lyt_epa_data_1', 20, 'string', 'text', 'Demanda:', 'Deamanda de agua - demand ', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'pattern_id', 'lyt_epa_data_1', 19, 'string', 'combo', 'Patrón:', 'Patrón', NULL, false, false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"setMultiline": false, "valueRelation":{"nullValue":true, "layer": "ve_inp_pattern", "activated": true, "keyColumn": "pattern_id", "valueColumn": "pattern_id", "filterExpression": null}}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'head', 'lyt_epa_data_1', 18, 'string', 'text', 'Carga hidráulica:', 'Cabeza', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'emitter_coeff', 'lyt_epa_data_1', 22, 'string', 'text', 'Coeficiente emisor:', 'Coeficiente del emisor', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'demand_pattern_id', 'lyt_epa_data_1', 21, 'string', 'combo', 'Id del patrón:', 'Id de patrón', NULL, false, false, true, false, false, 'SELECT DISTINCT (pattern_id) AS id,  pattern_id  AS idval FROM inp_pattern WHERE pattern_id IS NOT NULL', true, true, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);
INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, isfilter, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, stylesheet, widgetcontrols, widgetfunction, linkedobject, hidden, web_layoutorder) VALUES('ve_epa_shortpipe', 'form_feature', 'tab_epa', 'demand', 'lyt_epa_data_1', 20, 'string', 'text', 'Demanda:', 'Deamanda de agua - demand ', NULL, false, false, true, false, false, NULL, NULL, NULL, NULL, NULL, NULL, '{"filterSign":"ILIKE"}'::json, NULL, NULL, false, 17);


INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3560, 'gw_fct_create_dscenario_losses', 'ws', 'function', 'json', 'json', 'Function to create losses dscenario', 'role_epa', NULL, 'core', NULL)
ON CONFLICT DO NOTHING;

INSERT INTO inp_typevalue (typevalue, id, idval, descript, addparam) 
VALUES('inp_typevalue_dscenario', 'LOSSES', 'LOSSES', NULL, NULL)
ON CONFLICT DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) 
VALUES(3560, 'gw_fct_create_dscenario_losses', 'ws', 'function', 'json', 'json', 'Function to create losses dscenario.', 'role_epa', NULL, 'core', 'CREATE LOSSES DSCENARIO')
ON CONFLICT DO NOTHING;

INSERT INTO config_toolbox (id, alias, functionparams, inputparams, observ, active, device) 
VALUES(3560, 'Create losses dscenario', '{"featureType":[]}'::json, '[
  {
    "label": "Name: (*)",
    "value": null,
    "tooltip": "Name of the scenario",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "name",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 1,
    "placeholder": ""
  },
  {
    "label": "Descript:",
    "value": null,
    "tooltip": "Descript",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "descript",
    "widgettype": "linetext",
    "isMandatory": false,
    "layoutorder": 2,
    "placeholder": ""
  },
  {
    "label": "Sector:",
    "value": null,
    "datatype": "int",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "sectorId",
    "widgettype": "combo",
    "dvQueryText": "SELECT sector_id as id, name as idval FROM sector s WHERE EXISTS (SELECT 1 FROM selector_expl se WHERE se.expl_id = ANY(s.expl_id) AND se.cur_user = current_user)",
    "layoutorder": 3
  },
  {
    "label": "Emitter coefficient",
    "value": null,
    "tooltip": "Emitter coefficient",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "emitterCoeff",
    "widgettype": "linetext",
    "isMandatory": true,
    "layoutorder": 4,
    "placeholder": "0.01"
  },
  {
    "label": "Active:",
    "value": null,
    "tooltip": "If true, active",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "selectedId": null,
    "widgetname": "active",
    "widgettype": "check",
    "layoutorder": 5
  }
]'::json, NULL, true, '{4}');

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type) 
VALUES(4586, 'The scenario name already exists. The process was not executed.', NULL, 2, true, 'utils', 'core', 'AUDIT')
ON CONFLICT DO NOTHING;


UPDATE config_form_fields SET iseditable=false WHERE formname='plan_netscenario_presszone' AND formtype='form_feature' AND columnname='presszone_id' AND tabname='tab_none' AND iseditable=true;

DO $$

DECLARE
rec_feature TEXT;

BEGIN

-- Create aux cols
ALTER TABLE doc DROP COLUMN IF EXISTS unique_doc;

ALTER TABLE doc ADD COLUMN unique_doc int;


-- Set init values
UPDATE doc t SET unique_doc = a.first_doc FROM (
SELECT id, first_value(id) over(PARTITION BY "path" ORDER BY "path" asc) AS first_doc
	FROM doc a
)a WHERE t.id = a.id;


FOREACH rec_feature in ARRAY array['arc', 'connec', 'node', 'link'] 
LOOP

  -- Insert normalized doc_x_features
  execute format('INSERT INTO %s (%s, doc_id)
  SELECT %s.%s, unique_doc 
  FROM %s JOIN doc ON %s.doc_id = doc.id
  ON CONFLICT DO NOTHING;',
  'doc_x_' || rec_feature,
  rec_feature || '_id',
  'doc_x_' || rec_feature,
  rec_feature || '_id',
  'doc_x_' || rec_feature,
  'doc_x_' || rec_feature
  );

  /* example
  INSERT INTO doc_x_arc (arc_id, doc_id)
  SELECT doc_x_arc.arc_id, unique_doc 
  FROM doc_x_arc JOIN doc ON doc_x_arc.doc_id = doc.id
  ON CONFLICT DO NOTHING;
  */

END LOOP;

DELETE FROM doc WHERE id IN (
  SELECT id--, unique_doc, "path", aux 
  FROM doc WHERE id<> unique_doc AND "path" IN (
  SELECT "path" FROM doc GROUP BY "path" HAVING count(*)>1)
  ORDER BY unique_doc ASC
);


-- Drop aux cols
ALTER TABLE doc DROP COLUMN unique_doc;


END
$$;

ALTER TABLE doc_x_link ADD CONSTRAINT doc_x_link_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_workcat ADD CONSTRAINT doc_x_workcat_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_visit ADD CONSTRAINT doc_x_visit_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_element ADD CONSTRAINT doc_x_element_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE doc ADD CONSTRAINT doc_path_unique UNIQUE (path);

CREATE TRIGGER gw_trg_ui_doc_x_visit INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_visit FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('visit');

CREATE TRIGGER gw_trg_ui_doc_x_node INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_node FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('node');

CREATE TRIGGER gw_trg_ui_doc_x_arc INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_arc FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('arc');

CREATE TRIGGER gw_trg_ui_doc_x_connec INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_connec FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('connec');

CREATE TRIGGER gw_trg_ui_doc_x_link INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_link FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('link');

CREATE TRIGGER gw_trg_ui_doc_x_element INSTEAD OF INSERT OR DELETE OR UPDATE
ON v_ui_doc_x_element FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_doc('element');




create trigger gw_trg_edit_inp_node_valve instead of insert or delete or update on
ve_inp_valve for each row execute function gw_trg_edit_inp_node('inp_valve');

create trigger gw_trg_edit_ve_epa_valve instead of insert or delete or update on
ve_epa_valve for each row execute function gw_trg_edit_ve_epa('valve');

create trigger gw_trg_edit_inp_dscenario_valve instead of insert or delete or update on
ve_inp_dscenario_valve for each row execute function gw_trg_edit_inp_dscenario('VALVE');

create trigger gw_trg_edit_inp_node_shortpipe instead of insert or delete or update on
ve_inp_shortpipe for each row execute function gw_trg_edit_inp_node('inp_shortpipe');

create trigger gw_trg_edit_inp_dscenario_shortpipe instead of insert or delete or update on
ve_inp_dscenario_shortpipe for each row execute function gw_trg_edit_inp_dscenario('SHORTPIPE');

create trigger gw_trg_edit_ve_epa_shortpipe instead of insert or delete or update on
ve_epa_shortpipe for each row execute function gw_trg_edit_ve_epa('shortpipe');
