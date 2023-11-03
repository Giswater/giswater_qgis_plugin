/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3068


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setendfeature(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/* example
fid = 518


	SELECT SCHEMA_NAME.gw_fct_setendfeature($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	"form":{}, "feature":{["featureType":"arc", "featureId":["113935", "2076", "2215"]],
			      ["featureType":"node", "featureId":["113935", "2076", "2215"]], 
			      ["featureType":"connec", "featureId":["113935", "2076", "2215"]],
			      ["featureType":"gully", "featureId":["113935", "2076", "2215"]]}, 
	"data":{"filterFields":{}, "pageInfo":{}, "state_type":"1", "workcat_id_end":"work1", 
	"enddate":"2020/12/04", "workcat_date":"2017/12/06", "description":"Description work1"}}$$);
*/

DECLARE
v_id  text;
v_version text;
v_featuretype text;
v_error_context text;
v_num_feature integer;
v_psector_list text;
v_psector_id text;
v_id_list integer[];
v_feature_id_value integer;
v_result_info text;
v_projecttype text;
v_state_type integer;
v_workcat_id_end text;
v_enddate date;
v_audit_result text;
v_status text;
v_level integer;
v_message text;
v_result text;
v_count integer = 0;
v_count_feature integer = 0;
v_querytext text;
v_fid integer = 518;
v_feature json;
v_feature_element json;
v_feature_type text;
v_element_id text;

BEGIN
	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	--  get api version
	EXECUTE 'SELECT value FROM config_param_system WHERE parameter=''admin_version'''
	INTO v_version;
      
	SELECT project_type INTO v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	--set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );

	-- Get input parameters:
	v_feature := (p_data ->> 'feature')::json;
	v_featuretype := lower((p_data ->> 'feature')::json->> 'featureType');
	v_id := (p_data ->> 'feature')::json->> 'featureId';
	v_state_type =  (p_data ->> 'data')::json->> 'state_type';
	v_workcat_id_end =  (p_data ->> 'data')::json->> 'workcat_id_end';
	v_enddate =  ((p_data ->> 'data')::json->> 'enddate')::date;

	select array_agg(a) into v_id_list from json_array_elements_text(v_id::json) a;

	-- manage log
	DELETE FROM audit_check_data WHERE fid = v_fid AND cur_user=current_user;


	-- build log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('END FEATURE'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '--------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '-------');

	FOR v_feature_element IN SELECT json_array_elements(v_feature)
    loop
	    v_count_feature = 0;
	    v_feature_type = v_feature_element->>'featureType';

		IF v_feature_type = 'arc' THEN
			FOR v_feature_id_value IN SELECT value FROM jsonb_array_elements_text((v_feature_element->>'featureId')::jsonb)
    		loop
				v_count_feature = v_count_feature + 1;
				--remove links related to arc
				EXECUTE 'DELETE FROM link
				WHERE link_id IN (SELECT link_id FROM link l JOIN connec c ON c.connec_id = l.feature_id WHERE c.arc_id = '|| quote_literal(v_feature_id_value)||')';

				EXECUTE 'UPDATE connec SET arc_id = NULL WHERE arc_id = '|| quote_literal(v_feature_id_value)||';';

				IF v_projecttype = 'UD' THEN
					--remove links related to arc
					EXECUTE 'DELETE FROM link
					WHERE link_id IN (SELECT link_id FROM link l JOIN gully g ON g.gully_id = l.feature_id WHERE g.arc_id = '|| quote_literal(v_feature_id_value)||')';

					EXECUTE 'UPDATE gully SET arc_id = NULL WHERE arc_id = '|| quote_literal(v_feature_id_value)||'';
				END IF;

				-- specific log for arcs which have elements associated to other features
				if v_projecttype = 'UD' then
					v_querytext = 'With b as (select element_id, arc_id as feature_id from element_x_arc
						union select element_id, node_id as feature_id from element_x_node
						union select element_id, connec_id as feature_id from element_x_connec
						union select element_id, gully_id as feature_id from element_x_gully),
						c as (select element_id, state from element_x_'||v_feature_type||' join element using (element_id) where '||v_feature_type||'_id= '||quote_literal(v_feature_id_value)||')
						select count(*)-1, element_id from b join c using(element_id) where state=1 group by b.element_id having count(*)>1';
				elsif v_projecttype = 'WS' then
					v_querytext = 'With b as (select element_id, arc_id as feature_id from element_x_arc
						union select element_id, node_id as feature_id from element_x_node
						union select element_id, connec_id as feature_id from element_x_connec),
						c as (select element_id, state from element_x_'||v_feature_type||' join element using (element_id) where '||v_feature_type||'_id= '||quote_literal(v_feature_id_value)||')
						select count(*)-1, element_id from b join c using(element_id) where state=1 group by b.element_id having count(*)>1';
				end if;

				EXECUTE ' SELECT count(*) FROM ('||v_querytext||' ) a' INTO v_count;
				EXECUTE ' SELECT string_agg(element_id,'', '') FROM ('||v_querytext||' ) a' INTO v_element_id;

				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, concat(v_count , ' additional element(s) related to the downgraded arc (',v_feature_id_value,') was/were also related to another operative feature(s) (element_id:',v_element_id,')'));
				END IF;
			END LOOP;

			-- generic log for arcs
			IF v_count_feature > 0 THEN
				INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat(v_count_feature, ' arc(s) have been downgraded'));
			END IF;


		ELSIF v_feature_type = 'node' THEN

			FOR v_feature_id_value IN SELECT value FROM jsonb_array_elements_text((v_feature_element->>'featureId')::jsonb)
    		loop
	    		v_count_feature = v_count_feature + 1;
				--check if node is involved into psector because of arc
				EXECUTE 'SELECT count(arc.arc_id)  FROM arc WHERE (node_1='|| quote_literal(v_feature_id_value)||' OR node_2='|| quote_literal(v_feature_id_value)||') AND arc.state = 2'
				INTO v_num_feature;

				IF v_num_feature > 0 THEN

					EXECUTE 'SELECT string_agg(name::text, '', ''), string_agg(psector_id::text, '', '')
					FROM plan_psector_x_arc JOIN plan_psector USING (psector_id) where arc_id IN
					(SELECT arc.arc_id FROM arc WHERE (node_1='||quote_literal(v_feature_id_value)||' OR node_2='|| quote_literal(v_feature_id_value)||') AND arc.state = 2)'
					INTO v_psector_list, v_psector_id;

					IF v_psector_id IS NOT NULL THEN
						EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
						"data":{"message":"3142", "function":"3068","debug_msg":"'||v_psector_list||'"}}$$);' INTO v_audit_result;
					END IF;
				END IF;

				--check if node is related to on service arcs
				EXECUTE 'SELECT count(arc.arc_id)  FROM arc WHERE (node_1='|| quote_literal(v_feature_id_value)||' OR node_2='|| quote_literal(v_feature_id_value)||') AND arc.state = 1'
				INTO v_num_feature;

				IF v_num_feature > 0 THEN

					v_result = 'SELECT array_agg(arc_id) FROM arc WHERE (node_1='|| quote_literal(v_feature_id_value)||' OR node_2='|| quote_literal(v_feature_id_value)||') AND arc.state = 1';

					EXECUTE v_result INTO v_result;

					v_result=concat(v_feature_id_value,' has associated arcs ',v_result);

					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
					"data":{"message":"1072", "function":"3068","debug_msg":"'||v_result||'"}}$$);' INTO v_audit_result;
				END IF;

				-- specific log when a node is related to more than 1 node/arc/connec/gully
				if v_projecttype = 'UD' then
					v_querytext = 'With b as (select element_id, arc_id as feature_id from element_x_arc
						union select element_id, node_id as feature_id from element_x_node
						union select element_id, connec_id as feature_id from element_x_connec
						union select element_id, gully_id as feature_id from element_x_gully),
						c as (select element_id, state from element_x_'||v_feature_type||' join element using (element_id) where '||v_feature_type||'_id= '||quote_literal(v_feature_id_value)||')
						select count(*)-1, element_id from b join c using(element_id) where state=1 group by b.element_id having count(*)>1';
				elsif v_projecttype = 'WS' then
					v_querytext = 'With b as (select element_id, arc_id as feature_id from element_x_arc
						union select element_id, node_id as feature_id from element_x_node
						union select element_id, connec_id as feature_id from element_x_connec),
						c as (select element_id, state from element_x_'||v_feature_type||' join element using (element_id) where '||v_feature_type||'_id= '||quote_literal(v_feature_id_value)||')
						select count(*)-1, element_id from b join c using(element_id) where state=1 group by b.element_id having count(*)>1';
				end if;

				EXECUTE ' SELECT count(*) FROM ('||v_querytext||' ) a' INTO v_count;
				EXECUTE ' SELECT string_agg(element_id,'', '') FROM ('||v_querytext||' ) a' INTO v_element_id;

				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, concat(v_count , ' additional element(s) related to the downgraded node (',v_feature_id_value,') was/were also related to another operative feature(s) (element_id:',v_element_id,')'));
				END IF;
			END LOOP;

			-- generic log for nodes
			IF v_count_feature > 0 THEN
				INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat(v_count_feature, ' node(s) have been downgraded'));
			END IF;

		ELSIF v_feature_type = 'connec' then

			FOR v_feature_id_value IN SELECT value FROM jsonb_array_elements_text((v_feature_element->>'featureId')::jsonb)
    		loop
	    		v_count_feature = v_count_feature + 1;
				-- specific log when a connec is related to more than 1 node/arc/connec/gully
				if v_projecttype = 'UD' then
					v_querytext = 'With b as (select element_id, arc_id as feature_id from element_x_arc
						union select element_id, node_id as feature_id from element_x_node
						union select element_id, connec_id as feature_id from element_x_connec
						union select element_id, gully_id as feature_id from element_x_gully),
						c as (select element_id, state from element_x_'||v_feature_type||' join element using (element_id) where '||v_feature_type||'_id= '||quote_literal(v_feature_id_value)||')
						select count(*)-1, element_id from b join c using(element_id) where state=1 group by b.element_id having count(*)>1';
				elsif v_projecttype = 'WS' then
					v_querytext = 'With b as (select element_id, arc_id as feature_id from element_x_arc
						union select element_id, node_id as feature_id from element_x_node
						union select element_id, connec_id as feature_id from element_x_connec),
						c as (select element_id, state from element_x_'||v_feature_type||' join element using (element_id) where '||v_feature_type||'_id= '||quote_literal(v_feature_id_value)||')
						select count(*)-1, element_id from b join c using(element_id) where state=1 group by b.element_id having count(*)>1';
				end if;

				EXECUTE ' SELECT count(*) FROM ('||v_querytext||' ) a' INTO v_count;
				EXECUTE ' SELECT string_agg(element_id,'', '') FROM ('||v_querytext||' ) a' INTO v_element_id;

				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, concat(v_count , ' additional element(s) related to the downgraded connec (',v_feature_id_value,') was/were also related to another operative feature(s) (element_id:',v_element_id,')'));
				END IF;
			END LOOP;

			-- generic log for connecs
			IF v_count_feature > 0 THEN
				INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat(v_count_feature, ' connec(s) have been downgraded'));
			END IF;

		ELSIF v_feature_type = 'gully' THEN
			FOR v_feature_id_value IN SELECT value FROM jsonb_array_elements_text((v_feature_element->>'featureId')::jsonb)
    		loop
	    		v_count_feature = v_count_feature + 1;
				-- specific log when a gully is related to more than 1 node/arc/connec/gully
				v_querytext = 'with b as (select element_id, arc_id as feature_id from element_x_arc
						union select element_id, node_id as feature_id from element_x_node
						union select element_id, connec_id as feature_id from element_x_connec
						union select element_id, gully_id as feature_id from element_x_gully),
						c as (select element_id, state from element_x_'||v_feature_type||' join element using (element_id) where '||v_feature_type||'_id= '||quote_literal(v_feature_id_value)||')
						select count(*)-1, element_id from b join c using(element_id) where state=1 group by b.element_id having count(*)>1';

				EXECUTE ' SELECT count(*) FROM ('||v_querytext||' ) a' INTO v_count;
				EXECUTE ' SELECT string_agg(element_id,'', '') FROM ('||v_querytext||' ) a' INTO v_element_id;

				IF v_count > 0 THEN
					INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 2, concat(v_count , ' additional element(s) related to the downgraded gully (',v_feature_id_value,') was/were also related to another operative feature(s) (element_id:',v_element_id,')'));
				END IF;
			end loop;

			-- generic log for connecs
			IF v_count_feature > 0 THEN
				INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (v_fid, 1, concat(v_count_feature, ' gully(s) have been downgraded'));
			END IF;
		END IF;

		IF v_audit_result is null THEN

			FOR v_feature_id_value IN SELECT value FROM jsonb_array_elements_text((v_feature_element->>'featureId')::jsonb)
    		loop

				-- perform state control for connects
				IF v_feature_type='connec' or v_feature_type='gully' then
					PERFORM gw_fct_state_control(upper(v_feature_type::varchar), v_feature_id_value::varchar, 0, 'UPDATE');
				END IF;

				IF v_workcat_id_end IS NOT NULL THEN

					EXECUTE 'UPDATE '||v_feature_type||' SET state = 0, state_type='||v_state_type||',
					workcat_id_end = '||quote_literal(v_workcat_id_end)||',
					enddate = '||quote_literal(v_enddate)||' WHERE '||v_feature_type||'_id ='||quote_literal(v_feature_id_value)||'';

					-- related elements to obsolete
					EXECUTE 'UPDATE element e SET state = 0, state_type='||v_state_type||',
					workcat_id_end = '||quote_literal(v_workcat_id_end)||',
					enddate = '||quote_literal(v_enddate)||' FROM element_x_'||v_feature_type||' f WHERE f.element_id=e.element_id AND '||v_feature_type||'_id ='||quote_literal(v_feature_id_value)||'';

				ELSE

					EXECUTE 'UPDATE '||v_feature_type||' SET state = 0, state_type='||v_state_type||',
					enddate = '||quote_literal(v_enddate)||' WHERE '||v_feature_type||'_id ='||quote_literal(v_feature_id_value)||'';

					-- related elements to obsolete
					EXECUTE 'UPDATE element e SET state = 0, state_type='||v_state_type||',
					enddate = '||quote_literal(v_enddate)||' FROM element_x_'||v_feature_type||' f WHERE f.element_id=e.element_id AND '||v_feature_type||'_id ='||quote_literal(v_feature_id_value)||'';
				END IF;
			
				-- related link to obsolete
				IF v_feature_type='connec' or v_feature_type='gully' then
					EXECUTE 'UPDATE link SET state = 0 WHERE feature_id = '|| quote_literal(v_feature_id_value)||';';
				END IF;

			END LOOP;
		END IF;
	END LOOP;

	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Process done successfully';
	ELSE

		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;
	
	END IF;

	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	-- build log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '');

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND
	fid = v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":"'||v_level||'", "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||				
			'}}'||
	    '}')::json, 3068, null, null, null);

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$function$
;
