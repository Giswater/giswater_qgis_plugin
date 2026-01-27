/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg_user2cat_manager(
    p_username text,
    p_role text
)
RETURNS void
LANGUAGE plpgsql
AS $function$

/*
SELECT SCHEMA_NAME.gw_fct_pg_user2cat_manager('postgres', 'role_general');
*/

DECLARE
    v_exists boolean;
    v_idval text;
BEGIN
	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

    -- Remove 'role_' prefix from the role name to obtain idval
    v_idval := regexp_replace(p_role, '^role_', '');

    -- Check that the PostgreSQL user exists and can login
    SELECT TRUE
    INTO v_exists
    FROM pg_roles
    WHERE rolname = p_username
      AND rolcanlogin = TRUE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'User "%" does not exist or cannot login', p_username;
    END IF;

    -- Check that a cat_manager row exists with the derived idval
    IF NOT EXISTS (
        SELECT 1
        FROM cat_manager
        WHERE idval = v_idval
    ) THEN
        RAISE EXCEPTION 'No cat_manager entry found with idval = % (from role %)', v_idval, p_role;
    END IF;

    -- Append the user to the rolename array only if it is not already present
    UPDATE cat_manager
    SET rolename = array_append(rolename, p_username)
    WHERE idval = v_idval
      AND NOT (p_username = ANY (rolename));

END;
$function$;
