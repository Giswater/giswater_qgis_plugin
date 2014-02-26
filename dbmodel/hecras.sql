/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 10 (class 2615 OID 151924)
-- Name: SCHEMA_NAME; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "SCHEMA_NAME";


SET search_path = "SCHEMA_NAME", pg_catalog;

--
-- TOC entry 2000 (class 1247 OID 151926)
-- Name: linetype_enum; Type: TYPE; Schema: SCHEMA_NAME; Owner: -
--

CREATE TYPE "linetype_enum" AS ENUM (
    'left',
    'channel',
    'right'
);


--
-- TOC entry 1494 (class 1255 OID 151933)
-- Name: _gr_landuse_manning(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "_gr_landuse_manning"() RETURNS SETOF character
    LANGUAGE "sql"
    AS 'SELECT river.rivercode FROM SCHEMA_NAME.river';


--
-- TOC entry 1495 (class 1255 OID 151934)
-- Name: gr_clear(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_clear"() RETURNS "text"
    LANGUAGE "sql"
    AS 'SELECT SCHEMA_NAME.gr_clear_shapes();
SELECT SCHEMA_NAME.gr_clear_tables();
SELECT SCHEMA_NAME.gr_clear_dtm();
SELECT SCHEMA_NAME.gr_clear_log();
SELECT SCHEMA_NAME.gr_clear_error();
INSERT INTO SCHEMA_NAME.log VALUES (''gr_init()'',''SCHEMA_NAME empty schema'',CURRENT_TIMESTAMP);
SELECT ''SCHEMA_NAME schema init finished''::text;';


--
-- TOC entry 1496 (class 1255 OID 151935)
-- Name: gr_clear_dtm(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_clear_dtm"() RETURNS SETOF integer
    LANGUAGE "sql"
    AS 'DELETE FROM SCHEMA_NAME.mdt;
--DELETE FROM SCHEMA_NAME.mdt_qgis;
--SELECT setval(''SCHEMA_NAME.mdt_rid_seq'', 1, false); 
SELECT rid FROM SCHEMA_NAME.mdt;
';


--
-- TOC entry 1497 (class 1255 OID 151936)
-- Name: gr_clear_error(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_clear_error"() RETURNS character varying
    LANGUAGE "sql"
    AS 'DELETE FROM SCHEMA_NAME.error;
SELECT ''Error registry clear''::text;';


--
-- TOC entry 1498 (class 1255 OID 151937)
-- Name: gr_clear_log(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_clear_log"() RETURNS "text"
    LANGUAGE "sql"
    AS 'DELETE FROM SCHEMA_NAME.log;
SELECT ''Log registry clear''::text;';


--
-- TOC entry 1499 (class 1255 OID 151938)
-- Name: gr_clear_shapes(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_clear_shapes"() RETURNS SETOF "text"
    LANGUAGE "sql"
    AS 'DELETE FROM SCHEMA_NAME.banks;
DELETE FROM SCHEMA_NAME.flowpaths;
DELETE FROM SCHEMA_NAME.river;
DELETE FROM SCHEMA_NAME.river3d;
DELETE FROM SCHEMA_NAME.xscutlines;
DELETE FROM SCHEMA_NAME.xscutlines3d;
DELETE FROM SCHEMA_NAME."LandUse";
DELETE FROM SCHEMA_NAME."IneffAreas";
DELETE FROM SCHEMA_NAME."NodesTable";

--SELECT setval(''SCHEMA_NAME.banks_gid_seq'', 1, false);    
--SELECT setval(''SCHEMA_NAME.flowpaths_gid_seq'', 1, false);    
--SELECT setval(''SCHEMA_NAME.river_gid_seq'', 1, false);    
--SELECT setval(''SCHEMA_NAME.river3d_gid_seq'', 1, false);    
--SELECT setval(''SCHEMA_NAME.xscutlines_gid_seq'', 1, false);    
--SELECT setval(''SCHEMA_NAME.xscutlines3d_gid_seq'', 1, false);    
--SELECT setval(''SCHEMA_NAME.IneffAreas_gid_seq'', 1, false);
--SELECT setval(''SCHEMA_NAME.LandUse_gid_seq'', 1, false);
--SELECT setval(''SCHEMA_NAME.nodestable_objectid_seq'', 1, false);
SELECT ''Shape tables empty''::text;';


--
-- TOC entry 1500 (class 1255 OID 151939)
-- Name: gr_clear_tables(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_clear_tables"() RETURNS "text"
    LANGUAGE "sql"
    AS '
--Delete table rows
DELETE FROM SCHEMA_NAME."Manning";
DELETE FROM SCHEMA_NAME."LUManning";
DELETE FROM SCHEMA_NAME."IneffectivePositions";
DELETE FROM SCHEMA_NAME."outfile";

SELECT ''Tables empty''::text;
  ';


--
-- TOC entry 1501 (class 1255 OID 151940)
-- Name: gr_delete_case("text"); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_delete_case"("schema" "text") RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE

BEGIN

--	Check schema
	IF (SELECT 1 FROM pg_namespace WHERE nspname = schema) THEN
		EXECUTE(FORMAT($q$DROP SCHEMA IF EXISTS %s CASCADE$q$,quote_ident(schema)));
	ELSE
		INSERT INTO SCHEMA_NAME.error VALUES (''gr_delete_case('' || schema || '')'', ''Case '' || schema || '' does not exist.'',CURRENT_TIMESTAMP);
	END IF;


--	Log
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_delete_case('' || schema || '')'', ''Case '' || schema || '' deleted.'',CURRENT_TIMESTAMP);	
	RETURN ''SCHEMA_NAME case '' || schema || '' deleted''::text;



END';


--
-- TOC entry 1502 (class 1255 OID 151941)
-- Name: gr_downstream_distance(smallint, "text", numeric); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_downstream_distance"("fromnode" smallint, "rivercode" "text", "total_length" numeric) RETURNS numeric
    LANGUAGE "plpgsql"
    AS 'DECLARE

	querystring Varchar; 
	riverRecord Record;
	length_aux numeric;

BEGIN

	querystring := ''SELECT river.gid AS gid, river.arclength AS length, river.tonode AS endnode FROM SCHEMA_NAME.river river WHERE river.rivercode = '' || quote_literal(rivercode) || '' AND river.fromnode = '' || fromnode;

	EXECUTE querystring INTO riverRecord;

	IF (riverRecord.gid IS NULL) THEN
		RETURN total_length;
	ELSE
		total_length := total_length + riverRecord.length;
		length_aux := SCHEMA_NAME.gr_downstream_distance(riverRecord.endnode,rivercode,total_length);
		RETURN length_aux;
	END IF; 

END';


--
-- TOC entry 1503 (class 1255 OID 151942)
-- Name: gr_dump_river_to_sdf(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_dump_river_to_sdf"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	river_line geometry;
	line3d	geometry;
	row_id integer;
	row_id2 integer;
	point_aux geometry;
	point_aux_old geometry;
	index_point integer;
	

--	All fields to be copied from river
	shape_leng numeric;
	hydroid integer;
	rivercode character varying(16);
	reachcode character varying(16);
	fromnode smallint;
	tonode smallint;
	arclength double precision;
	fromsta double precision;
	tosta double precision;

--	All fields to be copied from NodesTable
	Coord_X double precision;
	Coord_Y double precision;
	Coord_Z double precision;
	Node_ID integer;


BEGIN



--	Write sdf XS header
	INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
	INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''BEGIN STREAM NETWORK:'');

--	End point nodes
	FOR row_id2 IN SELECT "OBJECTID" FROM SCHEMA_NAME."NodesTable"
	LOOP
		SELECT INTO Coord_X "X" FROM SCHEMA_NAME."NodesTable" WHERE "OBJECTID" = row_id2;
		SELECT INTO Coord_Y "Y" FROM SCHEMA_NAME."NodesTable" WHERE "OBJECTID" = row_id2;
		SELECT INTO Coord_Z "Z" FROM SCHEMA_NAME."NodesTable" WHERE "OBJECTID" = row_id2;
		SELECT INTO Node_ID "NodeID" FROM SCHEMA_NAME."NodesTable" WHERE "OBJECTID" = row_id2;

		INSERT INTO SCHEMA_NAME.outfile VALUES (''ENDPOINT: ''  || Coord_X || '', '' || Coord_Y || '', '' || Coord_Z || '', '' || Node_ID);
	END LOOP;

	
--	For each line in river
	FOR row_id IN SELECT gid FROM SCHEMA_NAME.river
	LOOP

--		Get the geom and remain fields
		SELECT INTO river_line geom FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO shape_leng river.shape_leng FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO hydroid river.hydroid FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO rivercode river.rivercode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO reachcode river.reachcode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO fromnode river.fromnode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO tonode river.tonode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO arclength river.arclength FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO fromsta river.fromsta FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO tosta river.tosta FROM SCHEMA_NAME.river WHERE gid = row_id;

--		Write particular River header
		INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''REACH:'');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''STREAM ID: '' || rivercode);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''REACH ID: '' || reachcode);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''FROM POINT: '' || fromnode);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''TO POINT: '' || tonode);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''CENTERLINE:'');

--		Loop for river 2d nodes
		index_point := 1;
		FOR point_aux IN SELECT (ST_dumppoints(river_line)).geom
		LOOP

