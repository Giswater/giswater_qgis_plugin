/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2516

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_addfields(csv2pgcat_id_aux integer, label_aux text)
RETURNS integer AS
$BODY$
DECLARE
	v_addfields record;

BEGIN

	--  Search path
    SET search_path = "SCHEMA_NAME", public;

	FOR v_addfields IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=4
	LOOP
		INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) VALUES
		(v_addfields.csv1, v_addfields.csv2::integer, v_addfields.csv3);			
		END LOOP;
			
	-- Delete values on temporal table
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=4;	
	
RETURN 0;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
