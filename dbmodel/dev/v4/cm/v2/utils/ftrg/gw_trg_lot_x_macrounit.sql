/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3143

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_lot_x_macrounit()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE 

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	
    IF TG_OP = 'INSERT' THEN
        				  
	    -- FEATURE INSERT
		INSERT INTO om_visit_lot_x_macrounit (macrounit_id, lot_id, orderby, length)
		VALUES (NEW.macrounit_id, NEW.lot_id, NEW.orderby, NEW.length);
					
		RETURN NEW;
		
          
    ELSIF TG_OP = 'UPDATE' THEN

		UPDATE om_visit_lot_x_macrounit 
		SET macrounit_id=NEW.macrounit_id, lot_id=NEW.lot_id, orderby=NEW.orderby, length=NEW.length
		WHERE macrounit_id=NEW.macrounit_id;
		
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN  		
			
		DELETE FROM om_visit_lot_x_macrounit WHERE macrounit_id=OLD.macrounit_id;
	
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