--			Insert result into outfile table
			IF index_point > 1 THEN
				shape_leng := shape_leng - ST_distance(point_aux,point_aux_old);
				INSERT INTO SCHEMA_NAME.outfile VALUES (''        '' || ST_X(point_aux) || '', '' || ST_Y(point_aux) || '', 0.0, '' || shape_leng);
			ELSE
				INSERT INTO SCHEMA_NAME.outfile VALUES (''        '' || ST_X(point_aux) || '', '' || ST_Y(point_aux) || '', 0.0, '' || shape_leng);
			END IF;

			index_point := index_point + 1;
			point_aux_old := point_aux;
		END LOOP;

--		Close particular xs 
		INSERT INTO SCHEMA_NAME.outfile VALUES (''END:'');


	END LOOP;

--	Close XS section
	INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''END STREAM NETWORK:'');


	INSERT INTO SCHEMA_NAME.log VALUES (''gr_dump_river_to_sdf()'',''River dump outfile finished.'',CURRENT_TIMESTAMP);
	RETURN ''2d river dumping finished''::text;

END
';


--
-- TOC entry 1504 (class 1255 OID 151943)
-- Name: gr_dump_sdf(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_dump_sdf"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE

	return_text text;
	querystring Varchar;

BEGIN

--	Clear outfile table
	DELETE FROM SCHEMA_NAME.outfile;

--	Add header to outfile
	return_text := SCHEMA_NAME.gr_dump_sdf_header();

--	Add River to outfile
	return_text := SCHEMA_NAME.gr_dump_river_to_sdf();

--	Add XS to outfile table
	return_text := SCHEMA_NAME.gr_dump_xs_to_sdf();

--	Create outputfile path
	SELECT INTO return_text setting FROM pg_settings WHERE name = ''data_directory'';

--	Export outfile table to sdf
	querystring := ''COPY (SELECT "Text" FROM SCHEMA_NAME.outfile ORDER BY index) TO '' || quote_literal(return_text || ''/SCHEMA_NAME_postgis.sdf'');
	EXECUTE querystring;

--	Log
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_dump_sdf()'',''SDF table exported.'',CURRENT_TIMESTAMP);


	RETURN ''SDF table exported.''::text;
END
';


--
-- TOC entry 1505 (class 1255 OID 151944)
-- Name: gr_dump_sdf(character varying); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_dump_sdf"("filename" character varying) RETURNS "text"
    LANGUAGE "plpgsql"
    AS '

DECLARE
	return_text text;
	querystring varchar;
	file varchar;

BEGIN

--	Clear outfile table
	DELETE FROM SCHEMA_NAME.outfile;

--	Add header to outfile
	return_text := SCHEMA_NAME.gr_dump_sdf_header();

--	Add River to outfile
	return_text := SCHEMA_NAME.gr_dump_river_to_sdf();

--	Add XS to outfile table
	return_text := SCHEMA_NAME.gr_dump_xs_to_sdf();

--	Create outputfile path
	SELECT INTO return_text setting FROM pg_settings WHERE name = ''data_directory'';

--	Export outfile table to sdf
	file:= quote_literal(return_text || ''/'' || filename);
	querystring := ''COPY (SELECT "Text" FROM SCHEMA_NAME.outfile ORDER BY index) TO '' || file;
	EXECUTE querystring;

--	Log
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_dump_sdf()'', ''SDF table exported: '' || querystring, CURRENT_TIMESTAMP);
	RETURN ''SDF table exported.''::text;

END

';


--
-- TOC entry 1506 (class 1255 OID 151945)
-- Name: gr_dump_sdf_header(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_dump_sdf_header"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE

	return_text text;

BEGIN

--	Write sdf XS header
	INSERT INTO SCHEMA_NAME.outfile VALUES (''#File generated by SCHEMA_NAME (GITS-UPC) for postGIS'');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''BEGIN HEADER:'');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''DTM TYPE: RASTER'');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''DTM:  '');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''STREAM LAYER:  '');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''NUMBER OF REACHES: '' || (SELECT COUNT(*) FROM SCHEMA_NAME.river));
	INSERT INTO SCHEMA_NAME.outfile VALUES (''CROSS-SECTION LAYER:  '');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''NUMBER OF CROSS-SECTIONS: '' || (SELECT COUNT(*) FROM SCHEMA_NAME.xscutlines));
	INSERT INTO SCHEMA_NAME.outfile VALUES (''MAP PROJECTION:  '');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''PROJECTION ZONE:  '');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''DATUM:  '');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''VERTICAL DATUM:  '');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''BEGIN SPATIAL EXTENT:'');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''XMIN: '' || (SELECT min(ST_xmin(ST_Envelope(geom))) FROM SCHEMA_NAME.xscutlines));
	INSERT INTO SCHEMA_NAME.outfile VALUES (''YMIN: '' || (SELECT min(ST_ymin(ST_Envelope(geom))) FROM SCHEMA_NAME.xscutlines));
	INSERT INTO SCHEMA_NAME.outfile VALUES (''XMAX: '' || (SELECT max(ST_xmax(ST_Envelope(geom))) FROM SCHEMA_NAME.xscutlines));
	INSERT INTO SCHEMA_NAME.outfile VALUES (''YMAX: '' || (SELECT max(ST_ymax(ST_Envelope(geom))) FROM SCHEMA_NAME.xscutlines));
	INSERT INTO SCHEMA_NAME.outfile VALUES (''END SPATIAL EXTENT:'');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''UNITS: METERS'');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''END HEADER:'');



--	Log
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_dump_sdf_header()'',''SDF header dumped.'',CURRENT_TIMESTAMP);


	RETURN ''SDF header exported.''::text;
END
';


--
-- TOC entry 1507 (class 1255 OID 151946)
-- Name: gr_dump_xs_to_sdf(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_dump_xs_to_sdf"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	xscutlines_line geometry;
	line3d	geometry;
	row_id integer;
	point_aux geometry;

--	All fields to be copied
	shape_leng numeric;
	hydroid integer;
	profilem double precision;
	rivercode character varying(16);
	reachcode character varying(16);
	leftbank double precision;
	rightbank double precision;
	llength double precision;
	chlength double precision;
	rlength double precision;
	nodename character varying(32);


BEGIN



--	Write sdf XS header
	INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
	INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''BEGIN CROSS-SECTIONS:'');


--	For each line in xscutlines
	FOR row_id IN SELECT gid FROM SCHEMA_NAME.xscutlines
	LOOP

--		Get the geom and remain fields
		SELECT INTO xscutlines_line geom FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO shape_leng xscutlines.shape_leng FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO hydroid xscutlines.hydroid FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO profilem xscutlines.profilem FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO rivercode xscutlines.rivercode FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO reachcode xscutlines.reachcode FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO leftbank xscutlines.leftbank FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO rightbank xscutlines.rightbank FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO llength xscutlines.llength FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO chlength xscutlines.chlength FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO rlength xscutlines.rlength FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO nodename xscutlines.nodename FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;

--		Write particular XS header
		INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''CROSS-SECTION:'');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''STREAM ID: '' || rivercode);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''REACH ID: '' || reachcode);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''STATION: '' || profilem);

		IF nodename IS NULL THEN
			INSERT INTO SCHEMA_NAME.outfile VALUES (''NODE NAME: '');
		ELSE
			INSERT INTO SCHEMA_NAME.outfile VALUES (''NODE NAME: '' || nodename);
		END IF;

		INSERT INTO SCHEMA_NAME.outfile VALUES (''BANK POSITIONS: '' || leftbank || '', '' || rightbank);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''REACH LENGTHS: '' || llength || '', '' || chlength || '', '' || rlength);
		INSERT INTO SCHEMA_NAME.outfile VALUES (''NVALUES:'');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''LEVEE POSITIONS:'');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''INEFFECTIVE POSITIONS:'');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''BLOCKED POSITIONS:'');
		INSERT INTO SCHEMA_NAME.outfile VALUES (''CUT LINE:'');

--		Loop for xs 2d nodes
		FOR point_aux IN SELECT (ST_dumppoints(xscutlines_line)).geom
		LOOP

			INSERT INTO SCHEMA_NAME.outfile VALUES (''        '' || ST_X(point_aux) || '', '' || ST_Y(point_aux));

		END LOOP;
	
		INSERT INTO SCHEMA_NAME.outfile VALUES (''SURFACE LINE:'');

--		Compute 3d crossection
		WITH intersectLines AS
			(SELECT ST_intersection(xscutlines_line,B.rast) AS geomval FROM SCHEMA_NAME.mdt as B WHERE ST_intersects(xscutlines_line, B.rast)),
--		Compute midpoint for every intersection line
		     intersectMidpoints AS
			(SELECT ST_line_interpolate_point((geomval).geom,0.5) AS geom, (geomval).val AS val, ST_distance(ST_startpoint(ST_LineMerge(xscutlines_line)), ST_line_interpolate_point((geomval).geom,0.5)) AS distance FROM intersectLines WHERE ST_geometrytype((geomval).geom) = ''ST_LineString''),
--		Compute ordered midpoint using distance
		     intersectMidpointsSort AS
			(SELECT geom AS geom, val AS val, distance AS distance FROM intersectMidpoints ORDER BY distance)
--		Insert result into outfile table
		INSERT INTO SCHEMA_NAME.outfile SELECT (''        '' || ST_X(intersectMidpointsSort.geom) || '', '' || ST_Y(intersectMidpointsSort.geom) || '', '' || intersectMidpointsSort.val) FROM intersectMidpointsSort;

--		Close particular xs 
		INSERT INTO SCHEMA_NAME.outfile VALUES (''END:'');


	END LOOP;

