/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;
-- WARNING: SCHEMA_NAME IS NOT ONLY PRESENT ON THE HEADER OF THIS FILE. IT EXISTS ALSO INTO IT. PLEASE REVIEW IT BEFORE REPLACE....




DROP VIEW IF EXISTS "v_inp_buildup" CASCADE;
CREATE VIEW "v_inp_buildup" AS 
SELECT inp_buildup_land_x_pol.landus_id, inp_buildup_land_x_pol.poll_id, inp_buildup_land_x_pol.funcb_type, inp_buildup_land_x_pol.c1, 
inp_buildup_land_x_pol.c2, inp_buildup_land_x_pol.c3, inp_buildup_land_x_pol.perunit 
FROM inp_buildup_land_x_pol;



DROP VIEW IF EXISTS "v_inp_controls" CASCADE;
CREATE VIEW "v_inp_controls" AS 
SELECT inp_controls_x_arc.id, text 
FROM inp_selector_sector, inp_controls_x_arc
	JOIN temp_arc on inp_controls_x_arc.arc_id=temp_arc.arc_id
	WHERE ((temp_arc.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"())
UNION
SELECT inp_controls_x_node.id, text FROM inp_selector_sector, inp_controls_x_node 
	JOIN temp_node on inp_controls_x_node.node_id=temp_node.node_id
	WHERE ((temp_node.sector_id)=(inp_selector_sector.sector_id) AND inp_selector_sector.cur_user="current_user"())
ORDER BY id;



DROP VIEW IF EXISTS "v_inp_curve" CASCADE;
CREATE OR REPLACE VIEW "v_inp_curve" AS 
SELECT inp_curve.id, inp_curve.curve_id, inp_curve.x_value, inp_curve.y_value,
(CASE WHEN x_value = (SELECT MIN(x_value) FROM inp_curve AS sub WHERE sub.curve_id = inp_curve.curve_id) THEN inp_curve_id.curve_type ELSE null END) AS curve_type
FROM (inp_curve JOIN inp_curve_id ON (((inp_curve_id.id) = (inp_curve.curve_id)))) 
ORDER BY inp_curve.id;



DROP VIEW IF EXISTS "v_inp_evap_co" CASCADE;
CREATE VIEW "v_inp_evap_co" AS 
SELECT inp_evaporation.evap_type AS type_evco, inp_evaporation.evap FROM inp_evaporation WHERE ((inp_evaporation.evap_type) = 'CONSTANT');


DROP VIEW IF EXISTS "v_inp_evap_do" CASCADE;
CREATE VIEW "v_inp_evap_do" AS 
SELECT 'DRY_ONLY'::text AS type_evdo, inp_evaporation.dry_only FROM inp_evaporation;


DROP VIEW IF EXISTS "v_inp_evap_fl" CASCADE;
CREATE VIEW "v_inp_evap_fl" AS 
SELECT inp_evaporation.evap_type AS type_evfl, inp_evaporation.pan_1, inp_evaporation.pan_2, inp_evaporation.pan_3, 
inp_evaporation.pan_4, inp_evaporation.pan_5, inp_evaporation.pan_6, inp_evaporation.pan_7, inp_evaporation.pan_8, 
inp_evaporation.pan_9, inp_evaporation.pan_10, inp_evaporation.pan_11, inp_evaporation.pan_12 
FROM inp_evaporation WHERE ((inp_evaporation.evap_type) = 'FILE');


DROP VIEW IF EXISTS "v_inp_evap_mo" CASCADE;
CREATE VIEW "v_inp_evap_mo" AS 
SELECT inp_evaporation.evap_type AS type_evmo, inp_evaporation.value_1, inp_evaporation.value_2, inp_evaporation.value_3,
 inp_evaporation.value_4, inp_evaporation.value_5, inp_evaporation.value_6, inp_evaporation.value_7, inp_evaporation.value_8, 
 inp_evaporation.value_9, inp_evaporation.value_10, inp_evaporation.value_11, inp_evaporation.value_12 
 FROM inp_evaporation WHERE ((inp_evaporation.evap_type) = 'MONTHLY');


DROP VIEW IF EXISTS "v_inp_evap_pa" CASCADE;
CREATE VIEW "v_inp_evap_pa" AS 
SELECT 'RECOVERY'::text AS type_evpa, inp_evaporation.recovery FROM inp_evaporation WHERE ((inp_evaporation.recovery) > '0');


DROP VIEW IF EXISTS "v_inp_evap_te" CASCADE;
CREATE VIEW "v_inp_evap_te" AS 
SELECT inp_evaporation.evap_type AS type_evte FROM inp_evaporation WHERE ((inp_evaporation.evap_type) = 'TEMPERATURE');


DROP VIEW IF EXISTS "v_inp_evap_ts" CASCADE;
CREATE VIEW "v_inp_evap_ts" AS 
SELECT inp_evaporation.evap_type AS type_evts, inp_evaporation.timser_id FROM inp_evaporation WHERE ((inp_evaporation.evap_type) = 'TIMESERIES');


DROP VIEW IF EXISTS "v_inp_hydrograph" CASCADE;
CREATE VIEW "v_inp_hydrograph" AS 
SELECT inp_hydrograph.id, inp_hydrograph.text FROM inp_hydrograph ORDER BY inp_hydrograph.id;


DROP VIEW IF EXISTS "v_inp_landuses" CASCADE;
CREATE VIEW "v_inp_landuses" AS 
SELECT inp_landuses.landus_id, inp_landuses.sweepint, inp_landuses.availab, inp_landuses.lastsweep FROM inp_landuses;


DROP VIEW IF EXISTS "v_inp_lidcontrol" CASCADE;
CREATE VIEW "v_inp_lidcontrol" AS 
SELECT inp_lid_control.lidco_id, inp_lid_control.lidco_type, inp_lid_control.value_2, inp_lid_control.value_3, 
inp_lid_control.value_4, inp_lid_control.value_5, inp_lid_control.value_6, inp_lid_control.value_7, inp_lid_control.value_8 
FROM inp_lid_control ORDER BY inp_lid_control.id;


DROP VIEW IF EXISTS "v_inp_options" CASCADE;
CREATE VIEW "v_inp_options" AS 
 SELECT inp_options.flow_units,
    cat_hydrology.infiltration,
    inp_options.flow_routing,
    inp_options.link_offsets,
    inp_options.force_main_equation,
    inp_options.ignore_rainfall,
    inp_options.ignore_snowmelt,
    inp_options.ignore_groundwater,
    inp_options.ignore_routing,
    inp_options.ignore_quality,
    inp_options.skip_steady_state,
    inp_options.start_date,
    inp_options.start_time,
    inp_options.enddate,
    inp_options.end_time,
    inp_options.report_start_date,
    inp_options.report_start_time,
    inp_options.sweep_start,
    inp_options.sweep_end,
    inp_options.dry_days,
    inp_options.report_step,
    inp_options.wet_step,
    inp_options.dry_step,
    inp_options.routing_step,
    inp_options.lengthening_step,
    inp_options.variable_step,
    inp_options.inertial_damping,
    inp_options.normal_flow_limited,
    inp_options.min_surfarea,
    inp_options.min_slope,
    inp_options.allow_ponding,
    inp_options.tempdir,
	inp_options.max_trials,
	inp_options.head_tolerance,
	inp_options.sys_flow_tol,
	inp_options.lat_flow_tol
   FROM inp_options,
    (inp_selector_hydrology
   JOIN cat_hydrology ON (((inp_selector_hydrology.hydrology_id) = (cat_hydrology.id))));


DROP VIEW IF EXISTS "v_inp_pattern_dl" CASCADE;
CREATE VIEW "v_inp_pattern_dl" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_padl, inp_pattern.factor_1, inp_pattern.factor_2, 
inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7 
FROM inp_pattern WHERE ((inp_pattern.pattern_type) = 'DAILY');


DROP VIEW IF EXISTS "v_inp_pattern_ho" CASCADE;
CREATE VIEW "v_inp_pattern_ho" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_paho, inp_pattern.factor_1, inp_pattern.factor_2, 
inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, 
inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12, 
inp_pattern.factor_13, inp_pattern.factor_14, inp_pattern.factor_15, inp_pattern.factor_16, inp_pattern.factor_17, 
inp_pattern.factor_18, inp_pattern.factor_19, inp_pattern.factor_20, inp_pattern.factor_21, inp_pattern.factor_22, 
inp_pattern.factor_23, inp_pattern.factor_24 
FROM inp_pattern WHERE ((inp_pattern.pattern_type) = 'HOURLY');


DROP VIEW IF EXISTS "v_inp_pattern_mo" CASCADE;
CREATE VIEW "v_inp_pattern_mo" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_pamo, inp_pattern.factor_1, inp_pattern.factor_2, 
inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, 
inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12 
FROM inp_pattern WHERE ((inp_pattern.pattern_type) = 'MONTHLY');

DROP VIEW IF EXISTS "v_inp_pattern_we" CASCADE;
CREATE VIEW "v_inp_pattern_we" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_pawe, inp_pattern.factor_1, inp_pattern.factor_2, 
inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, 
inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12, 
inp_pattern.factor_13, inp_pattern.factor_14, inp_pattern.factor_15, inp_pattern.factor_16, inp_pattern.factor_17, 
inp_pattern.factor_18, inp_pattern.factor_19, inp_pattern.factor_20, inp_pattern.factor_21, inp_pattern.factor_22, 
inp_pattern.factor_23, inp_pattern.factor_24 
FROM inp_pattern WHERE ((inp_pattern.pattern_type) = 'WEEKEND');


DROP VIEW IF EXISTS "v_inp_rgage_fl" CASCADE;
CREATE VIEW "v_inp_rgage_fl" AS 
SELECT raingage.rg_id, 
raingage.form_type, 
raingage.intvl, 
raingage.scf, 
raingage.rgage_type AS type_rgfl, 
raingage.fname, 
raingage.sta, 
raingage.units, 
(st_x(raingage.the_geom))::numeric(16,3) AS xcoord, 
(st_y(raingage.the_geom))::numeric(16,3) AS ycoord 
FROM v_edit_raingage raingage
WHERE ((raingage.rgage_type) = 'FILE');



DROP VIEW IF EXISTS "v_inp_rgage_ts" CASCADE;
CREATE VIEW "v_inp_rgage_ts" AS 
SELECT raingage.rg_id, 
raingage.form_type, 
raingage.intvl, 
raingage.scf, 
raingage.rgage_type AS type_rgts, 
raingage.timser_id, 
(st_x(raingage.the_geom))::numeric(16,3) AS xcoord, 
(st_y(raingage.the_geom))::numeric(16,3) AS ycoord 
FROM v_edit_raingage raingage
WHERE ((raingage.rgage_type) = 'TIMESERIES');



DROP VIEW IF EXISTS "v_inp_snowpack" CASCADE;
CREATE VIEW "v_inp_snowpack" AS 
SELECT inp_snowpack.snow_id, 'PLOWABLE'::text AS type_snpk1, inp_snowpack.cmin_1, inp_snowpack.cmax_1, inp_snowpack.tbase_1, 
inp_snowpack.fwf_1, inp_snowpack.sd0_1, inp_snowpack.fw0_1, inp_snowpack.snn0_1, 'IMPERVIOUS'::text AS type_snpk2, inp_snowpack.cmin_2, 
inp_snowpack.cmax_2, inp_snowpack.tbase_2, inp_snowpack.fwf_2, inp_snowpack.sd0_2, inp_snowpack.fw0_2, inp_snowpack.sd100_1, 
'PERVIOUS'::text AS type_snpk3, inp_snowpack.cmin_3, inp_snowpack.cmax_3, inp_snowpack.tbase_3, inp_snowpack.fwf_3, inp_snowpack.sd0_3, 
inp_snowpack.fw0_3, inp_snowpack.sd100_2, 'REMOVAL'::text AS type_snpk4, inp_snowpack.sdplow, inp_snowpack.fout, inp_snowpack.fimp, 
inp_snowpack.fperv, inp_snowpack.fimelt, inp_snowpack.fsub, inp_snowpack.subc_id FROM inp_snowpack;



DROP VIEW IF EXISTS "v_inp_temp_fl" CASCADE;
CREATE VIEW "v_inp_temp_fl" AS 
SELECT inp_temperature.temp_type AS type_tefl, inp_temperature.fname, inp_temperature.start 
FROM inp_temperature WHERE ((inp_temperature.temp_type) = 'FILE');



DROP VIEW IF EXISTS "v_inp_temp_sn" CASCADE;
CREATE VIEW "v_inp_temp_sn" AS 
SELECT 'SNOWMELT'::text AS type_tesn, inp_snowmelt.stemp, inp_snowmelt.atiwt, inp_snowmelt.rnm, inp_snowmelt.elev, 
inp_snowmelt.lat, inp_snowmelt.dtlong, 'ADC IMPERVIOUS'::text AS type_teai, inp_snowmelt.i_f0, inp_snowmelt.i_f1, 
inp_snowmelt.i_f2, inp_snowmelt.i_f3, inp_snowmelt.i_f4, inp_snowmelt.i_f5, inp_snowmelt.i_f6, inp_snowmelt.i_f7, 
inp_snowmelt.i_f8, inp_snowmelt.i_f9, 'ADC PERVIOUS'::text AS type_teap, inp_snowmelt.p_f0, inp_snowmelt.p_f1, 
inp_snowmelt.p_f2, inp_snowmelt.p_f3, inp_snowmelt.p_f4, inp_snowmelt.p_f5, inp_snowmelt.p_f6, inp_snowmelt.p_f7, 
inp_snowmelt.p_f8, inp_snowmelt.p_f9 
FROM inp_snowmelt;



DROP VIEW IF EXISTS "v_inp_temp_ts" CASCADE;
CREATE VIEW "v_inp_temp_ts" AS 
SELECT inp_temperature.temp_type AS type_tets, inp_temperature.timser_id 
FROM inp_temperature WHERE ((inp_temperature.temp_type) = 'TIMESERIES');



DROP VIEW IF EXISTS "v_inp_temp_wf" CASCADE;
CREATE VIEW "v_inp_temp_wf" AS 
SELECT 'WINDSPEED'::text AS type_tews, inp_windspeed.wind_type AS type_tefl, inp_windspeed.fname 
FROM inp_windspeed WHERE ((inp_windspeed.wind_type) = 'FILE');



DROP VIEW IF EXISTS "v_inp_temp_wm" CASCADE;
CREATE VIEW "v_inp_temp_wm" AS 
SELECT 'WINDSPEED'::text AS type_tews, inp_windspeed.wind_type AS type_temo, inp_windspeed.value_1, inp_windspeed.value_2, 
inp_windspeed.value_3, inp_windspeed.value_4, inp_windspeed.value_5, inp_windspeed.value_6, inp_windspeed.value_7, 
inp_windspeed.value_8, inp_windspeed.value_9, inp_windspeed.value_10, inp_windspeed.value_11, inp_windspeed.value_12 
FROM inp_windspeed WHERE ((inp_windspeed.wind_type) = 'MONTHLY');



DROP VIEW IF EXISTS "v_inp_timser_abs" CASCADE;
CREATE VIEW "v_inp_timser_abs" AS 
SELECT inp_timeseries.timser_id, inp_timeseries.date, inp_timeseries.hour, inp_timeseries.value 
FROM (inp_timeseries JOIN inp_timser_id ON (((inp_timeseries.timser_id) = (inp_timser_id.id)))) 
WHERE ((inp_timser_id.times_type) = 'ABSOLUTE') ORDER BY inp_timeseries.id;



DROP VIEW IF EXISTS "v_inp_timser_fl" CASCADE;
CREATE VIEW "v_inp_timser_fl" AS 
SELECT inp_timeseries.timser_id, 'FILE' AS type_times, inp_timeseries.fname 
FROM (inp_timeseries JOIN inp_timser_id ON (((inp_timeseries.timser_id) = (inp_timser_id.id)))) 
WHERE ((inp_timser_id.times_type) = 'FILE');


DROP VIEW IF EXISTS "v_inp_timser_rel" CASCADE;
CREATE VIEW "v_inp_timser_rel" AS 
SELECT inp_timeseries.timser_id, inp_timeseries."time", inp_timeseries.value 
FROM (inp_timeseries JOIN inp_timser_id ON (((inp_timeseries.timser_id) = (inp_timser_id.id)))) 
WHERE ((inp_timser_id.times_type) = 'RELATIVE') ORDER BY inp_timeseries.id;



DROP VIEW IF EXISTS "v_inp_transects" CASCADE;
CREATE VIEW "v_inp_transects" AS 
SELECT inp_transects.id, inp_transects.text FROM inp_transects ORDER BY inp_transects.id;



DROP VIEW IF EXISTS "v_inp_washoff" CASCADE;
CREATE VIEW "v_inp_washoff" AS 
SELECT inp_washoff_land_x_pol.landus_id, inp_washoff_land_x_pol.poll_id, inp_washoff_land_x_pol.funcw_type, 
inp_washoff_land_x_pol.c1, inp_washoff_land_x_pol.c2, inp_washoff_land_x_pol.sweepeffic, inp_washoff_land_x_pol.bmpeffic 
FROM inp_washoff_land_x_pol;




-- ----------------------------
-- View structure for subcatchments
-- ----------------------------
DROP VIEW IF EXISTS "v_inp_infiltration_cu" CASCADE;
CREATE VIEW "v_inp_infiltration_cu" AS 
SELECT 
subcatchment.subc_id,
subcatchment.curveno,
subcatchment.conduct_2,
subcatchment.drytime_2
FROM v_edit_subcatchment subcatchment
JOIN cat_hydrology ON hydrology_id=id
WHERE ((cat_hydrology.infiltration) = 'CURVE_NUMBER');



DROP VIEW IF EXISTS "v_inp_infiltration_gr" CASCADE;
CREATE VIEW "v_inp_infiltration_gr" AS 
SELECT
subcatchment.subc_id, 
subcatchment.suction, 
subcatchment.conduct, 
subcatchment.initdef 
FROM v_edit_subcatchment subcatchment
JOIN cat_hydrology ON hydrology_id=id
WHERE ((cat_hydrology.infiltration) = 'GREEN_AMPT');



DROP VIEW IF EXISTS "v_inp_infiltration_ho" CASCADE;
CREATE VIEW "v_inp_infiltration_ho" AS 
SELECT 
subcatchment.subc_id, 
subcatchment.maxrate, 
subcatchment.minrate, 
subcatchment.decay, 
subcatchment.drytime, 
subcatchment.maxinfil
FROM v_edit_subcatchment subcatchment
JOIN cat_hydrology ON hydrology_id=id
WHERE ((cat_hydrology.infiltration) = 'MODIFIED_HORTON') or ((cat_hydrology.infiltration) = 'HORTON');



DROP VIEW IF EXISTS "v_inp_subcatch" CASCADE;
CREATE VIEW "v_inp_subcatch" AS 
SELECT 
subcatchment.subc_id, 
subcatchment.node_id, 
subcatchment.rg_id, 
subcatchment.area, 
subcatchment.imperv, 
subcatchment.width, 
subcatchment.slope, 
subcatchment.clength, 
subcatchment.snow_id, 
subcatchment.nimp, 
subcatchment.nperv, 
subcatchment.simp, 
subcatchment.sperv, 
subcatchment.zero, 
subcatchment.routeto, 
subcatchment.rted
FROM v_edit_subcatchment subcatchment;



DROP VIEW IF EXISTS "v_inp_lidusage" CASCADE;
CREATE VIEW "v_inp_lidusage" AS 
SELECT 
inp_lidusage_subc_x_lidco.subc_id, 
inp_lidusage_subc_x_lidco.lidco_id, 
inp_lidusage_subc_x_lidco."number"::integer, 
inp_lidusage_subc_x_lidco.area, 
inp_lidusage_subc_x_lidco.width, 
inp_lidusage_subc_x_lidco.initsat, 
inp_lidusage_subc_x_lidco.fromimp, 
inp_lidusage_subc_x_lidco.toperv::integer, 
inp_lidusage_subc_x_lidco.rptfile 
FROM v_edit_subcatchment subcatchment
JOIN inp_lidusage_subc_x_lidco ON (((inp_lidusage_subc_x_lidco.subc_id) = (subcatchment.subc_id)));




DROP VIEW IF EXISTS "v_inp_groundwater" CASCADE;
CREATE VIEW "v_inp_groundwater" AS 
SELECT 
inp_groundwater.subc_id, 
inp_groundwater.aquif_id, 
inp_groundwater.node_id, 
inp_groundwater.surfel, 
inp_groundwater.a1, 
inp_groundwater.b1, 
inp_groundwater.a2, 
inp_groundwater.b2, 
inp_groundwater.a3, 
inp_groundwater.tw, 
inp_groundwater.h, 
(('LATERAL' || ' ') || (inp_groundwater.fl_eq_lat)) AS fl_eq_lat, 
(('DEEP' || ' ') || (inp_groundwater.fl_eq_lat)) AS fl_eq_deep
FROM v_edit_subcatchment subcatchment
JOIN inp_groundwater ON (((inp_groundwater.subc_id) = (subcatchment.subc_id)));



DROP VIEW IF EXISTS "v_inp_coverages" CASCADE;
CREATE VIEW "v_inp_coverages" AS 
SELECT subcatchment.subc_id, 
inp_coverage_land_x_subc.landus_id, 
inp_coverage_land_x_subc.percent
FROM inp_coverage_land_x_subc 
JOIN v_edit_subcatchment subcatchment ON inp_coverage_land_x_subc.subc_id = subcatchment.subc_id;



DROP VIEW IF EXISTS "v_inp_loadings" CASCADE;
CREATE VIEW "v_inp_loadings" AS 
SELECT inp_loadings_pol_x_subc.poll_id, 
inp_loadings_pol_x_subc.subc_id, 
inp_loadings_pol_x_subc.ibuildup
FROM v_edit_subcatchment subcatchment
JOIN inp_loadings_pol_x_subc ON (((inp_loadings_pol_x_subc.subc_id) = (subcatchment.subc_id)));



/*
DROP VIEW IF EXISTS "v_subcatchment" CASCADE;
CREATE VIEW v_subcatchment AS SELECT   
subc_id ,  node_id,  rg_id,  area,  imperv,  width,  slope,  clength,  snow_id ,  nimp,  nperv,  
simp,  sperv,  zero,  routeto,  rted,  maxrate,  minrate,  decay,  drytime,  maxinfil,  suction,  conduct,  initdef, 
curveno,  conduct_2,  drytime_2,  subcatchment.sector_id,  subcatchment.hydrology_id,  subcatchment.the_geom, 
subcatchment.expl_id
FROM selector_expl,subcatchment 
JOIN inp_selector_hydrology ON inp_selector_hydrology.hydrology_id=subcatchment.hydrology_id
JOIN inp_selector_sector ON inp_selector_sector.sector_id=subcatchment.sector_id 
WHERE ((subcatchment.expl_id)=(selector_expl.expl_id) AND selector_expl.cur_user="current_user"());

*/


-- ------------------------------------------------------------------
-- View structure for v_inp ARC  (SELECTED BY SECTOR & STATE SELECTION)
-- ------------------------------------------------------------------


DROP VIEW IF EXISTS "v_inp_conduit_cu" CASCADE;
CREATE OR REPLACE VIEW v_inp_conduit_cu AS 
SELECT 
temp_arc.arc_id,
node_1,
node_2,
length,
elevmax1 as z1,
elevmax2 as z2,
CASE
 WHEN inp_conduit.custom_n IS NOT NULL THEN inp_conduit.custom_n
 ELSE cat_mat_arc.n
 END AS n,
cat_arc.shape,
cat_arc.curve_id,
cat_arc.geom1,
cat_arc.geom2,
cat_arc.geom3,
cat_arc.geom4,
inp_conduit.q0,
inp_conduit.qmax,
inp_conduit.barrels,
inp_conduit.culvert,
inp_conduit.seepage
FROM temp_arc
     JOIN inp_conduit ON temp_arc.arc_id = inp_conduit.arc_id
     JOIN cat_arc ON temp_arc.arccat_id = cat_arc.id
     JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
     WHERE cat_arc.shape = 'CUSTOM';



DROP VIEW IF EXISTS "v_inp_conduit_no" CASCADE;
CREATE OR REPLACE VIEW v_inp_conduit_no AS 
 SELECT temp_arc.arc_id,
node_1,
node_2,
length,
elevmax1 as z1,
elevmax2 as z2,
CASE
 WHEN inp_conduit.custom_n IS NOT NULL THEN inp_conduit.custom_n
 ELSE cat_mat_arc.n
 END AS n,
cat_arc.shape,
cat_arc.curve_id,
cat_arc.geom1,
cat_arc.geom2,
cat_arc.geom3,
cat_arc.geom4,
inp_conduit.q0,
inp_conduit.qmax,
inp_conduit.barrels,
inp_conduit.culvert,
inp_conduit.seepage
FROM temp_arc
     JOIN inp_conduit ON temp_arc.arc_id = inp_conduit.arc_id
     JOIN cat_arc ON temp_arc.arccat_id = cat_arc.id
     JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
     WHERE cat_arc.shape!='CUSTOM' AND cat_arc.shape!='IRREGULAR';



DROP VIEW IF EXISTS "v_inp_conduit_xs" CASCADE;
CREATE OR REPLACE VIEW v_inp_conduit_xs AS 
SELECT
temp_arc.arc_id,
node_1,
node_2,
length,
elevmax1 as z1,
elevmax2 as z2,
CASE
 WHEN inp_conduit.custom_n IS NOT NULL THEN inp_conduit.custom_n
 ELSE cat_mat_arc.n
 END AS n,
cat_arc.shape,
cat_arc.curve_id,
cat_arc.geom1,
cat_arc.geom2,
cat_arc.geom3,
cat_arc.geom4,
inp_conduit.q0,
inp_conduit.qmax,
inp_conduit.barrels,
inp_conduit.culvert,
inp_conduit.seepage
FROM temp_arc
     JOIN inp_conduit ON temp_arc.arc_id = inp_conduit.arc_id
     JOIN cat_arc ON temp_arc.arccat_id = cat_arc.id
     JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
     WHERE cat_arc.shape = 'IRREGULAR';




DROP VIEW IF EXISTS "v_inp_orifice" CASCADE;
CREATE VIEW "v_inp_orifice" AS 
SELECT 
inp_orifice.arc_id, 
node_1,
node_2,
inp_orifice.ori_type, 
inp_orifice."offset", 
inp_orifice.cd, 
inp_orifice.flap, 
inp_orifice.orate, 
inp_orifice.shape, 
inp_orifice.geom1,
inp_orifice.geom2, 
inp_orifice.geom3, 
inp_orifice.geom4
FROM temp_arc
	JOIN inp_orifice ON inp_orifice.arc_id = temp_arc.arc_id;



DROP VIEW IF EXISTS "v_inp_outlet_fcd" CASCADE;
CREATE VIEW "v_inp_outlet_fcd" AS 
SELECT 
temp_arc.arc_id, 
node_1,
node_2,
inp_outlet.outlet_type AS type_oufcd, 
inp_outlet."offset", 
inp_outlet.cd1, 
inp_outlet.cd2, 
inp_outlet.flap
FROM temp_arc
	JOIN inp_outlet ON temp_arc.arc_id = inp_outlet.arc_id
	WHERE ((inp_outlet.outlet_type) = 'FUNCTIONAL/DEPTH') ;



DROP VIEW IF EXISTS "v_inp_outlet_fch" CASCADE;
CREATE VIEW "v_inp_outlet_fch" AS 
SELECT 
temp_arc.arc_id, 
node_1,
node_2,
inp_outlet.outlet_type AS type_oufch, 
inp_outlet."offset", 
inp_outlet.cd1, 
inp_outlet.cd2, 
inp_outlet.flap
FROM temp_arc
	JOIN inp_outlet ON temp_arc.arc_id = inp_outlet.arc_id
	WHERE ((inp_outlet.outlet_type) = 'FUNCTIONAL/HEAD');



DROP VIEW IF EXISTS "v_inp_outlet_tbd" CASCADE;
CREATE VIEW "v_inp_outlet_tbd" AS 
SELECT 
temp_arc.arc_id, 
node_1,
node_2,
inp_outlet.outlet_type AS type_outbd, 
inp_outlet."offset", 
inp_outlet.curve_id, 
inp_outlet.flap
FROM temp_arc
	JOIN inp_outlet ON temp_arc.arc_id = inp_outlet.arc_id
	WHERE ((inp_outlet.outlet_type) = 'TABULAR/DEPTH');




DROP VIEW IF EXISTS "v_inp_outlet_tbh" CASCADE;
CREATE VIEW "v_inp_outlet_tbh" AS 
SELECT 
temp_arc.arc_id, 
node_1,
node_2,
inp_outlet.outlet_type AS type_outbh, 
inp_outlet."offset", 
inp_outlet.curve_id, 
inp_outlet.flap
FROM temp_arc
	JOIN inp_outlet ON temp_arc.arc_id = inp_outlet.arc_id
	WHERE ((inp_outlet.outlet_type) = 'TABULAR/HEAD');




DROP VIEW IF EXISTS "v_inp_pump" CASCADE;
CREATE VIEW "v_inp_pump" AS 
SELECT 
temp_arc.arc_id, 
node_1,
node_2,
inp_pump.curve_id, 
inp_pump."status", 
inp_pump.startup, 
inp_pump.shutoff
FROM temp_arc
	JOIN inp_pump ON temp_arc.arc_id = inp_pump.arc_id;




DROP VIEW IF EXISTS "v_inp_weir" CASCADE;
CREATE VIEW "v_inp_weir" AS 
SELECT 
temp_arc.arc_id, 
node_1,
node_2,
inp_weir.weir_type, 
inp_weir."offset", 
inp_weir.cd, 
inp_weir.flap, 
inp_weir.ec, 
inp_weir.cd2, 
inp_value_weirs.shape, 
inp_weir.geom1, 
inp_weir.geom2, 
inp_weir.geom3, 
inp_weir.geom4, 
inp_weir.surcharge
FROM temp_arc
	JOIN inp_weir ON inp_weir.arc_id = temp_arc.arc_id
	JOIN inp_value_weirs ON inp_weir.weir_type = inp_value_weirs.id;




DROP VIEW IF EXISTS "v_inp_losses" CASCADE;
CREATE VIEW "v_inp_losses" AS 
SELECT 
inp_conduit.arc_id, 
inp_conduit.kentry, 
inp_conduit.kexit, 
inp_conduit.kavg, 
inp_conduit.flap, 
inp_conduit.seepage
FROM temp_arc
	JOIN inp_conduit ON temp_arc.arc_id = inp_conduit.arc_id
	WHERE ((((inp_conduit.kentry > (0)::numeric) OR (inp_conduit.kexit > (0)::numeric)) OR (inp_conduit.kavg > (0)::numeric)) OR ((inp_conduit.flap) = 'YES'));





-- ------------------------------------------------------------------
-- View structure for v_inp NODE (SELECTED BY SECTOR & STATE SELECTION)
-- ----------------------------------------------------------------

DROP VIEW IF EXISTS "v_inp_junction" CASCADE;
CREATE VIEW "v_inp_junction" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_junction.y0, 
inp_junction.ysur, 
inp_junction.apond,
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_junction  ON inp_junction.node_id=temp_node.node_id;



DROP VIEW IF EXISTS "v_inp_divider_cu" CASCADE;
CREATE VIEW "v_inp_divider_cu" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_divider.arc_id, 
inp_divider.divider_type AS type_dicu, 
inp_divider.qmin, 
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_divider ON temp_node.node_id = inp_divider.node_id 
	WHERE ((inp_divider.divider_type) = 'CUTOFF');



DROP VIEW IF EXISTS "v_inp_divider_ov" CASCADE;
CREATE VIEW "v_inp_divider_ov" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_divider.divider_type AS type_diov,
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_divider ON temp_node.node_id = inp_divider.node_id
	WHERE ((inp_divider.divider_type) = 'OVERFLOW');



DROP VIEW IF EXISTS "v_inp_divider_tb" CASCADE;
CREATE VIEW "v_inp_divider_tb" AS 
SELECT
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_divider.arc_id, 
inp_divider.divider_type AS type_ditb, 
inp_divider.curve_id, 
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_divider ON temp_node.node_id = inp_divider.node_id
	WHERE ((inp_divider.divider_type) = 'TABULAR');



DROP VIEW IF EXISTS "v_inp_divider_wr" CASCADE;
CREATE VIEW "v_inp_divider_wr" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_divider.arc_id, 
inp_divider.divider_type AS type_diwr,
inp_divider.qmin, 
inp_divider.ht, 
inp_divider.cd, 
inp_divider.y0, 
inp_divider.ysur, 
inp_divider.apond,
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_divider ON temp_node.node_id = inp_divider.node_id
	WHERE ((inp_divider.divider_type) = 'WEIR');



DROP VIEW IF EXISTS "v_inp_outfall_fi" CASCADE;
CREATE VIEW "v_inp_outfall_fi" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax, 
inp_outfall.outfall_type AS type_otlfi, 
inp_outfall.stage, 
inp_outfall.gate, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_outfall ON inp_outfall.node_id = temp_node.node_id
	WHERE ((inp_outfall.outfall_type) = 'FIXED');



DROP VIEW IF EXISTS "v_inp_outfall_fr" CASCADE;
CREATE VIEW "v_inp_outfall_fr" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_outfall.outfall_type AS type_otlfr, 
inp_outfall.gate, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_outfall ON temp_node.node_id = inp_outfall.node_id
	WHERE ((inp_outfall.outfall_type) = 'FREE');



DROP VIEW IF EXISTS "v_inp_outfall_nm" CASCADE;
CREATE VIEW "v_inp_outfall_nm" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_outfall.outfall_type AS type_otlnm, 
inp_outfall.gate, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_outfall ON temp_node.node_id = inp_outfall.node_id
	WHERE ((inp_outfall.outfall_type) = 'NORMAL');



DROP VIEW IF EXISTS "v_inp_outfall_ti" CASCADE;
CREATE VIEW "v_inp_outfall_ti" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_outfall.outfall_type AS type_otlti, 
inp_outfall.curve_id, 
inp_outfall.gate, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_outfall ON temp_node.node_id = inp_outfall.node_id
	WHERE ((inp_outfall.outfall_type) = 'TIDAL');



DROP VIEW IF EXISTS "v_inp_outfall_ts" CASCADE;
CREATE VIEW "v_inp_outfall_ts" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_outfall.outfall_type AS type_otlts, 
inp_outfall.timser_id, 
inp_outfall.gate, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_outfall ON temp_node.node_id = inp_outfall.node_id
	WHERE ((inp_outfall.outfall_type) = 'TIMESERIES');



DROP VIEW IF EXISTS "v_inp_storage_fc" CASCADE;
CREATE VIEW "v_inp_storage_fc" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_storage.y0, 
inp_storage.storage_type AS type_stfc,
inp_storage.a1, 
inp_storage.a2, 
inp_storage.a0, 
inp_storage.apond, 
inp_storage.fevap, 
inp_storage.sh, 
inp_storage.hc, 
inp_storage.imd, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_storage ON temp_node.node_id = inp_storage.node_id
	WHERE ((inp_storage.storage_type) = 'FUNCTIONAL');


DROP VIEW IF EXISTS "v_inp_storage_tb" CASCADE;
CREATE VIEW "v_inp_storage_tb" AS 
SELECT 
temp_node.node_id, 
top_elev,
elev,
top_elev-elev as ymax,
inp_storage.y0, 
inp_storage.storage_type AS type_sttb, 
inp_storage.curve_id, 
inp_storage.apond, 
inp_storage.fevap, 
inp_storage.sh, 
inp_storage.hc, 
inp_storage.imd, 
(st_x(temp_node.the_geom))::numeric(16,3) AS xcoord, 
(st_y(temp_node.the_geom))::numeric(16,3) AS ycoord
FROM temp_node
	JOIN inp_storage ON temp_node.node_id = inp_storage.node_id
	WHERE ((inp_storage.storage_type) = 'TABULAR');



DROP VIEW IF EXISTS "v_inp_dwf_flow" CASCADE;
CREATE VIEW "v_inp_dwf_flow" AS 
SELECT 
temp_node.node_id, 
'FLOW'::text AS type_dwf, 
inp_dwf.value, 
inp_dwf.pat1, 
inp_dwf.pat2, 
inp_dwf.pat3, 
inp_dwf.pat4 
FROM temp_node
	JOIN inp_dwf ON inp_dwf.node_id = temp_node.node_id;



DROP VIEW IF EXISTS "v_inp_dwf_load" CASCADE;
CREATE VIEW "v_inp_dwf_load" AS 
SELECT 
temp_node.node_id, 
inp_dwf_pol_x_node.poll_id, 
inp_dwf_pol_x_node.value, 
inp_dwf_pol_x_node.pat1, 
inp_dwf_pol_x_node.pat2, 
inp_dwf_pol_x_node.pat3, 
inp_dwf_pol_x_node.pat4
FROM temp_node
	JOIN inp_dwf_pol_x_node ON inp_dwf_pol_x_node.node_id = temp_node.node_id;



DROP VIEW IF EXISTS "v_inp_inflows_flow" CASCADE;
CREATE VIEW "v_inp_inflows_flow" AS 
SELECT 
temp_node.node_id, 
'FLOW'::text AS type_flow1, 
inp_inflows.timser_id, 
'FLOW'::text AS type_flow2, 
'1'::text AS type_n1, 
inp_inflows.sfactor, 
inp_inflows.base, 
inp_inflows.pattern_id
FROM temp_node
	JOIN inp_inflows ON inp_inflows.node_id = temp_node.node_id;



DROP VIEW IF EXISTS "v_inp_inflows_load" CASCADE;
CREATE VIEW "v_inp_inflows_load" AS 
SELECT 
temp_node.node_id, 
inp_inflows_pol_x_node.poll_id, 
inp_inflows_pol_x_node.timser_id, 
inp_inflows_pol_x_node.form_type, 
inp_inflows_pol_x_node.mfactor, 
inp_inflows_pol_x_node.sfactor, 
inp_inflows_pol_x_node.base, 
inp_inflows_pol_x_node.pattern_id
FROM temp_node
	JOIN inp_inflows_pol_x_node ON inp_inflows_pol_x_node.node_id = temp_node.node_id;




DROP VIEW IF EXISTS "v_inp_rdii" CASCADE;
CREATE VIEW "v_inp_rdii" AS 
SELECT 
temp_node.node_id, 
inp_rdii.hydro_id,
inp_rdii.sewerarea
FROM temp_node
	JOIN inp_rdii ON inp_rdii.node_id = temp_node.node_id;




DROP VIEW IF EXISTS "v_inp_treatment" CASCADE;
CREATE VIEW "v_inp_treatment" AS 
SELECT 
temp_node.node_id, 
inp_treatment_node_x_pol.poll_id, 
inp_treatment_node_x_pol.function
FROM temp_node
	JOIN inp_treatment_node_x_pol ON inp_treatment_node_x_pol.node_id = temp_node.node_id;






-- ----------------------------
-- View structure for v_vertice
-- ----------------------------

DROP VIEW IF EXISTS v_inp_vertice CASCADE;
CREATE OR REPLACE VIEW v_inp_vertice AS 
 SELECT 
 nextval('"SCHEMA_NAME".inp_vertice_seq'::regclass) AS id,
 arc.arc_id,
 st_x(arc.point)::numeric(16,3) AS xcoord,
 st_y(arc.point)::numeric(16,3) AS ycoord
 FROM 
	(SELECT (st_dumppoints(arc_1.the_geom)).geom AS point,
            st_startpoint(arc_1.the_geom) AS startpoint,
            st_endpoint(arc_1.the_geom) AS endpoint,
            arc_1.sector_id,
	    arc_1."state",
            arc_1.arc_id
	FROM temp_arc arc_1) arc
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint)
  ORDER BY nextval('"SCHEMA_NAME".inp_vertice_seq'::regclass);



-- ----------------------------
-- Direct views from tables
-- ----------------------------


DROP VIEW IF EXISTS "v_inp_project_id" CASCADE;
CREATE VIEW "v_inp_project_id" AS 
SELECT title,
author,
date
FROM inp_project_id
ORDER BY title;


DROP VIEW IF EXISTS "v_inp_backdrop" CASCADE;
CREATE VIEW "v_inp_backdrop" AS 
SELECT id,
text
FROM inp_backdrop
ORDER BY id; 



DROP VIEW IF EXISTS "v_inp_label" CASCADE;
CREATE VIEW "v_inp_label" AS 
SELECT label,
xcoord,
ycoord,
anchor,
font,
size,
bold,
italic 
FROM inp_label
ORDER BY label;



DROP VIEW IF EXISTS  "v_inp_mapdim" CASCADE;
CREATE VIEW  "v_inp_mapdim" AS 
SELECT type_dim,
x1,
y1,
x2,
y2
FROM inp_mapdim
ORDER BY type_dim;


DROP VIEW IF EXISTS  "v_inp_mapunits" CASCADE;
CREATE VIEW  "v_inp_mapunits" AS 
SELECT type_units,
map_type
FROM inp_mapunits
ORDER BY type_units;



DROP VIEW IF EXISTS  "v_inp_report" CASCADE;
CREATE VIEW  "v_inp_report" AS 
SELECT input,
continuity,
flowstats,
controls,
subcatchments,
nodes,
links
FROM inp_report
ORDER BY input;



DROP VIEW IF EXISTS  "v_inp_files" CASCADE;
CREATE VIEW  "v_inp_files" AS 
SELECT id,
actio_type,
file_type,
fname
FROM inp_files
ORDER BY id;



DROP VIEW IF EXISTS  "v_inp_aquifer" CASCADE;
CREATE VIEW  "v_inp_aquifer" AS 
SELECT aquif_id,
por,
wp,
fc,
k,
ks,
ps,
uef,
led,
gwr,
be,
wte,
umc,
pattern_id
FROM inp_aquifer
ORDER BY aquif_id;



DROP VIEW IF EXISTS  "v_inp_pollutant" CASCADE;
CREATE VIEW  "v_inp_pollutant" AS 
SELECT poll_id,
units_type,
crain,
cgw,
cii,
kd,
sflag,
copoll_id,
cofract,
cdwf
FROM inp_pollutant
ORDER BY poll_id;



DROP VIEW IF EXISTS  "v_inp_adjustments" CASCADE;
CREATE VIEW  "v_inp_adjustments" AS 
SELECT id,
adj_type,
value_1,
value_2,
value_3,
value_4,
value_5,
value_6,
value_7,
value_8,
value_9,
value_10,
value_11,
value_12
FROM inp_adjustments
ORDER BY id;




DROP VIEW IF EXISTS  "v_inp_subcatch2node" CASCADE;
CREATE OR REPLACE VIEW v_inp_subcatch2node AS 
 SELECT subcatchment.subc_id,
    st_makeline(st_centroid(subcatchment.the_geom), v_node.the_geom) AS the_geom
   FROM v_edit_subcatchment subcatchment
   JOIN v_node ON v_node.node_id = subcatchment.node_id;



   
DROP VIEW IF EXISTS  "v_inp_subcatchcentroid" CASCADE;
CREATE OR REPLACE VIEW v_inp_subcatchcentroid AS 
 SELECT subcatchment.subc_id,
    st_centroid(subcatchment.the_geom) AS the_geom
   FROM v_edit_subcatchment subcatchment;



