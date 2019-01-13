/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2616

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setinsert(p_data json)
  RETURNS json AS
$BODY$

/* example
-- Indirects
visit: (query used on setvisit function, not direct from client)
SELECT SCHEMA_NAME.gw_api_setinsert($${"client":{"device":3, "infoType":100, "lang":"ES"}, 
	"feature":{"featureType":"visit", "tableName":"ve_visit_arc_insp", "id":null, "idName": "visit_id"}, 
	"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":10, "desperfectes_arc":1, "neteja_arc":3},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)

file: (query used on setfileinsert function, not direct from client)
SELECT SCHEMA_NAME.gw_api_setinsert($${"client":{"device":3, "infoType":100, "lang":"ES"}, 
	"feature":{"featureType":"file","tableName":"om_visit_file", "id":null, "idName": "id"}, 
	"data":{"fields":{"visit_id":1, "hash":"testhash", "url":"urltest", "filetype":"png"},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)

-- directs
feature:
SELECT SCHEMA_NAME.gw_api_setinsert($${
"client":{"device":9, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"featureType":"node", "tableName":"v_edit_node", "id":"1251521", "idName": "node_id"},
	"data":{"fields":{"macrosector_id": "1", "sector_id": "2", "nodecat_id":"JUNCTION DN63", "dma_id":"2","undelete": "False", "inventory": "False", 
		"epa_type": "JUNCTION", "state": "1", "arc_id": "113854", "publish": "False", "verified": "TO REVIEW",
		"expl_id": "1", "builtdate": "2018/11/29", "muni_id": "2", "workcat_id": null, "buildercat_id": "builder1", "enddate": "2018/11/29", 
		"soilcat_id": "soil1", "ownercat_id": "owner1", "workcat_id_end": "22", "the_geom":"0101000020E7640000C66DDE79D9961941A771508A59755151"},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)

any row, any element:

*/

DECLARE
--    Variables
    v_device integer;
    v_infotype integer;
    v_tablename text;
    v_id  character varying;
    v_fields json;
    v_columntype character varying;
    v_querytext varchar;
    v_columntype_id character varying;
    v_apiversion json;
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

BEGIN
	--    Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';
	
	-- Get paramters
	EXECUTE 'SELECT epsg FROM version' INTO v_epsg;
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;
       
	-- Get input parameters:
	v_feature  := (p_data ->> 'feature');
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_idname := (p_data ->> 'feature')::json->> 'idName';
	v_fields := ((p_data ->> 'data')::json->> 'fields')::json;

	select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;

	-- query text, step1
	v_querytext := 'INSERT INTO ' || quote_ident(v_tablename) ||'(';

	-- query text, step2
	i=1;
	FOREACH text IN ARRAY v_text 
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ; -- getting v_value in order to prevent null values
				
		IF v_value !='null' OR v_value !='NULL' OR v_value IS NOT NULL THEN 

			--building the query text
			IF i=1 THEN
				v_querytext := concat (v_querytext, quote_ident(v_field));
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
	FOREACH text IN ARRAY v_text 
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ;
		-- Get column type
		EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_tablename) || ' AND column_name = $2'
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

		IF v_value !='null' OR v_value !='NULL' THEN 
			
			IF v_field in ('geom', 'the_geom') THEN			
				v_value := (SELECT ST_SetSRID((v_value)::geometry, 25831));				
			END IF;
			--building the query text
			IF i=1 THEN
				v_querytext := concat (v_querytext, quote_literal(v_value),'::',v_columntype);
			ELSIF i>1 THEN
				v_querytext := concat (v_querytext, ', ',  quote_literal(v_value),'::',v_columntype);
			END IF;
		END IF;
		i=i+1;

	END LOOP;

	-- query text, final step
	v_querytext := concat (v_querytext,' ) RETURNING ',quote_ident(v_idname));

	RAISE NOTICE '--- Insert new file with query:: % ---', v_querytext;
	
	-- execute query text
	EXECUTE v_querytext INTO v_newid;

	-- updating v_feature setting new id
	v_feature =  gw_fct_json_object_set_key (v_feature, 'id', v_newid);

	-- set message
	SELECT gw_api_getmessage(v_feature::json, 40) INTO v_message;
	
	RAISE NOTICE '--- Returning from (gw_api_setinsert) with this message :: % ---', v_message;

--    Return
    RETURN ('{"status":"Accepted", "message":'|| v_message ||', "apiVersion":'|| v_apiversion ||
	    ', "body": {"feature":{"tableName":"'||v_tablename||'", "id":"'||v_newid||'"}}}')::json;    

--    Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || (to_json(SQLERRM)) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
