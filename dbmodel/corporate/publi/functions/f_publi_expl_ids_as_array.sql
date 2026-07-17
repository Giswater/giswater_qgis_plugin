/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_publi_expl_ids_as_array(int4);

CREATE OR REPLACE FUNCTION publi.f_publi_expl_ids_as_array(p_expl_id integer)
 RETURNS integer[]
 LANGUAGE sql
 IMMUTABLE
AS $function$
    SELECT CASE
        WHEN p_expl_id IS NULL THEN ARRAY[]::integer[]
        ELSE ARRAY[p_expl_id]
    END;
$function$
;
