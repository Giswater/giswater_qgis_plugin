/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;
	
	
	
	DROP TABLE IF EXISTS anl_mincut_analytics;
    CREATE TABLE anl_mincut_analytics(
	id serial PRIMARY KEY,
    arc_id varchar(16),
	arc_id_aux varchar(16),
    network_length numeric (12,3),
    num_connec integer,
    num_hydro integer,
    sector_id integer,
    the_geom geometry (linestring, 25831),
    the_geom_p geometry (point, 25831),
    tstamp timestamp default now());

	
    DROP TABLE IF EXISTS temp_anl_mincut_analytics;
    CREATE TABLE temp_anl_mincut_analytics(
    id serial PRIMARY KEY,
    arc_id varchar(16),
	arc_id_aux varchar(16),
    network_length numeric (12,3),
    num_connec integer,
    num_hydro integer,
    sector_id integer,
    the_geom geometry (linestring, 25831),
    the_geom_p geometry (point, 25831));