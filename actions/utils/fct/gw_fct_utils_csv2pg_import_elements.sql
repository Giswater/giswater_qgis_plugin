/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2514

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_elements(csv2pgcat_id_aux integer, label_aux text)
RETURNS integer AS
$BODY$
DECLARE


element_rec record;
id_last int8;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

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
	
RETURN 0;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
