/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
 CREATE VIEW v_edit_cat_dscenario AS
 SELECT DISTINCT ON (dscenario_id)
  dscenario_id,
  c.name,
  c.descript,
  dscenario_type,
  parent_id,
  c.expl_id,
  c.active,
  c.log
  FROM cat_dscenario c, selector_expl s
  WHERE (s.expl_id = c.expl_id AND cur_user = current_user)
  OR c.expl_id is null;


DROP VIEW v_ui_rpt_cat_result;
CREATE OR REPLACE VIEW v_ui_rpt_cat_result AS 
 SELECT DISTINCT ON (result_id) 
    rpt_cat_result.result_id,
	rpt_cat_result.expl_id,
    rpt_cat_result.cur_user,
    rpt_cat_result.exec_date,
    inp_typevalue.idval AS status,
    rpt_cat_result.export_options,
    rpt_cat_result.network_stats,
    rpt_cat_result.inp_options,
    rpt_cat_result.rpt_stats
   FROM selector_expl s, rpt_cat_result
     JOIN inp_typevalue ON rpt_cat_result.status::text = inp_typevalue.id::text
  WHERE inp_typevalue.typevalue::text = 'inp_result_status'::text
  AND ((s.expl_id = rpt_cat_result.expl_id AND s.cur_user = current_user)
  OR rpt_cat_result.expl_id is null);
  
  
CREATE OR REPLACE VIEW v_plan_aux_arc_pavement AS 
 SELECT plan_arc_x_pavement.arc_id,
        CASE 
            WHEN v_price_x_catpavement.thickness IS NULL THEN 0::numeric(12,2)
            ELSE v_price_x_catpavement.thickness::numeric(12,2)
        END AS thickness,
        CASE
            WHEN v_price_x_catpavement.m2pav_cost IS NULL THEN 0::numeric(12,2)
            ELSE v_price_x_catpavement.m2pav_cost::numeric(12,2)
        END AS m2pav_cost
   FROM v_edit_arc a
     LEFT JOIN plan_arc_x_pavement USING (arc_id)
     LEFT JOIN v_price_x_catpavement ON v_price_x_catpavement.pavcat_id::text = plan_arc_x_pavement.pavcat_id::text;
