/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3159


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_periodic_lot()
  RETURNS json AS
$BODY$


/*
 * SELECT SCHEMA_NAME.gw_fct_periodic_lot();
 */

DECLARE 
    
v_projecttype text;
rec_lot record;
v_update boolean;
v_count integer;
v_count_update integer;
v_message text;


BEGIN 

    --EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    SET search_path = "SCHEMA_NAME", public;

	SELECT project_type INTO v_projecttype FROM sys_version LIMIT 1;

	v_count=(SELECT count(*) FROM om_visit_lot WHERE periodicity >0);

	v_count_update=0;

    -- search for lots that have periodicity
	FOR rec_lot IN (SELECT * FROM om_visit_lot WHERE periodicity > 0 ORDER BY id) LOOP

    	v_update = false;

        -- capture if update is needed using startdate or last_restart but exception for status 6
		IF rec_lot.last_restart IS NULL AND rec_lot.status <> 6  THEN
			SELECT true into v_update from om_visit_lot where (date (now())- date (rec_lot.startdate)) >= rec_lot.periodicity;
		ELSIF rec_lot.last_restart IS NOT NULL AND rec_lot.status <> 6 THEN
			SELECT true into v_update from om_visit_lot where (date (now())- date (rec_lot.last_restart)) >= rec_lot.periodicity;
		END IF;

        -- if update is needed reset all values for this lot
		IF v_update IS TRUE THEN
			UPDATE om_visit_lot set status=4, last_restart=now() where id=rec_lot.id;
			UPDATE om_visit_lot_x_unit set status=1 where lot_id=rec_lot.id;
			UPDATE om_visit_lot_x_arc set status=1 where lot_id=rec_lot.id;
			UPDATE om_visit_lot_x_node set status=1 where lot_id=rec_lot.id;
			UPDATE om_visit_lot_x_gully set status=1 where lot_id=rec_lot.id;
			v_count_update=v_count_update+1;
		
		END IF;
	
	END LOOP;

	v_message = concat('"Lots updated: ',v_count_update,' of ',v_count,' that have periodicity"');
	
	-- Return
        RETURN ('{"status":"Accepted", "message":'||v_message||'}')::json;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

