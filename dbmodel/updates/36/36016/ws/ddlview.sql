/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2024/11/11
CREATE OR REPLACE VIEW v_edit_node AS 
 SELECT a.node_id,
    a.code,
    a.elevation,
    a.depth,
    a.node_type,
    a.sys_type,
    a.nodecat_id,
    a.cat_matcat_id,
    a.cat_pnom,
    a.cat_dnom,
    a.cat_dint,
    a.epa_type,
    a.state,
    a.state_type,
    a.expl_id,
    a.macroexpl_id,
    a.sector_id,
    a.sector_name,
    a.macrosector_id,
    a.sector_type,
    a.presszone_id,
    a.presszone_name,
    a.presszone_type,
    a.presszone_head,
    a.dma_id,
    a.dma_name,
    a.dma_type,
    a.macrodma_id,
    a.dqa_id,
    a.dqa_name,
    a.dqa_type,
    a.macrodqa_id,
    a.arc_id,
    a.parent_id,
    a.annotation,
    a.observ,
    a.comment,
    a.staticpressure,
    a.soilcat_id,
    a.function_type,
    a.category_type,
    a.fluid_type,
    a.location_type,
    a.workcat_id,
    a.workcat_id_end,
    a.workcat_id_plan,
    a.builtdate,
    a.enddate,
    a.buildercat_id,
    a.ownercat_id,
    a.muni_id,
    a.postcode,
    a.district_id,
    a.streetname,
    a.postnumber,
    a.postcomplement,
    a.streetname2,
    a.postnumber2,
    a.postcomplement2,
    a.region_id,
    a.province_id,
    a.descript,
    a.svg,
    a.rotation,
    a.link,
    a.verified,
    a.undelete,
    a.label,
    a.label_x,
    a.label_y,
    a.label_rotation,
    a.label_quadrant,
    a.publish,
    a.inventory,
    a.hemisphere,
    a.num_value,
    a.adate,
    a.adescript,
    a.accessibility,
    a.dma_style,
    a.presszone_style,
    a.asset_id,
    a.om_state,
    a.conserv_state,
    a.access_type,
    a.placement_type,
    a.expl_id2,
    a.is_operative,
    a.brand_id,
    a.model_id,
    a.serial_number,
    a.minsector_id,
    a.macrominsector_id,
    a.demand_max,
    a.demand_min,
    a.demand_avg,
    a.press_max,
    a.press_min,
    a.press_avg,
    a.head_max,
    a.head_min,
    a.head_avg,
    a.quality_max,
    a.quality_min,
    a.quality_avg,
    a.tstamp,
    a.insert_user,
    a.lastupdate,
    a.lastupdate_user,
    a.the_geom,
        CASE
            WHEN s.sector_id > 0 AND a.is_operative = true AND a.epa_type::text <> 'UNDEFINED'::character varying(16)::text THEN a.epa_type
            ELSE NULL::character varying(16)
        END AS inp_type,
    v.closed AS closed_valve,
    v.broken AS broken_valve
   FROM ( SELECT n.node_id,
            n.code,
            n.elevation,
            n.depth,
            n.node_type,
            n.sys_type,
            n.nodecat_id,
            n.cat_matcat_id,
            n.cat_pnom,
            n.cat_dnom,
            n.cat_dint,
            n.epa_type,
            n.state,
            n.state_type,
            n.expl_id,
            n.macroexpl_id,
            n.sector_id,
            n.sector_name,
            n.macrosector_id,
            n.sector_type,
            n.presszone_id,
            n.presszone_name,
            n.presszone_type,
            n.presszone_head,
            n.dma_id,
            n.dma_name,
            n.dma_type,
            n.macrodma_id,
            n.dqa_id,
            n.dqa_name,
            n.dqa_type,
            n.macrodqa_id,
            n.arc_id,
            n.parent_id,
            n.annotation,
            n.observ,
            n.comment,
            n.staticpressure,
            n.soilcat_id,
            n.function_type,
            n.category_type,
            n.fluid_type,
            n.location_type,
            n.workcat_id,
            n.workcat_id_end,
            n.workcat_id_plan,
            n.builtdate,
            n.enddate,
            n.buildercat_id,
            n.ownercat_id,
            n.muni_id,
            n.postcode,
            n.district_id,
            n.streetname,
            n.postnumber,
            n.postcomplement,
            n.streetname2,
            n.postnumber2,
            n.postcomplement2,
            n.region_id,
            n.province_id,
            n.descript,
            n.svg,
            n.rotation,
            n.link,
            n.verified,
            n.undelete,
            n.label,
            n.label_x,
            n.label_y,
            n.label_rotation,
            n.label_quadrant,
            n.publish,
            n.inventory,
            n.hemisphere,
            n.num_value,
            n.adate,
            n.adescript,
            n.accessibility,
            n.dma_style,
            n.presszone_style,
            n.asset_id,
            n.om_state,
            n.conserv_state,
            n.access_type,
            n.placement_type,
            n.expl_id2,
            n.is_operative,
            n.brand_id,
            n.model_id,
            n.serial_number,
            n.minsector_id,
            n.macrominsector_id,
            n.demand_max,
            n.demand_min,
            n.demand_avg,
            n.press_max,
            n.press_min,
            n.press_avg,
            n.head_max,
            n.head_min,
            n.head_avg,
            n.quality_max,
            n.quality_min,
            n.quality_avg,
            n.tstamp,
            n.insert_user,
            n.lastupdate,
            n.lastupdate_user,
            n.the_geom
           FROM ( SELECT selector_expl.expl_id
                   FROM selector_expl
                  WHERE selector_expl.cur_user = CURRENT_USER::text) s_1,
            vu_node n
             JOIN v_state_node USING (node_id)
          WHERE n.expl_id = s_1.expl_id OR n.expl_id2 = s_1.expl_id) a
     LEFT JOIN man_valve v USING (node_id)
     JOIN selector_sector s USING (sector_id)
     LEFT JOIN selector_municipality m USING (muni_id)
  WHERE s.cur_user = CURRENT_USER AND (m.cur_user = CURRENT_USER OR a.muni_id IS NULL);


