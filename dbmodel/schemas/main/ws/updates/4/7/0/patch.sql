/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"om_mincut", "column":"shutoff_required", "dataType":"boolean", "defaultValue":"true", "isUtils":"False"}}$$);

-- add columns to tables for EPA families export
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_arc", "column":"builtdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_node", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"temp_node", "column":"builtdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"anl_node", "column":"builtdate", "dataType":"date", "isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_node","column":"builtdate","dataType":"date","isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc","column":"builtdate","dataType":"date","isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"rpt_inp_arc","column":"family","dataType":"varchar(100)","isUtils":"False"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"rpt_inp_node", "column":"presszone_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"rpt_inp_arc", "column":"presszone_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"temp_arc", "column":"presszone_id", "dataType":"int4"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"temp_node", "column":"presszone_id", "dataType":"int4"}}$$);


DROP VIEW IF EXISTS v_om_mincut;
DROP VIEW IF EXISTS v_om_mincut_current_initpoint;
DROP VIEW IF EXISTS v_ui_mincut;
DROP VIEW IF EXISTS v_om_mincut_initpoint;
DROP VIEW IF EXISTS v_om_mincut_polygon;
SELECT gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"om_mincut", "column":"anl_feature_id", "dataType":"int4"}}$$);

CREATE TABLE dma_graph_object (
	object_id INTEGER NOT NULL,
	expl_id INTEGER,
	object_type TEXT,
	object_label TEXT,
    label TEXT,
	order_id INTEGER,
	attrib json,
    coord_x numeric,
    coord_y numeric,
	meter_1 _int4 NULL,
	meter_2 _int4 NULL,
	the_geom public.geometry(POINT, SRID_VALUE),
	CONSTRAINT dma_graph_object_pkey PRIMARY KEY (object_id));

CREATE TABLE dma_graph_meter(
	meter_id int4 NOT NULL,
	expl_id int4 NULL,
	object_1 int4 NULL,
	object_2 int4 NULL,
	attrib json NULL,
	order_id int4 NULL,
	the_geom public.geometry(LINESTRING, SRID_VALUE),
	CONSTRAINT dma_graph_meter_pkey PRIMARY KEY (meter_id),
	CONSTRAINT dma_graph_meter_meter_expl_unique UNIQUE (meter_id, expl_id)
);

ALTER TABLE cat_element DROP CONSTRAINT IF EXISTS cat_element_fkey_element_type;
ALTER TABLE cat_element ADD CONSTRAINT cat_element_fkey_element_type FOREIGN KEY (element_type) REFERENCES cat_feature_element(id) ON DELETE RESTRICT ON UPDATE CASCADE;


ALTER TABLE minsector_graph RENAME COLUMN nodecat_id TO node_type;

CREATE TABLE presszone_graph (
	node_1 int4 NOT NULL,
	node_type_1 int4 NOT NULL,
	node_2 int4 NOT NULL,
	node_type_2 int4 NOT NULL,
	presszone_id int4 NOT NULL,
	the_geom geometry(MultiLineString, SRID_VALUE),
	CONSTRAINT presszone_graph_pkey PRIMARY KEY (node_1, node_2)
);

CREATE INDEX IF NOT EXISTS presszone_graph_node_1_idx ON presszone_graph USING btree (node_1);
CREATE INDEX IF NOT EXISTS presszone_graph_node_2_idx ON presszone_graph USING btree (node_2);
CREATE INDEX IF NOT EXISTS the_geom_graph_idx ON presszone_graph USING gist (the_geom);

CREATE OR REPLACE VIEW v_om_mincut
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_mincut_result
          WHERE sel_mincut_result.result_id = om_mincut.id)) AND om_mincut.id > 0;


CREATE OR REPLACE VIEW v_om_mincut_initpoint
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id,
            selector_mincut_result.result_type
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om.id,
    om.work_order,
    a.idval AS state,
    b.idval AS class,
    om.mincut_type,
    om.received_date,
    om.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om.macroexpl_id,
    om.muni_id,
    ext_municipality.name AS muni_name,
    om.postcode,
    om.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om.postnumber,
    c.idval AS anl_cause,
    om.anl_tstamp,
    om.anl_user,
    om.anl_descript,
    om.anl_feature_id,
    om.anl_feature_type,
    om.anl_the_geom,
    om.forecast_start,
    om.forecast_end,
    om.assigned_to,
    om.exec_start,
    om.exec_end,
    om.exec_user,
    om.exec_descript,
    om.exec_from_plot,
    om.exec_depth,
    om.exec_appropiate,
    om.notified,
    om.output,
    sm.result_type,
    om.shutoff_required
   FROM om_mincut om
     LEFT JOIN om_typevalue a ON a.id::integer = om.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om.muni_id = ext_municipality.muni_id
     LEFT JOIN sel_mincut_result sm ON sm.result_id = om.id AND om.id > 0;


CREATE OR REPLACE VIEW v_om_mincut_polygon
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.polygon_the_geom,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_mincut_result
          WHERE sel_mincut_result.result_id = om_mincut.id)) AND om_mincut.id > 0;


CREATE OR REPLACE VIEW v_ui_mincut
AS SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    om_mincut.postcode,
    ext_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON exploitation.expl_id = om_mincut.expl_id
     LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = om_mincut.macroexpl_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = om_mincut.muni_id
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = om_mincut.streetaxis_id::text
     LEFT JOIN cat_users ON cat_users.id::text = om_mincut.assigned_to::text
  WHERE om_mincut.id > 0;


