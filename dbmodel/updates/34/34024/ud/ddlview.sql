/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/10/22
CREATE OR REPLACE VIEW vi_coverages AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    inp_coverage_land_x_subc.landus_id,
    inp_coverage_land_x_subc.percent
   FROM inp_coverage_land_x_subc
     JOIN v_edit_inp_subcatchment ON inp_coverage_land_x_subc.subc_id::text = v_edit_inp_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;


CREATE OR REPLACE VIEW vi_groundwater AS 
 SELECT inp_groundwater.subc_id,
    inp_groundwater.aquif_id,
    inp_groundwater.node_id,
    inp_groundwater.surfel,
    inp_groundwater.a1,
    inp_groundwater.b1,
    inp_groundwater.a2,
    inp_groundwater.b2,
    inp_groundwater.a3,
    inp_groundwater.tw,
    inp_groundwater.h
   FROM v_edit_inp_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_inp_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text;


CREATE OR REPLACE VIEW vi_infiltration AS 
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.curveno AS other1,
    v_edit_inp_subcatchment.conduct_2 AS other2,
    v_edit_inp_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.suction AS other1,
    v_edit_inp_subcatchment.conduct AS other2,
    v_edit_inp_subcatchment.initdef AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_inp_subcatchment.subc_id,
    v_edit_inp_subcatchment.maxrate AS other1,
    v_edit_inp_subcatchment.minrate AS other2,
    v_edit_inp_subcatchment.decay AS other3,
    v_edit_inp_subcatchment.drytime AS other4,
    v_edit_inp_subcatchment.maxinfil AS other5
   FROM v_edit_inp_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_inp_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(inp_subcatchment.outlet_id::text[]) AS node_array,
                    inp_subcatchment.subc_id,
                    inp_subcatchment.outlet_id,
                    inp_subcatchment.rg_id,
                    inp_subcatchment.area,
                    inp_subcatchment.imperv,
                    inp_subcatchment.width,
                    inp_subcatchment.slope,
                    inp_subcatchment.clength,
                    inp_subcatchment.snow_id,
                    inp_subcatchment.nimp,
                    inp_subcatchment.nperv,
                    inp_subcatchment.simp,
                    inp_subcatchment.sperv,
                    inp_subcatchment.zero,
                    inp_subcatchment.routeto,
                    inp_subcatchment.rted,
                    inp_subcatchment.maxrate,
                    inp_subcatchment.minrate,
                    inp_subcatchment.decay,
                    inp_subcatchment.drytime,
                    inp_subcatchment.maxinfil,
                    inp_subcatchment.suction,
                    inp_subcatchment.conduct,
                    inp_subcatchment.initdef,
                    inp_subcatchment.curveno,
                    inp_subcatchment.conduct_2,
                    inp_subcatchment.drytime_2,
                    inp_subcatchment.sector_id,
                    inp_subcatchment.hydrology_id,
                    inp_subcatchment.the_geom,
                    inp_subcatchment.descript
                   FROM inp_subcatchment
                  WHERE "left"(inp_subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_inp_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = ANY (ARRAY['MODIFIED_HORTON'::text, 'HORTON'::text]);
  
  
  
CREATE OR REPLACE VIEW v_ui_om_visit_x_gully AS 
 SELECT om_visit_event.id AS event_id,
    om_visit.id AS visit_id,
    om_visit.ext_code,
    om_visit.visitcat_id,
    om_visit.startdate AS visit_start,
    om_visit.enddate AS visit_end,
    om_visit.user_name,
    om_visit.is_done,
    date_trunc('second'::text, om_visit_event.tstamp) AS tstamp,
    om_visit_x_gully.gully_id,
    om_visit_event.parameter_id,
    config_visit_parameter.parameter_type,
    config_visit_parameter.feature_type,
    config_visit_parameter.form_type,
    config_visit_parameter.descript,
    om_visit_event.value,
    om_visit_event.xcoord,
    om_visit_event.ycoord,
    om_visit_event.compass,
    om_visit_event.event_code,
        CASE
            WHEN a.event_id IS NULL THEN false
            ELSE true
        END AS gallery,
        CASE
            WHEN b.visit_id IS NULL THEN false
            ELSE true
        END AS document,
    om_visit.class_id
   FROM om_visit
     JOIN om_visit_event ON om_visit.id = om_visit_event.visit_id
     JOIN om_visit_x_gully ON om_visit_x_gully.visit_id = om_visit.id
     LEFT JOIN config_visit_parameter ON config_visit_parameter.id::text = om_visit_event.parameter_id::text
     LEFT JOIN ( SELECT DISTINCT om_visit_event_photo.event_id
           FROM om_visit_event_photo) a ON a.event_id = om_visit_event.id
     LEFT JOIN ( SELECT DISTINCT doc_x_visit.visit_id
           FROM doc_x_visit) b ON b.visit_id = om_visit.id
  ORDER BY om_visit_x_gully.gully_id;



CREATE OR REPLACE VIEW vi_xsections AS 
 SELECT rpt_inp_arc.arc_id,
    cat_arc_shape.epa AS shape,
    cat_arc.geom1::text AS other1,
    cat_arc.curve_id AS other2,
    0::text AS other3,
    0::text AS other4,
    rpt_inp_arc.barrels::integer AS other5,
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
    rpt_inp_arc.barrels::integer AS other5,
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
    NULL::character varying AS other2,
    NULL::text AS other3,
    NULL::text AS other4,
    NULL::integer AS other5,
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
  WHERE rpt_inp_arc.result_id::text = selector_inp_result.result_id::text AND selector_inp_result.cur_user = "current_user"()::text AND inp_typevalue.typevalue::text = 'inp_value_weirs'::text;
