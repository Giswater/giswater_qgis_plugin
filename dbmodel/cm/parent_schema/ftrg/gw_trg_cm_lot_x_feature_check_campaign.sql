/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3478

CREATE OR REPLACE FUNCTION cm.gw_trg_cm_lot_x_feature_check_campaign()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_feature TEXT := TG_ARGV[0];
    v_lot_id INTEGER;
    v_feature_id INTEGER;
    v_campaign_id INTEGER;
    v_exists BOOLEAN;
	v_new_feature BOOLEAN := false;
	v_prev_search_path text;
BEGIN
    v_prev_search_path := current_setting('search_path');
    PERFORM set_config('search_path', format('%I, public', TG_TABLE_SCHEMA), true);

    -- Get the lot_id and feature_id from the new record
    v_lot_id := NEW.lot_id;
    EXECUTE format('SELECT ($1).%I_id', v_feature)
        INTO v_feature_id
        USING NEW;

    -- Find the campaign assigned to this lot
    SELECT campaign_id INTO v_campaign_id
    FROM cm.om_campaign_lot
    WHERE lot_id = v_lot_id;

    IF v_campaign_id IS NULL THEN
        RAISE EXCEPTION 'Lot % does not have an assigned campaign.', v_lot_id;
    END IF;

    -- Check if this feature exists in the campaign
    EXECUTE format(
	    'SELECT EXISTS (
	        SELECT 1 FROM cm.om_campaign_x_%I
	         WHERE campaign_id = $1 AND %I_id = $2
	    )',
	    v_feature, v_feature
	)
	INTO v_exists
	USING v_campaign_id, v_feature_id;
	
	-- Exception for new feature coming from other app, using a '-' id
	EXECUTE format('SELECT ($1).%I_id::text LIKE ''-%%''', v_feature)
	INTO v_new_feature
	USING NEW;
	
	IF v_new_feature THEN
		EXECUTE format('INSERT INTO cm.om_campaign_x_%I (campaign_id, %I_id, status)
		     VALUES ($1, $2, $3)',
		    v_feature, v_feature)
		USING v_campaign_id, v_feature_id, NEW.status;

		PERFORM set_config('search_path', v_prev_search_path, true);
	    RETURN NEW;
	END IF;

    IF NOT v_exists THEN
        PERFORM set_config('search_path', v_prev_search_path, true);
        RETURN NULL;
    END IF;

    PERFORM set_config('search_path', v_prev_search_path, true);
    RETURN NEW;

EXCEPTION WHEN OTHERS THEN
    PERFORM set_config('search_path', v_prev_search_path, true);
    RAISE;
END;
$function$
;
