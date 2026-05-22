/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_publi_rls_bypass();

CREATE OR REPLACE FUNCTION publi.f_publi_rls_bypass()
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
    SELECT pg_has_role(current_user, 'role_general'::name, 'member')
        OR lower(COALESCE(nullif(trim(current_setting('giswater.publi_rls_bypass', true)), ''), 'off')) IN
           ('1', 'true', 'on', 'yes');
$function$
;
