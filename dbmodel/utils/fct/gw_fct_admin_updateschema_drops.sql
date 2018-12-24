/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2550

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_updateschema_drops()
RETURNS void AS
$BODY$


DECLARE
	project_type_aux text;
	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;


	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	-- both projects (WS/UD)	
	-- tables
		DROP TABLE version CASCADE;
		DELETE FROM audit_cat_table WHERE id='version';

		-- views

		
		-- functions & function triggers
	
	-- ws projects
	IF project_type_aux='WS' THEN
	
		-- tables
		DROP TABLE inp_value_opti_units CASCADE;
		DELETE FROM audit_cat_table WHERE id='inp_value_opti_units';

		-- views
		DROP TABLE v_inp_mixing CASCADE;
		DELETE FROM audit_cat_table WHERE id='v_inp_mixing';
		
		-- functions & function triggers
		
		
	-- ud projects
	ELSIF project_type_aux='UD' THEN
		-- tables
		
		-- views
		
		-- triggers
		
		-- functions & function triggers
			
	END IF;
		
RETURN v_count;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;