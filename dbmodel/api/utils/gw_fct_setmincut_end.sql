/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_setmincut_end"(p_mincut_id int4, p_insert_data json, p_element_type varchar, p_id varchar, p_device int4) RETURNS pg_catalog.json AS $BODY$

DECLARE
api_version json;

    
BEGIN

--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--  Update values
    UPDATE anl_mincut_result_cat SET mincut_state=2 WHERE id=p_mincut_id;
    UPDATE anl_mincut_result_cat SET exec_end=now() WHERE id=p_mincut_id;


--  Call for update values (in case of exists)
    PERFORM SCHEMA_NAME.gw_fct_upsertmincut(p_mincut_id, null::float, null::float, null::integer, p_device, p_insert_data, p_element_type, p_id);

--  Return
    RETURN  SCHEMA_NAME.gw_fct_getmincut(null, null, null, p_mincut_id::integer, p_device, p_element_type, 'lang');



--  Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

