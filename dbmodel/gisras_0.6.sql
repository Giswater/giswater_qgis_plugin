--
-- PostgreSQL database dump
--

-- Dumped from database version 9.2.4
-- Dumped by pg_dump version 9.2.4
-- Started on 2013-11-25 11:11:50

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 3630 (class 1262 OID 17654)
-- Name: gisras_ddb; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE gisras_ddb WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';


ALTER DATABASE gisras_ddb OWNER TO postgres;

\connect gisras_ddb

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 7 (class 2615 OID 83581)
-- Name: gisras; Type: SCHEMA; Schema: -; Owner: postgres
--

DROP SCHEMA IF EXISTS gisras CASCADE;
CREATE SCHEMA gisras;


ALTER SCHEMA gisras OWNER TO postgres;

--
-- TOC entry 6 (class 2615 OID 17509)
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- TOC entry 221 (class 3079 OID 11727)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 221
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 223 (class 3079 OID 16394)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 223
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 222 (class 3079 OID 17510)
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 222
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET search_path = gisras, pg_catalog;

--
-- TOC entry 1475 (class 1255 OID 83582)
-- Name: _gr_landuse_manning(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION _gr_landuse_manning() RETURNS SETOF character
    LANGUAGE sql
    AS $$SELECT river.rivercode FROM gisras.river$$;


ALTER FUNCTION gisras._gr_landuse_manning() OWNER TO postgres;

--
-- TOC entry 1458 (class 1255 OID 83594)
-- Name: gr_clear(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_clear() RETURNS text
    LANGUAGE sql
    AS $$SELECT gisras.gr_clear_shapes();
SELECT gisras.gr_clear_tables();
SELECT gisras.gr_clear_dtm();
SELECT gisras.gr_clear_log();
SELECT gisras.gr_clear_error();
INSERT INTO gisras.log VALUES ('gr_init()','Gisras empty schema',CURRENT_TIMESTAMP);
SELECT 'gisras schema init finished'::text;$$;


ALTER FUNCTION gisras.gr_clear() OWNER TO postgres;

--
-- TOC entry 1478 (class 1255 OID 83584)
-- Name: gr_clear_dtm(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_clear_dtm() RETURNS SETOF integer
    LANGUAGE sql
    AS $$DELETE FROM gisras.mdt;
--DELETE FROM gisras.mdt_qgis;
--SELECT setval('gisras.mdt_rid_seq', 1, false); 
SELECT rid FROM gisras.mdt;
$$;


ALTER FUNCTION gisras.gr_clear_dtm() OWNER TO postgres;

--
-- TOC entry 1476 (class 1255 OID 83585)
-- Name: gr_clear_error(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_clear_error() RETURNS character varying
    LANGUAGE sql
    AS $$DELETE FROM gisras.error;
SELECT 'Error registry clear'::text;$$;


ALTER FUNCTION gisras.gr_clear_error() OWNER TO postgres;

--
-- TOC entry 1477 (class 1255 OID 83586)
-- Name: gr_clear_log(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_clear_log() RETURNS text
    LANGUAGE sql
    AS $$DELETE FROM gisras.log;
SELECT 'Log registry clear'::text;$$;


ALTER FUNCTION gisras.gr_clear_log() OWNER TO postgres;

--
-- TOC entry 1480 (class 1255 OID 83587)
-- Name: gr_clear_shapes(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_clear_shapes() RETURNS SETOF text
    LANGUAGE sql
    AS $$DELETE FROM gisras.banks;
DELETE FROM gisras.flowpaths;
DELETE FROM gisras.river;
DELETE FROM gisras.river3d;
DELETE FROM gisras.xscutlines;
DELETE FROM gisras.xscutlines3d;
DELETE FROM gisras."LandUse";
DELETE FROM gisras."IneffAreas";
DELETE FROM gisras."NodesTable";

--SELECT setval('gisras.banks_gid_seq', 1, false);    
--SELECT setval('gisras.flowpaths_gid_seq', 1, false);    
--SELECT setval('gisras.river_gid_seq', 1, false);    
--SELECT setval('gisras.river3d_gid_seq', 1, false);    
--SELECT setval('gisras.xscutlines_gid_seq', 1, false);    
--SELECT setval('gisras.xscutlines3d_gid_seq', 1, false);    
--SELECT setval('gisras.IneffAreas_gid_seq', 1, false);
--SELECT setval('gisras.LandUse_gid_seq', 1, false);
--SELECT setval('gisras.nodestable_objectid_seq', 1, false);
SELECT 'Shape tables empty'::text;$$;


ALTER FUNCTION gisras.gr_clear_shapes() OWNER TO postgres;

--
-- TOC entry 1459 (class 1255 OID 83804)
-- Name: gr_clear_tables(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_clear_tables() RETURNS text
    LANGUAGE sql
    AS $$
--Delete table rows
DELETE FROM gisras."Manning";
DELETE FROM gisras."LUManning";
DELETE FROM gisras."IneffectivePositions";
DELETE FROM gisras."outfile";

SELECT 'Tables empty'::text;
  $$;


ALTER FUNCTION gisras.gr_clear_tables() OWNER TO postgres;

--
-- TOC entry 1471 (class 1255 OID 83809)
-- Name: gr_delete_case(text); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_delete_case(schema text) RETURNS text
    LANGUAGE plpgsql
    AS $_$DECLARE

BEGIN

--	Check schema
	IF (SELECT 1 FROM pg_namespace WHERE nspname = schema) THEN
		EXECUTE(FORMAT($q$DROP SCHEMA IF EXISTS %s CASCADE$q$,quote_ident(schema)));
	ELSE
		INSERT INTO gisras.error VALUES ('gr_delete_case(' || schema || ')', 'Case ' || schema || ' does not exist.',CURRENT_TIMESTAMP);
	END IF;


--	Log
	INSERT INTO gisras.log VALUES ('gr_delete_case(' || schema || ')', 'Case ' || schema || ' deleted.',CURRENT_TIMESTAMP);	
	RETURN 'gisras case ' || schema || ' deleted'::text;



END$_$;


ALTER FUNCTION gisras.gr_delete_case(schema text) OWNER TO postgres;

--
-- TOC entry 1492 (class 1255 OID 96497)
-- Name: gr_downstream_distance(smallint, text, numeric); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_downstream_distance(fromnode smallint, rivercode text, total_length numeric) RETURNS numeric
    LANGUAGE plpgsql
    AS $$DECLARE

	querystring Varchar; 
	riverRecord Record;
	length_aux numeric;

BEGIN

	querystring := 'SELECT river.gid AS gid, river.arclength AS length, river.tonode AS endnode FROM gisras.river river WHERE river.rivercode = ' || quote_literal(rivercode) || ' AND river.fromnode = ' || fromnode;

	EXECUTE querystring INTO riverRecord;

	IF (riverRecord.gid IS NULL) THEN
		RETURN total_length;
	ELSE
		total_length := total_length + riverRecord.length;
		length_aux := gisras.gr_downstream_distance(riverRecord.endnode,rivercode,total_length);
		RETURN length_aux;
	END IF; 

END$$;


ALTER FUNCTION gisras.gr_downstream_distance(fromnode smallint, rivercode text, total_length numeric) OWNER TO postgres;

--
-- TOC entry 1493 (class 1255 OID 83588)
-- Name: gr_dump_river_to_sdf(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_dump_river_to_sdf() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
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
	INSERT INTO gisras.outfile VALUES ('');
	INSERT INTO gisras.outfile VALUES ('');
	INSERT INTO gisras.outfile VALUES ('BEGIN STREAM NETWORK:');

--	End point nodes
	FOR row_id2 IN SELECT "OBJECTID" FROM gisras."NodesTable"
	LOOP
		SELECT INTO Coord_X "X" FROM gisras."NodesTable" WHERE "OBJECTID" = row_id2;
		SELECT INTO Coord_Y "Y" FROM gisras."NodesTable" WHERE "OBJECTID" = row_id2;
		SELECT INTO Coord_Z "Z" FROM gisras."NodesTable" WHERE "OBJECTID" = row_id2;
		SELECT INTO Node_ID "NodeID" FROM gisras."NodesTable" WHERE "OBJECTID" = row_id2;

		INSERT INTO gisras.outfile VALUES ('ENDPOINT: '  || Coord_X || ', ' || Coord_Y || ', ' || Coord_Z || ', ' || Node_ID);
	END LOOP;

	
--	For each line in river
	FOR row_id IN SELECT gid FROM gisras.river
	LOOP

--		Get the geom and remain fields
		SELECT INTO river_line geom FROM gisras.river WHERE gid = row_id;
		SELECT INTO shape_leng river.shape_leng FROM gisras.river WHERE gid = row_id;
		SELECT INTO hydroid river.hydroid FROM gisras.river WHERE gid = row_id;
		SELECT INTO rivercode river.rivercode FROM gisras.river WHERE gid = row_id;
		SELECT INTO reachcode river.reachcode FROM gisras.river WHERE gid = row_id;
		SELECT INTO fromnode river.fromnode FROM gisras.river WHERE gid = row_id;
		SELECT INTO tonode river.tonode FROM gisras.river WHERE gid = row_id;
		SELECT INTO arclength river.arclength FROM gisras.river WHERE gid = row_id;
		SELECT INTO fromsta river.fromsta FROM gisras.river WHERE gid = row_id;
		SELECT INTO tosta river.tosta FROM gisras.river WHERE gid = row_id;

--		Write particular River header
		INSERT INTO gisras.outfile VALUES ('');
		INSERT INTO gisras.outfile VALUES ('REACH:');
		INSERT INTO gisras.outfile VALUES ('STREAM ID: ' || rivercode);
		INSERT INTO gisras.outfile VALUES ('REACH ID: ' || reachcode);
		INSERT INTO gisras.outfile VALUES ('FROM POINT: ' || fromnode);
		INSERT INTO gisras.outfile VALUES ('TO POINT: ' || tonode);
		INSERT INTO gisras.outfile VALUES ('CENTERLINE:');

--		Loop for river 2d nodes
		index_point := 1;
		FOR point_aux IN SELECT (ST_dumppoints(river_line)).geom
		LOOP

--			Insert result into outfile table
			IF index_point > 1 THEN
				shape_leng := shape_leng - ST_distance(point_aux,point_aux_old);
				INSERT INTO gisras.outfile VALUES ('        ' || ST_X(point_aux) || ', ' || ST_Y(point_aux) || ', 0.0, ' || shape_leng);
			ELSE
				INSERT INTO gisras.outfile VALUES ('        ' || ST_X(point_aux) || ', ' || ST_Y(point_aux) || ', 0.0, ' || shape_leng);
			END IF;

			index_point := index_point + 1;
			point_aux_old := point_aux;
		END LOOP;

--		Close particular xs 
		INSERT INTO gisras.outfile VALUES ('END:');


	END LOOP;

--	Close XS section
	INSERT INTO gisras.outfile VALUES ('');
	INSERT INTO gisras.outfile VALUES ('END STREAM NETWORK:');


	INSERT INTO gisras.log VALUES ('gr_dump_river_to_sdf()','River dump outfile finished.',CURRENT_TIMESTAMP);
	RETURN '2d river dumping finished'::text;

END
$$;


ALTER FUNCTION gisras.gr_dump_river_to_sdf() OWNER TO postgres;

--
-- TOC entry 1479 (class 1255 OID 83589)
-- Name: gr_dump_sdf(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_dump_sdf() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

	return_text text;
	querystring Varchar;

BEGIN

--	Clear outfile table
	DELETE FROM gisras.outfile;

--	Add header to outfile
	return_text := gisras.gr_dump_sdf_header();

--	Add River to outfile
	return_text := gisras.gr_dump_river_to_sdf();

--	Add XS to outfile table
	return_text := gisras.gr_dump_xs_to_sdf();

--	Create outputfile path
	SELECT INTO return_text setting FROM pg_settings WHERE name = 'data_directory';

--	Export outfile table to sdf
	querystring := 'COPY (SELECT "Text" FROM gisras.outfile ORDER BY index) TO ' || quote_literal(return_text || '/gisRAS_postgis.sdf');
	EXECUTE querystring;

--	Log
	INSERT INTO gisras.log VALUES ('gr_dump_sdf()','SDF table exported.',CURRENT_TIMESTAMP);


	RETURN 'SDF table exported.'::text;
END
$$;


ALTER FUNCTION gisras.gr_dump_sdf() OWNER TO postgres;

--
-- TOC entry 1474 (class 1255 OID 108155)
-- Name: gr_dump_sdf(character varying); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_dump_sdf(filename character varying) RETURNS text
    LANGUAGE plpgsql
    AS $$

DECLARE
	return_text text;
	querystring varchar;
	file varchar;

BEGIN

--	Clear outfile table
	DELETE FROM gisras.outfile;

--	Add header to outfile
	return_text := gisras.gr_dump_sdf_header();

--	Add River to outfile
	return_text := gisras.gr_dump_river_to_sdf();

--	Add XS to outfile table
	return_text := gisras.gr_dump_xs_to_sdf();

--	Create outputfile path
	SELECT INTO return_text setting FROM pg_settings WHERE name = 'data_directory';

--	Export outfile table to sdf
	file:= quote_literal(return_text || '/' || filename);
	querystring := 'COPY (SELECT "Text" FROM gisras.outfile ORDER BY index) TO ' || file;
	EXECUTE querystring;

--	Log
	INSERT INTO gisras.log VALUES ('gr_dump_sdf()', 'SDF table exported: ' || querystring, CURRENT_TIMESTAMP);
	RETURN 'SDF table exported.'::text;

END

$$;


ALTER FUNCTION gisras.gr_dump_sdf(filename character varying) OWNER TO postgres;

--
-- TOC entry 1481 (class 1255 OID 83590)
-- Name: gr_dump_sdf_header(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_dump_sdf_header() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE

	return_text text;

BEGIN

--	Write sdf XS header
	INSERT INTO gisras.outfile VALUES ('#File generated by gisRAS (GITS-UPC) for postGIS');
	INSERT INTO gisras.outfile VALUES ('BEGIN HEADER:');
	INSERT INTO gisras.outfile VALUES ('DTM TYPE: RASTER');
	INSERT INTO gisras.outfile VALUES ('DTM:  ');
	INSERT INTO gisras.outfile VALUES ('STREAM LAYER:  ');
	INSERT INTO gisras.outfile VALUES ('NUMBER OF REACHES: ' || (SELECT COUNT(*) FROM gisras.river));
	INSERT INTO gisras.outfile VALUES ('CROSS-SECTION LAYER:  ');
	INSERT INTO gisras.outfile VALUES ('NUMBER OF CROSS-SECTIONS: ' || (SELECT COUNT(*) FROM gisras.xscutlines));
	INSERT INTO gisras.outfile VALUES ('MAP PROJECTION:  ');
	INSERT INTO gisras.outfile VALUES ('PROJECTION ZONE:  ');
	INSERT INTO gisras.outfile VALUES ('DATUM:  ');
	INSERT INTO gisras.outfile VALUES ('VERTICAL DATUM:  ');
	INSERT INTO gisras.outfile VALUES ('BEGIN SPATIAL EXTENT:');
	INSERT INTO gisras.outfile VALUES ('XMIN: ' || (SELECT min(ST_xmin(ST_Envelope(geom))) FROM gisras.xscutlines));
	INSERT INTO gisras.outfile VALUES ('YMIN: ' || (SELECT min(ST_ymin(ST_Envelope(geom))) FROM gisras.xscutlines));
	INSERT INTO gisras.outfile VALUES ('XMAX: ' || (SELECT max(ST_xmax(ST_Envelope(geom))) FROM gisras.xscutlines));
	INSERT INTO gisras.outfile VALUES ('YMAX: ' || (SELECT max(ST_ymax(ST_Envelope(geom))) FROM gisras.xscutlines));
	INSERT INTO gisras.outfile VALUES ('END SPATIAL EXTENT:');
	INSERT INTO gisras.outfile VALUES ('UNITS: METERS');
	INSERT INTO gisras.outfile VALUES ('END HEADER:');



--	Log
	INSERT INTO gisras.log VALUES ('gr_dump_sdf_header()','SDF header dumped.',CURRENT_TIMESTAMP);


	RETURN 'SDF header exported.'::text;
END
$$;


ALTER FUNCTION gisras.gr_dump_sdf_header() OWNER TO postgres;

--
-- TOC entry 1482 (class 1255 OID 83591)
-- Name: gr_dump_xs_to_sdf(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_dump_xs_to_sdf() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
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
	INSERT INTO gisras.outfile VALUES ('');
	INSERT INTO gisras.outfile VALUES ('');
	INSERT INTO gisras.outfile VALUES ('BEGIN CROSS-SECTIONS:');


--	For each line in xscutlines
	FOR row_id IN SELECT gid FROM gisras.xscutlines
	LOOP

--		Get the geom and remain fields
		SELECT INTO xscutlines_line geom FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO shape_leng xscutlines.shape_leng FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO hydroid xscutlines.hydroid FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO profilem xscutlines.profilem FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO rivercode xscutlines.rivercode FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO reachcode xscutlines.reachcode FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO leftbank xscutlines.leftbank FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO rightbank xscutlines.rightbank FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO llength xscutlines.llength FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO chlength xscutlines.chlength FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO rlength xscutlines.rlength FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO nodename xscutlines.nodename FROM gisras.xscutlines WHERE gid = row_id;

--		Write particular XS header
		INSERT INTO gisras.outfile VALUES ('');
		INSERT INTO gisras.outfile VALUES ('CROSS-SECTION:');
		INSERT INTO gisras.outfile VALUES ('STREAM ID: ' || rivercode);
		INSERT INTO gisras.outfile VALUES ('REACH ID: ' || reachcode);
		INSERT INTO gisras.outfile VALUES ('STATION: ' || profilem);

		IF nodename IS NULL THEN
			INSERT INTO gisras.outfile VALUES ('NODE NAME: ');
		ELSE
			INSERT INTO gisras.outfile VALUES ('NODE NAME: ' || nodename);
		END IF;

		INSERT INTO gisras.outfile VALUES ('BANK POSITIONS: ' || leftbank || ', ' || rightbank);
		INSERT INTO gisras.outfile VALUES ('REACH LENGTHS: ' || llength || ', ' || chlength || ', ' || rlength);
		INSERT INTO gisras.outfile VALUES ('NVALUES:');
		INSERT INTO gisras.outfile VALUES ('LEVEE POSITIONS:');
		INSERT INTO gisras.outfile VALUES ('INEFFECTIVE POSITIONS:');
		INSERT INTO gisras.outfile VALUES ('BLOCKED POSITIONS:');
		INSERT INTO gisras.outfile VALUES ('CUT LINE:');

--		Loop for xs 2d nodes
		FOR point_aux IN SELECT (ST_dumppoints(xscutlines_line)).geom
		LOOP

			INSERT INTO gisras.outfile VALUES ('        ' || ST_X(point_aux) || ', ' || ST_Y(point_aux));

		END LOOP;
	
		INSERT INTO gisras.outfile VALUES ('SURFACE LINE:');

--		Compute 3d crossection
		WITH intersectLines AS
			(SELECT ST_intersection(xscutlines_line,B.rast) AS geomval FROM gisras.mdt as B WHERE ST_intersects(xscutlines_line, B.rast)),
--		Compute midpoint for every intersection line
		     intersectMidpoints AS
			(SELECT ST_line_interpolate_point((geomval).geom,0.5) AS geom, (geomval).val AS val, ST_distance(ST_startpoint(ST_LineMerge(xscutlines_line)), ST_line_interpolate_point((geomval).geom,0.5)) AS distance FROM intersectLines WHERE ST_geometrytype((geomval).geom) = 'ST_LineString'),
--		Compute ordered midpoint using distance
		     intersectMidpointsSort AS
			(SELECT geom AS geom, val AS val, distance AS distance FROM intersectMidpoints ORDER BY distance)
--		Insert result into outfile table
		INSERT INTO gisras.outfile SELECT ('        ' || ST_X(intersectMidpointsSort.geom) || ', ' || ST_Y(intersectMidpointsSort.geom) || ', ' || intersectMidpointsSort.val) FROM intersectMidpointsSort;

--		Close particular xs 
		INSERT INTO gisras.outfile VALUES ('END:');


	END LOOP;

--	Close XS section
	INSERT INTO gisras.outfile VALUES ('');
	INSERT INTO gisras.outfile VALUES ('END CROSS-SECTIONS:');


	INSERT INTO gisras.log VALUES ('gr_dump_xs_to_sdf()','Banks computation finished',CURRENT_TIMESTAMP);
	RETURN '3d XS dumping finished'::text;

END
$$;


ALTER FUNCTION gisras.gr_dump_xs_to_sdf() OWNER TO postgres;

--
-- TOC entry 1494 (class 1255 OID 116343)
-- Name: gr_export_geo(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_export_geo() RETURNS text
    LANGUAGE sql
    AS $$--Clear log
SELECT gisras.gr_clear_log();

--Log
INSERT INTO gisras.log VALUES ('gr_export_geo()','Empty log',CURRENT_TIMESTAMP);

--Clear error
SELECT gisras.gr_clear_error();

--Compute stream length
SELECT gisras.gr_stream_length();

--XS station
SELECT gisras.gr_xs_station();

--XS banks
SELECT gisras.gr_xs_banks();

--XS flowpaths
SELECT gisras.gr_xs_lengths();

--Dump river & XS data to outfile and export to sdf
SELECT gisras.gr_dump_sdf();

--Update 3d layers
SELECT gisras.gr_fill_3d_tables();

--Log
INSERT INTO gisras.log VALUES ('gr_export_geo()','Sdf file finished.',CURRENT_TIMESTAMP);

--Return
SELECT 'gisras geometry export finished'::text;$$;


ALTER FUNCTION gisras.gr_export_geo() OWNER TO postgres;

--
-- TOC entry 1473 (class 1255 OID 108156)
-- Name: gr_export_geo(character varying); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_export_geo(filename character varying) RETURNS text
    LANGUAGE sql
    AS $$

SELECT gisras.gr_clear_log();

--Log
INSERT INTO gisras.log VALUES ('gr_export_geo()', 'Empty log', CURRENT_TIMESTAMP);

--Clear error
SELECT gisras.gr_clear_error();

--Compute stream length
SELECT gisras.gr_stream_length();

--XS station
SELECT gisras.gr_xs_station();

--XS banks
SELECT gisras.gr_xs_banks();

--XS flowpaths
SELECT gisras.gr_xs_lengths();

--Dump river & XS data to outfile and export to sdf
SELECT gisras.gr_dump_sdf(filename);

--Update 3d layers
SELECT gisras.gr_fill_3d_tables();

--Log
INSERT INTO gisras.log VALUES ('gr_export_geo()', 'Sdf file finished', CURRENT_TIMESTAMP);

--Return
SELECT 'gisras geometry export finished'::text;
$$;


ALTER FUNCTION gisras.gr_export_geo(filename character varying) OWNER TO postgres;

--
-- TOC entry 1483 (class 1255 OID 83593)
-- Name: gr_fill_3d_tables(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_fill_3d_tables() RETURNS text
    LANGUAGE sql
    AS $$--Insert XS in xscutlines3d
SELECT gisras.gr_xs_2dto3d();

--Insert River in river3d 
SELECT gisras.gr_river_2dto3d();

--Log
INSERT INTO gisras.log VALUES ('gr_fill_3d_tables()','3d Tables filled.',CURRENT_TIMESTAMP);

--Return
SELECT '3d tables filled'::text;$$;


ALTER FUNCTION gisras.gr_fill_3d_tables() OWNER TO postgres;

--
-- TOC entry 1496 (class 1255 OID 83811)
-- Name: gr_open_case(text); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_open_case(schema text) RETURNS text
    LANGUAGE plpgsql
    AS $_$DECLARE
	t_ex integer := 0;
	trg_table character varying;
	src_table character varying;
	src_table_aux character varying;

BEGIN

--	Check schema
	IF (SELECT 1 FROM pg_namespace WHERE nspname = schema) THEN

--		Copy tables
		FOR src_table IN EXECUTE(FORMAT($q$SELECT table_name FROM information_schema.TABLES WHERE table_schema = %s  AND table_type = 'BASE TABLE'$q$,quote_literal(schema)))
		LOOP

--			Table name
			trg_table := 'gisras.' || quote_ident(src_table);


--			Check the table name for raster table
			IF (src_table = 'mdt') THEN
				src_table_aux := quote_ident(schema) || '.mdt';
				
--				Delete old mdt table
				DROP TABLE IF EXISTS gisras.mdt;
				EXECUTE(FORMAT($q$CREATE TABLE %s (LIKE %s)$q$,trg_table,src_table_aux));
				EXECUTE 'INSERT INTO ' || trg_table || '(SELECT * FROM ' || src_table_aux || ')';

			ELSE

				EXECUTE 'DELETE FROM ' || trg_table;
				EXECUTE 'INSERT INTO ' || trg_table || '(SELECT * FROM ' || quote_ident(schema) || '.' || quote_ident(src_table) || ')';

			END IF;

		END LOOP;


	ELSE
		INSERT INTO gisras.error VALUES ('gr_open_case(' || schema || ')', 'Case ' || schema || ' does not exist.',CURRENT_TIMESTAMP);
	END IF;


--	Log
	INSERT INTO gisras.log VALUES ('gr_open_case(' || schema || ')', 'Case ' || schema || ' loaded',CURRENT_TIMESTAMP);	
	RETURN 'gisras case ' || schema || ' load finished'::text;

END;$_$;


ALTER FUNCTION gisras.gr_open_case(schema text) OWNER TO postgres;

--
-- TOC entry 1484 (class 1255 OID 83595)
-- Name: gr_river_2dto3d(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_river_2dto3d() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
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
	DELETE FROM gisras.river3d;


--	For each line in xscutlines
	FOR row_id IN SELECT gid FROM gisras.river
	LOOP

--		Get the geom and remain fields
		SELECT INTO river_line geom FROM gisras.river WHERE gid = row_id;
		SELECT INTO shape_leng river.shape_leng FROM gisras.river WHERE gid = row_id;
		SELECT INTO hydroid river.hydroid FROM gisras.river WHERE gid = row_id;
		SELECT INTO rivercode river.rivercode FROM gisras.river WHERE gid = row_id;
		SELECT INTO reachcode river.reachcode FROM gisras.river WHERE gid = row_id;
		SELECT INTO fromnode river.fromnode FROM gisras.river WHERE gid = row_id;
		SELECT INTO tonode river.tonode FROM gisras.river WHERE gid = row_id;
		SELECT INTO arclength river.arclength FROM gisras.river WHERE gid = row_id;
		SELECT INTO fromsta river.fromsta FROM gisras.river WHERE gid = row_id;
		SELECT INTO tosta river.tosta FROM gisras.river WHERE gid = row_id;


--		Compute 3d crossection
		WITH intersectLines AS
			(SELECT ST_intersection(river_line,B.rast) AS geomval FROM gisras.mdt as B WHERE ST_intersects(river_line, B.rast)),
--		Compute midpoint for every intersection line
		     intersectMidpoints AS
			(SELECT ST_line_interpolate_point((geomval).geom,0.5) AS geom, (geomval).val AS val, ST_distance(ST_startpoint(ST_LineMerge(river_line)), ST_line_interpolate_point((geomval).geom,0.5)) AS distance FROM intersectLines WHERE ST_geometrytype((geomval).geom) = 'ST_LineString'),
--		Compute ordered midpoint using distance
		     intersectMidpointsSort AS
			(SELECT geom AS geom, val AS val, distance AS distance FROM intersectMidpoints ORDER BY distance),
--		Compute 3d line
		     line3d_CTE AS
			(SELECT ST_makeline(ST_MakePoint(ST_X(geom), ST_Y(geom), val)) AS st_makeline FROM intersectMidpointsSort)
--		Store the resulting 3d line
		SELECT INTO line3d ST_multi(st_makeline) FROM line3d_CTE;

--		Insert 3d line in xscutlines3d
		INSERT INTO gisras.river3d (shape_leng, riv2did, hydroid, rivercode, reachcode, fromnode, tonode, arclength, fromsta, tosta, geom) VALUES (shape_leng, hydroid, row_id, rivercode, reachcode, fromnode, tonode, arclength, fromsta, tosta,line3d);
		
--		Insert result into outfile table
--		INSERT INTO gisras.outfile SELECT ('pp1 ' || ST_X(intersectMidpoints.geom) || ST_X(intersectMidpoints.geom) || intersectMidpoints.val || 'pp2' || 'pp3') FROM intersectMidpoints;



	END LOOP;

	INSERT INTO gisras.log VALUES ('gr_river_2dto3d()','River profiles computation finished',CURRENT_TIMESTAMP);
	RETURN '3d river computation finished'::text;

END
$$;


ALTER FUNCTION gisras.gr_river_2dto3d() OWNER TO postgres;

--
-- TOC entry 1487 (class 1255 OID 83808)
-- Name: gr_save_case_as(text); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_save_case_as(schema text) RETURNS text
    LANGUAGE plpgsql
    AS $_$DECLARE
	t_ex integer := 0;
	trg_table character varying;
	src_table character varying;
BEGIN

--	Check schema
	IF (SELECT 1 FROM pg_namespace WHERE nspname = schema) THEN
		INSERT INTO gisras.log VALUES ('gr_save_case_as(' || schema || ')', 'Case ' || schema || ' overwritten',CURRENT_TIMESTAMP);
		PERFORM gisras.gr_delete_case(schema);
	END IF;

	EXECUTE(FORMAT($q$CREATE SCHEMA %s AUTHORIZATION postgres$q$,quote_ident(schema)));

--	Create tables
	FOR src_table IN SELECT table_name FROM information_schema.TABLES WHERE table_schema = 'gisras' AND table_type = 'BASE TABLE'
	LOOP
--		Check the table name
		IF (src_table <> 'error' AND src_table <> 'log' AND src_table <> 'logfile') THEN
			trg_table := quote_ident(schema) || '.' || quote_ident(src_table);
			EXECUTE(FORMAT($q$CREATE TABLE %s (LIKE gisras.%I)$q$,trg_table,src_table));
			EXECUTE 'INSERT INTO ' || trg_table || '(SELECT * FROM gisras.' || quote_ident(src_table) || ')';
		END IF;
	END LOOP;

--	Log
	INSERT INTO gisras.log VALUES ('gr_save_case_as(' || schema || ')', 'Case ' || schema || 'saved',CURRENT_TIMESTAMP);	
	RETURN 'gisras schema save as finished'::text;


END;
$_$;


ALTER FUNCTION gisras.gr_save_case_as(schema text) OWNER TO postgres;

--
-- TOC entry 1486 (class 1255 OID 83596)
-- Name: gr_stream_length(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_stream_length() RETURNS SETOF numeric
    LANGUAGE sql
    AS $$UPDATE gisras.river SET shape_leng=ST_Length(geom),
                         arclength=ST_Length(geom),
                         fromsta=gisras.gr_downstream_distance(tonode, rivercode, 0.0),
                         tosta=gisras.gr_downstream_distance(tonode, rivercode, 0.0)+ST_Length(geom);
INSERT INTO gisras.log VALUES ('gr_stream_length()','Stream length computation finished',CURRENT_TIMESTAMP);
SELECT shape_leng FROM gisras.river;
$$;


ALTER FUNCTION gisras.gr_stream_length() OWNER TO postgres;

--
-- TOC entry 1209 (class 1255 OID 96460)
-- Name: gr_topology_check_node(public.geometry); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_topology_check_node(punto public.geometry, OUT nodegid integer, OUT nodegeom public.geometry) RETURNS record
    LANGUAGE plpgsql STRICT
    AS $_$ 
DECLARE 
	querystring Varchar; 
	nodeRecord Record; 
BEGIN 
	querystring := 'SELECT nodes.' || quote_ident('OBJECTID') || ' AS nodegid, nodes.geom as nodegeom FROM gisras.'
		|| quote_ident('NodesTable') || ' nodes WHERE nodes.geom && ST_EXPAND ($1, 1.0)'; 
	EXECUTE querystring INTO nodeRecord USING punto; 

	IF (nodeRecord.nodegid IS NULL) THEN 
		EXECUTE 'INSERT INTO gisras.' || quote_ident('NodesTable') || ' (numarcs, geom) VALUES (1,$1)' USING punto; 
		EXECUTE 'SELECT currval (' || quote_literal('gisras.nodestable_objectid_seq') || ')' INTO nodeRecord.nodegid; 
		nodeRecord.nodegeom:= punto; 
	ELSE 
		EXECUTE 'UPDATE gisras.' || quote_ident('NodesTable') || ' SET numarcs = numarcs + 1 WHERE ' || quote_ident('OBJECTID') || ' = ' || nodeRecord.nodegid; 
	END IF;
 
	nodegid:= nodeRecord.nodegid; 
	nodegeom:= nodeRecord.nodegeom; 

	RETURN; 
END; 
$_$;


ALTER FUNCTION gisras.gr_topology_check_node(punto public.geometry, OUT nodegid integer, OUT nodegeom public.geometry) OWNER TO postgres;

--
-- TOC entry 1472 (class 1255 OID 96468)
-- Name: gr_topology_cross(public.geometry, public.geometry); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_topology_cross(geoml public.geometry, geom2 public.geometry) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$ 
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
$$;


ALTER FUNCTION gisras.gr_topology_cross(geoml public.geometry, geom2 public.geometry) OWNER TO postgres;

--
-- TOC entry 1491 (class 1255 OID 83816)
-- Name: gr_topology_delete_river(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_topology_delete_river() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
--Function created modifying "tgg_functionborralinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 
 
DECLARE 
	querystring Varchar; 
	nodosrec Record; 
	nodosactualizados Integer; 

BEGIN 
	nodosactualizados := 0; 
 
	querystring := 'SELECT nodos.' || quote_ident ('OBJECTID') || ' AS ' || quote_ident ('OBJECTID') || ', nodos.numarcs AS numarcs FROM gisras.'
			|| quote_ident ('NodesTable') || ' nodos WHERE nodos.' || quote_ident('OBJECTID') || ' = ' 
			|| OLD.fromnode || ' OR nodos.' || quote_ident('OBJECTID') || ' = ' || OLD.tonode; 

INSERT INTO gisras.log VALUES ('gr_test()',querystring,CURRENT_TIMESTAMP);
			

	FOR nodosrec IN EXECUTE querystring
	LOOP
		nodosactualizados := nodosactualizados + 1; 

		IF (nodosrec.numarcs <= 1) THEN 
			EXECUTE 'DELETE FROM gisras.'|| quote_ident ('NodesTable') || ' WHERE ' || quote_ident('OBJECTID') || ' = ' || nodosrec."OBJECTID"; 
		ELSE 
			EXECUTE 'UPDATE gisras.' || quote_ident('NodesTable') || ' SET numarcs = numarcs - 1 WHERE ' || quote_ident('OBJECTID') || ' = ' || nodosrec."OBJECTID"; 
		END IF; 

	END LOOP; 

	RETURN OLD; 
END; 
$$;


ALTER FUNCTION gisras.gr_topology_delete_river() OWNER TO postgres;

--
-- TOC entry 1210 (class 1255 OID 96463)
-- Name: gr_topology_insert_river(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_topology_insert_river() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$ 

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
	querystring Varchar; 
	querystringinicial Varchar; 
	ngeoms Integer; 
	unionall Geometry; 
	array_len Integer; 
	gids Integer[];
 
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
		querystring:= 'INSERT INTO gisras.river VALUES ($1.*)'; 
		querystringUPDATE:= 'UPDATE gisras.river SET fromnode = -1 WHERE gid = $1'; 
		querystringinicial:= 'SELECT * FROM gisras.river t1 WHERE ST_EXPAND ($1,1.0
					) && t1.geom AND t1.gid <> $2 AND (NOT gisras.gr_topology_cross(t1.geom, $1)) AND ST_DISTANCE(t1.geom, $1) <= 1.0'; 

		ngeoms:= 0; 
		unionall:= ST_startpoint(ST_LineMerge(NEW.geom)); 

		FOR elemfeature in EXECUTE querystringinicial USING ST_LineMerge(NEW.geom), NEW.gid LOOP 
			ngeoms:= ngeoms + 1; 
			unionall:= ST_Union (unionall, elemfeature.geom); 
			gids:= array_append (gids, elemfeature.gid); 
		END LOOP; 

--		ngeoms sera mayor de cero si la geometria insertada interseca 
--		con alguna otra geometria. 
 
		IF (ngeoms > 0) THEN 
--			mediante e1 comando ST_Snap (a partir de PostGIS 2.0) se evitan 
--			errores tipo TopologyException de PostGIS (desde GEOS). 
			NEW.geom:= ST_multi(ST_Snap(ST_LineMerge(NEW.geom), unionall, 1.0)); 
			geomfrag:= ST_Difference(ST_LineMerge(NEW.geom), unionall); 

			IF (geomfrag IS NOT NULL) THEN 
				FOR elemgeom1 IN SELECT (st_dump(geomfrag)).geom
				LOOP 
					simplefeature      := NEW; 
					simplefeature.geom := ST_multi(elemgeom1); 
					simplefeature.gid  := nextval('gisras.river_gid_seq'); 

--					marca e1 nodo inicia1 a -2 
					simplefeature.fromnode:= -2; 

--					Esta funcion lanzara de nuevo el disparador INSERT saltando 
--					de forma recursiva a tggFunction_insertlinea 
					EXECUTE querystring using simplefeature; 

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
		nodeRecord1  := gisras.gr_topology_check_node (ST_startpoint(ST_LineMerge(NEW.geom))); 
		NEW.fromnode := nodeRecord1.nodegid; 
		nodeRecord2  := gisras.gr_topology_check_node (ST_endpoint(ST_LineMerge(NEW.geom))); 
		NEW.tonode   := nodeRecord2.nodegid; 

--		modifica los puntos inicial y final de la linea para que coincida con los 
--		nodos (debido a la tolerancia) 
		NEW.geom := ST_multi(ST_SetPoint(ST_SetPoint(ST_LineMerge(NEW.geom), 0, nodeRecord1.nodegeom), ST_NPoints(ST_LineMerge(NEW.geom)) - 1, nodeRecord2.nodegeom)); 

		RETURN NEW; 
	ELSE
		RETURN NULL;
	END IF;

END; 
$_$;


ALTER FUNCTION gisras.gr_topology_insert_river() OWNER TO postgres;

--
-- TOC entry 1488 (class 1255 OID 96455)
-- Name: gr_topology_update_river(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_topology_update_river() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$--Function created modifying "tgg_functionactualizalinea" developed by Jose C. Martinez Llario
--in "PostGIS 2 Analisis Espacial Avanzado" 

DECLARE 
	querystringdelete Varchar; 
	querystringINSERT Varchar; 
	marca Integer; 

BEGIN 
	querystringdelete:= 'DELETE FROM gisras.river WHERE gid = $1'; 
	querystringINSERT:= 'INSERT INTO gisras.river VALUES ($1.*)';

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

--	El 'usuario no puede cambiar el valor de los nodos de forma manual 
	NEW.fromnode:= OLD.fromnode; 
	NEW.tonode:= OLD.tonode; 

RETURN NEW; 

END; 
$_$;


ALTER FUNCTION gisras.gr_topology_update_river() OWNER TO postgres;

--
-- TOC entry 1485 (class 1255 OID 83597)
-- Name: gr_update_banks_view(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_update_banks_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
   BEGIN
      IF TG_OP = 'INSERT' THEN
        INSERT INTO  gisras.banks VALUES(DEFAULT,DEFAULT,DEFAULT,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE gisras.banks SET geom=NEW.geom WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM gisras.banks WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$$;


ALTER FUNCTION gisras.gr_update_banks_view() OWNER TO postgres;

--
-- TOC entry 1452 (class 1255 OID 83598)
-- Name: gr_update_flowpaths_view(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_update_flowpaths_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
      IF TG_OP = 'INSERT' THEN
        INSERT INTO  gisras.flowpaths VALUES(DEFAULT,DEFAULT,NEW.linetype,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE gisras.flowpaths SET geom=NEW.geom, linetype=NEW.linetype WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM gisras.flowpaths WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$$;


ALTER FUNCTION gisras.gr_update_flowpaths_view() OWNER TO postgres;

--
-- TOC entry 1489 (class 1255 OID 96451)
-- Name: gr_update_nodestable(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_update_nodestable() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

	NEW."X"=ST_X(NEW.geom);
	NEW."Y"=ST_Y(NEW.geom);
	NEW."Z"=0.0;
	NEW."NodeID" = NEW."OBJECTID";
	RETURN NEW;

END;$$;


ALTER FUNCTION gisras.gr_update_nodestable() OWNER TO postgres;

--
-- TOC entry 1453 (class 1255 OID 83599)
-- Name: gr_update_river_view(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_update_river_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
      IF TG_OP = 'INSERT' THEN
        INSERT INTO  gisras.river VALUES(DEFAULT,DEFAULT,DEFAULT,NEW.rivercode,NEW.reachcode,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE gisras.river SET geom=NEW.geom,rivercode=NEW.rivercode,reachcode=NEW.reachcode WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM gisras.river WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;
$$;


ALTER FUNCTION gisras.gr_update_river_view() OWNER TO postgres;

--
-- TOC entry 1454 (class 1255 OID 83600)
-- Name: gr_update_xscutlines_view(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_update_xscutlines_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
      IF TG_OP = 'INSERT' THEN
        INSERT INTO  gisras.xscutlines VALUES(DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,DEFAULT,NEW.nodename,NEW.geom);
        RETURN NEW;
      ELSIF TG_OP = 'UPDATE' THEN
       UPDATE gisras.xscutlines SET geom=NEW.geom,nodename=NEW.nodename WHERE gid=OLD.gid;
       RETURN NEW;
      ELSIF TG_OP = 'DELETE' THEN
       DELETE FROM gisras.xscutlines WHERE gid=OLD.gid;
       RETURN NULL;
      END IF;
      RETURN NEW;
    END;$$;


ALTER FUNCTION gisras.gr_update_xscutlines_view() OWNER TO postgres;

--
-- TOC entry 1455 (class 1255 OID 83601)
-- Name: gr_xs_2dto3d(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_xs_2dto3d() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
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
	DELETE FROM gisras.xscutlines3d;


--	For each line in xscutlines
	FOR row_id IN SELECT gid FROM gisras.xscutlines
	LOOP

--		Get the geom and remain fields
		SELECT INTO xscutlines_line geom FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO shape_leng xscutlines.shape_leng FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO hydroid xscutlines.hydroid FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO profilem xscutlines.profilem FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO rivercode xscutlines.rivercode FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO reachcode xscutlines.reachcode FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO leftbank xscutlines.leftbank FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO rightbank xscutlines.rightbank FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO llength xscutlines.llength FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO chlength xscutlines.chlength FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO rlength xscutlines.rlength FROM gisras.xscutlines WHERE gid = row_id;
		SELECT INTO nodename xscutlines.nodename FROM gisras.xscutlines WHERE gid = row_id;


--		Compute 3d crossection
		WITH intersectLines AS
			(SELECT ST_intersection(xscutlines_line,B.rast) AS geomval FROM gisras.mdt as B WHERE ST_intersects(xscutlines_line, B.rast)),
--		Compute midpoint for every intersection line
		     intersectMidpoints AS
			(SELECT ST_line_interpolate_point((geomval).geom,0.5) AS geom, (geomval).val AS val, ST_distance(ST_startpoint(ST_LineMerge(xscutlines_line)), ST_line_interpolate_point((geomval).geom,0.5)) AS distance FROM intersectLines WHERE ST_geometrytype((geomval).geom) = 'ST_LineString'),
--		Compute ordered midpoint using distance
		     intersectMidpointsSort AS
			(SELECT geom AS geom, val AS val, distance AS distance FROM intersectMidpoints ORDER BY distance),
--		Compute 3d line
		     line3d_CTE AS
			(SELECT ST_makeline(ST_MakePoint(ST_X(geom), ST_Y(geom), val)) AS st_makeline FROM intersectMidpointsSort)
--		Store the resulting 3d line
		SELECT INTO line3d ST_multi(st_makeline) FROM line3d_CTE;

--		Insert 3d line in xscutlines3d
		INSERT INTO gisras.xscutlines3d (shape_leng, xs2did, hydroid, profilem, rivercode, reachcode, leftbank, rightbank, llength, chlength, rlength, nodename, geom) VALUES (shape_leng, hydroid, row_id, profilem, rivercode, reachcode, leftbank, rightbank, llength, chlength, rlength, nodename,line3d);
		

	END LOOP;

	INSERT INTO gisras.log VALUES ('gr_xs_2dto3d()','Crossections profiles computation finished',CURRENT_TIMESTAMP);
	RETURN '3d crossections computation finished'::text;

END
$$;


ALTER FUNCTION gisras.gr_xs_2dto3d() OWNER TO postgres;

--
-- TOC entry 1456 (class 1255 OID 83602)
-- Name: gr_xs_banks(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_xs_banks() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
	bank_point geometry[2];
	bank_point_dist1 double precision;
	bank_point_dist2 double precision;
	number_of_bank_lines integer;
	xscutlines_line geometry;
	xscutlines_gid integer;
BEGIN

--	Compute banks lengths
	UPDATE gisras.banks SET shape_leng = ST_length(ST_LineMerge(gisras.banks.geom));

--	Empty banks values
	UPDATE gisras.xscutlines SET leftbank = NULL, rightbank = NULL;

--	Log	
	INSERT INTO gisras.log VALUES ('gr_xs_banks()','Begining banks intersections search',CURRENT_TIMESTAMP);


--	For each line in xscutlines
	FOR xscutlines_line, xscutlines_gid IN SELECT geom, gid FROM gisras.xscutlines
	LOOP

--		Control of bank lines intersection number
		SELECT COUNT(ST_intersection(gisras.banks.geom,xscutlines_line)) INTO number_of_bank_lines FROM gisras.banks  WHERE ST_intersects(gisras.banks.geom,xscutlines_line); 

		IF number_of_bank_lines <> 2 THEN
			INSERT INTO gisras.error VALUES ('gr_xs_banks()',format('Error: not exactly 2 bank lines in XS=%s',xscutlines_gid),CURRENT_TIMESTAMP);
		ELSE


--			Bank points
			bank_point := ARRAY(SELECT ST_intersection(gisras.banks.geom,xscutlines_line) FROM gisras.banks WHERE ST_intersects(gisras.banks.geom,xscutlines_line));
		
--			Banks position
			SELECT INTO bank_point_dist1 ST_line_locate_point(ST_LineMerge(xscutlines_line), bank_point[1]);
			SELECT INTO bank_point_dist2 ST_line_locate_point(ST_LineMerge(xscutlines_line), bank_point[2]);

--			Set values
			if bank_point_dist2 > bank_point_dist1 THEN
				UPDATE gisras.xscutlines SET leftbank= bank_point_dist1, rightbank=  bank_point_dist2 WHERE gid= xscutlines_gid;
			ELSE
				UPDATE gisras.xscutlines SET leftbank= bank_point_dist2, rightbank=  bank_point_dist1 WHERE gid= xscutlines_gid;
			END IF;

		END IF;	

	END LOOP;

	INSERT INTO gisras.log VALUES ('gr_xs_banks()','Banks computation finished',CURRENT_TIMESTAMP);
	RETURN 'Banks computation finished'::text;

END$$;


ALTER FUNCTION gisras.gr_xs_banks() OWNER TO postgres;

--
-- TOC entry 1457 (class 1255 OID 83603)
-- Name: gr_xs_lengths(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_xs_lengths() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
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
	UPDATE gisras.flowpaths SET shape_leng = ST_length(ST_LineMerge(gisras.flowpaths.geom));

--	Compute xscutlines length
	UPDATE gisras.xscutlines SET shape_leng = ST_length(ST_LineMerge(gisras.xscutlines.geom));

--	Empty flowpaths values
	UPDATE gisras.xscutlines SET llength = NULL, chlength = NULL, rlength = NULL;

--	Log	
	INSERT INTO gisras.log VALUES ('gr_xs_length()','Begining flowpaths intersections search',CURRENT_TIMESTAMP);


--	For each river in river layer
	FOR river_code IN SELECT rivercode FROM gisras.river GROUP BY rivercode 
	LOOP

--		For each line in xscutlines
		index_row := 1;
		FOR xscutlines_line, xscutlines_gid IN SELECT xscutlines.geom, xscutlines.gid FROM gisras.xscutlines WHERE gisras.xscutlines.rivercode = river_code ORDER BY profilem
		LOOP

--			Control of flowpaths lines intersection number
			SELECT COUNT(ST_intersection(gisras.flowpaths.geom,xscutlines_line)) INTO number_of_flowpath_lines FROM gisras.flowpaths  WHERE ST_intersects(gisras.flowpaths.geom,xscutlines_line); 

			IF number_of_flowpath_lines <> 3 THEN
				INSERT INTO gisras.error VALUES ('gr_xs_length()',format('Error: not exactly 3 flowpath lines in XS=%s',xscutlines_gid),CURRENT_TIMESTAMP);
			ELSE


--				Flowpath points
				flowpath_point_new := ARRAY(SELECT ST_intersection(gisras.flowpaths.geom,xscutlines_line) FROM gisras.flowpaths WHERE ST_intersects(gisras.flowpaths.geom,xscutlines_line));
		
--				Banks position
				flowpath_point_dist := ARRAY(SELECT ST_line_locate_point(ST_LineMerge(xscutlines_line), x) FROM unnest(flowpath_point_new) x);

--				Sort points
				flowpath_point_new := ARRAY(SELECT unnest(flowpath_point_new) ORDER BY flowpath_point_dist);

--				Set values
				if index_row > 1 THEN
					UPDATE gisras.xscutlines SET llength = ST_distance(flowpath_point_new[1],flowpath_point_old[1]), chlength = ST_distance(flowpath_point_new[2],flowpath_point_old[2]), rlength = ST_distance(flowpath_point_new[3],flowpath_point_old[3]) WHERE gid= xscutlines_gid;
				ELSE
					UPDATE gisras.xscutlines SET llength = 0.0, chlength = 0.0, rlength = 0.0 WHERE gid= xscutlines_gid;
				END IF;

--				Update index and values
				index_row := index_row + 1;
				flowpath_point_old := flowpath_point_new;

			END IF;	

		END LOOP;

	END LOOP;

	INSERT INTO gisras.log VALUES ('gr_xs_flowpaths()','Flowpaths computation finished',CURRENT_TIMESTAMP);
	RETURN 'Flowpaths computation finished'::text;

END









$$;


ALTER FUNCTION gisras.gr_xs_lengths() OWNER TO postgres;

--
-- TOC entry 1490 (class 1255 OID 83604)
-- Name: gr_xs_station(); Type: FUNCTION; Schema: gisras; Owner: postgres
--

CREATE FUNCTION gr_xs_station() RETURNS text
    LANGUAGE plpgsql
    AS $$DECLARE
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
	UPDATE gisras.xscutlines SET profilem = NULL, rivercode = NULL, reachcode = NULL;

--	Log	
	INSERT INTO gisras.log VALUES ('gr_xs_station()','Begining river intersections search',CURRENT_TIMESTAMP);


--	For each line in xscutlines
	FOR xscutlines_line, xscutlines_gid IN SELECT geom, gid FROM gisras.xscutlines
	LOOP

--		Control of stream lines intersection number
		SELECT COUNT(ST_intersection(gisras.river.geom,xscutlines_line)) INTO number_of_stream_lines FROM gisras.river WHERE ST_intersects(gisras.river.geom,xscutlines_line); 

		IF number_of_stream_lines <> 1 THEN
			INSERT INTO gisras.error VALUES ('gr_xs_station()',format('Error: not exactly 1 river lines in XS=%s',xscutlines_gid),CURRENT_TIMESTAMP);
		ELSE

--			River and reach code
			UPDATE gisras.xscutlines SET rivercode = gisras.river.rivercode, reachcode = gisras.river.reachcode FROM gisras.river WHERE ST_intersects(gisras.river.geom,xscutlines_line) AND gisras.xscutlines.gid= xscutlines_gid;

--			Stream points
			SELECT INTO stream_point ST_intersection(gisras.river.geom,xscutlines_line) FROM gisras.river WHERE ST_intersects(gisras.river.geom,xscutlines_line);
			SELECT INTO stream_length gisras.river.shape_leng FROM gisras.river WHERE ST_intersects(gisras.river.geom,xscutlines_line);
			SELECT INTO stream_line gisras.river.geom FROM gisras.river WHERE ST_intersects(gisras.river.geom,xscutlines_line);
			SELECT INTO stream_downstream_length gisras.river.fromsta FROM gisras.river WHERE ST_intersects(gisras.river.geom,xscutlines_line);

--			Banks position
			SELECT INTO stream_point_dist (1.0 - ST_line_locate_point(ST_LineMerge(stream_line), stream_point)) * stream_length + stream_downstream_length;

--			Set values
			UPDATE gisras.xscutlines SET profilem = stream_point_dist WHERE gid= xscutlines_gid;

		END IF;	

	END LOOP;

	INSERT INTO gisras.log VALUES ('gr_xs_stream()','Station computation finished',CURRENT_TIMESTAMP);
	RETURN 'Station computation finished'::text;

END$$;


ALTER FUNCTION gisras.gr_xs_station() OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- TOC entry 1212 (class 1255 OID 74996)
-- Name: addbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_addBBOX';


ALTER FUNCTION public.addbbox(geometry) OWNER TO postgres;

--
-- TOC entry 1262 (class 1255 OID 75046)
-- Name: addpoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addpoint(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_addpoint';


ALTER FUNCTION public.addpoint(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1263 (class 1255 OID 75047)
-- Name: addpoint(geometry, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION addpoint(geometry, geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_addpoint';


ALTER FUNCTION public.addpoint(geometry, geometry, integer) OWNER TO postgres;

--
-- TOC entry 1252 (class 1255 OID 75036)
-- Name: affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $2, $3, 0,  $4, $5, 0,  0, 0, 1,  $6, $7, 0)$_$;


ALTER FUNCTION public.affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1251 (class 1255 OID 75035)
-- Name: affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_affine';


ALTER FUNCTION public.affine(geometry, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1264 (class 1255 OID 75048)
-- Name: area(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION area(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_area_polygon';


ALTER FUNCTION public.area(geometry) OWNER TO postgres;

--
-- TOC entry 1265 (class 1255 OID 75049)
-- Name: area2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION area2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_area_polygon';


ALTER FUNCTION public.area2d(geometry) OWNER TO postgres;

--
-- TOC entry 1460 (class 1255 OID 74984)
-- Name: asbinary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asbinary(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asBinary';


ALTER FUNCTION public.asbinary(geometry) OWNER TO postgres;

--
-- TOC entry 1461 (class 1255 OID 74985)
-- Name: asbinary(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asbinary(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asBinary';


ALTER FUNCTION public.asbinary(geometry, text) OWNER TO postgres;

--
-- TOC entry 1266 (class 1255 OID 75050)
-- Name: asewkb(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asewkb(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'WKBFromLWGEOM';


ALTER FUNCTION public.asewkb(geometry) OWNER TO postgres;

--
-- TOC entry 1267 (class 1255 OID 75051)
-- Name: asewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asewkb(geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'WKBFromLWGEOM';


ALTER FUNCTION public.asewkb(geometry, text) OWNER TO postgres;

--
-- TOC entry 1268 (class 1255 OID 75052)
-- Name: asewkt(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asewkt(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asEWKT';


ALTER FUNCTION public.asewkt(geometry) OWNER TO postgres;

--
-- TOC entry 1269 (class 1255 OID 75053)
-- Name: asgml(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asgml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, 15, 0, null)$_$;


ALTER FUNCTION public.asgml(geometry) OWNER TO postgres;

--
-- TOC entry 1270 (class 1255 OID 75054)
-- Name: asgml(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION asgml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsGML(2, $1, $2, 0, null)$_$;


ALTER FUNCTION public.asgml(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1274 (class 1255 OID 75058)
-- Name: ashexewkb(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ashexewkb(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asHEXEWKB';


ALTER FUNCTION public.ashexewkb(geometry) OWNER TO postgres;

--
-- TOC entry 1275 (class 1255 OID 75059)
-- Name: ashexewkb(geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ashexewkb(geometry, text) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asHEXEWKB';


ALTER FUNCTION public.ashexewkb(geometry, text) OWNER TO postgres;

--
-- TOC entry 1272 (class 1255 OID 75056)
-- Name: askml(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION askml(geometry) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_Transform($1,4326), 15, null)$_$;


ALTER FUNCTION public.askml(geometry) OWNER TO postgres;

--
-- TOC entry 1271 (class 1255 OID 75055)
-- Name: askml(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION askml(geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML(2, ST_transform($1,4326), $2, null)$_$;


ALTER FUNCTION public.askml(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1273 (class 1255 OID 75057)
-- Name: askml(integer, geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION askml(integer, geometry, integer) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT _ST_AsKML($1, ST_Transform($2,4326), $3, null)$_$;


ALTER FUNCTION public.askml(integer, geometry, integer) OWNER TO postgres;

--
-- TOC entry 1276 (class 1255 OID 75060)
-- Name: assvg(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION assvg(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asSVG';


ALTER FUNCTION public.assvg(geometry) OWNER TO postgres;

--
-- TOC entry 1277 (class 1255 OID 75061)
-- Name: assvg(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION assvg(geometry, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asSVG';


ALTER FUNCTION public.assvg(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1278 (class 1255 OID 75062)
-- Name: assvg(geometry, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION assvg(geometry, integer, integer) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asSVG';


ALTER FUNCTION public.assvg(geometry, integer, integer) OWNER TO postgres;

--
-- TOC entry 1462 (class 1255 OID 74986)
-- Name: astext(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION astext(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_asText';


ALTER FUNCTION public.astext(geometry) OWNER TO postgres;

--
-- TOC entry 1279 (class 1255 OID 75063)
-- Name: azimuth(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION azimuth(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_azimuth';


ALTER FUNCTION public.azimuth(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1281 (class 1255 OID 75065)
-- Name: bdmpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bdmpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := ST_Multi(ST_BuildArea(mline));

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdmpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1280 (class 1255 OID 75064)
-- Name: bdpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION bdpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	geomtext alias for $1;
	srid alias for $2;
	mline geometry;
	geom geometry;
BEGIN
	mline := ST_MultiLineStringFromText(geomtext, srid);

	IF mline IS NULL
	THEN
		RAISE EXCEPTION 'Input is not a MultiLinestring';
	END IF;

	geom := ST_BuildArea(mline);

	IF GeometryType(geom) != 'POLYGON'
	THEN
		RAISE EXCEPTION 'Input returns more then a single polygon, try using BdMPolyFromText instead';
	END IF;

	RETURN geom;
END;
$_$;


ALTER FUNCTION public.bdpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1282 (class 1255 OID 75066)
-- Name: boundary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION boundary(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'boundary';


ALTER FUNCTION public.boundary(geometry) OWNER TO postgres;

--
-- TOC entry 1284 (class 1255 OID 75068)
-- Name: buffer(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION buffer(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'buffer';


ALTER FUNCTION public.buffer(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1283 (class 1255 OID 75067)
-- Name: buffer(geometry, double precision, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION buffer(geometry, double precision, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Buffer($1, $2, $3)$_$;


ALTER FUNCTION public.buffer(geometry, double precision, integer) OWNER TO postgres;

--
-- TOC entry 1285 (class 1255 OID 75069)
-- Name: buildarea(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION buildarea(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'ST_BuildArea';


ALTER FUNCTION public.buildarea(geometry) OWNER TO postgres;

--
-- TOC entry 1286 (class 1255 OID 75070)
-- Name: centroid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION centroid(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'centroid';


ALTER FUNCTION public.centroid(geometry) OWNER TO postgres;

--
-- TOC entry 1442 (class 1255 OID 75229)
-- Name: collect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION collect(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.0', 'LWGEOM_collect';


ALTER FUNCTION public.collect(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1443 (class 1255 OID 75230)
-- Name: combine_bbox(box2d, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION combine_bbox(box2d, geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.0', 'BOX2D_combine';


ALTER FUNCTION public.combine_bbox(box2d, geometry) OWNER TO postgres;

--
-- TOC entry 1444 (class 1255 OID 75231)
-- Name: combine_bbox(box3d, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION combine_bbox(box3d, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE
    AS '$libdir/postgis-2.0', 'BOX3D_combine';


ALTER FUNCTION public.combine_bbox(box3d, geometry) OWNER TO postgres;

--
-- TOC entry 1287 (class 1255 OID 75071)
-- Name: contains(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION contains(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'contains';


ALTER FUNCTION public.contains(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1288 (class 1255 OID 75072)
-- Name: convexhull(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION convexhull(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'convexhull';


ALTER FUNCTION public.convexhull(geometry) OWNER TO postgres;

--
-- TOC entry 1289 (class 1255 OID 75073)
-- Name: crosses(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION crosses(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'crosses';


ALTER FUNCTION public.crosses(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1291 (class 1255 OID 75075)
-- Name: difference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION difference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'difference';


ALTER FUNCTION public.difference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1292 (class 1255 OID 75076)
-- Name: dimension(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dimension(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_dimension';


ALTER FUNCTION public.dimension(geometry) OWNER TO postgres;

--
-- TOC entry 1293 (class 1255 OID 75077)
-- Name: disjoint(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION disjoint(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'disjoint';


ALTER FUNCTION public.disjoint(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1290 (class 1255 OID 75074)
-- Name: distance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION distance(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'LWGEOM_mindistance2d';


ALTER FUNCTION public.distance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1294 (class 1255 OID 75078)
-- Name: distance_sphere(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION distance_sphere(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'LWGEOM_distance_sphere';


ALTER FUNCTION public.distance_sphere(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1295 (class 1255 OID 75079)
-- Name: distance_spheroid(geometry, geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION distance_spheroid(geometry, geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'LWGEOM_distance_ellipsoid';


ALTER FUNCTION public.distance_spheroid(geometry, geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 1213 (class 1255 OID 74997)
-- Name: dropbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dropbbox(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_dropBBOX';


ALTER FUNCTION public.dropbbox(geometry) OWNER TO postgres;

--
-- TOC entry 1296 (class 1255 OID 75080)
-- Name: dump(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dump(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_dump';


ALTER FUNCTION public.dump(geometry) OWNER TO postgres;

--
-- TOC entry 1297 (class 1255 OID 75081)
-- Name: dumprings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION dumprings(geometry) RETURNS SETOF geometry_dump
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_dump_rings';


ALTER FUNCTION public.dumprings(geometry) OWNER TO postgres;

--
-- TOC entry 1304 (class 1255 OID 75089)
-- Name: endpoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION endpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_endpoint_linestring';


ALTER FUNCTION public.endpoint(geometry) OWNER TO postgres;

--
-- TOC entry 1298 (class 1255 OID 75082)
-- Name: envelope(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION envelope(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_envelope';


ALTER FUNCTION public.envelope(geometry) OWNER TO postgres;

--
-- TOC entry 1464 (class 1255 OID 74988)
-- Name: estimated_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION estimated_extent(text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-2.0', 'geometry_estimated_extent';


ALTER FUNCTION public.estimated_extent(text, text) OWNER TO postgres;

--
-- TOC entry 1463 (class 1255 OID 74987)
-- Name: estimated_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION estimated_extent(text, text, text) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-2.0', 'geometry_estimated_extent';


ALTER FUNCTION public.estimated_extent(text, text, text) OWNER TO postgres;

--
-- TOC entry 1299 (class 1255 OID 75083)
-- Name: expand(box2d, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION expand(box2d, double precision) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX2D_expand';


ALTER FUNCTION public.expand(box2d, double precision) OWNER TO postgres;

--
-- TOC entry 1300 (class 1255 OID 75084)
-- Name: expand(box3d, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION expand(box3d, double precision) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_expand';


ALTER FUNCTION public.expand(box3d, double precision) OWNER TO postgres;

--
-- TOC entry 1301 (class 1255 OID 75085)
-- Name: expand(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION expand(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_expand';


ALTER FUNCTION public.expand(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1305 (class 1255 OID 75090)
-- Name: exteriorring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION exteriorring(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_exteriorring_polygon';


ALTER FUNCTION public.exteriorring(geometry) OWNER TO postgres;

--
-- TOC entry 1302 (class 1255 OID 75087)
-- Name: find_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_extent(text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	tablename alias for $1;
	columnname alias for $2;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") As extent FROM "' || tablename || '"' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text) OWNER TO postgres;

--
-- TOC entry 1303 (class 1255 OID 75088)
-- Name: find_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION find_extent(text, text, text) RETURNS box2d
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $_$
DECLARE
	schemaname alias for $1;
	tablename alias for $2;
	columnname alias for $3;
	myrec RECORD;

BEGIN
	FOR myrec IN EXECUTE 'SELECT ST_Extent("' || columnname || '") FROM "' || schemaname || '"."' || tablename || '" As extent ' LOOP
		return myrec.extent;
	END LOOP;
END;
$_$;


ALTER FUNCTION public.find_extent(text, text, text) OWNER TO postgres;

--
-- TOC entry 1243 (class 1255 OID 75027)
-- Name: fix_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION fix_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	mislinked record;
	result text;
	linked integer;
	deleted integer;
	foundschema integer;
BEGIN

	-- Since 7.3 schema support has been added.
	-- Previous postgis versions used to put the database name in
	-- the schema column. This needs to be fixed, so we try to
	-- set the correct schema for each geometry_colums record
	-- looking at table, column, type and srid.
	
	return 'This function is obsolete now that geometry_columns is a view';

END;
$$;


ALTER FUNCTION public.fix_geometry_columns() OWNER TO postgres;

--
-- TOC entry 1306 (class 1255 OID 75091)
-- Name: force_2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_2d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_2d';


ALTER FUNCTION public.force_2d(geometry) OWNER TO postgres;

--
-- TOC entry 1307 (class 1255 OID 75092)
-- Name: force_3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_3d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_3dz';


ALTER FUNCTION public.force_3d(geometry) OWNER TO postgres;

--
-- TOC entry 1308 (class 1255 OID 75093)
-- Name: force_3dm(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_3dm(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_3dm';


ALTER FUNCTION public.force_3dm(geometry) OWNER TO postgres;

--
-- TOC entry 1309 (class 1255 OID 75094)
-- Name: force_3dz(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_3dz(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_3dz';


ALTER FUNCTION public.force_3dz(geometry) OWNER TO postgres;

--
-- TOC entry 1310 (class 1255 OID 75095)
-- Name: force_4d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_4d(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_4d';


ALTER FUNCTION public.force_4d(geometry) OWNER TO postgres;

--
-- TOC entry 1311 (class 1255 OID 75096)
-- Name: force_collection(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION force_collection(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_collection';


ALTER FUNCTION public.force_collection(geometry) OWNER TO postgres;

--
-- TOC entry 1312 (class 1255 OID 75097)
-- Name: forcerhr(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION forcerhr(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_clockwise_poly';


ALTER FUNCTION public.forcerhr(geometry) OWNER TO postgres;

--
-- TOC entry 1314 (class 1255 OID 75099)
-- Name: geomcollfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text) OWNER TO postgres;

--
-- TOC entry 1313 (class 1255 OID 75098)
-- Name: geomcollfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1316 (class 1255 OID 75101)
-- Name: geomcollfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1315 (class 1255 OID 75100)
-- Name: geomcollfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomcollfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromWKB($1, $2)) = 'GEOMETRYCOLLECTION'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.geomcollfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1217 (class 1255 OID 75001)
-- Name: geometryfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometryfromtext(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_from_text';


ALTER FUNCTION public.geometryfromtext(text) OWNER TO postgres;

--
-- TOC entry 1216 (class 1255 OID 75000)
-- Name: geometryfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometryfromtext(text, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_from_text';


ALTER FUNCTION public.geometryfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1317 (class 1255 OID 75102)
-- Name: geometryn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geometryn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_geometryn_collection';


ALTER FUNCTION public.geometryn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1466 (class 1255 OID 74990)
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1)$_$;


ALTER FUNCTION public.geomfromtext(text) OWNER TO postgres;

--
-- TOC entry 1465 (class 1255 OID 74989)
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1, $2)$_$;


ALTER FUNCTION public.geomfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1218 (class 1255 OID 75002)
-- Name: geomfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromwkb(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_from_WKB';


ALTER FUNCTION public.geomfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1219 (class 1255 OID 75003)
-- Name: geomfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SetSRID(ST_GeomFromWKB($1), $2)$_$;


ALTER FUNCTION public.geomfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1318 (class 1255 OID 75103)
-- Name: geomunion(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION geomunion(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'geomunion';


ALTER FUNCTION public.geomunion(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1319 (class 1255 OID 75104)
-- Name: getbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getbbox(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_to_BOX2D';


ALTER FUNCTION public.getbbox(geometry) OWNER TO postgres;

--
-- TOC entry 1215 (class 1255 OID 74999)
-- Name: getsrid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION getsrid(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_get_srid';


ALTER FUNCTION public.getsrid(geometry) OWNER TO postgres;

--
-- TOC entry 1495 (class 1255 OID 116344)
-- Name: gr_open_case(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gr_open_case(schema text) RETURNS text
    LANGUAGE plpgsql
    AS $_$DECLARE
	t_ex integer := 0;
	trg_table character varying;
	src_table character varying;
	src_table_aux character varying;

BEGIN

--	Check schema
	IF (SELECT 1 FROM pg_namespace WHERE nspname = schema) THEN

--		Copy tables
		FOR src_table IN EXECUTE(FORMAT($q$SELECT table_name FROM information_schema.TABLES WHERE table_schema = %s  AND table_type = 'BASE TABLE'$q$,quote_literal(schema)))
		LOOP

--			Table name
			trg_table := 'gisras.' || quote_ident(src_table);


--			Check the table name for raster table
			IF (src_table = 'mdt') THEN
				src_table_aux := quote_ident(schema) || '.' || quote_ident(src_table);
				
--				Delete old mdt table
				DROP TABLE IF EXISTS postgis.mdt;
				EXECUTE(FORMAT($q$CREATE TABLE %s (LIKE %I)$q$,trg_table,src_table_aux));
				EXECUTE 'INSERT INTO ' || trg_table || '(SELECT * FROM ' || quote_ident(src_table_aux) || ')';

			ELSE

				EXECUTE 'DELETE FROM ' || trg_table;
				EXECUTE 'INSERT INTO ' || trg_table || '(SELECT * FROM ' || quote_ident(schema) || '.' || quote_ident(src_table) || ')';

			END IF;

		END LOOP;


	ELSE
		INSERT INTO gisras.error VALUES ('gr_open_case(' || schema || ')', 'Case ' || schema || ' does not exist.',CURRENT_TIMESTAMP);
	END IF;


--	Log
	INSERT INTO gisras.log VALUES ('gr_open_case(' || schema || ')', 'Case ' || schema || ' loaded',CURRENT_TIMESTAMP);	
	RETURN 'gisras case ' || schema || ' load finished'::text;

END;$_$;


ALTER FUNCTION public.gr_open_case(schema text) OWNER TO postgres;

--
-- TOC entry 1214 (class 1255 OID 74998)
-- Name: hasbbox(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION hasbbox(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_hasBBOX';


ALTER FUNCTION public.hasbbox(geometry) OWNER TO postgres;

--
-- TOC entry 1335 (class 1255 OID 75120)
-- Name: interiorringn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION interiorringn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_interiorringn_polygon';


ALTER FUNCTION public.interiorringn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1336 (class 1255 OID 75121)
-- Name: intersection(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intersection(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'intersection';


ALTER FUNCTION public.intersection(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1320 (class 1255 OID 75105)
-- Name: intersects(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION intersects(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'intersects';


ALTER FUNCTION public.intersects(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1337 (class 1255 OID 75122)
-- Name: isclosed(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isclosed(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_isclosed';


ALTER FUNCTION public.isclosed(geometry) OWNER TO postgres;

--
-- TOC entry 1338 (class 1255 OID 75123)
-- Name: isempty(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isempty(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_isempty';


ALTER FUNCTION public.isempty(geometry) OWNER TO postgres;

--
-- TOC entry 1321 (class 1255 OID 75106)
-- Name: isring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isring(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'isring';


ALTER FUNCTION public.isring(geometry) OWNER TO postgres;

--
-- TOC entry 1322 (class 1255 OID 75107)
-- Name: issimple(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION issimple(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'issimple';


ALTER FUNCTION public.issimple(geometry) OWNER TO postgres;

--
-- TOC entry 1339 (class 1255 OID 75124)
-- Name: isvalid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION isvalid(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'isvalid';


ALTER FUNCTION public.isvalid(geometry) OWNER TO postgres;

--
-- TOC entry 1342 (class 1255 OID 75127)
-- Name: length(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_length_linestring';


ALTER FUNCTION public.length(geometry) OWNER TO postgres;

--
-- TOC entry 1341 (class 1255 OID 75126)
-- Name: length2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_length2d_linestring';


ALTER FUNCTION public.length2d(geometry) OWNER TO postgres;

--
-- TOC entry 1324 (class 1255 OID 75109)
-- Name: length2d_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length2d_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'LWGEOM_length2d_ellipsoid';


ALTER FUNCTION public.length2d_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 1340 (class 1255 OID 75125)
-- Name: length3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_length_linestring';


ALTER FUNCTION public.length3d(geometry) OWNER TO postgres;

--
-- TOC entry 1325 (class 1255 OID 75110)
-- Name: length3d_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length3d_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_length_ellipsoid_linestring';


ALTER FUNCTION public.length3d_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 1323 (class 1255 OID 75108)
-- Name: length_spheroid(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION length_spheroid(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'LWGEOM_length_ellipsoid_linestring';


ALTER FUNCTION public.length_spheroid(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 1343 (class 1255 OID 75128)
-- Name: line_interpolate_point(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION line_interpolate_point(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_line_interpolate_point';


ALTER FUNCTION public.line_interpolate_point(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1344 (class 1255 OID 75129)
-- Name: line_locate_point(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION line_locate_point(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_line_locate_point';


ALTER FUNCTION public.line_locate_point(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1345 (class 1255 OID 75130)
-- Name: line_substring(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION line_substring(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_line_substring';


ALTER FUNCTION public.line_substring(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1348 (class 1255 OID 75133)
-- Name: linefrommultipoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefrommultipoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_line_from_mpoint';


ALTER FUNCTION public.linefrommultipoint(geometry) OWNER TO postgres;

--
-- TOC entry 1346 (class 1255 OID 75131)
-- Name: linefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'LINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text) OWNER TO postgres;

--
-- TOC entry 1347 (class 1255 OID 75132)
-- Name: linefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'LINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1350 (class 1255 OID 75135)
-- Name: linefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1349 (class 1255 OID 75134)
-- Name: linefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1326 (class 1255 OID 75111)
-- Name: linemerge(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linemerge(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'linemerge';


ALTER FUNCTION public.linemerge(geometry) OWNER TO postgres;

--
-- TOC entry 1351 (class 1255 OID 75136)
-- Name: linestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1)$_$;


ALTER FUNCTION public.linestringfromtext(text) OWNER TO postgres;

--
-- TOC entry 1352 (class 1255 OID 75137)
-- Name: linestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT LineFromText($1, $2)$_$;


ALTER FUNCTION public.linestringfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1354 (class 1255 OID 75139)
-- Name: linestringfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'LINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1353 (class 1255 OID 75138)
-- Name: linestringfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION linestringfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'LINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.linestringfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1327 (class 1255 OID 75112)
-- Name: locate_along_measure(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION locate_along_measure(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_locate_between_measures($1, $2, $2) $_$;


ALTER FUNCTION public.locate_along_measure(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1355 (class 1255 OID 75140)
-- Name: locate_between_measures(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION locate_between_measures(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_locate_between_m';


ALTER FUNCTION public.locate_between_measures(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1356 (class 1255 OID 75141)
-- Name: m(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION m(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_m_point';


ALTER FUNCTION public.m(geometry) OWNER TO postgres;

--
-- TOC entry 1328 (class 1255 OID 75113)
-- Name: makebox2d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makebox2d(geometry, geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX2D_construct';


ALTER FUNCTION public.makebox2d(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1357 (class 1255 OID 75142)
-- Name: makebox3d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makebox3d(geometry, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_construct';


ALTER FUNCTION public.makebox3d(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1359 (class 1255 OID 75145)
-- Name: makeline(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makeline(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makeline';


ALTER FUNCTION public.makeline(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1358 (class 1255 OID 75143)
-- Name: makeline_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makeline_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makeline_garray';


ALTER FUNCTION public.makeline_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 1360 (class 1255 OID 75146)
-- Name: makepoint(double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepoint(double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makepoint';


ALTER FUNCTION public.makepoint(double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1361 (class 1255 OID 75147)
-- Name: makepoint(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepoint(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makepoint';


ALTER FUNCTION public.makepoint(double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1362 (class 1255 OID 75148)
-- Name: makepoint(double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepoint(double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makepoint';


ALTER FUNCTION public.makepoint(double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1363 (class 1255 OID 75149)
-- Name: makepointm(double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepointm(double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makepoint3dm';


ALTER FUNCTION public.makepointm(double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1330 (class 1255 OID 75115)
-- Name: makepolygon(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepolygon(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makepoly';


ALTER FUNCTION public.makepolygon(geometry) OWNER TO postgres;

--
-- TOC entry 1329 (class 1255 OID 75114)
-- Name: makepolygon(geometry, geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION makepolygon(geometry, geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makepoly';


ALTER FUNCTION public.makepolygon(geometry, geometry[]) OWNER TO postgres;

--
-- TOC entry 1364 (class 1255 OID 75150)
-- Name: max_distance(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION max_distance(geometry, geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_maxdistance2d_linestring';


ALTER FUNCTION public.max_distance(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1365 (class 1255 OID 75151)
-- Name: mem_size(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mem_size(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_mem_size';


ALTER FUNCTION public.mem_size(geometry) OWNER TO postgres;

--
-- TOC entry 1367 (class 1255 OID 75153)
-- Name: mlinefromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTILINESTRING'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text) OWNER TO postgres;

--
-- TOC entry 1366 (class 1255 OID 75152)
-- Name: mlinefromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE
	WHEN geometrytype(GeomFromText($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1369 (class 1255 OID 75155)
-- Name: mlinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1368 (class 1255 OID 75154)
-- Name: mlinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mlinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mlinefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1371 (class 1255 OID 75157)
-- Name: mpointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text) OWNER TO postgres;

--
-- TOC entry 1370 (class 1255 OID 75156)
-- Name: mpointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1,$2)) = 'MULTIPOINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1373 (class 1255 OID 75159)
-- Name: mpointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1372 (class 1255 OID 75158)
-- Name: mpointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1375 (class 1255 OID 75161)
-- Name: mpolyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'MULTIPOLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text) OWNER TO postgres;

--
-- TOC entry 1374 (class 1255 OID 75160)
-- Name: mpolyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1331 (class 1255 OID 75116)
-- Name: mpolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1376 (class 1255 OID 75162)
-- Name: mpolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION mpolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.mpolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1332 (class 1255 OID 75117)
-- Name: multi(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multi(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_force_multi';


ALTER FUNCTION public.multi(geometry) OWNER TO postgres;

--
-- TOC entry 1378 (class 1255 OID 75164)
-- Name: multilinefromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinefromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1377 (class 1255 OID 75163)
-- Name: multilinefromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinefromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTILINESTRING'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multilinefromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1379 (class 1255 OID 75165)
-- Name: multilinestringfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinestringfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_MLineFromText($1)$_$;


ALTER FUNCTION public.multilinestringfromtext(text) OWNER TO postgres;

--
-- TOC entry 1380 (class 1255 OID 75166)
-- Name: multilinestringfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multilinestringfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MLineFromText($1, $2)$_$;


ALTER FUNCTION public.multilinestringfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1381 (class 1255 OID 75167)
-- Name: multipointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1)$_$;


ALTER FUNCTION public.multipointfromtext(text) OWNER TO postgres;

--
-- TOC entry 1382 (class 1255 OID 75168)
-- Name: multipointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPointFromText($1, $2)$_$;


ALTER FUNCTION public.multipointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1384 (class 1255 OID 75170)
-- Name: multipointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1383 (class 1255 OID 75169)
-- Name: multipointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'MULTIPOINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1334 (class 1255 OID 75119)
-- Name: multipolyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1333 (class 1255 OID 75118)
-- Name: multipolyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'MULTIPOLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.multipolyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1386 (class 1255 OID 75172)
-- Name: multipolygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1)$_$;


ALTER FUNCTION public.multipolygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 1385 (class 1255 OID 75171)
-- Name: multipolygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION multipolygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT MPolyFromText($1, $2)$_$;


ALTER FUNCTION public.multipolygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1467 (class 1255 OID 74991)
-- Name: ndims(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ndims(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_ndims';


ALTER FUNCTION public.ndims(geometry) OWNER TO postgres;

--
-- TOC entry 1220 (class 1255 OID 75004)
-- Name: noop(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION noop(geometry) RETURNS geometry
    LANGUAGE c STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_noop';


ALTER FUNCTION public.noop(geometry) OWNER TO postgres;

--
-- TOC entry 1389 (class 1255 OID 75175)
-- Name: npoints(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION npoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_npoints';


ALTER FUNCTION public.npoints(geometry) OWNER TO postgres;

--
-- TOC entry 1390 (class 1255 OID 75176)
-- Name: nrings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION nrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_nrings';


ALTER FUNCTION public.nrings(geometry) OWNER TO postgres;

--
-- TOC entry 1391 (class 1255 OID 75177)
-- Name: numgeometries(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numgeometries(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_numgeometries_collection';


ALTER FUNCTION public.numgeometries(geometry) OWNER TO postgres;

--
-- TOC entry 1387 (class 1255 OID 75173)
-- Name: numinteriorring(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numinteriorring(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_numinteriorrings_polygon';


ALTER FUNCTION public.numinteriorring(geometry) OWNER TO postgres;

--
-- TOC entry 1388 (class 1255 OID 75174)
-- Name: numinteriorrings(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numinteriorrings(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_numinteriorrings_polygon';


ALTER FUNCTION public.numinteriorrings(geometry) OWNER TO postgres;

--
-- TOC entry 1392 (class 1255 OID 75178)
-- Name: numpoints(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION numpoints(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_numpoints_linestring';


ALTER FUNCTION public.numpoints(geometry) OWNER TO postgres;

--
-- TOC entry 1393 (class 1255 OID 75179)
-- Name: overlaps(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION "overlaps"(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'overlaps';


ALTER FUNCTION public."overlaps"(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1395 (class 1255 OID 75181)
-- Name: perimeter2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perimeter2d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_perimeter2d_poly';


ALTER FUNCTION public.perimeter2d(geometry) OWNER TO postgres;

--
-- TOC entry 1394 (class 1255 OID 75180)
-- Name: perimeter3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION perimeter3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_perimeter_poly';


ALTER FUNCTION public.perimeter3d(geometry) OWNER TO postgres;

--
-- TOC entry 1396 (class 1255 OID 75182)
-- Name: point_inside_circle(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION point_inside_circle(geometry, double precision, double precision, double precision) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_inside_circle_point';


ALTER FUNCTION public.point_inside_circle(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1397 (class 1255 OID 75183)
-- Name: pointfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POINT'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text) OWNER TO postgres;

--
-- TOC entry 1398 (class 1255 OID 75184)
-- Name: pointfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POINT'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1399 (class 1255 OID 75185)
-- Name: pointfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POINT'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1400 (class 1255 OID 75186)
-- Name: pointfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(ST_GeomFromWKB($1, $2)) = 'POINT'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.pointfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1401 (class 1255 OID 75187)
-- Name: pointn(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointn(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_pointn_linestring';


ALTER FUNCTION public.pointn(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1402 (class 1255 OID 75188)
-- Name: pointonsurface(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION pointonsurface(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'pointonsurface';


ALTER FUNCTION public.pointonsurface(geometry) OWNER TO postgres;

--
-- TOC entry 1403 (class 1255 OID 75189)
-- Name: polyfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1)) = 'POLYGON'
	THEN GeomFromText($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text) OWNER TO postgres;

--
-- TOC entry 1404 (class 1255 OID 75190)
-- Name: polyfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromText($1, $2)) = 'POLYGON'
	THEN GeomFromText($1,$2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1406 (class 1255 OID 75192)
-- Name: polyfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1405 (class 1255 OID 75191)
-- Name: polyfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polyfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1, $2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polyfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1408 (class 1255 OID 75194)
-- Name: polygonfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromtext(text) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1)$_$;


ALTER FUNCTION public.polygonfromtext(text) OWNER TO postgres;

--
-- TOC entry 1407 (class 1255 OID 75193)
-- Name: polygonfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromtext(text, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT PolyFromText($1, $2)$_$;


ALTER FUNCTION public.polygonfromtext(text, integer) OWNER TO postgres;

--
-- TOC entry 1410 (class 1255 OID 75196)
-- Name: polygonfromwkb(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromwkb(bytea) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1)) = 'POLYGON'
	THEN GeomFromWKB($1)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea) OWNER TO postgres;

--
-- TOC entry 1409 (class 1255 OID 75195)
-- Name: polygonfromwkb(bytea, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonfromwkb(bytea, integer) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
	SELECT CASE WHEN geometrytype(GeomFromWKB($1,$2)) = 'POLYGON'
	THEN GeomFromWKB($1, $2)
	ELSE NULL END
	$_$;


ALTER FUNCTION public.polygonfromwkb(bytea, integer) OWNER TO postgres;

--
-- TOC entry 1411 (class 1255 OID 75197)
-- Name: polygonize_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION polygonize_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'polygonize_garray';


ALTER FUNCTION public.polygonize_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 1244 (class 1255 OID 75028)
-- Name: probe_geometry_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION probe_geometry_columns() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
	inserted integer;
	oldcount integer;
	probed integer;
	stale integer;
BEGIN





	RETURN 'This function is obsolete now that geometry_columns is a view';
END

$$;


ALTER FUNCTION public.probe_geometry_columns() OWNER TO postgres;

--
-- TOC entry 1412 (class 1255 OID 75198)
-- Name: relate(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION relate(geometry, geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'relate_full';


ALTER FUNCTION public.relate(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1413 (class 1255 OID 75199)
-- Name: relate(geometry, geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION relate(geometry, geometry, text) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'relate_pattern';


ALTER FUNCTION public.relate(geometry, geometry, text) OWNER TO postgres;

--
-- TOC entry 1414 (class 1255 OID 75200)
-- Name: removepoint(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION removepoint(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_removepoint';


ALTER FUNCTION public.removepoint(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1242 (class 1255 OID 75026)
-- Name: rename_geometry_table_constraints(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rename_geometry_table_constraints() RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT 'rename_geometry_table_constraint() is obsoleted'::text
$$;


ALTER FUNCTION public.rename_geometry_table_constraints() OWNER TO postgres;

--
-- TOC entry 1415 (class 1255 OID 75201)
-- Name: reverse(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION reverse(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_reverse';


ALTER FUNCTION public.reverse(geometry) OWNER TO postgres;

--
-- TOC entry 1254 (class 1255 OID 75038)
-- Name: rotate(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotate(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_rotateZ($1, $2)$_$;


ALTER FUNCTION public.rotate(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1255 (class 1255 OID 75039)
-- Name: rotatex(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotatex(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1, 1, 0, 0, 0, cos($2), -sin($2), 0, sin($2), cos($2), 0, 0, 0)$_$;


ALTER FUNCTION public.rotatex(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1256 (class 1255 OID 75040)
-- Name: rotatey(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotatey(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  cos($2), 0, sin($2),  0, 1, 0,  -sin($2), 0, cos($2), 0,  0, 0)$_$;


ALTER FUNCTION public.rotatey(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1253 (class 1255 OID 75037)
-- Name: rotatez(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION rotatez(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  cos($2), -sin($2), 0,  sin($2), cos($2), 0,  0, 0, 1,  0, 0, 0)$_$;


ALTER FUNCTION public.rotatez(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1258 (class 1255 OID 75042)
-- Name: scale(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION scale(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_scale($1, $2, $3, 1)$_$;


ALTER FUNCTION public.scale(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1257 (class 1255 OID 75041)
-- Name: scale(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION scale(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $2, 0, 0,  0, $3, 0,  0, 0, $4,  0, 0, 0)$_$;


ALTER FUNCTION public.scale(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1221 (class 1255 OID 75005)
-- Name: se_envelopesintersect(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_envelopesintersect(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ 
	SELECT $1 && $2
	$_$;


ALTER FUNCTION public.se_envelopesintersect(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1222 (class 1255 OID 75006)
-- Name: se_is3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_is3d(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_hasz';


ALTER FUNCTION public.se_is3d(geometry) OWNER TO postgres;

--
-- TOC entry 1223 (class 1255 OID 75007)
-- Name: se_ismeasured(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_ismeasured(geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_hasm';


ALTER FUNCTION public.se_ismeasured(geometry) OWNER TO postgres;

--
-- TOC entry 1227 (class 1255 OID 75011)
-- Name: se_locatealong(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_locatealong(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT SE_LocateBetween($1, $2, $2) $_$;


ALTER FUNCTION public.se_locatealong(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1226 (class 1255 OID 75010)
-- Name: se_locatebetween(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_locatebetween(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_locate_between_m';


ALTER FUNCTION public.se_locatebetween(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1225 (class 1255 OID 75009)
-- Name: se_m(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_m(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_m_point';


ALTER FUNCTION public.se_m(geometry) OWNER TO postgres;

--
-- TOC entry 1224 (class 1255 OID 75008)
-- Name: se_z(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION se_z(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_z_point';


ALTER FUNCTION public.se_z(geometry) OWNER TO postgres;

--
-- TOC entry 1416 (class 1255 OID 75202)
-- Name: segmentize(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION segmentize(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_segmentize2d';


ALTER FUNCTION public.segmentize(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1417 (class 1255 OID 75203)
-- Name: setpoint(geometry, integer, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setpoint(geometry, integer, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_setpoint_linestring';


ALTER FUNCTION public.setpoint(geometry, integer, geometry) OWNER TO postgres;

--
-- TOC entry 1468 (class 1255 OID 74992)
-- Name: setsrid(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION setsrid(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_set_srid';


ALTER FUNCTION public.setsrid(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1418 (class 1255 OID 75204)
-- Name: shift_longitude(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION shift_longitude(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_longitude_shift';


ALTER FUNCTION public.shift_longitude(geometry) OWNER TO postgres;

--
-- TOC entry 1419 (class 1255 OID 75205)
-- Name: simplify(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION simplify(geometry, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_simplify2d';


ALTER FUNCTION public.simplify(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1421 (class 1255 OID 75207)
-- Name: snaptogrid(geometry, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $2)$_$;


ALTER FUNCTION public.snaptogrid(geometry, double precision) OWNER TO postgres;

--
-- TOC entry 1423 (class 1255 OID 75209)
-- Name: snaptogrid(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_SnapToGrid($1, 0, 0, $2, $3)$_$;


ALTER FUNCTION public.snaptogrid(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1420 (class 1255 OID 75206)
-- Name: snaptogrid(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_snaptogrid';


ALTER FUNCTION public.snaptogrid(geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1422 (class 1255 OID 75208)
-- Name: snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_snaptogrid_pointoff';


ALTER FUNCTION public.snaptogrid(geometry, geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1469 (class 1255 OID 74993)
-- Name: srid(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION srid(geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_get_srid';


ALTER FUNCTION public.srid(geometry) OWNER TO postgres;

--
-- TOC entry 1470 (class 1255 OID 74994)
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);$_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO postgres;

--
-- TOC entry 1211 (class 1255 OID 74995)
-- Name: st_astext(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_astext(bytea) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);$_$;


ALTER FUNCTION public.st_astext(bytea) OWNER TO postgres;

--
-- TOC entry 1230 (class 1255 OID 75014)
-- Name: st_box(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box(geometry) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_to_BOX';


ALTER FUNCTION public.st_box(geometry) OWNER TO postgres;

--
-- TOC entry 1233 (class 1255 OID 75017)
-- Name: st_box(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box(box3d) RETURNS box
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_to_BOX';


ALTER FUNCTION public.st_box(box3d) OWNER TO postgres;

--
-- TOC entry 1228 (class 1255 OID 75012)
-- Name: st_box2d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box2d(geometry) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_to_BOX2D';


ALTER FUNCTION public.st_box2d(geometry) OWNER TO postgres;

--
-- TOC entry 1231 (class 1255 OID 75015)
-- Name: st_box2d(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box2d(box3d) RETURNS box2d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_to_BOX2D';


ALTER FUNCTION public.st_box2d(box3d) OWNER TO postgres;

--
-- TOC entry 1229 (class 1255 OID 75013)
-- Name: st_box3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d(geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_to_BOX3D';


ALTER FUNCTION public.st_box3d(geometry) OWNER TO postgres;

--
-- TOC entry 1232 (class 1255 OID 75016)
-- Name: st_box3d(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d(box2d) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX2D_to_BOX3D';


ALTER FUNCTION public.st_box3d(box2d) OWNER TO postgres;

--
-- TOC entry 1240 (class 1255 OID 75024)
-- Name: st_box3d_in(cstring); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d_in(cstring) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_in';


ALTER FUNCTION public.st_box3d_in(cstring) OWNER TO postgres;

--
-- TOC entry 1241 (class 1255 OID 75025)
-- Name: st_box3d_out(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_box3d_out(box3d) RETURNS cstring
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_out';


ALTER FUNCTION public.st_box3d_out(box3d) OWNER TO postgres;

--
-- TOC entry 1239 (class 1255 OID 75023)
-- Name: st_bytea(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_bytea(geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_to_bytea';


ALTER FUNCTION public.st_bytea(geometry) OWNER TO postgres;

--
-- TOC entry 1235 (class 1255 OID 75019)
-- Name: st_geometry(box2d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(box2d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX2D_to_LWGEOM';


ALTER FUNCTION public.st_geometry(box2d) OWNER TO postgres;

--
-- TOC entry 1236 (class 1255 OID 75020)
-- Name: st_geometry(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(box3d) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_to_LWGEOM';


ALTER FUNCTION public.st_geometry(box3d) OWNER TO postgres;

--
-- TOC entry 1237 (class 1255 OID 75021)
-- Name: st_geometry(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(text) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'parse_WKT_lwgeom';


ALTER FUNCTION public.st_geometry(text) OWNER TO postgres;

--
-- TOC entry 1238 (class 1255 OID 75022)
-- Name: st_geometry(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry(bytea) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_from_bytea';


ALTER FUNCTION public.st_geometry(bytea) OWNER TO postgres;

--
-- TOC entry 1250 (class 1255 OID 75034)
-- Name: st_geometry_cmp(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_cmp(geometry, geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'lwgeom_cmp';


ALTER FUNCTION public.st_geometry_cmp(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1249 (class 1255 OID 75033)
-- Name: st_geometry_eq(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_eq(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'lwgeom_eq';


ALTER FUNCTION public.st_geometry_eq(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1248 (class 1255 OID 75032)
-- Name: st_geometry_ge(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_ge(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'lwgeom_ge';


ALTER FUNCTION public.st_geometry_ge(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1247 (class 1255 OID 75031)
-- Name: st_geometry_gt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_gt(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'lwgeom_gt';


ALTER FUNCTION public.st_geometry_gt(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1246 (class 1255 OID 75030)
-- Name: st_geometry_le(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_le(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'lwgeom_le';


ALTER FUNCTION public.st_geometry_le(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1245 (class 1255 OID 75029)
-- Name: st_geometry_lt(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_geometry_lt(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'lwgeom_lt';


ALTER FUNCTION public.st_geometry_lt(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1448 (class 1255 OID 75238)
-- Name: st_length3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_length_linestring';


ALTER FUNCTION public.st_length3d(geometry) OWNER TO postgres;

--
-- TOC entry 1449 (class 1255 OID 75239)
-- Name: st_length_spheroid3d(geometry, spheroid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_length_spheroid3d(geometry, spheroid) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'LWGEOM_length_ellipsoid_linestring';


ALTER FUNCTION public.st_length_spheroid3d(geometry, spheroid) OWNER TO postgres;

--
-- TOC entry 1451 (class 1255 OID 75241)
-- Name: st_makebox3d(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makebox3d(geometry, geometry) RETURNS box3d
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_construct';


ALTER FUNCTION public.st_makebox3d(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1424 (class 1255 OID 75210)
-- Name: st_makeline_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_makeline_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_makeline_garray';


ALTER FUNCTION public.st_makeline_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 1450 (class 1255 OID 75240)
-- Name: st_perimeter3d(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_perimeter3d(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_perimeter_poly';


ALTER FUNCTION public.st_perimeter3d(geometry) OWNER TO postgres;

--
-- TOC entry 1445 (class 1255 OID 75232)
-- Name: st_polygonize_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_polygonize_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT COST 100
    AS '$libdir/postgis-2.0', 'polygonize_garray';


ALTER FUNCTION public.st_polygonize_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 1234 (class 1255 OID 75018)
-- Name: st_text(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_text(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_to_text';


ALTER FUNCTION public.st_text(geometry) OWNER TO postgres;

--
-- TOC entry 1446 (class 1255 OID 75233)
-- Name: st_unite_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION st_unite_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'pgis_union_geometry_array';


ALTER FUNCTION public.st_unite_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 1425 (class 1255 OID 75211)
-- Name: startpoint(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION startpoint(geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_startpoint_linestring';


ALTER FUNCTION public.startpoint(geometry) OWNER TO postgres;

--
-- TOC entry 1428 (class 1255 OID 75214)
-- Name: summary(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION summary(geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_summary';


ALTER FUNCTION public.summary(geometry) OWNER TO postgres;

--
-- TOC entry 1426 (class 1255 OID 75212)
-- Name: symdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION symdifference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'symdifference';


ALTER FUNCTION public.symdifference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1427 (class 1255 OID 75213)
-- Name: symmetricdifference(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION symmetricdifference(geometry, geometry) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'symdifference';


ALTER FUNCTION public.symmetricdifference(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1430 (class 1255 OID 75216)
-- Name: touches(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION touches(geometry, geometry) RETURNS boolean
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'touches';


ALTER FUNCTION public.touches(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1429 (class 1255 OID 75215)
-- Name: transform(geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION transform(geometry, integer) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'transform';


ALTER FUNCTION public.transform(geometry, integer) OWNER TO postgres;

--
-- TOC entry 1260 (class 1255 OID 75044)
-- Name: translate(geometry, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION translate(geometry, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_translate($1, $2, $3, 0)$_$;


ALTER FUNCTION public.translate(geometry, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1259 (class 1255 OID 75043)
-- Name: translate(geometry, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION translate(geometry, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1, 1, 0, 0, 0, 1, 0, 0, 0, 1, $2, $3, $4)$_$;


ALTER FUNCTION public.translate(geometry, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1261 (class 1255 OID 75045)
-- Name: transscale(geometry, double precision, double precision, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION transscale(geometry, double precision, double precision, double precision, double precision) RETURNS geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT st_affine($1,  $4, 0, 0,  0, $5, 0,
		0, 0, 1,  $2 * $4, $3 * $5, 0)$_$;


ALTER FUNCTION public.transscale(geometry, double precision, double precision, double precision, double precision) OWNER TO postgres;

--
-- TOC entry 1447 (class 1255 OID 75234)
-- Name: unite_garray(geometry[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION unite_garray(geometry[]) RETURNS geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'pgis_union_geometry_array';


ALTER FUNCTION public.unite_garray(geometry[]) OWNER TO postgres;

--
-- TOC entry 1431 (class 1255 OID 75217)
-- Name: within(geometry, geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION within(geometry, geometry) RETURNS boolean
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_Within($1, $2)$_$;


ALTER FUNCTION public.within(geometry, geometry) OWNER TO postgres;

--
-- TOC entry 1432 (class 1255 OID 75218)
-- Name: x(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION x(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_x_point';


ALTER FUNCTION public.x(geometry) OWNER TO postgres;

--
-- TOC entry 1433 (class 1255 OID 75219)
-- Name: xmax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_xmax';


ALTER FUNCTION public.xmax(box3d) OWNER TO postgres;

--
-- TOC entry 1434 (class 1255 OID 75220)
-- Name: xmin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION xmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_xmin';


ALTER FUNCTION public.xmin(box3d) OWNER TO postgres;

--
-- TOC entry 1435 (class 1255 OID 75221)
-- Name: y(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION y(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_y_point';


ALTER FUNCTION public.y(geometry) OWNER TO postgres;

--
-- TOC entry 1436 (class 1255 OID 75222)
-- Name: ymax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ymax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_ymax';


ALTER FUNCTION public.ymax(box3d) OWNER TO postgres;

--
-- TOC entry 1437 (class 1255 OID 75223)
-- Name: ymin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION ymin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_ymin';


ALTER FUNCTION public.ymin(box3d) OWNER TO postgres;

--
-- TOC entry 1438 (class 1255 OID 75224)
-- Name: z(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION z(geometry) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_z_point';


ALTER FUNCTION public.z(geometry) OWNER TO postgres;

--
-- TOC entry 1439 (class 1255 OID 75225)
-- Name: zmax(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION zmax(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_zmax';


ALTER FUNCTION public.zmax(box3d) OWNER TO postgres;

--
-- TOC entry 1441 (class 1255 OID 75227)
-- Name: zmflag(geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION zmflag(geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'LWGEOM_zmflag';


ALTER FUNCTION public.zmflag(geometry) OWNER TO postgres;

--
-- TOC entry 1440 (class 1255 OID 75226)
-- Name: zmin(box3d); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION zmin(box3d) RETURNS double precision
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-2.0', 'BOX3D_zmin';


ALTER FUNCTION public.zmin(box3d) OWNER TO postgres;

--
-- TOC entry 2029 (class 1255 OID 75228)
-- Name: accum(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE accum(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_accum_finalfn
);


ALTER AGGREGATE public.accum(geometry) OWNER TO postgres;

--
-- TOC entry 2027 (class 1255 OID 75086)
-- Name: extent(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE extent(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d,
    FINALFUNC = public.box2d
);


ALTER AGGREGATE public.extent(geometry) OWNER TO postgres;

--
-- TOC entry 2030 (class 1255 OID 75235)
-- Name: extent3d(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE extent3d(geometry) (
    SFUNC = public.combine_bbox,
    STYPE = box3d
);


ALTER AGGREGATE public.extent3d(geometry) OWNER TO postgres;

--
-- TOC entry 2028 (class 1255 OID 75144)
-- Name: makeline(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE makeline(geometry) (
    SFUNC = pgis_geometry_accum_transfn,
    STYPE = pgis_abs,
    FINALFUNC = pgis_geometry_makeline_finalfn
);


ALTER AGGREGATE public.makeline(geometry) OWNER TO postgres;

--
-- TOC entry 2031 (class 1255 OID 75236)
-- Name: memcollect(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE memcollect(geometry) (
    SFUNC = public.st_collect,
    STYPE = geometry
);


ALTER AGGREGATE public.memcollect(geometry) OWNER TO postgres;

--
-- TOC entry 2032 (class 1255 OID 75237)
-- Name: memgeomunion(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE memgeomunion(geometry) (
    SFUNC = geomunion,
    STYPE = geometry
);


ALTER AGGREGATE public.memgeomunion(geometry) OWNER TO postgres;

--
-- TOC entry 2033 (class 1255 OID 75242)
-- Name: st_extent3d(geometry); Type: AGGREGATE; Schema: public; Owner: postgres
--

CREATE AGGREGATE st_extent3d(geometry) (
    SFUNC = public.st_combine_bbox,
    STYPE = box3d
);


ALTER AGGREGATE public.st_extent3d(geometry) OWNER TO postgres;

SET search_path = gisras, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 216 (class 1259 OID 83783)
-- Name: IneffAreas; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE "IneffAreas" (
    gid integer NOT NULL,
    "Shape_Leng" double precision,
    "Shape_Area" double precision,
    "HydroID" integer,
    geom public.geometry(Polygon)
);


ALTER TABLE gisras."IneffAreas" OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 83781)
-- Name: IneffAreas_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE "IneffAreas_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras."IneffAreas_gid_seq" OWNER TO postgres;

--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 215
-- Name: IneffAreas_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE "IneffAreas_gid_seq" OWNED BY "IneffAreas".gid;


--
-- TOC entry 214 (class 1259 OID 83775)
-- Name: nodestable_objectid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE nodestable_objectid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.nodestable_objectid_seq OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 83752)
-- Name: IneffectivePositions; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE "IneffectivePositions" (
    "OBJECTID" integer DEFAULT nextval('nodestable_objectid_seq'::regclass) NOT NULL,
    "XS2DID" integer,
    "IA2DID" integer,
    "BegFrac" double precision,
    "EndFrac" double precision,
    "BegElev" double precision,
    "EndElev" double precision,
    "UserElev" double precision
);


ALTER TABLE gisras."IneffectivePositions" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 83747)
-- Name: LUManning; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE "LUManning" (
    "OBJECTID" integer DEFAULT nextval('nodestable_objectid_seq'::regclass) NOT NULL,
    "LUCode" character varying(32),
    "N_Value" double precision
);


ALTER TABLE gisras."LUManning" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 83794)
-- Name: LandUse; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE "LandUse" (
    gid integer NOT NULL,
    "Shape_Leng" double precision,
    "Shape_Area" double precision,
    "LUCode" character varying(32),
    "N_Value" double precision,
    "OBJECTID" integer,
    "LUCode_1" character varying(32),
    "N_Value_1" double precision,
    geom public.geometry(Polygon)
);


ALTER TABLE gisras."LandUse" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 83792)
-- Name: LandUse_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE "LandUse_gid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras."LandUse_gid_seq" OWNER TO postgres;

--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 217
-- Name: LandUse_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE "LandUse_gid_seq" OWNED BY "LandUse".gid;


--
-- TOC entry 212 (class 1259 OID 83762)
-- Name: Manning; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE "Manning" (
    "OBJECTID" integer DEFAULT nextval('nodestable_objectid_seq'::regclass) NOT NULL,
    "XS2DID" integer,
    "Fraction" double precision,
    "N_Value" double precision
);


ALTER TABLE gisras."Manning" OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 83757)
-- Name: NodesTable; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE "NodesTable" (
    "OBJECTID" integer DEFAULT nextval('nodestable_objectid_seq'::regclass) NOT NULL,
    "NodeID" integer,
    "X" double precision,
    "Y" double precision,
    "Z" double precision,
    geom public.geometry(Point),
    numarcs integer
);


ALTER TABLE gisras."NodesTable" OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 83767)
-- Name: hydroid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE hydroid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.hydroid_seq OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 83605)
-- Name: banks; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE banks (
    gid integer NOT NULL,
    shape_leng numeric,
    hydroid integer DEFAULT nextval('hydroid_seq'::regclass) NOT NULL,
    geom public.geometry(MultiLineString)
);


ALTER TABLE gisras.banks OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 83611)
-- Name: banks_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE banks_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.banks_gid_seq OWNER TO postgres;

--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 190
-- Name: banks_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE banks_gid_seq OWNED BY banks.gid;


--
-- TOC entry 191 (class 1259 OID 83613)
-- Name: error; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE error (
    "Process" character varying,
    error character varying,
    "time" timestamp with time zone
);


ALTER TABLE gisras.error OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 83619)
-- Name: flowpaths; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE flowpaths (
    gid integer NOT NULL,
    shape_leng numeric,
    linetype character varying(7),
    geom public.geometry(MultiLineString)
);


ALTER TABLE gisras.flowpaths OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 83625)
-- Name: flowpaths_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE flowpaths_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.flowpaths_gid_seq OWNER TO postgres;

--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 193
-- Name: flowpaths_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE flowpaths_gid_seq OWNED BY flowpaths.gid;


--
-- TOC entry 194 (class 1259 OID 83627)
-- Name: log; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE log (
    "Process" character varying,
    message character varying,
    "time" timestamp with time zone
);


ALTER TABLE gisras.log OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 140921)
-- Name: mdt; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE mdt (
    rid integer NOT NULL,
    rast public.raster,
    filename text,
    CONSTRAINT enforce_height_rast CHECK ((public.st_height(rast) = 100)),
    CONSTRAINT enforce_max_extent_rast CHECK (public.st_coveredby(public.st_convexhull(rast), '01030000000100000005000000000000003A3A1D410000006073A55141000000003A3A1D4100000060FDA75141000000006A641D4100000060FDA75141000000006A641D410000006073A55141000000003A3A1D410000006073A55141'::public.geometry)),
    CONSTRAINT enforce_num_bands_rast CHECK ((public.st_numbands(rast) = 1)),
    CONSTRAINT enforce_out_db_rast CHECK ((public._raster_constraint_out_db(rast) = '{f}'::boolean[])),
    CONSTRAINT enforce_pixel_types_rast CHECK ((public._raster_constraint_pixel_types(rast) = '{32BF}'::text[])),
    CONSTRAINT enforce_same_alignment_rast CHECK (public.st_samealignment(rast, '0100000000000000000000F03F000000000000F0BF000000003A3A1D4100000060FDA75141000000000000000000000000000000000000000001000100'::public.raster)),
    CONSTRAINT enforce_scalex_rast CHECK (((public.st_scalex(rast))::numeric(16,10) = (1)::numeric(16,10))),
    CONSTRAINT enforce_scaley_rast CHECK (((public.st_scaley(rast))::numeric(16,10) = ((-1))::numeric(16,10))),
    CONSTRAINT enforce_srid_rast CHECK ((public.st_srid(rast) = 0)),
    CONSTRAINT enforce_width_rast CHECK ((public.st_width(rast) = 100))
);


ALTER TABLE gisras.mdt OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 140919)
-- Name: mdt_rid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE mdt_rid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.mdt_rid_seq OWNER TO postgres;

--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 219
-- Name: mdt_rid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE mdt_rid_seq OWNED BY mdt.rid;


--
-- TOC entry 195 (class 1259 OID 83651)
-- Name: outfile; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE outfile (
    "Text" character varying,
    index integer NOT NULL
);


ALTER TABLE gisras.outfile OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 83657)
-- Name: outfile_index_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE outfile_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.outfile_index_seq OWNER TO postgres;

--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 196
-- Name: outfile_index_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE outfile_index_seq OWNED BY outfile.index;


--
-- TOC entry 197 (class 1259 OID 83659)
-- Name: river; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE river (
    gid integer NOT NULL,
    shape_leng numeric,
    hydroid integer DEFAULT nextval('hydroid_seq'::regclass) NOT NULL,
    rivercode character varying(16),
    reachcode character varying(16),
    fromnode smallint,
    tonode smallint,
    arclength double precision,
    fromsta double precision,
    tosta double precision,
    geom public.geometry(MultiLineString)
);


ALTER TABLE gisras.river OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 83665)
-- Name: river3d; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE river3d (
    gid integer NOT NULL,
    shape_leng numeric,
    riv2did integer,
    hydroid integer DEFAULT nextval('hydroid_seq'::regclass) NOT NULL,
    rivercode character varying(16),
    reachcode character varying(16),
    fromnode smallint,
    tonode smallint,
    arclength double precision,
    fromsta double precision,
    tosta double precision,
    geom public.geometry(MultiLineStringZ)
);


ALTER TABLE gisras.river3d OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 83671)
-- Name: river3d_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE river3d_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.river3d_gid_seq OWNER TO postgres;

--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 199
-- Name: river3d_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE river3d_gid_seq OWNED BY river3d.gid;


--
-- TOC entry 200 (class 1259 OID 83673)
-- Name: river_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE river_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.river_gid_seq OWNER TO postgres;

--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 200
-- Name: river_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE river_gid_seq OWNED BY river.gid;


--
-- TOC entry 201 (class 1259 OID 83675)
-- Name: view_banks; Type: VIEW; Schema: gisras; Owner: postgres
--

CREATE VIEW view_banks AS
    SELECT banks.gid, banks.geom FROM banks;


ALTER TABLE gisras.view_banks OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 83679)
-- Name: view_flowpaths; Type: VIEW; Schema: gisras; Owner: postgres
--

CREATE VIEW view_flowpaths AS
    SELECT flowpaths.gid, flowpaths.linetype, flowpaths.geom FROM flowpaths;


ALTER TABLE gisras.view_flowpaths OWNER TO postgres;

--
-- TOC entry 203 (class 1259 OID 83683)
-- Name: view_river; Type: VIEW; Schema: gisras; Owner: postgres
--

CREATE VIEW view_river AS
    SELECT river.gid, river.rivercode, river.reachcode, river.geom FROM river;


ALTER TABLE gisras.view_river OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 83687)
-- Name: xscutlines; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE xscutlines (
    gid integer NOT NULL,
    shape_leng numeric,
    hydroid integer DEFAULT nextval('hydroid_seq'::regclass) NOT NULL,
    profilem double precision,
    rivercode character varying(16),
    reachcode character varying(16),
    leftbank double precision,
    rightbank double precision,
    llength double precision,
    chlength double precision,
    rlength double precision,
    nodename character varying(32),
    geom public.geometry(MultiLineString)
);


ALTER TABLE gisras.xscutlines OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 83693)
-- Name: view_xscutlines; Type: VIEW; Schema: gisras; Owner: postgres
--

CREATE VIEW view_xscutlines AS
    SELECT xscutlines.gid, xscutlines.nodename, xscutlines.geom FROM xscutlines;


ALTER TABLE gisras.view_xscutlines OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 83697)
-- Name: xscutlines3d; Type: TABLE; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE TABLE xscutlines3d (
    gid integer NOT NULL,
    shape_leng numeric,
    xs2did integer,
    hydroid integer DEFAULT nextval('hydroid_seq'::regclass) NOT NULL,
    profilem double precision,
    rivercode character varying(16),
    reachcode character varying(16),
    leftbank double precision,
    rightbank double precision,
    llength double precision,
    chlength double precision,
    rlength double precision,
    nodename character varying(32),
    geom public.geometry(MultiLineStringZ)
);


ALTER TABLE gisras.xscutlines3d OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 83703)
-- Name: xscutlines3d_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE xscutlines3d_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.xscutlines3d_gid_seq OWNER TO postgres;

--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 207
-- Name: xscutlines3d_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE xscutlines3d_gid_seq OWNED BY xscutlines3d.gid;


--
-- TOC entry 208 (class 1259 OID 83705)
-- Name: xscutlines_gid_seq; Type: SEQUENCE; Schema: gisras; Owner: postgres
--

CREATE SEQUENCE xscutlines_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE gisras.xscutlines_gid_seq OWNER TO postgres;

--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 208
-- Name: xscutlines_gid_seq; Type: SEQUENCE OWNED BY; Schema: gisras; Owner: postgres
--

ALTER SEQUENCE xscutlines_gid_seq OWNED BY xscutlines.gid;


--
-- TOC entry 3542 (class 2604 OID 142893)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY "IneffAreas" ALTER COLUMN gid SET DEFAULT nextval('"IneffAreas_gid_seq"'::regclass);


--
-- TOC entry 3543 (class 2604 OID 142894)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY "LandUse" ALTER COLUMN gid SET DEFAULT nextval('"LandUse_gid_seq"'::regclass);


--
-- TOC entry 3527 (class 2604 OID 142895)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY banks ALTER COLUMN gid SET DEFAULT nextval('banks_gid_seq'::regclass);


--
-- TOC entry 3528 (class 2604 OID 142896)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY flowpaths ALTER COLUMN gid SET DEFAULT nextval('flowpaths_gid_seq'::regclass);


--
-- TOC entry 3544 (class 2604 OID 142897)
-- Name: rid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY mdt ALTER COLUMN rid SET DEFAULT nextval('mdt_rid_seq'::regclass);


--
-- TOC entry 3529 (class 2604 OID 142898)
-- Name: index; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY outfile ALTER COLUMN index SET DEFAULT nextval('outfile_index_seq'::regclass);


--
-- TOC entry 3531 (class 2604 OID 142899)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY river ALTER COLUMN gid SET DEFAULT nextval('river_gid_seq'::regclass);


--
-- TOC entry 3533 (class 2604 OID 142900)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY river3d ALTER COLUMN gid SET DEFAULT nextval('river3d_gid_seq'::regclass);


--
-- TOC entry 3535 (class 2604 OID 142901)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY xscutlines ALTER COLUMN gid SET DEFAULT nextval('xscutlines_gid_seq'::regclass);


--
-- TOC entry 3537 (class 2604 OID 142902)
-- Name: gid; Type: DEFAULT; Schema: gisras; Owner: postgres
--

ALTER TABLE ONLY xscutlines3d ALTER COLUMN gid SET DEFAULT nextval('xscutlines3d_gid_seq'::regclass);


--
-- TOC entry 3621 (class 0 OID 83783)
-- Dependencies: 216
-- Data for Name: IneffAreas; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY "IneffAreas" (gid, "Shape_Leng", "Shape_Area", "HydroID", geom) FROM stdin;
\.


--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 215
-- Name: IneffAreas_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('"IneffAreas_gid_seq"', 3, true);


--
-- TOC entry 3615 (class 0 OID 83752)
-- Dependencies: 210
-- Data for Name: IneffectivePositions; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY "IneffectivePositions" ("OBJECTID", "XS2DID", "IA2DID", "BegFrac", "EndFrac", "BegElev", "EndElev", "UserElev") FROM stdin;
\.


--
-- TOC entry 3614 (class 0 OID 83747)
-- Dependencies: 209
-- Data for Name: LUManning; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY "LUManning" ("OBJECTID", "LUCode", "N_Value") FROM stdin;
\.


--
-- TOC entry 3623 (class 0 OID 83794)
-- Dependencies: 218
-- Data for Name: LandUse; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY "LandUse" (gid, "Shape_Leng", "Shape_Area", "LUCode", "N_Value", "OBJECTID", "LUCode_1", "N_Value_1", geom) FROM stdin;
\.


--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 217
-- Name: LandUse_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('"LandUse_gid_seq"', 4, true);


--
-- TOC entry 3617 (class 0 OID 83762)
-- Dependencies: 212
-- Data for Name: Manning; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY "Manning" ("OBJECTID", "XS2DID", "Fraction", "N_Value") FROM stdin;
\.


--
-- TOC entry 3616 (class 0 OID 83757)
-- Dependencies: 211
-- Data for Name: NodesTable; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY "NodesTable" ("OBJECTID", "NodeID", "X", "Y", "Z", geom, numarcs) FROM stdin;
\.


--
-- TOC entry 3598 (class 0 OID 83605)
-- Dependencies: 189
-- Data for Name: banks; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY banks (gid, shape_leng, hydroid, geom) FROM stdin;
\.


--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 190
-- Name: banks_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('banks_gid_seq', 38, true);


--
-- TOC entry 3600 (class 0 OID 83613)
-- Dependencies: 191
-- Data for Name: error; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY error ("Process", error, "time") FROM stdin;
\.


--
-- TOC entry 3601 (class 0 OID 83619)
-- Dependencies: 192
-- Data for Name: flowpaths; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY flowpaths (gid, shape_leng, linetype, geom) FROM stdin;
\.


--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 193
-- Name: flowpaths_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('flowpaths_gid_seq', 67, true);


--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 213
-- Name: hydroid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('hydroid_seq', 298, true);


--
-- TOC entry 3603 (class 0 OID 83627)
-- Dependencies: 194
-- Data for Name: log; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY log ("Process", message, "time") FROM stdin;
gr_init()	Gisras empty schema	2013-11-25 10:22:10.815+01
gr_init()	Gisras empty schema	2013-11-25 10:22:10.815+01
gr_init()	Gisras empty schema	2013-11-25 10:22:10.815+01
gr_init()	Gisras empty schema	2013-11-25 10:22:10.815+01
\.


--
-- TOC entry 3625 (class 0 OID 140921)
-- Dependencies: 220
-- Data for Name: mdt; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY mdt (rid, rast, filename) FROM stdin;
\.


--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 219
-- Name: mdt_rid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('mdt_rid_seq', 702, true);


--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 214
-- Name: nodestable_objectid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('nodestable_objectid_seq', 355, true);


--
-- TOC entry 3604 (class 0 OID 83651)
-- Dependencies: 195
-- Data for Name: outfile; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY outfile ("Text", index) FROM stdin;
\.


--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 196
-- Name: outfile_index_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('outfile_index_seq', 305497, true);


--
-- TOC entry 3606 (class 0 OID 83659)
-- Dependencies: 197
-- Data for Name: river; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY river (gid, shape_leng, hydroid, rivercode, reachcode, fromnode, tonode, arclength, fromsta, tosta, geom) FROM stdin;
\.


--
-- TOC entry 3607 (class 0 OID 83665)
-- Dependencies: 198
-- Data for Name: river3d; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY river3d (gid, shape_leng, riv2did, hydroid, rivercode, reachcode, fromnode, tonode, arclength, fromsta, tosta, geom) FROM stdin;
\.


--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 199
-- Name: river3d_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('river3d_gid_seq', 214, true);


--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 200
-- Name: river_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('river_gid_seq', 275, true);


--
-- TOC entry 3610 (class 0 OID 83687)
-- Dependencies: 204
-- Data for Name: xscutlines; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY xscutlines (gid, shape_leng, hydroid, profilem, rivercode, reachcode, leftbank, rightbank, llength, chlength, rlength, nodename, geom) FROM stdin;
\.


--
-- TOC entry 3611 (class 0 OID 83697)
-- Dependencies: 206
-- Data for Name: xscutlines3d; Type: TABLE DATA; Schema: gisras; Owner: postgres
--

COPY xscutlines3d (gid, shape_leng, xs2did, hydroid, profilem, rivercode, reachcode, leftbank, rightbank, llength, chlength, rlength, nodename, geom) FROM stdin;
\.


--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 207
-- Name: xscutlines3d_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('xscutlines3d_gid_seq', 759, true);


--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 208
-- Name: xscutlines_gid_seq; Type: SEQUENCE SET; Schema: gisras; Owner: postgres
--

SELECT pg_catalog.setval('xscutlines_gid_seq', 167, true);


SET search_path = public, pg_catalog;

--
-- TOC entry 3521 (class 0 OID 16634)
-- Dependencies: 171
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


SET search_path = topology, pg_catalog;

--
-- TOC entry 3520 (class 0 OID 17526)
-- Dependencies: 185
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- TOC entry 3519 (class 0 OID 17513)
-- Dependencies: 184
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology (id, name, srid, "precision", hasz) FROM stdin;
\.


SET search_path = gisras, pg_catalog;

--
-- TOC entry 3584 (class 2606 OID 83788)
-- Name: IneffAreas_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "IneffAreas"
    ADD CONSTRAINT "IneffAreas_pkey" PRIMARY KEY (gid);


--
-- TOC entry 3578 (class 2606 OID 83756)
-- Name: IneffectivePositions_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "IneffectivePositions"
    ADD CONSTRAINT "IneffectivePositions_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3576 (class 2606 OID 83751)
-- Name: LUManning_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "LUManning"
    ADD CONSTRAINT "LUManning_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3586 (class 2606 OID 83799)
-- Name: LandUse_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "LandUse"
    ADD CONSTRAINT "LandUse_pkey" PRIMARY KEY (gid);


--
-- TOC entry 3582 (class 2606 OID 83766)
-- Name: Manning_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "Manning"
    ADD CONSTRAINT "Manning_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3580 (class 2606 OID 83761)
-- Name: NodesTable_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY "NodesTable"
    ADD CONSTRAINT "NodesTable_pkey" PRIMARY KEY ("OBJECTID");


--
-- TOC entry 3557 (class 2606 OID 83716)
-- Name: banks_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY banks
    ADD CONSTRAINT banks_pkey PRIMARY KEY (gid);


--
-- TOC entry 3560 (class 2606 OID 83718)
-- Name: flowpaths_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY flowpaths
    ADD CONSTRAINT flowpaths_pkey PRIMARY KEY (gid);


--
-- TOC entry 3588 (class 2606 OID 140929)
-- Name: mdt_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mdt
    ADD CONSTRAINT mdt_pkey PRIMARY KEY (rid);


--
-- TOC entry 3562 (class 2606 OID 83722)
-- Name: outfile_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY outfile
    ADD CONSTRAINT outfile_pkey PRIMARY KEY (index);


--
-- TOC entry 3568 (class 2606 OID 83724)
-- Name: river3d_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY river3d
    ADD CONSTRAINT river3d_pkey PRIMARY KEY (gid);


--
-- TOC entry 3565 (class 2606 OID 83726)
-- Name: river_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY river
    ADD CONSTRAINT river_pkey PRIMARY KEY (gid);


--
-- TOC entry 3574 (class 2606 OID 83728)
-- Name: xscutlines3d_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY xscutlines3d
    ADD CONSTRAINT xscutlines3d_pkey PRIMARY KEY (gid);


--
-- TOC entry 3571 (class 2606 OID 83730)
-- Name: xscutlines_pkey; Type: CONSTRAINT; Schema: gisras; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY xscutlines
    ADD CONSTRAINT xscutlines_pkey PRIMARY KEY (gid);


--
-- TOC entry 3555 (class 1259 OID 83731)
-- Name: banks_geom_gist; Type: INDEX; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE INDEX banks_geom_gist ON banks USING gist (geom);


--
-- TOC entry 3558 (class 1259 OID 83732)
-- Name: flowpaths_geom_gist; Type: INDEX; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE INDEX flowpaths_geom_gist ON flowpaths USING gist (geom);


--
-- TOC entry 3589 (class 1259 OID 141278)
-- Name: mdt_rast_gist; Type: INDEX; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE INDEX mdt_rast_gist ON mdt USING gist (public.st_convexhull(rast));


--
-- TOC entry 3566 (class 1259 OID 83734)
-- Name: river3d_geom_gist; Type: INDEX; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE INDEX river3d_geom_gist ON river3d USING gist (geom);


--
-- TOC entry 3563 (class 1259 OID 83735)
-- Name: river_geom_gist; Type: INDEX; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE INDEX river_geom_gist ON river USING gist (geom);


--
-- TOC entry 3572 (class 1259 OID 83736)
-- Name: xscutlines3d_geom_gist; Type: INDEX; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE INDEX xscutlines3d_geom_gist ON xscutlines3d USING gist (geom);


--
-- TOC entry 3569 (class 1259 OID 83737)
-- Name: xscutlines_geom_gist; Type: INDEX; Schema: gisras; Owner: postgres; Tablespace: 
--

CREATE INDEX xscutlines_geom_gist ON xscutlines USING gist (geom);


SET search_path = public, pg_catalog;

--
-- TOC entry 3512 (class 2618 OID 17051)
-- Name: geometry_columns_delete; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE geometry_columns_delete AS ON DELETE TO geometry_columns DO INSTEAD NOTHING;


--
-- TOC entry 3510 (class 2618 OID 17049)
-- Name: geometry_columns_insert; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE geometry_columns_insert AS ON INSERT TO geometry_columns DO INSTEAD NOTHING;


--
-- TOC entry 3511 (class 2618 OID 17050)
-- Name: geometry_columns_update; Type: RULE; Schema: public; Owner: postgres
--

CREATE RULE geometry_columns_update AS ON UPDATE TO geometry_columns DO INSTEAD NOTHING;


SET search_path = gisras, pg_catalog;

--
-- TOC entry 3592 (class 2620 OID 96467)
-- Name: gr_delete_river_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_delete_river_trigger BEFORE DELETE ON river FOR EACH ROW EXECUTE PROCEDURE gr_topology_delete_river();


--
-- TOC entry 3590 (class 2620 OID 96465)
-- Name: gr_insert_river_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_insert_river_trigger BEFORE INSERT ON river FOR EACH ROW EXECUTE PROCEDURE gr_topology_insert_river();


--
-- TOC entry 3593 (class 2620 OID 83738)
-- Name: gr_update_banks_view_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_update_banks_view_trigger INSTEAD OF INSERT OR DELETE OR UPDATE ON view_banks FOR EACH ROW EXECUTE PROCEDURE gr_update_banks_view();


--
-- TOC entry 3594 (class 2620 OID 83739)
-- Name: gr_update_flowpaths_view_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_update_flowpaths_view_trigger INSTEAD OF INSERT OR DELETE OR UPDATE ON view_flowpaths FOR EACH ROW EXECUTE PROCEDURE gr_update_flowpaths_view();


--
-- TOC entry 3597 (class 2620 OID 96479)
-- Name: gr_update_nodestable_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_update_nodestable_trigger BEFORE INSERT OR UPDATE ON "NodesTable" FOR EACH ROW EXECUTE PROCEDURE gr_update_nodestable();


--
-- TOC entry 3591 (class 2620 OID 96466)
-- Name: gr_update_river_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_update_river_trigger BEFORE UPDATE ON river FOR EACH ROW EXECUTE PROCEDURE gr_topology_update_river();


--
-- TOC entry 3595 (class 2620 OID 83740)
-- Name: gr_update_river_view_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_update_river_view_trigger INSTEAD OF INSERT OR DELETE OR UPDATE ON view_river FOR EACH ROW EXECUTE PROCEDURE gr_update_river_view();


--
-- TOC entry 3596 (class 2620 OID 83741)
-- Name: gr_update_xscutlines_view_trigger; Type: TRIGGER; Schema: gisras; Owner: postgres
--

CREATE TRIGGER gr_update_xscutlines_view_trigger INSTEAD OF INSERT OR DELETE OR UPDATE ON view_xscutlines FOR EACH ROW EXECUTE PROCEDURE gr_update_xscutlines_view();


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 8
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 203
-- Name: view_river; Type: ACL; Schema: gisras; Owner: postgres
--

REVOKE ALL ON TABLE view_river FROM PUBLIC;
REVOKE ALL ON TABLE view_river FROM postgres;
GRANT ALL ON TABLE view_river TO postgres;
GRANT ALL ON TABLE view_river TO PUBLIC;


-- Completed on 2013-11-25 11:11:51

--
-- PostgreSQL database dump complete
--

