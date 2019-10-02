/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP VIEW IF EXISTS v_rtc_dma_parameter_period;
DROP VIEW IF EXISTS v_rtc_dma_hydrometer_period;
DROP VIEW IF EXISTS v_rtc_hydrometer_x_node_period;
DROP VIEW IF EXISTS v_rtc_hydrometer_period;

CREATE OR REPLACE VIEW SCHEMA_NAME.vi_parent_arc AS 
SELECT ve_arc.*
FROM ve_arc, inp_selector_sector 
WHERE ve_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW SCHEMA_NAME.vi_parent_node as
SELECT DISTINCT ON (node_id) ve_node.*
FROM ve_node
JOIN vi_parent_arc a ON a.node_1::text = ve_node.node_id::text OR a.node_2::text = ve_node.node_id::text;



CREATE OR REPLACE VIEW v_rtc_hydrometer AS 
 SELECT ext_rtc_hydrometer.id::text AS hydrometer_id,
    ext_rtc_hydrometer.code AS hydrometer_customer_code,
        CASE
            WHEN connec.connec_id IS NULL THEN 'XXXX'::character varying
            ELSE connec.connec_id
        END AS connec_id,
        CASE
            WHEN ext_rtc_hydrometer.connec_id::text IS NULL THEN 'XXXX'::text
            ELSE ext_rtc_hydrometer.connec_id::text
        END AS connec_customer_code,
    ext_rtc_hydrometer_state.name AS state,
    ext_municipality.name AS muni_name,
    connec.expl_id,
    exploitation.name AS expl_name,
    ext_rtc_hydrometer.plot_code,
    ext_rtc_hydrometer.priority_id,
    ext_rtc_hydrometer.catalog_id,
    ext_rtc_hydrometer.category_id,
    ext_rtc_hydrometer.hydro_number,
    ext_rtc_hydrometer.hydro_man_date,
    ext_rtc_hydrometer.crm_number,
    ext_rtc_hydrometer.customer_name,
    ext_rtc_hydrometer.address1,
    ext_rtc_hydrometer.address2,
    ext_rtc_hydrometer.address3,
    ext_rtc_hydrometer.address2_1,
    ext_rtc_hydrometer.address2_2,
    ext_rtc_hydrometer.address2_3,
    ext_rtc_hydrometer.m3_volume,
    ext_rtc_hydrometer.start_date,
    ext_rtc_hydrometer.end_date,
    ext_rtc_hydrometer.update_date,
        CASE
            WHEN (( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text)) IS NULL THEN rtc_hydrometer.link
            ELSE concat(( SELECT config_param_system.value
               FROM config_param_system
              WHERE config_param_system.parameter::text = 'hydrometer_link_absolute_path'::text), rtc_hydrometer.link)
        END AS hydrometer_link
   FROM selector_hydrometer, selector_expl, rtc_hydrometer
     LEFT JOIN ext_rtc_hydrometer ON ext_rtc_hydrometer.id::text = rtc_hydrometer.hydrometer_id::text
     JOIN ext_rtc_hydrometer_state ON ext_rtc_hydrometer_state.id = ext_rtc_hydrometer.state_id
     JOIN connec ON connec.customer_code::text = ext_rtc_hydrometer.connec_id::text
     LEFT JOIN ext_municipality ON ext_municipality.muni_id = connec.muni_id
     LEFT JOIN exploitation ON exploitation.expl_id = connec.expl_id
     WHERE selector_hydrometer.state_id = ext_rtc_hydrometer.state_id AND selector_hydrometer.cur_user = "current_user"()::text
     AND selector_expl.expl_id = connec.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_rtc_hydrometer_x_arc CASCADE;

drop view if exists v_rtc_period_hydrometer cascade;   
CREATE OR REPLACE VIEW v_rtc_period_hydrometer AS 
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN rpt_inp_arc ON v_edit_connec.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_edit_connec.dma_id
  WHERE 
	ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_arc.result_id::text = ((( SELECT inp_selector_result.result_id
           FROM inp_selector_result
          WHERE inp_selector_result.cur_user = "current_user"()::text))::text)

UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    rpt_inp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN rpt_inp_node ON concat('VN', v_edit_connec.pjoint_id) = rpt_inp_node.node_id::text
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE 
pjoint_type='VNODE' AND 
  ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_node.result_id::text = ((( SELECT inp_selector_result.result_id
           FROM inp_selector_result
          WHERE inp_selector_result.cur_user = "current_user"()::text))::text)
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_edit_connec.connec_id,
    rpt_inp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_edit_connec ON v_edit_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN rpt_inp_node ON v_edit_connec.pjoint_id::text = rpt_inp_node.node_id::text
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_edit_connec.dma_id::text = c.dma_id::text
  WHERE 
 pjoint_type='NODE' AND 

  ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_node.result_id::text = ((( SELECT inp_selector_result.result_id
           FROM inp_selector_result
          WHERE inp_selector_result.cur_user = "current_user"()::text))::text);
		  
  
