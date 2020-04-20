/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2864

CREATE OR REPLACE FUNCTION "utils".gw_trg_manage_raster_dem()  RETURNS trigger AS
$BODY$

DECLARE 


BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
    IF TG_OP = 'INSERT' THEN
	
		INSERT INTO cat_raster (id, raster_type, tstamp, insert_user) VALUES (NEW.rastercat_id, 'DEM', now(), current_user)
		ON CONFLICT (id) DO NOTHING;

		UPDATE raster_dem SET envelope  =  (
					SELECT ST_MakeEnvelope(ST_UpperLeftX(NEW.rast), ST_UpperLeftY(NEW.rast),ST_UpperLeftX(NEW.rast) + ST_ScaleX(NEW.rast)*ST_width(NEW.rast),
					ST_UpperLeftY(NEW.rast) + ST_ScaleY(NEW.rast)*ST_height(NEW.rast), SRID_VALUE) WHERE id = NEW.id);
		RETURN NEW;
				
    ELSIF TG_OP = 'DELETE' THEN  

		-- only if it's last row for that raster
		IF (SELECT count(*) FROM raster_dem WHERE rastercat_id=OLD.rastercat_id) = 0 THEN
	 		DELETE FROM cat_raster WHERE id = OLD.rastercat_id;		
	 	END IF;
	 	
		RETURN NULL;
     
    END IF;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


