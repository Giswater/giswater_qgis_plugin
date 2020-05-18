/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getlistweb(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
--SELECT SCHEMA_NAME.gw_api_getlistweb($${"table_name":"arc","offset":1,"limit":5,"lang":"ES"}$$);
--SELECT SCHEMA_NAME.gw_api_getlistweb($${"table_name":"arc","offset":0,"limit":5,"filter":{"arc_id":"2086"},"lang":"ES"}$$);
--SELECT SCHEMA_NAME.gw_api_getlistweb($${"table_name":"arc","offset":0,"limit":5,"filter":{"arc_id":"%2%"},"lang":"ES"}$$);
--SELECT SCHEMA_NAME.gw_api_getlistweb($${"table_name":"arc","offset":0,"limit":5,"filter":{"arc_id":"%2%"},"orderBy":"arc_id","lang":"ES"}$$);
--SELECT SCHEMA_NAME.gw_api_getlistweb($${"table_name":"arc","offset":0,"limit":5,"filter":{"arc_id":"%2%"},"orderBy":"arc_id","orderType":"DESC","lang":"ES"}$$);
*/

DECLARE

	v_apiversion text;
	v_schemaname text;
	v_tablename text;
	v_offset text;
	v_orderBy text;
	v_orderType text;
	v_limit text;
	v_lang text;
	v_filter text;
	result json;
	v_srid text;
	aux_json json;
	formFields json;
	pageInfo json;
	firstRegistry record;
	allRecords json;
	fieldsJson json;
	auxText text[];
	returnJson json;
	query_text text;
	numberPages integer;


BEGIN
	
--	Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';
  
--	get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

--	Fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
	p_data = REPLACE (p_data::text, '''''', 'null');


	SELECT epsg INTO v_srid FROM version LIMIT 1;

--	Get input parameters:
	v_tablename := p_data ->> 'table_name';
	v_offset := p_data ->> 'offset';
	v_limit := p_data ->> 'limit';
	v_filter := p_data ->> 'filter';
	v_lang := p_data ->> 'lang';
	v_orderBy := p_data ->> 'orderBy';
	v_orderType := p_data ->> 'orderType';

--	Control inputs
	v_offset := COALESCE(v_offset, '0');

--	Control filters
	IF v_filter IS NULL THEN
		v_filter = '{"limit":' || v_limit || '}';
	ELSE
		v_filter = left(v_filter, length(v_filter) - 1) || ',"limit":' || v_limit || '}';
	END IF;

--	Control order
	IF v_orderBy IS NULL THEN
		v_orderBy = '';
	ELSE
		v_orderBy = ',"orderBy":"' || v_orderBy || '"';
	END IF;

--	Control order type
	IF v_orderType IS NULL THEN
		v_orderType = '';
	ELSE
		v_orderType = ',"orderType":"' || v_orderType || '"';
	END IF;

--	Call API function
	SELECT INTO result gw_api_getlist(('{
		"client":
			{"device":3, "infoType":100, "lang":"' || v_lang || '"},
		"feature":
			{"tableName":"' || v_tablename || '"},
		"data":
			{"filterFields":' || v_filter || ', "pageInfo":{"currentPage":1,"offset":' || v_offset || v_orderBy || v_orderType || '}}
		}')::json);	


--	Get the form fields
	formFields := (((result ->> 'body')::JSON ->> 'data')::JSON ->> 'fields')::JSON;

--	Get tableView data as JSON
	SELECT * INTO firstRegistry FROM json_array_elements(formFields) obj WHERE obj ->> 'type' = 'tableView' LIMIT 1;
	allRecords := ((row_to_json(firstRegistry) ->> 'value')::JSON->>'value')::JSON;

	--firstRecord := allRecords->0;

--	Get number of pages
	numberPages := (((((result ->> 'body')::JSON ->> 'data')::JSON ->> 'pageInfo')::JSON) ->> 'lastPage')::INT;

--	Get keys
	IF allRecords IS NULL THEN
		query_text := 'SELECT json_agg(column_name) FROM information_schema.columns WHERE table_schema = ' || quote_literal(v_schemaname) || ' AND table_name = ' || quote_literal(v_tablename);
		EXECUTE query_text INTO fieldsJson;
	ELSE
		SELECT json_agg(ARRAY(select json_object_keys(allRecords->0)))->0 INTO fieldsJson;
	END IF;

--	NULL's control
	fieldsJson := COALESCE(fieldsJson, '[]');
	allRecords := COALESCE(allRecords, '[]');
	numberPages := COALESCE(numberPages, 0);
	

--	Filter result to adapt to web requirements	
	returnJson := ('{"status":"' || (result->>'status') || 
			'","fields":' || fieldsJson || 
			',"data":' || allRecords || 
			',"totalRows":' || json_array_length(allRecords) || 
			',"totalPages":' || numberPages ||
				'}')::json;

	return returnJson;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
