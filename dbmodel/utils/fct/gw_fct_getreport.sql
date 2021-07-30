/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getreport(p_data json)
  RETURNS json AS
$BODY$
	
/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_getreport($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"isToolbox":false, "function":2522, "filterText":"Import inp epanet file"}}$$)

SELECT SCHEMA_NAME.gw_fct_getreport($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"filterText":"Import inp epanet file"}}$$)

SELECT SCHEMA_NAME.gw_fct_getreport($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"data":{"filterText":null, "listName":"arc_length_x_arccat"}}$$);

*/

DECLARE

v_list text;
v_filtervalue text;
v_fields json;
v_widgetfields json;
i integer;
v_filterparam json;
v_filterdvquery json;
v_comboid json;
v_comboidval json;
v_filterlist json[];
v_fieldslist json[];

v_version text;
v_role text;
v_projectype text;
v_filter text;
v_om_fields json;
v_edit_fields json;
v_epa_fields json;
v_master_fields json;
v_admin_fields json;
v_isepa boolean = false;
v_epa_user text;
rec record;
v_querytext text;
v_querytext_mod text;
v_queryresult text;
v_expl text;
v_state text;
v_inp_result text; 
v_rpt_result text;
v_return json;
v_return2 text;
v_nodetype text;
v_nodecat text;

v_arrayresult text[];
v_selectedid text;
v_rec_replace json;
v_errcontext text;
v_querystring text;
v_debug_vars json;
v_debug json;
v_msgerr json;
v_value text;

v_message text;
v_error_context text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
  
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;

	-- get input parameter
	v_list := json_extract_path_text(p_data,'data','listName');
	v_filter := json_extract_path_text(p_data,'data','filter');
	v_filtervalue := json_extract_path_text(p_data,'data','filterValue');
	
	--filter widgets
	FOR i IN 0..(SELECT jsonb_array_length(filterparam::jsonb)-1 FROM config_form_list WHERE listname = v_list) LOOP

		SELECT filterparam::jsonb->>i into v_filterparam FROM config_form_list WHERE listname = v_list;

			EXECUTE 'SELECT json_agg(t.id) FROM ('||json_extract_path_text(v_filterparam,'dvquerytext')||') t'
			INTO v_comboid;

			EXECUTE 'SELECT json_agg(t.idval) FROM ('||json_extract_path_text(v_filterparam,'dvquerytext')||') t'
			INTO v_comboidval;

			v_filterdvquery=(v_filterparam::jsonb || json_build_object('comboId', v_comboid, 'comboNames', v_comboidval)::jsonb);

			v_filterlist = array_append(v_filterlist,v_filterdvquery);
	
		i=i+1;
	END LOOP;

	--list data
	--execute query 
	SELECT CASE WHEN vdefault IS NOT NULL THEN  concat(query_text, ' ORDER BY ',json_extract_path_text(vdefault,'orderBy'),' ',json_extract_path_text(vdefault,'orderType')) 
	ELSE  query_text END AS query INTO v_querytext FROM config_form_list WHERE listname = v_list;
/*
	IF v_filter IS NOT NULL THEN

		IF v_querytext ILIKE '%WHERE%' THEN
			IF v_querytext ILIKE '%GROUP BY%' THEN
				v_querytext = replace(v_querytext, 'GROUP BY',concat(' WHERE ',v_filter,' = ',v_filtervalue,' GROUP BY'));

			END IF;
		END IF; 
	END IF;
	*/
	EXECUTE 'SELECT json_agg(t) FROM ('||v_querytext||') t'
	INTO v_fields ;

	v_fields = json_build_object('widgettype', 'list', 'value',v_fields); 
	
  v_fields=json_build_object('fields',v_fields||v_filterlist);
	
	v_fields := COALESCE(v_fields, '{}'); 
	    	
	RETURN ('{"status":"Accepted", "version":'||v_version||
	      ',"body":{"message":{"level":1, "text":"Process done successfully"}'||
		      --',"form":'||(p_data->>'form')::json||
		     -- ',"feature":'||(p_data->>'feature')::json||
		      ',"data":' || v_fields ||'}'||		     
	       '}')::json;
	       

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

