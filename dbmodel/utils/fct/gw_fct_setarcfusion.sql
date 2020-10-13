/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2112

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_fusion(character varying, character varying, date);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_fusion(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setarcfusion (p_data json)
RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_arc_fusion($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["1004"]},"data":{"workcat_id_end":"work1","enddate":"2020-02-05"}}$$)

-- fid: 214

*/

DECLARE

v_point_array1 geometry[];
v_point_array2 geometry[];
v_count integer;
v_exists_node_id varchar;
v_new_record SCHEMA_NAME.v_edit_arc;
v_my_record1 SCHEMA_NAME.v_edit_arc;
v_my_record2 SCHEMA_NAME.v_edit_arc;
v_arc_geom geometry;
v_project_type text;
rec_addfield1 record;
rec_addfield2 record;
rec_param record;
v_vnode integer;
v_node_geom public.geometry;
v_version  text;

v_result text;
v_result_info text;
v_result_point text;
v_result_line text;
v_result_polygon text;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_hide_form boolean;
v_array_addfields text[];
v_array_node_id json;
v_node_id text;
v_workcat_id_end text;
v_enddate date;
v_state_node int2;
v_state_arc int2;

BEGIN

    -- Search path
    SET search_path = SCHEMA_NAME, public;

    SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version LIMIT 1;

    --set current process as users parameter
    DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

    INSERT INTO config_param_user (value, parameter, cur_user)
    VALUES (txid_current(),'utils_cur_trans',current_user );

    -- Get parameters from configs table
    SELECT value::boolean INTO v_hide_form FROM config_param_user where parameter='qgis_form_log_hidden' AND cur_user=current_user;
   
   -- Get parameters from input json
   v_array_node_id = lower(((p_data ->>'feature')::json->>'id')::text);
   v_node_id = (SELECT json_array_elements_text(v_array_node_id)); 
   v_workcat_id_end = lower(((p_data ->>'data')::json->>'workcat_id_end')::text);
   v_enddate = ((p_data ->>'data')::json->>'enddate')::date;

    -- delete old values on result table
    DELETE FROM audit_check_data WHERE fid=214 AND cur_user=current_user;
    
    -- Starting process
    INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (214, null, 4, 'ARC FUSION');
    INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (214, null, 4, '-------------------------------------------------------------');

    -- Check if the node exists
    SELECT node_id INTO v_exists_node_id FROM v_edit_node WHERE node_id = v_node_id;
    SELECT the_geom INTO v_node_geom FROM node WHERE node_id = v_node_id;
 
    -- Compute proceed
    IF FOUND THEN

        INSERT INTO audit_check_data (fid,  criticity, error_message)
        VALUES (214, 1, concat('Fusion arcs using node: ', v_exists_node_id,'.'));

        -- Find arcs sharing node
        SELECT COUNT(*) INTO v_count FROM v_edit_arc WHERE node_1 = v_node_id OR node_2 = v_node_id;

        -- Accepted if there are just two distinct arcs
        IF v_count = 2 THEN

            -- Get both arc features
            SELECT * INTO v_my_record1 FROM v_edit_arc WHERE node_1 = v_node_id OR node_2 = v_node_id ORDER BY arc_id DESC LIMIT 1;
            SELECT * INTO v_my_record2 FROM v_edit_arc WHERE node_1 = v_node_id OR node_2 = v_node_id ORDER BY arc_id ASC LIMIT 1;

            -- get states
            SELECT state INTO v_state_node FROM node WHERE node_id = v_node_id;
            SELECT state INTO v_state_arc FROM arc WHERE arc_id = v_my_record1.arc_id;
            
            INSERT INTO audit_check_data (fid,  criticity, error_message)
            VALUES (214, 1, concat('Arcs related to selected node: ', v_my_record1.arc_id,', ',v_my_record2.arc_id,'.'));

            -- Compare arcs
            IF  v_my_record1.arccat_id = v_my_record2.arccat_id AND v_my_record1.sector_id = v_my_record2.sector_id AND
                v_my_record1.expl_id = v_my_record2.expl_id AND v_my_record1.state = v_my_record2.state THEN

			-- Final geometry
			IF v_my_record1.node_1 = v_node_id THEN
			    IF v_my_record2.node_1 = v_node_id THEN
				v_point_array1 := ARRAY(SELECT (ST_DumpPoints(ST_Reverse(v_my_record1.the_geom))).geom);
				v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_my_record2.the_geom)).geom));
			    ELSE
				v_point_array1 := ARRAY(SELECT (ST_DumpPoints(v_my_record2.the_geom)).geom);
				v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_my_record1.the_geom)).geom));
			    END IF;
			ELSE
			    IF v_my_record2.node_1 = v_node_id THEN
				v_point_array1 := ARRAY(SELECT (ST_DumpPoints(v_my_record1.the_geom)).geom);
				v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_my_record2.the_geom)).geom));
			    ELSE
				v_point_array1 := ARRAY(SELECT (ST_DumpPoints(v_my_record2.the_geom)).geom);
				v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(ST_Reverse(v_my_record1.the_geom))).geom));
			    END IF;
			END IF;

		    v_arc_geom := ST_MakeLine(v_point_array2);

		    SELECT * INTO v_new_record FROM v_edit_arc WHERE arc_id = v_my_record1.arc_id;

		    -- Create a new arc values
		    v_new_record.the_geom := v_arc_geom;
		    v_new_record.node_1 := (SELECT node_id FROM v_edit_node WHERE ST_DWithin(ST_StartPoint(v_arc_geom), v_edit_node.the_geom, 0.01) LIMIT 1);
		    v_new_record.node_2 := (SELECT node_id FROM v_edit_node WHERE ST_DWithin(ST_EndPoint(v_arc_geom), v_edit_node.the_geom, 0.01) LIMIT 1);
		    v_new_record.arc_id := (SELECT nextval('urn_id_seq'));

		    --Compare addfields and assign them to new arc
		    FOR rec_param IN SELECT DISTINCT parameter_id, param_name FROM man_addfields_value
			JOIN sys_addfields ON sys_addfields.id = man_addfields_value.parameter_id WHERE feature_id=v_my_record1.arc_id
			OR feature_id=v_my_record2.arc_id
		    LOOP

		    SELECT * INTO rec_addfield1 FROM man_addfields_value WHERE feature_id=v_my_record1.arc_id and parameter_id=rec_param.parameter_id;
		    SELECT * INTO rec_addfield2 FROM man_addfields_value WHERE feature_id=v_my_record2.arc_id and parameter_id=rec_param.parameter_id;

			IF rec_addfield1.value_param!=rec_addfield2.value_param  THEN
			    EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
			    "data":{"message":"3008", "function":"2112","debug_msg":null}}$$)' INTO v_audit_result;

			ELSIF rec_addfield2.value_param IS NULL and rec_addfield1.value_param IS NOT NULL THEN
			    UPDATE man_addfields_value SET feature_id=v_new_record.arc_id WHERE feature_id=v_my_record1.arc_id AND parameter_id=rec_param.parameter_id;
			ELSIF rec_addfield1.value_param IS NULL and rec_addfield2.value_param IS NOT NULL THEN
			    UPDATE man_addfields_value SET feature_id=v_new_record.arc_id WHERE feature_id=v_my_record2.arc_id AND parameter_id=rec_param.parameter_id;
			ELSE
			   UPDATE man_addfields_value SET feature_id=v_new_record.arc_id WHERE feature_id=v_my_record1.arc_id AND parameter_id=rec_param.parameter_id;
		       END IF;

			IF  rec_addfield1.value_param!=rec_addfield2.value_param  THEN
			
			ELSE
			    v_array_addfields:= array_append(v_array_addfields, rec_param.param_name::text);
			END IF;
		    END LOOP;

		    IF v_array_addfields is not null THEN
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (214, 1, concat('Copy values for addfields: ', array_to_string(v_array_addfields,','),'.'));
		    END IF;

		    -- temporary dissable the arc_searchnodes_control in order to use the node1 and node2 getted before
		    -- to get values topocontrol arc needs to be before, but this is not possible
		    UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'activated', false) WHERE parameter = 'edit_arc_searchnodes';
		    INSERT INTO v_edit_arc SELECT v_new_record.*;
		    UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'activated', true) WHERE parameter = 'edit_arc_searchnodes';

		    UPDATE arc SET node_1=v_new_record.node_1, node_2=v_new_record.node_2 where arc_id=v_new_record.arc_id;
			    
		    --Insert data on audit_arc_traceability table
		    INSERT INTO audit_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", cur_user) 
		    VALUES ('ARC FUSION', v_new_record.arc_id, v_my_record2.arc_id,v_my_record1.arc_id,v_exists_node_id, CURRENT_TIMESTAMP, CURRENT_USER);

			-- update nodes
			SELECT count(node_id) INTO v_count FROM node WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			IF v_count > 0 THEN
				UPDATE node SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (214, 1, concat('Reconnect ',v_count,' nodes.'));
			END IF;

			-- update links related to node
			IF  (SELECT link_id FROM link WHERE exit_type='NODE' and exit_id=v_node_id LIMIT 1) IS NOT NULL THEN
			    
				-- insert one vnode (indenpendently of the number of links. Only one vnode must replace the node)
				INSERT INTO vnode (state, the_geom) 
				VALUES (v_new_record.state, v_node_geom) 
				RETURNING vnode_id INTO v_vnode;
				
				-- update link with new vnode
				UPDATE link SET exit_type='VNODE', exit_id=v_vnode WHERE exit_type='NODE' and exit_id=v_node_id;  
			END IF;    
			
		    IF v_state_node = 1 THEN

			-- update elements
			SELECT count(id) INTO v_count FROM element_x_arc WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			IF v_count > 0 THEN
				UPDATE element_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (214, 1, concat('Copy ',v_count,' elements from old arcs to new one.'));
			END IF;

			-- update documents
			SELECT count(id) INTO v_count FROM doc_x_arc WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			IF v_count > 0 THEN
				UPDATE doc_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (214, 1, concat('Copy ',v_count,' documents from old arcs to new one.'));
			END IF;

			-- update visits
			SELECT count(id) INTO v_count FROM om_visit_x_arc WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			IF v_count > 0 THEN
				UPDATE om_visit_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (214, 1, concat('Copy ',v_count,' visits from old arcs to new one.'));
			END IF;
		    
			-- update connecs
			SELECT count(connec_id) INTO v_count FROM connec WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			IF v_count > 0 THEN
				UPDATE connec SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (214, 1, concat('Reconnect ',v_count,' connecs.'));
			END IF;

			-- update gullies
			IF v_project_type='UD' THEN
				SELECT count(gully_id) INTO v_count FROM gully WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			IF v_count > 0 THEN
				UPDATE gully SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;

				INSERT INTO audit_check_data (fid,  criticity, error_message)
				    VALUES (214, 1, concat('Reconnect ',v_count,' gullies.'));
				END IF;
			END IF;

			-- Delete arcs
			DELETE FROM arc WHERE arc_id = v_my_record1.arc_id;
			DELETE FROM arc WHERE arc_id = v_my_record2.arc_id;

			-- Moving to obsolete the previous node
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Change state of node  ',v_node_id,' to obsolete.'));
			UPDATE node SET state=0, workcat_id_end=v_workcat_id_end, enddate=v_enddate WHERE node_id = v_node_id;
		    
		    ELSIF v_state_node = 2 THEN -- psector

			-- update connecs
			SELECT count(connec_id) INTO v_count FROM plan_psector_x_connec WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			IF v_count > 0 THEN
				UPDATE plan_psector_x_connec SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
				INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Reconnect ',v_count,' connecs.'));
			END IF;

			-- update gullies
			IF v_project_type = 'UD' THEN
				SELECT count(gully_id) INTO v_count FROM plan_psector_x_gully WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
				IF v_count > 0 THEN
					UPDATE plan_psector_x_gully SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
					INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Reconnect ',v_count,' gullies.'));
				END IF;
			END IF;
			
			-- Delete arcs
			DELETE FROM arc WHERE arc_id = v_my_record1.arc_id;
			DELETE FROM arc WHERE arc_id = v_my_record2.arc_id;

			-- Delete node
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (214, 1, concat('Delete planned node ',v_node_id));
			DELETE FROM node WHERE node_id = v_node_id;
		
		    END IF;
		    
		    INSERT INTO audit_check_data (fid,  criticity, error_message)
		    VALUES (214, 1, concat('Delete arcs: ',v_my_record1.arc_id,', ',v_my_record2.arc_id,'.'));

            -- Arcs has different types
            ELSE
                EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                "data":{"message":"2004", "function":"2112","debug_msg":null}}$$)' INTO v_audit_result;

            END IF;
         
        -- Node has not 2 arcs
        ELSE
            EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            "data":{"message":"2006", "function":"2112","debug_msg":null}}$$)' INTO v_audit_result;  
        END IF;

    -- Node not found
    ELSE 

        EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
        "data":{"message":"2002", "function":"2112","debug_msg":null}}$$)' INTO v_audit_result;  

    END IF;


   -- EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
   -- "data":{"message":"0", "function":"2112","debug_msg":null}}$$)' INTO v_audit_result;  

	-- get results
    -- info

    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
    FROM (SELECT id, error_message as message FROM audit_check_data 
    WHERE cur_user="current_user"() AND fid=214 ORDER BY criticity desc, id asc) row;
    
    IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Arc fusion done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;

    v_result_info := COALESCE(v_result, '{}'); 
    v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

    v_result_point = '{"geometryType":"", "features":[]}';
    v_result_line = '{"geometryType":"", "features":[]}';
    v_result_polygon = '{"geometryType":"", "features":[]}';

    v_status := COALESCE(v_status, '{}'); 
    v_level := COALESCE(v_level, '0'); 
    v_message := COALESCE(v_message, '{}'); 
    v_hide_form := COALESCE(v_hide_form, true); 

	--  Return
    RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{ "info":'||v_result_info||','||
                '"point":'||v_result_point||','||
                '"line":'||v_result_line||','||
                '"polygon":'||v_result_polygon||'}'||
                ', "actions":{"hideForm":' || v_hide_form || '}'||
               '}'
        '}')::json, 2112);

    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
    RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


