/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3412

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_array_fk_id_table()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE

name_id_column text;
tables_to_search json;
table_name text;
column_name text;
old_id text;
new_id text;
_key text;
_value text;
v_data_type text;
exists_in_foreign_table boolean;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

	name_id_column := TG_ARGV[0];
    tables_to_search := TG_ARGV[1];


    IF name_id_column IS NULL OR tables_to_search IS NULL THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3324", "function":"1320"}}$$);';
    END IF;

    FOR _key, _value IN SELECT * FROM json_each_text(tables_to_search) LOOP
        table_name := _key;
        column_name := _value;

        EXECUTE 'SELECT data_type FROM information_schema.columns WHERE table_schema = $1 AND table_name = $2 AND column_name = $3'
		USING TG_TABLE_SCHEMA, table_name, column_name
		INTO v_data_type;

        EXECUTE format('SELECT $1.%I, $2.%I', name_id_column, name_id_column)
        USING OLD, NEW
        INTO old_id, new_id;

        IF v_data_type = 'ARRAY' THEN
            IF TG_OP = 'UPDATE' THEN


                EXECUTE format('UPDATE %I SET %I = array_replace(%I, $1, $2) WHERE $1 = ANY(%I)', table_name, column_name, column_name, column_name)
                USING old_id::int4, new_id::int4;

            ELSEIF TG_OP = 'DELETE' THEN
                EXECUTE format('SELECT EXISTS(SELECT 1 FROM %I WHERE $1 = ANY(%I))', table_name, column_name)
                USING old_id::int4
                INTO exists_in_foreign_table;

                IF exists_in_foreign_table IS TRUE THEN
                    EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3328", "function":"1320"}}$$);';
                END IF;
            END IF;
        ELSEIF v_data_type = 'integer' THEN
            IF TG_OP = 'UPDATE' THEN
                EXECUTE format('UPDATE %I SET %I = $2 WHERE $1 = %I', table_name, column_name, column_name)
                USING old_id::int4, new_id::int4;
            ELSEIF TG_OP = 'DELETE' THEN
                EXECUTE format('SELECT EXISTS(SELECT 1 FROM %I WHERE $1 = %I)', table_name, column_name)
                USING old_id::int4
                INTO exists_in_foreign_table;

                IF exists_in_foreign_table IS TRUE THEN
                    EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3328", "function":"1320"}}$$);';
                END IF;
            END IF;
        END IF;
    END LOOP;

    IF TG_OP = 'UPDATE' THEN
        RETURN NEW;
    ELSEIF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
END;
$function$
;