CREATE OR REPLACE VIEW v_ui_mincut_connec
AS SELECT om_mincut_connec.id,
    om_mincut_connec.connec_id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut_cat_type.virtual,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_start::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_end::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date,
    om_mincut.shutoff_required
   FROM om_mincut_connec
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
     JOIN om_mincut_cat_type ON om_mincut.mincut_type::text = om_mincut_cat_type.id::text;


CREATE OR REPLACE VIEW v_ui_mincut_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.hydrometer_id,
    rtc_hydrometer_x_connec.connec_id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut.mincut_state,
    om_mincut.mincut_class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_appropiate,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_start::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_start::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS start_date,
        CASE
            WHEN om_mincut.mincut_state = 0 THEN om_mincut.forecast_end::timestamp with time zone
            WHEN om_mincut.mincut_state = 1 THEN now()
            WHEN om_mincut.mincut_state = 2 THEN om_mincut.exec_end::timestamp with time zone
            ELSE NULL::timestamp with time zone
        END AS end_date,
    om_mincut.shutoff_required
   FROM om_mincut_hydrometer
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = om_mincut_hydrometer.hydrometer_id::bigint;

CREATE OR REPLACE VIEW ve_arc
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
)
SELECT
    a.arc_id,
    a.code,
    a.sys_code,
    a.node_1,
    a.nodetype_1,
    a.elevation1,
    a.depth1,
    a.staticpressure1,
    a.node_2,
    a.nodetype_2,
    a.staticpressure2,
    a.elevation2,
    a.depth2,
    ((COALESCE(a.depth1) + COALESCE(a.depth2)) / 2::numeric)::numeric(12,2) AS depth,
    cat_arc.arc_type,
    a.arccat_id,
    cat_feature.feature_class AS sys_type,
    cat_arc.matcat_id AS cat_matcat_id,
    cat_arc.pnom AS cat_pnom,
    cat_arc.dnom AS cat_dnom,
    cat_arc.dint AS cat_dint,
    cat_arc.dr AS cat_dr,
    a.epa_type,
    a.state,
    a.state_type,
    a.parent_id,
    a.expl_id,
    exploitation.macroexpl_id,
    a.muni_id,
    a.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    a.supplyzone_id,
    supplyzone_table.supplyzone_type,
    a.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    a.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type,
    a.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    a.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    a.minsector_id,
    a.pavcat_id,
    a.soilcat_id,
    a.function_type,
    a.category_type,
    a.location_type,
    a.fluid_type,
    a.descript,
    st_length2d(a.the_geom)::numeric(12,2) AS gis_length,
    a.custom_length,
    a.annotation,
    a.observ,
    a.comment,
    concat(cat_feature.link_path, a.link) AS link,
    a.num_value,
    a.district_id,
    a.postcode,
    a.streetaxis_id,
    a.postnumber,
    a.postcomplement,
    a.streetaxis2_id,
    a.postnumber2,
    a.postcomplement2,
    mu.region_id,
    mu.province_id,
    a.workcat_id,
    a.workcat_id_end,
    a.workcat_id_plan,
    a.builtdate,
    a.enddate,
    a.ownercat_id,
    a.om_state,
    a.conserv_state,
    COALESCE(a.brand_id, cat_arc.brand_id) AS brand_id,
    COALESCE(a.model_id, cat_arc.model_id) AS model_id,
    a.serial_number,
    a.asset_id,
    a.adate,
    a.adescript,
    a.verified,
    a.datasource,
    cat_arc.label,
    a.label_x,
    a.label_y,
    a.label_rotation,
    a.label_quadrant,
    a.inventory,
    a.publish,
    vst.is_operative,
    a.is_scadamap,
    CASE
        WHEN a.sector_id > 0 AND vst.is_operative = true AND a.epa_type::text <> 'UNDEFINED'::text THEN a.epa_type::text
        ELSE NULL::text
    END AS inp_type,
    arc_add.result_id,
    arc_add.flow_max,
    arc_add.flow_min,
    arc_add.flow_avg,
    arc_add.vel_max,
    arc_add.vel_min,
    arc_add.vel_avg,
    arc_add.tot_headloss_max,
    arc_add.tot_headloss_min,
    arc_add.mincut_connecs,
    arc_add.mincut_hydrometers,
    arc_add.mincut_length,
    arc_add.mincut_watervol,
    arc_add.mincut_criticality,
    arc_add.hydraulic_criticality,
    arc_add.pipe_capacity,
    arc_add.mincut_impact_topo,
    arc_add.mincut_impact_hydro,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
    dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
    supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
    a.lock_level,
    a.expl_visibility,
    date_trunc('second'::text, a.created_at) AS created_at,
    a.created_by,
    date_trunc('second'::text, a.updated_at) AS updated_at,
    a.updated_by,
    a.the_geom,
    COALESCE(pp.state, a.state) AS p_state,
    a.uuid,
    a.uncertain
FROM arc a
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_arc pp_1
          WHERE pp_1.arc_id = a.arc_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
     JOIN cat_arc ON cat_arc.id::text = a.arccat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_arc.arc_type::text
     JOIN exploitation ON a.expl_id = exploitation.expl_id
     JOIN ext_municipality mu ON a.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = a.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = a.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = a.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = a.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = a.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = a.omzone_id
     LEFT JOIN arc_add ON arc_add.arc_id = a.arc_id
     LEFT JOIN value_state_type vst ON vst.id = a.state_type
     WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = COALESCE(pp.state, a.state) AND ss.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = a.sector_id AND ssec.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = a.muni_id AND sm.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(a.expl_visibility, a.expl_id))) AND se.cur_user = CURRENT_USER);

