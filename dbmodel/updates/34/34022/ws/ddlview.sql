/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_pumps AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
        CASE
            WHEN (rpt_inp_arc.addparam::json ->> 'power'::text) <> ''::text THEN ('POWER'::text || ' '::text) || (rpt_inp_arc.addparam::json ->> 'power'::text)
            ELSE NULL::text
        END AS power,
        CASE
            WHEN (rpt_inp_arc.addparam::json ->> 'curve_id'::text) <> ''::text THEN ('HEAD'::text || ' '::text) || (rpt_inp_arc.addparam::json ->> 'curve_id'::text)
            ELSE NULL::text
        END AS head,
        CASE
            WHEN (rpt_inp_arc.addparam::json ->> 'speed'::text) <> ''::text THEN ('SPEED'::text || ' '::text) || (rpt_inp_arc.addparam::json ->> 'speed'::text)
            ELSE NULL::text
        END AS speed,
        CASE
            WHEN (rpt_inp_arc.addparam::json ->> 'pattern'::text) <> ''::text THEN ('PATTERN'::text || ' '::text) || (rpt_inp_arc.addparam::json ->> 'pattern'::text)
            ELSE NULL::text
        END AS pattern
   FROM selector_inp_result,
    rpt_inp_arc
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND rpt_inp_arc.epa_type::text = 'PUMP'::text
AND arc_id NOT IN (SELECT arc_id FROM vi_valves);
