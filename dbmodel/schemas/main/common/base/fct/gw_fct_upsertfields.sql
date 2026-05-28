/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3246

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_upsertfields(p_data json)
  RETURNS json AS
$BODY$

/* example

-- FEATURE
SELECT SCHEMA_NAME.gw_fct_upsertfields($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"featureType":"node", "tableName":"ve_man_junction", "id":"1251521"},
"data":{"fields":{"macrosector_id": "1", "sector_id": "2",
"inventory": "False", "epa_type": "PUMP", "state": "1", "arc_id": "113854", "publish": "False", "verified": "TO REVIEW",
"expl_id": "1", "builtdate": "2018/11/29", "muni_id": "2", "workcat_id": "22", "buildercat_id": "builder1", "enddate": "2018/11/29",
"soilcat_id": "soil1", "ownercat_id": "owner1", "workcat_id_end": "22"}}}$$)

-- VISIT
SELECT SCHEMA_NAME.gw_fct_upsertfields('
 {"client":{"device":4, "infoType":1, "lang":"ES"},
 "feature":{"featureType":"arc", "tableName":"ve_visit_multievent_x_arc", "id":1135},
 "data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":1000, "desperfectes_arc":1, "neteja_arc":3},
 "deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}')

-- MAPZONES
SELECT gw_fct_upsertfields($${"client":{"device":4, "infoType":1, "lang":"ES","epsg":SRID_VALUE}, "form":{},
"feature":{"id":"1295", "tableName":"ve_node_valvula", "featureType":"node" }, "data":{"filterFields":{}, "pageInfo":{}, "fields":{"closed": "False"}, "afterInsert":"False"}}$$)

*/

DECLARE

v_device integer;
v_infotype integer;
v_tablename text;
v_id  character varying;
v_fields json;
v_columntype character varying;
v_querytext varchar;
v_idname varchar;
column_type_id character varying;
v_version text;
v_text text[];
text text;
i integer=1;
n integer=1;
v_field text;
v_value text;
v_return text;
v_schemaname text;
v_featuretype text;
v_jsonfield json;
v_fieldsreload text;
v_columnfromid json;
v_projecttype text;
v_closedstatus boolean;
v_message json;
v_afterinsert boolean;
v_addparam json;
v_idname_array text[];
v_id_array text[];
column_type_id_array text[];
idname text;
v_result record;
v_force_action text;
v_pkeyfield text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

        -- get project type
        v_projecttype = (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
	p_data = REPLACE (p_data::text, '''''', 'null');

	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_featuretype := (p_data ->> 'feature')::json->> 'featureType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_idname := (p_data ->> 'feature')::json->> 'idName';
	v_fields := ((p_data ->> 'data')::json->> 'fields')::json;
	v_force_action := ((p_data ->> 'data')::json->> 'force_action');
	v_fieldsreload := (p_data ->> 'data')::json->> 'reload';
	v_afterinsert := json_extract_path_text (p_data,'data','afterInsert')::text;

	select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;

	-- Manage primary key
	EXECUTE 'SELECT addparam FROM sys_table WHERE id = $1' INTO v_addparam USING v_tablename;
	v_idname_array := string_to_array(v_idname, ', ');
	if v_idname_array is null THEN
		EXECUTE 'SELECT gw_fct_getpkeyfield('''||v_tablename||''');' INTO v_pkeyfield;
		v_idname_array := string_to_array(v_pkeyfield, ', ');
	end if;

	v_id_array := string_to_array(v_id, ', ');

	if v_idname_array is not null then
		FOREACH idname IN ARRAY v_idname_array LOOP
			EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
			    JOIN pg_class t on a.attrelid = t.oid
			    JOIN pg_namespace s on t.relnamespace = s.oid
			    WHERE a.attnum > 0
			    AND NOT a.attisdropped
			    AND a.attname = $3
			    AND t.relname = $2
			    AND s.nspname = $1
			    ORDER BY a.attnum'
		    USING v_schemaname, v_tablename, idname
		    INTO column_type_id;
			column_type_id_array[i] := column_type_id;
			i=i+1;
		END LOOP;
	else

		--   Get id column type
		EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
		    JOIN pg_class t on a.attrelid = t.oid
		    JOIN pg_namespace s on t.relnamespace = s.oid
		    WHERE a.attnum > 0
		    AND NOT a.attisdropped
		    AND a.attname = $3
		    AND t.relname = $2
		    AND s.nspname = $1
		    ORDER BY a.attnum'
            USING v_schemaname, v_tablename, v_idname
            INTO column_type_id;
	end if;

    IF v_force_action IS NULL THEN

        v_querytext := 'SELECT * FROM ' || quote_ident(v_tablename);

        if v_idname_array is null then
        	v_idname_array := string_to_array(v_idname, ', ');
        	v_id_array := string_to_array(v_id, ', ');
        end if;

        IF cardinality(v_idname_array) > 0 AND cardinality(v_id_array) > 0 then

            i = 1;
            v_querytext := v_querytext || ' WHERE ';
            FOREACH idname IN ARRAY v_idname_array loop
                v_querytext := v_querytext || quote_ident(idname) || ' = CAST(' || quote_literal(v_id_array[i]) || ' AS ' || column_type_id_array[i] || ') AND ';
                i=i+1;
            END LOOP;
            v_querytext = substring(v_querytext, 0, length(v_querytext)-4);
        ELSIF cardinality(v_idname_array) > 0 then

            i = 1;
            v_querytext := v_querytext || ' WHERE ';
            FOREACH idname IN ARRAY v_idname_array loop
                v_querytext := v_querytext || quote_ident(idname) || ' = CAST(' || quote_literal(v_fields->>idname) || ' AS ' || column_type_id_array[i] || ') AND ';
                i=i+1;
            END LOOP;
            v_querytext = substring(v_querytext, 0, length(v_querytext)-4);
        ELSE
            v_querytext := v_querytext || ' WHERE ' || quote_ident(v_idname) || ' = CAST(' || quote_literal(v_id) || ' AS ' || column_type_id || ')';
        END IF;

       	EXECUTE v_querytext INTO v_result;

    END IF;

    -- updating p_data setting idName
    IF v_force_action = 'INSERT' OR (v_force_action IS NULL AND v_result IS NULL) THEN
        p_data := (gw_fct_json_object_set_key(p_data, 'feature', gw_fct_json_object_set_key((p_data->>'feature')::json, 'idName', v_idname)));
    END IF;

    RETURN CASE
        WHEN v_force_action = 'INSERT' THEN gw_fct_setinsert(p_data)
        WHEN v_force_action = 'UPDATE' THEN gw_fct_setfields(p_data)
        WHEN v_result IS NULL THEN gw_fct_setinsert(p_data)
        ELSE gw_fct_setfields(p_data)
    END;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN json_build_object('status', 'Failed', 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM),  'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;