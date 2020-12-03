/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/03/19

DROP VIEW IF EXISTS v_inp_subcatch;
DROP VIEW IF EXISTS v_inp_infiltration_cu;
DROP VIEW IF EXISTS v_inp_infiltration_gr;
DROP VIEW IF EXISTS v_inp_infiltration_ho;
DROP VIEW IF EXISTS v_inp_lidusage;
DROP VIEW IF EXISTS v_inp_groundwater;
DROP VIEW IF EXISTS v_inp_coverages;
DROP VIEW IF EXISTS v_inp_loadings;
DROP VIEW IF EXISTS v_inp_subcatch2node;
DROP VIEW IF EXISTS v_inp_subcatchcentroid;

DROP VIEW IF EXISTS v_edit_subcatchment;
CREATE OR REPLACE VIEW v_edit_subcatchment AS 
 SELECT subcatchment.subc_id,
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
    subcatchment.rted,
    subcatchment.maxrate,
    subcatchment.minrate,
    subcatchment.decay,
    subcatchment.drytime,
    subcatchment.maxinfil,
    subcatchment.suction,
    subcatchment.conduct,
    subcatchment.initdef,
    subcatchment.curveno,
    subcatchment.conduct_2,
    subcatchment.drytime_2,
    subcatchment.sector_id,
    subcatchment.hydrology_id,
    subcatchment.the_geom,
	subcatchment.parent_id,
	subcatchment.descript
   FROM inp_selector_sector,
    inp_selector_hydrology,
    subcatchment
     JOIN v_node ON v_node.node_id::text = subcatchment.node_id::text
  WHERE subcatchment.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text AND subcatchment.hydrology_id = inp_selector_hydrology.hydrology_id AND inp_selector_hydrology.cur_user = "current_user"()::text;



CREATE VIEW "v_inp_infiltration_cu" AS 
SELECT 
subc_id,
curveno,
conduct_2,
drytime_2
FROM v_edit_subcatchment
	JOIN cat_hydrology ON cat_hydrology.hydrology_id=v_edit_subcatchment.hydrology_id
	WHERE cat_hydrology.infiltration='CURVE_NUMBER';



CREATE VIEW "v_inp_infiltration_gr" AS 
SELECT
subc_id, 
suction, 
conduct, 
initdef 
FROM v_edit_subcatchment
	JOIN cat_hydrology ON cat_hydrology.hydrology_id=v_edit_subcatchment.hydrology_id
	WHERE cat_hydrology.infiltration='GREEN_AMPT';



CREATE VIEW "v_inp_infiltration_ho" AS 
SELECT 
subc_id, 
maxrate, 
minrate, 
decay, 
drytime, 
maxinfil
FROM v_edit_subcatchment
	JOIN cat_hydrology ON cat_hydrology.hydrology_id=v_edit_subcatchment.hydrology_id
	WHERE cat_hydrology.infiltration='MODIFIED_HORTON' 
	OR cat_hydrology.infiltration ='HORTON';



CREATE VIEW "v_inp_subcatch" AS 
SELECT 
subc_id, 
CASE WHEN parent_id IS NULL THEN node_id ELSE parent_id END AS node_id,
rg_id, 
area, 
imperv, 
width, 
slope, 
clength, 
snow_id, 
nimp, 
nperv, 
simp, 
sperv, 
zero, 
routeto, 
rted
FROM v_edit_subcatchment;



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
FROM v_edit_subcatchment
	JOIN inp_lidusage_subc_x_lidco ON inp_lidusage_subc_x_lidco.subc_id=v_edit_subcatchment.subc_id;




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
'LATERAL' || ' ' || (inp_groundwater.fl_eq_lat) AS fl_eq_lat, 
'DEEP' || ' ' || (inp_groundwater.fl_eq_lat) AS fl_eq_deep
FROM v_edit_subcatchment
	JOIN inp_groundwater ON inp_groundwater.subc_id=v_edit_subcatchment.subc_id;

	


CREATE VIEW "v_inp_coverages" AS 
SELECT 
v_edit_subcatchment.subc_id, 
inp_coverage_land_x_subc.landus_id, 
inp_coverage_land_x_subc.percent
FROM inp_coverage_land_x_subc 
	JOIN v_edit_subcatchment ON inp_coverage_land_x_subc.subc_id = v_edit_subcatchment.subc_id;


	

CREATE VIEW "v_inp_loadings" AS 
SELECT 
inp_loadings_pol_x_subc.poll_id, 
inp_loadings_pol_x_subc.subc_id, 
inp_loadings_pol_x_subc.ibuildup
FROM v_edit_subcatchment 
	JOIN inp_loadings_pol_x_subc ON inp_loadings_pol_x_subc.subc_id=v_edit_subcatchment.subc_id;



CREATE OR REPLACE VIEW v_inp_subcatch2node AS 
SELECT s1.subc_id,
        CASE
            WHEN s1.parent_id IS NULL THEN st_makeline(st_centroid(s1.the_geom), v_node.the_geom)
            ELSE st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))
        END AS the_geom
   FROM v_edit_subcatchment s1
     LEFT JOIN v_edit_subcatchment s2 ON s2.subc_id::text = s1.parent_id::text
     JOIN v_node ON v_node.node_id::text = s1.node_id::text;


   
CREATE OR REPLACE VIEW v_inp_subcatchcentroid AS 
SELECT 
subcatchment.subc_id,
st_centroid(subcatchment.the_geom) AS the_geom
FROM v_edit_subcatchment subcatchment;


DROP VIEW IF EXISTS "v_inp_options" ;
CREATE VIEW "v_inp_options" AS 
SELECT 
inp_options.flow_units,
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
FROM inp_options, inp_selector_hydrology
   JOIN cat_hydrology ON inp_selector_hydrology.hydrology_id = cat_hydrology.hydrology_id
   WHERE cat_hydrology.hydrology_id = inp_selector_hydrology.hydrology_id AND inp_selector_hydrology.cur_user = "current_user"()::text;
   
-- 2019/03/20
DROP VIEW IF EXISTS v_ui_element_x_gully;
CREATE OR REPLACE VIEW v_ui_element_x_gully AS
SELECT element_x_gully.id,
    element_x_gully.gully_id,
    element_x_gully.element_id,
    element.elementcat_id,
    cat_element.descript,
    element.num_elements,
    value_state.name AS state,
    value_state_type.name AS state_type,
    element.observ,
    element.comment,
    element.location_type,
    element.builtdate,
    element.enddate
   FROM element_x_gully
JOIN element ON element.element_id = element_x_gully.element_id
JOIN value_state ON element.state = value_state.id
LEFT JOIN value_state_type ON element.state_type = value_state_type.id
LEFT JOIN man_type_location ON man_type_location.location_type = element.location_type AND man_type_location.feature_type='ELEMENT'
LEFT JOIN cat_element ON cat_element.id=element.elementcat_id
WHERE element.state = 1;


