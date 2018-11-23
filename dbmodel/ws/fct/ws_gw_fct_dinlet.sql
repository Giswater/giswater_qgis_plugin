/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2538

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_dinlet(p_node_id varchar)
  RETURNS void AS
$BODY$

/*
--EXAMPLE
DELETE FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=35 AND user_name=current_user;

SELECT node_id, SCHEMA_NAME.gw_fct_dinlet(node_id) 
FROM SCHEMA_NAME.anl_mincut_inlet_x_exploitation
JOIN SCHEMA_NAME.exploitation ON anl_mincut_inlet_x_exploitation.expl_id=exploitation.expl_id
WHERE macroexpl_id=1;

--RESULTS
SELECT * FROM SCHEMA_NAME.v_arc_dattrib
SELECT * FROM SCHEMA_NAME.v_node_dattrib
SELECT * FROM SCHEMA_NAME.v_connec_dattrib
*/

DECLARE

BEGIN
    -- Search path
    SET search_path = SCHEMA_NAME, public;
  	
	-- Set selectors
	DELETE FROM selector_state WHERE cur_user=current_user AND state_id=0;
	DELETE FROM selector_state WHERE cur_user=current_user AND state_id=2;
	DELETE FROM selector_psector WHERE cur_user=current_user;
	
	-- Set config 
	UPDATE config_param_user SET value=TRUE WHERE parameter='om_mincut_analysis_dinletsector' AND cur_user=current_user;
	
	-- Execute mincut
	PERFORM gw_fct_mincut_inlet_flowtrace(-1, p_node_id)  ;

	-- Moving from log result to dattrib table (3-dinlet)
	DELETE FROM dattrib WHERE dattrib_type=3 AND feature_id IN 
		(SELECT feature_id FROM audit_log_data WHERE fprocesscat_id=35 AND user_name=current_user);
		
	INSERT INTO dattrib 
		SELECT 3, feature_id, 'arc', log_message FROM audit_log_data 
		WHERE fprocesscat_id=35 AND user_name=current_user;

	-- Moving from log result to dattrib table (4- static pressure)
	DELETE FROM dattrib WHERE dattrib_type=4 AND feature_id IN 
		(SELECT node.node_id FROM audit_log_data 
		JOIN node ON node.node_id=log_message
		JOIN node inlet ON inlet.node_id=log_message
		WHERE fprocesscat_id=35 AND user_name=current_user;
	DELETE FROM dattrib WHERE dattrib_type=4 AND feature_id IN 
		(SELECT connec_id FROM audit_log_data
		JOIN connec ON connec.arc_id=audit_log_data.feature_id
		WHERE fprocesscat_id=35 AND user_name=current_user;	
		
	INSERT INTO dattrib
		SELECT 4 as dattrib_type, node.node_id, 'node' as feature_type, inlet.elevation-node.elevation AS static_pressure 
		FROM audit_log_data 
		JOIN node ON node.node_id=log_message
		JOIN node inlet ON inlet.node_id=log_message
		WHERE fprocesscat_id=35 AND user_name=current_user	
			UNION
		SELECT 4, connec_id, 'connec', inlet.elevation-connec.elevation AS static_pressure FROM audit_log_data
		JOIN node inlet ON inlet.node_id=log_message
		JOIN connec ON connec.arc_id=audit_log_data.feature_id
		WHERE fprocesscat_id=35 AND user_name=current_user;

	-- Restore system
	UPDATE config_param_user SET value=FALSE WHERE parameter='om_mincut_analysis_dinletsector' AND cur_user=current_user;
	RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


