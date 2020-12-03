/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT inp_reservoir.node_id,
    rpt_inp_node.elevation AS head,
    inp_reservoir.pattern_id
   FROM inp_selector_result,
    inp_reservoir
     JOIN rpt_inp_node ON inp_reservoir.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.epa_type = 'RESERVOIR' AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_inlet.node_id,
    rpt_inp_node.elevation AS head,
    inp_inlet.pattern_id
   FROM inp_selector_result,
    inp_inlet
     LEFT JOIN ( SELECT a.node_id,
            count(*) AS ct
           FROM ( SELECT rpt_inp_arc.node_1 AS node_id
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text
                UNION ALL
                 SELECT rpt_inp_arc.node_2
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text) a
          GROUP BY a.node_id) b USING (node_id)
     JOIN rpt_inp_node ON inp_inlet.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND b.ct = 1
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation AS head,
    rpt_inp_node.pattern_id
   FROM inp_selector_result,
    rpt_inp_node
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND rpt_inp_node.node_type::text = 'VIRT-RESERVOIR'::text;

drop view IF EXISTS vi_curves;
drop view IF EXISTS vi_tanks;
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    cast((rpt_inp_node.addparam::json ->> 'initlevel'::text) as numeric) AS initlevel,
    cast((rpt_inp_node.addparam::json ->> 'minlevel'::text) as numeric) AS minlevel,
    cast((rpt_inp_node.addparam::json ->> 'maxlevel'::text) as numeric) AS maxlevel,
    cast((rpt_inp_node.addparam::json ->> 'diameter'::text) as numeric) AS diameter,
    cast((rpt_inp_node.addparam::json ->> 'minvol'::text) as numeric) AS minvol,
    replace((rpt_inp_node.addparam::json ->> 'curve_id'::text),''::text, NULL::text) AS curve_id
   FROM inp_selector_result,
    rpt_inp_node
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND rpt_inp_node.epa_type::text = 'TANK'::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    cast((rpt_inp_node.addparam::json ->> 'initlevel'::text) as numeric) AS initlevel,
    cast((rpt_inp_node.addparam::json ->> 'minlevel'::text) as numeric) AS minlevel,
    cast((rpt_inp_node.addparam::json ->> 'maxlevel'::text) as numeric) AS maxlevel,
    cast((rpt_inp_node.addparam::json ->> 'diameter'::text) as numeric) AS diameter,
    cast((rpt_inp_node.addparam::json ->> 'minvol'::text) as numeric) AS minvol,
    replace((rpt_inp_node.addparam::json ->> 'curve_id'::text),''::text, NULL::text) AS curve_id   
    FROM inp_selector_result,
    rpt_inp_node
     LEFT JOIN ( SELECT a.node_id,
            count(*) AS ct
           FROM ( SELECT rpt_inp_arc.node_1 AS node_id
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text
                UNION ALL
                 SELECT rpt_inp_arc.node_2
                   FROM rpt_inp_arc,
                    inp_selector_result inp_selector_result_1
                  WHERE rpt_inp_arc.result_id::text = inp_selector_result_1.result_id::text AND inp_selector_result_1.cur_user = "current_user"()::text) a
          GROUP BY a.node_id) b USING (node_id)
  WHERE b.ct > 1 AND rpt_inp_node.epa_type::text = 'INLET'::text;



drop view vi_pumps;

CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT arc_id::varchar(16),
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    CASE WHEN addparam::json->>'power' !='' THEN ('POWER'::text || ' '::text) || (rpt_inp_arc.addparam::json->>'power')::text ELSE NULL END AS power,
    CASE WHEN addparam::json->>'curve_id' !='' THEN ('HEAD'::text || ' '::text) || (rpt_inp_arc.addparam::json->>'curve_id')::text ELSE NULL END AS head,
    CASE WHEN addparam::json->>'speed' !='' THEN ('SPEED'::text || ' '::text) || (rpt_inp_arc.addparam::json->>'speed')::text ELSE NULL END AS speed,
    CASE WHEN addparam::json->>'pattern' !='' THEN ('PATTERN'::text || ' '::text) || (rpt_inp_arc.addparam::json->>'pattern')::text ELSE NULL END AS pattern
   FROM inp_selector_result, rpt_inp_arc
     WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
      AND epa_type = 'PUMP'::text;


      
CREATE TRIGGER gw_trg_vi_pumps
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_pumps
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_pumps');



