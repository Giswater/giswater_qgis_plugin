/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3352

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_trg_cat_material_fk()
  RETURNS trigger AS
$BODY$

DECLARE
    v_table text;
    v_insert_table text;
    v_new_data jsonb;
    v_type_table text;
    v_columname_table text;
    v_feature_type text;
    v_feature_type_value text;
    v_matcat_id text;
    v_matcat_id_value text;
    v_querytext text;
    v_list TEXT[];

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';

    v_table := TG_ARGV[0]; -- 'ARC', 'NODE', 'CONNEC', 'GULLY', 'ELEMENT'
	v_insert_table := 'cat_' || v_table || '/' || v_table;

	--insert new fields values into json
    v_new_data := to_jsonb(NEW);

	v_type_table := 'cat_material';
    v_columname_table := 'id';

	--v_cat_table := 'cat_' || v_table;
    v_feature_type := v_table || '_type';
	v_feature_type_value := v_new_data ->> v_feature_type;
	v_matcat_id := 'matcat_id';
    v_matcat_id_value := v_new_data ->> v_matcat_id;

	--select typevalue
	v_querytext = 'SELECT array_agg('||v_columname_table||') FROM '||v_type_table||' 
									WHERE active IS TRUE
									AND (
										feature_type IS NULL
										OR '''||upper(v_table)||''' = ANY(feature_type)
									)
									AND (
										featurecat_id IS NULL
										OR '''||v_feature_type_value||''' = ANY(featurecat_id)
									)';
	EXECUTE v_querytext INTO v_list;

	IF v_matcat_id_value = ANY(v_list) OR v_matcat_id_value IS NULL THEN
		RETURN NULL;
	ELSE
		v_matcat_id_value = REPLACE(v_matcat_id_value, '"', '\"');
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3022", "function":"3352","parameters":{"catalog":"'||concat('Catalog: ', v_type_table,', insert table: ',v_insert_table, ', field: ',v_matcat_id,', value: ', v_matcat_id_value)||'"}}}$$);';
	END IF;

	RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

