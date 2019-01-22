﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2630


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getgeometry(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getgeometry($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"arc", "tableName":"v_edit_arc", "id":"2001"},
"data":{}}$$)


*/

DECLARE
	v_apiversion text;
	v_schemaname text;
	v_projecttype varchar;
	v_id text;
	v_tablename text;
	v_idname text;
	v_feature json;
	v_columntype text;
	v_geometry text;
	v_the_geom text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

	-- get project type
	SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

	--  get parameters from input
	v_id = ((p_data ->>'feature')::json->>'id')::integer;
	v_tablename = ((p_data ->>'feature')::json->>'tableName')::varchar;
	v_idname = ((p_data ->>'feature')::json->>'idName')::integer;
	v_feature = (p_data ->>'feature');

	
	--  get id column
	EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING v_tablename;
	
	IF v_idname ISNULL THEN
        EXECUTE '
        SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
        AND t.relname = $1 
        AND s.nspname = $2
        ORDER BY a.attnum LIMIT 1'
        INTO v_idname
        USING v_tablename, v_schemaname;
    END IF;

    -- get id column type
    EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
	JOIN pg_class t on a.attrelid = t.oid
	JOIN pg_namespace s on t.relnamespace = s.oid
	WHERE a.attnum > 0 
	AND NOT a.attisdropped
	AND a.attname = $3
	AND t.relname = $2 
	AND s.nspname = $1
	ORDER BY a.attnum'
		USING v_schemaname, v_tablename, v_idname
		INTO v_columntype;

	-- get geometry_column
    EXECUTE 'SELECT attname FROM pg_attribute a        
        JOIN pg_class t on a.attrelid = t.oid
        JOIN pg_namespace s on t.relnamespace = s.oid
        WHERE a.attnum > 0 
        AND NOT a.attisdropped
        AND t.relname = $1
        AND s.nspname = $2
        AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
        ORDER BY a.attnum' 
        INTO v_the_geom
        USING v_tablename, v_schemaname;
           
	-- get geometry
	IF v_the_geom IS NOT NULL THEN
		EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText('||v_the_geom||') FROM '||v_tablename||' WHERE '||v_idname||' = CAST('||quote_nullable(v_id)||' AS '||v_columntype||'))row'
		INTO v_geometry;
	END IF;
	
	-- Control NULL's
	v_apiversion := COALESCE(v_apiversion, '{}');
	v_feature := COALESCE(v_feature, '{}');
	v_geometry := COALESCE(v_geometry, '');

  
	-- Return
	RETURN ('{"status":"Accepted", "message":{"priority":0, "text":"This is a test message"}, "apiVersion":'||v_apiversion||
             ',"body":{"feature":'||v_feature||
					 ',"data":{"geometry":"'||v_geometry||'}}"'||
	    '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
