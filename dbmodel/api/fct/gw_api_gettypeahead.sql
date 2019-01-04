/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2602

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_gettypeahead(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- with parent
SELECT SCHEMA_NAME.gw_api_gettypeahead($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tableName":"ve_arc_pipe"},
"data":{"queryText":"SELECT id FROM cat_arc WHERE id IS NOT NULL",
        "fieldToSearch":"id",
	"queryTextFilter":" AND arctype_id = ", 
	"parentId":"arc_type",
	"parentValue":"PIPE", 
	"textToSearch":"FC"}}$$)

-- without parent
SELECT SCHEMA_NAME.gw_api_gettypeahead($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tableName":"ve_arc_pipe"},
"data":{"queryText":"SELECT id FROM cat_arc WHERE id IS NOT NULL",
        "fieldToSearch":"id",
	"textToSearch":"FC"}}$$)
*/

DECLARE
	v_response json;
	v_message text;
	v_apiversion text;
	v_querytext text;
	v_querytextparent text; 
	v_parent text; 
	v_parentvalue text; 
	v_textosearch text;
	v_fieldtosearch text; 
BEGIN

    --  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
    -- 	get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;

    --	getting input data 
	v_querytext := ((p_data ->>'data')::json->>'queryText')::text;
	v_parent :=  ((p_data ->>'data')::json->>'parentId')::text;
	v_querytextparent :=  ((p_data ->>'data')::json->>'queryTextFilter')::text;
	v_fieldtosearch :=  ((p_data ->>'data')::json->>'fieldToSearch')::text;
	v_parentvalue :=  ((p_data ->>'data')::json->>'parentValue')::text;
	v_textosearch :=  ((p_data ->>'data')::json->>'textToSearch')::text;

	-- building query text
	IF v_parent IS NULL OR v_querytextparent IS NULL OR v_parentvalue IS NULL THEN
		v_querytext = v_querytext;
	ELSE
		v_querytext = concat (v_querytext, v_querytextparent, quote_literal(v_parentvalue)); 
	END IF;
	v_querytext = concat ('SELECT array_to_json(array_agg(row_to_json(a))) FROM (', v_querytext, ' AND ', v_fieldtosearch , ' ILIKE ''%', v_textosearch, '%'' LIMIT 10) a');

	-- execute query text
	EXECUTE v_querytext INTO v_response;

	-- message
	v_message := '{"priority":"0", "text":"typeahead upserted sucessfully"}';

	-- Control NULL's
	v_response := COALESCE(v_response, '{}');
	v_message := COALESCE(v_message, '{}');

    
--    Return
    RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'|| v_apiversion ||
    	    ', "body": {"data":'|| v_response || '}}')::json;      
	 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
