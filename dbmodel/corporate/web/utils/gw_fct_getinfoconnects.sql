/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- Function: SCHEMA_NAME.gw_fct_getinfoconnects(character varying, character varying, integer)


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfoconnects(
    v_element_type character varying,
    v_id character varying,
    device integer)
  RETURNS json AS
$BODY$
DECLARE

/*EXAMPLE QUERYS
SELECT SCHEMA_NAME.gw_fct_getinfoconnects('node', '1007', 3)
SELECT SCHEMA_NAME.gw_fct_getinfoconnects('arc', '2001', 3)
*/

--    Variables
    query_result character varying;
    query_result_connects json;
    query_result_node_1 json;
    query_result_node_2 json;
    query_result_upstream json;
    query_result_downstream json;
    exec_sql text;
    api_version json;
    v_downstream_label text;
    v_upstream_label text;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    
--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--  Armonize element type
     v_element_type := lower (v_element_type);
     IF RIGHT (v_element_type,1)=':' THEN
            v_element_type := reverse(substring(reverse(v_element_type) from 2 for 99));
     END IF;

--    Query depends on element type
    IF v_element_type = 'arc' THEN

--        Get label
--	Label is used from what is called on the geinfofromid method. Only for nodes label is called from this method

--        Get query for connects
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''arc_x_connect'' AND device = $1'
            INTO query_result
            USING device;

            raise notice 'query_result %', query_result;

--        Get connects
        EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE arc_id::text = $1::text) a'
            INTO query_result_connects
            USING v_id, v_element_type;

            raise notice 'query_result_connects %', query_result_connects;
            raise notice 'v_id %', v_id;
            raise notice 'v_element_type %', v_element_type;


--        Get node_1
        EXECUTE 'SELECT row_to_json(a) FROM (SELECT node_1 AS sys_id, ''v_edit_node'' as sys_table_id, ''node_id'' as sys_idname FROM arc JOIN node ON (node_1 = node_id) WHERE arc.arc_id::text = $1) a'
            INTO query_result_node_1
            USING v_id;

--        Get node_2
        EXECUTE 'SELECT row_to_json(a) FROM (SELECT node_2 AS sys_id,  ''v_edit_node'' as sys_table_id, ''node_id'' as sys_idname FROM arc JOIN node ON (node_2 = node_id) WHERE arc.arc_id::text = $1) a'
            INTO query_result_node_2
            USING v_id;

--        Control NULL's
        query_result_connects := COALESCE(query_result_connects, '{}');
        query_result_node_1 := COALESCE(query_result_node_1, '{}');
        query_result_node_2 := COALESCE(query_result_node_2, '{}');
    
--        Return
        RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "table":' || query_result_connects || ', "node1":'|| query_result_node_1 || ', "node2":'|| query_result_node_2 ||'}')::json;

    ELSE
   
--        Get label
	SELECT  trim(both '{}' from tabtext[2:2]::text) INTO v_upstream_label FROM (select tabtext::text[] from config_web_tabs where tablabel='Connect' 
	and substring (tabtext from 3 for 4)='node' limit 1)a;
	SELECT  trim(both '{}' from tabtext[3:3]::text) INTO v_downstream_label FROM (select tabtext::text[] from config_web_tabs where tablabel='Connect'
	and substring (tabtext from 3 for 4)='node' limit 1)a;

--      Get query for connects upstream
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''node_x_connect_upstream'' AND device = $1'
            INTO query_result
            USING device;
--      Get connects upstream
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE node_id::text = $1) a'
		INTO query_result_upstream
		USING v_id;

--      Get query for connects downstream
        EXECUTE 'SELECT query_text FROM config_web_forms WHERE table_id = ''node_x_connect_downstream'' AND device = $1'
            INTO query_result
            USING device;
--        Get connects downstream
       EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (' || query_result || ' WHERE node_id::text = $1) a'
		INTO query_result_downstream
		USING v_id;       
    END IF;

--        Control NULL's
        query_result_upstream := COALESCE(query_result_upstream, '{}');
        v_upstream_label := COALESCE(v_upstream_label, '{}');
        v_downstream_label := COALESCE(v_downstream_label, '{}');
        query_result_downstream := COALESCE(query_result_downstream, '{}');       
        
--        Return
        RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "upstream_label":' ||v_upstream_label||
        ', "downstream_label":' ||v_downstream_label||
        ', "upstream":' || query_result_upstream || ', "downstream":'|| query_result_downstream || '}')::json;            

		--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
  --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;