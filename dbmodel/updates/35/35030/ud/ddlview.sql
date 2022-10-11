/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/10/11
CREATE OR REPLACE VIEW vi_subareas AS 
select distinct on (subc_id)
  v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.nimp,
    v_edit_inp_subcatchment.nperv,
    v_edit_inp_subcatchment.simp,
    v_edit_inp_subcatchment.sperv,
    v_edit_inp_subcatchment.zero,
    v_edit_inp_subcatchment.routeto,
    v_edit_inp_subcatchment.rted
   FROM v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id);

  
CREATE OR REPLACE VIEW vi_subcatchments AS 
select distinct on (subc_id)
 v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.rg_id,
    b.outlet_id,
    v_edit_inp_subcatchment.area,
    v_edit_inp_subcatchment.imperv,
    v_edit_inp_subcatchment.width,
    v_edit_inp_subcatchment.slope,
    v_edit_inp_subcatchment.clength,
    v_edit_inp_subcatchment.snow_id
   FROM v_edit_inp_subcatchment
     JOIN ( SELECT a.subc_id,
            a.outlet_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::character varying[]) AS outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                     JOIN temp_node ON inp_subcatchment.outlet_id::text = temp_node.node_id::text
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text
                UNION
                 SELECT inp_subcatchment.outlet_id,
                    inp_subcatchment.subc_id
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) <> '{'::text) a) b USING (outlet_id);


DROP VIEW vi_timeseries;
CREATE OR REPLACE VIEW vi_timeseries AS 
with t as ( SELECT a.timser_id,
            a.other1 as date,
            a.other2 as time,
            a.other3 as value,
            a.expl_id
           FROM ( SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    inp_timeseries_value.date AS other1,
                    inp_timeseries_value.hour AS other2,
                    inp_timeseries_value.value AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
                    concat('FILE', ' ', inp_timeseries.fname) AS other1,
                    NULL::character varying AS other2,
                    NULL::numeric AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'FILE'::text
                UNION
                 SELECT inp_timeseries_value.id,
                    inp_timeseries_value.timser_id,
				    NULL::varchar AS other1,
                    inp_timeseries_value."time" AS other2,
                    inp_timeseries_value.value AS other3,
                    inp_timeseries.expl_id
                   FROM inp_timeseries_value
                     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
                  WHERE inp_timeseries.times_type::text = 'RELATIVE'::text) a
          ORDER BY a.id)
		 SELECT timser_id, date, time, value from t, selector_expl s WHERE (t.expl_id = s.expl_id AND s.cur_user = "current_user"()::text)
		 UNION
		 SELECT  timser_id, date, time, value from t WHERE t.expl_id is null;
