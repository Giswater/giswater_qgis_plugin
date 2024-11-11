/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2624
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_json_object_delete_keys(json, text[]);
CREATE OR REPLACE FUNCTION SCHEMA_NAME."gw_fct_json_object_delete_keys"(p_json json, VARIADIC "keys_to_delete" TEXT[])
  RETURNS json
  LANGUAGE sql
  IMMUTABLE
  STRICT
AS $function$
SELECT COALESCE(
  (SELECT ('{' || string_agg(to_json("key") || ':' || "value", ',') || '}')
   FROM json_each("p_json")
   WHERE "key" <> ALL ("keys_to_delete")),
  '{}'
)::json
$function$;