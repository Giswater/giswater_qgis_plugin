CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_json_object_set_key"(json json, key_to_set text, value_to_set anyelement) RETURNS pg_catalog.json AS $BODY$
DECLARE

    res_json json;
    
BEGIN

--RAISE NOTICE 'json: %, key_to_set: %, value_to_set: %', json, key_to_set, value_to_set;

    SELECT concat('{', string_agg(to_json("key") || ':' || "value", ','), '}')::json
        INTO res_json
        FROM (SELECT * FROM json_each("json") WHERE "key" <> "key_to_set" 
        UNION ALL
        SELECT "key_to_set", to_json("value_to_set")) AS "fields";

    RETURN res_json;
  END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

