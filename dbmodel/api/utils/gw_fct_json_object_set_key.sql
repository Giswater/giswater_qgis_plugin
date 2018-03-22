
CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_json_object_set_key"(json json, key_to_set text, value_to_set anyelement) RETURNS pg_catalog.json AS $BODY$
BEGIN
	SELECT concat('{', string_agg(to_json("key") || ':' || "value", ','), '}')::json
	FROM (SELECT *
          FROM json_each("json")
         WHERE "key" <> "key_to_set"
         UNION ALL
        SELECT "key_to_set", to_json("value_to_set")) AS "fields";
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

