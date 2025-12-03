/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3198

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setclosestaddress(p_data json)
  RETURNS json AS
$BODY$

/*
SELECT gw_fct_setclosestaddress($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE}, "form":{},
 "feature":{"tableName":"ve_node", "featureType":"NODE", "id":[""]},
 "data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"previousSelection",
 "parameters":{"catFeature":"ALL NODES", "fieldToUpdate":"postcomplement", "searchBuffer":"50", "updateValues":"nullPostcomplement"}}}$$);
*/

DECLARE

v_version text;
v_project_type text;
v_result_info text;
v_result text;
v_id json;
v_worklayer text;
v_selectionmode text;
v_array text;
v_catfeature text;
v_fieldtoupdate text;
v_searchbuffer integer;
v_feature_type text;
v_updatevalues text;
v_catalog text;
affected_rows numeric;
v_partialquery text;
v_partialquery2 text;
v_partialquery3 text;
v_partialquery4 text;
v_polygonlayer text;
v_expl text;
v_state text;
v_geom_column text;
v_count integer;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- get input parameters
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;
	v_catfeature := ((p_data ->>'data')::json->>'parameters')::json->>'catFeature';
	v_fieldtoupdate := ((p_data ->>'data')::json->>'parameters')::json->>'fieldToUpdate';
	v_updatevalues := ((p_data ->>'data')::json->>'parameters')::json->>'updateValues';
	v_searchbuffer := ((p_data ->>'data')::json->>'parameters')::json->>'searchBuffer';
	v_feature_type := lower(((p_data ->>'feature')::json->>'featureType'))::text;
	v_polygonlayer := ((p_data ->>'data')::json->>'parameters')::json->>'insersectPolygonLayer';
	Select count(*)
	into v_count From ext_address
	Where postnumber NOT SIMILAR TO '[0-9]*';



	if v_count > 0 and v_fieldtoupdate='postnumber' THEN

		execute 'SELECT gw_fct_getmessage($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"feature":{},
		"data":{"message":"3268", "function":"3198","parameters":null, "variables":"value", "is_process":true}}$$);';


	end if;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=486;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=486;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3198", "fid":"486", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	v_expl= (select string_agg(expl_id::text,',') from selector_expl where cur_user = current_user);
	v_expl= concat(' AND a.expl_id IN (', v_expl,')');

	v_state= (select string_agg(state_id::text,',') from selector_state where cur_user = current_user);
	v_state= concat(' AND a.state IN (', v_state,')');

	-- Partial query
	IF v_project_type = 'WS' THEN
		IF v_feature_type='node' THEN
			v_partialquery=' JOIN cat_node cn on cn.id=a.nodecat_id JOIN cat_feature cf on cf.id=cn.node_type ';
		ELSIF v_feature_type='connec' THEN
			v_partialquery=' JOIN cat_connec cn on cn.id=a.conneccat_id JOIN cat_feature cf on cf.id=cn.connec_type ';
		END IF;
	ELSIF v_project_type = 'UD' THEN
		IF v_feature_type='node' THEN
			v_partialquery=' JOIN cat_node cn on cn.id=a.nodecat_id JOIN cat_feature cf on cf.id=a.node_type ';
		ELSE
			v_partialquery=' ';
		END IF;
	END IF;

	-- Partial query
	-- update all elements without feature WHERE
	IF v_catfeature IN ('ALL NODES', 'ALL CONNECS', 'ALL GULLYS') THEN
		IF v_updatevalues='nullStreet' THEN
			v_partialquery2=' WHERE a.streetaxis_id IS NULL ';
		ELSIF v_updatevalues='nullPostnumber' THEN
			v_partialquery2=' WHERE a.postnumber IS NULL ';
		ELSIF v_updatevalues='nullPostcomplement' THEN
			v_partialquery2=' WHERE a.postcomplement IS NULL ';
		ELSIF v_updatevalues='allValues' THEN
			v_partialquery2='';
		END IF;
	-- update with feature WHERE
	ELSE
		IF v_updatevalues='nullStreet' THEN
			v_partialquery2=' WHERE cf.feature_class='||quote_literal(v_catfeature)||' AND a.streetaxis_id IS NULL ';
		ELSIF v_updatevalues='nullPostnumber' THEN
			v_partialquery2=' WHERE cf.feature_class='||quote_literal(v_catfeature)||' AND a.postnumber IS NULL ';
		ELSIF v_updatevalues='nullPostcomplement' THEN
			v_partialquery2=' WHERE cf.feature_class='||quote_literal(v_catfeature)||' AND a.postcomplement IS NULL ';
		ELSIF v_updatevalues='allValues' THEN
			v_partialquery2=' WHERE cf.feature_class='||quote_literal(v_catfeature)||'';
		END IF;
	END IF;

	-- set query postnumber to integer in order to update postnumber from node/connec
	IF v_fieldtoupdate='postnumber' THEN
		v_partialquery3=' ea.postnumber::integer ';
	ELSE
		v_partialquery3=' ea.postnumber ';
	END IF;

	IF v_polygonlayer='NONE' OR v_polygonlayer IS NULL THEN
		v_partialquery4='';
	ELSE
		EXECUTE 'select column_name from INFORMATION_SCHEMA.columns 
		where table_schema=''SCHEMA_NAME'' and udt_name=''geometry'' and table_name='||quote_literal(v_polygonlayer)||''
		INTO v_geom_column;

		v_partialquery4='and a.'||v_feature_type||'_id in (select a.'||v_feature_type||'_id from '||v_polygonlayer||' p, '||v_feature_type||' a 
		where ST_Contains (p.'||v_geom_column||', a.the_geom))';
	END IF;

    -- get array elements if previousSelection
	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	IF v_selectionmode = 'previousSelection' AND v_array IS NOT NULL THEN
		EXECUTE 'UPDATE '||v_feature_type||' a set streetaxis_id = q.streetaxis_id, '||v_fieldtoupdate||' = q.postnumber from (
		SELECT distinct on ('||v_feature_type||'_id) '||v_feature_type||'_id, ea.streetaxis_id ,'||v_partialquery3||'
	    FROM '||v_feature_type||' a
	        JOIN ext_address ea ON ST_DWithin(a.the_geom, ea.the_geom, '||v_searchbuffer||')
		'||v_partialquery||'
		'||v_partialquery2||'
		'||v_partialquery4||'
	    ORDER BY '||v_feature_type||'_id, ST_Distance(a.the_geom, ea.the_geom))q
	    where a.'||v_feature_type||'_id=q.'||v_feature_type||'_id and a.'||v_feature_type||'_id IN ('||v_array||');';

	   	GET DIAGNOSTICS affected_rows=row_count;
	ELSE
		EXECUTE 'UPDATE '||v_feature_type||' a set streetaxis_id = q.streetaxis_id, '||v_fieldtoupdate||' = q.postnumber from (
		SELECT distinct on ('||v_feature_type||'_id) '||v_feature_type||'_id, ea.streetaxis_id ,'||v_partialquery3||'
	    FROM '||v_feature_type||' a
	        JOIN ext_address ea ON ST_DWithin(a.the_geom, ea.the_geom, '||v_searchbuffer||')
		'||v_partialquery||'
		'||v_partialquery2||' '||v_partialquery4||' '||v_expl||' '||v_state||'
	    ORDER BY '||v_feature_type||'_id, ST_Distance(a.the_geom, ea.the_geom))q
	    where a.'||v_feature_type||'_id=q.'||v_feature_type||'_id '||v_expl||' '||v_state||';';

	   	GET DIAGNOSTICS affected_rows=row_count;
	END IF;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3614", "function":"3198", "parameters":{"affected_rows":"'||affected_rows||'","v_feature_type":"'||v_feature_type||'"}, "fcount":"'||affected_rows||'", "fid":"486", "is_process":true}}$$)';

	--info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=486 order by id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');
	v_result_info := COALESCE(v_result_info, '{}');
	v_version := COALESCE(v_version, '');

	-- return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "version":"'||v_version||'"'||
            ',"message":{"level":1, "text":""},"body":{"data": {"info":'||v_result_info||'}}}')::json, 3198, null, null, null);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