CREATE OR REPLACE VIEW ve_node
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
)
SELECT
    n.node_id,
    n.code,
    n.sys_code,
    n.top_elev,
    n.custom_top_elev,
    COALESCE(n.custom_top_elev, n.top_elev) AS sys_top_elev,
    n.depth,
    cat_node.node_type,
    cat_feature.feature_class AS sys_type,
    n.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    cat_node.dint AS cat_dint,
    n.epa_type,
    n.state,
    n.state_type,
    n.arc_id,
    n.parent_id,
    n.expl_id,
    exploitation.macroexpl_id,
    n.muni_id,
    n.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    n.supplyzone_id,
    supplyzone_table.supplyzone_type,
    n.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    n.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type,
    n.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    n.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    n.minsector_id,
    n.pavcat_id,
    n.soilcat_id,
    n.function_type,
    n.category_type,
    n.location_type,
    n.fluid_type,
    n.staticpressure,
    n.annotation,
    n.observ,
    n.comment,
    n.descript,
    concat(cat_feature.link_path, n.link) AS link,
    n.num_value,
    n.district_id,
    n.streetaxis_id,
    n.postcode,
    n.postnumber,
    n.postcomplement,
    n.streetaxis2_id,
    n.postnumber2,
    n.postcomplement2,
    mu.region_id,
    mu.province_id,
    n.workcat_id,
    n.workcat_id_end,
    n.workcat_id_plan,
    n.builtdate,
    n.enddate,
    n.ownercat_id,
    n.accessibility,
    n.om_state,
    n.conserv_state,
    n.access_type,
    n.placement_type,
    COALESCE(n.brand_id, cat_node.brand_id) AS brand_id,
    COALESCE(n.model_id, cat_node.model_id) AS model_id,
    n.serial_number,
    n.asset_id,
    n.adate,
    n.adescript,
    n.verified,
    n.datasource,
    n.hemisphere,
    cat_node.label,
    n.label_x,
    n.label_y,
    n.label_rotation,
    n.rotation,
    n.label_quadrant,
    cat_node.svg,
    n.inventory,
    n.publish,
    vst.is_operative,
    n.is_scadamap,
        CASE
            WHEN n.sector_id > 0 AND vst.is_operative = true AND n.epa_type::text <> 'UNDEFINED'::text THEN n.epa_type::text
            ELSE NULL::text
        END AS inp_type,
    node_add.demand_max,
    node_add.demand_min,
    node_add.demand_avg,
    node_add.press_max,
    node_add.press_min,
    node_add.press_avg,
    node_add.head_max,
    node_add.head_min,
    node_add.head_avg,
    node_add.quality_max,
    node_add.quality_min,
    node_add.quality_avg,
    node_add.result_id,
    sector_table.stylesheet ->> 'featureColor'::text AS sector_style,
    dma_table.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone_table.stylesheet ->> 'featureColor'::text AS presszone_style,
    dqa_table.stylesheet ->> 'featureColor'::text AS dqa_style,
    supplyzone_table.stylesheet ->> 'featureColor'::text AS supplyzone_style,
    n.lock_level,
    n.expl_visibility,
    ( SELECT st_x(n.the_geom) AS st_x) AS xcoord,
    ( SELECT st_y(n.the_geom) AS st_y) AS ycoord,
    ( SELECT st_y(st_transform(n.the_geom, 4326)) AS st_y) AS lat,
    ( SELECT st_x(st_transform(n.the_geom, 4326)) AS st_x) AS long,
    m.closed AS closed_valve,
    m.broken AS broken_valve,
    date_trunc('second'::text, n.created_at) AS created_at,
    n.created_by,
    date_trunc('second'::text, n.updated_at) AS updated_at,
    n.updated_by,
    n.the_geom,
    COALESCE(pp.state, n.state) AS p_state,
    n.uuid,
    n.uncertain,
    n.xyz_date
FROM node n
     LEFT JOIN LATERAL ( SELECT pp_1.state
           FROM plan_psector_x_node pp_1
          WHERE pp_1.node_id = n.node_id AND (pp_1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER))
          ORDER BY pp_1.psector_id DESC
         LIMIT 1) pp ON true
     JOIN cat_node ON cat_node.id::text = n.nodecat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_node.node_type::text
     JOIN value_state_type vst ON vst.id = n.state_type
     JOIN exploitation ON n.expl_id = exploitation.expl_id
     JOIN ext_municipality mu ON n.muni_id = mu.muni_id
     JOIN sector_table ON sector_table.sector_id = n.sector_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = n.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = n.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = n.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = n.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = n.omzone_id
     LEFT JOIN node_add ON node_add.node_id = n.node_id
     LEFT JOIN man_valve m ON m.node_id = n.node_id
     WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = COALESCE(pp.state, n.state) AND ss.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = n.sector_id AND ssec.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = n.muni_id AND sm.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(n.expl_visibility, n.expl_id))) AND se.cur_user = CURRENT_USER);


