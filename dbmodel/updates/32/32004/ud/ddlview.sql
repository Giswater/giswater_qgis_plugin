/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ud_sample, public, pg_catalog;



CREATE OR REPLACE VIEW ud_sample.vi_report AS 
 SELECT a.idval,
    b.value
   FROM ud_sample.audit_cat_param_user a
   JOIN ud_sample.config_param_user b ON a.id = b.parameter::text
   WHERE (a.layout_name = ANY (ARRAY['grl_reports_17'::text, 'grl_reports_18'::text])) AND b.cur_user::name = "current_user"()
   AND b.value IS NOT NULL;
  

CREATE OR REPLACE VIEW ud_sample.vi_options AS 
 SELECT a.idval,
    b.value
   FROM ud_sample.audit_cat_param_user a
   JOIN ud_sample.config_param_user b ON a.id = b.parameter::text
   WHERE (a.layout_name = ANY (ARRAY['grl_general_1'::text, 'grl_general_2'::text, 'grl_hyd_3'::text, 'grl_hyd_4'::text, 'grl_date_13'::text, 'grl_date_14'::text]))
   AND b.cur_user::name = "current_user"()
   AND a.epaversion::json->>'from'='5.0.022'
   AND b.value IS NOT NULL;



CREATE OR REPLACE VIEW ud_sample.vi_xsections AS 
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    concat(cat_arc_shape.curve_id, ' ', cat_arc.geom1, ' ', cat_arc.geom2, ' ', cat_arc.geom3, ' ', cat_arc.geom4, ' ', inp_conduit.barrels, ' ', inp_conduit.culvert) AS other_val
   FROM ud_sample.inp_selector_result,
    ud_sample.rpt_inp_arc
     JOIN ud_sample.inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN ud_sample.cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN ud_sample.cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text <> 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    concat(cat_arc_shape.tsect_id, ' ', cat_arc.geom1, ' ', cat_arc.geom2, ' ', cat_arc.geom3, ' ', cat_arc.geom4, ' ', inp_conduit.barrels, ' ', inp_conduit.culvert) AS other_val
   FROM ud_sample.inp_selector_result,
    ud_sample.rpt_inp_arc
     JOIN ud_sample.inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN ud_sample.cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN ud_sample.cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_orifice.arc_id,
    inp_typevalue.idval AS shape,
    concat(inp_orifice.geom1, ' ', inp_orifice.geom2, ' ', inp_orifice.geom3, ' ', inp_orifice.geom4) AS other_val
   FROM ud_sample.inp_selector_result,
    ud_sample.rpt_inp_arc
     JOIN ud_sample.inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN ud_sample.inp_typevalue ON inp_typevalue.id::text = inp_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval AS shape,
    concat(inp_flwreg_orifice.geom1, ' ', inp_flwreg_orifice.geom2, ' ', inp_flwreg_orifice.geom3, ' ', inp_flwreg_orifice.geom4) AS other_val
   FROM ud_sample.inp_selector_result,
    ud_sample.rpt_inp_arc
     JOIN ud_sample.inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
     LEFT JOIN ud_sample.inp_typevalue ON inp_typevalue.id::text = inp_flwreg_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval AS shape,
    concat(inp_weir.geom1, ' ', inp_weir.geom2, ' ', inp_weir.geom3, ' ', inp_weir.geom4) AS other_val
   FROM ud_sample.inp_selector_result,
    ud_sample.rpt_inp_arc
     JOIN ud_sample.inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN ud_sample.inp_typevalue ON inp_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::varchar(30) AS shape,
    concat(inp_flwreg_weir.geom1, ' ', inp_flwreg_weir.geom2, ' ', inp_flwreg_weir.geom3, ' ', inp_flwreg_weir.geom4) AS other_val
   FROM ud_sample.inp_selector_result,
    ud_sample.rpt_inp_arc
     JOIN ud_sample.inp_flwreg_weir ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     JOIN ud_sample.inp_typevalue ON inp_flwreg_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;




