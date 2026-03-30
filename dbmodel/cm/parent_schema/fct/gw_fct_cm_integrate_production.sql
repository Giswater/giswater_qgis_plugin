/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3426

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_integrate_production(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT cm.gw_fct_cm_integrate_production($${"data":{"parameters":{"campaignId":9}}}$$)
*/

DECLARE

v_campaign integer;
v_result json;
v_result_info json;
v_result_point json;
v_error_context text;
v_version text;
v_project_type text;
v_msgerr json;
v_catfeature record;
v_cmschema text;
v_parentschema text;
v_querytext text;
v_querytext_review text;
v_column_list text;
v_column_list_values text;
v_update_list text;
v_ins integer := 0;
v_upd integer := 0;
v_del integer := 0;
v_tot_ins integer := 0;
v_tot_upd integer := 0;
v_tot_del integer := 0;
v_cat_result json;
v_cat_log text;
v_catalogs_created integer := 0;
v_prev_search_path text;
v_noderecord1 record;
v_noderecord2 record;
v_arc record;
v_disable_params text[] := ARRAY[
	'edit_disable_typevalue_fk',
	'edit_disable_arctopocontrol',
	'edit_disable_planpsector_arc',
	'edit_disable_arc_fkarray',
	'edit_disable_editcontrols',
	'edit_disable_noderotation',
	'edit_disable_noderotation_complete',
	'edit_disable_topocontrol',
	'edit_disable_topocontrol_complete',
	'edit_disable_statetopocontrol',
	'edit_disable_planpsector_node',
	'edit_disable_arc_divide',
	'edit_disable_planpsector_connec'
];
v_restore_param record;
v_workcat_id text;
v_arc_childs text[];
v_data json;

BEGIN

	-- Save current search_path and switch to parent schema (transaction-local)
	v_prev_search_path := current_setting('search_path');
	PERFORM set_config('search_path', 'PARENT_SCHEMA,public', true);
	v_cmschema = 'cm';
   	v_parentschema = 'PARENT_SCHEMA';

  	-- select version and project type
  	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

  	-- getting input data
  	v_campaign :=  (((p_data ->>'data')::json->>'parameters')::json->>'campaignId')::integer;

	v_data :=
    jsonb_build_object(
        'data',
        jsonb_build_object(
            'parameters',
			jsonb_build_object(
				'campaignId', v_campaign::text,
				'lotId', null
			)
        )
    );
	SELECT cm.gw_fct_cm_verify_catalogs(v_data) INTO v_cat_result;

	IF v_cat_result->>'status' = 'Accepted' THEN
		IF (v_cat_result->'body'->'data'->'info' IS NOT NULL AND (v_cat_result->'body'->'data'->'info')::jsonb != '{}'::jsonb) THEN
			RETURN v_cat_result;
		END IF;
	ELSE
		RETURN v_cat_result;
	END IF;

	-- Temporarily disable selected edit triggers for performance (mandatory user params only)
	CREATE TEMP TABLE tmp_cm_integrate_trigger_params (
		parameter text PRIMARY KEY,
		prev_value text,
		existed boolean
	) ON COMMIT DROP;

	INSERT INTO tmp_cm_integrate_trigger_params (parameter, prev_value, existed)
	SELECT p.parameter, cpu.value, (cpu.parameter IS NOT NULL)
	FROM (SELECT DISTINCT unnest(v_disable_params) AS parameter) p
	JOIN sys_param_user spu ON spu.id = p.parameter AND spu.ismandatory IS TRUE
	LEFT JOIN config_param_user cpu ON cpu.parameter = p.parameter AND cpu.cur_user = current_user;

	INSERT INTO config_param_user (parameter, value, cur_user)
	SELECT parameter, 'true', current_user
	FROM tmp_cm_integrate_trigger_params
	ON CONFLICT (parameter, cur_user) DO UPDATE
	SET value = 'true';

	--Create workcat
	SELECT name INTO v_workcat_id FROM cm.om_campaign WHERE campaign_id = v_campaign;
	INSERT INTO PARENT_SCHEMA.cat_work (id, descript, active)
	VALUES (v_workcat_id, concat('Generado al integrar la campaña ', v_workcat_id), true) ON CONFLICT (id) DO NOTHING;

	SELECT lower(concat('PARENT_SCHEMA_', lower(id))) INTO v_arc_childs
	FROM PARENT_SCHEMA.cat_feature
	WHERE lower(feature_type) = 'arc';
	

  	v_querytext_review=
		format('SELECT * FROM (SELECT object_id, feature_type, 
		child_layer as target_layer, 
		lower(concat('''||v_parentschema||'_'',object_id)) as source_layer,
		lower(concat(''om_campaign_lot_x_'',feature_type)) as campaign_layer,
		lower(concat(feature_type,''_id'')) as column_id,
		CASE
			WHEN lower(concat('''||v_parentschema||'_'',object_id)) IN (''%s'') THEN 0
			ELSE 1
		END AS orderby
		from '||v_cmschema||'.om_reviewclass_x_object 
		join '||v_parentschema||'.cat_feature on id = object_id 
		join '||v_cmschema||'.om_campaign_review using (reviewclass_id)
		join '||v_cmschema||'.om_campaign using (campaign_id) 
		WHERE campaign_id = '||v_campaign||') sub ORDER BY sub.orderby', array_to_string(v_arc_childs, ','));

	
	INSERT INTO PARENT_SCHEMA.config_param_user VALUES ('edit_arc_division_dsbl', 'TRUE', current_user) ON CONFLICT (parameter, cur_user) DO UPDATE SET value = 'TRUE';


	-- INSERT nodes
	FOR v_catfeature IN execute concat(v_querytext_review, ' desc')
	LOOP
		IF lower(v_catfeature.source_layer) = ANY(v_arc_childs) THEN
			CONTINUE;
		END IF;

		-- insert (action = 1);
		-- get columns excluding those are not used
		SELECT string_agg(quote_ident(column_name), ', ')
	    INTO v_column_list_values
	    FROM information_schema.columns
	    WHERE table_name = v_catfeature.source_layer
	      AND table_schema = v_cmschema
	      AND column_name not IN ('id','lot_id', 'node_1', 'node_2', 'code', 'workcat_id');

		SELECT string_agg('s.' || quote_ident(column_name), ', ')
	    INTO v_column_list
	    FROM information_schema.columns
	    WHERE table_name = v_catfeature.source_layer
	      AND table_schema = v_cmschema
	      AND column_name not IN ('id','lot_id', 'node_1', 'node_2', 'code', 'workcat_id');

		

     -- set querytext
	     v_querytext :=
		'INSERT INTO ' || v_catfeature.target_layer || ' ' ||
			' ( '|| v_column_list_values || ', code, workcat_id) ' || 
		'SELECT ' || v_column_list || ', '||v_catfeature.column_id||', '||quote_literal(v_workcat_id)||' FROM ' || v_cmschema ||'.'|| v_catfeature.source_layer || ' s ' ||
		'JOIN ' || v_cmschema || '.' || v_catfeature.campaign_layer || ' l ' ||
		'USING (' || v_catfeature.column_id || ') ' ||
				'WHERE action = 1 AND l.lot_id IN (SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign || ');';

       execute v_querytext;
       GET DIAGNOSTICS v_ins = ROW_COUNT;
       v_tot_ins := v_tot_ins + v_ins;

	END LOOP;



	-- UPDATES
	FOR v_catfeature IN execute concat(v_querytext_review, ' desc')
	LOOP

		-- update (action = 2)
		-- get columns excluding those are not used
		SELECT string_agg(format('%I = s.%I', column_name, column_name), ', ')
	    INTO v_update_list
	    FROM information_schema.columns
	    WHERE table_name = v_catfeature.source_layer
	      AND table_schema = v_cmschema
	      AND column_name not IN ('id','lot_id','code', 'workcat_id');


	    v_querytext :=
		'UPDATE ' || v_catfeature.target_layer || ' t SET ' || v_update_list ||', workcat_id = '||quote_literal(v_workcat_id)||
		' FROM ' || v_cmschema ||'.'|| v_catfeature.source_layer || ' s ' ||
		'JOIN ' || v_cmschema || '.' || v_catfeature.campaign_layer || ' l ' ||
		'USING (' || v_catfeature.column_id || ') ' ||
		'WHERE t.' || v_catfeature.column_id || ' = s.' || v_catfeature.column_id ||
		' AND l.action = 2 AND l.lot_id IN (' ||
			'SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign ||
					');';

       EXECUTE v_querytext;
       GET DIAGNOSTICS v_upd = ROW_COUNT;
       v_tot_upd := v_tot_upd + v_upd;

	END LOOP;


	-- INSERT ARCS
	FOR v_catfeature IN execute concat(v_querytext_review, ' desc')
	LOOP
		IF lower(v_catfeature.source_layer) <> ALL(v_arc_childs) THEN
			CONTINUE;
		END IF;

		-- insert (action = 1);
		-- get columns excluding those are not used
		SELECT string_agg(quote_ident(column_name), ', ')
	    INTO v_column_list_values
	    FROM information_schema.columns
	    WHERE table_name = v_catfeature.source_layer
	      AND table_schema = v_cmschema
	      AND column_name not IN ('id','lot_id', 'node_1', 'node_2', 'code', 'workcat_id');

		SELECT string_agg('s.' || quote_ident(column_name), ', ')
	    INTO v_column_list
	    FROM information_schema.columns
	    WHERE table_name = v_catfeature.source_layer
	      AND table_schema = v_cmschema
	      AND column_name not IN ('id','lot_id', 'node_1', 'node_2', 'code', 'workcat_id');


     -- set querytext
	     v_querytext :=
       'INSERT INTO ' || v_catfeature.target_layer || ' ' ||
		' ( '|| v_column_list_values || ', code, node_1, node_2, workcat_id) ' || 
       'SELECT ' || v_column_list || ', '||v_catfeature.column_id||', (select node_id from node where code = s.node_1::text), (select node_id from node where code = s.node_2::text), '||quote_literal(v_workcat_id)||' FROM ' || v_cmschema ||'.'|| v_catfeature.source_layer || ' s ' ||
       'JOIN ' || v_cmschema || '.' || v_catfeature.campaign_layer || ' l ' ||
       'USING (' || v_catfeature.column_id || ') ' ||
      		'WHERE action = 1 AND l.lot_id IN (SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign || ');';

       EXECUTE v_querytext;
       GET DIAGNOSTICS v_ins = ROW_COUNT;
       v_tot_ins := v_tot_ins + v_ins;

	END LOOP;

	-- DELETES
	FOR v_catfeature IN execute v_querytext_review
	LOOP

		EXECUTE'UPDATE connec SET arc_id=NULL
		WHERE connec_id IN (SELECT connec_id FROM connec WHERE arc_id IN (SELECT arc_id FROM cm.om_campaign_lot_x_arc s ' ||
      	' WHERE action = 3 AND s.lot_id IN (SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign || ')))';

		
		v_querytext =
		'UPDATE ' || v_catfeature.target_layer || 
		' SET state = 0 WHERE ' || v_catfeature.column_id || ' IN (SELECT ' || v_catfeature.column_id ||
		' FROM ' || v_cmschema || '.' || v_catfeature.campaign_layer ||' s ' ||
      		 ' WHERE action = 3 AND s.lot_id IN (SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign || '));';

       EXECUTE v_querytext;
       GET DIAGNOSTICS v_del = ROW_COUNT;
       v_tot_del := v_tot_del + v_del;

	END LOOP;

	-- UPDATE campaign workcat
	UPDATE cm.om_campaign SET workcat_id = v_workcat_id WHERE campaign_id = v_campaign;

	-- Check and create missing catalog entries
	SELECT cm.gw_fct_cm_check_catalogs(json_build_object('data', json_build_object(
		'projectType', v_project_type,
		'version', v_version,
		'fromProduction', true,
		'campaign_id', v_campaign::text,
		'lot_id', null
	))) INTO v_cat_result;
	v_cat_log := COALESCE(v_cat_result->'body'->>'log', '');
	IF v_cat_log IS NOT NULL THEN
		SELECT COUNT(*) INTO v_catalogs_created FROM regexp_matches(v_cat_log, 'Created new catalog entry', 'g');
		v_catalogs_created := COALESCE(v_catalogs_created, 0);
	END IF;
	
	-- manage campaing status value (INTEGRATED) and clean selectors
	UPDATE cm.om_campaign SET status=9 WHERE campaign_id=v_campaign;
	UPDATE cm.om_campaign_lot SET status=9 WHERE campaign_id=v_campaign;
	DELETE FROM cm.selector_lot where lot_id in (select lot_id from cm.om_campaign_lot where campaign_id=v_campaign);
	DELETE FROM cm.selector_campaign where campaign_id = v_campaign;

	-- managing results
  	v_result := COALESCE(v_result, '{}');

    -- Build info messages with operation totals and catalog summary
    v_result_info := json_build_object(
        'values', json_build_array(
            json_build_object('message', format('Inserted: %s', v_tot_ins)),
            json_build_object('message', format('Updated: %s', v_tot_upd)),
            json_build_object('message', format('Deleted: %s', v_tot_del)),
            json_build_object('message', format('Catalogs created: %s', COALESCE(v_catalogs_created, 0)))
        )
    );
    v_result_point := COALESCE(v_result_point, '{}');

	--  Build return and restore search_path
	v_result := PARENT_SCHEMA.gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
  		     ',"data":{ "info":'||v_result_info||','||
 				'"point":'||v_result_point||
 			'}}'||
 	    '}')::json, 3426, null, null, null);

	-- Restore trigger params to their previous values
	FOR v_restore_param IN
		SELECT parameter, prev_value, existed
		FROM tmp_cm_integrate_trigger_params
	LOOP
		IF v_restore_param.existed IS TRUE THEN
			UPDATE config_param_user
			SET value = v_restore_param.prev_value
			WHERE parameter = v_restore_param.parameter
			AND cur_user = current_user;
		ELSE
			DELETE FROM config_param_user
			WHERE parameter = v_restore_param.parameter
			AND cur_user = current_user;
		END IF;
	END LOOP;

	PERFORM set_config('search_path', v_prev_search_path, true);
	RETURN v_result;

EXCEPTION WHEN OTHERS THEN
	-- Restore trigger params even on error
	IF to_regclass('pg_temp.tmp_cm_integrate_trigger_params') IS NOT NULL THEN
		FOR v_restore_param IN
			SELECT parameter, prev_value, existed
			FROM tmp_cm_integrate_trigger_params
		LOOP
			IF v_restore_param.existed IS TRUE THEN
				UPDATE config_param_user
				SET value = v_restore_param.prev_value
				WHERE parameter = v_restore_param.parameter
				AND cur_user = current_user;
			ELSE
				DELETE FROM config_param_user
				WHERE parameter = v_restore_param.parameter
				AND cur_user = current_user;
			END IF;
		END LOOP;
	END IF;

	-- Ensure restoration on error
	PERFORM set_config('search_path', v_prev_search_path, true);
	RAISE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;
