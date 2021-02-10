/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/02/09
CREATE OR REPLACE VIEW vi_valves AS 
SELECT DISTINCT ON (arc_id) * FROM (
 SELECT rpt_inp_arc.arc_id::text AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    ((rpt_inp_arc.addparam::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
    rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'coefloss'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'PRV'::character varying(18) AS valv_type,
    0.000::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_4')
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    'GPV'::character varying(18) AS valv_type,
    rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_5')
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'coef_loss'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    rpt_inp_arc.diameter,
    rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
    rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
    rpt_inp_arc.minorloss
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text 
  AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text 
  AND selector_inp_result.cur_user = "current_user"()::text) a;


DROP VIEW IF EXISTS vi_demands;
CREATE OR REPLACE VIEW vi_demands AS 
 SELECT inp_demand.feature_id,
    inp_demand.demand,
    inp_demand.pattern_id,
    inp_demand.demand_type
      FROM selector_inp_demand,
    inp_demand
  WHERE selector_inp_demand.dscenario_id::text = inp_demand.dscenario_id::text 
  AND selector_inp_demand.cur_user = "current_user"()::text
  UNION
SELECT feature_id,
    demand,
    pattern_id,
    demand_type
   FROM temp_demand
  ORDER BY feature_id;