CREATE OR REPLACE VIEW ve_connec
AS WITH typevalue AS (
    SELECT 
        edit_typevalue.typevalue,
        edit_typevalue.id,
        edit_typevalue.idval
    FROM edit_typevalue
    WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::text, 'presszone_type'::text, 'dma_type'::text, 'dqa_type'::text, 'supplyzone_type'::text, 'omzone_type'::text])
), sector_table AS (
    SELECT 
        sector.sector_id,
        sector.macrosector_id,
        sector.stylesheet,
        t.id::character varying(16) AS sector_type
    FROM sector
    LEFT JOIN typevalue t ON t.id::text = sector.sector_type::text AND t.typevalue::text = 'sector_type'::text
), dma_table AS (
    SELECT 
        dma.dma_id,
        dma.macrodma_id,
        dma.stylesheet,
        t.id::character varying(16) AS dma_type
    FROM dma
    LEFT JOIN typevalue t ON t.id::text = dma.dma_type::text AND t.typevalue::text = 'dma_type'::text
), presszone_table AS (
    SELECT 
        presszone.presszone_id,
        presszone.head AS presszone_head,
        presszone.stylesheet,
        t.id::character varying(16) AS presszone_type
    FROM presszone
    LEFT JOIN typevalue t ON t.id::text = presszone.presszone_type AND t.typevalue::text = 'presszone_type'::text
), dqa_table AS (
    SELECT 
        dqa.dqa_id,
        dqa.stylesheet,
        t.id::character varying(16) AS dqa_type,
        dqa.macrodqa_id
    FROM dqa
    LEFT JOIN typevalue t ON t.id::text = dqa.dqa_type::text AND t.typevalue::text = 'dqa_type'::text
), supplyzone_table AS (
    SELECT 
        supplyzone.supplyzone_id,
        supplyzone.stylesheet,
        t.id::character varying(16) AS supplyzone_type
    FROM supplyzone
    LEFT JOIN typevalue t ON t.id::text = supplyzone.supplyzone_type::text AND t.typevalue::text = 'supplyzone_type'::text
), omzone_table AS (
    SELECT 
        omzone.omzone_id,
        t.id::character varying(16) AS omzone_type,
        omzone.macroomzone_id
    FROM omzone
    LEFT JOIN typevalue t ON t.id::text = omzone.omzone_type::text AND t.typevalue::text = 'omzone_type'::text
), inp_network_mode AS (
    SELECT config_param_user.value
    FROM config_param_user
    WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
), link_planned AS (
    SELECT 
        l.link_id,
        l.feature_id,
        l.feature_type,
        l.exit_id,
        l.exit_type,
        l.expl_id
    FROM link l
    WHERE l.state = 2
)
SELECT
    c.connec_id,
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
    dma_table.dma_type::character varying,
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
    COALESCE(link_planned.exit_id, c.pjoint_id) AS pjoint_id,
    COALESCE(link_planned.exit_type, c.pjoint_type) AS pjoint_type,
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
            pp_1.link_id
           FROM plan_psector_x_connec pp_1
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
     LEFT JOIN link_planned ON link_planned.link_id = pp.link_id
     LEFT JOIN connec_add ON connec_add.connec_id = c.connec_id
     LEFT JOIN value_state_type vst ON vst.id = c.state_type
     LEFT JOIN inp_network_mode ON TRUE
     WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = COALESCE(pp.state, c.state) AND ss.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = c.sector_id AND ssec.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = c.muni_id AND sm.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(c.expl_visibility, c.expl_id))) AND se.cur_user = CURRENT_USER);


CREATE OR REPLACE VIEW ve_link
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
 SELECT
    l.link_id,
    l.code,
    l.sys_code,
    l.top_elev1,
    l.depth1,
        CASE
            WHEN l.top_elev1 IS NULL OR l.depth1 IS NULL THEN NULL::double precision
            ELSE l.top_elev1 - l.depth1::double precision
        END AS elevation1,
    l.exit_id,
    l.exit_type,
    l.top_elev2,
    l.depth2,
        CASE
            WHEN l.top_elev2 IS NULL OR l.depth2 IS NULL THEN NULL::double precision
            ELSE l.top_elev2 - l.depth2::double precision
        END AS elevation2,
    l.feature_type,
    l.feature_id,
    cat_link.link_type,
    cat_feature.feature_class AS sys_type,
    l.linkcat_id,
    l.state,
    l.state_type,
    l.expl_id,
    exploitation.macroexpl_id,
    l.muni_id,
    l.sector_id,
    sector_table.macrosector_id,
    sector_table.sector_type,
    l.supplyzone_id,
    supplyzone_table.supplyzone_type,
    l.presszone_id,
    presszone_table.presszone_type,
    presszone_table.presszone_head,
    l.dma_id,
    dma_table.macrodma_id,
    dma_table.dma_type,
    l.dqa_id,
    dqa_table.macrodqa_id,
    dqa_table.dqa_type,
    l.omzone_id,
    omzone_table.macroomzone_id,
    omzone_table.omzone_type,
    l.minsector_id,
    l.location_type,
    l.fluid_type,
    l.custom_length,
    st_length(l.the_geom)::numeric(12,3) AS gis_length,
    l.staticpressure1,
    l.staticpressure2,
    l.annotation,
    l.observ,
    l.comment,
    l.descript,
    l.link,
    l.num_value,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    l.brand_id,
    l.model_id,
    l.verified,
    l.uncertain,
    l.userdefined_geom,
    l.datasource,
    l.is_operative,
        CASE
            WHEN l.sector_id > 0 AND l.is_operative = true AND c.epa_type = 'JUNCTION'::text AND inp_network_mode.value = '4'::text THEN c.epa_type
            ELSE NULL::text
        END AS inp_type,
    l.lock_level,
    l.expl_visibility,
    l.created_at,
    l.created_by,
    l.updated_at,
    l.updated_by,
    l.the_geom,
    COALESCE(pp.state, l.state) AS p_state,
    l.uuid
