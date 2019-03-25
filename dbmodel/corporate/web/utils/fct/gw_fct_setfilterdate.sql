/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- Function: SCHEMA_NAME.gw_fct_setfilterdate(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_setfilterdate(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setfilterdate(json_dates json)
  RETURNS json AS
$BODY$
DECLARE

--    Variables
    event_id integer;
    existing_record integer;
    api_version text;
    from_date_value date;
    to_date_value date;

BEGIN


--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

    --  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


--  Get values from json
    from_date_value:= json_dates->>'from_date';
    to_date_value:= json_dates->>'to_date';

--      Check exists and set
    EXECUTE format('SELECT COUNT(*) FROM selector_date WHERE cur_user = current_user')
    INTO existing_record;
    
    IF existing_record THEN

        EXECUTE format('UPDATE selector_date SET from_date = $1, to_date = $2 WHERE cur_user = current_user') 
        USING from_date_value, to_date_value;

    ELSE
        EXECUTE format('INSERT INTO selector_date (from_date, to_date, cur_user) VALUES ($1, $2, current_user)') 
        USING from_date_value, to_date_value;
    END IF;
    
  --Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;    


--    Exception handling
    --EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