CREATE OR REPLACE VIEW v_ui_dma
AS SELECT d.dma_id,
    d.name,
    d.descript,
    d.expl_id,
    md.name AS macrodma,
    d.active,
    d.undelete,
    d.minc,
    d.maxc,
    d.effc,
    d.avg_press,
    d.pattern_id,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user
   FROM selector_expl s, dma d
   	   LEFT JOIN macrodma md ON md.macrodma_id = d.macrodma_id
  WHERE d.dma_id > 0 
  and s.expl_id = d.expl_id and s.cur_user = current_user
  ORDER BY d.dma_id;
  
 
 CREATE OR REPLACE VIEW v_ui_sector
AS SELECT s.sector_id,
    s.name,
    ms.name AS macrosector,
    s.descript,
    s.undelete,
    s.sector_type,
    s.active,
    s.parent_id,
    s.pattern_id,
    s.tstamp,
    s.insert_user,
    s.lastupdate,
    s.lastupdate_user,
    s.graphconfig,
    s.stylesheet
   FROM selector_sector ss, sector s
     LEFT JOIN macrosector ms ON ms.macrosector_id = s.macrosector_id
  WHERE s.sector_id > 0
  and ss.sector_id = s.sector_id and ss.cur_user = current_user
  ORDER BY s.sector_id;
  
 
 CREATE OR REPLACE VIEW v_ui_presszone
AS SELECT presszone_id,
    name,
    descript,
    p.expl_id,
    link,
    head,
    active,
    graphconfig,
    stylesheet,
    tstamp,
    insert_user,
    lastupdate,
    lastupdate_user
   FROM selector_expl s, presszone p
  WHERE presszone_id::text <> ALL (ARRAY['0'::character varying, '-1'::character varying]::text[])
  and s.expl_id = p.expl_id and s.cur_user = current_user
  ORDER BY presszone_id;
  
 
CREATE OR REPLACE VIEW v_ui_dqa
AS SELECT d.dqa_id,
    d.name,
    d.descript,
    d.expl_id,
    md.name AS macrodma,
    d.active,
    d.undelete,
    d.the_geom,
    d.pattern_id,
    d.dqa_type,
    d.link,
    d.graphconfig,
    d.stylesheet,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user
   FROM selector_expl s, dqa d
     LEFT JOIN macrodqa md ON md.macrodqa_id = d.macrodqa_id
  WHERE d.dqa_id > 0
  and s.expl_id = d.expl_id and s.cur_user = current_user
  ORDER BY d.dqa_id;


