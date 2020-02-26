/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2432

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_module_activate(module_id_var text) 
RETURNS integer AS
$BODY$

DECLARE 

v_project_type text;

BEGIN 

    SET search_path=SCHEMA_NAME, public;
	
	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;
	
	IF v_project_type='UD' THEN
	
		IF module_id_var = 'om_insp_reh' THEN
			-- UPDATE config_param_system SET extension_om_insp_reh=TRUE
			-- INSERT INTO plan_result_type VALUES ('rehabilitation')
			-- INSERT INTO plan_psector_type VALUES ('rehabilitation')
			-- INSERT INTO om_visit_parameter_type ('REHABIT')
			-- INSERT INTO om_visit_form_type ('event_ud_arc_rehabit')
	
			
		ELSIF extension_id_var = 'om_add_csv' THEN
			-- to do
	
		ELSE 
			RETURN gw_fct_audit_function (2082,2432,extension_id_var);
	  	
		END IF;
	
	ELSIF v_project_type='WS' THEN
	
		IF module_id_var = 'epa_rtc' THEN
				
		
		ELSE 
			RETURN gw_fct_audit_function(2084,2432,extension_id_var);
	  	
		END IF;

	END IF;
	
	
	
RETURN 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
