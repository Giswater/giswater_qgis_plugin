/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2440

--DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_utils_csv2pg(integer, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg(
    csv2pgcat_id_aux integer,
    label_aux text)
  RETURNS integer AS
$BODY$
DECLARE

units_rec record;
element_rec record;
addfields_rec record;
id_last int8;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;


	-- db prices catalog
	IF csv2pgcat_id_aux=1 THEN

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
		INSERT INTO price_cat_simple (id) VALUES (label_aux);

		-- Upsert into price_simple table
		INSERT INTO price_simple (id, pricecat_id, unit, descript, text, price)
		SELECT csv1, label_aux, csv2, csv3, csv4, csv5::numeric(12,4)
		FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1
		AND csv1 NOT IN (SELECT id FROM price_simple);

		UPDATE price_simple SET pricecat_id=label_aux, price=csv5::numeric(12,4) FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1 AND price_simple.id=csv1;
		
		-- Delete values on temporal table
		DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=1;
	

	-- om visit tables
	ELSIF csv2pgcat_id_aux=2 THEN
	
		-- Insert into audit table
		INSERT INTO audit_log_csv2pg 
		(csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20)
		SELECT csv2pgcat_id, user_name,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18,csv19,csv20
		FROM temp_csv2pg;

	-- elements import
	ELSIF csv2pgcat_id_aux=3 THEN
	
		FOR element_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=3
		LOOP 
			IF label_aux='node' THEN
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')),element_rec.csv2, element_rec.csv3, element_rec.csv4, element_rec.csv5::integer) RETURNING element_id INTO id_last;
				INSERT INTO element_x_node (element_id, node_id) VALUES (id_last, element_rec.csv1);
				
			ELSIF label_aux='arc' THEN 
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')),element_rec.csv2, element_rec.csv3, element_rec.csv4, element_rec.csv5::integer) RETURNING element_id INTO id_last;
				INSERT INTO element_x_arc (element_id, arc_id) VALUES (id_last, element_rec.csv1);
				
			ELSIF label_aux='connec' THEN	
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')),element_rec.csv2, element_rec.csv3, element_rec.csv4, element_rec.csv5::integer) RETURNING element_id INTO id_last;
				INSERT INTO element_x_connec (element_id, connec_id) VALUES (id_last, element_rec.csv1);
				
			ELSIF label_aux='gully' THEN
				INSERT INTO element (element_id, elementcat_id,observ, comment, num_elements) VALUES
				((SELECT nextval('urn_id_seq')),element_rec.csv2, element_rec.csv3, element_rec.csv4, element_rec.csv5::integer) RETURNING element_id INTO id_last;
				INSERT INTO element_x_gully (element_id, gully_id) VALUES (id_last, element_rec.csv1);
			END IF;	

		END LOOP;

		-- Delete values on temporal table
		DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=3;

	-- addfields import
	ELSIF csv2pgcat_id_aux=4 THEN

		FOR addfields_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=4
		LOOP
				INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) VALUES
				(addfields_rec.csv1, addfields_rec.csv2::integer, addfields_rec.csv3);			
		END LOOP;
		
		-- Delete values on temporal table
		DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=4;

			
	END IF;
	
	
RETURN 0;
	
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
