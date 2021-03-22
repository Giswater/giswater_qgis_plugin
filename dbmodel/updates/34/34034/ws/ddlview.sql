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

