/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



DROP VIEW IF EXISTS vi_status;
CREATE OR REPLACE VIEW vi_status AS SELECT rpt_inp_arc.arc_id,
   idval
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
     JOIN inp_typevalue ON inp_typevalue.id=rpt_inp_arc.status
  WHERE rpt_inp_arc.status::text = 'CLOSED_VALVE'::text OR rpt_inp_arc.status::text = 'OPEN_VALVE'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
   idval
    FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
     JOIN inp_typevalue ON inp_typevalue.id=rpt_inp_arc.status
 WHERE inp_pump.status::text = 'CLOSED_PUMP'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
   idval
    FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump_additional ON rpt_inp_arc.arc_id::text = concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id)
    LEFT JOIN inp_typevalue ON inp_typevalue.id=rpt_inp_arc.status
  WHERE inp_pump_additional.status::text = 'CLOSED_PUMP'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