FROM link l
     LEFT JOIN connec c ON c.connec_id = l.feature_id
     LEFT JOIN LATERAL ( SELECT pp1.connec_id,
            pp1.psector_id
           FROM plan_psector_x_connec pp1
          WHERE (pp1.psector_id IN ( SELECT sp.psector_id
                   FROM selector_psector sp
                  WHERE sp.cur_user = CURRENT_USER)) AND pp1.connec_id = l.feature_id
          ORDER BY pp1.psector_id DESC
         LIMIT 1) last_ps ON true
     LEFT JOIN LATERAL ( SELECT pp2.state
           FROM plan_psector_x_connec pp2
          WHERE pp2.link_id = l.link_id AND pp2.psector_id = last_ps.psector_id
         LIMIT 1) pp ON true
     JOIN sector_table ON sector_table.sector_id = l.sector_id
     JOIN cat_link ON cat_link.id::text = l.linkcat_id::text
     JOIN cat_feature ON cat_feature.id::text = cat_link.link_type::text
     JOIN exploitation ON l.expl_id = exploitation.expl_id
     LEFT JOIN presszone_table ON presszone_table.presszone_id = l.presszone_id
     LEFT JOIN dma_table ON dma_table.dma_id = l.dma_id
     LEFT JOIN dqa_table ON dqa_table.dqa_id = l.dqa_id
     LEFT JOIN supplyzone_table ON supplyzone_table.supplyzone_id = l.supplyzone_id
     LEFT JOIN omzone_table ON omzone_table.omzone_id = l.omzone_id
     LEFT JOIN inp_network_mode ON TRUE
     WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = COALESCE(pp.state, l.state) AND ss.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = l.sector_id AND ssec.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = l.muni_id AND sm.cur_user = CURRENT_USER)
     AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(l.expl_visibility, l.expl_id))) AND se.cur_user = CURRENT_USER);

CREATE OR REPLACE VIEW ve_pol_node
AS SELECT p.pol_id,
    p.feature_id,
    p.featurecat_id,
    p.state,
    p.sys_type,
    p.the_geom,
    p.trace_featuregeom
FROM polygon p
JOIN node n ON p.feature_id = n.node_id
WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = n.state AND ss.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = p.state AND ss.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = n.sector_id AND ssec.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = n.muni_id AND sm.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(n.expl_visibility, n.expl_id))) AND se.cur_user = CURRENT_USER);

CREATE OR REPLACE VIEW ve_pol_connec
AS SELECT p.pol_id,
    p.feature_id,
    p.featurecat_id,
    p.state,
    p.sys_type,
    p.the_geom,
    p.trace_featuregeom
FROM polygon p
JOIN connec c ON p.feature_id = c.connec_id
WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = c.state AND ss.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = p.state AND ss.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = c.sector_id AND ssec.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = c.muni_id AND sm.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(c.expl_visibility, c.expl_id))) AND se.cur_user = CURRENT_USER);


CREATE OR REPLACE VIEW ve_element
AS SELECT e.element_id,
    e.code,
    e.sys_code,
    e.top_elev,
    cat_element.element_type,
    e.elementcat_id,
    e.num_elements,
    e.epa_type,
    e.state,
    e.state_type,
    e.expl_id,
    e.muni_id,
    e.sector_id,
    e.omzone_id,
    e.function_type,
    e.category_type,
    e.location_type,
    e.observ,
    e.comment,
    cat_element.link,
    e.workcat_id,
    e.workcat_id_end,
    e.builtdate,
    e.enddate,
    e.ownercat_id,
    e.brand_id,
    e.model_id,
    e.serial_number,
    e.asset_id,
    e.verified,
    e.datasource,
    e.label_x,
    e.label_y,
    e.label_rotation,
    e.rotation,
    e.inventory,
    e.publish,
    e.trace_featuregeom,
    e.lock_level,
    e.expl_visibility,
    e.created_at,
    e.created_by,
    e.updated_at,
    e.updated_by,
    e.the_geom,
    e.uuid
   FROM element e
   JOIN cat_element ON e.elementcat_id = cat_element.id
   WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = e.state AND ss.cur_user = CURRENT_USER)
   AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = e.sector_id AND ssec.cur_user = CURRENT_USER)
   AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = e.muni_id AND sm.cur_user = CURRENT_USER)
   AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(e.expl_visibility, e.expl_id))) AND se.cur_user = CURRENT_USER);


CREATE OR REPLACE VIEW ve_pol_element
AS SELECT p.pol_id,
    e.element_id,
    p.the_geom,
    p.trace_featuregeom,
    p.featurecat_id,
    p.state,
    p.sys_type
FROM polygon p
JOIN element e ON p.feature_id = e.element_id
WHERE EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = e.state AND ss.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_state ss WHERE ss.state_id = p.state AND ss.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_sector ssec WHERE ssec.sector_id = e.sector_id AND ssec.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_municipality sm WHERE sm.muni_id = e.muni_id AND sm.cur_user = CURRENT_USER)
AND EXISTS (SELECT 1 FROM selector_expl se WHERE (se.expl_id = ANY (array_append(e.expl_visibility, e.expl_id))) AND se.cur_user = CURRENT_USER);



CREATE OR REPLACE VIEW v_om_mincut
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_mincut_result
          WHERE sel_mincut_result.result_id = om_mincut.id)) AND om_mincut.id > 0;

CREATE OR REPLACE VIEW v_om_mincut_initpoint
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id,
            selector_mincut_result.result_type
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om.id,
    om.work_order,
    a.idval AS state,
    b.idval AS class,
    om.mincut_type,
    om.received_date,
    om.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om.macroexpl_id,
    om.muni_id,
    ext_municipality.name AS muni_name,
    om.postcode,
    om.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om.postnumber,
    c.idval AS anl_cause,
    om.anl_tstamp,
    om.anl_user,
    om.anl_descript,
    om.anl_feature_id,
    om.anl_feature_type,
    om.anl_the_geom,
    om.forecast_start,
    om.forecast_end,
    om.assigned_to,
    om.exec_start,
    om.exec_end,
    om.exec_user,
    om.exec_descript,
    om.exec_from_plot,
    om.exec_depth,
    om.exec_appropiate,
    om.notified,
    om.output,
    sm.result_type,
    om.shutoff_required
   FROM om_mincut om
     LEFT JOIN om_typevalue a ON a.id::integer = om.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om.muni_id = ext_municipality.muni_id
     LEFT JOIN sel_mincut_result sm ON sm.result_id = om.id AND om.id > 0;

