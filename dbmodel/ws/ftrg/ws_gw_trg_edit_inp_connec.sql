/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION NODE: 2730


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_inp_connec()
RETURNS trigger AS
$BODY$
DECLARE

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	-- Control insertions ID
	IF TG_OP = 'INSERT' THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"1030", "function":"1310","parameters":null}}$$);';
	RETURN NEW;


	ELSIF TG_OP = 'UPDATE' THEN

		-- The geom
		IF (ST_equals (NEW.the_geom, OLD.the_geom)) IS FALSE THEN
			UPDATE connec SET the_geom=NEW.the_geom WHERE connec_id = OLD.connec_id;

			--update top_elev from raster
			IF (SELECT json_extract_path_text(value::json,'activated')::boolean FROM config_param_system WHERE parameter='admin_raster_dem') IS TRUE
			 AND (NEW.top_elev IS NULL) AND
			(SELECT upper(value)  FROM config_param_user WHERE parameter = 'edit_update_elevation_from_dem' and cur_user = current_user) = 'TRUE' THEN
					NEW.top_elev = (SELECT ST_Value(rast,1,NEW.the_geom,true) FROM ext_raster_dem WHERE id =
					(SELECT id FROM ext_raster_dem WHERE st_dwithin (envelope, NEW.the_geom, 1) LIMIT 1));
			END IF;
		END IF;

		UPDATE inp_connec
			SET demand=NEW.demand, pattern_id=NEW.pattern_id, peak_factor=NEW.peak_factor, custom_roughness = NEW.custom_roughness ,custom_length = NEW.custom_length, custom_dint = NEW.custom_dint,
			status = NEW.status, minorloss = NEW.minorloss, emitter_coeff = NEW.emitter_coeff, init_quality= NEW.init_quality, source_type= NEW.source_type, source_quality= NEW.source_quality,
			source_pattern_id= NEW.source_pattern_id
			WHERE connec_id=OLD.connec_id;

		IF (OLD.top_elev::TEXT!=NEW.top_elev::TEXT) or (OLD.depth::TEXT!=NEW.depth::TEXT) OR (OLD.conneccat_id!=NEW.conneccat_id) OR (OLD.annotation!=NEW.annotation) THEN
			UPDATE connec
			SET top_elev=NEW.top_elev, "depth"=NEW."depth", conneccat_id=NEW.conneccat_id, annotation=NEW.annotation
			WHERE connec_id=OLD.connec_id;
		END IF;

		IF quote_nullable(NEW.arc_id) != quote_nullable(OLD.arc_id) THEN
			UPDATE v_edit_connec SET arc_id=NEW.arc_id
			WHERE connec_id=OLD.connec_id;
		END IF;

		RETURN NEW;

	    ELSIF TG_OP = 'DELETE' THEN
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"1032", "function":"1310","parameters":null}}$$);';
		RETURN NEW;
	END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
