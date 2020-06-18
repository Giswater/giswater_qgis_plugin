/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2660

drop function if exists SCHEMA_NAME.gw_fct_edit_check_data(json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_edit_check_data(fid json) RETURNS json AS $$
DECLARE

v_return json;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
	
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND audit_check_data.fid = 38;
	
    RETURN vjson;
        
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 