--	Close XS section
	INSERT INTO SCHEMA_NAME.outfile VALUES ('''');
	INSERT INTO SCHEMA_NAME.outfile VALUES (''END CROSS-SECTIONS:'');


	INSERT INTO SCHEMA_NAME.log VALUES (''gr_dump_xs_to_sdf()'',''Banks computation finished'',CURRENT_TIMESTAMP);
	RETURN ''3d XS dumping finished''::text;

END
';


--
-- TOC entry 1508 (class 1255 OID 151947)
-- Name: gr_export_geo(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_export_geo"() RETURNS "text"
    LANGUAGE "sql"
    AS '--Clear log
SELECT SCHEMA_NAME.gr_clear_log();

--Log
INSERT INTO SCHEMA_NAME.log VALUES (''gr_export_geo()'',''Empty log'',CURRENT_TIMESTAMP);

--Clear error
SELECT SCHEMA_NAME.gr_clear_error();

--Compute stream length
SELECT SCHEMA_NAME.gr_stream_length();

--XS station
SELECT SCHEMA_NAME.gr_xs_station();

--XS banks
SELECT SCHEMA_NAME.gr_xs_banks();

--XS flowpaths
SELECT SCHEMA_NAME.gr_xs_lengths();

--Dump river & XS data to outfile and export to sdf
SELECT SCHEMA_NAME.gr_dump_sdf();

--Update 3d layers
SELECT SCHEMA_NAME.gr_fill_3d_tables();

--Log
INSERT INTO SCHEMA_NAME.log VALUES (''gr_export_geo()'',''Sdf file finished.'',CURRENT_TIMESTAMP);

--Return
SELECT ''SCHEMA_NAME geometry export finished''::text;';


--
-- TOC entry 1509 (class 1255 OID 151948)
-- Name: gr_export_geo(character varying); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_export_geo"("filename" character varying) RETURNS "text"
    LANGUAGE "sql"
    AS '

SELECT SCHEMA_NAME.gr_clear_log();

--Log
INSERT INTO SCHEMA_NAME.log VALUES (''gr_export_geo()'', ''Empty log'', CURRENT_TIMESTAMP);

--Clear error
SELECT SCHEMA_NAME.gr_clear_error();

--Compute stream length
SELECT SCHEMA_NAME.gr_stream_length();

--XS station
SELECT SCHEMA_NAME.gr_xs_station();

--XS banks
SELECT SCHEMA_NAME.gr_xs_banks();

--XS flowpaths
SELECT SCHEMA_NAME.gr_xs_lengths();

--Dump river & XS data to outfile and export to sdf
SELECT SCHEMA_NAME.gr_dump_sdf(filename);

--Update 3d layers
SELECT SCHEMA_NAME.gr_fill_3d_tables();

--Log
INSERT INTO SCHEMA_NAME.log VALUES (''gr_export_geo()'', ''Sdf file finished'', CURRENT_TIMESTAMP);

--Return
SELECT ''SCHEMA_NAME geometry export finished''::text;
';


--
-- TOC entry 1510 (class 1255 OID 151949)
-- Name: gr_fill_3d_tables(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_fill_3d_tables"() RETURNS "text"
    LANGUAGE "sql"
    AS '--Insert XS in xscutlines3d
SELECT SCHEMA_NAME.gr_xs_2dto3d();

--Insert River in river3d 
SELECT SCHEMA_NAME.gr_river_2dto3d();

--Log
INSERT INTO SCHEMA_NAME.log VALUES (''gr_fill_3d_tables()'',''3d Tables filled.'',CURRENT_TIMESTAMP);

--Return
SELECT ''3d tables filled''::text;';


--
-- TOC entry 1511 (class 1255 OID 151950)
-- Name: gr_open_case("text"); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_open_case"("schema" "text") RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	t_ex integer := 0;
	trg_table character varying;
	src_table character varying;
	src_table_aux character varying;

BEGIN

--	Check schema
	IF (SELECT 1 FROM pg_namespace WHERE nspname = schema) THEN

--		Copy tables
		FOR src_table IN EXECUTE(FORMAT($q$SELECT table_name FROM information_schema.TABLES WHERE table_schema = %s  AND table_type = ''BASE TABLE''$q$,quote_literal(schema)))
		LOOP

--			Table name
			trg_table := ''SCHEMA_NAME.'' || quote_ident(src_table);


--			Check the table name for raster table
			IF (src_table = ''mdt'') THEN
				src_table_aux := quote_ident(schema) || ''.mdt'';
				
--				Delete old mdt table
				DROP TABLE IF EXISTS SCHEMA_NAME.mdt;
				EXECUTE(FORMAT($q$CREATE TABLE %s (LIKE %s)$q$,trg_table,src_table_aux));
				EXECUTE ''INSERT INTO '' || trg_table || ''(SELECT * FROM '' || src_table_aux || '')'';

			ELSE

				EXECUTE ''DELETE FROM '' || trg_table;
				EXECUTE ''INSERT INTO '' || trg_table || ''(SELECT * FROM '' || quote_ident(schema) || ''.'' || quote_ident(src_table) || '')'';

			END IF;

		END LOOP;


	ELSE
		INSERT INTO SCHEMA_NAME.error VALUES (''gr_open_case('' || schema || '')'', ''Case '' || schema || '' does not exist.'',CURRENT_TIMESTAMP);
	END IF;


--	Log
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_open_case('' || schema || '')'', ''Case '' || schema || '' loaded'',CURRENT_TIMESTAMP);	
	RETURN ''SCHEMA_NAME case '' || schema || '' load finished''::text;

END;';


--
-- TOC entry 1513 (class 1255 OID 151951)
-- Name: gr_river_2dto3d(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_river_2dto3d"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	river_line geometry;
	line3d	geometry;
	row_id integer;

--	All fields to be copied
	shape_leng numeric;
	hydroid integer;
	rivercode character varying(16);
	reachcode character varying(16);
	fromnode smallint;
	tonode smallint;
	arclength double precision;
	fromsta double precision;
	tosta double precision;


BEGIN

--	Delete 3d tables
	DELETE FROM SCHEMA_NAME.river3d;


--	For each line in xscutlines
	FOR row_id IN SELECT gid FROM SCHEMA_NAME.river
	LOOP

--		Get the geom and remain fields
		SELECT INTO river_line geom FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO shape_leng river.shape_leng FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO hydroid river.hydroid FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO rivercode river.rivercode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO reachcode river.reachcode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO fromnode river.fromnode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO tonode river.tonode FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO arclength river.arclength FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO fromsta river.fromsta FROM SCHEMA_NAME.river WHERE gid = row_id;
		SELECT INTO tosta river.tosta FROM SCHEMA_NAME.river WHERE gid = row_id;


--		Compute 3d crossection
		WITH intersectLines AS
			(SELECT ST_intersection(river_line,B.rast) AS geomval FROM SCHEMA_NAME.mdt as B WHERE ST_intersects(river_line, B.rast)),
--		Compute midpoint for every intersection line
		     intersectMidpoints AS
			(SELECT ST_line_interpolate_point((geomval).geom,0.5) AS geom, (geomval).val AS val, ST_distance(ST_startpoint(ST_LineMerge(river_line)), ST_line_interpolate_point((geomval).geom,0.5)) AS distance FROM intersectLines WHERE ST_geometrytype((geomval).geom) = ''ST_LineString''),
--		Compute ordered midpoint using distance
		     intersectMidpointsSort AS
			(SELECT geom AS geom, val AS val, distance AS distance FROM intersectMidpoints ORDER BY distance),
--		Compute 3d line
		     line3d_CTE AS
			(SELECT ST_makeline(ST_MakePoint(ST_X(geom), ST_Y(geom), val)) AS st_makeline FROM intersectMidpointsSort)
--		Store the resulting 3d line
		SELECT INTO line3d ST_multi(st_makeline) FROM line3d_CTE;

--		Insert 3d line in xscutlines3d
		INSERT INTO SCHEMA_NAME.river3d (shape_leng, riv2did, hydroid, rivercode, reachcode, fromnode, tonode, arclength, fromsta, tosta, geom) VALUES (shape_leng, hydroid, row_id, rivercode, reachcode, fromnode, tonode, arclength, fromsta, tosta,line3d);
		
--		Insert result into outfile table
--		INSERT INTO SCHEMA_NAME.outfile SELECT (''pp1 '' || ST_X(intersectMidpoints.geom) || ST_X(intersectMidpoints.geom) || intersectMidpoints.val || ''pp2'' || ''pp3'') FROM intersectMidpoints;



	END LOOP;

	INSERT INTO SCHEMA_NAME.log VALUES (''gr_river_2dto3d()'',''River profiles computation finished'',CURRENT_TIMESTAMP);
	RETURN ''3d river computation finished''::text;

END
';


--
-- TOC entry 1514 (class 1255 OID 151952)
-- Name: gr_save_case_as("text"); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_save_case_as"("schema" "text") RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	t_ex integer := 0;
	trg_table character varying;
	src_table character varying;
BEGIN

--	Check schema
	IF (SELECT 1 FROM pg_namespace WHERE nspname = schema) THEN
		INSERT INTO SCHEMA_NAME.log VALUES (''gr_save_case_as('' || schema || '')'', ''Case '' || schema || '' overwritten'',CURRENT_TIMESTAMP);
		PERFORM SCHEMA_NAME.gr_delete_case(schema);
	END IF;

	EXECUTE(FORMAT($q$CREATE SCHEMA %s AUTHORIZATION postgres$q$,quote_ident(schema)));

--	Create tables
	FOR src_table IN SELECT table_name FROM information_schema.TABLES WHERE table_schema = ''SCHEMA_NAME'' AND table_type = ''BASE TABLE''
	LOOP
--		Check the table name
		IF (src_table <> ''error'' AND src_table <> ''log'' AND src_table <> ''logfile'') THEN
			trg_table := quote_ident(schema) || ''.'' || quote_ident(src_table);
			EXECUTE(FORMAT($q$CREATE TABLE %s (LIKE SCHEMA_NAME.%I)$q$,trg_table,src_table));
			EXECUTE ''INSERT INTO '' || trg_table || ''(SELECT * FROM SCHEMA_NAME.'' || quote_ident(src_table) || '')'';
		END IF;
	END LOOP;

--	Log
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_save_case_as('' || schema || '')'', ''Case '' || schema || ''saved'',CURRENT_TIMESTAMP);	
	RETURN ''SCHEMA_NAME schema save as finished''::text;


END;
';


--
-- TOC entry 1515 (class 1255 OID 151953)
-- Name: gr_stream_length(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_stream_length"() RETURNS SETOF numeric
    LANGUAGE "sql"
    AS 'UPDATE SCHEMA_NAME.river SET shape_leng=ST_Length(geom),
                         arclength=ST_Length(geom),
                         fromsta=SCHEMA_NAME.gr_downstream_distance(tonode, rivercode, 0.0),
                         tosta=SCHEMA_NAME.gr_downstream_distance(tonode, rivercode, 0.0)+ST_Length(geom);
INSERT INTO SCHEMA_NAME.log VALUES (''gr_stream_length()'',''Stream length computation finished'',CURRENT_TIMESTAMP);
SELECT shape_leng FROM SCHEMA_NAME.river;
';


--
-- TOC entry 1516 (class 1255 OID 151954)
-- Name: gr_topology_check_node("public"."geometry"); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_topology_check_node"("punto" "public"."geometry", OUT "nodegid" integer, OUT "nodegeom" "public"."geometry") RETURNS "record"
    LANGUAGE "plpgsql" STRICT
    AS ' 
DECLARE 
	querystring Varchar; 
	nodeRecord Record; 
BEGIN 
	querystring := ''SELECT nodes.'' || quote_ident(''OBJECTID'') || '' AS nodegid, nodes.geom as nodegeom FROM SCHEMA_NAME.''
		|| quote_ident(''NodesTable'') || '' nodes WHERE nodes.geom && ST_EXPAND ($1, 1.0)''; 
	EXECUTE querystring INTO nodeRecord USING punto; 

	IF (nodeRecord.nodegid IS NULL) THEN 
		EXECUTE ''INSERT INTO SCHEMA_NAME.'' || quote_ident(''NodesTable'') || '' (numarcs, geom) VALUES (1,$1)'' USING punto; 
		EXECUTE ''SELECT currval ('' || quote_literal(''SCHEMA_NAME.nodestable_objectid_seq'') || '')'' INTO nodeRecord.nodegid; 
		nodeRecord.nodegeom:= punto; 
	ELSE 
		EXECUTE ''UPDATE SCHEMA_NAME.'' || quote_ident(''NodesTable'') || '' SET numarcs = numarcs + 1 WHERE '' || quote_ident(''OBJECTID'') || '' = '' || nodeRecord.nodegid; 
	END IF;
 
	nodegid:= nodeRecord.nodegid; 
	nodegeom:= nodeRecord.nodegeom; 

	RETURN; 
END; 
';


--
-- TOC entry 1517 (class 1255 OID 151955)
-- Name: gr_topology_cross("public"."geometry", "public"."geometry"); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_topology_cross"("geoml" "public"."geometry", "geom2" "public"."geometry") RETURNS boolean
    LANGUAGE "plpgsql" IMMUTABLE STRICT
    AS ' 
DECLARE 
geom_boundary Geometry; 
BEGIN 
	IF (ST_IsClosed(geoml) OR ST_IsClosed(geom2)) THEN 
		Return false; 
	END IF;
	 
	geom_boundary := ST_Boundary (geoml); 

	IF (ST_Distance(geom_boundary, ST_startpoint(geom2)) < 1.0) THEN 
		RETURN true; 
	ELSIF (ST_Distance(geom_boundary, ST_endpoint(geom2)) < 1.0) THEN 
		RETURN true; 
	ELSE 
		RETURN false; 
	END IF; 
END; 
';


--
-- TOC entry 1518 (class 1255 OID 151956)
-- Name: gr_topology_delete_river(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_topology_delete_river"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS '
--Function created modifying "tgg_functionborralinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 
 
DECLARE 
	querystring Varchar; 
	nodosrec Record; 
	nodosactualizados Integer; 

BEGIN 
	nodosactualizados := 0; 
 
	querystring := ''SELECT nodos.'' || quote_ident (''OBJECTID'') || '' AS '' || quote_ident (''OBJECTID'') || '', nodos.numarcs AS numarcs FROM SCHEMA_NAME.''
			|| quote_ident (''NodesTable'') || '' nodos WHERE nodos.'' || quote_ident(''OBJECTID'') || '' = '' 
			|| OLD.fromnode || '' OR nodos.'' || quote_ident(''OBJECTID'') || '' = '' || OLD.tonode; 

INSERT INTO SCHEMA_NAME.log VALUES (''gr_test()'',querystring,CURRENT_TIMESTAMP);
			

	FOR nodosrec IN EXECUTE querystring
	LOOP
		nodosactualizados := nodosactualizados + 1; 

		IF (nodosrec.numarcs <= 1) THEN 
			EXECUTE ''DELETE FROM SCHEMA_NAME.''|| quote_ident (''NodesTable'') || '' WHERE '' || quote_ident(''OBJECTID'') || '' = '' || nodosrec."OBJECTID"; 
		ELSE 
			EXECUTE ''UPDATE SCHEMA_NAME.'' || quote_ident(''NodesTable'') || '' SET numarcs = numarcs - 1 WHERE '' || quote_ident(''OBJECTID'') || '' = '' || nodosrec."OBJECTID"; 
		END IF; 

	END LOOP; 

	RETURN OLD; 
END; 
';


--
-- TOC entry 1519 (class 1255 OID 151957)
-- Name: gr_topology_insert_river(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_topology_insert_river"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS ' 

--Function created modifying "tgg_functioninsertlinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 

DECLARE 

	loopquery Varchar; 
	nodeRecord1 Record; 
	nodeRecord2 Record; 
	geomlin Geometry; 
	simplefeature Record; 
	geomfrag Geometry; 
	elemfeature Record; 
	elemgeom1 Geometry; 
	querystringUPDATE Varchar; 
	querystringUPDATEREACH Varchar;
	querystring Varchar; 
	querystringinicial Varchar; 
	ngeoms Integer; 
	unionall Geometry; 
	array_len Integer; 
	gids Integer[];
	combinedName Varchar;
	combinedNames Varchar[];
 
BEGIN 

/* 
Esta funcion varia su comportamiento en funcion desde don de ha sido llamada. Para ello analiza el valor de New.fromnode. 
Si fromnode es NULL, entonces se acepta que fue llamada por un comando SQL Insert ejecutado por el usuario. 
Si fromnode es -1, entonces fue llamada por el comando SQL Insert ejecutado dentro de 1a funcion gr_update_river(), 
que a su vez fue llamada tras la ejecucion de un comando SQL Update dentro de la funcion gr_insert_river(). 

Si fromnode es -3, entonces fue llamada por el 
comando SQL Insert ejecutado dentro de la funcion gr_update_river, que a su vez fue llamada tras la ejecucion de un comando SQL Update 
par el usuario. 

Si fromnode es -2, entonces gr_insert_river fue llamada por el 
comando SQL Insert ejecutado dentro de la funcion gr_insert_river(). 
*/

	IF (NEW.fromnode is NULL OR NEW.fromnode = -1 OR NEW.fromnode = -3) THEN 
		querystring:= ''INSERT INTO SCHEMA_NAME.river VALUES ($1.*)''; 
		querystringUPDATE:= ''UPDATE SCHEMA_NAME.river SET fromnode = -1 WHERE gid = $1''; 
		querystringUPDATEREACH:= ''UPDATE SCHEMA_NAME.river SET reachcode = concat(reachcode , $2) WHERE gid = $1''; 
		querystringinicial:= ''SELECT * FROM SCHEMA_NAME.river t1 WHERE ST_EXPAND ($1,1.0
					) && t1.geom AND t1.gid <> $2 AND (NOT SCHEMA_NAME.gr_topology_cross(t1.geom, $1)) AND ST_DISTANCE(t1.geom, $1) <= 1.0''; 

		ngeoms:= 0; 
		unionall:= ST_startpoint(ST_LineMerge(NEW.geom)); 

		FOR elemfeature in EXECUTE querystringinicial USING ST_LineMerge(NEW.geom), NEW.gid LOOP 
			ngeoms:= ngeoms + 1; 
			unionall:= ST_Union (unionall, elemfeature.geom); 
			gids:= array_append (gids, elemfeature.gid); 

			combinedName = elemfeature.reachcode;
			combinedNames:= array_append (combinedNames, combinedName); 
			
		END LOOP; 

--		ngeoms sera mayor de cero si la geometria insertada interseca 
--		con alguna otra geometria. 
 
		IF (ngeoms > 0) THEN 
--			mediante e1 comando ST_Snap (a partir de PostGIS 2.0) se evitan 
--			errores tipo TopologyException de PostGIS (desde GEOS). 
			NEW.geom:= ST_multi(ST_Snap(ST_LineMerge(NEW.geom), unionall, 1.0)); 
			geomfrag:= ST_Difference(ST_LineMerge(NEW.geom), unionall); 

			IF (geomfrag IS NOT NULL) THEN 
				ngeoms:= 0; 
				FOR elemgeom1 IN SELECT (st_dump(geomfrag)).geom
				LOOP 
					ngeoms:= ngeoms + 1;
					
					simplefeature      := NEW; 
					simplefeature.geom := ST_multi(elemgeom1); 
					simplefeature.gid  := nextval(''SCHEMA_NAME.river_gid_seq''); 

--					marca e1 nodo inicia1 a -2 
					simplefeature.fromnode:= -2; 

--					Esta funcion lanzara de nuevo el disparador INSERT saltando 
--					de forma recursiva a tggFunction_insertlinea 
					EXECUTE querystring using simplefeature; 
					EXECUTE querystringUPDATEREACH using simplefeature.gid, combinedNames[ngeoms];


				END LOOP; 
			END IF;
 
--			Si este disparador ha sido invocado desde 
			IF (NEW.fromnode IS NULL OR NEW.fromnode = -3) THEN 
				array_len:= array_upper(gids, 1); 

				FOR i IN 1 .. array_len LOOP 
--					Esta funcion lanzara el disparador UPDATE pero con la marca -2 
--					para que el disparador UPDATE sepa que viene de aqui 
					EXECUTE querystringUPDATE using gids[i]; 
				END LOOP; 
			END IF; 

--			Anula la inserccion 
			RETURN NULL; 
		END IF; 
	END IF; 

--	Control de lineas de longitud 0
	IF ST_distance(ST_startpoint(ST_LineMerge(NEW.geom)),ST_endpoint(ST_LineMerge(NEW.geom))) > 0.5 THEN

--		Solo cuando New.nodoinicial es -2, 0 en el caso en e1 que la geometria 
--		insertada no interseque con ninguna geometria en 1a tabla (ngeoms = 0) 
		nodeRecord1  := SCHEMA_NAME.gr_topology_check_node (ST_startpoint(ST_LineMerge(NEW.geom))); 
		NEW.fromnode := nodeRecord1.nodegid; 
		nodeRecord2  := SCHEMA_NAME.gr_topology_check_node (ST_endpoint(ST_LineMerge(NEW.geom))); 
		NEW.tonode   := nodeRecord2.nodegid; 

--		modifica los puntos inicial y final de la linea para que coincida con los 
--		nodos (debido a la tolerancia) 
		NEW.geom := ST_multi(ST_SetPoint(ST_SetPoint(ST_LineMerge(NEW.geom), 0, nodeRecord1.nodegeom), ST_NPoints(ST_LineMerge(NEW.geom)) - 1, nodeRecord2.nodegeom)); 

		RETURN NEW; 
	ELSE
		RETURN NULL;
	END IF;

END; 
';


--
-- TOC entry 1520 (class 1255 OID 151959)
-- Name: gr_topology_update_river(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_topology_update_river"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS '--Function created modifying "tgg_functionactualizalinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 

DECLARE 
	querystringdelete Varchar; 
	querystringINSERT Varchar; 
	marca Integer; 

BEGIN 
	querystringdelete:= ''DELETE FROM SCHEMA_NAME.river WHERE gid = $1''; 
	querystringINSERT:= ''INSERT INTO SCHEMA_NAME.river VALUES ($1.*)'';

	marca:= 0; 

	IF (NEW.fromnode = -1) THEN 
		marca:= -1; 
	ELSIF (ST_ASEWKB(OLD.geom) <> ST_ASEWKB(NEW.geom)) THEN 
		marca:= -3; 
	END IF; 

	IF ( marca <> 0 ) THEN 
		EXECUTE querystringdelete USING OLD.gid; 

--		New.nodoinicial valdra -1, marcando si esta funcion ha sido a su 
--		vez invocada previamente tras la ejecuci6n del coman do SQL Update dentro 
--		de la funcion gr_insert_river 

--		New.nodoinicial va1dra -3, marcando si esta funcion ha side invocada 
--		por un comando SQL Update introducido por el usuario. 

		NEW.fromnode:= marca; 
		EXECUTE querystringINSERT using NEW; 

--		Anula la actualizaci6n 
		RETURN NULL; 
	END IF; 

--	El ''usuario no puede cambiar el valor de los nodos de forma manual 
	NEW.fromnode:= OLD.fromnode; 
	NEW.tonode:= OLD.tonode; 

RETURN NEW; 

END; 
';


--
-- TOC entry 1512 (class 1255 OID 151960)
-- Name: gr_update_banks_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_update_banks_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS '
   BEGIN
      IF TG_OP = ''INSERT'' THEN
        INSERT INTO  SCHEMA_NAME.banks VALUES(DEFAULT,DEFAULT,DEFAULT,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = ''UPDATE'' THEN
       UPDATE SCHEMA_NAME.banks SET geom=NEW.geom WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = ''DELETE'' THEN
       DELETE FROM SCHEMA_NAME.banks WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
';


--
-- TOC entry 1521 (class 1255 OID 151961)
-- Name: gr_update_flowpaths_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_update_flowpaths_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS 'BEGIN
      IF TG_OP = ''INSERT'' THEN
        INSERT INTO  SCHEMA_NAME.flowpaths VALUES(DEFAULT,DEFAULT,NEW.linetype,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = ''UPDATE'' THEN
       UPDATE SCHEMA_NAME.flowpaths SET geom=NEW.geom, linetype=NEW.linetype WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = ''DELETE'' THEN
       DELETE FROM SCHEMA_NAME.flowpaths WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
';


--
-- TOC entry 1522 (class 1255 OID 151962)
-- Name: gr_update_nodestable(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_update_nodestable"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS 'BEGIN

	NEW."X"=ST_X(NEW.geom);
	NEW."Y"=ST_Y(NEW.geom);
	NEW."Z"=0.0;
	NEW."NodeID" = NEW."OBJECTID";
	RETURN NEW;

END;';


--
-- TOC entry 1523 (class 1255 OID 151963)
-- Name: gr_update_river_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_update_river_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS 'BEGIN
      IF TG_OP = ''INSERT'' THEN
        INSERT INTO  SCHEMA_NAME.river VALUES(DEFAULT,DEFAULT,DEFAULT,NEW.rivercode,NEW.reachcode,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = ''UPDATE'' THEN
       UPDATE SCHEMA_NAME.river SET geom=NEW.geom,rivercode=NEW.rivercode,reachcode=NEW.reachcode WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = ''DELETE'' THEN
       DELETE FROM SCHEMA_NAME.river WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
';


--
-- TOC entry 1524 (class 1255 OID 151964)
-- Name: gr_update_xscutlines_view(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_update_xscutlines_view"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS 'BEGIN
      IF TG_OP = ''INSERT'' THEN
        INSERT INTO  SCHEMA_NAME.xscutlines VALUES(DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,NEW.nodename,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = ''UPDATE'' THEN
       UPDATE SCHEMA_NAME.xscutlines SET geom=NEW.geom,nodename=NEW.nodename WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = ''DELETE'' THEN
       DELETE FROM SCHEMA_NAME.xscutlines WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;';


--
-- TOC entry 1525 (class 1255 OID 151965)
-- Name: gr_xs_2dto3d(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_xs_2dto3d"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	xscutlines_line geometry;
	line3d	geometry;
	row_id integer;

--	All fields to be copied
	shape_leng numeric;
	hydroid integer;
	profilem double precision;
	rivercode character varying(16);
	reachcode character varying(16);
	leftbank double precision;
	rightbank double precision;
	llength double precision;
	chlength double precision;
	rlength double precision;
	nodename character varying(32);


BEGIN

--	Delete 3d tables
	DELETE FROM SCHEMA_NAME.xscutlines3d;


--	For each line in xscutlines
	FOR row_id IN SELECT gid FROM SCHEMA_NAME.xscutlines
	LOOP

--		Get the geom and remain fields
		SELECT INTO xscutlines_line geom FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO shape_leng xscutlines.shape_leng FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO hydroid xscutlines.hydroid FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO profilem xscutlines.profilem FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO rivercode xscutlines.rivercode FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO reachcode xscutlines.reachcode FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO leftbank xscutlines.leftbank FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO rightbank xscutlines.rightbank FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO llength xscutlines.llength FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO chlength xscutlines.chlength FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO rlength xscutlines.rlength FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;
		SELECT INTO nodename xscutlines.nodename FROM SCHEMA_NAME.xscutlines WHERE gid = row_id;


--		Compute 3d crossection
		WITH intersectLines AS
			(SELECT ST_intersection(xscutlines_line,B.rast) AS geomval FROM SCHEMA_NAME.mdt as B WHERE ST_intersects(xscutlines_line, B.rast)),
--		Compute midpoint for every intersection line
		     intersectMidpoints AS
			(SELECT ST_line_interpolate_point((geomval).geom,0.5) AS geom, (geomval).val AS val, ST_distance(ST_startpoint(ST_LineMerge(xscutlines_line)), ST_line_interpolate_point((geomval).geom,0.5)) AS distance FROM intersectLines WHERE ST_geometrytype((geomval).geom) = ''ST_LineString''),
--		Compute ordered midpoint using distance
		     intersectMidpointsSort AS
			(SELECT geom AS geom, val AS val, distance AS distance FROM intersectMidpoints ORDER BY distance),
--		Compute 3d line
		     line3d_CTE AS
			(SELECT ST_makeline(ST_MakePoint(ST_X(geom), ST_Y(geom), val)) AS st_makeline FROM intersectMidpointsSort)
--		Store the resulting 3d line
		SELECT INTO line3d ST_multi(st_makeline) FROM line3d_CTE;

--		Insert 3d line in xscutlines3d
		INSERT INTO SCHEMA_NAME.xscutlines3d (shape_leng, xs2did, hydroid, profilem, rivercode, reachcode, leftbank, rightbank, llength, chlength, rlength, nodename, geom) VALUES (shape_leng, hydroid, row_id, profilem, rivercode, reachcode, leftbank, rightbank, llength, chlength, rlength, nodename,line3d);
		

	END LOOP;

	INSERT INTO SCHEMA_NAME.log VALUES (''gr_xs_2dto3d()'',''Crossections profiles computation finished'',CURRENT_TIMESTAMP);
	RETURN ''3d crossections computation finished''::text;

END
';


--
-- TOC entry 1526 (class 1255 OID 151966)
-- Name: gr_xs_banks(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_xs_banks"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	bank_point geometry[2];
	bank_point_dist1 double precision;
	bank_point_dist2 double precision;
	number_of_bank_lines integer;
	xscutlines_line geometry;
	xscutlines_gid integer;
BEGIN

--	Compute banks lengths
	UPDATE SCHEMA_NAME.banks SET shape_leng = ST_length(ST_LineMerge(SCHEMA_NAME.banks.geom));

--	Empty banks values
	UPDATE SCHEMA_NAME.xscutlines SET leftbank = NULL, rightbank = NULL;

--	Log	
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_xs_banks()'',''Begining banks intersections search'',CURRENT_TIMESTAMP);


--	For each line in xscutlines
	FOR xscutlines_line, xscutlines_gid IN SELECT geom, gid FROM SCHEMA_NAME.xscutlines
	LOOP

--		Control of bank lines intersection number
		SELECT COUNT(ST_intersection(SCHEMA_NAME.banks.geom,xscutlines_line)) INTO number_of_bank_lines FROM SCHEMA_NAME.banks  WHERE ST_intersects(SCHEMA_NAME.banks.geom,xscutlines_line); 

		IF number_of_bank_lines <> 2 THEN
			INSERT INTO SCHEMA_NAME.error VALUES (''gr_xs_banks()'',format(''Error: not exactly 2 bank lines in XS=%s'',xscutlines_gid),CURRENT_TIMESTAMP);
		ELSE


--			Bank points
			bank_point := ARRAY(SELECT ST_intersection(SCHEMA_NAME.banks.geom,xscutlines_line) FROM SCHEMA_NAME.banks WHERE ST_intersects(SCHEMA_NAME.banks.geom,xscutlines_line));
		
--			Banks position
			SELECT INTO bank_point_dist1 ST_line_locate_point(ST_LineMerge(xscutlines_line), bank_point[1]);
			SELECT INTO bank_point_dist2 ST_line_locate_point(ST_LineMerge(xscutlines_line), bank_point[2]);

--			Set values
			if bank_point_dist2 > bank_point_dist1 THEN
				UPDATE SCHEMA_NAME.xscutlines SET leftbank= bank_point_dist1, rightbank=  bank_point_dist2 WHERE gid= xscutlines_gid;
			ELSE
				UPDATE SCHEMA_NAME.xscutlines SET leftbank= bank_point_dist2, rightbank=  bank_point_dist1 WHERE gid= xscutlines_gid;
			END IF;

		END IF;	

	END LOOP;

	INSERT INTO SCHEMA_NAME.log VALUES (''gr_xs_banks()'',''Banks computation finished'',CURRENT_TIMESTAMP);
	RETURN ''Banks computation finished''::text;

END';


--
-- TOC entry 1527 (class 1255 OID 151967)
-- Name: gr_xs_lengths(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_xs_lengths"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	flowpath_point_old geometry[3];
	flowpath_point_new geometry[3];
	flowpath_point_dist double precision[3];
	number_of_flowpath_lines integer;
	xscutlines_line geometry;
	xscutlines_gid integer;
	river_code character varying(16);
	index_row integer;
BEGIN

--	Compute flowpaths lengths
	UPDATE SCHEMA_NAME.flowpaths SET shape_leng = ST_length(ST_LineMerge(SCHEMA_NAME.flowpaths.geom));

--	Compute xscutlines length
	UPDATE SCHEMA_NAME.xscutlines SET shape_leng = ST_length(ST_LineMerge(SCHEMA_NAME.xscutlines.geom));

--	Empty flowpaths values
	UPDATE SCHEMA_NAME.xscutlines SET llength = NULL, chlength = NULL, rlength = NULL;

--	Log	
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_xs_length()'',''Begining flowpaths intersections search'',CURRENT_TIMESTAMP);


--	For each river in river layer
	FOR river_code IN SELECT rivercode FROM SCHEMA_NAME.river GROUP BY rivercode 
	LOOP

--		For each line in xscutlines
		index_row := 1;
		FOR xscutlines_line, xscutlines_gid IN SELECT xscutlines.geom, xscutlines.gid FROM SCHEMA_NAME.xscutlines WHERE SCHEMA_NAME.xscutlines.rivercode = river_code ORDER BY profilem
		LOOP

--			Control of flowpaths lines intersection number
			SELECT COUNT(ST_intersection(SCHEMA_NAME.flowpaths.geom,xscutlines_line)) INTO number_of_flowpath_lines FROM SCHEMA_NAME.flowpaths  WHERE ST_intersects(SCHEMA_NAME.flowpaths.geom,xscutlines_line); 

			IF number_of_flowpath_lines <> 3 THEN
				INSERT INTO SCHEMA_NAME.error VALUES (''gr_xs_length()'',format(''Error: not exactly 3 flowpath lines in XS=%s'',xscutlines_gid),CURRENT_TIMESTAMP);
			ELSE


--				Flowpath points
				flowpath_point_new := ARRAY(SELECT ST_intersection(SCHEMA_NAME.flowpaths.geom,xscutlines_line) FROM SCHEMA_NAME.flowpaths WHERE ST_intersects(SCHEMA_NAME.flowpaths.geom,xscutlines_line));
		
--				Banks position
				flowpath_point_dist := ARRAY(SELECT ST_line_locate_point(ST_LineMerge(xscutlines_line), x) FROM unnest(flowpath_point_new) x);

--				Sort points
				flowpath_point_new := ARRAY(SELECT unnest(flowpath_point_new) ORDER BY flowpath_point_dist);

--				Set values
				if index_row > 1 THEN
					UPDATE SCHEMA_NAME.xscutlines SET llength = ST_distance(flowpath_point_new[1],flowpath_point_old[1]), chlength = ST_distance(flowpath_point_new[2],flowpath_point_old[2]), rlength = ST_distance(flowpath_point_new[3],flowpath_point_old[3]) WHERE gid= xscutlines_gid;
				ELSE
					UPDATE SCHEMA_NAME.xscutlines SET llength = 0.0, chlength = 0.0, rlength = 0.0 WHERE gid= xscutlines_gid;
				END IF;

--				Update index and values
				index_row := index_row + 1;
				flowpath_point_old := flowpath_point_new;

			END IF;	

		END LOOP;

	END LOOP;

	INSERT INTO SCHEMA_NAME.log VALUES (''gr_xs_flowpaths()'',''Flowpaths computation finished'',CURRENT_TIMESTAMP);
	RETURN ''Flowpaths computation finished''::text;

END









';


--
-- TOC entry 1528 (class 1255 OID 151968)
-- Name: gr_xs_station(); Type: FUNCTION; Schema: SCHEMA_NAME; Owner: -
--

CREATE FUNCTION "gr_xs_station"() RETURNS "text"
    LANGUAGE "plpgsql"
    AS 'DECLARE
	stream_point geometry;
	stream_point_dist double precision;
	stream_length double precision;
	stream_downstream_length numeric;
	number_of_stream_lines integer;
	xscutlines_line geometry;
	stream_line geometry;
	xscutlines_gid integer;
BEGIN

--	Empty station values
	UPDATE SCHEMA_NAME.xscutlines SET profilem = NULL, rivercode = NULL, reachcode = NULL;

--	Log	
	INSERT INTO SCHEMA_NAME.log VALUES (''gr_xs_station()'',''Begining river intersections search'',CURRENT_TIMESTAMP);


--	For each line in xscutlines
	FOR xscutlines_line, xscutlines_gid IN SELECT geom, gid FROM SCHEMA_NAME.xscutlines
	LOOP

--		Control of stream lines intersection number
		SELECT COUNT(ST_intersection(SCHEMA_NAME.river.geom,xscutlines_line)) INTO number_of_stream_lines FROM SCHEMA_NAME.river WHERE ST_intersects(SCHEMA_NAME.river.geom,xscutlines_line); 

		IF number_of_stream_lines <> 1 THEN
			INSERT INTO SCHEMA_NAME.error VALUES (''gr_xs_station()'',format(''Error: not exactly 1 river lines in XS=%s'',xscutlines_gid),CURRENT_TIMESTAMP);
		ELSE

--			River and reach code
			UPDATE SCHEMA_NAME.xscutlines SET rivercode = SCHEMA_NAME.river.rivercode, reachcode = SCHEMA_NAME.river.reachcode FROM SCHEMA_NAME.river WHERE ST_intersects(SCHEMA_NAME.river.geom,xscutlines_line) AND SCHEMA_NAME.xscutlines.gid= xscutlines_gid;

--			Stream points
			SELECT INTO stream_point ST_intersection(SCHEMA_NAME.river.geom,xscutlines_line) FROM SCHEMA_NAME.river WHERE ST_intersects(SCHEMA_NAME.river.geom,xscutlines_line);
			SELECT INTO stream_length SCHEMA_NAME.river.shape_leng FROM SCHEMA_NAME.river WHERE ST_intersects(SCHEMA_NAME.river.geom,xscutlines_line);
			SELECT INTO stream_line SCHEMA_NAME.river.geom FROM SCHEMA_NAME.river WHERE ST_intersects(SCHEMA_NAME.river.geom,xscutlines_line);
			SELECT INTO stream_downstream_length SCHEMA_NAME.river.fromsta FROM SCHEMA_NAME.river WHERE ST_intersects(SCHEMA_NAME.river.geom,xscutlines_line);

--			Banks position
			SELECT INTO stream_point_dist (1.0 - ST_line_locate_point(ST_LineMerge(stream_line), stream_point)) * stream_length + stream_downstream_length;

--			Set values
			UPDATE SCHEMA_NAME.xscutlines SET profilem = stream_point_dist WHERE gid= xscutlines_gid;

		END IF;	

	END LOOP;

	INSERT INTO SCHEMA_NAME.log VALUES (''gr_xs_stream()'',''Station computation finished'',CURRENT_TIMESTAMP);
	RETURN ''Station computation finished''::text;

END';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 220 (class 1259 OID 151969)
-- Name: IneffAreas; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "IneffAreas" (
    "gid" integer NOT NULL,
    "Shape_Leng" double precision,
    "Shape_Area" double precision,
    "HydroID" integer,
    "geom" "public"."geometry"(Polygon, SRID_VALUE)
);


--
-- TOC entry 221 (class 1259 OID 151975)
-- Name: IneffAreas_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "IneffAreas_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 221
-- Name: IneffAreas_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "IneffAreas_gid_seq" OWNED BY "IneffAreas"."gid";


--
-- TOC entry 222 (class 1259 OID 151977)
-- Name: nodestable_objectid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "nodestable_objectid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 223 (class 1259 OID 151979)
-- Name: IneffectivePositions; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "IneffectivePositions" (
    "OBJECTID" integer DEFAULT "nextval"('"nodestable_objectid_seq"'::"regclass") NOT NULL,
    "XS2DID" integer,
    "IA2DID" integer,
    "BegFrac" double precision,
    "EndFrac" double precision,
    "BegElev" double precision,
    "EndElev" double precision,
    "UserElev" double precision
);


--
-- TOC entry 224 (class 1259 OID 151983)
-- Name: LUManning; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "LUManning" (
    "OBJECTID" integer DEFAULT "nextval"('"nodestable_objectid_seq"'::"regclass") NOT NULL,
    "LUCode" character varying(32),
    "N_Value" double precision
);


--
-- TOC entry 225 (class 1259 OID 151987)
-- Name: LandUse; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "LandUse" (
    "gid" integer NOT NULL,
    "Shape_Leng" double precision,
    "Shape_Area" double precision,
    "LUCode" character varying(32),
    "N_Value" double precision,
    "OBJECTID" integer,
    "LUCode_1" character varying(32),
    "N_Value_1" double precision,
    "geom" "public"."geometry"(Polygon, SRID_VALUE)
);


--
-- TOC entry 226 (class 1259 OID 151993)
-- Name: LandUse_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "LandUse_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 226
-- Name: LandUse_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "LandUse_gid_seq" OWNED BY "LandUse"."gid";


--
-- TOC entry 227 (class 1259 OID 151995)
-- Name: Manning; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "Manning" (
    "OBJECTID" integer DEFAULT "nextval"('"nodestable_objectid_seq"'::"regclass") NOT NULL,
    "XS2DID" integer,
    "Fraction" double precision,
    "N_Value" double precision
);


--
-- TOC entry 228 (class 1259 OID 151999)
-- Name: NodesTable; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "NodesTable" (
    "OBJECTID" integer DEFAULT "nextval"('"nodestable_objectid_seq"'::"regclass") NOT NULL,
    "NodeID" integer,
    "X" double precision,
    "Y" double precision,
    "Z" double precision,
    "geom" "public"."geometry"(Point, SRID_VALUE),
    "numarcs" integer
);


--
-- TOC entry 229 (class 1259 OID 152006)
-- Name: hydroid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "hydroid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 230 (class 1259 OID 152008)
-- Name: banks; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "banks" (
    "gid" integer NOT NULL,
    "shape_leng" numeric,
    "hydroid" integer DEFAULT "nextval"('"hydroid_seq"'::"regclass") NOT NULL,
    "geom" "public"."geometry"(MultiLineString, SRID_VALUE)
);


--
-- TOC entry 231 (class 1259 OID 152015)
-- Name: banks_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "banks_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 231
-- Name: banks_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "banks_gid_seq" OWNED BY "banks"."gid";


--
-- TOC entry 232 (class 1259 OID 152017)
-- Name: error; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "error" (
    "Process" character varying,
    "error" character varying,
    "time" timestamp with time zone
);


--
-- TOC entry 233 (class 1259 OID 152023)
-- Name: flowpaths; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "flowpaths" (
    "gid" integer NOT NULL,
    "shape_leng" numeric,
    "linetype" character varying(7),
    "geom" "public"."geometry"(MultiLineString, SRID_VALUE)
);


--
-- TOC entry 234 (class 1259 OID 152029)
-- Name: flowpaths_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "flowpaths_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 234
-- Name: flowpaths_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "flowpaths_gid_seq" OWNED BY "flowpaths"."gid";


--
-- TOC entry 235 (class 1259 OID 152031)
-- Name: linetype; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "linetype" (
    "name" character varying(7) NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 152034)
-- Name: log; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "log" (
    "Process" character varying,
    "message" character varying,
    "time" timestamp with time zone
);



--
-- TOC entry 239 (class 1259 OID 152058)
-- Name: outfile; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "outfile" (
    "Text" character varying,
    "index" integer NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 152064)
-- Name: outfile_index_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "outfile_index_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 240
-- Name: outfile_index_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "outfile_index_seq" OWNED BY "outfile"."index";


--
-- TOC entry 241 (class 1259 OID 152066)
-- Name: river; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "river" (
    "gid" integer NOT NULL,
    "shape_leng" numeric,
    "hydroid" integer DEFAULT "nextval"('"hydroid_seq"'::"regclass") NOT NULL,
    "rivercode" character varying(16),
    "reachcode" character varying(16),
    "fromnode" smallint,
    "tonode" smallint,
    "arclength" double precision,
    "fromsta" double precision,
    "tosta" double precision,
    "geom" "public"."geometry"(MultiLineString, SRID_VALUE)
);


--
-- TOC entry 242 (class 1259 OID 152073)
-- Name: river3d; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "river3d" (
    "gid" integer NOT NULL,
    "shape_leng" numeric,
    "riv2did" integer,
    "hydroid" integer DEFAULT "nextval"('"hydroid_seq"'::"regclass") NOT NULL,
    "rivercode" character varying(16),
    "reachcode" character varying(16),
    "fromnode" smallint,
    "tonode" smallint,
    "arclength" double precision,
    "fromsta" double precision,
    "tosta" double precision,
    "geom" "public"."geometry"(MultiLineStringZ, SRID_VALUE)
);


--
-- TOC entry 243 (class 1259 OID 152080)
-- Name: river3d_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "river3d_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 243
-- Name: river3d_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "river3d_gid_seq" OWNED BY "river3d"."gid";


--
-- TOC entry 244 (class 1259 OID 152082)
-- Name: river_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "river_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 244
-- Name: river_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "river_gid_seq" OWNED BY "river"."gid";


--
-- TOC entry 245 (class 1259 OID 152084)
-- Name: view_banks; Type: VIEW; Schema: SCHEMA_NAME; Owner: -
--

CREATE VIEW "view_banks" AS
    SELECT "banks"."gid", "banks"."geom" FROM "banks";


--
-- TOC entry 246 (class 1259 OID 152088)
-- Name: view_flowpaths; Type: VIEW; Schema: SCHEMA_NAME; Owner: -
--

CREATE VIEW "view_flowpaths" AS
    SELECT "flowpaths"."gid", "flowpaths"."linetype", "flowpaths"."geom" FROM "flowpaths";


--
-- TOC entry 247 (class 1259 OID 152092)
-- Name: view_river; Type: VIEW; Schema: SCHEMA_NAME; Owner: -
--

CREATE VIEW "view_river" AS
    SELECT "river"."gid", "river"."rivercode", "river"."reachcode", "river"."geom" FROM "river";


--
-- TOC entry 248 (class 1259 OID 152096)
-- Name: xscutlines; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "xscutlines" (
    "gid" integer NOT NULL,
    "shape_leng" numeric,
    "hydroid" integer DEFAULT "nextval"('"hydroid_seq"'::"regclass") NOT NULL,
    "profilem" double precision,
    "rivercode" character varying(16),
    "reachcode" character varying(16),
    "leftbank" double precision,
    "rightbank" double precision,
    "llength" double precision,
    "chlength" double precision,
    "rlength" double precision,
    "nodename" character varying(32),
    "geom" "public"."geometry"(MultiLineString, SRID_VALUE)
);


--
-- TOC entry 249 (class 1259 OID 152103)
-- Name: view_xscutlines; Type: VIEW; Schema: SCHEMA_NAME; Owner: -
--

CREATE VIEW "view_xscutlines" AS
    SELECT "xscutlines"."gid", "xscutlines"."nodename", "xscutlines"."geom" FROM "xscutlines";


--
-- TOC entry 250 (class 1259 OID 152107)
-- Name: xscutlines3d; Type: TABLE; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE TABLE "xscutlines3d" (
    "gid" integer NOT NULL,
    "shape_leng" numeric,
    "xs2did" integer,
    "hydroid" integer DEFAULT "nextval"('"hydroid_seq"'::"regclass") NOT NULL,
    "profilem" double precision,
    "rivercode" character varying(16),
    "reachcode" character varying(16),
    "leftbank" double precision,
    "rightbank" double precision,
    "llength" double precision,
    "chlength" double precision,
    "rlength" double precision,
    "nodename" character varying(32),
    "geom" "public"."geometry"(MultiLineStringZ, SRID_VALUE)
);


--
-- TOC entry 251 (class 1259 OID 152114)
-- Name: xscutlines3d_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "xscutlines3d_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 251
-- Name: xscutlines3d_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "xscutlines3d_gid_seq" OWNED BY "xscutlines3d"."gid";


--
-- TOC entry 252 (class 1259 OID 152116)
-- Name: xscutlines_gid_seq; Type: SEQUENCE; Schema: SCHEMA_NAME; Owner: -
--

CREATE SEQUENCE "xscutlines_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 252
-- Name: xscutlines_gid_seq; Type: SEQUENCE OWNED BY; Schema: SCHEMA_NAME; Owner: -
--

ALTER SEQUENCE "xscutlines_gid_seq" OWNED BY "xscutlines"."gid";


--
-- TOC entry 3598 (class 2604 OID 152118)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "IneffAreas" ALTER COLUMN "gid" SET DEFAULT "nextval"('"IneffAreas_gid_seq"'::"regclass");


--
-- TOC entry 3601 (class 2604 OID 152119)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "LandUse" ALTER COLUMN "gid" SET DEFAULT "nextval"('"LandUse_gid_seq"'::"regclass");


--
-- TOC entry 3605 (class 2604 OID 152120)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "banks" ALTER COLUMN "gid" SET DEFAULT "nextval"('"banks_gid_seq"'::"regclass");


--
-- TOC entry 3606 (class 2604 OID 152121)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "flowpaths" ALTER COLUMN "gid" SET DEFAULT "nextval"('"flowpaths_gid_seq"'::"regclass");


--
-- TOC entry 3618 (class 2604 OID 152123)
-- Name: index; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "outfile" ALTER COLUMN "index" SET DEFAULT "nextval"('"outfile_index_seq"'::"regclass");


--
-- TOC entry 3620 (class 2604 OID 152124)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "river" ALTER COLUMN "gid" SET DEFAULT "nextval"('"river_gid_seq"'::"regclass");


--
-- TOC entry 3622 (class 2604 OID 152125)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "river3d" ALTER COLUMN "gid" SET DEFAULT "nextval"('"river3d_gid_seq"'::"regclass");


--
-- TOC entry 3624 (class 2604 OID 152126)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "xscutlines" ALTER COLUMN "gid" SET DEFAULT "nextval"('"xscutlines_gid_seq"'::"regclass");


--
-- TOC entry 3626 (class 2604 OID 152127)
-- Name: gid; Type: DEFAULT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "xscutlines3d" ALTER COLUMN "gid" SET DEFAULT "nextval"('"xscutlines3d_gid_seq"'::"regclass");


--
-- TOC entry 3628 (class 2606 OID 152129)
-- Name: IneffAreas_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "IneffAreas"
    ADD CONSTRAINT "IneffAreas_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3630 (class 2606 OID 152131)
-- Name: IneffectivePositions_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "IneffectivePositions"
    ADD CONSTRAINT "IneffectivePositions_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3632 (class 2606 OID 152133)
-- Name: LUManning_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "LUManning"
    ADD CONSTRAINT "LUManning_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3634 (class 2606 OID 152135)
-- Name: LandUse_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "LandUse"
    ADD CONSTRAINT "LandUse_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3636 (class 2606 OID 152137)
-- Name: Manning_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "Manning"
    ADD CONSTRAINT "Manning_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3638 (class 2606 OID 152139)
-- Name: NodesTable_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "NodesTable"
    ADD CONSTRAINT "NodesTable_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3641 (class 2606 OID 152141)
-- Name: banks_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "banks"
    ADD CONSTRAINT "banks_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3644 (class 2606 OID 152143)
-- Name: flowpaths_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "flowpaths"
    ADD CONSTRAINT "flowpaths_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3646 (class 2606 OID 152145)
-- Name: linetype_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "linetype"
    ADD CONSTRAINT "linetype_pkey" PRIMARY KEY ("name");


--
-- TOC entry 3651 (class 2606 OID 152149)
-- Name: outfile_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "outfile"
    ADD CONSTRAINT "outfile_pkey" PRIMARY KEY ("index");


--
-- TOC entry 3657 (class 2606 OID 152151)
-- Name: river3d_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "river3d"
    ADD CONSTRAINT "river3d_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3654 (class 2606 OID 152153)
-- Name: river_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "river"
    ADD CONSTRAINT "river_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3663 (class 2606 OID 152155)
-- Name: xscutlines3d_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "xscutlines3d"
    ADD CONSTRAINT "xscutlines3d_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3660 (class 2606 OID 152157)
-- Name: xscutlines_pkey; Type: CONSTRAINT; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

ALTER TABLE ONLY "xscutlines"
    ADD CONSTRAINT "xscutlines_pkey" PRIMARY KEY ("gid");


--
-- TOC entry 3639 (class 1259 OID 152158)
-- Name: banks_geom_gist; Type: INDEX; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE INDEX "banks_geom_gist" ON "banks" USING "gist" ("geom");


--
-- TOC entry 3642 (class 1259 OID 152159)
-- Name: flowpaths_geom_gist; Type: INDEX; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE INDEX "flowpaths_geom_gist" ON "flowpaths" USING "gist" ("geom");



--
-- TOC entry 3655 (class 1259 OID 152161)
-- Name: river3d_geom_gist; Type: INDEX; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE INDEX "river3d_geom_gist" ON "river3d" USING "gist" ("geom");


--
-- TOC entry 3652 (class 1259 OID 152162)
-- Name: river_geom_gist; Type: INDEX; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE INDEX "river_geom_gist" ON "river" USING "gist" ("geom");


--
-- TOC entry 3661 (class 1259 OID 152163)
-- Name: xscutlines3d_geom_gist; Type: INDEX; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE INDEX "xscutlines3d_geom_gist" ON "xscutlines3d" USING "gist" ("geom");


--
-- TOC entry 3658 (class 1259 OID 152164)
-- Name: xscutlines_geom_gist; Type: INDEX; Schema: SCHEMA_NAME; Owner: -; Tablespace: 
--

CREATE INDEX "xscutlines_geom_gist" ON "xscutlines" USING "gist" ("geom");


--
-- TOC entry 3666 (class 2620 OID 152165)
-- Name: gr_delete_river_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_delete_river_trigger" BEFORE DELETE ON "river" FOR EACH ROW EXECUTE PROCEDURE "gr_topology_delete_river"();


--
-- TOC entry 3667 (class 2620 OID 152166)
-- Name: gr_insert_river_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_insert_river_trigger" BEFORE INSERT ON "river" FOR EACH ROW EXECUTE PROCEDURE "gr_topology_insert_river"();


--
-- TOC entry 3669 (class 2620 OID 152167)
-- Name: gr_update_banks_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_banks_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_banks" FOR EACH ROW EXECUTE PROCEDURE "gr_update_banks_view"();


--
-- TOC entry 3670 (class 2620 OID 152168)
-- Name: gr_update_flowpaths_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_flowpaths_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_flowpaths" FOR EACH ROW EXECUTE PROCEDURE "gr_update_flowpaths_view"();


--
-- TOC entry 3665 (class 2620 OID 152169)
-- Name: gr_update_nodestable_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_nodestable_trigger" BEFORE INSERT OR UPDATE ON "NodesTable" FOR EACH ROW EXECUTE PROCEDURE "gr_update_nodestable"();


--
-- TOC entry 3668 (class 2620 OID 152170)
-- Name: gr_update_river_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_river_trigger" BEFORE UPDATE ON "river" FOR EACH ROW EXECUTE PROCEDURE "gr_topology_update_river"();


--
-- TOC entry 3671 (class 2620 OID 152171)
-- Name: gr_update_river_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_river_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_river" FOR EACH ROW EXECUTE PROCEDURE "gr_update_river_view"();


--
-- TOC entry 3672 (class 2620 OID 152172)
-- Name: gr_update_xscutlines_view_trigger; Type: TRIGGER; Schema: SCHEMA_NAME; Owner: -
--

CREATE TRIGGER "gr_update_xscutlines_view_trigger" INSTEAD OF INSERT OR DELETE OR UPDATE ON "view_xscutlines" FOR EACH ROW EXECUTE PROCEDURE "gr_update_xscutlines_view"();


--
-- TOC entry 3664 (class 2606 OID 152173)
-- Name: linetype_constraint; Type: FK CONSTRAINT; Schema: SCHEMA_NAME; Owner: -
--

ALTER TABLE ONLY "flowpaths"
    ADD CONSTRAINT "linetype_constraint" FOREIGN KEY ("linetype") REFERENCES "linetype"("name");

	
SET search_path = public, pg_catalog;

-- Completed on 2013-12-17 23:15:03

--
-- PostgreSQL database dump complete
--

