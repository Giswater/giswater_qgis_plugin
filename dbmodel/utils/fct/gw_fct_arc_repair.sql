/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2496

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_arc_repair (text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_repair (p_arc_id text) RETURNS varchar AS

$BODY$
DECLARE 


BEGIN 

	SET search_path= 'SCHEMA_NAME','public';

    
	-- Set config parameter
	UPDATE config_param_system SET value=TRUE WHERE parameter='edit_topocontrol_dsbl_error' ;
	
	-- execute
	UPDATE arc SET the_geom=the_geom WHERE arc_id=p_arc_id;

	-- raise notice
	RAISE NOTICE 'Arc id: %', p_arc_id;
		
	-- Set config parameter
	UPDATE config_param_system SET value=FALSE WHERE parameter='edit_topocontrol_dsbl_error' ;
	
RETURN p_arc_id;
    
END;  
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;