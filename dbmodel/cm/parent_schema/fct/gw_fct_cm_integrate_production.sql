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
v_column_list text;
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

  	v_querytext=
  	'SELECT object_id, feature_type, 
	child_layer as target_layer, 
	lower(concat('''||v_parentschema||'_'',object_id)) as source_layer,
	lower(concat(''om_campaign_lot_x_'',feature_type)) as campaign_layer,
	lower(concat(feature_type,''_id'')) as column_id
	from '||v_cmschema||'.om_reviewclass_x_object 
	join '||v_parentschema||'.cat_feature on id = object_id 
	join '||v_cmschema||'.om_campaign_review using (reviewclass_id)
	join '||v_cmschema||'.om_campaign using (campaign_id) 
	WHERE campaign_id = '||v_campaign||' ORDER BY orderby';

	FOR v_catfeature IN execute v_querytext
	LOOP

		-- insert (action = 1);
		-- get columns excluding those are not used
		SELECT string_agg('s.' || quote_ident(column_name), ', ')
	    INTO v_column_list
	    FROM information_schema.columns
	    WHERE table_name = v_catfeature.source_layer
	      AND table_schema = v_cmschema
	      AND column_name not IN ('id','lot_id');

	     -- set querytext
	     v_querytext :=
       'INSERT INTO ' || v_catfeature.target_layer || ' ' ||
       'SELECT ' || v_column_list || ' FROM ' || v_cmschema ||'.'|| v_catfeature.source_layer || ' s ' ||
       'JOIN ' || v_cmschema || '.' || v_catfeature.campaign_layer || ' l ' ||
       'USING (' || v_catfeature.column_id || ') ' ||
      		'WHERE action = 1 AND l.lot_id IN (SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign || ');';

       execute v_querytext;
       GET DIAGNOSTICS v_ins = ROW_COUNT;
       v_tot_ins := v_tot_ins + v_ins;

	    -- update (action = 2)
		-- get columns excluding those are not used
       SELECT string_agg(format('%I = s.%I', column_name, column_name), ', ')
	    INTO v_update_list
	    FROM information_schema.columns
	    WHERE table_name = v_catfeature.target_layer
	      AND table_schema = v_parentschema;


	    v_querytext :=
       'UPDATE ' || v_catfeature.target_layer || ' t SET ' || v_update_list ||
       ' FROM ' || v_cmschema ||'.'|| v_catfeature.source_layer || ' s ' ||
       'JOIN ' || v_cmschema || '.' || v_catfeature.campaign_layer || ' l ' ||
       'USING (' || v_catfeature.column_id || ') ' ||
       'WHERE t.' || v_catfeature.column_id || ' = s.' || v_catfeature.column_id ||
       ' AND l.action = 2 AND l.lot_id IN (' ||
           'SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign ||
                ');';

       execute v_querytext;
       GET DIAGNOSTICS v_upd = ROW_COUNT;
       v_tot_upd := v_tot_upd + v_upd;

		-- delete (action = 3)
		v_querytext =
		'DELETE FROM ' || v_catfeature.target_layer ||
		' WHERE ' || v_catfeature.column_id || ' IN (SELECT ' || v_catfeature.column_id ||
		' FROM ' || v_cmschema || '.' || v_catfeature.source_layer ||' s ' ||
       ' JOIN ' || v_cmschema || '.' || v_catfeature.campaign_layer || ' l ' ||
       ' USING (' || v_catfeature.column_id || ') ' ||
      		 ' WHERE action = 3 AND l.lot_id IN (SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign || '));';

       execute v_querytext;
       GET DIAGNOSTICS v_del = ROW_COUNT;
       v_tot_del := v_tot_del + v_del;

	END LOOP;

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
	v_result := gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
  		     ',"data":{ "info":'||v_result_info||','||
 				'"point":'||v_result_point||
 			'}}'||
 	    '}')::json, 3426, null, null, null);

	PERFORM set_config('search_path', v_prev_search_path, true);
	RETURN v_result;

EXCEPTION WHEN OTHERS THEN
	-- Ensure restoration on error
	PERFORM set_config('search_path', v_prev_search_path, true);
	RAISE;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

