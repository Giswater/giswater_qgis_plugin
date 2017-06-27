/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_arc_state_update()  RETURNS trigger AS $BODY$

DECLARE 
    querystring Varchar; 
    arcrec Record; 
    nodeRecord Record; 
    check_aux boolean;
    
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    SELECT node_topocoh INTO check_aux FROM value_state where NEW.state=id;

-- TODO
/*
		IF THEN
        ELSE
		RETURN audit_function(215,200); 
        END IF;

    END LOOP; 

    RETURN NEW;*/
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_arc_state_update ON "SCHEMA_NAME"."arc";
CREATE TRIGGER gw_trg_arc_state_update BEFORE INSERT ON "SCHEMA_NAME"."arc" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_arc_state_update"();


