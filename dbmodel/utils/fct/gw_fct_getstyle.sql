/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 3220


-- DROP FUNCTION SCHEMA_NAME.gw_fct_getstyle(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getstyle(p_data json)
  RETURNS json AS
$BODY$

/*
    SELECT SCHEMA_NAME.gw_fct_getstyle($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
        "data":{"filterFields":{}, "pageInfo":{}, "style_id": "106"}}$$);

    SELECT SCHEMA_NAME.gw_fct_getstyle($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
        "data":{"filterFields":{}, "pageInfo":{}, "layername": "v_edit_node"}}$$);
*/

DECLARE
v_return json;
v_style_id text;
v_layername text;
v_styles json;
v_version json;
v_error_context text;



BEGIN

    -- Search path
    SET search_path = 'SCHEMA_NAME', public;

    -- Get input variables
    v_style_id = (p_data -> 'data' ->> 'style_id')::text;
    v_layername = (p_data -> 'data' ->> 'layername')::text;

    IF v_style_id IS NOT NULL THEN
        -- If style_id is provided, get the style directly
        v_styles := jsonb_object_agg(stylecat_id::text, stylevalue) FROM (
            SELECT stylecat_id, stylevalue
            FROM sys_style
            WHERE id::text = v_style_id::text AND active IS TRUE
        ) sub;
    ELSIF v_layername IS NOT NULL THEN
        -- If layername is provided, get all styles for that layer
        v_styles := jsonb_object_agg(idval::text, stylevalue) FROM (
            SELECT c.idval, stylevalue
            FROM sys_style s
            JOIN cat_style c ON s.stylecat_id = c.id
            WHERE s.idval = v_layername AND s.active IS TRUE
        ) sub;
    ELSE
        -- If neither style_id nor layername is provided, return an empty JSON object
        v_styles := '{}'::jsonb;
    END IF;

    -- Ensure version and return JSON are initialized
    v_version := COALESCE(v_version, '{}');
    v_styles := COALESCE(v_styles, '{}');

    -- Return the final JSON structure
    v_return = ('{"status":"Accepted", "message":{"level":1, "text":"Executed successfully"}, "version":"'||v_version||'"'||
        ',"body":{"form":{}'||
        ',"data":{}'||
        ',"styles":'||v_styles||''||
    '}}')::json;
    RETURN v_return;

    -- Exception handling
    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
    RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;