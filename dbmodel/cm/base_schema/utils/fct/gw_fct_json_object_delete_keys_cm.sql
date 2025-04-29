CREATE OR REPLACE FUNCTION cm.gw_fct_json_object_delete_keys_cm(p_json json, VARIADIC keys_to_delete text[])
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
