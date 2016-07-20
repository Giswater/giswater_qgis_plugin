


-- ----------------------------
-- View structure for v_inp
-- ----------------------------

CREATE VIEW "SCHEMA_NAME"."v_inp_buildup" AS 
SELECT inp_buildup_land_x_pol.landus_id, inp_buildup_land_x_pol.poll_id, inp_buildup_land_x_pol.funcb_type, inp_buildup_land_x_pol.c1, inp_buildup_land_x_pol.c2, inp_buildup_land_x_pol.c3, inp_buildup_land_x_pol.perunit FROM SCHEMA_NAME.inp_buildup_land_x_pol;


CREATE VIEW "SCHEMA_NAME"."v_inp_controls" AS 
SELECT inp_controls.id, inp_controls.text FROM SCHEMA_NAME.inp_controls ORDER BY inp_controls.id;


CREATE OR REPLACE VIEW "SCHEMA_NAME"."v_inp_curve" AS 
SELECT inp_curve.id, inp_curve.curve_id, inp_curve.x_value, inp_curve.y_value,
(CASE WHEN x_value = (SELECT MIN(x_value) FROM SCHEMA_NAME.inp_curve AS sub WHERE sub.curve_id = inp_curve.curve_id) THEN inp_curve_id.curve_type ELSE null END) AS curve_type
FROM (SCHEMA_NAME.inp_curve JOIN SCHEMA_NAME.inp_curve_id ON (((inp_curve_id.id)::text = (inp_curve.curve_id)::text))) 
ORDER BY inp_curve.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_evap_co" AS 
SELECT inp_evaporation.evap_type AS type_evco, inp_evaporation.evap FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'CONSTANT'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_evap_do" AS 
SELECT 'DRY_ONLY'::text AS type_evdo, inp_evaporation.dry_only FROM SCHEMA_NAME.inp_evaporation;


