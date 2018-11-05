/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2512

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_omvisit(csv2pgcat_id_aux integer, label_aux text)
RETURNS integer AS
$BODY$
DECLARE

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	-- Insert into audit table
	INSERT INTO audit_log_csv2pg 
	(csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20)
	SELECT csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20
	FROM temp_csv2pg;
	
RETURN 0;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
