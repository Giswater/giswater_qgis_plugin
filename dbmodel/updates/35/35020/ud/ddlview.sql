/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/11
CREATE OR REPLACE VIEW vi_timeseries AS 
 SELECT timser_id, other1, other2, other3 FROM (SELECT 
inp_timeseries_value.id,
 inp_timeseries_value.timser_id,
    inp_timeseries_value.date AS other1,
    inp_timeseries_value.hour AS other2,
    inp_timeseries_value.value AS other3
   FROM inp_timeseries_value
     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
  WHERE inp_timeseries.times_type::text = 'ABSOLUTE'::text
UNION
 SELECT 
 inp_timeseries_value.id,
 inp_timeseries_value.timser_id,
    concat('FILE', ' ', inp_timeseries.fname) AS other1,
    NULL::character varying AS other2,
    NULL::numeric AS other3
   FROM inp_timeseries_value
     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
  WHERE inp_timeseries.times_type::text = 'FILE'::text
UNION
 SELECT 
    inp_timeseries_value.id,
    inp_timeseries_value.timser_id,
    inp_timeseries_value."time" AS other1,
    inp_timeseries_value.value::text AS other2,
    NULL::numeric AS other3
   FROM inp_timeseries_value
     JOIN inp_timeseries ON inp_timeseries_value.timser_id::text = inp_timeseries.id::text
  WHERE inp_timeseries.times_type::text = 'RELATIVE'::text) a
  ORDER BY id;



  
CREATE OR REPLACE VIEW vi_xsections AS 
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.curve_id AS other2,
    0::text AS other3,
    0::text AS other4,
    rpt_inp_arc.barrels AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'CUSTOM'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.geom2::text AS other2,
    cat_arc.geom3::text AS other3,
    cat_arc.geom4::text AS other4,
    rpt_inp_arc.barrels AS other5,
    inp_conduit.culvert::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text <> 'CUSTOM'::text AND cat_arc_shape.epa::text <> 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.tsect_id AS other1,
    0::character varying AS other2,
    0::text AS other3,
    0::text AS other4,
    rpt_inp_arc.barrels AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arc_id::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT inp_orifice.arc_id,
    inp_typevalue.idval AS shape,
    inp_orifice.geom1::text AS other1,
    inp_orifice.geom2::text AS other2,
    inp_orifice.geom3::text AS other3,
    inp_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval AS shape,
    inp_flwreg_orifice.geom1::text AS other1,
    inp_flwreg_orifice.geom2::text AS other2,
    inp_flwreg_orifice.geom3::text AS other3,
    inp_flwreg_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_flwreg_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_weir.geom1::text AS other1,
    inp_weir.geom2::text AS other2,
    inp_weir.geom3::text AS other3,
    inp_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN inp_typevalue ON inp_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_flwreg_weir.geom1::text AS other1,
    inp_flwreg_weir.geom2::text AS other2,
    inp_flwreg_weir.geom3::text AS other3,
    inp_flwreg_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_weir ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     JOIN inp_typevalue ON inp_flwreg_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.curve_id AS other2,
    0::text AS other3,
    0::text AS other4,
    rpt_inp_arc.barrels AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arcparent::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'CUSTOM'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.geom2::text AS other2,
    cat_arc.geom3::text AS other3,
    cat_arc.geom4::text AS other4,
    rpt_inp_arc.barrels AS other5,
    inp_conduit.culvert::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arcparent::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text <> 'CUSTOM'::text AND cat_arc_shape.epa::text <> 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.tsect_id AS other1,
    0::character varying AS other2,
    0::text AS other3,
    0::text AS other4,
    rpt_inp_arc.barrels AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_conduit ON rpt_inp_arc.arcparent::text = inp_conduit.arc_id::text
     JOIN cat_arc ON rpt_inp_arc.arccat_id::text = cat_arc.id::text
     JOIN cat_arc_shape ON cat_arc_shape.id::text = cat_arc.shape::text
  WHERE cat_arc_shape.epa::text = 'IRREGULAR'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT inp_orifice.arc_id,
    inp_typevalue.idval AS shape,
    inp_orifice.geom1::text AS other1,
    inp_orifice.geom2::text AS other2,
    inp_orifice.geom3::text AS other3,
    inp_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_orifice ON inp_orifice.arc_id::text = rpt_inp_arc.arcparent::text
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.idval AS shape,
    inp_flwreg_orifice.geom1::text AS other1,
    inp_flwreg_orifice.geom2::text AS other2,
    inp_flwreg_orifice.geom3::text AS other3,
    inp_flwreg_orifice.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_orifice ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_orifice.node_id, '_', inp_flwreg_orifice.to_arc, '_ori_', inp_flwreg_orifice.flwreg_id)
     LEFT JOIN inp_typevalue ON inp_typevalue.id::text = inp_flwreg_orifice.shape::text
  WHERE inp_typevalue.typevalue::text = 'inp_value_orifice'::text AND rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_weir.geom1::text AS other1,
    inp_weir.geom2::text AS other2,
    inp_weir.geom3::text AS other3,
    inp_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_weir ON inp_weir.arc_id::text = rpt_inp_arc.arcparent::text
     JOIN inp_typevalue ON inp_weir.weir_type::text = inp_typevalue.idval::text
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text
UNION
 SELECT rpt_inp_arc.arc_id,
    inp_typevalue.descript::character varying(30) AS shape,
    inp_flwreg_weir.geom1::text AS other1,
    inp_flwreg_weir.geom2::text AS other2,
    inp_flwreg_weir.geom3::text AS other3,
    inp_flwreg_weir.geom4::text AS other4,
    NULL::integer AS other5,
    NULL::text AS other6
   FROM selector_inp_result,
    rpt_inp_arc
     JOIN inp_flwreg_weir ON rpt_inp_arc.flw_code::text = concat(inp_flwreg_weir.node_id, '_', inp_flwreg_weir.to_arc, '_weir_', inp_flwreg_weir.flwreg_id)
     JOIN inp_typevalue ON inp_flwreg_weir.weir_type::text = inp_typevalue.idval::text;
