/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3016

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getidsfrompolygon(p_data json)
RETURNS json AS
$BODY$

/* example
SELECT SCHEMA_NAME.gw_fct_getidsfrompolygon($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{},
		"feature":{"featureType":"node"},
		"data":{"activeLayer":"ve_node",
			"visibleLayer":["v_edit_node","ve_node_junction"],
		"geometry":"POLYGON((418859 4576751, 419277 4576751, 419275 4576531, 418859 4576532, 418859 4576751))"}}$$)
*/

DECLARE
v_featuretype text;
v_geometry text;
v_epsg integer;
v_polygon public.geometry;
v_idname text;
v_layer text;
v_geometrytype text;
v_result text;
v_errcontext text;
v_version text;
v_visiblelayer text;
v_parent text;
v_sql text;
v_layers text;
v_ids text;
v_return text;


BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_featuretype = ((p_data ->> 'feature')::json->>'featureType');
	v_geometry = (p_data ->> 'data')::json->> 'geometry';
	v_visiblelayer = (p_data ->> 'data')::json->> 'visibleLayer';

	-- get system variables
	v_epsg := (SELECT epsg FROM sys_version LIMIT 1);
	v_version := (SELECT giswater FROM sys_version LIMIT 1);
	
	-- post-procesed variables
	SELECT ST_GeomFromText(v_geometry, v_epsg) INTO v_polygon;
	v_idname =  concat(v_featuretype, '_id');
	v_parent = concat('v_edit_',v_featuretype);

	--  Harmonize v_visiblelayer
	v_visiblelayer = concat('{',substring((v_visiblelayer) from 2 for LENGTH(v_visiblelayer)));
	v_visiblelayer = concat('}',substring(reverse(v_visiblelayer) from 2 for LENGTH(v_visiblelayer)));
	v_visiblelayer := reverse(v_visiblelayer);


	-- look for parent
	v_sql = 'SELECT DISTINCT parent_layer FROM cat_feature WHERE parent_layer = any('||quote_literal(v_visiblelayer)||') AND parent_layer = '||quote_literal(v_parent)||';';

	EXECUTE v_sql
	INTO v_layers;

	-- look for childs when parent result is none
	IF v_layers IS NULL THEN
		v_sql = 'SELECT child_layer FROM cat_feature WHERE child_layer = any('||quote_literal(v_visiblelayer)||') AND parent_layer = '||quote_literal(v_parent)||';';
	END IF;

	FOR v_layer IN EXECUTE v_sql
	LOOP
		EXECUTE 'SELECT array_agg('||v_idname||') FROM '||v_layer||' WHERE st_contains($1, '||v_layer||'.the_geom)'
		INTO v_ids
		USING v_polygon;

		-- parse array
		v_ids = replace (v_ids,'{', '');
		v_ids = replace (v_ids,'}', '');
		
		-- build return
		v_result = concat('{"tableName":"',v_layer,'", "ids":[',v_ids,']},');
		v_return = concat(v_return, v_result);

	END LOOP;

	-- parse return
	v_return = concat('[',v_return);
	v_return = concat(']',substring(reverse(v_return) from 2 for LENGTH(v_return)));
	v_return := reverse(v_return);
	v_return := COALESCE(v_return, '[]'); 

	-- return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Selection done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":'||v_return||
		       '}'||
	    '}')::json, 2436);
	
	-- exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_errcontext) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;