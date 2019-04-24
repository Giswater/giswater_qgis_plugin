/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


drop view  SCHEMA_NAME.vi_title;


DROP VIEW SCHEMA_NAME.vi_inflows;
CREATE OR REPLACE VIEW SCHEMA_NAME.vi_inflows AS 
 SELECT rpt_inp_node.node_id,
    'FLOW'::text AS type_flow,
    inp_inflows.timser_id,
    'FLOW'::text AS type, 
    1::float as mfactor, 
    inp_inflows.sfactor,
    inp_inflows.base,
    inp_inflows.pattern_id
   FROM SCHEMA_NAME.inp_selector_result,
    SCHEMA_NAME.rpt_inp_node
     JOIN SCHEMA_NAME.inp_inflows ON inp_inflows.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    inp_inflows_pol_x_node.poll_id AS type_flow,
    inp_inflows_pol_x_node.timser_id,
    inp_typevalue.idval,
    inp_inflows_pol_x_node.mfactor,
    inp_inflows_pol_x_node.sfactor,
    inp_inflows_pol_x_node.base, 
    inp_inflows_pol_x_node.pattern_id
   FROM SCHEMA_NAME.inp_selector_result,
    SCHEMA_NAME.rpt_inp_node
     JOIN SCHEMA_NAME.inp_inflows_pol_x_node ON inp_inflows_pol_x_node.node_id::text = rpt_inp_node.node_id::text
     LEFT JOIN SCHEMA_NAME.inp_typevalue ON inp_typevalue.id::text = inp_inflows_pol_x_node.form_type::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
DROP VIEW SCHEMA_NAME.vi_controls;
CREATE OR REPLACE VIEW SCHEMA_NAME.vi_controls AS 
SELECT text FROM (SELECT inp_controls_x_arc.id, inp_controls_x_arc.text
   FROM SCHEMA_NAME.inp_selector_sector,
    SCHEMA_NAME.inp_controls_x_arc
     JOIN SCHEMA_NAME.rpt_inp_arc ON inp_controls_x_arc.arc_id::text = rpt_inp_arc.arc_id::text
  WHERE rpt_inp_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
UNION
 SELECT inp_controls_x_node.id+1000000,inp_controls_x_node.text
   FROM SCHEMA_NAME.inp_selector_sector,
    SCHEMA_NAME.inp_controls_x_node
     JOIN SCHEMA_NAME.rpt_inp_node ON inp_controls_x_node.node_id::text = rpt_inp_node.node_id::text
  WHERE rpt_inp_node.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text
  ORDER BY id) a;

  
DROP VIEW SCHEMA_NAME.vi_treatment;
CREATE OR REPLACE VIEW SCHEMA_NAME.vi_treatment AS 
SELECT 
   rpt_inp_node.node_id,
   inp_treatment_node_x_pol.poll_id,
  function::varchar(30)
   FROM inp_selector_result, 
   rpt_inp_node
     JOIN inp_treatment_node_x_pol ON inp_treatment_node_x_pol.node_id::text = rpt_inp_node.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_treatment_node_x_pol.function::text
  WHERE rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


DROP VIEW vi_transects;
CREATE OR REPLACE VIEW vi_transects AS 
 SELECT inp_transects.text
   FROM inp_transects
  ORDER BY inp_transects.id;
 
 
DROP VIEW vi_temperature;
CREATE OR REPLACE VIEW vi_temperature AS 
 SELECT temp_type,
    inp_temperature.value
   FROM inp_temperature;

	
DROP VIEW vi_evaporation;
CREATE OR REPLACE VIEW vi_evaporation AS 
 SELECT evap_type,
    inp_evaporation.value
   FROM inp_evaporation;
   
   
DROP VIEW vi_hydrographs;
CREATE OR REPLACE VIEW vi_hydrographs AS 
SELECT inp_hydrograph.text
   FROM inp_hydrograph;

   
DROP VIEW vi_snowpacks;
CREATE OR REPLACE VIEW vi_snowpacks AS 
 SELECT inp_snowpack.snow_id,
    inp_snowpack.snow_type,
    inp_snowpack.value_1,
    inp_snowpack.value_2,
    inp_snowpack.value_3,
    inp_snowpack.value_4,
    inp_snowpack.value_5,
    inp_snowpack.value_6,
    inp_snowpack.value_7
   FROM inp_snowpack
  ORDER BY id;

  
