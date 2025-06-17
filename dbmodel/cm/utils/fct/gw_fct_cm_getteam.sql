/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3434

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_getteam(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_campaign_id integer;
    v_result json;
   v_orgname TEXT;
BEGIN

    -- Extract campaign_id from the input JSON
    v_campaign_id := (p_data->>'p_campaign_id')::integer;
   RAISE NOTICE 'v_campaign_id:: %', v_campaign_id;

    -- If no campaign_id is found, return empty
    IF v_campaign_id IS NULL THEN
        RETURN '{"status": "Accepted", "body": {"data": []}}'::json;
    END IF;

   SELECT orgname INTO v_orgname
   FROM cm.om_campaign oc
   JOIN cm.cat_organization co ON co.organization_id = oc.organization_id
   WHERE oc.campaign_id = v_campaign_id;

  -- Assumed that OWNER text is the administrators
  	IF v_orgname = 'OWNER' THEN
    	-- Return teams that match the criteria
	    SELECT json_build_object(
	        'status', 'Accepted',
	        'body', json_build_object(
	        	'data', json_agg(
		            json_build_object('id', ct.team_id, 'idval', ct.teamname)
		        )
	        )
	    )
	    INTO v_result
	    FROM cm.cat_team AS ct
	    WHERE ct.role_id <> 'role_cm_admin'; -- ASSUMED
	ELSE
		-- Return teams that match the criteria
	    SELECT json_build_object(
	        'status', 'Accepted',
	        'body', json_build_object(
	        	'data', json_agg(
		            json_build_object('id', ct.team_id, 'idval', ct.teamname)
		        )
	        )
	    )
	    INTO v_result
	    FROM cm.cat_team AS ct
	    JOIN cm.om_campaign AS oc ON ct.organization_id = oc.organization_id
	    WHERE oc.campaign_id = v_campaign_id
	   	AND ct.role_id = 'role_cm_field'; -- ASSUMED
     END IF;

     RAISE NOTICE 'v_result->: %', v_result->'body'->'data';

    IF v_result->'body'->>'data' IS NULL THEN
     	RETURN '{"status": "Accepted", "body": {"data": [{"id": "", "idval": ""}]}}'::json;
	ELSE
	    RETURN COALESCE(v_result, '{"status": "Accepted", "body": {"data": [{"id": "", "idval": ""}]}}'::json);
	END IF;


END;
$function$
;
