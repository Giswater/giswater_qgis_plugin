/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3282

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeatureboundary(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT "SCHEMA_NAME".gw_fct_getfeatureboundary($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{"arc":[2001,2002], "node":[], "connec":[3001, 3002]},"data":{"type":"feature"}}$$)
SELECT "SCHEMA_NAME".gw_fct_getfeatureboundary($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{},"data":{"type":"time", "lastSeed":"2023-05-05"}}$$)
SELECT "SCHEMA_NAME".gw_fct_getfeatureboundary($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{},"feature":{},"data":{"type":"area", "polygon":"11223344}}$$) -- not solved
*/  

DECLARE    

v_type text;
v_lastseed text;
v_data json;
v_version json;
v_querynode text ='';
v_queryarc text ='';
v_queryconnec text ='';
v_querygully text ='';
v_array text;
v_querytext text;
v_boundary text;
v_union text = '';
    
BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- Get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	v_type = ((p_data ->>'data')::json->>'type');

	IF v_type = 'time' THEN

		v_lastseed = ((p_data ->>'data')::json->>'lastSeed');
		-- copy current code from service
		--v_querytext = concat ('SELECT st_union(st_buffer(the_geom, 1)) from ......................;


	ELSIF v_type = 'area' THEN
		-- todo

	ELSIF v_type = 'feature' THEN

		v_array =  COALESCE (replace(replace(((p_data ->>'feature')::json->>'node'),'[','('),']',')'),'()') ;
		IF v_array !='()' THEN
			v_querynode = concat ('SELECT the_geom FROM v_edit_node WHERE node_id::integer IN ', v_array);
			v_union  = ' UNION ';
		END IF;

		v_array =  COALESCE (replace(replace(((p_data ->>'feature')::json->>'arc'),'[','('),']',')'),'()') ;
		IF v_array !='()' THEN
			v_queryarc = concat (v_union, 'SELECT the_geom FROM v_edit_arc WHERE arc_id::integer IN ', v_array);
			v_union  = ' UNION ';
		END IF;
		
		v_array =  COALESCE (replace(replace(((p_data ->>'feature')::json->>'connec'),'[','('),']',')'),'()') ;
		IF v_array !='()' THEN
			v_queryconnec = concat (v_union, 'SELECT the_geom FROM v_edit_connec WHERE connec_id::integer IN ', v_array);
			v_union  = ' UNION ';
		END IF;

		v_array =  COALESCE (replace(replace(((p_data ->>'feature')::json->>'gully'),'[','('),']',')'),'()') ;
		IF v_array !='()' THEN
			v_querygully = concat (v_union, 'SELECT the_geom FROM v_edit_gully WHERE gully_id::integer IN ', v_array);
		END IF;

		--building querytext
		v_querytext = concat ('SELECT st_union(st_buffer(the_geom, 2)) from (',v_querynode, v_queryarc , v_queryconnec , v_querygully, ')a');
		
	END IF;

	-- execute query text and buildup boundary geometry
	EXECUTE v_querytext INTO v_boundary;
	v_data = concat ('{"boundary":"',v_boundary,'"}');

	-- check null
	v_version := COALESCE(v_version, '[]');
	v_data := COALESCE(v_data, '{}'); 

	-- Return
	RETURN ('{"status":"Accepted"' ||
        ', "version":'|| v_version ||
        ', "data":'|| v_data || 
        '}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