DROP VIEW IF EXISTS vi_xsections;
CREATE OR REPLACE VIEW  vi_xsections AS
SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.curve_id AS other2,
    NULL::text AS other3,
    NULL::text AS other4,
    barrels::integer AS other5,
    NULL::text AS other6
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'CUSTOM'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.geom2::text AS other2,
    cat_arc.geom3::text AS other3,
    cat_arc.geom4::text AS other4,
    barrels::integer AS other5,
    culvert::text AS other6
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text <> 'CUSTOM'::text AND cat_arc_shape.epa::text <> 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.tsect_id AS other1,
    NULL::character varying AS other2,
    NULL::text AS other3,
    NULL::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT inp_orifice.arc_id,
    inp_typevalue.idval AS shape,
    inp_orifice.geom1::text AS other1,
    inp_orifice.geom2::text AS other2,
    inp_orifice.geom3::text AS other3,
    inp_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval AS shape,
    inp_flwreg_orifice.geom1::text AS other1,
    inp_flwreg_orifice.geom2::text AS other2,
    inp_flwreg_orifice.geom3::text AS other3,
    inp_flwreg_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_flwreg_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_weir.geom1::text AS other1,
    inp_weir.geom2::text AS other2,
    inp_weir.geom3::text AS other3,
    inp_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN inp_typevalue ON inp_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_flwreg_weir.geom1::text AS other1,
    inp_flwreg_weir.geom2::text AS other2,
    inp_flwreg_weir.geom3::text AS other3,
    inp_flwreg_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_flwreg_weir ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     JOIN inp_typevalue ON inp_flwreg_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text;

  
  
DROP VIEW IF EXISTS vi_report;
CREATE OR REPLACE VIEW vi_report AS 
 SELECT a.idval as parameter,
    b.value
   FROM audit_cat_param_user a
   JOIN config_param_user b ON a.id = b.parameter::text
   WHERE (a.layout_name = ANY (ARRAY['grl_reports_17'::text, 'grl_reports_18'::text])) AND b.cur_user::name = "current_user"()
   AND b.value IS NOT NULL;
  
  
DROP VIEW IF EXISTS vi_options;
CREATE OR REPLACE VIEW vi_options AS 
 SELECT a.idval as parameter,
    b.value
   FROM audit_cat_param_user a
   JOIN config_param_user b ON a.id = b.parameter::text
   WHERE (a.layout_name = ANY (ARRAY['grl_general_1'::text, 'grl_general_2'::text, 'grl_hyd_3'::text, 'grl_hyd_4'::text, 'grl_date_13'::text, 'grl_date_14'::text]))
   AND b.cur_user::name = "current_user"()
   AND a.epaversion::json->>'from'='5.0.022'
   AND b.value IS NOT NULL;
   
 
drop view vi_dividers;
CREATE OR REPLACE VIEW vi_dividers AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_divider.divider_type,
    inp_divider.qmin::text as other1, 
    inp_divider.y0 as other2,
    inp_divider.ysur as other3,
    inp_divider.apond as other4,
    null::float as other5,
    null::float as other6
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
  WHERE inp_divider.divider_type::text = 'CUTOFF'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_divider.divider_type,
    inp_divider.y0::text, 
    inp_divider.ysur,
    inp_divider.apond,
    null,
    null,
    null
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
  WHERE inp_divider.divider_type::text = 'OVERFLOW'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_typevalue.idval AS divider_type,
    inp_divider.curve_id,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond,
    null,
    null
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_divider.divider_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_divider'::text AND inp_divider.divider_type::text = 'TABULAR'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_divider.arc_id,
    inp_divider.divider_type,
    inp_divider.qmin::text,
    inp_divider.ht, 
    inp_divider.cd,
    inp_divider.y0, 
    inp_divider.ysur, 
    inp_divider.apond  
    FROM inp_selector_result, rpt_inp_node
    JOIN inp_divider ON rpt_inp_node.node_id::text = inp_divider.node_id::text
  WHERE inp_divider.divider_type::text = 'WEIR'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
  DROP VIEW vi_outfalls;
CREATE OR REPLACE VIEW vi_outfalls AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.stage::text as other1, 
    inp_outfall.gate::text as other2
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON inp_outfall.node_id::text = rpt_inp_node.node_id::text
  WHERE inp_outfall.outfall_type::text = 'FIXED'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.gate,
    null as other2
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
  WHERE inp_outfall.outfall_type::text = 'FREE'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_outfall.outfall_type,
    inp_outfall.gate,
    null as other2
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
  WHERE inp_outfall.outfall_type::text = 'NORMAL'::text AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_typevalue.idval AS outfall_type,
    inp_outfall.curve_id,
    inp_outfall.gate
     FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_outfall.outfall_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_outfall'::text AND inp_outfall.outfall_type::text = 'TIDAL'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    inp_typevalue.idval AS outfall_type,
    inp_outfall.timser_id,
    inp_outfall.gate
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_outfall ON rpt_inp_node.node_id::text = inp_outfall.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_outfall.outfall_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_outfall'::text AND inp_outfall.outfall_type::text = 'TIMESERIES'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;
   
  
 DROP VIEW vi_storage;
