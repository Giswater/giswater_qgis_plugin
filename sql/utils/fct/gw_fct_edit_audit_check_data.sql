/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_edit_audit_check_data(fprocesscat_id integer) RETURNS void AS $$
DECLARE


BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;


	
	--fprocesscat_id 25 (Check mincut data)
	IF fprocesscat_id=25 THEN
	
		DELETE FROM audit_check_data WHERE user_name="current_user"() AND audit_check_data.fprocesscat_id=25;
	
	
	--fprocesscat_id 26 (Check profile tool data)
	ELSIF fprocesscat_id=26 THEN
		DELETE FROM audit_check_data WHERE user_name="current_user"() AND audit_check_data.fprocesscat_id=26;

	
	END IF;
	
	
    RETURN;
        
END;
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
 