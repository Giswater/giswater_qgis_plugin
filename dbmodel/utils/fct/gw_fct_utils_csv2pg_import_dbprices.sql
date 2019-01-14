/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2510

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_dbprices(csv2pgcat_id_aux integer, label_aux text)
RETURNS integer AS
$BODY$
DECLARE
	units_rec record;

BEGIN

	--  Search path
    SET search_path = "SCHEMA_NAME", public;

	-- control of price code (csv1)
	SELECT csv1 INTO units_rec FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	IF units_rec IS NULL THEN
		RETURN audit_function(2086,2440);
	END IF;
	
	-- control of price units (csv2)
	SELECT csv2 INTO units_rec FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1
	AND csv2 IS NOT NULL AND csv2 NOT IN (SELECT unit FROM price_simple);

	IF units_rec IS NOT NULL THEN
		RETURN audit_function(2088,2440,(units_rec)::text);
	END IF;

	-- control of price descript (csv3)
	SELECT csv3 INTO units_rec FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	IF units_rec IS NULL THEN
		RETURN audit_function(2090,2440);
	END IF;

	-- control of null prices(csv5)
	SELECT csv5 INTO units_rec FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	IF units_rec IS NULL THEN
		RETURN audit_function(2092,2440);
	END IF;
	
	-- Insert into audit table
	INSERT INTO audit_log_csv2pg  (csv2pgcat_id, user_name, csv1, csv2, csv3, csv4, csv5)
	SELECT csv2pgcat_id, user_name, csv1, csv2, csv3, csv4, csv5
	FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;

	-- Insert into price_cat_simple table
	IF label_aux NOT IN (SELECT id FROM price_cat_simple) THEN
		INSERT INTO price_cat_simple (id) VALUES (label_aux);
	END IF;

	-- Upsert into price_simple table
	INSERT INTO price_simple (id, pricecat_id, unit, descript, text, price)
	SELECT csv1, label_aux, csv2, csv3, csv4, csv5::numeric(12,4)
	FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1
	AND csv1 NOT IN (SELECT id FROM price_simple);

	UPDATE price_simple SET pricecat_id=label_aux, price=csv5::numeric(12,4) FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1 AND price_simple.id=csv1;
		
	-- Delete values on temporal table
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;	
	
RETURN 0;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
