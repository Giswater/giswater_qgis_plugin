/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3144

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_mincut()  RETURNS trigger AS
$BODY$

DECLARE 
reference_ts timestamp;

BEGIN
    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    reference_ts := COALESCE(NEW.modification_date, NEW.anl_tstamp);

    -- only if now is > than modification or creation
	-- skip the first minutes because the mincut itself perform an update after saving
    IF now() > reference_ts + '2 minutes'::interval THEN

        -- check key fields for changes
        IF OLD.mincut_type       IS DISTINCT FROM NEW.mincut_type OR
           OLD.anl_cause         IS DISTINCT FROM NEW.anl_cause OR
           OLD.anl_tstamp        IS DISTINCT FROM NEW.anl_tstamp OR
           OLD.received_date     IS DISTINCT FROM NEW.received_date OR
           OLD.work_order        IS DISTINCT FROM NEW.work_order OR
           OLD.mincut_class      IS DISTINCT FROM NEW.mincut_class OR
           OLD.expl_id           IS DISTINCT FROM NEW.expl_id OR
           OLD.macroexpl_id      IS DISTINCT FROM NEW.macroexpl_id OR
           OLD.muni_id           IS DISTINCT FROM NEW.muni_id OR
           OLD.postcode          IS DISTINCT FROM NEW.postcode OR
           OLD.streetaxis_id     IS DISTINCT FROM NEW.streetaxis_id OR
           OLD.postnumber        IS DISTINCT FROM NEW.postnumber OR
           OLD.anl_user          IS DISTINCT FROM NEW.anl_user OR
           OLD.anl_descript      IS DISTINCT FROM NEW.anl_descript OR
           OLD.anl_feature_id    IS DISTINCT FROM NEW.anl_feature_id OR
           OLD.anl_feature_type  IS DISTINCT FROM NEW.anl_feature_type OR
           OLD.anl_the_geom::text IS DISTINCT FROM NEW.anl_the_geom::text OR
           OLD.forecast_start    IS DISTINCT FROM NEW.forecast_start OR
           OLD.forecast_end      IS DISTINCT FROM NEW.forecast_end OR
           OLD.assigned_to       IS DISTINCT FROM NEW.assigned_to OR
           OLD.output::text      IS DISTINCT FROM NEW.output::text OR
           OLD.shutoff_required  IS DISTINCT FROM NEW.shutoff_required
        THEN
            UPDATE om_mincut 
               SET modification_date = now(),
                   modification_user = CURRENT_USER
             WHERE id = NEW.id;
        END IF;

    END IF;

    RETURN NEW;
END;
	
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

