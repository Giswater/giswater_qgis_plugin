/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2840

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_cat_vehicle()
  RETURNS trigger AS
$BODY$
DECLARE 


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
    IF TG_OP = 'INSERT' THEN
	
        -- FEATURE INSERT
        	INSERT INTO ext_cat_vehicle (id, idval, descript, model, number_plate)
            VALUES (NEW.id, NEW.idval, NEW.descript, NEW.model, NEW.number_plate);

	RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	-- FEATURE UPDATE
		UPDATE ext_cat_vehicle 
		SET id=NEW.id, idval=NEW.idval, descript=NEW.descript, model=NEW.model, number_plate=NEW.number_plate
		WHERE id::integer=NEW.id;
		
        RETURN NEW;

		
     ELSIF TG_OP = 'DELETE' THEN  
	 -- FEATURE DELETE
		DELETE FROM ext_cat_vehicle WHERE id = OLD.id;	

	RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;