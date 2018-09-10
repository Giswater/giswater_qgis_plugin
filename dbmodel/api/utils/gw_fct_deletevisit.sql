/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_deletevisit"(visit_id int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

    res_delete boolean;
    api_version json;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;    
    
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


--    Get parameter id
    EXECUTE 'SELECT EXISTS(SELECT 1 FROM om_visit WHERE id = $1)'
    USING visit_id
    INTO res_delete;

--    Return
    IF res_delete THEN

        EXECUTE 'DELETE FROM om_visit WHERE id = $1'
            USING visit_id;

        RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;
    ELSE
        RETURN ('{"status":"Failed","message":"visit_id ' || visit_id || ' does not exist", "apiVersion":'|| api_version ||'}')::json;
    END IF;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

