/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2218

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_flow_trace(character varying);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_trace(p_node_id character varying)  
RETURNS smallint AS 
$BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_flow_trace ('5100');
*/

DECLARE 

 
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
	
	-- Compute the tributary area using recursive function
	PERFORM gw_fct_flow_trace_recursive(p_node_id);
	
RETURN 1;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