CREATE VIEW "SCHEMA_NAME"."v_inp_evap_fl" AS 
SELECT inp_evaporation.evap_type AS type_evfl, inp_evaporation.pan_1, inp_evaporation.pan_2, inp_evaporation.pan_3, inp_evaporation.pan_4, inp_evaporation.pan_5, inp_evaporation.pan_6, inp_evaporation.pan_7, inp_evaporation.pan_8, inp_evaporation.pan_9, inp_evaporation.pan_10, inp_evaporation.pan_11, inp_evaporation.pan_12 FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'FILE'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_evap_mo" AS 
SELECT inp_evaporation.evap_type AS type_evmo, inp_evaporation.value_1, inp_evaporation.value_2, inp_evaporation.value_3, inp_evaporation.value_4, inp_evaporation.value_5, inp_evaporation.value_6, inp_evaporation.value_7, inp_evaporation.value_8, inp_evaporation.value_9, inp_evaporation.value_10, inp_evaporation.value_11, inp_evaporation.value_12 FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'MONTHLY'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_evap_pa" AS 
SELECT 'RECOVERY'::text AS type_evpa, inp_evaporation.recovery FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.recovery)::text > '0'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_evap_te" AS 
SELECT inp_evaporation.evap_type AS type_evte FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'TEMPERATURE'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_evap_ts" AS 
SELECT inp_evaporation.evap_type AS type_evts, inp_evaporation.timser_id FROM SCHEMA_NAME.inp_evaporation WHERE ((inp_evaporation.evap_type)::text = 'TIMESERIES'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_hydrograph" AS 
SELECT inp_hydrograph.id, inp_hydrograph.text FROM SCHEMA_NAME.inp_hydrograph ORDER BY inp_hydrograph.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_landuses" AS 
SELECT inp_landuses.landus_id, inp_landuses.sweepint, inp_landuses.availab, inp_landuses.lastsweep FROM SCHEMA_NAME.inp_landuses;


CREATE VIEW "SCHEMA_NAME"."v_inp_lidcontrol" AS 
SELECT inp_lid_control.lidco_id, inp_lid_control.lidco_type, inp_lid_control.value_2, inp_lid_control.value_3, inp_lid_control.value_4, inp_lid_control.value_5, inp_lid_control.value_6, inp_lid_control.value_7, inp_lid_control.value_8 FROM SCHEMA_NAME.inp_lid_control ORDER BY inp_lid_control.id;



CREATE VIEW "SCHEMA_NAME"."v_inp_options" AS 
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
    inp_options.end_date,
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
   FROM SCHEMA_NAME.inp_options,
    (SCHEMA_NAME.inp_selector_hydrology
   JOIN SCHEMA_NAME.cat_hydrology ON (((inp_selector_hydrology.hydrology_id)::text = (cat_hydrology.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_dl" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_padl, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'DAILY'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_ho" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_paho, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12, inp_pattern.factor_13, inp_pattern.factor_14, inp_pattern.factor_15, inp_pattern.factor_16, inp_pattern.factor_17, inp_pattern.factor_18, inp_pattern.factor_19, inp_pattern.factor_20, inp_pattern.factor_21, inp_pattern.factor_22, inp_pattern.factor_23, inp_pattern.factor_24 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'HOURLY'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_mo" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_pamo, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'MONTHLY'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_pattern_we" AS 
SELECT inp_pattern.pattern_id, inp_pattern.pattern_type AS type_pawe, inp_pattern.factor_1, inp_pattern.factor_2, inp_pattern.factor_3, inp_pattern.factor_4, inp_pattern.factor_5, inp_pattern.factor_6, inp_pattern.factor_7, inp_pattern.factor_8, inp_pattern.factor_9, inp_pattern.factor_10, inp_pattern.factor_11, inp_pattern.factor_12, inp_pattern.factor_13, inp_pattern.factor_14, inp_pattern.factor_15, inp_pattern.factor_16, inp_pattern.factor_17, inp_pattern.factor_18, inp_pattern.factor_19, inp_pattern.factor_20, inp_pattern.factor_21, inp_pattern.factor_22, inp_pattern.factor_23, inp_pattern.factor_24 FROM SCHEMA_NAME.inp_pattern WHERE ((inp_pattern.pattern_type)::text = 'WEEKEND'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_rgage_fl" AS 
SELECT raingage.rg_id, raingage.form_type, raingage.intvl, raingage.scf, raingage.rgage_type AS type_rgfl, raingage.fname, raingage.sta, raingage.units, (st_x(raingage.the_geom))::numeric(16,3) AS xcoord, (st_y(raingage.the_geom))::numeric(16,3) AS ycoord FROM SCHEMA_NAME.raingage WHERE ((raingage.rgage_type)::text = 'FILE'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_rgage_ts" AS 
SELECT raingage.rg_id, raingage.form_type, raingage.intvl, raingage.scf, raingage.rgage_type AS type_rgts, raingage.timser_id, (st_x(raingage.the_geom))::numeric(16,3) AS xcoord, (st_y(raingage.the_geom))::numeric(16,3) AS ycoord FROM SCHEMA_NAME.raingage WHERE ((raingage.rgage_type)::text = 'TIMESERIES'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_snowpack" AS 
SELECT inp_snowpack.snow_id, 'PLOWABLE'::text AS type_snpk1, inp_snowpack.cmin_1, inp_snowpack.cmax_1, inp_snowpack.tbase_1, inp_snowpack.fwf_1, inp_snowpack.sd0_1, inp_snowpack.fw0_1, inp_snowpack.snn0_1, 'IMPERVIOUS'::text AS type_snpk2, inp_snowpack.cmin_2, inp_snowpack.cmax_2, inp_snowpack.tbase_2, inp_snowpack.fwf_2, inp_snowpack.sd0_2, inp_snowpack.fw0_2, inp_snowpack.sd100_1, 'PERVIOUS'::text AS type_snpk3, inp_snowpack.cmin_3, inp_snowpack.cmax_3, inp_snowpack.tbase_3, inp_snowpack.fwf_3, inp_snowpack.sd0_3, inp_snowpack.fw0_3, inp_snowpack.sd100_2, 'REMOVAL'::text AS type_snpk4, inp_snowpack.sdplow, inp_snowpack.fout, inp_snowpack.fimp, inp_snowpack.fperv, inp_snowpack.fimelt, inp_snowpack.fsub, inp_snowpack.subc_id FROM SCHEMA_NAME.inp_snowpack;


CREATE VIEW "SCHEMA_NAME"."v_inp_temp_fl" AS 
SELECT inp_temperature.temp_type AS type_tefl, inp_temperature.fname, inp_temperature.start FROM SCHEMA_NAME.inp_temperature WHERE ((inp_temperature.temp_type)::text = 'FILE'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_temp_sn" AS 
SELECT 'SNOWMELT'::text AS type_tesn, inp_snowmelt.stemp, inp_snowmelt.atiwt, inp_snowmelt.rnm, inp_snowmelt.elev, inp_snowmelt.lat, inp_snowmelt.dtlong, 'ADC IMPERVIOUS'::text AS type_teai, inp_snowmelt.i_f0, inp_snowmelt.i_f1, inp_snowmelt.i_f2, inp_snowmelt.i_f3, inp_snowmelt.i_f4, inp_snowmelt.i_f5, inp_snowmelt.i_f6, inp_snowmelt.i_f7, inp_snowmelt.i_f8, inp_snowmelt.i_f9, 'ADC PERVIOUS'::text AS type_teap, inp_snowmelt.p_f0, inp_snowmelt.p_f1, inp_snowmelt.p_f2, inp_snowmelt.p_f3, inp_snowmelt.p_f4, inp_snowmelt.p_f5, inp_snowmelt.p_f6, inp_snowmelt.p_f7, inp_snowmelt.p_f8, inp_snowmelt.p_f9 FROM SCHEMA_NAME.inp_snowmelt;


CREATE VIEW "SCHEMA_NAME"."v_inp_temp_ts" AS 
SELECT inp_temperature.temp_type AS type_tets, inp_temperature.timser_id FROM SCHEMA_NAME.inp_temperature WHERE ((inp_temperature.temp_type)::text = 'TIMESERIES'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_temp_wf" AS 
SELECT 'WINDSPEED'::text AS type_tews, inp_windspeed.wind_type AS type_tefl, inp_windspeed.fname FROM SCHEMA_NAME.inp_windspeed WHERE ((inp_windspeed.wind_type)::text = 'FILE'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_temp_wm" AS 
SELECT 'WINDSPEED'::text AS type_tews, inp_windspeed.wind_type AS type_temo, inp_windspeed.value_1, inp_windspeed.value_2, inp_windspeed.value_3, inp_windspeed.value_4, inp_windspeed.value_5, inp_windspeed.value_6, inp_windspeed.value_7, inp_windspeed.value_8, inp_windspeed.value_9, inp_windspeed.value_10, inp_windspeed.value_11, inp_windspeed.value_12 FROM SCHEMA_NAME.inp_windspeed WHERE ((inp_windspeed.wind_type)::text = 'MONTHLY'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_timser_abs" AS 
SELECT inp_timeseries.timser_id, inp_timeseries.date, inp_timeseries.hour, inp_timeseries.value FROM (SCHEMA_NAME.inp_timeseries JOIN SCHEMA_NAME.inp_timser_id ON (((inp_timeseries.timser_id)::text = (inp_timser_id.id)::text))) WHERE ((inp_timser_id.times_type)::text = 'ABSOLUTE'::text) ORDER BY inp_timeseries.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_timser_fl" AS 
SELECT inp_timeseries.timser_id, 'FILE'::text AS type_times, inp_timeseries.fname FROM (SCHEMA_NAME.inp_timeseries JOIN SCHEMA_NAME.inp_timser_id ON (((inp_timeseries.timser_id)::text = (inp_timser_id.id)::text))) WHERE ((inp_timser_id.times_type)::text = 'FILE'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_timser_rel" AS 
SELECT inp_timeseries.timser_id, inp_timeseries."time", inp_timeseries.value FROM (SCHEMA_NAME.inp_timeseries JOIN SCHEMA_NAME.inp_timser_id ON (((inp_timeseries.timser_id)::text = (inp_timser_id.id)::text))) WHERE ((inp_timser_id.times_type)::text = 'RELATIVE'::text) ORDER BY inp_timeseries.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_transects" AS 
SELECT inp_transects.id, inp_transects.text FROM SCHEMA_NAME.inp_transects ORDER BY inp_transects.id;


CREATE VIEW "SCHEMA_NAME"."v_inp_washoff" AS 
SELECT inp_washoff_land_x_pol.landus_id, inp_washoff_land_x_pol.poll_id, inp_washoff_land_x_pol.funcw_type, inp_washoff_land_x_pol.c1, inp_washoff_land_x_pol.c2, inp_washoff_land_x_pol.sweepeffic, inp_washoff_land_x_pol.bmpeffic FROM SCHEMA_NAME.inp_washoff_land_x_pol;



-- ----------------------------
-- View structure for subcatchments  (SELECTED BY SECTOR & HYDROLOGY CATALOG) 
-- ----------------------------

CREATE VIEW "SCHEMA_NAME"."v_inp_infiltration_cu" AS 
 SELECT subcatchment.subc_id,subcatchment.curveno,subcatchment.conduct_2,subcatchment.drytime_2,inp_selector_sector.sector_id,cat_hydrology.infiltration
   FROM (((SCHEMA_NAME.subcatchment
   JOIN SCHEMA_NAME.inp_selector_sector ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text)))
   JOIN SCHEMA_NAME.cat_hydrology ON (((subcatchment.hydrology_id)::text = (cat_hydrology.id)::text)))
   JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text)))
  WHERE ((cat_hydrology.infiltration)::text = 'CURVE_NUMBER'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_infiltration_gr" AS 
SELECT subcatchment.subc_id, subcatchment.suction, subcatchment.conduct, subcatchment.initdef, inp_selector_sector.sector_id, cat_hydrology.infiltration 
FROM (SCHEMA_NAME.subcatchment 
JOIN SCHEMA_NAME.inp_selector_sector ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text))
JOIN SCHEMA_NAME.cat_hydrology ON (((subcatchment.hydrology_id)::text = (cat_hydrology.id)::text))
JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text))) 
WHERE ((cat_hydrology.infiltration)::text = 'GREEN_AMPT'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_infiltration_ho" AS 
SELECT subcatchment.subc_id, subcatchment.maxrate, subcatchment.minrate, subcatchment.decay, subcatchment.drytime, subcatchment.maxinfil, inp_selector_sector.sector_id, cat_hydrology.infiltration 
FROM (SCHEMA_NAME.subcatchment 
JOIN SCHEMA_NAME.inp_selector_sector ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text))
JOIN SCHEMA_NAME.cat_hydrology ON (((subcatchment.hydrology_id)::text = (cat_hydrology.id)::text))
JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text)))
WHERE ((cat_hydrology.infiltration)::text = 'MODIFIED_HORTON'::text) or ((cat_hydrology.infiltration)::text = 'HORTON'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_subcatch" AS 
SELECT subcatchment.subc_id, subcatchment.node_id, subcatchment.rg_id, subcatchment.area, subcatchment.imperv, subcatchment.width, subcatchment.slope, subcatchment.clength, subcatchment.snow_id, subcatchment.nimp, subcatchment.nperv, subcatchment.simp, subcatchment.sperv, subcatchment.zero, subcatchment.routeto, subcatchment.rted, inp_selector_sector.sector_id 
FROM (SCHEMA_NAME.subcatchment 
JOIN SCHEMA_NAME.inp_selector_sector ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text))
JOIN SCHEMA_NAME.cat_hydrology ON (((subcatchment.hydrology_id)::text = (cat_hydrology.id)::text))
JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_lidusage" AS 
SELECT inp_lidusage_subc_x_lidco.subc_id, inp_lidusage_subc_x_lidco.lidco_id, inp_lidusage_subc_x_lidco."number"::integer, inp_lidusage_subc_x_lidco.area, inp_lidusage_subc_x_lidco.width, inp_lidusage_subc_x_lidco.initsat, inp_lidusage_subc_x_lidco.fromimp, inp_lidusage_subc_x_lidco.toperv::integer, inp_lidusage_subc_x_lidco.rptfile, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_selector_sector
JOIN SCHEMA_NAME.subcatchment ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text)))
JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text))) 
JOIN SCHEMA_NAME.inp_lidusage_subc_x_lidco ON (((inp_lidusage_subc_x_lidco.subc_id)::text = (subcatchment.subc_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_groundwater" AS 
SELECT inp_groundwater.subc_id, inp_groundwater.aquif_id, inp_groundwater.node_id, inp_groundwater.surfel, inp_groundwater.a1, inp_groundwater.b1, inp_groundwater.a2, inp_groundwater.b2, inp_groundwater.a3, inp_groundwater.tw, inp_groundwater.h, (('LATERAL'::text || ' '::text) || (inp_groundwater.fl_eq_lat)::text) AS fl_eq_lat, (('DEEP'::text || ' '::text) || (inp_groundwater.fl_eq_lat)::text) AS fl_eq_deep, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.subcatchment 
JOIN SCHEMA_NAME.inp_groundwater ON (((inp_groundwater.subc_id)::text = (subcatchment.subc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text)))
JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_coverages" AS 
SELECT subcatchment.subc_id, inp_coverage_land_x_subc.landus_id, inp_coverage_land_x_subc.percent, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_coverage_land_x_subc 
JOIN SCHEMA_NAME.subcatchment ON (((inp_coverage_land_x_subc.subc_id)::text = (subcatchment.subc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text)))
JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_loadings" AS 
SELECT inp_loadings_pol_x_subc.poll_id, inp_loadings_pol_x_subc.subc_id, inp_loadings_pol_x_subc.ibuildup, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_selector_sector 
JOIN SCHEMA_NAME.subcatchment ON (((subcatchment.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_loadings_pol_x_subc ON (((inp_loadings_pol_x_subc.subc_id)::text = (subcatchment.subc_id)::text)))
JOIN SCHEMA_NAME.inp_selector_hydrology ON (((subcatchment.hydrology_id)::text = (inp_selector_hydrology.hydrology_id)::text)));










-- ------------------------------------------------------------------
-- View structure for v_inp ARC  (SELECTED BY SECTOR & STATE SELECTION)
-- ------------------------------------------------------------------


CREATE VIEW "SCHEMA_NAME"."v_inp_conduit_cu" AS 
SELECT 
arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, v_arc_x_node.z1, v_arc_x_node.z2, 
cat_mat_arc.n,
cat_arc.shape, cat_arc.curve_id, cat_arc.geom1, cat_arc.geom2, cat_arc.geom3, cat_arc.geom4,  
inp_conduit.q0, inp_conduit.qmax, 
inp_conduit.barrels, inp_conduit.culvert, inp_conduit.seepage, inp_selector_sector.sector_id 
FROM ((((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_conduit ON (((arc.arc_id)::text = (inp_conduit.arc_id)::text)))
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text)))   
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))) 
JOIN SCHEMA_NAME.cat_mat_arc ON (((cat_arc.matcat_id)::text = (cat_mat_arc.id)::text)))
JOIN SCHEMA_NAME.inp_selector_sector ON (((inp_selector_sector.sector_id)::text = (arc.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text)))
WHERE ((cat_arc.shape)::text = 'CUSTOM'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_conduit_no" AS 
SELECT arc.arc_id, 
v_arc_x_node.node_1, v_arc_x_node.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, v_arc_x_node.z1, v_arc_x_node.z2, 
cat_mat_arc.n,
cat_arc.shape, cat_arc.geom1, cat_arc.geom2, cat_arc.geom3, cat_arc.geom4,  
inp_conduit.q0, inp_conduit.qmax, inp_conduit.barrels, inp_conduit.culvert, inp_conduit.seepage, inp_selector_sector.sector_id 
FROM ((((((SCHEMA_NAME.arc
JOIN SCHEMA_NAME.inp_conduit ON (((arc.arc_id)::text = (inp_conduit.arc_id)::text)))
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text)))   
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))) 
JOIN SCHEMA_NAME.cat_mat_arc ON (((cat_arc.matcat_id)::text = (cat_mat_arc.id)::text)))
JOIN SCHEMA_NAME.inp_selector_sector ON (((inp_selector_sector.sector_id)::text = (arc.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text))) 
WHERE ((((cat_arc.shape)::text < 'CUSTOM'::text) OR (((cat_arc.shape)::text > 'CUSTOM'::text) AND ((cat_arc.shape)::text < 'IRREGULAR'::text))) OR ((cat_arc.shape)::text > 'IRREGULAR'::text));


