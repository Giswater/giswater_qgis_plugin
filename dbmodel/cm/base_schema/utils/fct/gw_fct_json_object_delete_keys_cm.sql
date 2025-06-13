/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3446

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_json_object_delete_keys_cm(p_json json, VARIADIC keys_to_delete text[])
 RETURNS json
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$
SELECT COALESCE(
  (SELECT ('{' || string_agg(to_json("key") || ':' || "value", ',') || '}')
   FROM json_each("p_json")
   WHERE "key" <> ALL ("keys_to_delete")),
  '{}'
)::json
$function$
;
