/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3038

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_lid_usage()
  RETURNS trigger AS
$BODY$
DECLARE 
expl_id_int integer;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    IF TG_OP = 'INSERT' THEN
    
		INSERT INTO inp_lid_usage (hydrology_id, subc_id, lidco_id, numelem, area, width, initsat, fromimp, toperv,rptfile, descript, hydrology_id) 
		VALUES (NEW.hydrology_id, NEW.subc_id, NEW.lidco_id, NEW.numelem, NEW.area, NEW.width, NEW.initsat, NEW.fromimp, NEW.toperv, NEW.rptfile, NEW.descript, NEW.hydrology_id);
		
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
		
		UPDATE inp_lid_usage 
		SET subc_id=NEW.subc_id, lidco_id=NEW.lidco_id, numelem=NEW.numelem, area=NEW.area, width=NEW.width, initsat=NEW.initsat, fromimp=NEW.fromimp,
		toperv=NEW.toperv, rptfile=NEW.rptfile, descript=NEW.descript, hydrology_id = NEW.hydrology_id
		WHERE subc_id = OLD.subc_id AND hydrology_id = OLD.hydrology_id AND lidco_id = OLD.lidco_id;
                
		RETURN NEW;
   
    ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM inp_lid_usage WHERE subc_id = OLD.subc_id AND hydrology_id = OLD.hydrology_id;

		RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;