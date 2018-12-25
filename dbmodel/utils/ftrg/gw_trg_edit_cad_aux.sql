/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_cad_aux()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_sql varchar;
	plan_psector_seq int8;
	geom_type text;
	
BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    geom_type:= TG_ARGV[0];
    
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN          
	
		IF geom_type='circle' THEN					   
			INSERT INTO temp_table (fprocesscat_id, geom_polygon, user_name)
			VALUES  (28, NEW.geom_polygon, current_user);
		ELSIF geom_type='point' THEN
            INSERT INTO temp_table (fprocesscat_id, geom_point, user_name)
            VALUES  (27, NEW.geom_point, current_user);
		END IF;
		
        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN

	IF geom_type='circle' THEN	               
		UPDATE temp_table 
		SET id=NEW.id, geom_polygon=NEW.geom_polygon
		WHERE id=OLD.id;
	ELSIF geom_type='point' THEN	               
		UPDATE temp_table 
		SET id=NEW.id, geom_point=NEW.geom_point
		WHERE id=OLD.id;
	END IF;
               
        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
    

	DELETE FROM temp_table WHERE id = OLD.id;      

    RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;