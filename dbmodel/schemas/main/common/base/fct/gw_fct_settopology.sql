/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3154

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_settopology(p_data json)
  RETURNS json AS
$BODY$

/* example
SELECT SCHEMA_NAME.gw_fct_settopology($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{"id":"2001"},"data":{"fields":{"node_1":"1005"}}}$$);
SELECT SCHEMA_NAME.gw_fct_settopology($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{"id":"2001"},"data":{"fields":{"node_1":"1006"}}}$$);

-- FEATURE

*/

DECLARE

v_device integer;
v_infotype integer;
v_id integer;
v_version text;
v_text text[];
text text;
i integer=1;
n integer=1;
v_field text;
v_value text;
v_return text;
v_schemaname text;
v_featuretype text;
v_projecttype text;
v_closedstatus boolean;
v_message json;
v_afterinsert boolean;
v_node1 integer;
v_node2 integer;
v_node1_geom public.geometry;
v_node2_geom public.geometry;
v_arc_geom public.geometry;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

        -- get project type
        v_projecttype = (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
	p_data = REPLACE (p_data::text, '''''', 'null');
      
	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_id := ((p_data -> 'feature')->> 'id');
	v_node1 := ((p_data -> 'data')-> 'fields')->>'node_1';
	v_node2 := ((p_data -> 'data')-> 'fields')->>'node_2';

	
	-- Get gdb parameters
	v_node1_geom = (SELECT the_geom FROM node WHERE node_id = v_node1); 
	v_node2_geom = (SELECT the_geom FROM node WHERE node_id = v_node2); 
	v_arc_geom  = (SELECT the_geom FROM arc WHERE arc_id = v_id); 

	-- Temporarily disable topocontrol
	UPDATE config_param_user SET value = true WHERE parameter = 'edit_disable_topocontrol' and cur_user = cur_user;

	IF v_node1 IS NOT NULL THEN
		UPDATE arc SET node_1 = v_node1 WHERE arc_id = v_id;
		EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, 0, $2) WHERE arc_id = ' || quote_literal(v_id) USING v_arc_geom, v_node1_geom;			

	END IF;

	IF v_node2 IS NOT NULL THEN
		UPDATE arc SET node_2 = v_node2 WHERE arc_id = v_id;
		EXECUTE 'UPDATE arc SET the_geom = ST_SetPoint($1, ST_NumPoints($1) - 1, $2) WHERE arc_id = ' || quote_literal(v_id) USING v_arc_geom, v_node2_geom;		
	END IF;

	-- Enable topocontrol
	UPDATE config_param_user SET value = false WHERE parameter = 'edit_disable_topocontrol' and cur_user = cur_user;
	v_message = '{"level": 3, "text": "Feature have been succesfully updated."}';
	
	-- Control NULL's
	v_version := COALESCE(v_version, '');

	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "version":"' || v_version || '"'||
	      ',"body":{"data":{"fields":""}'||
	      '}'||'}')::json; 

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM),  'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;