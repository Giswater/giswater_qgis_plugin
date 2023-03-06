/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3202

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_arc_node_values() RETURNS trigger AS $BODY$
DECLARE 

v_nodecat text;
v_message text;

	
BEGIN 

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
    
	UPDATE arc a SET nodetype_1 = node_type, node_sys_top_elev_1 =sys_top_elev,
	node_sys_elev_1 = sys_elev
	FROM vu_node
	WHERE a.arc_id = NEW.arc_id AND node_id = node_1;

	UPDATE arc a SET nodetype_2 = node_type ,node_sys_top_elev_2 = sys_top_elev, 
	node_sys_elev_2 = sys_elev
	FROM vu_node
	WHERE a.arc_id = NEW.arc_id AND node_id = node_2;

RETURN NEW;
		
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


