/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 1232

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_trg_edit_subcatchment() CASCADE;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_edit_inp_subcatchment()
  RETURNS trigger AS
$BODY$
DECLARE 
	expl_id_int integer;


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    -- Control insertions ID
    IF TG_OP = 'INSERT' THEN
    
       -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
            NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='edit_sector_vdefault' AND "cur_user"="current_user"());
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			END IF;
        END IF;

        -- hydrology_id
		NEW.hydrology_id=(SELECT "hydrology_id" FROM selector_inp_hydrology WHERE "cur_user"="current_user"() LIMIT 1);
		IF (NEW.hydrology_id IS NULL) THEN
		END IF;
	
		-- Subc ID
        IF (NEW.subc_id IS NULL) THEN
            NEW.subc_id := concat((SELECT value FROM config_param_system WHERE parameter='epa_subcatchment_concat_prefix_id'),(SELECT nextval('SCHEMA_NAME.inp_subcatchment_subc_id_seq'::regclass)));
        END IF;

       		
		-- FEATURE INSERT
		INSERT INTO inp_subcatchment (subc_id, outlet_id, rg_id, area, imperv, width, slope, clength, snow_id, nimp, nperv, simp, sperv, zero, routeto, rted, maxrate, minrate, decay, drytime, maxinfil, suction, conduct, initdef, curveno, conduct_2, 
		drytime_2, sector_id, hydrology_id, the_geom, descript) 
		VALUES (NEW.subc_id, NEW.outlet_id, NEW.rg_id, NEW.area, NEW.imperv, NEW.width, NEW.slope, NEW.clength, NEW.snow_id, NEW.nimp, NEW.nperv, NEW.simp, NEW.sperv, NEW.zero, NEW.routeto, NEW.rted, NEW.maxrate, 
		NEW.minrate, NEW.decay, NEW.drytime, NEW.maxinfil, NEW.suction, NEW.conduct, NEW.initdef, NEW.curveno, NEW.conduct_2, NEW.drytime_2, NEW.sector_id, NEW.hydrology_id, NEW.the_geom, NEW.descript);
		
		RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
    
		-- UPDATE values
		
		UPDATE inp_subcatchment 
		SET subc_id=NEW.subc_id, outlet_id=NEW.outlet_id, rg_id=NEW.rg_id, area=NEW.area, imperv=NEW.imperv, width=NEW.width, slope=NEW.slope, clength=NEW.clength, snow_id=NEW.snow_id, nimp=NEW.nimp, nperv=NEW.nperv, 
		simp=NEW.simp, sperv=NEW.sperv, zero=NEW.zero, routeto=NEW.routeto, rted=NEW.rted, maxrate=NEW.maxrate, minrate=NEW.minrate, decay=NEW.decay, drytime=NEW.drytime, maxinfil=NEW.maxinfil, suction=NEW.suction, 
		conduct=NEW.conduct, initdef=NEW.initdef, curveno=NEW.curveno, conduct_2=NEW.conduct_2, drytime_2=NEW.drytime_2, sector_id=NEW.sector_id, hydrology_id=NEW.hydrology_id, the_geom=NEW.the_geom,
		descript = NEW.descript
		WHERE subc_id = OLD.subc_id;
                
		RETURN NEW;
   
    ELSIF TG_OP = 'DELETE' THEN
        DELETE FROM inp_subcatchment WHERE subc_id = OLD.subc_id;

        RETURN NULL;
   
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;