/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 19/12/2025
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