drop view if exists v_rtc_period_dma;
CREATE OR REPLACE VIEW v_rtc_period_dma AS 
SELECT v_rtc_period_hydrometer.dma_id::integer AS dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period
    ,a.pattern_id
   FROM v_rtc_period_hydrometer
     JOIN ext_rtc_scada_dma_period a ON  a.dma_id=v_rtc_period_hydrometer.dma_id AND v_rtc_period_hydrometer.period_id=a.cat_period_id
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;

  

CREATE OR REPLACE VIEW v_rtc_period_node AS 
SELECT node_id, dma_id, period_id, sum(lps_avg) as lps_avg, effc, sum(lps_avg_real) as lps_avg_real, minc, sum(lps_min) as lps_min, maxc, sum(lps_max) as lps_max, sum(m3_total_period) m3_total_period FROM (
 SELECT v_rtc_period_hydrometer.node_1 AS node_id,
    v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
    v_rtc_period_hydrometer.effc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
    v_rtc_period_hydrometer.minc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
    v_rtc_period_hydrometer.maxc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
    sum(v_rtc_period_hydrometer.m3_total_period * 0.5) AS m3_total_period
   FROM v_rtc_period_hydrometer
  WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
  GROUP BY v_rtc_period_hydrometer.node_1, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc
UNION
 SELECT v_rtc_period_hydrometer.node_2 AS node_id,
    v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
    v_rtc_period_hydrometer.effc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
    v_rtc_period_hydrometer.minc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
    v_rtc_period_hydrometer.maxc,
    sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
    sum(v_rtc_period_hydrometer.m3_total_period * 0.5) AS m3_total_period
   FROM v_rtc_period_hydrometer
  WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
  GROUP BY v_rtc_period_hydrometer.node_2, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc) a
 GROUP BY node_id, period_id, dma_id, effc, minc, maxc;


 
CREATE OR REPLACE VIEW v_rtc_period_pjoint AS 
 SELECT 
    pjoint_id, 
    v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.lps_avg::double precision) AS lps_avg,
    v_rtc_period_hydrometer.effc,
    sum(v_rtc_period_hydrometer.lps_avg::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
    v_rtc_period_hydrometer.minc,
    sum(v_rtc_period_hydrometer.lps_avg::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
    v_rtc_period_hydrometer.maxc,
    sum(v_rtc_period_hydrometer.lps_avg::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
    sum(m3_total_period) as m3_total_period
   FROM v_rtc_period_hydrometer
   WHERE pjoint_id IS NOT NULL
  GROUP BY v_rtc_period_hydrometer.pjoint_id,v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc;
  
  
CREATE OR REPLACE VIEW v_plan_current_psector AS 
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
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
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
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
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
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
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
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom,
    d.suma AS affec_length,
    e.suma AS plan_length,
    f.suma AS current_length
   FROM plan_psector
     JOIN plan_psector_selector ON plan_psector.psector_id = plan_psector_selector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM v_plan_psector_x_arc
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.total_budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM v_plan_psector_x_node
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(st_length2d(arc.the_geom)::numeric(12,2)) AS suma,
            pa.psector_id
           FROM arc
             JOIN plan_psector_x_arc pa USING (arc_id)
          WHERE pa.state = 0 AND pa.doable = false AND (pa.addparam->>'arcDivide' != 'parent' OR pa.addparam->>'arcDivide' IS NULL) OR arc.state_type = ((( SELECT config_param_system.value
                   FROM config_param_system
                  WHERE config_param_system.parameter::text = 'plan_statetype_reconstruct'::text))::smallint)
          GROUP BY pa.psector_id) d ON d.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(st_length2d(arc.the_geom)::numeric(12,2)) AS suma,
            pa.psector_id
           FROM arc
             JOIN plan_psector_x_arc pa USING (arc_id)
          WHERE pa.state = 1 AND pa.doable = true
          GROUP BY pa.psector_id) e ON e.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(st_length2d(arc.the_geom)::numeric(12,2)) AS suma,
            pa.psector_id
           FROM arc
             JOIN plan_psector_x_arc pa USING (arc_id)
          WHERE pa.state = 1 AND pa.doable = false
          GROUP BY pa.psector_id) f ON f.psector_id = plan_psector.psector_id
  WHERE plan_psector_selector.cur_user = "current_user"()::text;
  
  
