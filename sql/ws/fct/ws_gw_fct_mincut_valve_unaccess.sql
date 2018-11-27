/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: 2312

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_valve_unaccess(node_id_var character varying, result_id_var integer, cur_user_var text)
  RETURNS void AS
$BODY$
DECLARE 
feature_id_aux text;
feature_type_aux text;
v_flag boolean = false;

BEGIN 
	-- set search_path
    SET search_path= 'SCHEMA_NAME','public';
	
	SELECT anl_feature_id INTO feature_id_aux FROM anl_mincut_result_cat WHERE id=result_id_var;
	SELECT anl_feature_type INTO feature_type_aux FROM anl_mincut_result_cat WHERE id=result_id_var;

	-- In case of variable om_mincut_valvestat_using_valveunaccess on TRUE and valve closed status on TRUE) -> change status to open
	IF (SELECT value::boolean FROM config_param_system WHERE parameter='om_mincut_valvestat_using_valveunaccess') IS TRUE AND (SELECT closed FROM man_valve WHERE node_id=node_id_var) IS TRUE THEN
		UPDATE man_valve SET closed=FALSE WHERE node_id=node_id_var;
		v_flag := true;

	-- The rest of cases. In case of closed valves without om_mincut_valvestat_using_valveunaccess on true -> nothing
	ELSIF (SELECT closed FROM man_valve WHERE node_id=node_id_var) IS FALSE THEN 

		-- Changing temporary status of accessibility
		IF (SELECT node_id FROM anl_mincut_result_valve_unaccess WHERE node_id=node_id_var and result_id=result_id_var) IS NULL THEN
			INSERT INTO anl_mincut_result_valve_unaccess (result_id, node_id) VALUES (result_id_var, node_id_var);
		ELSE
			DELETE FROM anl_mincut_result_valve_unaccess WHERE result_id=result_id_var AND node_id=node_id_var;
		END IF;
	END IF;
	
	-- Recalculate the mincut
	PERFORM gw_fct_mincut(feature_id_aux, feature_type_aux, result_id_var, current_user);

	-- In case of variable om_mincut_valvestat_using_valveunaccess on TRUE and valve closed status on TRUE)
	IF v_flag IS TRUE THEN
		-- Modify result values
		INSERT INTO anl_mincut_result_valve (result_id, node_id) VALUES (result_id_var, node_id_var);
        UPDATE anl_mincut_result_valve SET closed=TRUE, proposed=TRUE, broken=FALSE, unaccess=FALSE, 
		the_geom=(SELECT the_geom FROM ws.node WHERE node_id=node_id_var) WHERE node_id=node_id_var;
		--restore man_valve original values
		UPDATE man_valve SET closed=TRUE WHERE node_id=node_id_var;
	END IF;

RETURN;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;