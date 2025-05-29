/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3410

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_array_fk_array_table()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE

name_id_column text;
name_id_table text;
name_array_column text;
check_array_column record;
all_exist boolean;
v_data_type text;
v_querystring text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    name_array_column := TG_ARGV[0];
    name_id_table := TG_ARGV[1];
    name_id_column := TG_ARGV[2];

    IF name_array_column IS NULL OR name_id_table IS NULL OR name_id_column IS NULL THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3324", "function":"1320"}}$$);';
    END IF;

    EXECUTE format('SELECT ($1).%I', name_array_column) USING NEW INTO check_array_column;

    IF check_array_column IS NULL THEN
        RETURN NEW;
    END IF;


	EXECUTE 'SELECT data_type FROM information_schema.columns WHERE table_schema = $1 AND table_name = $2 AND column_name = $3'
	USING TG_TABLE_SCHEMA, TG_TABLE_NAME, name_array_column
	INTO v_data_type;

	IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN

        IF v_data_type = 'ARRAY' THEN

            v_querystring := format('SELECT NOT EXISTS (SELECT 1 FROM unnest(($1).%I) as arrays
            LEFT JOIN '||name_id_table||' ON arrays = '||name_id_table||'.'||name_id_column||'::int4 WHERE '||name_id_table||'.'||name_id_column||' IS NULL)', name_array_column);

            EXECUTE v_querystring USING NEW INTO all_exist;


        ELSEIF v_data_type = 'integer' THEN

            v_querystring := format('SELECT EXISTS (SELECT 1 FROM '||name_id_table||'
            WHERE '||name_id_table||'.'||name_id_column||'::int4 = ($1).%I)', name_array_column);

            EXECUTE v_querystring USING NEW INTO all_exist;

        END IF;

		IF all_exist IS FALSE THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3326", "function":"1320", "parameters":{"array_column":"'||name_array_column||'", "id_table":"'||name_id_table||'", "id_column":"'||name_id_column||'"}}}$$);';
		END IF;

		RETURN NEW;
	END IF;
END;
$function$
;
