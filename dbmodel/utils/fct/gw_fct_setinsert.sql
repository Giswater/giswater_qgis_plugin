/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2616

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setinsert(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/* example
-- Indirects
visit: (query used on setvisit function, not direct from client)
SELECT "SCHEMA_NAME".gw_fct_setinsert($${"client":{"device":4, "infoType":1, "lang":"ES"},
	"feature":{"featureType":"visit", "tableName":"ve_visit_arc_insp", "id":null, "idName": "visit_id"},
	"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":10, "desperfectes_arc":1, "neteja_arc":3},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)

file: (query used on setfileinsert function, not direct from client)
SELECT "SCHEMA_NAME".gw_fct_setinsert($${"client":{"device":4, "infoType":1, "lang":"ES"},
	"feature":{"featureType":"file","tableName":"om_visit_file", "id":null, "idName": "id"},
	"data":{"fields":{"visit_id":1, "hash":"testhash", "url":"urltest", "filetype":"png"},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)

-- directs
feature:
SELECT "SCHEMA_NAME".gw_fct_setinsert($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"featureType":"node", "tableName":"ve_node", "id":"1251521", "idName": "node_id"},
	"data":{"fields":{"macrosector_id": "1", "sector_id": "2", "nodecat_id":"JUNCTION DN63", "dma_id":"2", "inventory": "False",
		"epa_type": "JUNCTION", "state": "1", "arc_id": "113854", "publish": "False", "verified": "TO REVIEW",
		"expl_id": "1", "builtdate": "2018/11/29", "muni_id": "2", "workcat_id": null, "buildercat_id": "builder1", "enddate": "2018/11/29",
		"soilcat_id": "soil1", "ownercat_id": "owner1", "workcat_id_end": "22", "the_geom":"0101000020E7640000C66DDE79D9961941A771508A59755151"},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)

any row, any element:

*/

DECLARE

v_device integer;
v_infotype integer;
v_tablename text;
v_id  character varying;
v_fields json;
v_columntype character varying;
v_querytext varchar;
v_columntype_id character varying;
v_version text;
v_text text[];
v_jsonfield json;
text text;
i integer=1;
v_field text;
v_value text;
v_return text;
v_schemaname text;
v_type text;
v_epsg integer;
v_newid text;
v_idname text;
v_feature json;
v_message json;
v_first boolean;
v_error_context text;
v_addparam json;
v_idname_array text[];
v_id_array text[];
column_type_id_array text[];
idname text;
column_type_id character varying;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Get paramters
	EXECUTE 'SELECT epsg FROM sys_version' INTO v_epsg;
	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
        p_data = REPLACE (p_data::text, '''''', 'null');

	-- Get input parameters:
	v_feature  := (p_data ->> 'feature');
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_idname := (p_data ->> 'feature')::json->> 'idName';
	v_fields := ((p_data ->> 'data')::json->> 'fields')::json;

	select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;

	-- Get if view has composite primary key
	IF v_idname ISNULL THEN

		-- Manage primary key
		EXECUTE 'SELECT addparam FROM sys_table WHERE id = $1' INTO v_addparam USING v_tablename;
		v_idname_array := string_to_array(v_idname, ', ');
		if v_idname_array is null THEN
			EXECUTE 'SELECT gw_fct_getpkeyfield('''||v_tablename||''');' INTO v_idname;
			v_idname_array := string_to_array(v_idname, ', ');
		end if;

		v_id_array := string_to_array(v_id, ', ');
		IF v_idname IS NOT NULL then

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
		END IF;
	END IF;

	--  Get id column, for tables is the key column
	IF v_idname ISNULL THEN
		EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
	        INTO v_idname
	        USING v_tablename;
    END IF;

	-- For views it suposse pk is the first column
	IF v_idname ISNULL THEN
		EXECUTE '
		SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_idname
		USING v_tablename, v_schemaname;
	END IF;

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

	-- query text, step1
	v_querytext := 'INSERT INTO ' || quote_ident(v_tablename) ||' (';

	-- query text, step2
	i=1;
	v_first=FALSE;
	FOREACH text IN ARRAY v_text
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ; -- getting v_value in order to prevent null values

		IF v_value !='null' OR v_value !='NULL' OR v_value IS NOT NULL THEN
			IF v_tablename = 'om_visit' AND v_field = 'visit_id' THEN
				v_field := 'id';
			ELSIF v_field = 'sys_pol_id' THEN
				v_field := 'pol_id';
			END IF;
			--building the query text
			IF i=1 OR v_first IS FALSE THEN
				v_querytext := concat (v_querytext, v_field);
				v_first = TRUE;
			ELSIF i>1 THEN
				v_querytext := concat (v_querytext, ', ', quote_ident(v_field));
			END IF;

		END IF;
		i=i+1;
	END LOOP;

	-- query text, step3
	v_querytext := concat (v_querytext, ') VALUES (');

	-- query text, step4
	i=1;
	v_first=FALSE;
	FOREACH text IN ARRAY v_text
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ;

		IF v_tablename = 'om_visit' AND v_field = 'visit_id' THEN
				v_field := 'id';
			ELSIF v_field = 'sys_pol_id' THEN
				v_field := 'pol_id';
			END IF;

		-- Get column type
		EXECUTE 'SELECT udt_name::regtype as data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_tablename) || ' AND column_name = $2'
			USING v_schemaname, v_field
			INTO v_columntype;

		-- control column_type
		IF v_columntype IS NULL THEN
			v_columntype='text';
		END IF;

		-- control geometry fields
		IF v_field ='the_geom' OR v_field ='geom' THEN
			v_columntype='geometry';
		END IF;

		-- Handle array types - format value with curly braces if it's an array
		IF v_columntype LIKE '%[]' AND v_value IS NOT NULL AND v_value != '' THEN
			-- Replace [ with { and ] with } for array input
			IF v_value LIKE '[%' THEN
				v_value := replace(replace(v_value, '[', '{'), ']', '}');
			ELSIF v_value NOT LIKE '{%}' THEN
				v_value := '{' || v_value || '}';
			END IF;
		END IF;

		IF v_value !='null' OR v_value !='NULL' THEN

			IF v_field in ('geom', 'the_geom') THEN
				v_value := (SELECT ST_SetSRID((v_value)::geometry, v_epsg));
			END IF;
			--building the query text
			IF i=1 OR v_first IS FALSE THEN
				v_querytext := concat (v_querytext, quote_literal(v_value),'::',v_columntype);
				v_first = TRUE;
			ELSIF i>1 THEN
				v_querytext := concat (v_querytext, ', ',  quote_literal(v_value),'::',v_columntype);
			END IF;

		END IF;
		i=i+1;

	END LOOP;

	-- query text, final step
	IF v_tablename = 'om_visit' AND v_field = 'visit_id' THEN
		v_field := 'id';
	ELSIF v_field = 'sys_pol_id' THEN
		v_field := 'pol_id';
	END IF;
	v_querytext := concat ((v_querytext),' ) RETURNING (',v_idname,')');

	RAISE NOTICE '--- Insert new file with query:: % ---', v_querytext;

	-- execute query text
	EXECUTE v_querytext INTO v_newid;
	-- updating v_feature setting new id
	v_feature =  gw_fct_json_object_set_key (v_feature, 'id', v_newid);

	-- set message
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
	"data":{"message":"3118", "function":"2616","parameters":null, "is_process":true}}$$);'INTO v_message;

	RAISE NOTICE '--- Returning from (gw_fct_setinsert) with this message :: % ---', v_message;

	-- manage nulls
	v_message = COALESCE(v_message, '{}');
	v_version = COALESCE(v_version, '""');
	v_tablename = COALESCE(v_tablename, '');
	v_newid = COALESCE(v_newid, '');

	-- Return
    RETURN ('{"status":"Accepted", "message":'|| v_message ||', "version":'|| v_version ||
	    ', "body": {"feature":{"tableName":"'||v_tablename||'", "id":"'||v_newid||'"}}}')::json;

END;
$function$
;