CREATE OR REPLACE VIEW v_plan_psector_arc_affect AS 
SELECT pa.arc_id, pa.psector_id, a.the_geom, pa.state, pa.doable, pa.descript, vst.name
FROM selector_psector, plan_psector_x_arc pa
JOIN arc a USING (arc_id)
JOin value_state_type vst ON vst.id=a.state_type 
WHERE ((pa.state=0 AND pa.doable=FALSE 
AND (pa.addparam->>'arcDivide' != 'parent' OR pa.addparam->>'arcDivide' IS NULL))
OR (a.state_type = ( SELECT config_param_system.value FROM config_param_system WHERE config_param_system.parameter = 'plan_statetype_reconstruct')::smallint))
AND  pa.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;
COMMENT ON VIEW v_plan_psector_arc_affect is 'Return the arcs which will be removed by a psector. Arcs divided by a node to generate ficticius will not count. 
Arcs with state_type=RECONSTRUCT will be considered because geometry do not change but old arc are removed. Be careful with plan_statetype_reconstruct
variable, it must be configured correctly. Filtered by psector selector';


CREATE OR REPLACE VIEW v_plan_psector_arc_current AS 
SELECT pa.arc_id, pa.psector_id, a.the_geom, pa.state, pa.doable, pa.descript, vst.name 
FROM selector_psector, plan_psector_x_arc pa
JOIN arc a USING (arc_id)
JOin value_state_type vst ON vst.id=a.state_type 
WHERE pa.state=1 AND pa.doable=FALSE
AND  pa.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;
COMMENT ON VIEW v_plan_psector_arc_current is 'Return ficticius arcs created by arc division in a psector. They will be considered current arcs because its geometry already exists in real network.
 Ficticius arcs means: state in the psector=1 and doable=FALSE. Filtered by psector selector';

CREATE OR REPLACE VIEW v_plan_psector_arc_planif AS 
SELECT pa.arc_id, pa.psector_id, a.the_geom, pa.state, pa.doable, pa.descript, vst.name
FROM selector_psector, plan_psector_x_arc pa
JOIN arc a USING (arc_id)
JOIN value_state_type vst ON a.state_type = vst.id
WHERE pa.state=1 AND pa.doable=TRUE
AND  pa.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;
COMMENT ON VIEW v_plan_psector_arc_planif is 'Return the arcs which will be new in a psector. New arcs means: state in the psector=1 and doable=TRUE. Filtered by psector selector';

CREATE OR REPLACE VIEW v_ui_om_visit_lot AS 
 SELECT om_visit_lot.id,
    om_visit_lot.startdate,
    om_visit_lot.enddate,
    om_visit_lot.real_startdate,
    om_visit_lot.real_enddate,
    om_visit_class.idval AS visitclass_id,
    om_visit_lot.descript,
    cat_team.idval AS team_id,
    om_visit_lot.duration,
    om_typevalue.idval AS status,
    om_visit_lot.class_id,
    om_visit_lot.exercice,
    om_visit_lot.serie,
    ext_workorder.wotype_id,
    ext_workorder.wotype_name,
    om_visit_lot.adreca,
    om_visit_lot.feature_type
   FROM om_visit_lot
     LEFT JOIN ext_workorder ON ext_workorder.serie::text = om_visit_lot.serie::text
     LEFT JOIN om_visit_class ON om_visit_class.id = om_visit_lot.visitclass_id
     LEFT JOIN cat_team ON cat_team.id = om_visit_lot.team_id
     LEFT JOIN om_typevalue ON om_typevalue.id = om_visit_lot.status AND om_typevalue.typevalue = 'lot_cat_status'::text;

     
 CREATE OR REPLACE VIEW v_res_lot_x_user AS 
 SELECT om_visit_lot_x_user.id,
    om_visit_lot_x_user.user_id,
    om_visit_lot_x_user.team_id,
    om_visit_lot_x_user.lot_id,
    om_visit_lot_x_user.starttime,
    om_visit_lot_x_user.endtime,
    (om_visit_lot_x_user.endtime - om_visit_lot_x_user.starttime)::text AS duration,
    om_visit_lot.the_geom
   FROM selector_date, om_visit_lot_x_user
    JOIN om_visit_lot ON om_visit_lot.id=om_visit_lot_x_user.lot_id
  WHERE "overlaps"(om_visit_lot_x_user.starttime, om_visit_lot_x_user.starttime, selector_date.from_date, selector_date.to_date) AND selector_date.cur_user = "current_user"()::text;
  
