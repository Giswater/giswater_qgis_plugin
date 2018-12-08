/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

CREATE OR REPLACE FUNCTION ws_sample.gw_api_getattributetable(p_data json)  RETURNS json AS
$BODY$

/*EXAMPLE:
-- attribute table using custom filters
SELECT ws_sample.gw_api_getattributetable($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe", "idName":"arc_id"},
"data":{"filterFields":{"arccat_id":"PVC160-PN16", "limit":5},
    "pageInfo":{"orderby":"arc_id", "orderType":"DESC", "limit":"10", "offsset":"10", "pageNumber":3}}}$$)

-- attribute table using canvas filter
SELECT ws_sample.gw_api_getattributetable($${ "client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"tableName":"v_edit_man_pipe", "idName":"arc_id"},
"data":{"filterFields":{"arccat_id":null, "limit":null},
    "canvasExtend":{"x1coord":1,"y1coord":1,"x2coord":999999,"y2coord":9999999},
    "pageInfo":{"orderby":"arc_id", "orderType":"DESC", "offsset":"10", "pageNumber":3}}}$$)
*/

DECLARE
	v_formactions json;
	v_form json;
	v_body json;
	v_return json;

BEGIN

-- Set search path to local schema
    SET search_path = "ws_sample", public;

--  Creating the form actions  
   	v_formactions = '[{"actionName":"actionZoom","actionTooltip":"Zoom"},{"actionName":"actionSelect","actionTooltip":"Select"}
			,{"actionName":"actionLink","actionTooltip":"Link"},{"actionName":"actionDelete","actionTooltip":"Delete"}]';

    SELECT gw_api_getlist (p_data) INTO v_return;

--  setting the formactions
    v_form = gw_fct_json_object_set_key(((v_return->>'body')::json->>'form')::json, 'formActions', v_formactions);
    v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'form', v_form);
    v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
   
--    Return
    RETURN v_return;
       
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
