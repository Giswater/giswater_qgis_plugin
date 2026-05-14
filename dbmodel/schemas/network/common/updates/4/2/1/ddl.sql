/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

alter table archived_psector_arc add column psector_descript text;
alter table archived_psector_node add column psector_descript text;
alter table archived_psector_connec add column psector_descript text;

DO $$
DECLARE
    r RECORD;
BEGIN
    FOR r IN
        SELECT pg_get_userbyid(member) AS username
        FROM pg_auth_members
        JOIN pg_roles ON pg_roles.oid = pg_auth_members.roleid
        WHERE pg_roles.rolname = 'role_master'
    LOOP
        EXECUTE format('GRANT role_plan TO %I;', r.username);
    END LOOP;
END
$$;
