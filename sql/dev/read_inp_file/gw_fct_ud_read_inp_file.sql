/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_ud_read_inp_file()
  RETURNS void AS
$BODY$
BEGIN

-- Search path
    SET search_path = "SCHEMA_NAME", public;

 
-- DROP TABLES
	DROP TABLE IF EXISTS temp_rinp_options CASCADE;
	DROP TABLE IF EXISTS temp_rinp_evaporation CASCADE;
	DROP TABLE IF EXISTS temp_rinp_raingages CASCADE;
	DROP TABLE IF EXISTS temp_rinp_subcatchments CASCADE;
	DROP TABLE IF EXISTS temp_rinp_subareas CASCADE;
   	DROP TABLE IF EXISTS temp_rinp_infiltration CASCADE;
	DROP TABLE IF EXISTS temp_rinp_lid_controls CASCADE;
	DROP TABLE IF EXISTS temp_rinp_lid_usage CASCADE;
	DROP TABLE IF EXISTS temp_rinp_snowpack CASCADE;
	DROP TABLE IF EXISTS temp_rinp_junctions CASCADE;
	DROP TABLE IF EXISTS temp_rinp_outfalls CASCADE;
	DROP TABLE IF EXISTS temp_rinp_conduits CASCADE;
	DROP TABLE IF EXISTS temp_rinp_xsections CASCADE;
   	DROP TABLE IF EXISTS temp_rinp_losses CASCADE;
	DROP TABLE IF EXISTS temp_rinp_controls CASCADE;
	DROP TABLE IF EXISTS temp_rinp_pollutants CASCADE;
	DROP TABLE IF EXISTS temp_rinp_landuses CASCADE;
	DROP TABLE IF EXISTS temp_rinp_coverages CASCADE;
	DROP TABLE IF EXISTS temp_rinp_loadings CASCADE;
    DROP TABLE IF EXISTS temp_rinp_buildup CASCADE;
	DROP TABLE IF EXISTS temp_rinp_washoff CASCADE;
	DROP TABLE IF EXISTS temp_rinp_treatment CASCADE;
	DROP TABLE IF EXISTS temp_rinp_dwf_flow CASCADE;
	DROP TABLE IF EXISTS temp_rinp_dwf_load CASCADE;
    DROP TABLE IF EXISTS temp_rinp_timeseries CASCADE;
	DROP TABLE IF EXISTS temp_rinp_patterns CASCADE;
	DROP TABLE IF EXISTS temp_rinp_report CASCADE;
	DROP TABLE IF EXISTS temp_rinp_mapdim CASCADE;
	DROP TABLE IF EXISTS temp_rinp_mapunits CASCADE;
	DROP TABLE IF EXISTS temp_rinp_coordinates CASCADE;
	DROP TABLE IF EXISTS temp_rinp_vertices CASCADE;
	DROP TABLE IF EXISTS temp_rinp_symbols CASCADE;
	DROP TABLE IF EXISTS temp_rinp_polygons CASCADE;
	
-- CREATE INP TABLES
	CREATE TABLE temp_rinp_options (
		nid serial PRIMARY KEY NOT NULL,
		flow_unit text,
		infiltration text,
		flow_routing text,
		start_date text,
		start_time text,
		report_start_date text,
		report_start_time text,
		end_date text,
		end_time text,
		sweep_start text,
		sweep_end text,
		dry_day int,
		report_step text,
		wet_step text,
		dry_step text,
		allow_ponding text,
		inertial_damping text,
		variable_step numeric (12,4),
		lengthening_step text,
		min_surfarea numeric (12,4),
		normal_flow_limited text,
		skip_steady_state text,
		force_main_equation text,
		link_offset text,
		min_slope numeric (12,4),
		ingore_rainfall text,
		ignore_snowmelt text,
		ignore_quality text,
		ignore_groundwater text,
		ignore_routing text,
		routing_step text,
		tempdir text);
	

	CREATE TABLE temp_rinp_evaporation (
		nid serial PRIMARY KEY NOT NULL,
		evaporation_type text,
		evapo_parameter text);
	
	CREATE TABLE temp_rinp_raingages (
		nid serial PRIMARY KEY NOT NULL,
		raingage_name int,
		rain_type text,
		time_intrvl text,
		snow_catch numeric (12,4),
		data_source text);

	CREATE TABLE temp_rinp_subcatchments (	
	nid serial PRIMARY KEY NOT NULL,
	subcatch_name int,
	raingage int,
	outlet int,
	total_area numeric (12,6),
	pcnt_imperv numeric (12,4),
	width numeric (12,4),
	pcnt_slope numeric (12,4),
	curb_length numeric (12,4),
	snow_pack text);
	
	CREATE TABLE temp_rinp_subareas (
	nid serial PRIMARY KEY NOT NULL,
	subcatchment int,
	n_imperv numeric (12,4),
	n_perv numeric (12,4),
	s_imperv numeric (12,4),
	s_perv numeric (12,4),
	pctzero numeric (12,4),
	routeto text,
	pctrouted numeric (12,4));

