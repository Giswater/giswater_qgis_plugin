/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.grafconfig::text AS grafconfig,
    sector.stylesheet::text AS stylesheet,
    sector.active,
    sector.parent_id,
    sector.pattern_id
   FROM selector_sector,sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_pattern AS 
 SELECT DISTINCT p.pattern_id,
    p.observ,
    p.tscode,
    p.tsparameters::text AS tsparameters,
    p.sector_id,
    p.log
   FROM selector_sector, inp_pattern p
  WHERE p.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text OR p.sector_id IS NULL
  ORDER BY p.pattern_id;


CREATE OR REPLACE VIEW v_edit_inp_curve AS 
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.sector_id,
    c.log
   FROM selector_sector, inp_curve c
  WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text OR c.sector_id IS NULL
  ORDER BY c.id;
  

CREATE OR REPLACE VIEW vi_reservoirs AS 
 SELECT node_id,
    elevation AS head,
    pattern_id,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', node_type) as "other"
   FROM temp_node
   WHERE epa_type = 'RESERVOIR'
   ORDER BY node_id;


CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT node_id,
    elevation,
    (addparam::json ->> 'initlevel'::text)::numeric AS initlevel,
    (addparam::json ->> 'minlevel'::text)::numeric AS minlevel,
    (addparam::json ->> 'maxlevel'::text)::numeric AS maxlevel,
    (addparam::json ->> 'diameter'::text)::numeric AS diameter,
    (addparam::json ->> 'minvol'::text)::numeric AS minvol,
    addparam::json ->> 'curve_id'::text AS curve_id,
    addparam::json ->> 'overflow'::text AS overflow,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', node_type) as "other"
   FROM temp_node
   WHERE epa_type = 'TANK'
   ORDER BY node_id;

CREATE OR REPLACE VIEW vi_junctions AS 
 SELECT node_id,
    elevation,
    demand,
    pattern_id,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', node_type) as "other"
    FROM temp_node
    WHERE epa_type NOT IN ('RESERVOIR', 'TANK')
  ORDER BY node_id;

CREATE OR REPLACE VIEW vi_pipes AS 
 SELECT arc_id,
    node_1,
    node_2,
    length,
    diameter,
    roughness,
    minorloss,
    status::varchar(30),
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', arccat_id) as "other"
    FROM temp_arc
    WHERE epa_type IN ('PIPE', 'SHORTPIPE', 'NODE2NODE');


