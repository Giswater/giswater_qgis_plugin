/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3450

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_setcampaign(p_data json)
  RETURNS json AS
$BODY$

DECLARE
    v_status TEXT := 'Accepted';
    v_message JSON;
    v_version JSON;
    v_fields JSON;
    v_client JSON;
    v_campaign_type INT;
    v_reviewclass_id INT;
    v_visitclass_id INT;
    v_querytext TEXT;
    v_schemaname TEXT;
    v_id INTEGER;
    v_newid INTEGER;
    v_exists INTEGER;

BEGIN
    -- Set search path
    SET search_path = cm, public;
    v_schemaname = 'cm';

    -- Get version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM cm.config_param_system WHERE parameter=''admin_version'') row'
    INTO v_version;

    -- Parse input
    v_client := (p_data ->> 'client')::json;
    v_fields := (p_data -> 'data' ->> 'fields')::json;
    v_campaign_type := (p_data -> 'data' ->> 'campaign_type')::int;
	IF (p_data -> 'data' -> 'fields' ->> 'campaign_id') IS NOT NULL THEN
    v_id := (p_data -> 'data' -> 'fields' ->> 'campaign_id')::int;
	END IF;

    -- Parse class ID
    IF v_campaign_type = 1 THEN
        v_reviewclass_id := (v_fields ->> 'reviewclass_id')::int;
    ELSIF v_campaign_type = 2 THEN
        v_visitclass_id := (v_fields ->> 'visitclass_id')::int;
    END IF;

    -- Check if the campaign ID exists
	SELECT campaign_id INTO v_exists FROM om_campaign WHERE campaign_id = v_id;


    IF v_exists IS NULL THEN
	    -- INSERT
	    v_querytext := 'INSERT INTO om_campaign (
	        campaign_id, name, startdate, enddate, real_startdate, real_enddate, campaign_type,
	        descript, active, organization_id, duration, status
	    ) VALUES (' ||
	        v_id || ', ' ||
	        quote_nullable(v_fields ->> 'name') || ', ' ||
	        quote_nullable(v_fields ->> 'startdate') || '::date, ' ||
	        quote_nullable(v_fields ->> 'enddate') || '::date, ' ||
	        quote_nullable(v_fields ->> 'real_startdate') || '::date, ' ||
	        quote_nullable(v_fields ->> 'real_enddate') || '::date, ' ||
	        v_campaign_type || ', ' ||
	        quote_nullable(v_fields ->> 'descript') || ', ' ||
	        (v_fields ->> 'active')::bool || ', ' ||
	        quote_nullable(v_fields ->> 'organization_id') || ', ' ||
	        quote_nullable(v_fields ->> 'duration') || ', ' ||
	        quote_nullable(v_fields ->> 'status') || ') RETURNING campaign_id';
	    EXECUTE v_querytext INTO v_newid;

	    -- Insert into subtype table
	    IF v_campaign_type = 1 THEN
	        INSERT INTO om_campaign_review (campaign_id, reviewclass_id)
	        VALUES (v_newid, v_reviewclass_id);
	    ELSIF v_campaign_type = 2 THEN
	        INSERT INTO om_campaign_visit (campaign_id, visitclass_id)
	        VALUES (v_newid, v_visitclass_id);
	    END IF;

	ELSE
	    -- UPDATE
	    v_querytext := 'UPDATE om_campaign SET ' ||
	    	'name = ' || quote_nullable(v_fields ->> 'name') || ', ' ||
	        'startdate = ' || quote_nullable(v_fields ->> 'startdate') || '::date, ' ||
	        'enddate = ' || quote_nullable(v_fields ->> 'enddate') || '::date, ' ||
	        'real_startdate = ' || quote_nullable(v_fields ->> 'real_startdate') || '::date, ' ||
	        'real_enddate = ' || quote_nullable(v_fields ->> 'real_enddate') || '::date, ' ||
	        'campaign_type = ' || v_campaign_type || ', ' ||
	        'descript = ' || quote_nullable(v_fields ->> 'descript') || ', ' ||
	        'active = ' || (v_fields ->> 'active')::bool || ', ' ||
	        'organization_id = ' || quote_nullable(v_fields ->> 'organization_id') || ', ' ||
	        'duration = ' || quote_nullable(v_fields ->> 'duration') || ', ' ||
	        'status = ' || quote_nullable(v_fields ->> 'status') ||
	        ' WHERE campaign_id = ' || v_id || ' RETURNING campaign_id';
		RAISE NOTICE 'v_querytext de update % ', v_querytext;
	    EXECUTE v_querytext INTO v_newid;
	END IF;

	-- Update selector_campaign for manager users for selected organization and admin users
    EXECUTE 'INSERT INTO selector_campaign (campaign_id, cur_user)
    select '|| v_newid ||', username from cat_user
    join cat_team using (team_id) 
	where (role_id=''role_cm_manager'' and organization_id = ' || quote_nullable(v_fields ->> 'organization_id') || ')
	OR (role_id=''role_cm_admin'')
    ON CONFLICT DO NOTHING;';

    -- Return success response
    RETURN json_build_object(
        'status', v_status,
        'message', 'Campaign saved successfully',
        'version', v_version,
        'body', json_build_object('campaign_id', v_newid)
    );

EXCEPTION WHEN OTHERS THEN
    RETURN json_build_object(
        'status', 'Failed',
        'NOSQLERR', SQLERRM,
        'SQLSTATE', SQLSTATE,
        'version', v_version
    );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