CREATE TABLE temp_rinp_infiltration (
	nid serial PRIMARY KEY NOT NULL,
	subcatchment int,
	curvenum numeric (12,4),
	hydcon numeric (12,4),
	drytime numeric (12,4));

CREATE TABLE temp_rinp_lid_controls (
	nid serial PRIMARY KEY NOT NULL,
	id_control text,
	type_layer text,
	value1 numeric (12,4),
	value2 numeric (12,4),
	value3 numeric (12,4),
	value4 numeric (12,4),
	value5 numeric (12,4),
	value6 numeric (12,4),
	value7 numeric (12,4));

CREATE TABLE temp_rinp_lid_usage (
	nid serial PRIMARY KEY NOT NULL,
	subcatchment int,
	lid_process text,
	lid_no int,
	area numeric (12,6),
	width numeric (12,4),
	initsatur numeric (12,4),
	fromimprv numeric (12,4),
	reportfile numeric (12,4));


CREATE TABLE temp_rinp_snowpack (
	nid serial PRIMARY KEY NOT NULL,
	spack text,
	spack_type text,
	value1 numeric (12,4),
	value2 numeric (12,4),
	value3 numeric (12,4),
	value4 numeric (12,4),
	value5 numeric (12,4),
	value6 numeric (12,4),
	value7 numeric (12,4));

CREATE TABLE temp_rinp_junctions (
	nid serial PRIMARY KEY NOT NULL,
	junction_name int,
	invertelev numeric (12,4),
	max_depth numeric (12,4),
	init_depth numeric (12,4),
	surcharge_depth numeric (12,4),
	ponded_area numeric (12,4));

CREATE TABLE temp_rinp_outfalls (
	nid serial PRIMARY KEY NOT NULL,
	outfall_name int,
	invert_elev numeric (12,4),
	outfall_type text,
	stage_timeseries text,
	tide_gate text);

CREATE TABLE temp_rinp_conduits (
	nid serial PRIMARY KEY NOT NULL,
	conduit_name int,
	inlet_node int,
	outlet_node int,
	conduit_length numeric (12,4),
	manning_n numeric (12,4),
	inlet_offset numeric (12,4),
	outlet_offset numeric (12,4),
	init_flow numeric (12,4),
	max_flow numeric (12,4));

CREATE TABLE temp_rinp_xsections (
	nid serial PRIMARY KEY NOT NULL,
	link int, 
	shape text,
	geom1 numeric (12,4),
	geom2 numeric (12,4),
	geom3 numeric (12,4),
	geom4 numeric (12,4),
	barrels int);

CREATE TABLE temp_rinp_losses (
	nid serial PRIMARY KEY NOT NULL,
	link int,
	inlet numeric(12,4),
	outlet numeric(12,4),
	avarge numeric (12,4),
	flap_gate text);

CREATE TABLE temp_rinp_controls (
	nid serial PRIMARY KEY NOT NULL,
	control_text text);

CREATE TABLE temp_rinp_pollutants(
	nid serial PRIMARY KEY NOT NULL,
	pollutant_name text,
	mass_units text,
	rain_concen numeric (12,4),
	gw_concen numeric (12,4),
	ii_concen numeric (12,4),
	decay_coeff numeric (12,4),
	snow_only text,
	co_pollut_name text,
	co_pollut_fraction numeric (12,4),
	dwf_concen numeric (12,4));


