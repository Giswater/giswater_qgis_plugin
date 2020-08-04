/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2992

CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_setmincut_end"(p_data json)
RETURNS pg_catalog.json AS $BODY$

DECLARE
v_mincut_id int4;
v_insert_data json;
v_feature_type varchar;
v_feature_id varchar;
v_version json;
    
BEGIN

	--  set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

	--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	--  get input parameters
	v_mincut_id := (p_data ->> 'data')::json->> 'mincutId';
	v_insert_data := (p_data ->> 'data')::json->> 'insertData';
	v_feature_type := (p_data ->> 'data')::json->> 'featureType';
	v_feature_id := (p_data ->> 'data')::json->> 'featureId';

	--  update values
    UPDATE om_mincut SET mincut_state=2 WHERE id=v_mincut_id;
    UPDATE om_mincut SET exec_end=now() WHERE id=v_mincut_id;

	--  update the value of the state
    v_insert_data := gw_fct_json_object_set_key(v_insert_data, 'mincut_state',2);

	--  call for update values (in case of exists)
    PERFORM SCHEMA_NAME.gw_fct_upsertmincut(v_mincut_id, null::float, null::float, null::integer, p_device, v_insert_data, v_feature_type, v_feature_id);

	--  Return
    RETURN  SCHEMA_NAME.gw_fct_getmincut(null, null, null, v_mincut_id::integer, p_device, v_feature_type, 'lang');

	--  Exception handling
    EXCEPTION WHEN OTHERS THEN 
    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