drop VIEW vi_valves;
CREATE OR REPLACE VIEW vi_valves AS 
 SELECT rpt_inp_arc.arc_id::text,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    (addparam::json->>'valv_type')::character varying(18) as valv_type,
    addparam::json->>'pressure' AS setting,
    rpt_inp_arc.minorloss
   FROM inp_selector_result,rpt_inp_arc
  WHERE (addparam::json->>'valv_type' = 'PRV' OR addparam::json->>'valv_type' = 'PSV' OR addparam::json->>'valv_type' = 'PBV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    addparam::json->>'valv_type',
    addparam::json->>'flow',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (addparam::json->>'valv_type' = 'FCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    addparam::json->>'valv_type',
    addparam::json->>'coefloss',
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
WHERE (addparam::json->>'valv_type' = 'TCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    addparam::json->>'valv_type',
    addparam::json->>'curve_id',
    rpt_inp_arc.minorloss
   FROM inp_selector_result,
    rpt_inp_arc
WHERE (addparam::json->>'valv_type' = 'GPV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION

-- doublevalve
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'PRV'::character varying(18) AS valv_type,
    0::text AS setting,
    0::numeric AS minorloss
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
    addparam::json->>'curve_id' AS setting,
    0::numeric(12,4) AS minorloss
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_5')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION

--virtualvalve
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    addparam::json->>'valv_type',
    addparam::json->>'pressure',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (addparam::json->>'valv_type' = 'PRV' OR addparam::json->>'valv_type' = 'PSV' OR addparam::json->>'valv_type' = 'PBV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    addparam::json->>'valv_type',
    addparam::json->>'flow',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (addparam::json->>'valv_type' = 'FCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    addparam::json->>'valv_type',
    addparam::json->>'coef_loss',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
  WHERE (addparam::json->>'valv_type' = 'TCV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    addparam::json->>'valv_type',
    addparam::json->>'curve_id',
    rpt_inp_arc.minorloss
   FROM inp_selector_result, rpt_inp_arc
   WHERE (addparam::json->>'valv_type' = 'GPV') 
  AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
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

/*

--2020/02/21
CREATE OR REPLACE VIEW ve_arc AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.arccat_id,
    v_arc.arctype_id AS cat_arctype_id,
    v_arc.sys_type,
    v_arc.matcat_id AS cat_matcat_id,
    v_arc.pnom AS cat_pnom,
    v_arc.dnom AS cat_dnom,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.label,
    v_arc.gis_length,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.presszonecat_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetaxis_id,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.postcomplement2,
    v_arc.streetaxis2_id,
    v_arc.postnumber2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value,
    v_arc.minsector_id,
    v_arc.dqa_id,
    v_arc.macrodqa_id,
    v_arc.arc_type,
    v_arc.nodetype_1,
    v_arc.elevation1,
    v_arc.depth1,
    v_arc.staticpress1,
    v_arc.nodetype_2,
    v_arc.elevation2,
    v_arc.depth2,
    v_arc.staticpress2,
    date_trunc('second', v_arc.lastupdate) as lastupdate,
    v_arc.lastupdate_user,
    v_arc.insert_user
   FROM v_arc;

CREATE OR REPLACE VIEW ve_connec AS 
 SELECT connec.connec_id,
    connec.code,
    connec.elevation,
    connec.depth,
    cat_connec.connectype_id,
    connec_type.type AS sys_type,
    connec.connecat_id,
    connec.sector_id,
    sector.macrosector_id,
    connec.customer_code,
    cat_connec.matcat_id AS cat_matcat_id,
    cat_connec.pnom AS cat_pnom,
    cat_connec.dnom AS cat_dnom,
    connec.connec_length,
    connec.state,
    connec.state_type,
    connec.annotation,
    connec.observ,
    connec.comment,
    cat_connec.label,
    connec.dma_id,
    connec.presszonecat_id,
    connec.soilcat_id,
    connec.function_type,
    connec.category_type,
    connec.fluid_type,
    connec.location_type,
    connec.workcat_id,
    connec.workcat_id_end,
    connec.buildercat_id,
    connec.builtdate,
    connec.enddate,
    connec.ownercat_id,
    connec.muni_id,
    connec.postcode,
    connec.streetaxis_id,
    connec.postnumber,
    connec.postcomplement,
    connec.streetaxis2_id,
    connec.postnumber2,
    connec.postcomplement2,
    connec.descript,
    connec.arc_id,
    cat_connec.svg,
    connec.rotation,
    concat(connec_type.link_path, connec.link) AS link,
    connec.verified,
    connec.the_geom,
    connec.undelete,
    connec.label_x,
    connec.label_y,
    connec.label_rotation,
    connec.publish,
    connec.inventory,
    dma.macrodma_id,
    connec.expl_id,
    connec.num_value,
    connec.minsector_id,
    connec.dqa_id,
    dqa.macrodqa_id,
    connec.staticpressure,
    connec.featurecat_id,
    connec.feature_id,
    connec.pjoint_type,
    connec.pjoint_id,
    cat_connec.connectype_id AS connec_type,
    date_trunc('second', connec.lastupdate) as lastupdate,
    connec.lastupdate_user,
    connec.insert_user,
    a.n_hydrometer
   FROM connec
     LEFT JOIN ( SELECT connec_1.connec_id,
            count(ext_rtc_hydrometer.id)::integer AS n_hydrometer
           FROM ext_rtc_hydrometer
             JOIN connec connec_1 ON ext_rtc_hydrometer.connec_id::text = connec_1.customer_code::text
          GROUP BY connec_1.connec_id) a USING (connec_id)
     JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
     JOIN connec_type ON connec_type.id::text = cat_connec.connectype_id::text
     JOIN v_state_connec ON v_state_connec.connec_id::text = connec.connec_id::text
     LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
     LEFT JOIN dma ON connec.dma_id = dma.dma_id
     LEFT JOIN sector ON connec.sector_id = sector.sector_id
     LEFT JOIN dqa ON connec.dqa_id = dqa.dqa_id;


CREATE OR REPLACE VIEW ve_node AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.sys_type,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.label,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.buildercat_id,
    v_node.workcat_id_end,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    v_node.minsector_id,
    v_node.dqa_id,
    v_node.macrodqa_id,
    v_node.staticpressure,
    v_node.node_type,
    date_trunc('second', v_node.lastupdate) as lastupdate,
    v_node.lastupdate_user,
    v_node.insert_user
   FROM v_node;
*/
   
   
DROP VIEW v_edit_inp_virtualvalve;
CREATE OR REPLACE VIEW v_edit_inp_virtualvalve AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    (v_arc.elevation1 + v_arc.elevation2) / 2::numeric AS elevation,
    (v_arc.depth1 + v_arc.depth2) / 2::numeric AS depth,
    v_arc.arccat_id,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.the_geom,
    inp_virtualvalve.valv_type,
    inp_virtualvalve.pressure,
    inp_virtualvalve.flow,
    inp_virtualvalve.coef_loss,
    inp_virtualvalve.curve_id,
    inp_virtualvalve.minorloss,
    inp_virtualvalve.to_arc,
    inp_virtualvalve.status
   FROM inp_selector_sector,
    v_arc
     JOIN inp_virtualvalve USING (arc_id)
     JOIN value_state_type ON v_arc.state_type = value_state_type.id
  WHERE v_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text AND value_state_type.is_operative IS TRUE;



CREATE OR REPLACE VIEW vi_patterns AS 
 SELECT a.pattern_id,
    a.factor_1,
    a.factor_2,
    a.factor_3,
    a.factor_4,
    a.factor_5,
    a.factor_6,
    a.factor_7,
    a.factor_8,
    a.factor_9,
    a.factor_10,
    a.factor_11,
    a.factor_12,
    a.factor_13,
    a.factor_14,
    a.factor_15,
    a.factor_16,
    a.factor_17,
    a.factor_18
   FROM ( SELECT a_1.id,
            a_1.pattern_id,
            a_1.factor_1,
            a_1.factor_2,
            a_1.factor_3,
            a_1.factor_4,
            a_1.factor_5,
            a_1.factor_6,
            a_1.factor_7,
            a_1.factor_8,
            a_1.factor_9,
            a_1.factor_10,
            a_1.factor_11,
            a_1.factor_12,
            a_1.factor_13,
            a_1.factor_14,
            a_1.factor_15,
            a_1.factor_16,
            a_1.factor_17,
            a_1.factor_18
           FROM inp_selector_result, inp_pattern_value a_1
             JOIN rpt_inp_node b ON a_1.pattern_id::text = b.pattern_id::text 
             WHERE b.result_id = inp_selector_result.result_id AND inp_selector_result.cur_user = current_user 
        UNION
         SELECT a_1.id,
            a_1.pattern_id,
            a_1.factor_1,
            a_1.factor_2,
            a_1.factor_3,
            a_1.factor_4,
            a_1.factor_5,
            a_1.factor_6,
            a_1.factor_7,
            a_1.factor_8,
            a_1.factor_9,
            a_1.factor_10,
            a_1.factor_11,
            a_1.factor_12,
            a_1.factor_13,
            a_1.factor_14,
            a_1.factor_15,
            a_1.factor_16,
            a_1.factor_17,
            a_1.factor_18
           FROM inp_selector_result,inp_pattern_value a_1
             JOIN (SELECT value as pattern_id FROM config_param_user 
		WHERE parameter = 'inp_options_pattern' and cur_user = current_user) a USING (pattern_id)
        UNION
         SELECT rpt_inp_pattern_value.id + 1000000,
            rpt_inp_pattern_value.pattern_id,
            rpt_inp_pattern_value.factor_1,
            rpt_inp_pattern_value.factor_2,
            rpt_inp_pattern_value.factor_3,
            rpt_inp_pattern_value.factor_4,
            rpt_inp_pattern_value.factor_5,
            rpt_inp_pattern_value.factor_6,
            rpt_inp_pattern_value.factor_7,
            rpt_inp_pattern_value.factor_8,
            rpt_inp_pattern_value.factor_9,
            rpt_inp_pattern_value.factor_10,
            rpt_inp_pattern_value.factor_11,
            rpt_inp_pattern_value.factor_12,
            rpt_inp_pattern_value.factor_13,
            rpt_inp_pattern_value.factor_14,
            rpt_inp_pattern_value.factor_15,
            rpt_inp_pattern_value.factor_16,
            rpt_inp_pattern_value.factor_17,
            rpt_inp_pattern_value.factor_18
           FROM rpt_inp_pattern_value
          WHERE rpt_inp_pattern_value.result_id::text = ((( SELECT inp_selector_result.result_id
                   FROM inp_selector_result
                  WHERE inp_selector_result.cur_user = "current_user"()::text))::text)          
	ORDER BY 1) a;
  