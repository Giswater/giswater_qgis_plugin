/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_exit(node_id_arg character varying)  RETURNS smallint AS $BODY$

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Clear tables
    DELETE FROM anl_flow_trace_node;
    DELETE FROM anl_flow_trace_arc;

    -- Compute the tributary area using DFS
    PERFORM gw_fct_flow_exit_recursive(node_id_arg);

    RETURN audit_function(0,720);
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