DROP VIEW IF EXISTS ve_lot_x_arc;
CREATE OR REPLACE VIEW ve_lot_x_arc AS 
 SELECT row_number() OVER (ORDER BY om_visit_lot_x_arc.lot_id, arc.arc_id) AS rid,
    arc.arc_id,
    lower(arc.feature_type::text) AS feature_type,
    arc.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_arc.lot_id,
    om_visit_lot_x_arc.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_arc.observ,
    arc.the_geom
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_arc ON om_visit_lot_x_arc.lot_id = om_visit_lot.id
     JOIN arc ON arc.arc_id::text = om_visit_lot_x_arc.arc_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id = om_visit_lot_x_arc.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS ve_lot_x_node;
CREATE OR REPLACE VIEW ve_lot_x_node AS 
 SELECT row_number() OVER (ORDER BY om_visit_lot_x_node.lot_id, node.node_id) AS rid,
    node.node_id,
    lower(node.feature_type::text) AS feature_type,
    node.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_node.lot_id,
    om_visit_lot_x_node.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_node.observ,
    node.the_geom
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_node ON om_visit_lot_x_node.lot_id = om_visit_lot.id
     JOIN node ON node.node_id::text = om_visit_lot_x_node.node_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id = om_visit_lot_x_node.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS ve_lot_x_connec;
CREATE OR REPLACE VIEW ve_lot_x_connec AS 
 SELECT row_number() OVER (ORDER BY om_visit_lot_x_connec.lot_id, connec.connec_id) AS rid,
    connec.connec_id,
    lower(connec.feature_type::text) AS feature_type,
    connec.code,
    om_visit_lot.visitclass_id,
    om_visit_lot_x_connec.lot_id,
    om_visit_lot_x_connec.status,
    om_typevalue.idval AS status_name,
    om_visit_lot_x_connec.observ,
    connec.the_geom
   FROM selector_lot,
    om_visit_lot
     JOIN om_visit_lot_x_connec ON om_visit_lot_x_connec.lot_id = om_visit_lot.id
     JOIN connec ON connec.connec_id::text = om_visit_lot_x_connec.connec_id::text
     LEFT JOIN om_typevalue ON om_typevalue.id = om_visit_lot_x_connec.status AND om_typevalue.typevalue = 'lot_x_feature_status'::text
  WHERE om_visit_lot.id = selector_lot.lot_id AND selector_lot.cur_user = "current_user"()::text;
  
DROP VIEW IF EXISTS v_visit_lot_user_manager;
CREATE OR REPLACE VIEW v_visit_lot_user AS 
 SELECT om_visit_lot_x_user.id,
    om_visit_lot_x_user.user_id,
    om_visit_lot_x_user.team_id,
    om_visit_lot_x_user.lot_id,
    om_visit_lot_x_user.starttime,
    om_visit_lot_x_user.endtime,
    now()::date AS date
   FROM om_visit_lot_x_user
  WHERE om_visit_lot_x_user.user_id::name = "current_user"()
  ORDER BY om_visit_lot_x_user.id DESC
 LIMIT 1;

 
CREATE OR REPLACE VIEW vi_parent_arc AS 
SELECT ve_arc.*
FROM ve_arc, inp_selector_sector 
WHERE ve_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW vi_parent_node as
SELECT DISTINCT ON (node_id) ve_node.*
FROM ve_node
JOIN vi_parent_arc a ON a.node_1::text = ve_node.node_id::text OR a.node_2::text = ve_node.node_id::text;

--2019/08/06
CREATE OR REPLACE VIEW v_edit_plan_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.descript,
    plan_psector.priority,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.sector_id,
    plan_psector.atlas_id,
    plan_psector.gexpenses,
    plan_psector.vat,
    plan_psector.other,
    plan_psector.the_geom,
    plan_psector.expl_id,
    plan_psector.psector_type,
    plan_psector.active,
    plan_psector.ext_code,
    plan_psector.status
   FROM selector_expl,
    plan_psector
  WHERE plan_psector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
  
--2019/09/02  
DROP VIEW IF EXISTS v_om_current_psector;
DROP VIEW IF EXISTS v_om_current_psector_budget;
DROP VIEW IF EXISTS v_om_current_psector_budget_detail_rec;
DROP VIEW IF EXISTS v_om_psector;
DROP VIEW IF EXISTS v_om_psector_x_arc;
DROP VIEW IF EXISTS v_om_psector_x_node;
DROP VIEW IF EXISTS v_om_psector_x_other;

