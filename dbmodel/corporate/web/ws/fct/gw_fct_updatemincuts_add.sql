/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_updatemincuts_add"(search_data json) RETURNS pg_catalog.json AS 
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_updatemincuts_add($${"tabName":"on_going","mincut_muni":{"id":"1","name":"Sant Boi del Llobregat"},"mincut_class":{"id":"1","name":"Corte de red"},"mincut_workorder":{"text":"cal"}}$$) AS result
*/

DECLARE

--    Variables
    response_json json;
    v_tabname varchar;
    api_version json;
    v_muni varchar;
    v_class varchar;
    v_state int2;
    v_search text;
    v_query_text text;
    v_temp json;
    


BEGIN

--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--  Get values
    v_tabname := search_data->>'tabName';
   
    v_temp := search_data->'mincut_muni';
    v_muni := v_temp->>'id';
    

    v_temp := search_data->'mincut_class';
    v_class := v_temp->>'id';
    
    v_temp := search_data->'mincut_workorder';
    v_search := v_temp->>'text';


--  Add state filter
    v_state = NULL;
    IF v_tabname = 'planified' THEN
        v_state = 0;
    ELSIF v_tabname = 'on_going' THEN
        v_state = 1;
    ELSIF v_tabname = 'executed' THEN
        v_state = 2;
    END IF;

-- Searh query
    v_query_text = 'SELECT array_to_json(array_agg(row_to_json(a))) 
	FROM (SELECT * FROM (SELECT 
	(CASE WHEN work_order IS NULL THEN concat (a.id::text,''-'',ext_streetaxis.name) ELSE concat (a.id::text,''-'',a.work_order,''-'',ext_streetaxis.name) END) 
	as display_name, st_x(anl_the_geom) as sys_x, st_y(anl_the_geom) as sys_y, (SELECT concat(''EPSG:'',epsg) FROM version LIMIT 1) AS srid FROM anl_mincut_result_cat a
	JOIN ext_municipality USING (muni_id)
	LEFT JOIN ext_streetaxis ON (streetaxis_id = ext_streetaxis.id)    
	WHERE mincut_state='||v_state|| ' AND mincut_class='||v_class||' AND ext_municipality.muni_id= '||v_muni||')b WHERE display_name ILIKE ''%'||v_search||'%'' LIMIT 10 
    )a';

    raise notice 'v_query_text %', v_query_text;

    EXECUTE v_query_text INTO response_json;

--  Control NULL's
    response_json := COALESCE(response_json, '{}');

--  Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "data":' || response_json ||    
        '}')::json;

--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