CREATE TABLE temp_rinp_landuses(
	nid serial PRIMARY KEY NOT NULL,
	landuse_name text,
	cleaning_interval numeric (12,4),
	fraction_available numeric (12,4),
	last_cleand numeric (12,4));

 CREATE TABLE temp_rinp_coverages (
	nid serial PRIMARY KEY NOT NULL,
	subcatchment int,
	land_use text,
	percent numeric (12,4));

CREATE TABLE temp_rinp_loadings (
	nid serial PRIMARY KEY NOT NULL,
	subcatchment varchar(16),
	pollutnat text,
	loading numeric(12,6));

CREATE TABLE temp_rinp_buildup (
	nid serial PRIMARY KEY NOT NULL,
	landuse text,
	pollutant text,
	buildup_function text,
	coeff1 numeric (12,4),
	coeff2 numeric (12,4),
	coeff3 numeric (12,4),
	normalizer text);

CREATE TABLE temp_rinp_washoff (
	nid serial PRIMARY KEY NOT NULL,
	landuse text,
	pollutant text,
	washoff_function text,
	coeff1 numeric (12,4),
	coeff2 numeric (12,4),
	cleaning_effic numeric (12,4),
	bmp_effic numeric (12,4));

CREATE TABLE temp_rinp_treatment (
	nid serial PRIMARY KEY NOT NULL,
	node int,
	pollutant text,
	treatment_function text);

CREATE TABLE temp_rinp_dwf_flow (
	nid serial PRIMARY KEY NOT NULL,
	node int,
	dwf_parameter text,
	avarage_value numeric (12,5),
	pat1 text,
	pat2 text,
	pat3 text,
	pat4 text);

CREATE TABLE temp_rinp_dwf_load (
	nid serial PRIMARY KEY NOT NULL,
	node int,
	avarage_value numeric (12,5),
	pat1 text,
	pat2 text,
	pat3 text,
	pat4 text);

CREATE TABLE temp_rinp_timeseries (
	nid serial PRIMARY KEY NOT NULL,
	name1 text,
	date1 text,
	time1 text,
	value1 numeric (12,4));

CREATE TABLE temp_rinp_patterns (
	nid serial PRIMARY KEY NOT NULL,
	pattern_name text,
	pattern_type text,
	value1 numeric (12,4),
	value2 numeric (12,4),
	value3 numeric (12,4),
	value4 numeric (12,4),
	value5 numeric (12,4),
	value6 numeric (12,4),
	value7 numeric (12,4),
	value8 numeric (12,4),
	value9 numeric (12,4),
	value10 numeric (12,4),
	value11 numeric (12,4),
	value12 numeric (12,4),
	value13 numeric (12,4),
	value14 numeric (12,4),
	value15 numeric (12,4),
	value16 numeric (12,4),
	value17 numeric (12,4),
	value18 numeric (12,4),
	value19 numeric (12,4),
	value20 numeric (12,4),
	value21 numeric (12,4),
	value22 numeric (12,4),
	value23 numeric (12,4),
	value24 numeric (12,4));

CREATE TABLE temp_rinp_report (
	nid serial PRIMARY KEY NOT NULL,
	rep_input text,
	continuity text,
	flowstats text,
	rep_control text,
	subcatchment text,
	node text,
	link text);


CREATE TABLE temp_rinp_mapdim (
	nid serial PRIMARY KEY NOT NULL,
	x1 numeric (12,4),
	y1 numeric (12,4),
	x2 numeric (12,4),
	y2 numeric (12,4));

CREATE TABLE temp_rinp_mapunits (
	nid serial PRIMARY KEY NOT NULL,
	type_units text);

CREATE TABLE temp_rinp_coordinates (
	nid serial PRIMARY KEY NOT NULL,
	node int,
	x_coord numeric (12,4),
	y_coord numeric (12,4));

CREATE TABLE temp_rinp_vertices (
	nid serial PRIMARY KEY NOT NULL,
	link int,
	x_coord serial8,
	y_coord serial8);

CREATE TABLE temp_rinp_symbols (
	nid serial PRIMARY KEY NOT NULL,
	gage int,
	x_coord numeric (12,4),
	y_coord numeric (12,4));

CREATE TABLE temp_rinp_polygons (
	nid serial PRIMARY KEY NOT NULL,
	subcatchment text,
	x_coord serial8,
	y_coord serial8);
	
	
RETURN;   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;