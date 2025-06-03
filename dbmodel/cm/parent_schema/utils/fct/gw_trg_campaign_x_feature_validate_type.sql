/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: NEW CODE FOR THIS FUNCTIN

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type() CASCADE;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_campaign_x_feature_validate_type()
 RETURNS trigger AS
$BODY$

DECLARE
    v_feature TEXT := TG_ARGV[0];
    v_feature_types_allowed json;
    v_feature_type TEXT;
    v_allowed boolean;
    v_object_id TEXT;
    v_sql TEXT;


BEGIN

    -- Get allowed object_ids (feature_type list)
    SELECT to_json(array_agg(object_id)) INTO v_feature_types_allowed
    FROM SCHEMA_NAME.om_campaign oc 
    JOIN SCHEMA_NAME.om_campaign_review ocr ON oc.campaign_id = ocr.campaign_id 
    JOIN SCHEMA_NAME.om_reviewclass_x_object orxo ON ocr.reviewclass_id = orxo.reviewclass_id 
    WHERE oc.campaign_id = NEW.campaign_id;

    -- Get the dynamic ID value from NEW
    EXECUTE format('SELECT ($1).%I', v_feature || '_id')
    INTO v_object_id
    USING NEW;


    -- Get the feature type (dynamic)
    v_sql := format(
        'SELECT c.%I_type
         FROM PARENT_SCHEMA.%I p 
         JOIN PARENT_SCHEMA.cat_%I c ON p.%Icat_id = c.id 
         WHERE p.%I_id = $1::integer',
        v_feature, v_feature, v_feature, v_feature, v_feature
    );

    EXECUTE v_sql
    INTO v_feature_type
    USING v_object_id;

    -- Check if allowed
    SELECT EXISTS (
        SELECT 1
        FROM json_array_elements_text(v_feature_types_allowed) AS t(object_id)
        WHERE t.object_id = v_feature_type
    )
    INTO v_allowed;


    -- If not allowed, skip insert
    IF NOT v_allowed THEN
        RAISE NOTICE 'Insert skipped → feature_type not allowed.';
        RETURN NULL;
    END IF;

    RAISE NOTICE 'Insert accepted → feature_type allowed.';
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;