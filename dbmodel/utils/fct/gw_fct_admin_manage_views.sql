
	/*
	This file is part of Giswater 3
	The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
	This version of Giswater is provided by Giswater Association
	*/

	--FUNCTION CODE: XXXX

	CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_views(p_data json)
	  RETURNS json AS
	$BODY$

	/*EXAMPLE
	"action":"saveView"
	SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
    "data":{"viewName":["v_vnode","v_arc_x_vnode","v_edit_link"], "action":"saveView","hasChilds":"False"}}$$);

	"action":"deleteField"
	SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
    "data":{"viewName":["v_edit_connec"], "fieldName":"featurecat_id","action":"deleteField","hasChilds":"True"}}$$);
	
	"action":"restoreView"
	SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
    "data":{"viewName":["vu_connec", "v_connec", "ve_connec","vi_parent_connec"], "action":"restoreView","hasChilds":"False"}}$$);

	"action":"addField"
	SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
    "data":{"viewName":["v_edit_node], "fieldName":"asset_id", "action":"addField","hasChilds":"True"}}$$);
	
	"action":"renameView"
	SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
    "data":{"viewName":["ve_node_junction], "newViewName":"ve_node_junction2", "action":"renameView","hasChilds":"False"}}$$);
	*/

	DECLARE 
	v_version text;
	v_project_type text;
	v_error_context text;
	v_level integer;
	v_status text;
	v_message text;

	v_haschilds boolean;
	v_viewname text;
	v_fieldname text;
	v_action text;
	v_schemaname text;
	rec record;
	v_fieldposition integer;
	v_maxposition integer;
	v_viewdefinition text;
	rec_view text;
	v_viewlist text[];
	v_lastview text;
	v_penultimate_field text;

	--trg
	v_trgquery text;
	rec_trg record;
	v_replace_query text;
	v_trg_fields text;
	BEGIN

		-- search path
		SET search_path = "SCHEMA_NAME", public;
		v_schemaname =  'SCHEMA_NAME';

		SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;


		-- get info from version table
		v_viewname=json_extract_path_text(p_data,'data','viewName');
		v_fieldname=json_extract_path_text(p_data,'data','fieldName');
		v_action=json_extract_path_text(p_data,'data','action');
		v_haschilds=json_extract_path_text(p_data,'data','hasChilds')::boolean;
		
		--change viewnames into list
		v_viewlist = ARRAY(SELECT json_array_elements_text(v_viewname::json)); 	

		IF v_haschilds IS TRUE THEN
			p_data = replace(p_data::text,'"hasChilds":"True"','"hasChilds":"False"');

			IF (SELECT a.child_layer FROM (SELECT  child_layer from cat_feature WHERE parent_layer = ANY(v_viewlist)
			UNION SELECT DISTINCT parent_layer from cat_feature WHERE parent_layer = ANY(v_viewlist))a LIMIT 1) IS NOT NULL THEN

				--execute over child views in order to  execute fct for each one of them separately
				FOREACH rec_view IN ARRAY(SELECT string_to_array(string_agg(a.child_layer::text,','),',') FROM (
				SELECT  child_layer from cat_feature WHERE parent_layer = ANY(v_viewlist)
				UNION SELECT DISTINCT parent_layer from cat_feature WHERE parent_layer = ANY(v_viewlist) order by 1 desc)a) LOOP
					
					IF v_lastview IS NULL THEN 
						p_data = replace(p_data::text,json_array_elements_text(v_viewname::json),rec_view);
					ELSE
						p_data = replace(p_data::text,v_lastview,rec_view);
					END IF;
					--execute function for each child view
					EXECUTE 'SELECT gw_fct_admin_manage_views($$'||p_data||'$$)';
					v_lastview = rec_view;
				END LOOP;
			ELSE 
				EXECUTE 'SELECT gw_fct_admin_manage_views($$'||p_data||'$$)';
			END IF;

		END IF;

		IF v_action='deleteField' THEN
			FOREACH rec_view IN ARRAY(v_viewlist) LOOP
				
				EXECUTE 'INSERT INTO temp_csv (fid, source, csv1 )
				SELECT ''380'', '||quote_literal(rec_view)||',  definition FROM pg_views 
				WHERE schemaname='||quote_literal(v_schemaname)||' and viewname = '||quote_literal(rec_view)||';';
				
				--find the location of a replaced field
				EXECUTE 'SELECT max(ordinal_position) FROM information_schema.columns 
				WHERE table_schema='||quote_literal(v_schemaname)||' and table_name = '||quote_literal(rec_view)||';'
				INTO v_maxposition;
				EXECUTE 'SELECT ordinal_position FROM information_schema.columns 
				WHERE table_schema='||quote_literal(v_schemaname)||' and table_name = '||quote_literal(rec_view)||' 
				AND column_name = '||quote_literal(v_fieldname)||''
				INTO v_fieldposition;

				--replace text in a view definition, depending on whether the file is last or not
				IF v_maxposition = v_fieldposition THEN
					FOR rec IN (select * from information_schema.view_table_usage WHERE table_schema=v_schemaname and view_name = rec_view AND table_name not ilike 'selector%') LOOP
						
						EXECUTE 'select replace(csv1,concat('||quote_literal(rec.table_name)||',''.'','||quote_literal(v_fieldname)||'),'''') 
						from temp_csv WHERE fid=380 AND source='||quote_literal(rec_view)||''
						into v_viewdefinition;
						
						--find penultiate field and remove , before FROM
						EXECUTE 'SELECT column_name FROM information_schema.columns 
						WHERE table_schema='||quote_literal(v_schemaname)||' and table_name = '||quote_literal(rec_view)||' AND 
						ordinal_position = '||v_maxposition||' -1 ;'
						INTO v_penultimate_field;

						v_viewdefinition = replace(v_viewdefinition,concat(v_penultimate_field,','),v_penultimate_field);
					
						IF  position(v_fieldname in v_viewdefinition) = 0 then --v_fieldposition = 0 THEN
							EXECUTE 'UPDATE temp_csv set csv2 = '||quote_literal(v_viewdefinition)||' WHERE fid=380 AND source='||quote_literal(rec_view)||';';
						END IF;
						
					END LOOP;
				ELSE
					FOR rec IN (select * from information_schema.view_table_usage WHERE table_schema=v_schemaname and view_name = rec_view AND table_name not ilike 'selector%') LOOP
					
						EXECUTE 'select replace(csv1,concat('||quote_literal(rec.table_name)||',''.'','||quote_literal(v_fieldname)||','',''),'''') 
						from temp_csv WHERE fid=380 AND source='||quote_literal(rec_view)||''
						into v_viewdefinition;
						
						IF  position(v_fieldname in v_viewdefinition) = 0 then 
							EXECUTE 'UPDATE temp_csv set csv2 = '||quote_literal(v_viewdefinition)||' 
							WHERE fid=380 AND source='||quote_literal(rec_view)||';';
						END IF;
						
					END LOOP;
				END IF;
				

			END LOOP;

		ELSIF v_action='saveView' THEN
			--save view definition on the temp table and delete the view. Order of saving is the order defined in input array
			FOREACH rec_view IN ARRAY(v_viewlist) LOOP
			raise notice'rec_view,%',rec_view;
				EXECUTE 'INSERT INTO temp_csv (fid, source, csv1, csv2)
				SELECT ''380'', '||quote_literal(rec_view)||',  definition, definition FROM pg_views 
				WHERE schemaname='||quote_literal(v_schemaname)||' and viewname = '||quote_literal(rec_view)||';';

			END LOOP;

		ELSIF v_action='addField' THEN
			--save view definition on the temp table and delete the view. Order of saving is the order defined in input array
			FOREACH rec_view IN ARRAY(v_viewlist) LOOP

				EXECUTE 'INSERT INTO temp_csv (fid, source, csv1, csv2)
				SELECT ''380'', '||quote_literal(rec_view)||',  definition, 
				replace(replace(replace(replace(definition,''FROM '||v_schemaname||'.ve'', '','||v_fieldname||' FROM '||v_schemaname||'.ve''),
				''FROM (ve'', '','||v_fieldname||' FROM (ve''),''FROM ((ve'', '','||v_fieldname||' FROM ((ve''),
				''FROM (('||v_schemaname||'.ve'', '','||v_fieldname||' FROM (('||v_schemaname||'.ve'') FROM pg_views 
				WHERE schemaname='||quote_literal(v_schemaname)||' and viewname = '||quote_literal(rec_view)||'
				AND definition not ilike ''%'||v_fieldname||'%'';';

				EXECUTE 'SELECT gw_fct_admin_manage_views($${"client":{"lang":"ES"}, "feature":{},
  				"data":{"viewName":["'||rec_view||'"], "action":"restoreView","hasChilds":"False"}}$$);';

			END LOOP;


		ELSIF v_action='restoreView' THEN
			--recreate views saved on the temp table and delete its definition from temp table. Order of restoring is the order defined in input array
			FOREACH rec_view IN ARRAY(v_viewlist) LOOP
				
				EXECUTE 'SELECT concat(''CREATE OR REPLACE VIEW '','||quote_literal(v_schemaname)||',''.'', source, '' AS '', csv2)  from temp_csv
				WHERE fid=380 AND source='||quote_literal(rec_view)||''
				INTO v_viewdefinition;

				IF v_viewdefinition IS NOT NULL THEN 
					EXECUTE v_viewdefinition;
				END IF;
				--recreate trigger
				EXECUTE 'SELECT csv3  from temp_csv WHERE fid=380 AND source='||quote_literal(rec_view)||''
				INTO v_viewdefinition;

				IF v_viewdefinition IS NOT NULL THEN 
					EXECUTE v_viewdefinition;
				END IF;
				--remove definition of restored view from temp table
				EXECUTE 'DELETE FROM temp_csv WHERE fid=380 AND source='||quote_literal(rec_view)||';';
			END LOOP;
		END IF;
		 
	 	IF v_action='saveView' OR v_action='deleteField' THEN
	 		--save trigger definition and delete view 
	 		FOREACH rec_view IN ARRAY(v_viewlist) LOOP
				FOR rec_trg IN 
					select event_object_schema as table_schema, event_object_table as table_name, trigger_schema, trigger_name,
					string_agg(event_manipulation, ',') as event, action_timing as activation, action_condition as condition, action_statement as definition
					from information_schema.triggers where event_object_schema = v_schemaname AND event_object_table = rec_view
					group by 1,2,3,4,6,7,8 order by table_schema, table_name
				LOOP
					--replace trg definition to execute it correctly
					SELECT string_agg(event_object_column, ',') INTO v_trg_fields FROM information_schema.triggered_update_columns 
					WHERE event_object_schema = v_schemaname and event_object_table=rec_trg.table_name AND trigger_name = rec_trg.trigger_name;

					EXECUTE 'select replace('''||rec_trg.event||''', '','', '' OR '')'
					INTO v_replace_query;	

					IF v_trg_fields IS NULL THEN 

						v_trgquery = 'CREATE TRIGGER '||rec_trg.trigger_name||' '||rec_trg.activation||' '||v_replace_query||'
						ON '||v_schemaname||'.'||rec_trg.table_name||' FOR EACH ROW '|| rec_trg.definition||';';
					  
					ELSE   

						EXECUTE 'select replace('''||v_replace_query||''', ''UPDATE'', '' UPDATE  OF '||v_trg_fields||''')'
						INTO v_replace_query; 

						v_trgquery= 'CREATE TRIGGER '||rec_trg.trigger_name||' '||rec_trg.activation||' '||v_replace_query||' ON 
						'||v_dest_schema||'.'||rec_trg.table_name||' FOR EACH ROW '|| rec_trg.definition||';';

					END IF;
					--insert trigger into temp table
					EXECUTE 'UPDATE temp_csv SET csv3 = '||quote_literal(v_trgquery)||' WHERE fid=380 AND source = '||quote_literal(rec_view)||'';
				END LOOP;
				
				EXECUTE 'DROP VIEW IF EXISTS '||v_schemaname||'.'||rec_view||';';
			END LOOP;
		END IF;

		v_status = 'Accepted';
	    v_level = 3;
	    v_message = 'Process done successfully';
		--  Return
		RETURN gw_fct_json_create_return( ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":""}'||
			       '}'||
		    '}')::json, 2690, null, null, null);


		EXCEPTION WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
		RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

	END;
	$BODY$
	  LANGUAGE plpgsql VOLATILE
	  COST 100;

