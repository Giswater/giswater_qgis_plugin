/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2610

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setfields(p_data json)
  RETURNS json AS
$BODY$


/* example

-- FEATURE
SELECT SCHEMA_NAME.gw_api_setfields($${
"client":{"device":9, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"node", "tableName":"ve_node_t", "id":"1251521"},
"data":{"fields":{"macrosector_id": "1", "sector_id": "2", 
"undelete": "False", "inventory": "False", "epa_type": "PUMP", "state": "1", "arc_id": "113854", "publish": "False", "verified": "TO REVIEW",
"expl_id": "1", "builtdate": "2018/11/29", "muni_id": "2", "workcat_id": "22", "buildercat_id": "builder1", "enddate": "2018/11/29", 
"soilcat_id": "soil1", "ownercat_id": "owner1", "workcat_id_end": "22"}}}$$)

-- VISIT
SELECT SCHEMA_NAME.gw_api_setfields('
 {"client":{"device":3, "infoType":100, "lang":"ES"}, 
 "feature":{"featureType":"arc", "tableName":"ve_visit_multievent_x_arc", "id":1135}, 
 "data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":1000, "desperfectes_arc":1, "neteja_arc":3},
 "deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}')
*/

DECLARE

--    Variables
    v_device integer;
    v_infotype integer;
    v_tablename text;
    v_id  character varying;
    v_fields json;
    column_type character varying;
    sql_query varchar;
    v_idname varchar;
    column_type_id character varying;
    api_version json;
    v_text text[];
    json_field json;
    text text;
    i integer=1;
    v_field text;
    v_value text;
    v_return text;
    v_schemaname text;
    v_featuretype text;

BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    v_schemaname = 'SCHEMA_NAME';

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;
       
	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_featuretype := (p_data ->> 'feature')::json->> 'featureType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_fields := ((p_data ->> 'data')::json->> 'fields')::json;

	select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;


--    Get id column, for tables is the key column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO v_idname
        USING v_tablename;
        
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
-------------------------
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

         
    FOREACH text IN ARRAY v_text 
    LOOP

	-- Get field and value from json
	SELECT v_text [i] into json_field;
	v_field:= (SELECT (json_field ->> 'key')) ;
	v_value:= (SELECT (json_field ->> 'value')) ;

	i=i+1;
	
	-- Get column type
	EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_tablename) || ' AND column_name = $2'
		USING v_schemaname, v_field
		INTO column_type;

		--RAISE NOTICE '--- UPDATE FIELDS using v_field % v_tablename % column_type % v_idname % v_id % column_type_id % ---'  , v_field, v_tablename, column_type, v_idname, v_id, column_type_id;

	IF v_field='state' THEN
		PERFORM gw_fct_state_control(v_featuretype, v_id, v_value::integer, 'UPDATE');
	END IF;

	--    Value update
	sql_query := 'UPDATE ' || quote_ident(v_tablename) || ' SET ' || quote_ident(v_field) || ' = CAST(' || quote_nullable(v_value) || ' AS ' 
	|| column_type || ') WHERE ' || quote_ident(v_idname) || ' = CAST(' || quote_literal(v_id) || ' AS ' || column_type_id || ')';

	--RAISE NOTICE ' --- UPDATE FIELDS USING QUERY % ---', sql_query;
	
	EXECUTE sql_query;
	
   END LOOP;

--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'|| api_version ||'}')::json;    

--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
