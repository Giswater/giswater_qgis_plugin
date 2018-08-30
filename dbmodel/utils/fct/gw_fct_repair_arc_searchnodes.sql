/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2230

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_repair_arc_searchnodes();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_repair_arc_searchnodes() RETURNS void AS

$BODY$
DECLARE 
    arcrec Record;
    v_count integer;
    v_count_partial integer=0;

BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

	-- Delete previous log results
	DELETE FROM audit_log_data WHERE fprocesscat_id=3 AND user_name=current_user;
	DELETE FROM audit_log_data WHERE fprocesscat_id=4 AND user_name=current_user;
    
	-- Set config parameter
	UPDATE config_param_system SET value=TRUE WHERE parameter='edit_topocontrol_dsbl_error' ;
	
	-- init counter
	SELECT COUNT(*) into v_count FROM v_edit_arc ;  

	-- Starting loop process
	FOR arcrec IN SELECT * FROM v_edit_arc
	LOOP
		--counter
		v_count_partial = v_count_partial+1;
		RAISE NOTICE 'Comptador: % / %', v_count_partial,v_count;
		
		-- execute
		UPDATE v_edit_arc SET the_geom=the_geom WHERE arc_id=arcrec.arc_id;
		
	END LOOP;

	-- Set config parameter
	UPDATE config_param_system SET value=FALSE WHERE parameter='edit_topocontrol_dsbl_error' ;
	
RETURN;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;