/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3141

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_lot_x_unit()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE 

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	
    IF TG_OP = 'INSERT' THEN
        				  
	    -- FEATURE INSERT
		INSERT INTO om_visit_lot_x_unit (unit_id, lot_id, status, orderby, the_geom, unit_type, length, way_type, way_in, way_out)
		VALUES (NEW.unit_id, NEW.lot_id, NEW.status, NEW.orderby, NEW.the_geom, NEW.unit_type, NEW.length, NEW.way_type, NEW.way_in, NEW.way_out, NEW.macrounit_id);
					
		RETURN NEW;
		
          
    ELSIF TG_OP = 'UPDATE' THEN

		UPDATE om_visit_lot_x_unit 
		SET unit_id=NEW.unit_id, lot_id=NEW.lot_id, status=NEW.status, orderby=NEW.orderby, the_geom=NEW.the_geom, unit_type=NEW.unit_type, length=NEW.length,
	  	way_type=NEW.way_type, way_in=NEW.way_in, way_out=NEW.way_out
		WHERE unit_id=NEW.unit_id;
		
        RETURN NEW;

     ELSIF TG_OP = 'DELETE' THEN  		
			
		DELETE FROM om_visit_lot_x_unit WHERE unit_id=OLD.unit_id;
	
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