CREATE OR REPLACE VIEW v_om_mincut_polygon
AS WITH sel_mincut_result AS (
         SELECT selector_mincut_result.result_id
           FROM selector_mincut_result
          WHERE selector_mincut_result.cur_user = CURRENT_USER
        )
 SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    om_mincut.expl_id,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    om_mincut.macroexpl_id,
    om_mincut.muni_id,
    ext_municipality.name AS muni_name,
    om_mincut.postcode,
    om_mincut.streetaxis_id,
    ext_streetaxis.name AS street_name,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.anl_the_geom,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    om_mincut.assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_the_geom,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.polygon_the_geom,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
  WHERE (EXISTS ( SELECT 1
           FROM sel_mincut_result
          WHERE sel_mincut_result.result_id = om_mincut.id)) AND om_mincut.id > 0;

CREATE OR REPLACE VIEW v_ui_mincut
AS SELECT om_mincut.id,
    om_mincut.work_order,
    a.idval AS state,
    b.idval AS class,
    om_mincut.mincut_type,
    om_mincut.received_date,
    exploitation.name AS exploitation,
    ext_municipality.name AS municipality,
    om_mincut.postcode,
    ext_streetaxis.name AS streetaxis,
    om_mincut.postnumber,
    c.idval AS anl_cause,
    om_mincut.anl_tstamp,
    om_mincut.anl_user,
    om_mincut.anl_descript,
    om_mincut.anl_feature_id,
    om_mincut.anl_feature_type,
    om_mincut.forecast_start,
    om_mincut.forecast_end,
    cat_users.name AS assigned_to,
    om_mincut.exec_start,
    om_mincut.exec_end,
    om_mincut.exec_user,
    om_mincut.exec_descript,
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.chlorine,
    om_mincut.turbidity,
    om_mincut.notified,
    om_mincut.output,
    om_mincut.reagent_lot,
    om_mincut.equipment_code,
    om_mincut.shutoff_required
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON exploitation.expl_id = om_mincut.expl_id
     LEFT JOIN macroexploitation ON macroexploitation.macroexpl_id = om_mincut.macroexpl_id
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = om_mincut.muni_id
     LEFT JOIN ext_streetaxis ON ext_streetaxis.id::text = om_mincut.streetaxis_id::text
     LEFT JOIN cat_users ON cat_users.id::text = om_mincut.assigned_to::text
  WHERE om_mincut.id > 0;


CREATE OR REPLACE VIEW v_om_mincut_valve
AS SELECT om_mincut_valve.id,
    om_mincut_valve.result_id,
    om_mincut.work_order,
    om_mincut_valve.node_id,
    om_mincut_valve.closed,
    om_mincut_valve.broken,
    om_mincut_valve.unaccess,
    om_mincut_valve.proposed,
    om_mincut_valve.to_arc,
    om_mincut_valve.the_geom,
    om_mincut_valve.changestatus
   FROM selector_mincut_result,
    om_mincut_valve
     JOIN om_mincut ON om_mincut_valve.result_id = om_mincut.id
  WHERE selector_mincut_result.result_id::text = om_mincut_valve.result_id::text AND selector_mincut_result.cur_user = "current_user"()::text;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias) VALUES(3528, 'gw_fct_get_epa_result_families', 'ws', 'function', 'text, integer', 'json', 'Function to get json with EPA result families.', NULL, NULL, 'core', NULL);


UPDATE config_form_fields
	SET dv_isnullvalue=true
	WHERE formname='generic' AND formtype='form_featuretype_change' AND columnname='fluid_type' AND tabname='tab_none';


UPDATE sys_feature_class SET epa_default = 'JUNCTION' WHERE type IN ('CONNEC');


INSERT INTO sys_param_user (id,formname,descript,sys_role,"label",isenabled,layoutorder,project_type,isparent,isautoupdate,"datatype",widgettype,ismandatory,vdefault,layoutname,iseditable,"source")
VALUES ('inp_options_demand_weight_factor','epaoptions','Use demand in DMA weight factor format','role_epa','Demand weight factor format:',true,(SELECT MAX(layoutorder) + 1 FROM sys_param_user WHERE formname='epaoptions' AND layoutname='lyt_general_2'),'ws',false,false,'boolean','check',true,'FALSE','lyt_general_2',true,'core');

INSERT INTO config_param_user ("parameter", value, cur_user) VALUES('inp_options_demand_weight_factor', 'FALSE', 'postgres') ON CONFLICT DO NOTHING;


UPDATE config_csv SET descript = 'The csv file must contain the following fields: dscenario_name, feature_id, feature_type, value, pattern_id, demand_type, source.' WHERE fid = 501;

