/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE:2966

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setprofile(p_data json)
  RETURNS json AS
$BODY$
DECLARE

/*

SELECT "SCHEMA_NAME".gw_fct_setprofile($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"profile_id":"1", "initNode":116, "endNode":111, "listArcs":"{133,134,135,136,137}", "linksDistance":1, "legendFactor":1, "papersize":{"id":0, "customDim":{"xdim":300, "ydim":100}}, "title":"Title", "date":"15/6/20", "scale":{"scaleToFit":"False", "eh":2000, "ev":500}}}$$)

SELECT "SCHEMA_NAME".gw_fct_setprofile($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"profile_id":"1",} "action":"delete"}$$)
*/


--    Variables
    schemas_array name[];
    v_version text;
    v_fields json [];
    v_device integer;
    v_profile text;
    v_profile_id text;
    v_init_node integer;
    v_end_node integer;
    v_message text;
    v_list_arcs text;
    v_arc_id text;
    v_linksDistance float;
    v_legendFactor integer;
    v_papersize_id integer;
    v_papersize_xdim integer;
    v_papersize_ydim integer;
    v_title text;
    v_date text;
    v_scaletofit boolean;
    v_scale_eh integer;
    v_scale_ev integer;
    v_values text;
    v_action text;


BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get json parameters
	v_device := ((p_data ->>'client')::json->>'device')::text;
	v_profile_id := ((p_data ->>'data')::json->>'profile_id')::text;
	v_init_node := ((p_data ->>'data')::json->>'initNode')::text;
	v_end_node := ((p_data ->>'data')::json->>'endNode')::text;
	v_list_arcs := ((p_data ->>'data')::json->>'listArcs')::text;
	v_linksDistance := ((p_data ->>'data')::json->>'linksDistance')::integer;
	v_legendFactor := ((p_data ->>'data')::json->>'legendFactor')::integer;
	v_papersize_id := (((p_data ->>'data')::json->>'papersize')::json->>'id')::integer;
	v_papersize_xdim := ((((p_data ->>'data')::json->>'papersize')::json->>'customDim')::json->>'xdim')::integer;
	v_papersize_ydim := ((((p_data ->>'data')::json->>'papersize')::json->>'customDim')::json->>'ydim')::integer;
	v_title := ((p_data ->>'data')::json->>'title')::text;
	v_date := ((p_data ->>'data')::json->>'date')::text;
	v_scaletofit := (((p_data ->>'data')::json->>'scale')::json->>'scaleToFit')::boolean;
	v_scale_eh := (((p_data ->>'data')::json->>'scale')::json->>'eh')::integer;
	v_scale_ev := (((p_data ->>'data')::json->>'scale')::json->>'ev')::integer;
	v_action := ((p_data ->>'data')::json->>'action')::text;


	-- Get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;


	IF v_action = 'delete' THEN
		EXECUTE 'DELETE FROM om_profile WHERE profile_id = ''' || v_profile_id ||'''';
		v_message := 'Profile deleted';
	ELSE
		-- Check if id of profile already exists in DB
		EXECUTE 'SELECT DISTINCT(profile_id) FROM om_profile WHERE profile_id = ''' || v_profile_id || '''::text' INTO v_profile;
		IF v_profile IS NULL THEN
			-- Populate values
			v_values = '{"initNode":'||v_init_node||', "endNode":'||v_end_node||', "listArcs":"'||COALESCE(v_list_arcs, '[]')||'","linksDistance":'||COALESCE(v_linksDistance::text, '""')||', "legendFactor":'||COALESCE(v_legendFactor::text, '""')||', "papersize":{"id":'||COALESCE(v_papersize_id::text, '""')||', "customDim":{"xdim":'||COALESCE(v_papersize_xdim::text, '""')||', "ydim":'||COALESCE(v_papersize_ydim::text, '""')||'}}, "title":"'||COALESCE(v_title, '""')||'","date":"'||COALESCE(v_date::text, '""')||'", "scale":{"scaleToFit":'||COALESCE(v_scaletofit::text, '""')||', "eh":'||COALESCE(v_scale_eh::text,'""')||', "ev":'||COALESCE(v_scale_ev::text, '""')||'}}';
			EXECUTE 'INSERT INTO om_profile (profile_id, values) VALUES ('''||v_profile_id||''', '''||v_values||''')';

			v_message := 'Values has been updated';
		ELSE
			v_message := 'Selected ''profile_id'' already exist in database';
		END IF;
	END IF;

	-- Check null
	v_version := COALESCE(v_version, '');
	v_fields := COALESCE(v_fields, '{}');

	--    Return
	RETURN ('{"status":"Accepted", "message":"'||v_message||'", "version":' || v_version ||
	      ',"body":{"data":{}'||
			'}'||
		'}')::json;

	--    Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;