/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION publi.f_publi_match_feature_expl(text, _int4, _int4);

CREATE OR REPLACE FUNCTION publi.f_publi_match_feature_expl(p_source_schema text, p_expl_ids integer[], p_expl_visibility integer[])
 RETURNS boolean
 LANGUAGE sql
 STABLE
AS $function$
    SELECT publi.f_publi_allowed_expl_ids(p_source_schema)
        && (
            COALESCE(p_expl_visibility, ARRAY[]::integer[])
            || publi.f_publi_expl_ids_as_array(p_expl_ids)
        );
$function$
;