CREATE VIEW "SCHEMA_NAME"."v_inp_conduit_xs" AS 
SELECT arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, (st_length2d(arc.the_geom))::numeric(16,3) AS length, v_arc_x_node.z1, v_arc_x_node.z2, 
cat_mat_arc.n,
cat_arc.shape, cat_arc.tsect_id, cat_arc.geom1, cat_arc.geom2, cat_arc.geom3, cat_arc.geom4, 
inp_conduit.q0, inp_conduit.qmax, inp_conduit.barrels,inp_conduit.culvert, inp_conduit.seepage, inp_selector_sector.sector_id 
FROM ((((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_conduit ON (((arc.arc_id)::text = (inp_conduit.arc_id)::text)))
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text)))   
JOIN SCHEMA_NAME.cat_arc ON (((arc.arccat_id)::text = (cat_arc.id)::text))) 
JOIN SCHEMA_NAME.cat_mat_arc ON (((cat_arc.matcat_id)::text = (cat_mat_arc.id)::text)))
JOIN SCHEMA_NAME.inp_selector_sector ON (((inp_selector_sector.sector_id)::text = (arc.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text)))
WHERE ((cat_arc.shape)::text = 'IRREGULAR'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_orifice" AS 
SELECT inp_orifice.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, inp_orifice.ori_type, inp_orifice."offset", inp_orifice.cd, inp_orifice.flap, inp_orifice.orate, inp_orifice.shape, inp_orifice.geom1, inp_orifice.geom2, inp_orifice.geom3, inp_orifice.geom4, inp_selector_sector.sector_id 
FROM ((((SCHEMA_NAME.arc JOIN SCHEMA_NAME.inp_orifice ON (((inp_orifice.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_fcd" AS 
SELECT arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, inp_outlet.outlet_type AS type_oufcd, inp_outlet."offset", inp_outlet.cd1, inp_outlet.cd2, inp_outlet.flap, inp_selector_sector.sector_id FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_outlet ON ((((arc.arc_id)::text = (inp_outlet.arc_id)::text) AND ((arc.arc_id)::text = (inp_outlet.arc_id)::text)))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outlet.outlet_type)::text = 'FUNCTIONAL/DEPTH'::text) ;


CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_fch" AS 
SELECT arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, inp_outlet.outlet_type AS type_oufch, inp_outlet."offset", inp_outlet.cd1, inp_outlet.cd2, inp_outlet.flap, inp_selector_sector.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outlet.outlet_type)::text = 'FUNCTIONAL/HEAD'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_tbd" AS 
SELECT arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, inp_outlet.outlet_type AS type_outbd, inp_outlet."offset", inp_outlet.curve_id, inp_outlet.flap, inp_selector_sector.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outlet.outlet_type)::text = 'TABULAR/DEPTH'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_outlet_tbh" AS 
SELECT arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, inp_outlet.outlet_type AS type_outbh, inp_outlet."offset", inp_outlet.curve_id, inp_outlet.flap, inp_selector_sector.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_outlet ON (((arc.arc_id)::text = (inp_outlet.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outlet.outlet_type)::text = 'TABULAR/HEAD'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_pump" AS 
SELECT arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, inp_pump.curve_id, inp_pump."status", inp_pump.startup, inp_pump.shutoff, inp_selector_sector.sector_id 
FROM ((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_pump ON (((arc.arc_id)::text = (inp_pump.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_weir" AS 
SELECT arc.arc_id, v_arc_x_node.node_1, v_arc_x_node.node_2, inp_weir.weir_type, inp_weir."offset", inp_weir.cd, inp_weir.flap, inp_weir.ec, inp_weir.cd2, inp_value_weirs.shape, inp_weir.geom1, inp_weir.geom2, inp_weir.geom3, inp_weir.geom4, inp_weir.surcharge, inp_selector_sector.sector_id 
FROM (((((SCHEMA_NAME.arc 
JOIN SCHEMA_NAME.inp_weir ON (((inp_weir.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_value_weirs ON (((inp_weir.weir_type)::text = (inp_value_weirs.id)::text))) 
JOIN SCHEMA_NAME.v_arc_x_node ON (((v_arc_x_node.arc_id)::text = (arc.arc_id)::text)))
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text)))  
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_losses" AS 
SELECT inp_conduit.arc_id, inp_conduit.kentry, inp_conduit.kexit, inp_conduit.kavg, inp_conduit.flap, inp_conduit.seepage, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_conduit 
JOIN SCHEMA_NAME.arc ON (((inp_conduit.arc_id)::text = (arc.arc_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((arc.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text))) 
WHERE ((((inp_conduit.kentry > (0)::numeric) OR (inp_conduit.kexit > (0)::numeric)) OR (inp_conduit.kavg > (0)::numeric)) OR ((inp_conduit.flap)::text = 'YES'::text));







-- ------------------------------------------------------------------
-- View structure for v_inp NODE (SELECTED BY SECTOR & STATE SELECTION)
-- ----------------------------------------------------------------


CREATE VIEW "SCHEMA_NAME"."v_inp_junction" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, node.ymax, inp_junction.y0, inp_junction.ysur, inp_junction.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_junction 
JOIN SCHEMA_NAME.node ON (((inp_junction.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_divider_cu" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_divider.arc_id, inp_divider.divider_type AS type_dicu, inp_divider.qmin, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_divider.divider_type)::text = 'CUTOFF'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_divider_ov" AS 
SELECT node.node_id, inp_divider.arc_id, (node.top_elev - node.ymax) AS elev, inp_divider.divider_type AS type_diov, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_divider.divider_type)::text = 'OVERFLOW'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_divider_tb" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_divider.arc_id, inp_divider.divider_type AS type_ditb, inp_divider.curve_id, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_divider.divider_type)::text = 'TABULAR'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_divider_wr" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_divider.arc_id, inp_divider.divider_type AS type_diwr, inp_divider.qmin, inp_divider.ht, inp_divider.cd, node.ymax, inp_divider.y0, inp_divider.ysur, inp_divider.apond, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_divider ON (((node.node_id)::text = (inp_divider.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_divider.divider_type)::text = 'WEIR'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_fi" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlfi, inp_outfall.stage, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_outfall ON (((inp_outfall.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outfall.outfall_type)::text = 'FIXED'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_fr" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlfr, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outfall.outfall_type)::text = 'FREE'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_nm" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlnm, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outfall.outfall_type)::text = 'NORMAL'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_ti" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlti, inp_outfall.curve_id, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outfall.outfall_type)::text = 'TIDAL'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_outfall_ts" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, inp_outfall.outfall_type AS type_otlts, inp_outfall.timser_id, inp_outfall.gate, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_outfall ON (((node.node_id)::text = (inp_outfall.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_outfall.outfall_type)::text = 'TIMESERIES'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_storage_fc" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, node.ymax, inp_storage.y0, inp_storage.storage_type AS type_stfc, inp_storage.a1, inp_storage.a2, inp_storage.a0, inp_storage.apond, inp_storage.fevap, inp_storage.sh, inp_storage.hc, inp_storage.imd, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_storage ON (((node.node_id)::text = (inp_storage.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_storage.storage_type)::text = 'FUNCTIONAL'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_storage_tb" AS 
SELECT node.node_id, (node.top_elev - node.ymax) AS elev, node.ymax, inp_storage.y0, inp_storage.storage_type AS type_sttb, inp_storage.curve_id, inp_storage.apond, inp_storage.fevap, inp_storage.sh, inp_storage.hc, inp_storage.imd, (st_x(node.the_geom))::numeric(16,3) AS xcoord, (st_y(node.the_geom))::numeric(16,3) AS ycoord, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_storage ON (((node.node_id)::text = (inp_storage.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text))) 
WHERE ((inp_storage.storage_type)::text = 'TABULAR'::text);


CREATE VIEW "SCHEMA_NAME"."v_inp_dwf_flow" AS 
SELECT node.node_id, 'FLOW'::text AS type_dwf, inp_dwf.value, inp_dwf.pat1, inp_dwf.pat2, inp_dwf.pat3, inp_dwf.pat4, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_selector_sector 
JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_dwf ON (((inp_dwf.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_dwf_load" AS 
SELECT inp_dwf_pol_x_node.poll_id, node.node_id, inp_dwf_pol_x_node.value, inp_dwf_pol_x_node.pat1, inp_dwf_pol_x_node.pat2, inp_dwf_pol_x_node.pat3, inp_dwf_pol_x_node.pat4, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_selector_sector JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_dwf_pol_x_node ON (((inp_dwf_pol_x_node.node_id)::text = (node.node_id)::text))));


CREATE VIEW "SCHEMA_NAME"."v_inp_inflows_flow" AS 
SELECT inp_inflows.node_id, 'FLOW'::text AS type_flow1, inp_inflows.timser_id, 'FLOW'::text AS type_flow2, '1'::text AS type_n1, inp_inflows.sfactor, inp_inflows.base, inp_inflows.pattern_id, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_selector_sector 
JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_inflows ON (((inp_inflows.node_id)::text = (node.node_id)::text)))
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_inp_inflows_load" AS 
SELECT inp_inflows_pol_x_node.poll_id, node.node_id, inp_inflows_pol_x_node.timser_id, inp_inflows_pol_x_node.form_type, inp_inflows_pol_x_node.mfactor, inp_inflows_pol_x_node.sfactor, inp_inflows_pol_x_node.base, inp_inflows_pol_x_node.pattern_id, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_selector_sector 
JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_inflows_pol_x_node ON (((inp_inflows_pol_x_node.node_id)::text = (node.node_id)::text)))
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text)));



CREATE VIEW "SCHEMA_NAME"."v_inp_rdii" AS 
SELECT node.node_id, inp_rdii.hydro_id, inp_rdii.sewerarea, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.inp_selector_sector 
JOIN SCHEMA_NAME.node ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text))) 
JOIN SCHEMA_NAME.inp_rdii ON (((inp_rdii.node_id)::text = (node.node_id)::text)))
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text)));



CREATE VIEW "SCHEMA_NAME"."v_inp_treatment" AS 
SELECT node.node_id, inp_treatment_node_x_pol.poll_id, inp_treatment_node_x_pol.function, inp_selector_sector.sector_id 
FROM (((SCHEMA_NAME.node 
JOIN SCHEMA_NAME.inp_treatment_node_x_pol ON (((inp_treatment_node_x_pol.node_id)::text = (node.node_id)::text))) 
JOIN SCHEMA_NAME.inp_selector_sector ON (((node.sector_id)::text = (inp_selector_sector.sector_id)::text)))
JOIN SCHEMA_NAME.inp_selector_state ON (((node."state")::text = (inp_selector_state.id)::text)));





-- ----------------------------
-- View structure for v_vertice
-- ----------------------------


CREATE OR REPLACE VIEW SCHEMA_NAME.v_inp_vertice AS 
 SELECT nextval('SCHEMA_NAME.inp_vertice_seq'::regclass) AS id,
    arc.arc_id,
    st_x(arc.point)::numeric(16,3) AS xcoord,
    st_y(arc.point)::numeric(16,3) AS ycoord
   FROM (( SELECT (st_dumppoints(arc_1.the_geom)).geom AS point,
            st_startpoint(arc_1.the_geom) AS startpoint,
            st_endpoint(arc_1.the_geom) AS endpoint,
            arc_1.sector_id,
			arc_1."state",
            arc_1.arc_id
           FROM SCHEMA_NAME.arc arc_1) arc
   JOIN SCHEMA_NAME.inp_selector_sector ON arc.sector_id::text = inp_selector_sector.sector_id::text
   JOIN SCHEMA_NAME.inp_selector_state ON (((arc."state")::text = (inp_selector_state.id)::text)))
  WHERE (arc.point < arc.startpoint OR arc.point > arc.startpoint) AND (arc.point < arc.endpoint OR arc.point > arc.endpoint)
  ORDER BY nextval('SCHEMA_NAME.inp_vertice_seq'::regclass);





-- ----------------------------
-- View structure for v_rpt_
-- ----------------------------

CREATE VIEW "SCHEMA_NAME"."v_rpt_arcflow_sum" AS 
SELECT rpt_arcflow_sum.id, rpt_selector_result.result_id, rpt_arcflow_sum.arc_id, rpt_arcflow_sum.arc_type, rpt_arcflow_sum.max_flow, rpt_arcflow_sum.time_days, rpt_arcflow_sum.time_hour, rpt_arcflow_sum.max_veloc, rpt_arcflow_sum.mfull_flow, rpt_arcflow_sum.mfull_dept, rpt_arcflow_sum.max_shear, rpt_arcflow_sum.max_hr, rpt_arcflow_sum.max_slope, rpt_arcflow_sum.day_max, rpt_arcflow_sum.time_max, rpt_arcflow_sum.min_shear,rpt_arcflow_sum.day_min, rpt_arcflow_sum.time_min, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.arc JOIN SCHEMA_NAME.rpt_arcflow_sum ON ((((rpt_arcflow_sum.arc_id)::text = (arc.arc_id)::text) AND ((arc.arc_id)::text = (rpt_arcflow_sum.arc_id)::text)))) JOIN SCHEMA_NAME.rpt_selector_result ON (((rpt_arcflow_sum.result_id)::text = (rpt_selector_result.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_arcpolload_sum" AS 
SELECT rpt_arcpolload_sum.id, rpt_arcpolload_sum.result_id, rpt_arcpolload_sum.arc_id, rpt_arcpolload_sum.poll_id, arc.sector_id, arc.the_geom FROM ("SCHEMA_NAME".rpt_selector_result JOIN "SCHEMA_NAME".rpt_arcpolload_sum ON (((rpt_selector_result.result_id)::text = (rpt_arcpolload_sum.result_id)::text))) JOIN "SCHEMA_NAME".arc ON (((rpt_arcpolload_sum.arc_id)::text = (arc.arc_id)::text));


CREATE VIEW "SCHEMA_NAME"."v_rpt_condsurcharge_sum" AS 
SELECT rpt_condsurcharge_sum.id, rpt_condsurcharge_sum.result_id, rpt_condsurcharge_sum.arc_id, rpt_condsurcharge_sum.both_ends, rpt_condsurcharge_sum.upstream, rpt_condsurcharge_sum.dnstream, rpt_condsurcharge_sum.hour_nflow, rpt_condsurcharge_sum.hour_limit, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_condsurcharge_sum ON ((((rpt_selector_result.result_id)::text = (rpt_condsurcharge_sum.result_id)::text) AND ((rpt_selector_result.result_id)::text = (rpt_condsurcharge_sum.result_id)::text)))) JOIN SCHEMA_NAME.arc ON (((arc.arc_id)::text = (rpt_condsurcharge_sum.arc_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_continuity_errors" AS 
SELECT rpt_continuity_errors.id, rpt_continuity_errors.result_id, rpt_continuity_errors.text FROM (SCHEMA_NAME.rpt_continuity_errors JOIN SCHEMA_NAME.rpt_selector_result ON (((rpt_continuity_errors.result_id)::text = (rpt_selector_result.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_critical_elements" AS 
SELECT rpt_critical_elements.id, rpt_critical_elements.result_id, rpt_critical_elements.text FROM (SCHEMA_NAME.rpt_critical_elements JOIN SCHEMA_NAME.rpt_selector_result ON (((rpt_critical_elements.result_id)::text = (rpt_selector_result.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_flowclass_sum" AS 
SELECT rpt_flowclass_sum.id, rpt_flowclass_sum.result_id, rpt_flowclass_sum.arc_id, rpt_flowclass_sum.length, rpt_flowclass_sum.dry, rpt_flowclass_sum.up_dry, rpt_flowclass_sum.down_dry, rpt_flowclass_sum.sub_crit, rpt_flowclass_sum.sub_crit_1, rpt_flowclass_sum.up_crit, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.arc JOIN SCHEMA_NAME.rpt_flowclass_sum ON (((rpt_flowclass_sum.arc_id)::text = (arc.arc_id)::text))) JOIN SCHEMA_NAME.rpt_selector_result ON (((rpt_flowclass_sum.result_id)::text = (rpt_selector_result.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_flowrouting_cont" AS 
SELECT rpt_flowrouting_cont.id, rpt_flowrouting_cont.result_id, rpt_flowrouting_cont.dryw_inf, rpt_flowrouting_cont.wetw_inf, rpt_flowrouting_cont.ground_inf, rpt_flowrouting_cont.rdii_inf, rpt_flowrouting_cont.ext_inf, rpt_flowrouting_cont.ext_out, rpt_flowrouting_cont.int_out, rpt_flowrouting_cont.evap_losses, rpt_flowrouting_cont.seepage_losses, rpt_flowrouting_cont.stor_loss, rpt_flowrouting_cont.initst_vol, rpt_flowrouting_cont.finst_vol, rpt_flowrouting_cont.cont_error FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_flowrouting_cont ON (((rpt_selector_result.result_id)::text = (rpt_flowrouting_cont.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_groundwater_cont" AS 
SELECT rpt_groundwater_cont.id, rpt_groundwater_cont.result_id, rpt_groundwater_cont.init_stor, rpt_groundwater_cont.infilt, rpt_groundwater_cont.upzone_et, rpt_groundwater_cont.lowzone_et, rpt_groundwater_cont.deep_perc, rpt_groundwater_cont.groundw_fl, rpt_groundwater_cont.final_stor, rpt_groundwater_cont.cont_error FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_groundwater_cont ON (((rpt_selector_result.result_id)::text = (rpt_groundwater_cont.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_high_cont_errors" AS 
SELECT rpt_continuity_errors.id, rpt_continuity_errors.result_id, rpt_continuity_errors.text FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_continuity_errors ON (((rpt_selector_result.result_id)::text = (rpt_continuity_errors.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_high_flowinest_ind" AS 
SELECT rpt_high_flowinest_ind.id, rpt_high_flowinest_ind.result_id, rpt_high_flowinest_ind.text FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_high_flowinest_ind ON (((rpt_selector_result.result_id)::text = (rpt_high_flowinest_ind.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_instability_index" AS 
SELECT rpt_instability_index.id, rpt_instability_index.result_id, rpt_instability_index.text FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_instability_index ON (((rpt_selector_result.result_id)::text = (rpt_instability_index.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_lidperfomance_sum" AS 
SELECT rpt_lidperformance_sum.id, rpt_lidperformance_sum.result_id, rpt_lidperformance_sum.subc_id, rpt_lidperformance_sum.lidco_id, rpt_lidperformance_sum.tot_inflow, rpt_lidperformance_sum.evap_loss, rpt_lidperformance_sum.infil_loss, rpt_lidperformance_sum.surf_outf, rpt_lidperformance_sum.drain_outf, rpt_lidperformance_sum.init_stor, rpt_lidperformance_sum.final_stor, rpt_lidperformance_sum.per_error, subcatchment.sector_id, subcatchment.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_lidperformance_sum ON (((rpt_selector_result.result_id)::text = (rpt_lidperformance_sum.result_id)::text))) JOIN SCHEMA_NAME.subcatchment ON (((rpt_lidperformance_sum.subc_id)::text = (subcatchment.subc_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_nodedepth_sum" AS 
SELECT rpt_nodedepth_sum.id, rpt_nodedepth_sum.result_id, rpt_nodedepth_sum.node_id, rpt_nodedepth_sum.swnod_type, rpt_nodedepth_sum.aver_depth, rpt_nodedepth_sum.max_depth, rpt_nodedepth_sum.max_hgl, rpt_nodedepth_sum.time_days, rpt_nodedepth_sum.time_hour, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_nodedepth_sum ON ((((rpt_nodedepth_sum.result_id)::text = (rpt_selector_result.result_id)::text) AND ((rpt_selector_result.result_id)::text = (rpt_nodedepth_sum.result_id)::text)))) JOIN SCHEMA_NAME.node ON (((rpt_nodedepth_sum.node_id)::text = (node.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_nodeflooding_sum" AS 
SELECT rpt_nodeflooding_sum.id, rpt_selector_result.result_id, rpt_nodeflooding_sum.node_id, rpt_nodeflooding_sum.hour_flood, rpt_nodeflooding_sum.max_rate, rpt_nodeflooding_sum.time_days, rpt_nodeflooding_sum.time_hour, rpt_nodeflooding_sum.tot_flood, rpt_nodeflooding_sum.max_ponded, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.node JOIN SCHEMA_NAME.rpt_nodeflooding_sum ON (((rpt_nodeflooding_sum.node_id)::text = (node.node_id)::text))) JOIN SCHEMA_NAME.rpt_selector_result ON (((rpt_nodeflooding_sum.result_id)::text = (rpt_selector_result.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_nodeinflow_sum" AS 
SELECT rpt_nodeinflow_sum.id, rpt_nodeinflow_sum.result_id, rpt_nodeinflow_sum.node_id, rpt_nodeinflow_sum.swnod_type, rpt_nodeinflow_sum.max_latinf, rpt_nodeinflow_sum.max_totinf, rpt_nodeinflow_sum.time_days, rpt_nodeinflow_sum.time_hour, rpt_nodeinflow_sum.latinf_vol, rpt_nodeinflow_sum.totinf_vol, rpt_nodeinflow_sum.flow_balance_error, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_nodeinflow_sum ON (((rpt_selector_result.result_id)::text = (rpt_nodeinflow_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((rpt_nodeinflow_sum.node_id)::text = (node.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_nodesurcharge_sum" AS 
SELECT rpt_nodesurcharge_sum.id, rpt_nodesurcharge_sum.result_id, rpt_nodesurcharge_sum.swnod_type, rpt_nodesurcharge_sum.hour_surch, rpt_nodesurcharge_sum.max_height, rpt_nodesurcharge_sum.min_depth, node.sector_id, node.the_geom 	FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_nodesurcharge_sum ON (((rpt_selector_result.result_id)::text = (rpt_nodesurcharge_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((rpt_nodesurcharge_sum.node_id)::text = (node.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_outfallflow_sum" AS 
SELECT rpt_outfallflow_sum.id, rpt_outfallflow_sum.node_id, rpt_outfallflow_sum.result_id, rpt_outfallflow_sum.flow_freq, rpt_outfallflow_sum.avg_flow, rpt_outfallflow_sum.max_flow, rpt_outfallflow_sum.total_vol, node.the_geom, node.sector_id FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_outfallflow_sum ON (((rpt_selector_result.result_id)::text = (rpt_outfallflow_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (rpt_outfallflow_sum.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_outfallload_sum" AS 
SELECT rpt_outfallload_sum.id, rpt_outfallload_sum.result_id, rpt_outfallload_sum.poll_id, rpt_outfallload_sum.node_id, rpt_outfallload_sum.value, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_outfallload_sum ON (((rpt_selector_result.result_id)::text = (rpt_outfallload_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (rpt_outfallload_sum.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_pumping_sum" AS 
SELECT rpt_pumping_sum.id, rpt_pumping_sum.result_id, rpt_pumping_sum.arc_id, rpt_pumping_sum.percent,  rpt_pumping_sum.num_startup, rpt_pumping_sum.min_flow, rpt_pumping_sum.avg_flow, rpt_pumping_sum.max_flow, rpt_pumping_sum.vol_ltr, rpt_pumping_sum.powus_kwh, rpt_pumping_sum.timoff_min,  rpt_pumping_sum.timoff_max, arc.sector_id, arc.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_pumping_sum ON (((rpt_selector_result.result_id)::text = (rpt_pumping_sum.result_id)::text))) JOIN SCHEMA_NAME.arc ON (((arc.arc_id)::text = (rpt_pumping_sum.arc_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_qualrouting" AS 
SELECT rpt_qualrouting_cont.id, rpt_qualrouting_cont.result_id, rpt_qualrouting_cont.poll_id, rpt_qualrouting_cont.dryw_inf, rpt_qualrouting_cont.wetw_inf, rpt_qualrouting_cont.ground_inf, rpt_qualrouting_cont.rdii_inf, rpt_qualrouting_cont.ext_inf, rpt_qualrouting_cont.int_inf, rpt_qualrouting_cont.ext_out, rpt_qualrouting_cont.mass_reac, rpt_qualrouting_cont.initst_mas, rpt_qualrouting_cont.finst_mas, rpt_qualrouting_cont.cont_error FROM (SCHEMA_NAME.rpt_qualrouting_cont JOIN SCHEMA_NAME.rpt_selector_result ON (((rpt_selector_result.result_id)::text = (rpt_qualrouting_cont.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_rainfall_dep" AS 
SELECT rpt_rainfall_dep.id, rpt_rainfall_dep.result_id, rpt_rainfall_dep.sewer_rain, rpt_rainfall_dep.rdiip_prod, rpt_rainfall_dep.rdiir_rat FROM (SCHEMA_NAME.rpt_rainfall_dep JOIN SCHEMA_NAME.rpt_selector_result ON (((rpt_selector_result.result_id)::text = (rpt_rainfall_dep.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_routing_timestep" AS 
SELECT rpt_routing_timestep.id, rpt_routing_timestep.result_id, rpt_routing_timestep.text FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_routing_timestep ON (((rpt_selector_result.result_id)::text = (rpt_routing_timestep.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_runoff_qual" AS 
SELECT rpt_runoff_qual.id, rpt_runoff_qual.result_id, rpt_runoff_qual.poll_id, rpt_runoff_qual.init_buil, rpt_runoff_qual.surf_buil, rpt_runoff_qual.wet_dep, rpt_runoff_qual.sweep_re, rpt_runoff_qual.infil_loss, rpt_runoff_qual.bmp_re, rpt_runoff_qual.surf_runof, rpt_runoff_qual.rem_buil, rpt_runoff_qual.cont_error FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_runoff_qual ON (((rpt_selector_result.result_id)::text = (rpt_runoff_qual.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_runoff_quant" AS 
SELECT rpt_runoff_quant.id, rpt_runoff_quant.result_id, rpt_runoff_quant.initsw_co, rpt_runoff_quant.total_prec, rpt_runoff_quant.evap_loss, rpt_runoff_quant.infil_loss, rpt_runoff_quant.surf_runof, rpt_runoff_quant.snow_re, rpt_runoff_quant.finalsw_co, rpt_runoff_quant.finals_sto, rpt_runoff_quant.cont_error FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_runoff_quant ON (((rpt_selector_result.result_id)::text = (rpt_runoff_quant.result_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_storagevol_sum" AS 
SELECT rpt_storagevol_sum.id, rpt_storagevol_sum.result_id, rpt_storagevol_sum.node_id, rpt_storagevol_sum.aver_vol, rpt_storagevol_sum.avg_full, rpt_storagevol_sum.ei_loss, rpt_storagevol_sum.max_vol, rpt_storagevol_sum.max_full, rpt_storagevol_sum.time_days, rpt_storagevol_sum.time_hour, rpt_storagevol_sum.max_out, node.sector_id, node.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_storagevol_sum ON (((rpt_selector_result.result_id)::text = (rpt_storagevol_sum.result_id)::text))) JOIN SCHEMA_NAME.node ON (((node.node_id)::text = (rpt_storagevol_sum.node_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_subcatchrunoff_sum" AS 
SELECT rpt_subcathrunoff_sum.id, rpt_subcathrunoff_sum.result_id, rpt_subcathrunoff_sum.subc_id, rpt_subcathrunoff_sum.tot_precip, rpt_subcathrunoff_sum.tot_runon, rpt_subcathrunoff_sum.tot_evap, rpt_subcathrunoff_sum.tot_infil, rpt_subcathrunoff_sum.tot_runoff, rpt_subcathrunoff_sum.tot_runofl, rpt_subcathrunoff_sum.peak_runof, rpt_subcathrunoff_sum.runoff_coe, rpt_subcathrunoff_sum.vxmax, rpt_subcathrunoff_sum.vymax, rpt_subcathrunoff_sum.depth, rpt_subcathrunoff_sum.vel, rpt_subcathrunoff_sum.vhmax, subcatchment.sector_id, subcatchment.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_subcathrunoff_sum ON (((rpt_selector_result.result_id)::text = (rpt_subcathrunoff_sum.result_id)::text))) JOIN SCHEMA_NAME.subcatchment ON (((rpt_subcathrunoff_sum.subc_id)::text = (subcatchment.subc_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_subcatchwasoff_sum" AS 
SELECT rpt_subcatchwashoff_sum.id, rpt_subcatchwashoff_sum.result_id, rpt_subcatchwashoff_sum.subc_id, rpt_subcatchwashoff_sum.poll_id, rpt_subcatchwashoff_sum.value, subcatchment.sector_id, subcatchment.the_geom FROM ((SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_subcatchwashoff_sum ON (((rpt_selector_result.result_id)::text = (rpt_subcatchwashoff_sum.result_id)::text))) JOIN SCHEMA_NAME.subcatchment ON (((rpt_subcatchwashoff_sum.subc_id)::text = (subcatchment.subc_id)::text)));


CREATE VIEW "SCHEMA_NAME"."v_rpt_timestep_critelem" AS 
SELECT rpt_timestep_critelem.id, rpt_timestep_critelem.result_id, rpt_timestep_critelem.text FROM (SCHEMA_NAME.rpt_selector_result JOIN SCHEMA_NAME.rpt_timestep_critelem ON (((rpt_selector_result.result_id)::text = (rpt_timestep_critelem.result_id)::text)));

