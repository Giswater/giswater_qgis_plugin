/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 2312

--DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_valve_unaccess(p_data);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_valve_unaccess(p_data json)

  RETURNS json AS
$BODY$

DECLARE 

feature_id_aux text;
feature_type_aux text;
v_flag boolean = false;
v_node_id character varying;
v_result_id integer;
v_error_context text;

BEGIN 
	-- set search_path
    SET search_path= 'SCHEMA_NAME','public';

	-- get input parameters
	v_node_id := (p_data ->>'data')::json->>'nodeId';
	v_result_id := ((p_data ->>'data')::json->>'mincutId')::integer;	

	SELECT anl_feature_id INTO feature_id_aux FROM om_mincut WHERE id=v_result_id;
	SELECT anl_feature_type INTO feature_type_aux FROM om_mincut WHERE id=v_result_id;

	-- In case of variable om_mincut_valvestatus_unaccess on TRUE and valve closed status on TRUE) -> change status to open
	IF (SELECT value::boolean FROM config_param_system WHERE parameter='om_mincut_valvestatus_unaccess') IS TRUE AND (SELECT closed FROM man_valve WHERE node_id=v_node_id) IS TRUE THEN
		UPDATE man_valve SET closed=FALSE WHERE node_id=v_node_id;
		v_flag := true;

	-- The rest of cases. In case of closed valves without om_mincut_valvestatus_unaccess on true -> nothing
	ELSIF (SELECT closed FROM man_valve WHERE node_id=v_node_id) IS FALSE THEN 

		-- Changing temporary status of accessibility
		IF (SELECT node_id FROM om_mincut_valve_unaccess WHERE node_id=v_node_id and result_id=v_result_id) IS NULL THEN
			INSERT INTO om_mincut_valve_unaccess (result_id, node_id) VALUES (v_result_id, v_node_id);
		ELSE
			DELETE FROM om_mincut_valve_unaccess WHERE result_id=v_result_id AND node_id=v_node_id;
		END IF;
	END IF;
	RAISE NOTICE 'TEST 10';
	
	-- Recalculate the mincut
	PERFORM gw_fct_mincut(feature_id_aux, feature_type_aux, v_result_id);
	
	-- In case of variable om_mincut_valvestatus_unaccess on TRUE and valve closed status on TRUE)
	IF v_flag IS TRUE THEN
		-- Modify result values
		INSERT INTO om_mincut_valve (result_id, node_id) VALUES (v_result_id, v_node_id);
        UPDATE om_mincut_valve SET closed=TRUE, proposed=TRUE, broken=FALSE, unaccess=FALSE, 
		the_geom=(SELECT the_geom FROM node WHERE node_id=v_node_id) WHERE node_id=v_node_id;
		
		--restore man_valve original values
		UPDATE man_valve SET closed=TRUE WHERE node_id=v_node_id;
	END IF;


	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Custom mincut executed successfully"}, "version":""'||
		',"body":{"form":{}'||
		',"data":{}'||
		'}}')::json;
		
	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

