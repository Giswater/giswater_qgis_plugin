/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


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

-- Fix nulls
    IF value_to_set::TEXT = 'NULL' THEN
        res_json := replace(res_json::TEXT, '"NULL"', 'null')::json;
    END IF;

    RETURN res_json;
  END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

