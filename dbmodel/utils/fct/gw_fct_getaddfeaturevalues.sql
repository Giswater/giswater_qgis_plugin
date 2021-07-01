-- Function: SCHEMA_NAME.gw_fct_getaddfeaturevalues(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getaddfeaturevalues(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getaddfeaturevalues(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getaddfeaturevalues ($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{}, "feature":{"featureType":""}, 
"data":{"filterFields":{}, "pageInfo":{}}}$$)::text

-- fid: 3028

*/

DECLARE

v_version text;
v_projectype text;
v_error_context text;
v_result_array json[];
v_result json;


BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Select version
	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;

		-- Get values
	EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (SELECT * FROM cat_feature WHERE active IS TRUE ORDER BY id) a'
	INTO v_result_array;
	
	v_result := array_to_json(v_result_array);
	
	

	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "values":'||v_result||'}}'||
	    '}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

