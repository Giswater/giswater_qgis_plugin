/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_setvalveunaccess"(node_id_var varchar, result_id_var int4, p_device int4) RETURNS pg_catalog.json AS $BODY$

DECLARE 
feature_id_aux text;
feature_type_aux text;
api_version json;

BEGIN 
    -- set search_path
    SET search_path= 'SCHEMA_NAME','public';

    --  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


    --  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

    SELECT anl_feature_id INTO feature_id_aux FROM anl_mincut_result_cat WHERE id=result_id_var::integer;
    SELECT anl_feature_type INTO feature_type_aux FROM anl_mincut_result_cat WHERE id=result_id_var::integer;
    
    -- Computing process
      IF (SELECT node_id FROM anl_mincut_result_valve_unaccess WHERE node_id=node_id_var and result_id=result_id_var::integer) IS NULL THEN
        INSERT INTO anl_mincut_result_valve_unaccess (result_id, node_id) VALUES (result_id_var::integer, node_id_var);
    ELSE
        DELETE FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_var::integer AND node_id=node_id_var;
    END IF;

    PERFORM gw_fct_mincut(feature_id_aux, feature_type_aux, result_id_var::integer);
       
        
-- Return
     RETURN SCHEMA_NAME.gw_fct_getmincut(null, null, null, result_id_var::integer, p_device, 'arc', 'lang');

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

                  

    
END;  
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

