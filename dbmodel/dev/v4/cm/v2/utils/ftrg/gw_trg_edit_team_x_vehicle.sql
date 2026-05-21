/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2844

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_team_x_vehicle()
  RETURNS trigger AS
$BODY$
DECLARE 

	v_team integer;
	v_vehicle integer;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';


	
    IF TG_OP = 'INSERT' THEN
	
		v_team = (select id from cat_team where idval=NEW.team);
		v_vehicle = (select id from ext_cat_vehicle where idval=NEW.vehicle);
	
			
        -- FEATURE INSERT
        
        			INSERT INTO om_team_x_vehicle (team_id, vehicle_id)
				VALUES (v_team, v_vehicle);

		RETURN NEW;
		
    ELSIF TG_OP = 'UPDATE' THEN
   	-- FEATURE UPDATE
			UPDATE om_team_x_vehicle 
			SET team_id=v_team, vehicle_id=v_vehicle
			WHERE id=NEW.id;
		
        RETURN NEW;

		
		
     ELSIF TG_OP = 'DELETE' THEN  
	 -- FEATURE DELETE
		DELETE FROM om_team_x_vehicle WHERE id = OLD.id;		

		RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;