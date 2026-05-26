/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3346

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_mantypevalue_fk()
  RETURNS trigger AS
$BODY$

DECLARE

    v_table text;
    v_new_data jsonb;
	v_old_data jsonb;
    v_type_table text;
	v_type text;
	v_cat_table text;
    v_columname text;
	v_new_columname_value text;
	v_old_columname_value text;
    v_feature_type text;
    v_feature_type_value text;
	v_featurecat_id text;
	v_featurecat_id_value text;
    v_querytext text;
    v_list TEXT[];
	v_array_tables text[];
	v_array_types text[];
	v_project_type text;
BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;

    v_table := TG_ARGV[0]; -- 'ARC', 'CONNEC', 'NODE', 'GULLY', 'man_type_category', 'man_type_fluid', 'man_type_function', 'man_type_location'

	--insert new fields values into json
    v_new_data := to_jsonb(NEW);
	v_old_data := to_jsonb(OLD);

	IF upper(v_table) IN ('ARC', 'CONNEC', 'NODE', 'GULLY') THEN
		IF v_project_type = 'UD' THEN 
			v_array_types := ARRAY['function', 'category', 'location'];
		ELSE 
			v_array_types := ARRAY['function', 'category', 'location', 'fluid'];
		END IF;
		FOR v_type IN SELECT unnest(v_array_types)
		LOOP
			v_type_table := 'man_type_' || v_type;
			v_columname := v_type || '_type';
			v_new_columname_value := v_new_data ->> v_columname;
			v_cat_table := 'cat_' || v_table;
			v_feature_type := v_table || '_type';
			v_featurecat_id := v_table || 'cat_id';
			v_featurecat_id_value := v_new_data ->> v_featurecat_id;

			--select feature_type
			v_querytext = 'SELECT '||v_feature_type||' FROM '||v_cat_table||' WHERE id = '''||v_featurecat_id_value||'''';
			EXECUTE v_querytext INTO v_feature_type_value;

			--select typevalue
			v_querytext = 'SELECT array_agg('||v_columname||') FROM '||v_type_table||' 
							WHERE active IS TRUE
							AND '''||upper(v_table)||''' = ANY(feature_type)
							AND (
								featurecat_id IS NULL
								OR '''||v_feature_type_value||''' = ANY(featurecat_id)
							)';
			EXECUTE v_querytext INTO v_list;

			IF v_new_columname_value = ANY(v_list) OR v_new_columname_value IS NULL THEN
				CONTINUE;
			ELSE
				v_new_columname_value = REPLACE(v_new_columname_value, '"', '\"');
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3022", "function":"2744","parameters":{"catalog":"'||concat('Catalog: ', v_type_table,', insert table: ',v_table, ', field: ',v_columname,', value: ', v_new_columname_value)||'"}}}$$);';
			END IF;
		END LOOP;
	ELSIF v_table IN ('man_type_category', 'man_type_fluid', 'man_type_function', 'man_type_location') THEN
		v_columname := TG_ARGV[1]; -- 'category_type', 'fluid_type', 'function_type', 'location_type'
		IF v_project_type = 'UD' THEN 
			v_array_tables := ARRAY['node', 'arc', 'connec', 'gully'];
		ELSE 
			v_array_tables := ARRAY['node', 'arc', 'connec'];
		END IF;

		FOR v_type IN SELECT unnest(v_array_tables)
		LOOP
			v_type_table := v_type;
			v_new_columname_value := v_new_data ->> v_columname;
			v_old_columname_value := v_old_data ->> v_columname;	
			
			IF v_new_columname_value = v_old_columname_value THEN
				CONTINUE;
			END IF;
			EXECUTE format('
				UPDATE %I SET %I = %L WHERE %I = %L;
			', v_type_table, v_columname, v_new_columname_value, v_columname, v_old_columname_value);
		END LOOP;
	END IF;

	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;