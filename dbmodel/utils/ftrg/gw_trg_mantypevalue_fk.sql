/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_mantypevalue_fk()
  RETURNS trigger AS
$BODY$

DECLARE

    v_table text;
    v_new_data jsonb;
    v_type_table text;
	v_type text;
    v_columname text;
	v_columname_value text;
    v_feature_type text;
    v_feature_type_value text;
    v_querytext text;
    v_list TEXT[];

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    v_table := TG_ARGV[0]; -- 'ARC', 'CONNEC', 'NODE', 'GULLY'

	--insert new fields values into json
    v_new_data := to_jsonb(NEW);

    FOR v_type IN SELECT unnest(ARRAY['function', 'category', 'fluid', 'location'])
	LOOP
		v_type_table := 'man_type_' || v_type;
        v_columname := v_type || '_type';
		v_columname_value := v_new_data ->> v_columname;
        v_feature_type := v_table || '_type';
        v_feature_type_value := v_new_data ->> v_feature_type;


		--select typevalue
		v_querytext = 'SELECT array_agg('||v_columname||') FROM '||v_type_table||' 
						WHERE active IS TRUE
						AND feature_type = '''||upper(v_table)||'''
						AND (
							featurecat_id IS NULL
							OR '''||v_feature_type_value||''' = ANY(featurecat_id)
						)';
		RAISE NOTICE 'v_querytext: %', v_querytext;
		EXECUTE v_querytext INTO v_list;

		IF v_columname_value = ANY(v_list) OR v_columname_value IS NULL THEN
			CONTINUE;
		ELSE
			v_columname_value = REPLACE(v_columname_value, '"', '\"');
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			"data":{"message":"3022", "function":"2744","debug_msg":
			"'||concat('Catalog: ', v_type_table,', insert table: ',v_table, ', field: ',v_columname,', value: ', v_columname_value)||'"}}$$);';
		END IF;
	END LOOP;

	RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;