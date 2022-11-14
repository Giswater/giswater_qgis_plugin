/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3174

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_setarcdata()  RETURNS trigger AS
$BODY$

DECLARE 

v_table text;
v_projecttype text;
v_version text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	v_table= lower(TG_ARGV[0]);

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	
	IF v_projecttype='WS' THEN
		IF v_table ='node' THEN
			UPDATE arc SET nodetype_1=node_type, elevation1=elevation ,depth1=n.depth, staticpress1=n.staticpressure FROM v_edit_node n 
			WHERE node_1=node_id AND node_id=NEW.node_id;

			UPDATE arc SET nodetype_2=node_type, elevation2=elevation ,depth2=n.depth, staticpress2=n.staticpressure FROM v_edit_node n 
			WHERE node_2=node_id AND node_id=NEW.node_id;
		ELSIF v_table='arc' THEN
			UPDATE arc SET nodetype_1=node_type, elevation1=elevation ,depth1=n.depth, staticpress1=n.staticpressure FROM v_edit_node n 
			WHERE node_1=node_id AND arc.arc_id=NEW.arc_id;

			UPDATE arc SET nodetype_2=node_type, elevation2=elevation ,depth2=n.depth, staticpress2=n.staticpressure FROM v_edit_node n 
			WHERE node_2=node_id AND arc.arc_id=NEW.arc_id;

		END IF;
	ELSIF v_projecttype='UD' THEN
	
	END IF;	
	RETURN NEW;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

