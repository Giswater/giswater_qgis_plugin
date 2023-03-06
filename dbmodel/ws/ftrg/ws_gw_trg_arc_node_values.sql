/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_node_values() RETURNS trigger AS $BODY$
DECLARE 
v_node_1 text;
v_node_2 text;
v_nodecat text;
v_message text;

	
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
    
    SELECT node_1 INTO v_node_1 FROM arc WHERE arc_id = NEW.arc_id;
    SELECT node_2 INTO v_node_2 FROM arc WHERE arc_id = NEW.arc_id;
	
	UPDATE arc a SET nodetype_1 = nodetype_id ,elevation1 = n.elevation, depth1 = n.depth, staticpress1 = n.staticpressure 
	FROM node n JOIN cat_node ct ON ct.id = nodecat_id 
	WHERE a.arc_id = NEW.arc_id AND node_id = v_node_1;

	UPDATE arc a SET nodetype_2 = nodetype_id ,elevation2 = n.elevation, depth2 = n.depth, staticpress2 = n.staticpressure 
	FROM node n JOIN cat_node ct ON ct.id = nodecat_id 
	WHERE a.arc_id = NEW.arc_id AND node_id = v_node_2;

RETURN NEW;
		
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


