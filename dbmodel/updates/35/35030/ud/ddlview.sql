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