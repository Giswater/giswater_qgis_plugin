/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/03/22
CREATE OR REPLACE VIEW vi_tanks AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elevation,
    (rpt_inp_node.addparam::json ->> 'initlevel'::text)::numeric AS initlevel,
    (rpt_inp_node.addparam::json ->> 'minlevel'::text)::numeric AS minlevel,
    (rpt_inp_node.addparam::json ->> 'maxlevel'::text)::numeric AS maxlevel,
    (rpt_inp_node.addparam::json ->> 'diameter'::text)::numeric AS diameter,
    (rpt_inp_node.addparam::json ->> 'minvol'::text)::numeric AS minvol,
    (rpt_inp_node.addparam::json ->> 'curve_id'::text) AS curve_id
   FROM selector_inp_result, rpt_inp_node
  WHERE rpt_inp_node.result_id::text = selector_inp_result.result_id::text 
  AND rpt_inp_node.epa_type::text = 'TANK'::text AND selector_inp_result.cur_user = "current_user"()::text;



-- 2021/04/01
CREATE OR REPLACE VIEW inpvi_valves AS 
 SELECT DISTINCT ON (a.arc_id) a.arc_id,
    a.node_1,
    a.node_2,
    a.diameter,
    a.valv_type,
    a.setting,
    a.minorloss
   FROM ( SELECT rpt_inp_arc.arc_id::text AS arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            ((rpt_inp_arc.addparam::json ->> 'valv_type'::text))::character varying(18) AS valv_type,
            rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'coef_loss'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            'PRV'::character varying(18) AS valv_type,
            rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
             JOIN inpinp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a_4')
          WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'pressure'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE ((rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PRV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PSV'::text OR (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'PBV'::text) AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'flow'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'FCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'coef_loss'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'TCV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
        UNION
         SELECT rpt_inp_arc.arc_id,
            rpt_inp_arc.node_1,
            rpt_inp_arc.node_2,
            rpt_inp_arc.diameter,
            rpt_inp_arc.addparam::json ->> 'valv_type'::text AS valv_type,
            rpt_inp_arc.addparam::json ->> 'curve_id'::text AS setting,
            rpt_inp_arc.minorloss
           FROM inpselector_inp_result,
            inprpt_inp_arc
          WHERE (rpt_inp_arc.addparam::json ->> 'valv_type'::text) = 'GPV'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text) a;