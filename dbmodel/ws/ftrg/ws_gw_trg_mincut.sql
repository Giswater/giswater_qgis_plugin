/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3144

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_mincut()  RETURNS trigger AS
$BODY$

DECLARE 

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	

	IF now()::date != NEW.anl_tstamp::date THEN

		IF OLD.mincut_type!=NEW.mincut_type or OLD.anl_cause!=NEW.anl_cause OR OLD.anl_tstamp!=NEW.anl_tstamp OR OLD.received_date!=NEW.received_date OR 
		OLD.work_order!=NEW.work_order OR NEW.mincut_class!=OLD.mincut_class OR NEW.expl_id!=OLD.expl_id OR OLD.macroexpl_id!=NEW.macroexpl_id OR 
		OLD.muni_id!=NEW.muni_id OR OLD.postcode!=NEW.postcode OR OLD.streetaxis_id!=NEW.streetaxis_id OR NEW.postnumber!=OLD.postnumber OR 
		NEW.anl_user!=OLD.anl_user OR NEW.anl_descript!=OLD.anl_descript OR OLD.anl_feature_id!=NEW.anl_feature_id OR NEW.anl_feature_type!=OLD.anl_feature_type OR 
		NEW.anl_the_geom::text!=OLD.anl_the_geom::text OR NEW.forecast_start!=OLD.forecast_start OR NEW.forecast_end!=OLD.forecast_end OR NEW.assigned_to!=OLD.assigned_to
        OR NEW.output::text!=OLD.output::text THEN

			UPDATE om_mincut SET modification_date=now() WHERE id = NEW.id;

		
	END IF;

	END IF;
	
	RETURN NEW;

END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