CREATE OR REPLACE VIEW vi_storage AS 
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    rpt_inp_node.ymax,
    inp_storage.y0,
    inp_storage.storage_type,
    inp_storage.a1::text AS other1,
    inp_storage.a2 AS other2,
    inp_storage.a0 AS other3,
    inp_storage.apond AS other4,
    inp_storage.fevap AS other5,
    inp_storage.sh AS other6,
    inp_storage.hc AS other7,
    inp_storage.imd AS other8
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_storage ON rpt_inp_node.node_id::text = inp_storage.node_id::text
  WHERE inp_storage.storage_type::text = 'FUNCTIONAL'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_node.node_id,
    rpt_inp_node.elev,
    rpt_inp_node.ymax,
    inp_storage.y0,
    inp_typevalue.idval AS storage_type,
    inp_storage.curve_id, 
    inp_storage.apond,
    inp_storage.fevap,
    inp_storage.sh,
    inp_storage.hc,
    inp_storage.imd,
    null as other7,
    null as other8
   FROM inp_selector_result, rpt_inp_node
     JOIN inp_storage ON rpt_inp_node.node_id::text = inp_storage.node_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_storage.storage_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_storage'::text AND inp_storage.storage_type::text = 'TABULAR'::text 
  AND rpt_inp_node.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;
   

   DROP VIEW vi_outlets;
CREATE OR REPLACE VIEW vi_outlets AS 
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    inp_outlet.cd1::text AS other1,
    inp_outlet.cd2::text AS other2, 
    inp_outlet.flap AS other3
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'FUNCTIONAL/DEPTH'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    inp_flwreg_outlet.cd1::text,
    inp_flwreg_outlet.cd2::text,
    inp_flwreg_outlet.flap
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'FUNCTIONAL/DEPTH'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    inp_outlet.cd1::text,
    inp_outlet.cd2::text, 
    inp_outlet.flap
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'FUNCTIONAL/HEAD'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    inp_flwreg_outlet.cd1::text, 
    inp_flwreg_outlet.cd2::text,
    inp_flwreg_outlet.flap
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'FUNCTIONAL/HEAD'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    inp_outlet.curve_id,
    inp_outlet.flap,
    null as other3
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'TABULAR/DEPTH'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    inp_flwreg_outlet.curve_id,
    inp_flwreg_outlet.flap,
    null as other3
   FROM inp_selector_result,  rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'TABULAR/DEPTH'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_outlet."offset",
    inp_outlet.outlet_type,
    inp_outlet.curve_id, 
    inp_outlet.flap,
    null as other3
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_outlet ON rpt_inp_arc.arc_id::text = inp_outlet.arc_id::text
  WHERE inp_outlet.outlet_type::text = 'TABULAR/HEAD'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    inp_flwreg_outlet."offset",
    inp_flwreg_outlet.outlet_type,
    inp_flwreg_outlet.curve_id, 
    inp_flwreg_outlet.flap,
    null as other3
   FROM inp_selector_result, rpt_inp_arc
     JOIN inp_flwreg_outlet ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_outlet.node_id, '_', inp_flwreg_outlet.to_arc, '_out_', inp_flwreg_outlet.flwreg_id)
  WHERE inp_flwreg_outlet.outlet_type::text = 'TABULAR/HEAD'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

  
  
