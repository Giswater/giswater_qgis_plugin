/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: NEW CODE FOR THIS FUNCTION

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getcmteam(
    p_data json
)
RETURNS json AS $$
DECLARE
    v_campaign_id integer;
    v_result json;
    v_user_org_id integer;
    v_user_org_name text;
BEGIN

    -- Get user organization
    SELECT u.organization_id, o.name
    INTO v_user_org_id, v_user_org_name
    FROM SCHEMA_NAME.v_user u
    JOIN SCHEMA_NAME.cat_organization o ON u.organization_id = o.organization_id
    WHERE u.username = current_user;

    -- Extract campaign_id from the input JSON
    v_campaign_id := (p_data->>'p_campaign_id')::integer;

    -- If user's organization is OWNER, return all teams from their organization
    IF v_user_org_name = 'OWNER' THEN
        SELECT json_build_object(
            'status', 'Accepted',
            'body', json_agg(
                json_build_object('id', ct.team_id, 'idval', ct.teamname)
            )
        )
        INTO v_result
        FROM cat_team AS ct
        WHERE ct.organization_id = v_user_org_id
          AND ct.role_id = 'role_cm_field';

    ELSE
        -- If no campaign_id is found, return empty
        IF v_campaign_id IS NULL THEN
            RETURN '{"status": "Accepted", "body": []}'::json;
        END IF;

        -- Return teams that match the criteria
        SELECT json_build_object(
            'status', 'Accepted',
            'body', json_agg(
                json_build_object('id', ct.team_id, 'idval', ct.teamname)
            )
        )
        INTO v_result
        FROM cat_team AS ct
        JOIN om_campaign AS oc ON ct.organization_id = oc.organization_id
        WHERE oc.campaign_id = v_campaign_id
          AND ct.role_id = 'role_cm_field';
    END IF;

    RETURN COALESCE(v_result, '{"status": "Accepted", "body": []}'::json);

END;
$$ LANGUAGE plpgsql;