CREATE OR REPLACE VIEW v_edit_macrosector
AS SELECT distinct on (macrosector_id) macrosector_id,
    m.name,
    m.descript,
    m.the_geom,
    m.undelete,
    m.active
   FROM selector_sector ss, macrosector m left join sector s using (macrosector_id) 
   where (ss.sector_id = s.sector_id and cur_user = current_user or s.macrosector_id is null)
   and m.active is true;

   
CREATE OR REPLACE VIEW v_edit_macroexploitation
AS SELECT distinct  on (macroexpl_id) m.*
   FROM selector_expl ss, macroexploitation m join exploitation s using (macroexpl_id) 
   where (ss.expl_id = s.expl_id and cur_user = current_user or s.macroexpl_id is null)
   and m.active is true;

-- 20/11/2024
CREATE OR REPLACE VIEW vu_link
AS WITH typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'presszone_type'::character varying::text, 'dma_type'::character varying::text, 'dqa_type'::character varying::text])
        ),
        inp_netw_mode AS (
         WITH inp_netw_mode_aux AS (
                 SELECT count(*) AS t
                   FROM config_param_user
                  WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
                )
         SELECT
                CASE
                    WHEN inp_netw_mode_aux.t > 0 THEN ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER)
                    ELSE NULL::text
                END AS value
           FROM inp_netw_mode_aux
        )
 SELECT l.link_id,
    l.feature_type,
    l.feature_id,
    l.exit_type,
    l.exit_id,
    l.state,
    l.expl_id,
    l.sector_id,
    s.name AS sector_name,
    et1.idval::character varying(16) AS sector_type,
    s.macrosector_id,
    presszone_id::character varying(16) AS presszone_id,
    p.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    p.head AS presszone_head,
    l.dma_id,
    d.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    d.macrodma_id,
    l.dqa_id,
    q.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    q.macrodqa_id,
    l.exit_topelev,
    l.exit_elev,
    l.fluid_type,
    st_length2d(l.the_geom)::numeric(12,3) AS gis_length,
    l.the_geom,
    l.muni_id,
    l.expl_id2,
    l.epa_type,
    l.is_operative,
    l.staticpressure,
    l.connecat_id,
    l.workcat_id,
    l.workcat_id_end,
    l.builtdate,
    l.enddate,
    date_trunc('second'::text, l.lastupdate) AS lastupdate,
    l.lastupdate_user,
    l.uncertain,
    l.minsector_id,
    l.macrominsector_id,
        CASE
            WHEN l.sector_id > 0 AND l.is_operative = true AND l.epa_type::text = 'JUNCTION'::character varying(16)::text AND cpu.value = '4'::text THEN l.epa_type::character varying
            ELSE NULL::character varying(16)
        END AS inp_type
   FROM ( SELECT inp_netw_mode.value FROM inp_netw_mode) cpu,
    link l
     LEFT JOIN sector s USING (sector_id)
     LEFT JOIN presszone p USING (presszone_id)
     LEFT JOIN dma d USING (dma_id)
     LEFT JOIN dqa q USING (dqa_id)
     LEFT JOIN typevalue et1 ON et1.id::text = s.sector_type::text AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = p.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = d.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = q.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;


