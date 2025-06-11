/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3426

CREATE OR REPLACE FUNCTION ws_cm.gw_fct_cm_integrate_production(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT ws_cm.gw_fct_cm_integrate_production($${"data":{"parameters":{"campaignId":9}}}$$)
*/

DECLARE

v_campaign integer;
v_result json;
v_result_info json;
v_result_point json;
v_error_context text;
v_version text;
v_msgerr json;
v_catfeature record;
v_cmschema text;
v_parentschema text;
v_querytext text;
v_column_list text;
v_update_list text;


BEGIN
 
   	SET search_path = "PARENT_SCHEMA", public;
	v_cmschema = 'SCHEMA_NAME';
   	v_parentschema = 'PARENT_SCHEMA';
  
  	-- select version
  	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
  
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
	WHERE campaign_id = 9 ORDER BY orderby';
  
	raise notice 'v_querytext %', v_querytext;
	
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

		raise notice 'v_querytext %', v_querytext;
		execute v_querytext;
	
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
	

		raise notice 'v_querytext %', v_querytext;
		execute v_querytext;
	
		-- delete (action = 3)
		v_querytext = 
		'DELETE FROM ' || v_catfeature.target_layer ||
		' WHERE ' || v_catfeature.column_id || ' IN (SELECT ' || v_catfeature.column_id || 
		' FROM ' || v_cmschema || '.' || v_catfeature.source_layer ||' s ' ||
        ' JOIN ' || v_cmschema || '.' || v_catfeature.campaign_layer || ' l ' ||
        ' USING (' || v_catfeature.column_id || ') ' ||
        ' WHERE action = 3 AND l.lot_id IN (SELECT lot_id FROM ' || v_cmschema || '.om_campaign_lot WHERE campaign_id = ' || v_campaign || '));';

		raise notice 'v_querytext %', v_querytext;	
		execute v_querytext;

	END LOOP;

	-- managing results
  	v_result := COALESCE(v_result, '{}');

  	-- Control nulls
  	v_result_info := COALESCE(v_result_info, '{}');
  	v_result_point := COALESCE(v_result_point, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
  		     ',"data":{ "info":'||v_result_info||','||
  				'"point":'||v_result_point||
  			'}}'||
  	    '}')::json, 3426, null, null, null);


  	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;
	--RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

