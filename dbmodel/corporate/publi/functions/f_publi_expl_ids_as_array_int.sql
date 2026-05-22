/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_publi_expl_ids_as_array(_int4);

CREATE OR REPLACE FUNCTION publi.f_publi_expl_ids_as_array(p_expl_ids integer[])
 RETURNS integer[]
 LANGUAGE sql
 IMMUTABLE
AS $function$
    SELECT COALESCE(p_expl_ids, ARRAY[]::integer[]);
$function$
;
