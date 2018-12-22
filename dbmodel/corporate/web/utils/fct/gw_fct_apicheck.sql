/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_apicheck"() RETURNS pg_catalog.json AS $BODY$
DECLARE

    api_version json;
    v_result json;
    v_count integer=0;
    v_gid integer;


BEGIN

--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;  
      
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;


RAISE NOTICE 'count: % gw_fct_deleteevent', v_count;    v_count=v_count+1;
    SELECT id FROM SCHEMA_NAME.om_visit_event LIMIT 1 into v_gid;
    PERFORM SCHEMA_NAME.gw_fct_deleteevent (v_gid);
        
       

RAISE NOTICE 'count: % gw_fct_getinfofromcoordinates', v_count;    v_count=v_count+1;
    
    -- NODE
    PERFORM gw_fct_getinfofromcoordinates (419098.0,4576635.7,25831,'v_edit_connec',
    '{"v_edit_connec","v_edit_arc","v_edit_node"}','{"v_edit_man_junction,"v_edit_man_pipe","v_edit_man_wjoin"}',3, 0, NULL );

    -- CONNEC
    PERFORM gw_fct_getinfofromcoordinates (418483.1,4577866.7,25831,'v_edit_connec',
    '{"v_edit_connec","v_edit_arc","v_edit_node"}','{"v_edit_man_junction,"v_edit_man_pipe","v_edit_man_wjoin"}',3, 0, NULL );

    -- ARC
    PERFORM gw_fct_getinfofromcoordinates (419148.5,4576625.2,25831,'v_edit_connec',
    '{"v_edit_connec","v_edit_arc","v_edit_node"}','{"v_edit_man_junction,"v_edit_man_pipe","v_edit_man_wjoin"}',3, 0, NULL );

    -- WORKCAT
    PERFORM gw_fct_getinfofromcoordinates (418918.3,4576842,25831,'v_edit_connec',
    '{"v_ui_workcat_polygon"}','{"v_edit_man_junction,"v_edit_man_pipe","v_edit_man_wjoin"}' ,3, 0, NULL );







--  return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;

--  Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","apiVersion":'|| api_version ||'}')::json;

END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

