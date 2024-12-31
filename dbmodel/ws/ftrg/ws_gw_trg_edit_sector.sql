/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 1124

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_sector()
  RETURNS trigger AS
$BODY$

DECLARE 

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	IF TG_OP = 'INSERT' THEN

		INSERT INTO sector (sector_id, name, descript, macrosector_id, the_geom, undelete, graphconfig, stylesheet, active, parent_id, pattern_id, avg_press)
		VALUES (NEW.sector_id, NEW.name, NEW.descript, NEW.macrosector_id, NEW.the_geom, NEW.undelete, 
		NEW.graphconfig::json, NEW.stylesheet::json, true, NEW.parent_id, NEW.pattern_id, NEW.avg_press);
	
		INSERT INTO selector_sector VALUES (NEW.sector_id, current_user);

		RETURN NEW;
				
	ELSIF TG_OP = 'UPDATE' THEN

		RETURN NEW;
	
	ELSIF TG_OP = 'DELETE' THEN  

		DELETE FROM sector WHERE sector_id = OLD.sector_id;

		RETURN NEW;

	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
