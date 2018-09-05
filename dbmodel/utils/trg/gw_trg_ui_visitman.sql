/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1314

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_ui_visitman()
  RETURNS trigger AS
$BODY$
DECLARE 

    visitman_table varchar;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	      
	    visitman_table:= TG_TABLE_NAME;


    IF TG_OP = 'DELETE' THEN 
	
	 	IF visitman_table='v_ui_om_visitman_x_arc' THEN
	 		DELETE FROM om_visit_x_arc WHERE arc_id = OLD.arc_id AND visit_id=OLD.visit_id;

	 	ELSIF visitman_table='v_ui_om_visitman_x_node' THEN
	 		DELETE FROM om_visit_x_node WHERE node_id = OLD.node_id AND visit_id=OLD.visit_id;

	 	ELSIF visitman_table='v_ui_om_visitman_x_connec' THEN
	 		DELETE FROM om_visit_x_connec WHERE connec_id = OLD.connec_id AND visit_id=OLD.visit_id;

	 	--ELSIF visitman_table='v_ui_om_visitman_x_gully' THEN
	 	--	DELETE FROM om_visit_x_gully WHERE gully_id = OLD.gully_id AND visit_id=OLD.visit_id;
  		
  		END IF;
        RETURN NULL;
     
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  


