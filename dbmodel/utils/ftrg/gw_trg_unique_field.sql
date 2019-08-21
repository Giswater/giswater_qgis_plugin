/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2702

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_unique_field() RETURNS trigger AS 

$BODY$
DECLARE 
table_name text;

BEGIN
   -- set search_path
   EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
   
   table_name:= TG_ARGV[0];
  
    IF table_name = 'connec' AND NEW.state = 1 THEN 
   
	   IF (SELECT count(connec_id) FROM connec WHERE state=1 AND customer_code=NEW.customer_code) > 1 THEN
	       PERFORM audit_function(2702,3018);
	   END IF;

    ELSIF table_name = 'plan_x_arc' AND NEW.state=1 THEN
      IF (SELECT count(arc_id) FROM plan_psector_x_arc WHERE state=1 AND arc_id=NEW.arc_id) > 1 THEN
        PERFORM audit_function(3020,2702);
      END IF;
    ELSIF table_name = 'plan_x_node' AND NEW.state=1 THEN
       IF (SELECT count(node_id) FROM plan_psector_x_node WHERE state=1 AND node_id=NEW.node_id) > 1 THEN
        PERFORM audit_function(3020,2702);
      END IF;
     ELSIF table_name = 'plan_x_connec' AND NEW.state=1 THEN
       IF (SELECT count(connec_id) FROM plan_psector_x_connec WHERE state=1 AND connec_id=NEW.connec_id) > 1 THEN
        PERFORM audit_function(3020,2702);
      END IF;
    ELSIF table_name = 'plan_x_gully' AND NEW.state=1 THEN
      IF (SELECT count(gully_id) FROM plan_psector_x_gully WHERE state=1 AND gully_id=NEW.gully_id) > 1 THEN
        PERFORM audit_function(3020,2702);
      END IF;
    END IF;
			
RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;