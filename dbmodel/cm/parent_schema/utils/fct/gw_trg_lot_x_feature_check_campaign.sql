/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: NEW CODE FOR THIS FUNCTIN

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_lot_x_feature_check_campaign()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_feature TEXT := TG_ARGV[0];
    v_lot_id INTEGER;
    v_feature_id INTEGER;
    v_campaign_id INTEGER;
    v_exists BOOLEAN;
BEGIN
    -- Get the lot_id and feature_id from the new record
    v_lot_id := NEW.lot_id;
    EXECUTE format('SELECT ($1).%I_id', v_feature)
        INTO v_feature_id
        USING NEW;

    -- Find the campaign assigned to this lot
    SELECT campaign_id INTO v_campaign_id
    FROM SCHEMA_NAME.om_campaign_lot
    WHERE lot_id = v_lot_id;

    IF v_campaign_id IS NULL THEN
        RAISE EXCEPTION 'Lot % does not have an assigned campaign.', v_lot_id;
    END IF;

    -- Check if this feature exists in the campaign
    EXECUTE format(
	    'SELECT EXISTS (
	        SELECT 1 FROM SCHEMA_NAME.om_campaign_x_%I
	         WHERE campaign_id = $1 AND %I_id = $2
	    )',
	    v_feature, v_feature
	)
	INTO v_exists
	USING v_campaign_id, v_feature_id;

    IF NOT v_exists THEN
        RETURN NULL;
    END IF;

    RETURN NEW;
END;
$function$
;