CREATE OR REPLACE VIEW vu_connec
AS WITH streetaxis AS (
         SELECT v_ext_streetaxis.id,
            v_ext_streetaxis.descript
           FROM v_ext_streetaxis
        ), typevalue AS (
         SELECT edit_typevalue.typevalue,
            edit_typevalue.id,
            edit_typevalue.idval
           FROM edit_typevalue
          WHERE edit_typevalue.typevalue::text = ANY (ARRAY['sector_type'::character varying::text, 'presszone_type'::character varying::text, 'dma_type'::character varying::text, 'dqa_type'::character varying::text])
        ), inp_netw_mode AS (
         WITH inp_netw_mode_aux AS (
                 SELECT count(*) AS t
                   FROM config_param_user
                  WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER
                )
         SELECT
                CASE
                    WHEN inp_netw_mode_aux.t > 0 THEN ( SELECT config_param_user.value
                       FROM config_param_user
                      WHERE config_param_user.parameter::text = 'inp_options_networkmode'::text AND config_param_user.cur_user::text = CURRENT_USER)
                    ELSE NULL::text
                END AS value
           FROM inp_netw_mode_aux
        )
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id AS connec_type,
    cat_feature.system_id AS sys_type,
    connec.connecat_id,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    cat_connec.dint AS cat_dint,
    connec.epa_type,
    connec.state,
    connec.state_type,
    connec.expl_id,
    exploitation.macroexpl_id,
    connec.sector_id,
    sector.name AS sector_name,
    sector.macrosector_id,
    et1.idval::character varying(16) AS sector_type,
    connec.presszone_id,
    presszone.name AS presszone_name,
    et2.idval::character varying(16) AS presszone_type,
    presszone.head AS presszone_head,
    connec.dma_id,
    dma.name AS dma_name,
    et3.idval::character varying(16) AS dma_type,
    dma.macrodma_id,
    connec.dqa_id,
    dqa.name AS dqa_name,
    et4.idval::character varying(16) AS dqa_type,
    dqa.macrodqa_id,
    connec.crmzone_id,
    crm_zone.name AS crmzone_name,
    connec.customer_code,
    connec.connec_length,
    connec.n_hydrometer,
    connec.arc_id,
    connec.annotation,
    connec.observ,
    connec.comment,
    connec.staticpressure,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.workcat_id_plan,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.district_id,
    c.descript::character varying(100) AS streetname,
    connec.postnumber,
    connec.postcomplement,
    b.descript::character varying(100) AS streetname2,
    connec.postnumber2,
    connec.postcomplement2,
    mu.region_id,
    mu.province_id,
    connec.descript,
    cat_connec.svg,
    connec.rotation,
    concat(cat_feature.link_path, connec.link) AS link,
    connec.verified,
    connec.undelete,
    cat_connec.label,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.label_quadrant,
    connec.publish,
    connec.inventory,
    connec.num_value,
    connec.pjoint_id,
    connec.pjoint_type,
    connec.adate,
    connec.adescript,
    connec.accessibility,
    dma.stylesheet ->> 'featureColor'::text AS dma_style,
    presszone.stylesheet ->> 'featureColor'::text AS presszone_style,
    connec.asset_id,
    connec.om_state,
    connec.conserv_state,
    connec.priority,
    connec.valve_location,
    connec.valve_type,
    connec.shutoff_valve,
    connec.access_type,
    connec.placement_type,
    connec.expl_id2,
    vst.is_operative,
    connec.plot_code,
        CASE
            WHEN connec.brand_id IS NULL THEN cat_connec.brand_id
            ELSE connec.brand_id
        END AS brand_id,
        CASE
            WHEN connec.model_id IS NULL THEN cat_connec.model_id
            ELSE connec.model_id
        END AS model_id,
    connec.serial_number,
    connec.cat_valve,
    connec.minsector_id,
    connec.macrominsector_id,
    e.demand,
    e.press_max,
    e.press_min,
    e.press_avg,
    e.quality_max,
    e.quality_min,
    e.quality_avg,
    date_trunc('second'::text, connec.tstamp) AS tstamp,
    connec.insert_user,
    date_trunc('second'::text, connec.lastupdate) AS lastupdate,
    connec.lastupdate_user,
    connec.the_geom,
        CASE
            WHEN connec.sector_id > 0 AND vst.is_operative = true AND connec.epa_type = 'JUNCTION'::character varying(16)::text AND cpu.value = '4'::text THEN connec.epa_type::character varying
            ELSE NULL::character varying(16)
        END AS inp_type
   FROM (SELECT inp_netw_mode.value FROM inp_netw_mode) cpu,
    connec
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN cat_feature ON cat_feature.id::text = cat_connec.connectype_id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id
     LEFT JOIN presszone ON presszone.presszone_id::text = connec.presszone_id::text
     LEFT JOIN crm_zone ON crm_zone.id::text = connec.crmzone_id::text
     LEFT JOIN streetaxis c ON c.id::text = connec.streetaxis_id::text
     LEFT JOIN streetaxis b ON b.id::text = connec.streetaxis2_id::text
     LEFT JOIN connec_add e ON e.connec_id::text = connec.connec_id::text
     LEFT JOIN value_state_type vst ON vst.id = connec.state_type
     LEFT JOIN ext_municipality mu ON connec.muni_id = mu.muni_id
     LEFT JOIN typevalue et1 ON et1.id::text = sector.sector_type::text AND et1.typevalue::text = 'sector_type'::text
     LEFT JOIN typevalue et2 ON et2.id::text = presszone.presszone_type AND et2.typevalue::text = 'presszone_type'::text
     LEFT JOIN typevalue et3 ON et3.id::text = dma.dma_type::text AND et3.typevalue::text = 'dma_type'::text
     LEFT JOIN typevalue et4 ON et4.id::text = dqa.dqa_type::text AND et4.typevalue::text = 'dqa_type'::text;


