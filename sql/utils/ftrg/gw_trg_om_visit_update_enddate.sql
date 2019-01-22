/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2632

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_visit_update_enddate()
  RETURNS trigger AS
$BODY$
DECLARE 
	v_node_1 varchar;
	v_node_2 varchar;
	v_the_geom public.geometry;
	v_unitarylength float;
	v_point public.geometry;
	v_table text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    v_table:= TG_ARGV[0];


	IF v_table = 'visit' THEN
	
		UPDATE om_visit SET enddate=now() WHERE id=NEW.id;
	
	ELSIF v_table = 'event' THEN
	
		UPDATE om_visit SET enddate=now() WHERE id=NEW.visit_id;
	
	END IF;

	RETURN NEW;
	
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;