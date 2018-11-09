/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_ws_read_inp_file()
  RETURNS void AS
$BODY$
   BEGIN

-- Search path
    SET search_path = "SCHEMA_NAME", public;

 
-- DROP TABLES
	DROP TABLE IF EXISTS temp_rinp_junctions CASCADE;
	DROP TABLE IF EXISTS temp_rinp_reservoirs CASCADE;
	DROP TABLE IF EXISTS temp_rinp_tanks CASCADE;
	DROP TABLE IF EXISTS temp_rinp_pipes CASCADE;
	DROP TABLE IF EXISTS temp_rinp_pumps CASCADE;
   	DROP TABLE IF EXISTS temp_rinp_valves CASCADE;
	DROP TABLE IF EXISTS temp_rinp_tags CASCADE;
	DROP TABLE IF EXISTS temp_rinp_demands CASCADE;
	DROP TABLE IF EXISTS temp_rinp_status CASCADE;
	DROP TABLE IF EXISTS temp_rinp_patterns CASCADE;
	DROP TABLE IF EXISTS temp_rinp_curves CASCADE;
	DROP TABLE IF EXISTS temp_rinp_controls CASCADE;
	DROP TABLE IF EXISTS temp_rinp_rules CASCADE;
   	DROP TABLE IF EXISTS temp_rinp_energy CASCADE;
	DROP TABLE IF EXISTS temp_rinp_emitters CASCADE;
	DROP TABLE IF EXISTS temp_rinp_quality CASCADE;
	DROP TABLE IF EXISTS temp_rinp_sources CASCADE;
	DROP TABLE IF EXISTS temp_rinp_reactions CASCADE;
	DROP TABLE IF EXISTS temp_rinp_reactions1 CASCADE;
    DROP TABLE IF EXISTS temp_rinp_mixing CASCADE;
	DROP TABLE IF EXISTS temp_rinp_times CASCADE;
	DROP TABLE IF EXISTS temp_rinp_report CASCADE;
	DROP TABLE IF EXISTS temp_rinp_options CASCADE;
	DROP TABLE IF EXISTS temp_rinp_coordinates CASCADE;
    DROP TABLE IF EXISTS temp_rinp_vertices CASCADE;
	DROP TABLE IF EXISTS temp_rinp_labes CASCADE;
	
CREATE TABLE temp_rinp_junctions (
	nid serial PRIMARY KEY NOT NULL,
	id int4,
	elev numeric (12,4),
	demand numeric (12,4),
	pattern text);

CREATE TABLE temp_rinp_reservoirs (
	nid serial PRIMARY KEY NOT NULL,
	id int,
	head numeric (12,4),
	pattern text);

CREATE TABLE temp_rinp_tanks (
	nid serial PRIMARY KEY NOT NULL,
	id int,
	elevation numeric (12,4),
	initlevel int,
	minlevel int,
	maxlevel int,
	diameter int,
	minvol int,
	volcurve text);

CREATE TABLE temp_rinp_pipes (
	nid serial PRIMARY KEY NOT NULL,
	id int,
	node1 int,
	node2 int,
	pipe_length numeric (12,4),
	diameter numeric (12,4),
	roughness numeric (12,4),
	minorloss numeric (12,4),
	status text);

 CREATE TABLE temp_rinp_pumps (
	nid serial PRIMARY KEY NOT NULL,
	id int,
	node1 int,
	node2 int,
	parameters text);

 CREATE TABLE temp_rinp_valves (
	nid serial PRIMARY KEY NOT NULL,
	id int,
	node1 int,
	node2 int,
	diameter numeric (12,4),
	valve_type text,
	setting numeric (12,4),
	minorloss numeric (12,4),
	parameters text);

CREATE TABLE temp_rinp_tags (
	nid serial PRIMARY KEY NOT NULL,
	tag_object text,
	node int,
	tag text);

CREATE TABLE temp_rinp_demands (
	nid serial PRIMARY KEY NOT NULL,
	junction int,
	demand numeric (12,4),
	pattern text,
	category text);

CREATE TABLE temp_rinp_status (
	nid serial PRIMARY KEY NOT NULL,
	id int,
	status_setting text);
	
CREATE TABLE temp_rinp_patterns (
	nid serial PRIMARY KEY NOT NULL,
	id text,
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

CREATE TABLE temp_rinp_curves (
	nid serial PRIMARY KEY NOT NULL,
	id int,
	x_value numeric (12,4),
	y_value numeric (12,4));

CREATE TABLE temp_rinp_controls (
	nid serial PRIMARY KEY NOT NULL,
	control_text text);

CREATE TABLE temp_rinp_rules (
	nid serial PRIMARY KEY NOT NULL,
	rule_text text);

CREATE TABLE temp_rinp_energy (
	nid serial PRIMARY KEY NOT NULL,
	parameter text,
	value_energy text);

CREATE TABLE temp_rinp_emitters(
	nid serial PRIMARY KEY NOT NULL,
	junction int,
	coefficient numeric (12,4));

CREATE TABLE temp_rinp_quality (
	nid serial PRIMARY KEY NOT NULL,
	node int,
	initqual numeric (12,4));

CREATE TABLE temp_rinp_sources (
	nid serial PRIMARY KEY NOT NULL,
	node int,
	source_type text,
	quality numeric (12,4),
	pattern text);

CREATE TABLE temp_rinp_reactions (
	nid serial PRIMARY KEY NOT NULL,
	reaction_type text,
	pipe_tank int,
	coefficient numeric (12,4));

CREATE TABLE temp_rinp_reactions1 (
	nid serial PRIMARY KEY NOT NULL,
	reaction_parameter text,
	reaction_value int,
	coefficient numeric (12,4));
	
CREATE TABLE temp_rinp_mixing (
	nid serial PRIMARY KEY NOT NULL,
	tank int,
	model text,
	mixing_value numeric(12,4));

CREATE TABLE temp_rinp_times (
	nid serial PRIMARY KEY NOT NULL,
	time_parameter text,
	time_value text);

CREATE TABLE temp_rinp_report (
	nid serial PRIMARY KEY NOT NULL,
	report_parameter text,
	report_value text);

CREATE TABLE temp_rinp_options (
	nid serial PRIMARY KEY NOT NULL,
	option_parameter text,
	option_value text);

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

CREATE TABLE temp_rinp_labes (
	nid serial PRIMARY KEY NOT NULL,
	x_coord numeric (12,6),
	y_coord numeric (12,6),
	label text,
	anchor_node int);

RETURN;   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;







