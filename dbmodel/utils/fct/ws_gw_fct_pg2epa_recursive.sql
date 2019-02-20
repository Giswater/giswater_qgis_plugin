/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2640

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_recursive(p_data json)  
RETURNS integer AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_recursive($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"status":1, "result_id":"test1"}]}}$$)
*/

DECLARE


BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;


--  Get input data
	v_status = (p_data->>'data')::json->>'status';
	v_result_id =  (p_data->>'data')::json->>'result_id';

	IF v_status=1 THEN
	
		RAISE NOTICE 'Starting pg2epa recursive process.';
				
		-- test recursive
		INSERT INTO temp_csv2pg (csv2pgcat_id, source, csv1, csv2) 
		SELECT 35, v_result_id, row_number() over (order by arc_id), arc_id FROM arc;
		RETURN (SELECT count(*) FROM arc);

	ELSE
	
		RAISE NOTICE 'Finishing pg2epa recursive process.';
		
		-- Deleting variable
		RETURN 0;

	END IF;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;