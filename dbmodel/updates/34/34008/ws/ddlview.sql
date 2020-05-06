/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_patterns AS 
SELECT a.pattern_id,a.factor_1,a.factor_2,a.factor_3,a.factor_4,a.factor_5,a.factor_6,a.factor_7, a.factor_8, a.factor_9, a.factor_10, 
a.factor_11, a.factor_12, a.factor_13, a.factor_14, a.factor_15, a.factor_16, a.factor_17, a.factor_18
FROM rpt_inp_pattern_value a, inp_selector_result b
WHERE a.result_id = b.result_id AND cur_user = current_user
ORDER BY pattern_id, idrow;
	

CREATE OR REPLACE VIEW vi_pjoint AS 
SELECT pjoint_id, sum(demand) AS sum
FROM v_edit_inp_connec WHERE pjoint_id IS NOT NULL GROUP BY pjoint_id;

DROP VIEW v_rtc_period_dma;

CREATE OR REPLACE VIEW v_rtc_period_dma AS 
 SELECT v_rtc_period_hydrometer.dma_id::integer AS dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.m3_total_period)::numeric(12,4) AS m3_total_period,
    a.pattern_id
   FROM v_rtc_period_hydrometer
     JOIN ext_rtc_dma_period a ON a.dma_id::text = v_rtc_period_hydrometer.dma_id::text 
	 AND v_rtc_period_hydrometer.period_id::text = a.cat_period_id::text
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;
  
CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT node_id,
    rpt_inp_node.elevation AS head,
    rpt_inp_node.pattern_id
   FROM inp_selector_result, rpt_inp_node
  WHERE rpt_inp_node.epa_type::text = 'RESERVOIR'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text;

drop VIEW if exists vi_curves;
drop VIEW if exists vi_tanks;
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    cast((rpt_inp_node.addparam::json ->> 'initlevel'::text) as numeric) AS initlevel,
    cast((rpt_inp_node.addparam::json ->> 'minlevel'::text) as numeric) AS minlevel,
    cast((rpt_inp_node.addparam::json ->> 'maxlevel'::text) as numeric) AS maxlevel,
    cast((rpt_inp_node.addparam::json ->> 'diameter'::text) as numeric) AS diameter,
    cast((rpt_inp_node.addparam::json ->> 'minvol'::text) as numeric) AS minvol,
    replace(rpt_inp_node.addparam::json ->> 'curve_id'::text, ''::text, NULL::text) AS curve_id
   FROM inp_selector_result, rpt_inp_node
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text 
  AND rpt_inp_node.epa_type::text = 'TANK'::text 
  AND inp_selector_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_curves AS 
 SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':', inp_curve_id.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a
  WHERE 	((a.curve_id::text IN (SELECT vi_tanks.curve_id::text FROM vi_tanks)) 
		OR (concat('HEAD ', a.curve_id) IN ( SELECT vi_pumps.head FROM vi_pumps)) 
		OR (concat('GPV ', a.curve_id) IN ( SELECT vi_valves.setting FROM vi_valves)) 
		OR (a.curve_id::text IN ( SELECT vi_energy.energyvalue FROM vi_energy WHERE vi_energy.idval::text = 'EFFIC'::text)))
		OR (SELECT value FROM config_param_user WHERE parameter = 'inp_options_buildup_mode' and cur_user=current_user)::integer = 1;


CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT DISTINCT ON (a.arc_id) a.arc_id,
    a.node_1,
    a.node_2,
    a.length,
    a.diameter,
    a.roughness,
    a.minorloss,
    a.status
   FROM ( SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.length,
            rpt_inp_arc.diameter,
            rpt_inp_arc.roughness,
            rpt_inp_arc.minorloss,
            rpt_inp_arc.status::character varying(30) AS status
            FROM inp_selector_result, rpt_inp_arc
            WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
            AND (rpt_inp_arc.epa_type::text = 'SHORTPIPE'::text OR rpt_inp_arc.epa_type::text = 'PIPE'::text)
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.length,
            rpt_inp_arc.diameter,
            rpt_inp_arc.roughness,
            rpt_inp_arc.minorloss,
            rpt_inp_arc.status::character varying(30) AS status
           FROM inp_selector_result,
            rpt_inp_arc
          WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
          AND rpt_inp_arc.arc_type::text = 'NODE2NODE'::text ) a;


drop view vi_curves;
drop view vi_valves;

CREATE OR REPLACE VIEW vi_valves AS 
 SELECT rpt_inp_arc.arc_id::text AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    ((rpt_inp_arc.addparam::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
    rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'coefloss'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'PRV'::character varying(18) AS valv_type,
    0.000::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_4')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'GPV'::character varying(18) AS valv_type,
    rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_5')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'coef_loss'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW vi_curves AS 
 SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':', inp_curve_id.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a
  WHERE (a.curve_id::text IN ( SELECT vi_tanks.curve_id
           FROM vi_tanks)) OR (concat('HEAD ', a.curve_id) IN ( SELECT vi_pumps.head
           FROM vi_pumps)) OR (concat('GPV ', a.curve_id) IN ( SELECT vi_valves.setting
           FROM vi_valves)) OR (a.curve_id::text IN ( SELECT vi_energy.energyvalue
           FROM vi_energy
          WHERE vi_energy.idval::text = 'EFFIC'::text)) OR ((( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_buildup_mode'::text AND config_param_user.cur_user::name = "current_user"()))::integer) = 1;
		  


CREATE OR REPLACE VIEW v_rtc_period_hydrometer AS 
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    temp_arc.node_1,
    temp_arc.node_2,
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
     JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_arc ON v_connec.arc_id::text = temp_arc.arc_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) 
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    temp_node.node_id AS pjoint_id,
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
     LEFT JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON concat('VN', v_connec.pjoint_id) = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_connec.dma_id::text = c.dma_id::text
  WHERE v_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    temp_node.node_id AS pjoint_id,
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
     LEFT JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN temp_node ON v_connec.pjoint_id::text = temp_node.node_id::text
     JOIN ext_rtc_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_connec.dma_id::text = c.dma_id::text
  WHERE v_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text))
          ;