DROP VIEW vi_patterns;
CREATE OR REPLACE VIEW vi_patterns AS 
SELECT 
    inp_pattern_value.pattern_id,
    c.pattern_type,
    inp_pattern_value.factor_1,
    inp_pattern_value.factor_2,
    inp_pattern_value.factor_3,
    inp_pattern_value.factor_4,
    inp_pattern_value.factor_5,
    inp_pattern_value.factor_6,
    inp_pattern_value.factor_7,
    inp_pattern_value.factor_8,
    inp_pattern_value.factor_9,
    inp_pattern_value.factor_10,
    inp_pattern_value.factor_11,
    inp_pattern_value.factor_12,
    inp_pattern_value.factor_13,
    inp_pattern_value.factor_14,
    inp_pattern_value.factor_15,
    inp_pattern_value.factor_16,
    inp_pattern_value.factor_17,
    inp_pattern_value.factor_18,
    inp_pattern_value.factor_19,
    inp_pattern_value.factor_20,
    inp_pattern_value.factor_21,
    inp_pattern_value.factor_22,
    inp_pattern_value.factor_23,
    inp_pattern_value.factor_24
   FROM inp_pattern_value
     JOIN inp_pattern ON inp_pattern_value.pattern_id::text = inp_pattern.pattern_id::text
     LEFT JOIN 
      (SELECT  min(a.id) AS id, a.pattern_id, d.pattern_type FROM inp_pattern_value a, inp_pattern_value b JOIN inp_pattern d ON b.pattern_id=d.pattern_id  
      WHERE a.pattern_id = b.pattern_id group by a.pattern_id, pattern_type) 
      c ON c.id = inp_pattern_value.id
     order by inp_pattern_value.id;

  
DROP VIEW vi_infiltration;
CREATE OR REPLACE VIEW vi_infiltration AS 
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.curveno AS other1,
    v_edit_subcatchment.conduct_2 AS other2, 
    v_edit_subcatchment.drytime_2 AS other3,
    null::integer AS other4,
    null::float AS other5
   FROM v_edit_subcatchment
   JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
UNION
 SELECT v_edit_subcatchment.subc_id,
   v_edit_subcatchment.suction, 
   v_edit_subcatchment.conduct,
   v_edit_subcatchment.initdef,
   null AS other4,
    null AS other5
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.maxrate, 
    v_edit_subcatchment.minrate, 
    v_edit_subcatchment.decay, 
    v_edit_subcatchment.drytime, 
    v_edit_subcatchment.maxinfil
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
  WHERE cat_hydrology.infiltration::text = 'MODIFIED_HORTON'::text OR cat_hydrology.infiltration::text = 'HORTON'::text
  ORDER BY 2;
  
  
DROP VIEW vi_timeseries;
CREATE OR REPLACE VIEW vi_timeseries AS 
 SELECT inp_timeseries.timser_id,
    inp_timeseries.date AS other1,
    inp_timeseries.hour AS other2,
    inp_timeseries.value AS other3
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'ABSOLUTE'::text
UNION
 SELECT inp_timeseries.timser_id,
    concat('FILE', ' ', inp_timeseries.fname) AS other1,
    NULL::character varying AS other2,
    NULL::numeric AS other3
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'FILE'::text
UNION
 SELECT inp_timeseries.timser_id,
    inp_timeseries."time",
    inp_timeseries.value::text,
    NULL::numeric AS other3
   FROM inp_timeseries
     JOIN inp_timser_id ON inp_timeseries.timser_id::text = inp_timser_id.id::text
  WHERE inp_timser_id.times_type::text = 'RELATIVE'::text
  ORDER BY 1, 2;
  
  
DROP VIEW vi_raingages;
CREATE OR REPLACE VIEW vi_raingages AS 
 SELECT v_edit_raingage.rg_id,
    v_edit_raingage.form_type,
    v_edit_raingage.intvl,
    v_edit_raingage.scf,
    inp_typevalue.idval as raingage_type,
    v_edit_raingage.timser_id as other1,
    null as other2,
    null as other3
   FROM v_edit_raingage
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = v_edit_raingage.rgage_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_raingage'::text AND rgage_type='TIMESERIES'
  UNION
  SELECT v_edit_raingage.rg_id,
    v_edit_raingage.form_type,
    v_edit_raingage.intvl,
    v_edit_raingage.scf,
    inp_typevalue.idval as raingage_type,
    v_edit_raingage.fname as other1,
    v_edit_raingage.sta as other2,
    v_edit_raingage.units as other3
   FROM v_edit_raingage
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = v_edit_raingage.rgage_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_typevalue_raingage'::text AND rgage_type='FILE';

  
DROP VIEW vi_lid_controls;
CREATE OR REPLACE VIEW vi_lid_controls AS 
 SELECT inp_lid_control.lidco_id,
    inp_typevalue.idval AS lidco_type,
    inp_lid_control.value_2 as other1,
    inp_lid_control.value_3 as other2,
    inp_lid_control.value_4 as other3,
    inp_lid_control.value_5 as other4,
    inp_lid_control.value_6 as other5,
    inp_lid_control.value_7 as other6,
    inp_lid_control.value_8 AS other7
   FROM inp_lid_control
   LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_lid_control.lidco_type::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_lidcontrol'::text
  ORDER BY inp_lid_control.id;