UPDATE config_toolbox
	SET inputparams='[
  {
    "label": "Scenario name:",
    "value": "",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "name",
    "widgettype": "text",
    "layoutorder": 1
  },
  {
    "label": "Scenario descript:",
    "value": "",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "descript",
    "widgettype": "text",
    "layoutorder": 2
  },
  {
    "label": "Exploitation:",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": "0",
    "widgetname": "exploitation",
    "widgettype": "combo",
    "dvQueryText": "SELECT expl_id as id, name as idval FROM exploitation where expl_id>0 UNION select 99999 as id, ''ALL'' as idval order by id desc",
    "layoutorder": 4
  },
  {
    "label": "Choose time method:",
    "comboIds": [
      1,
      2
    ],
    "datatype": "text",
    "comboNames": [
      "PERIOD ID",
      "DATE INTERVAL"
    ],
    "layoutname": "grl_option_parameters",
    "widgetname": "patternOrDate",
    "widgettype": "combo",
    "isMandatory": true,
    "layoutorder": 5
  },
  {
    "label": "if PERIOD_ID - Period:",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "selectedId": "1",
    "widgetname": "period",
    "widgettype": "combo",
    "dvQueryText": "SELECT id, code as idval FROM ext_cat_period",
    "layoutorder": 6
  },
  {
    "label": "[if DATE INTERVAL] Source CRM init date:",
    "value": null,
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "initDate",
    "widgettype": "datetime",
    "layoutorder": 7
  },
  {
    "label": "[if DATE INTERVAL] Source CRM end date:",
    "value": "2015-07-30 00:00:00",
    "datatype": "text",
    "layoutname": "grl_option_parameters",
    "widgetname": "endDate",
    "widgettype": "datetime",
    "layoutorder": 8
  },
  {
    "label": "Only hydrometers with waterbal true:",
    "value": null,
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "widgetname": "onlyIsWaterBal",
    "widgettype": "check",
    "layoutorder": 9
  },
  {
    "label": "Feature pattern:",
    "tooltip": "This value will be stored on pattern_id of inp_dscenario_demand table in order to be used on the inp file exportation ONLY with the pattern method FEATURE PATTERN.",
    "comboIds": [
      1,
      2,
      3,
      4,
      5,
      6,
      7
    ],
    "datatype": "text",
    "comboNames": [
      "NONE",
      "SECTOR-DEFAULT",
      "DMA-DEFAULT",
      "DMA-PERIOD",
      "HYDROMETER-PERIOD",
      "HYDROMETER-CATEGORY",
      "FEATURE-PATTERN"
    ],
    "layoutname": "grl_option_parameters",
    "selectedId": "",
    "widgetname": "pattern",
    "widgettype": "combo",
    "layoutorder": 10
  },
  {
    "label": "Demand units:",
    "tooltip": "Choose units to insert volume data on demand column. This value need to be the same that flow units used on EPANET. On the other hand, it is assumed that volume from hydrometer data table is expresed on m3/period and column period_seconds is filled.",
    "comboIds": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "datatype": "text",
    "comboNames": [
      "LPS",
      "LPM",
      "MLD",
      "CMH",
      "CMD",
      "CFS",
      "GPM",
      "MGD",
      "AFD"
    ],
    "layoutname": "grl_option_parameters",
    "selectedId": "",
    "widgetname": "demandUnits",
    "widgettype": "combo",
    "layoutorder": 11
  },
  {
    "label": "Demand as DMA weight factor:",
    "tooltip": "",
    "datatype": "boolean",
    "layoutname": "grl_option_parameters",
    "widgetname": "export_weight",
    "widgettype": "check",
    "layoutorder": 12
  }
]'::json
	WHERE id=3110;


UPDATE config_param_system
SET value='true'
WHERE "parameter"='ignoreBrokenOnlyMassiveMincut';

