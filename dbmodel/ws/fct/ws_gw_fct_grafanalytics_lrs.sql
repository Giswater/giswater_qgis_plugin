/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: XXXX

DROP FUNCTION IF EXISTS ws_sample.gw_fct_grafanalytics_lrs(json);
CREATE OR REPLACE FUNCTION ws_sample.gw_fct_grafanalytics_lrs(p_data json)
RETURNS json AS
$BODY$

/*
TO EXECUTE
SELECT ws_sample.gw_fct_grafanalytics_lrs('{"data":{"parameters":{"exploitation":"[1,2]"}}}');


delete from ws_sample.audit_log_data;
delete from ws_sample.temp_anlgraf

SELECT * FROM ws_sample.anl_arc WHERE fprocesscat_id=34 AND cur_user=current_user
SELECT * FROM ws_sample.anl_node WHERE fprocesscat_id=34 AND cur_user=current_user
SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=34 AND user_name=current_user


*/

DECLARE
v_affectedrows numeric; 
v_cont1 integer default 0;
v_class text = 'LRS';
v_feature record;
v_expl json;
v_fprocesscat_id integer;
v_querytext text;
v_result_info json; -- provides info about how have been done function
v_result_point json; -- nice to show as log all nodes with pk
v_result text;
v_count	integer;
v_version text;
v_srid integer;
v_input json;
v_visible_layer text;
v_error_context text;
v_querynode text;
v_queryarc text;
v_costfield text;
v_valuefield text;
v_headerfield text;
v_layer record;

