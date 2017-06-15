/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_node_state_update()  RETURNS trigger AS $BODY$

DECLARE 
    querystring Varchar; 
    arcrec Record; 
    nodeRecord Record; 
    check_aux boolean;
    
BEGIN 

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    SELECT node_topocoh INTO check_aux FROM value_state where NEW.state=id;

    -- Select arcs with start-end on the updated node
    querystring := 'SELECT * FROM arc WHERE arc.node_1 = ' || quote_literal(NEW.node_id) || ' OR arc.node_2 = ' || quote_literal(NEW.node_id); 
  

    FOR arcrec IN EXECUTE querystring
    LOOP

        -- Initial and final node of the arc
        IF ((arcrec.state=NEW.state) AND (check_aux IS true)) OR check_aux IS false THEN
        ELSE
		RETURN audit_function(205,190);
        END IF;

    END LOOP; 

    RETURN NEW;
    
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_node_state_update ON "SCHEMA_NAME"."node";
CREATE TRIGGER gw_trg_node_state_update BEFORE INSERT ON "SCHEMA_NAME"."node" 
FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME"."gw_trg_node_state_update"();


