/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- FUNCTION NUMBER : 3140

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_coverage()
  RETURNS trigger AS
$BODY$
DECLARE 

BEGIN

	--Get schema name
	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	
	IF TG_OP = 'INSERT' THEN

		INSERT INTO inp_coverage (subc_id, landus_id, percent,hydrology_id)
		VALUES (NEW.subc_id, NEW.landus_id, NEW.percent, NEW.hydrology_id) 
		ON CONFLICT (subc_id, landus_id, hydrology_id) DO NOTHING;
		
		RETURN NEW;

	ELSIF TG_OP = 'UPDATE' THEN

		UPDATE inp_coverage SET percent=NEW.percent, hydrology_id=NEW.hydrology_id, landus_id=NEW.landus_id, subc_id=NEW.subc_id
		WHERE subc_id=OLD.subc_id AND landus_id = OLD.landus_id AND hydrology_id=OLD.hydrology_id;
		
		RETURN NEW;

	ELSIF TG_OP = 'DELETE' THEN

		DELETE FROM inp_coverage WHERE subc_id=OLD.subc_id AND landus_id = OLD.landus_id AND hydrology_id=OLD.hydrology_id;

		RETURN OLD;
  END IF;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
