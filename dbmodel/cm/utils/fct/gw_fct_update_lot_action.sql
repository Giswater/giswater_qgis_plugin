/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: xxxxx

CREATE OR REPLACE FUNCTION cm.gw_trg_update_lot_action()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_role_name TEXT;
    v_user_role_name TEXT;
BEGIN
    v_role_name = 'role_cm_field';

    -- Get the role name for the current user by joining user -> team -> role
    SELECT r.role_id INTO v_user_role_name
    FROM cm.cat_user u
    JOIN cm.cat_team t ON u.team_id = t.team_id
    JOIN cm.cat_role r ON t.role_id = r.role_id
    WHERE u.username = current_user;

    -- Only proceed if the user's role is 'field'
    IF v_role_name = v_user_role_name THEN
        IF TG_OP = 'INSERT' THEN
            NEW.action = 1;
        ELSIF TG_OP = 'UPDATE' THEN
            -- Only update the action if the row is actually changing
            IF NEW IS DISTINCT FROM OLD THEN
                NEW.action = 2;
            END IF;
        END IF;
    END IF;

    -- Return the modified row to be inserted/updated
    RETURN NEW;
END;
$function$
;
