/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2214


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_exit(node_id_arg character varying)  RETURNS smallint AS $BODY$


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


    -- Reset values
    DELETE FROM anl_flow_node WHERE cur_user="current_user"() AND context='Flow exit';
    DELETE FROM anl_flow_arc WHERE cur_user="current_user"() AND context='Flow exit' ; 


    -- Compute the tributary area using DFS
    PERFORM gw_fct_flow_exit_recursive(node_id_arg);

RETURN 1;
        
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

