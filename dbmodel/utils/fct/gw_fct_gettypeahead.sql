/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2602

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_gettypeahead(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_gettypeahead(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:

-- without parent
SELECT SCHEMA_NAME.gw_fct_gettypeahead($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},
"feature":{"tableName":"ve_arc_pipe"},
"data":{"queryText":"SELECT id AS id, id AS idval FROM cat_arc WHERE id IS NOT NULL",
	"textToSearch":"FD"}}$$)

SELECT SCHEMA_NAME.gw_fct_gettypeahead($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
"queryText":"SELECT id AS id, a.name AS idval FROM ext_streetaxis a JOIN ext_municipality m USING (muni_id) WHERE id IS NOT NULL",
"queryTextFilter":"AND m.name", "parentId":"muni_id", "parentValue":"", "textToSearch":"Ave"}}$$);

SELECT SCHEMA_NAME.gw_fct_gettypeahead($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},
"queryText":"SELECT a.postnumber AS id, a.postnumber AS idval FROM ext_address a JOIN ext_streetaxis m ON streetaxis_id=m.id WHERE a.id IS NOT NULL",
"queryTextFilter":"AND m.name", "parentId":"streetname", "parentValue":"Avenida de Aragó", "textToSearch":"1"}}$$);

*/

DECLARE

v_response json;
v_message text;
v_version text;
v_querytext text;
v_querytextparent text;
v_parent text;
v_parentvalue text;
v_textosearch text;
v_fieldtosearch text;
v_position integer;
v_error_context text;

BEGIN

	-- set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	-- get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- filter input data
	p_data = replace (p_data::text, 'None', '');

	-- getting input data
	v_querytext := ((p_data ->>'data')::json->>'queryText')::text;
	v_parent :=  ((p_data ->>'data')::json->>'parentId')::text;
	v_querytextparent :=  ((p_data ->>'data')::json->>'queryTextFilter')::text;
	v_fieldtosearch :=  ((p_data ->>'data')::json->>'fieldToSearch')::text;
	v_parentvalue :=  ((p_data ->>'data')::json->>'parentValue')::text;
	v_textosearch :=  ((p_data ->>'data')::json->>'textToSearch')::text;
	v_textosearch := concat('%',v_textosearch,'%');

	-- control nulls for parent mapzone hidden (muni_id) the only parent mapzone with typeahead childs
	IF v_parentvalue = '' AND v_parent = 'muni_id' THEN
		v_parentvalue =  (SELECT name FROM ext_municipality WHERE active IS TRUE LIMIT 1);
	END IF;

	-- building query text
	IF v_parent IS NULL OR v_querytextparent IS NULL OR v_parentvalue IS NULL OR v_querytextparent = '' THEN
		v_querytext = v_querytext;
	ELSE

		v_position = position('AND' in v_querytextparent);

		IF v_position > 0 and v_position <3 THEN
			v_querytextparent =overlay(v_querytextparent placing 'AND(' from v_position for 3);

			v_querytext = concat (v_querytext, ' ', v_querytextparent, ' = ' ,quote_literal(v_parentvalue),')');

		ELSE
			v_querytext = concat (v_querytext, ' ', v_querytextparent, ' = ' ,quote_literal(v_parentvalue));
		END IF;

	END IF;

	v_querytext = concat(
		'SELECT array_to_json(array_agg(row_to_json(a))) FROM ( SELECT * FROM (',
		v_querytext,
		')a WHERE CAST(idval AS TEXT) ILIKE $$%',
		v_textosearch,
		'%$$ LIMIT 10)a'
	);

	-- execute query text
	EXECUTE v_querytext INTO v_response;

	-- message
	v_message := '{"level":"0", "text":"typeahead upserted sucessfully"}';

	-- Control NULL's
	v_response := COALESCE(v_response, '{}');
	v_message := COALESCE(v_message, '{}');

	-- Return
	RETURN ('{"status":"Accepted", "message":'||v_message||', "version":"'|| v_version ||
    	    '", "body": {"data":'|| v_response || '}}')::json;

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;




END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
