/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3068

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getreport(p_data json)
  RETURNS json AS
$BODY$
	
/*EXAMPLE:

SELECT SCHEMA_NAME.gw_fct_getreport($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"filterText":null, "listId":"1"}}$$);

*/

DECLARE

v_list_id integer;
v_fields json;
i integer;
v_filterparam json;
v_filterdvquery json;
v_comboid json;
v_comboidval json;
v_filterlist json[];
v_filter json;
rec_filter text;
v_filterinput text[];
v_filtername text;
v_filtervalue text;
v_filtersign text;
v_querytext text;

v_version text;
v_error_context text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
  
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- get input parameter
	v_list_id := json_extract_path_text(p_data,'data','listId');
	v_filter := json_extract_path_text(p_data,'data','filter');

	SELECT array_agg(a) AS list FROM   json_array_elements_text(v_filter) a
	INTO v_filterinput;

	--filter widgets
	IF (SELECT filterparam FROM config_report WHERE id = v_list_id) IS NOT NULL THEN
		FOR i IN 0..(SELECT jsonb_array_length(filterparam::jsonb)-1 FROM config_report WHERE id = v_list_id) LOOP

			SELECT filterparam::jsonb->>i into v_filterparam FROM config_report WHERE id = v_list_id;

				EXECUTE 'SELECT json_agg(t.id) FROM ('||json_extract_path_text(v_filterparam,'dvquerytext')||') t'
				INTO v_comboid;

				EXECUTE 'SELECT json_agg(t.idval) FROM ('||json_extract_path_text(v_filterparam,'dvquerytext')||') t'
				INTO v_comboidval;

				v_filterdvquery=(v_filterparam::jsonb || json_build_object('comboIds', v_comboid, 'comboNames', v_comboidval, 'widgetname',json_extract_path_text(v_filterparam,'columnname') )::jsonb);

				v_filterlist = array_append(v_filterlist,v_filterdvquery);
		
			i=i+1;
		END LOOP;
	END IF;

	--list data
	--execute query 
	SELECT CASE WHEN vdefault IS NOT NULL THEN  concat(query_text, ' ORDER BY ',json_extract_path_text(vdefault,'orderBy'),' ',json_extract_path_text(vdefault,'orderType')) 
	ELSE  query_text END AS query INTO v_querytext FROM config_report WHERE id = v_list_id;

	IF v_filterinput IS NOT NULL THEN
		i=1;
		FOREACH rec_filter IN ARRAY v_filterinput LOOP
			v_filtername = json_extract_path_text(rec_filter::json,'filterName');
			v_filtervalue = json_extract_path_text(rec_filter::json,'filterValue');
			v_filtersign = json_extract_path_text(rec_filter::json,'filterSign');

			IF v_filtersign  IS NULL THEN
				v_filtersign='=';
			END IF;
			IF v_filtername != '' AND v_filtervalue != '' THEN
				IF v_querytext ILIKE '%WHERE%' THEN
					IF v_querytext ILIKE '%GROUP BY%' THEN
						v_querytext = replace(v_querytext, 'GROUP BY',concat(' AND ',v_filtername,v_filtersign,quote_literal(v_filtervalue),' GROUP BY'));
					ELSE 
						v_querytext = replace(v_querytext, 'WHERE ',concat(' WHERE ',v_filtername,v_filtersign,quote_literal(v_filtervalue),' AND '));
		
					END IF;
				ELSE
					IF v_querytext ILIKE '%GROUP BY%' THEN
						v_querytext = replace(v_querytext, 'GROUP BY',concat(' WHERE ',v_filtername,v_filtersign,quote_literal(v_filtervalue),' GROUP BY'));
					ELSIF v_querytext ILIKE '%ORDER BY%' THEN
						v_querytext = replace(v_querytext, 'ORDER BY', concat(' WHERE ',  v_filtername,v_filtersign,quote_literal(v_filtervalue), 'ORDER BY '));
					ELSE 
						v_querytext = concat(v_querytext, ' WHERE ',  v_filtername,v_filtersign,quote_literal(v_filtervalue));
					END IF;
				END IF; 
			END IF;
			i=i+1;
		END LOOP;
	END IF;
	
	raise notice 'v_querytext,%',v_querytext;
	EXECUTE 'SELECT json_agg(t) FROM ('||v_querytext||') t'
	INTO v_fields ;

	v_fields = json_build_object('widgettype', 'list', 'value',v_fields); 
	
  v_fields=json_build_object('fields',v_fields||v_filterlist);
	
	v_fields := COALESCE(v_fields, '{}'); 
	    	
	RETURN ('{"status":"Accepted", "version":'||v_version||
	      ',"body":{"message":{"level":1, "text":"Process done successfully"}'||
		      ',"form":{}'||
		      ',"feature":{}'||
		      ',"data":' || v_fields ||'}'||
	       '}')::json;
	       

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

