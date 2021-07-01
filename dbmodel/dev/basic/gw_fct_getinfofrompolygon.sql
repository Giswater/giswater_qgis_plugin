CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeaturesfrompolygon(p_data json)
RETURNS json AS
$BODY$

/* example
SELECT SCHEMA_NAME.gw_fct_getfeaturesfrompolygon($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{},
		"feature":{"featureType":"arc"},
		"data":{"activeLayer":"ve_node",
			"visibleLayer":["ve_node","ve_arc"],
			"addSchema":"ud",
			"infoType":"full",
			"projecRole":"role_admin",
			"geometry":"POLYGON((418859 4576751, 419277 4576751, 419275 4576531, 418859 4576532, 418859 4576751))",
			"zoomRatio":1000}}$$)
*/

DECLARE
v_featuretype text;
v_geometry text;
v_zoomratio double precision;
v_epsg integer;
v_polygon public.geometry;
v_idname text;
v_layer text;
v_geometrytype text;
v_result json;
v_errcontext text;
v_version text;

BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	v_featuretype = ((p_data ->> 'feature')::json->>'featureType');
	v_geometry = (p_data ->> 'data')::json->> 'geometry';
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';

	-- get system variables
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_version := (SELECT giswater FROM sys_version ORDER BY id DESC LIMIT 1);
	
	-- post-procesed variables
	SELECT ST_GeomFromText(v_geometry, v_epsg) INTO v_polygon;
	v_idname =  concat(v_featuretype, '_id');
	v_layer = concat('v_edit_',v_featuretype);
	IF v_layer = 'v_edit_arc'  THEN
		v_geometrytype = 'LineString';
	ELSE 
		v_geometrytype = 'Point';
	END IF;


	-- calculate response json
	v_result = null;
	EXECUTE'
	SELECT jsonb_agg(features.feature) 
	FROM (
	SELECT json_build_object
	(''type'', ''Feature'',
	''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
	''properties'', to_jsonb(row) - ''the_geom'') as feature
	FROM (SELECT '||v_idname||', the_geom FROM '||v_layer||' WHERE st_contains($1, '||v_layer||'.the_geom))row)features'
	INTO v_result
	USING v_polygon;
	
	v_result = concat ('{"geometryType":"',v_geometrytype,'", "features":',v_result,'}');
	v_result := COALESCE(v_result, '{}'); 
	
	-- return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Selection done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":'||v_result||
		       '}'||
	    '}')::json, 2436, null, null, null);
	
	-- exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_errcontext) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;