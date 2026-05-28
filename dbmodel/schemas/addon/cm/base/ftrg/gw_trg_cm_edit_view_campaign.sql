/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3476

DROP FUNCTION IF EXISTS cm.gw_trg_cm_edit_view_campaign() CASCADE;
CREATE OR REPLACE FUNCTION cm.gw_trg_cm_edit_view_campaign()
 RETURNS trigger AS
$BODY$

DECLARE

    v_feature_type TEXT := TG_ARGV[0];

    v_tablename TEXT;
    v_field_id TEXT;
    v_querytext TEXT;
    v_prev_search_path text;

BEGIN

    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', format('%I, public', TG_TABLE_SCHEMA), true);

      v_tablename := 'om_campaign_x_' || lower(v_feature_type);
      v_field_id  := lower(v_feature_type) || '_id';


    IF TG_OP = 'INSERT' THEN
	    RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        v_querytext := 'UPDATE ' || quote_ident(v_tablename) ||
             ' SET status = $1, admin_observ = $2, org_observ = $3' ||
             ' WHERE campaign_id = $4 AND ' || quote_ident(v_field_id) || ' = $5';

        EXECUTE v_querytext
            USING NEW.status, NEW.admin_observ, NEW.org_observ, OLD.campaign_id, OLD.node_id;

        RETURN NEW;

    END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN NEW;

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;