CREATE OR REPLACE VIEW v_om_mincut_current_arc
AS SELECT om_mincut_arc.id,
    om_mincut_arc.result_id,
    om_mincut.work_order,
    om_mincut_arc.arc_id,
    om_mincut_arc.the_geom
   FROM om_mincut_arc
     JOIN om_mincut ON om_mincut_arc.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;
 
 
CREATE OR REPLACE VIEW v_om_mincut_current_connec
AS SELECT om_mincut_connec.id,
    om_mincut_connec.result_id,
    om_mincut.work_order,
    om_mincut_connec.connec_id,
    om_mincut_connec.customer_code,
    om_mincut_connec.the_geom
   FROM om_mincut_connec
     JOIN om_mincut ON om_mincut_connec.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;
  
 
 CREATE OR REPLACE VIEW v_om_mincut_current_hydrometer
AS SELECT om_mincut_hydrometer.id,
    om_mincut_hydrometer.result_id,
    om_mincut.work_order,
    om_mincut_hydrometer.hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
    rtc_hydrometer_x_connec.connec_id,
    connec.code AS connec_code
   FROM om_mincut_hydrometer
     JOIN ext_rtc_hydrometer ON om_mincut_hydrometer.hydrometer_id::text = ext_rtc_hydrometer.id::text
     JOIN rtc_hydrometer_x_connec ON om_mincut_hydrometer.hydrometer_id::text = rtc_hydrometer_x_connec.hydrometer_id::text
     JOIN connec ON rtc_hydrometer_x_connec.connec_id::text = connec.connec_id::text
     JOIN om_mincut ON om_mincut_hydrometer.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;
  
 
CREATE OR REPLACE VIEW v_om_mincut_current_node
AS SELECT om_mincut_node.id,
    om_mincut_node.result_id,
    om_mincut.work_order,
    om_mincut_node.node_id,
    om_mincut_node.node_type,
    om_mincut_node.the_geom
   FROM om_mincut_node
     JOIN om_mincut ON om_mincut_node.result_id = om_mincut.id
  WHERE om_mincut.mincut_state = 1;
  
  
CREATE OR REPLACE VIEW v_om_mincut_current_initpoint
AS SELECT om_mincut.id,
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
    om_mincut.exec_from_plot,
    om_mincut.exec_depth,
    om_mincut.exec_appropiate,
    om_mincut.notified,
    om_mincut.output
   FROM om_mincut
     LEFT JOIN om_typevalue a ON a.id::integer = om_mincut.mincut_state AND a.typevalue = 'mincut_state'::text
     LEFT JOIN om_typevalue b ON b.id::integer = om_mincut.mincut_class AND b.typevalue = 'mincut_class'::text
     LEFT JOIN om_typevalue c ON c.id::integer = om_mincut.anl_cause::integer AND c.typevalue = 'mincut_cause'::text
     LEFT JOIN exploitation ON om_mincut.expl_id = exploitation.expl_id
     LEFT JOIN ext_streetaxis ON om_mincut.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN macroexploitation ON om_mincut.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_municipality ON om_mincut.muni_id = ext_municipality.muni_id
    WHERE om_mincut.mincut_state = 1;


CREATE OR REPLACE VIEW v_edit_sector
AS SELECT vu_sector.sector_id,
    vu_sector.name,
    vu_sector.macrosector_id,
    vu_sector.macrosector_name,
    vu_sector.idval,
    vu_sector.descript,
    vu_sector.parent_id,
    vu_sector.pattern_id,
    vu_sector.graphconfig,
    vu_sector.stylesheet,
    vu_sector.link,
    vu_sector.avg_press,
    vu_sector.active,
    vu_sector.undelete,
    vu_sector.tstamp,
    vu_sector.insert_user,
    vu_sector.lastupdate,
    vu_sector.lastupdate_user,
    case when active is true then vu_sector.the_geom else null::geometry(MultiPolygon,SRID_VALUE) end the_geom
   FROM vu_sector, selector_sector
  WHERE vu_sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;
