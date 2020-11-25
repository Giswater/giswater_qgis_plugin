/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 3014


CREATE OR REPLACE FUNCTION gw_fct_setmapzone(p_data json)
  RETURNS json AS
$BODY$


/*EXAMPLE

SELECT gw_fct_setmapzone($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"featureType":"TANK", "id":"113766"}, 
"data":{"filterFields":{}, "pageInfo":{},"parameters":{"arcId":"113906","mapzoneId":"2"}}}$$)::text;

SELECT gw_fct_setmapzone($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"featureType":"SHUTOFF_VALVE", "id":"1115"}, 
"data":{"filterFields":{}, "pageInfo":{},"parameters":{"arcId":"11","mapzoneId":"2"}}}$$)::text;

-- fid: 

*/

DECLARE
v_result text;
v_version text;
v_mapzone_type text;
v_mapzone_type text;
v_name text;
v_expl_id text;
v_descript integer;
v_link_id integer;
v_stylesheet_id integer;



v_feature_id text;
v_arc_id text;
v_systype text;
v_epatype text;
v_grafdelim text;
v_config json;
v_mapzone_id integer;
v_arc_array text[];
v_mapzone_array text[];
rec text;
v_check_grafconfig text;
v_query TEXT;
BEGIN

--  Set search path to local schema
    SET search_path = ws_sample34, public;

    -- select version
    SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

    v_mapzone_type := json_extract_path_text (p_data,'data','parameters','Type')::text;

    EXECUTE 'INSERT INTO '||v_mapzone_type||' (name, expl_id, descript, link, stylesheet)'

    SELECT upper(type), upper(graf_delimiter)  INTO v_systype, v_grafdelim FROM cat_feature_node WHERE id = v_mapzone_type;
    SELECT upper(epa_type) INTO v_epatype FROM node WHERE node_id = v_feature_id;

    
    --    Control nulls
    v_result := COALESCE(v_result, '[]'); 
    --mandar en return el id de dma / presszone igual como en getinfofromcoord;
    --  Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{"result":' || v_result ||
                 '}'||
               '}'||
    '}')::json;

    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;