CREATE OR REPLACE VIEW vi_valves AS 
 SELECT DISTINCT ON (a.arc_id) a.arc_id,
    a.node_1,
    a.node_2,
    a.diameter,
    a.valv_type,
    a.setting,
    a.minorloss,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', arccat_id) as "other"
   FROM ( SELECT arc_id::text AS arc_id,
            node_1,
            node_2,
            diameter,
            ((addparam::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
            addparam::json ->> 'pressure'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            WHERE ((addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (addparam::json ->> 'valv_type'::text) = 'PBV'::text) 
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            addparam::json ->> 'valv_type'::text AS valv_type,
            addparam::json ->> 'flow'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            WHERE (addparam::json ->> 'valv_type'::text) = 'FCV'::text 
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            addparam::json ->> 'valv_type'::text AS valv_type,
            addparam::json ->> 'coef_loss'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            WHERE (addparam::json ->> 'valv_type'::text) = 'TCV'::text
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            addparam::json ->> 'valv_type'::text AS valv_type,
            addparam::json ->> 'curve_id'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
           FROM temp_arc
          WHERE (addparam::json ->> 'valv_type'::text) = 'GPV'::text
        UNION
         SELECT arc_id,
            node_1,
            node_2,
            diameter,
            'PRV'::character varying(18) AS valv_type,
            addparam::json ->> 'pressure'::text AS setting,
            minorloss, sector_id, dma_id, presszone_id, dqa_id, minsector_id, arccat_id
            FROM temp_arc
            JOIN inp_pump ON arc_id::text = concat(inp_pump.node_id, '_n2a_4')) a;

CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT arc_id,
    node_1,
    node_2,
        CASE
            WHEN (addparam::json ->> 'power'::text) <> ''::text THEN ('POWER'::text || ' '::text) || (addparam::json ->> 'power'::text)
            ELSE NULL::text
        END AS power,
        CASE
            WHEN (addparam::json ->> 'curve_id'::text) <> ''::text THEN ('HEAD'::text || ' '::text) || (addparam::json ->> 'curve_id'::text)
            ELSE NULL::text
        END AS head,
        CASE
            WHEN (addparam::json ->> 'speed'::text) <> ''::text THEN ('SPEED'::text || ' '::text) || (addparam::json ->> 'speed'::text)
            ELSE NULL::text
        END AS speed,
        CASE
            WHEN (addparam::json ->> 'pattern'::text) <> ''::text THEN ('PATTERN'::text || ' '::text) || (addparam::json ->> 'pattern'::text)
            ELSE NULL::text
        END AS pattern,
    concat(';', sector_id, ' ', dma_id, ' ', presszone_id, ' ', dqa_id, ' ', minsector_id, ' ', arccat_id) as "other"
    FROM temp_arc
    WHERE epa_type IN ('PUMP') AND arc_id NOT IN (SELECT arc_id FROM vi_valves)
  ORDER BY arc_id;


DROP VIEW SCHEMA_NAME.vi_tags;
CREATE OR REPLACE VIEW SCHEMA_NAME.vi_tags AS 
 SELECT inp_tags.feature_type,
    inp_tags.feature_id,
    inp_tags.tag
   FROM SCHEMA_NAME.inp_tags
  ORDER BY inp_tags.feature_type;

CREATE TRIGGER gw_trg_vi_tags
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.vi_tags
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_tags');



CREATE OR REPLACE VIEW SCHEMA_NAME.vi_curves AS 
 SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
    NULL::text AS other
   FROM ( SELECT DISTINCT ON (inp_curve_value.curve_id) ( SELECT min(sub.id) AS min
                   FROM SCHEMA_NAME.inp_curve_value sub
                  WHERE sub.curve_id::text = inp_curve_value.curve_id::text) AS id,
            inp_curve_value.curve_id,
            concat(';', inp_curve.curve_type, ':', inp_curve.descript) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM SCHEMA_NAME.inp_curve
             JOIN SCHEMA_NAME.inp_curve_value ON inp_curve_value.curve_id::text = inp_curve.id::text
        UNION
         SELECT inp_curve_value.id,
            inp_curve_value.curve_id,
            inp_curve.curve_type,
            inp_curve_value.x_value,
            inp_curve_value.y_value
           FROM SCHEMA_NAME.inp_curve_value
             JOIN SCHEMA_NAME.inp_curve ON inp_curve_value.curve_id::text = inp_curve.id::text
  ORDER BY 1, 4 DESC) a
  WHERE (a.curve_id::text IN ( SELECT vi_tanks.curve_id
           FROM SCHEMA_NAME.vi_tanks)) OR (concat('HEAD ', a.curve_id) IN ( SELECT vi_pumps.head
           FROM SCHEMA_NAME.vi_pumps)) OR (a.curve_id::text IN ( SELECT vi_valves.setting
           FROM SCHEMA_NAME.vi_valves)) OR (a.curve_id::text IN ( SELECT vi_energy.energyvalue
           FROM SCHEMA_NAME.vi_energy
          WHERE vi_energy.idval::text = 'EFFIC'::text)) OR ((( SELECT config_param_user.value
           FROM SCHEMA_NAME.config_param_user
          WHERE config_param_user.parameter::text = 'inp_options_buildup_mode'::text AND config_param_user.cur_user::name = "current_user"()))::integer) = 1;


drop view vi_demands;
CREATE OR REPLACE VIEW vi_demands AS 
SELECT temp_demand.feature_id,
    temp_demand.demand,
    temp_demand.pattern_id,
    concat(';',dscenario_id,' ',source,' ', demand_type) as other
   FROM temp_demand
   JOIN temp_node ON temp_demand.feature_id::text = temp_node.node_id::text
   ORDER BY 1,4;
     
CREATE OR REPLACE VIEW v_edit_inp_dscenario_demand AS 
 SELECT inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source
   FROM selector_sector,
    selector_inp_dscenario,
    inp_dscenario_demand
     JOIN v_node ON v_node.node_id::text = inp_dscenario_demand.feature_id::text
  WHERE v_node.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
  AND inp_dscenario_demand.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text
UNION
 SELECT inp_dscenario_demand.dscenario_id,
    inp_dscenario_demand.feature_id,
    inp_dscenario_demand.feature_type,
    inp_dscenario_demand.demand,
    inp_dscenario_demand.pattern_id,
    inp_dscenario_demand.demand_type,
    inp_dscenario_demand.source
   FROM selector_sector,
    selector_inp_dscenario,
    inp_dscenario_demand
     JOIN v_connec ON v_connec.connec_id::text = inp_dscenario_demand.feature_id::text
  WHERE v_connec.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text 
  AND inp_dscenario_demand.dscenario_id = selector_inp_dscenario.dscenario_id AND selector_inp_dscenario.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_inp_tank;
CREATE OR REPLACE VIEW v_edit_inp_tank
AS SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    inp_tank.minvol,
    inp_tank.curve_id,
    n.the_geom
   FROM selector_sector,
    v_node n
     JOIN inp_tank USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_inp_inlet AS 
 SELECT n.node_id,
    n.elevation,
    n.depth,
    n.nodecat_id,
    n.sector_id,
    n.macrosector_id,
    n.dma_id,
    n.state,
    n.state_type,
    n.annotation,
    n.expl_id,
    inp_inlet.initlevel,
    inp_inlet.minlevel,
    inp_inlet.maxlevel,
    inp_inlet.diameter,
    inp_inlet.minvol,
    inp_inlet.curve_id,
    inp_inlet.pattern_id,
    n.the_geom,
	inp_inlet.overflow
   FROM selector_sector, v_node n
     JOIN inp_inlet USING (node_id)
  WHERE n.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW ws_sample.v_ui_rpt_cat_result AS 
 SELECT rpt_cat_result.result_id,
    rpt_cat_result.cur_user,
    rpt_cat_result.exec_date,
    inp_typevalue.idval AS status,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats
   FROM ws_sample.rpt_cat_result
     JOIN ws_sample.inp_typevalue ON rpt_cat_result.status::text = inp_typevalue.id::text
  WHERE inp_typevalue.typevalue::text = 'inp_result_status'::text;
