/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3157

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_om_visit_lot()
  RETURNS trigger AS
$BODY$
DECLARE 

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    IF TG_OP='UPDATE' THEN
    	IF NEW.status=6 THEN
    		UPDATE om_visit SET status=5 WHERE lot_id=NEW.id;
    	END IF;
		RETURN NEW;	
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


