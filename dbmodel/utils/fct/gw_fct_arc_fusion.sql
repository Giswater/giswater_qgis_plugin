/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2112


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_arc_fusion(character varying, character varying, date);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_fusion(node_id_arg character varying, workcat_id_end_aux character varying, enddate_aux date)

  RETURNS json AS
$BODY$
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
    rec_param integer;
    v_vnode integer;
    v_node_geom public.geometry;
    v_version  text;

    v_result text;
    v_result_info text;
    v_result_point text;
    v_result_line text;
    v_result_polygon text;
    v_error_context text;

BEGIN

    -- Search path
    SET search_path = SCHEMA_NAME, public;

    SELECT wsoftware, giswater INTO v_project_type, v_version FROM version LIMIT 1;

        -- delete old values on result table
    DELETE FROM audit_check_data WHERE fprocesscat_id=114 AND user_name=current_user;
    
    -- Starting process
    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 4, 'ARC FUSION');
    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 4, '-------------------------------------------------------------');

    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 3, 'CRITICAL ERRORS');    
    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 3, '----------------------'); 

    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 2, 'WARNINGS');   
    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 2, '--------------'); 

    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 1, 'INFO');
    INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (114, null, 1, '-------');

    -- Check if the node is exists
    SELECT node_id INTO v_exists_node_id FROM v_edit_node WHERE node_id = node_id_arg;
    SELECT the_geom INTO v_node_geom FROM node WHERE node_id = node_id_arg;
    

    -- Compute proceed
    IF FOUND THEN

        -- Find arcs sharing node
        SELECT COUNT(*) INTO v_count FROM v_edit_arc WHERE node_1 = node_id_arg OR node_2 = node_id_arg;

        -- Accepted if there are just two distinc arcs
        IF v_count = 2 THEN

            -- Get both arc features
            SELECT * INTO v_my_record1 FROM v_edit_arc WHERE node_1 = node_id_arg OR node_2 = node_id_arg ORDER BY arc_id DESC LIMIT 1;
            SELECT * INTO v_my_record2 FROM v_edit_arc WHERE node_1 = node_id_arg OR node_2 = node_id_arg ORDER BY arc_id ASC LIMIT 1;

            -- Compare arcs
            IF  v_my_record1.arccat_id = v_my_record2.arccat_id AND
                v_my_record1.sector_id = v_my_record2.sector_id AND
                v_my_record1.expl_id = v_my_record2.expl_id AND
                v_my_record1.state = v_my_record2.state
                THEN

                -- Final geometry
                IF v_my_record1.node_1 = node_id_arg THEN
                    IF v_my_record2.node_1 = node_id_arg THEN
                        v_point_array1 := ARRAY(SELECT (ST_DumpPoints(ST_Reverse(v_my_record1.the_geom))).geom);
                        v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_my_record2.the_geom)).geom));
                    ELSE
                        v_point_array1 := ARRAY(SELECT (ST_DumpPoints(v_my_record2.the_geom)).geom);
                        v_point_array2 := array_cat(v_point_array1, ARRAY(SELECT (ST_DumpPoints(v_my_record1.the_geom)).geom));
                    END IF;
                ELSE
                    IF v_my_record2.node_1 = node_id_arg THEN
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
            FOR rec_param IN SELECT DISTINCT parameter_id FROM man_addfields_value WHERE feature_id=v_my_record1.arc_id
                OR feature_id=v_my_record2.arc_id
            LOOP

            SELECT * INTO rec_addfield1 FROM man_addfields_value WHERE feature_id=v_my_record1.arc_id and parameter_id=rec_param;
            SELECT * INTO rec_addfield2 FROM man_addfields_value WHERE feature_id=v_my_record2.arc_id and parameter_id=rec_param;

                IF rec_addfield1.value_param!=rec_addfield2.value_param  THEN
                    RETURN audit_function(3008,2114);
                ELSIF rec_addfield2.value_param IS NULL and rec_addfield1.value_param IS NOT NULL THEN
                    UPDATE man_addfields_value SET feature_id=v_new_record.arc_id WHERE feature_id=v_my_record1.arc_id AND parameter_id=rec_param;
                ELSIF rec_addfield1.value_param IS NULL and rec_addfield2.value_param IS NOT NULL THEN
                    UPDATE man_addfields_value SET feature_id=v_new_record.arc_id WHERE feature_id=v_my_record2.arc_id AND parameter_id=rec_param;
                ELSE
                   UPDATE man_addfields_value SET feature_id=v_new_record.arc_id WHERE feature_id=v_my_record1.arc_id AND parameter_id=rec_param;
               END IF;

            END LOOP;
			-- temporary dissable the arc_searchnodes_control in order to use the node1 and node2 getted before
			-- to get values topocontrol arc needs to be before, but this is not possible
			UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'activated', false) WHERE parameter = 'arc_searchnodes';
			INSERT INTO v_edit_arc SELECT v_new_record.*;
			UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'activated', true) WHERE parameter = 'arc_searchnodes';

			UPDATE arc SET node_1=v_new_record.node_1, node_2=v_new_record.node_2 where arc_id=v_new_record.arc_id;
					
			--Insert data on audit_log_arc_traceability table
			INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
			VALUES ('ARC FUSION', v_new_record.arc_id, v_my_record2.arc_id,v_my_record1.arc_id,v_exists_node_id, CURRENT_TIMESTAMP, CURRENT_USER);
				
			-- Update complementary information from old arcs to new one
			UPDATE element_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			UPDATE doc_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			UPDATE om_visit_x_arc SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			UPDATE connec SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			UPDATE node SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;

			-- update links related to node
			IF  (SELECT link_id FROM link WHERE exit_type='NODE' and exit_id=node_id_arg LIMIT 1) IS NOT NULL THEN
			
				-- insert one vnode (indenpendently of the number of links. Only one vnode must replace the node)
				INSERT INTO vnode (vnode_id, vnode_type, state, sector_id, dma_id, expl_id, the_geom) 
				VALUES ((SELECT nextval('vnode_vnode_id_seq')), 'AUTO', v_new_record.state, v_new_record.sector_id, v_new_record.dma_id, v_new_record.expl_id, v_node_geom) 
				RETURNING vnode_id INTO v_vnode;
				
				-- update link with new vnode
				UPDATE link SET exit_type='VNODE', exit_id=v_vnode WHERE exit_type='NODE' and exit_id=node_id_arg;	
			END IF;
	
			IF v_project_type='UD' THEN
				UPDATE gully SET arc_id=v_new_record.arc_id WHERE arc_id=v_my_record1.arc_id OR arc_id=v_my_record2.arc_id;
			END IF;

			-- Delete information of arc deleted
			DELETE FROM arc WHERE arc_id = v_my_record1.arc_id;
			DELETE FROM arc WHERE arc_id = v_my_record2.arc_id;

			-- create links that where related to deprecated node
		
			-- Moving to obsolete the previous node
			UPDATE node SET state=0, workcat_id_end=workcat_id_end_aux, enddate=enddate_aux WHERE node_id = node_id_arg;

            -- Arcs has different types
            ELSE
                --INSERT INTO temp_table (fprocesscat_id, text_column) VALUES (1, node_id_arg);
                --RETURN audit_function(2004,2114);
                INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
                VALUES (114, 3, 'It is impossible to use the node to fusion two arcs. HINT: Pipes have different types');
            END IF;
         
        -- Node has not 2 arcs
        ELSE
            RETURN audit_function(2006,2114);
            INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
            VALUES (114, 3, 'It is impossible to use the node to fusion two arcs. HINT: Node doesnt have 2 arcs');
            
        END IF;

    -- Node not found
    ELSE 
        RETURN audit_function(2002,2114);
        INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
        VALUES (114, 3, 'Node not found . HINT: Please check table node');
    END IF;

   -- RETURN audit_function(0,2114);
-- get results
    -- info

    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
    FROM (SELECT id, error_message as message FROM audit_check_data 
    WHERE user_name="current_user"() AND fprocesscat_id=114 ORDER BY criticity desc, id asc) row; 
    
    v_result_info := COALESCE(v_result, '{}'); 
    v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

    v_result_point = '{"geometryType":"", "features":[]}';
    v_result_line = '{"geometryType":"", "features":[]}';
    v_result_polygon = '{"geometryType":"", "features":[]}';

--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Arc fusion done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{ "info":'||v_result_info||','||
                '"setVisibleLayers":[]'||','||
                '"point":'||v_result_point||','||
                '"line":'||v_result_line||','||
                '"polygon":'||v_result_polygon||'}'||
               '}'
        '}')::json;

    EXCEPTION WHEN OTHERS THEN
     GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
     RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