BEGIN

	-- Search path
	SET search_path = "ws_sample", public;

	-- get variables (from input)
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');

	-- get variables (from config_param_system)
	v_costfield = (SELECT (value::json->>'arc')::json->>'costField' FROM config_param_system WHERE parameter='grafanalytics_lrs_graf');
	v_valuefield = (SELECT (value::json->>'nodeChild')::json->>'valueField' FROM config_param_system WHERE parameter='grafanalytics_lrs_graf');
	v_headerfield = (SELECT (value::json->>'nodeChild')::json->>'headerField' FROM config_param_system WHERE parameter='grafanalytics_lrs_graf');
	
	-- setting cost field when has not configure value
	IF v_costfield IS NULL THEN
		v_costfield =  '1::float';
	END IF;
	
	-- get variables (from version)
	SELECT giswater, epsg INTO v_version, v_srid FROM version order by 1 desc limit 1;

	-- set variables
	v_fprocesscat_id=XX;  

	-- data quality analysis
	v_input = '{"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}'::json;
	PERFORM gw_fct_om_check_data(v_input);

	-- todo: manage result of quality data in case of errors
	

	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, concat('DYNAMIC LINEAR REFERENCING SYSTEM'));
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, concat('---------------------------------------------------'));
	
	-- reset tables (graf & audit_log)
	DELETE FROM temp_anlgraf;
	DELETE FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat_id AND user_name=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id=XX AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id=XX AND cur_user=current_user;
	DELETE FROM audit_check_data WHERE fprocesscat_id=XX AND user_name=current_user;

	-- reset user's state
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, 
	concat('INFO: State have been forced to ''1'''));

	-- reset user's psectors
	DELETE FROM selector_psector WHERE cur_user=current_user;
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, 
	concat('INFO: All psectors have been disabled to execute this analysis'));

	-- reset user's exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation where macroexpl_id IN
		(SELECT distinct(macroexpl_id) FROM ws_sample.exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl)a  ON expl=expl_id);
	END IF;

	-- water:  dry (0) wet (1)
	-- flag: open (0) closed (1)
	-- checkf: not used (0) used (1)
	-- length: arc length
	-- cost: cost value (only when lrs analytics is used)
	-- value: result value (only when lrs analytics is used)

	-- create graf (all boundary conditions are opened, flag=0)
	EXECUTE 'INSERT INTO temp_anlgraf ( arc_id, node_1, node_2, water, flag, checkf, length, cost, value )
	SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0, st_length(the_geom), '||v_costfield||', 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0, st_length(the_geom), '||v_costfield||', 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE';

	-- getting v_querys of node header (node_id and toarc) from config variable
	v_querynode = 'SELECT json_array_elements_text((value::json->>''headers'')::json)::json->>''node'' AS node_id 
				  FROM config_param_system WHERE parameter=''grafanalytics_lrs_graf''';
			
	v_queryarc =  'SELECT json_array_elements_text((value::json->>''headers'')::json)::json->>''node'' as node_id,
			      json_array_elements_text(((json_array_elements_text((value::json->>''headers'')::json))::json->>''toArc'')::json) as to_arc 
				  FROM config_param_system WHERE parameter=''grafanalytics_lrs_graf'' order by 1,2';

	-- close boundary conditions, setting flag=1 for all nodes that fits on graf delimiters
	EXECUTE 'UPDATE temp_anlgraf SET flag=1 WHERE node_1 IN ('||v_querynode||') OR  node_2 IN ('||v_querynode||')';
		
	-- open boundary conditions, setting again flag=0 for graf delimiters that have been setted to 1 on query before BUT ONLY ENABLING the right sense (to_arc)
	EXECUTE 'UPDATE temp_anlgraf SET flag=0 WHERE id IN (SELECT id FROM temp_anlgraf 
								JOIN ('||v_queryarc||') a ON to_arc::integer=arc_id::integer 
								WHERE node_id::integer=node_1::integer)';
					
	-- starting process
	LOOP
	
		-- looking for pick one graf header
		v_querytext = 'SELECT * FROM temp_anlgraf WHERE node_id IN ('||v_querynode||') AND checkf = 0 LIMIT 1 ) a';
		IF v_querytext IS NOT NULL THEN
			RAISE NOTICE 'v_querytext %', v_querytext;
			EXECUTE v_querytext INTO v_feature;
		END IF;

		-- finish process when graf header is not found
		EXIT WHEN v_feature.id IS NULL;

		-- reset water flag
		UPDATE temp_anlgraf SET water=0;
				
		-- set the starting element
		v_querytext = 'UPDATE temp_anlgraf SET water=1 WHERE node_1='||quote_literal(v_feature.node_id)||' AND flag=0'; 
		EXECUTE v_querytext;

		-- inundation process
		LOOP	
			v_cont1 = v_cont1+1;
			EXECUTE 'UPDATE temp_anlgraf n SET water= 1, flag=n.flag+1, checkf=1, value = length*cost + a.value
			FROM v_anl_graf a WHERE n.node_1::integer = a.node_1::integer AND n.arc_id = a.arc_id';

			-- todo: possible update of anl_node values here

			GET DIAGNOSTICS v_affectedrows =row_count;
			EXIT WHEN v_affectedrows = 0;
			EXIT WHEN v_cont1 = 200;
		END LOOP;
		
		-- insert arc results into anl table
		EXECUTE 'INSERT INTO anl_arc (fprocesscat_id, arccat_id, arc_id, the_geom, descript) 
			SELECT DISTINCT ON (arc_id)'||v_fprocesscat_id||', arccat_id, a.arc_id, the_geom, concat (''{"value":'',value,'', "header":'''||v_feature.node_id||'}'') 
			FROM (SELECT arc_id, max(water) as water, value FROM temp_anlgraf WHERE water=1 GROUP by arc_id) a 
			JOIN v_edit_arc b ON a.arc_id::integer=b.arc_id::integer';
	
		-- todo: possible update of anl_node values here
		EXECUTE 'INSERT INTO anl_node (fprocesscat_id, nodecat_id, node_id, the_geom, descript) 
			SELECT DISTINCT ON (node_id) '||v_fprocesscat_id||', nodecat_id, b.node_id, the_geom, concat (''{"value":'',value,'', "header":'''||
			v_feature.node_id||'}'')
			FROM (SELECT min(value), node_id FROM (SELECT node_1 as node_id, water, value FROM temp_anlgraf UNION SELECT node_2, water, value FROM temp_anlgraf)a
			GROUP BY node_id, water HAVING water=1)b JOIN v_edit_node c ON c.node_id::integer=b.node_id::integer';

	END LOOP;
		
	-- update fields for node layers (value and header)
	FOR v_layer IN SELECT child_layer FROM cat_feature
	LOOP
		EXECUTE 'UPDATE '||v_layer||' SET '||v_valuefield||' = a.descript::json->>''value'', '||v_headerfield||
		' = a.descript::json->>''header'' FROM anl_node a WHERE fprocesscat_id=XX AND a.node_id=node.node_id AND cur_user=current_user';
	END LOOP;
	INSERT INTO audit_check_data (fprocesscat_id, error_message) 
	VALUES (v_fprocesscat_id, concat('WARNING: LRS attributes on node features have been updated by this process'));
		

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=v_fprocesscat_id order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_visible_layer := COALESCE(v_visible_layer, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	
--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"setVisibleLayers":["'||v_visible_layer||'"],'||
				'"point":'||v_result_point||','||
		       '}'||
	    '}')::json;

	
--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	 GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	 RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
