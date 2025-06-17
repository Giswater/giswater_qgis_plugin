/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3474

DROP FUNCTION IF EXISTS cm.gw_trg_cm_edit_view_campaign_lot() CASCADE;

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_edit_view_campaign_lot()
RETURNS trigger AS
$BODY$
DECLARE
    v_feature_type TEXT := TG_ARGV[0];
    v_tablename TEXT;
    v_field_id TEXT;
    v_querytext TEXT;
BEGIN
    -- Optional: Set search path
    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    v_tablename := 'om_campaign_x_' || lower(v_feature_type);
    v_field_id  := lower(v_feature_type) || '_id';

    IF TG_OP = 'INSERT' THEN
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        -- Build UPDATE query with audit columns
        v_querytext :=
            'UPDATE ' || quote_ident(v_tablename) ||
            ' SET status = $1,
                  admin_observ = $2,
                  org_observ = $3,
                  update_at = NOW(),
                  update_by = current_user,
                  update_count = COALESCE(update_count,0)+1,
                  update_log = COALESCE(update_log, ''[]''::jsonb) || ' ||
            ' to_jsonb(json_build_object(''old_values'', $6, ''update_at'', NOW(), ''update_by'', current_user)) ' ||
            ' WHERE campaign_id = $4 AND ' || quote_ident(v_field_id) || ' = $5';

        EXECUTE v_querytext
        USING
            NEW.status,
            NEW.admin_observ,
            NEW.org_observ,
            OLD.campaign_id,
            OLD.node_id,
            row_to_json(OLD)::jsonb;

        RETURN NEW;
    END IF;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