UPDATE sys_style 
SET styletype='qml', stylevalue='<!DOCTYPE qgis PUBLIC ''http://mrcc.com/qgis.dtd'' ''SYSTEM''>
<qgis styleCategories="Symbology" version="3.40.8-Bratislava">
  <renderer-v2 symbollevels="0" forceraster="0" enableorderby="0" referencescale="-1" type="RuleRenderer">
    <rules key="{fe59b236-7757-4f2f-bf2c-359f48943171}">
      <rule symbol="0" label="Proposed to close" filter="proposed = true" key="{0f18df46-1b7b-40d9-88f3-4fbe45f7bfae}"/>
      <rule symbol="1" label="Proposed unaccess" filter="unaccess = true" key="{22675754-6166-4d98-8a0b-7000f3878811}"/>
      <rule symbol="2" label="Do not operate" filter="unaccess = false AND proposed = false" key="{8c72728b-43dc-40b0-86b1-1ceeeba84852}"/>
      <rule symbol="3" label="Changestatus" filter="changestatus = true" key="{f2a5c437-aed1-485e-95b3-acaf018f5255}"/>
    </rules>
    <symbols>
      <symbol frame_rate="10" force_rhr="0" is_animated="0" name="0" alpha="1" type="marker" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{df6cd293-fef4-4a6e-a813-9711cd93d23a}" enabled="1" pass="0" locked="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="237,55,58,255,rgb:0.92941176470588238,0.21568627450980393,0.22745098039215686,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="134,13,13,255,rgb:0.52549019607843139,0.05098039215686274,0.05098039215686274,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" force_rhr="0" is_animated="0" name="1" alpha="1" type="marker" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{056d6dab-db90-43c2-8c86-e516523aee9a}" enabled="1" pass="0" locked="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="51,160,44,255,rgb:0.20000000000000001,0.62745098039215685,0.17254901960784313,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="6,94,0,255,rgb:0.02352941176470588,0.36862745098039218,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{df6cd293-fef4-4a6e-a813-9711cd93d23a}" enabled="1" pass="0" locked="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="237,55,58,255,rgb:0.92941176470588238,0.21568627450980393,0.22745098039215686,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="203,21,21,255,hsv:0,0.89721522850385294,0.79760433356221871,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="1.8" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" force_rhr="0" is_animated="0" name="2" alpha="1" type="marker" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{adea55e8-1ca0-4555-9fd6-781f98d4f0e8}" enabled="1" pass="0" locked="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="51,160,44,255,rgb:0.20000000000000001,0.62745098039215685,0.17254901960784313,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="6,94,0,255,rgb:0.02352941176470588,0.36862745098039218,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
      <symbol frame_rate="10" force_rhr="0" is_animated="0" name="3" alpha="1" type="marker" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{056d6dab-db90-43c2-8c86-e516523aee9a}" enabled="1" pass="0" locked="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="237,55,58,255,rgb:0.92941176470588238,0.21568627450980393,0.22745098039215686,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="203,21,21,255,hsv:0,0.89721522850385294,0.79760433356221871,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="3.4" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
        <layer id="{df6cd293-fef4-4a6e-a813-9711cd93d23a}" enabled="1" pass="0" locked="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="51,160,44,255,rgb:0.20000000000000001,0.62745098039215685,0.17254901960784313,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="6,94,0,255,rgb:0.02352941176470588,0.36862745098039218,0,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2.2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </symbols>
    <data-defined-properties>
      <Option type="Map">
        <Option value="" name="name" type="QString"/>
        <Option name="properties"/>
        <Option value="collection" name="type" type="QString"/>
      </Option>
    </data-defined-properties>
  </renderer-v2>
  <selection mode="Default">
    <selectionColor invalid="1"/>
    <selectionSymbol>
      <symbol frame_rate="10" force_rhr="0" is_animated="0" name="" alpha="1" type="marker" clip_to_extent="1">
        <data_defined_properties>
          <Option type="Map">
            <Option value="" name="name" type="QString"/>
            <Option name="properties"/>
            <Option value="collection" name="type" type="QString"/>
          </Option>
        </data_defined_properties>
        <layer id="{da497ce3-31a2-4557-88ad-ccd4654886bb}" enabled="1" pass="0" locked="0" class="SimpleMarker">
          <Option type="Map">
            <Option value="0" name="angle" type="QString"/>
            <Option value="square" name="cap_style" type="QString"/>
            <Option value="255,0,0,255,rgb:1,0,0,1" name="color" type="QString"/>
            <Option value="1" name="horizontal_anchor_point" type="QString"/>
            <Option value="bevel" name="joinstyle" type="QString"/>
            <Option value="circle" name="name" type="QString"/>
            <Option value="0,0" name="offset" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="offset_map_unit_scale" type="QString"/>
            <Option value="MM" name="offset_unit" type="QString"/>
            <Option value="35,35,35,255,rgb:0.13725490196078433,0.13725490196078433,0.13725490196078433,1" name="outline_color" type="QString"/>
            <Option value="solid" name="outline_style" type="QString"/>
            <Option value="0" name="outline_width" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="outline_width_map_unit_scale" type="QString"/>
            <Option value="MM" name="outline_width_unit" type="QString"/>
            <Option value="diameter" name="scale_method" type="QString"/>
            <Option value="2" name="size" type="QString"/>
            <Option value="3x:0,0,0,0,0,0" name="size_map_unit_scale" type="QString"/>
            <Option value="MM" name="size_unit" type="QString"/>
            <Option value="1" name="vertical_anchor_point" type="QString"/>
          </Option>
          <data_defined_properties>
            <Option type="Map">
              <Option value="" name="name" type="QString"/>
              <Option name="properties"/>
              <Option value="collection" name="type" type="QString"/>
            </Option>
          </data_defined_properties>
        </layer>
      </symbol>
    </selectionSymbol>
  </selection>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerGeometryType>0</layerGeometryType>
</qgis>', active=true
WHERE layername='v_om_mincut_valve' AND styleconfig_id=101;

CREATE INDEX IF NOT EXISTS node_supplyzone_id_idx ON node USING btree (supplyzone_id);
CREATE INDEX IF NOT EXISTS arc_supplyzone_id_idx ON arc USING btree (supplyzone_id);
CREATE INDEX IF NOT EXISTS connec_supplyzone_id_idx ON connec USING btree (supplyzone_id);
CREATE INDEX IF NOT EXISTS link_supplyzone_id_idx ON link USING btree (supplyzone_id);

ALTER TABLE link ADD CONSTRAINT link_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id);

CREATE INDEX IF NOT EXISTS link_minsector_id_idx ON link USING btree (minsector_id);

DROP INDEX IF EXISTS node_expl_visibility_idx;
DROP INDEX IF EXISTS arc_expl_visibility_idx;
DROP INDEX IF EXISTS connec_expl_visibility_idx;
DROP INDEX IF EXISTS link_expl_visibility_idx;
DROP INDEX IF EXISTS element_expl_visibility_idx;

-- Recreate indexes with gin index
CREATE INDEX node_expl_visibility_gin ON node USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX arc_expl_visibility_gin ON arc USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX connec_expl_visibility_gin ON connec USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX link_expl_visibility_gin ON link USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;
CREATE INDEX element_expl_visibility_gin ON element USING gin(expl_visibility) WHERE expl_visibility IS NOT NULL;

-- Create cat_material trigger on cat_link
CREATE TRIGGER gw_trg_cat_material_fk_insert AFTER INSERT ON cat_link
FOR EACH ROW EXECUTE FUNCTION gw_trg_cat_material_fk('link');

CREATE TRIGGER gw_trg_cat_material_fk_update AFTER UPDATE OF matcat_id ON cat_link
FOR EACH ROW WHEN (((OLD.matcat_id)::TEXT IS DISTINCT
FROM (NEW.matcat_id)::TEXT)) EXECUTE FUNCTION gw_trg_cat_material_fk('link');
