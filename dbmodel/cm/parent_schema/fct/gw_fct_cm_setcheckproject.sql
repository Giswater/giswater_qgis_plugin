/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3470

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_setcheckproject(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT gw_fct_cm_setcheckproject($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831},
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters": {"functionFid": 0, "lotId": 3, "campaignId":4, "project_type": "cm"}}}$$);

*/



DECLARE
	-- system variables
    v_project_type text;
	v_version text;
	v_epsg integer;
	v_schemaname text;

	-- dialog variables
    v_fid integer;
	v_campaign_id integer;
	v_lot_id integer;
	v_lot_id_array integer[];
	v_check_management_configs boolean;
	v_check_data_related boolean;
	v_fids_to_run integer[];
	v_count integer;

	-- variables
    v_querytext text;
	v_querytext_cfg text;
    v_rec record;
    v_check_result json;

	v_check_mandatory_fid integer := 100;
	v_check_fkeys_fid integer := 101;

	-- return variables
    v_results jsonb := '[]'::jsonb;
	v_result_info JSON;
	v_result_point json;
	v_result_line json;
	v_result_polygon json;

	v_uservalues json;
	v_missing_layers json;
	v_qgis_layers_setpropierties boolean;
	v_qgis_init_guide_map boolean;
	v_return json;

	v_features_array text[] := array['node', 'arc', 'connec', 'link'];
	v_feature_view_name text;
	v_feature_table_name text;
	v_feature_id_column text;
	v_feature_cm_table text;
	v_rec_id integer;
	v_rec_check record;

	v_current_role text;
	v_qindex_column text;
	v_feature_type_iterator text;
	v_combo_columns text[];
	v_update_calculation text;
	v_rec_subtype record;
	v_feature_cat_id_col text;
	v_form_name text;
	v_verified_combo_columns text[];

	v_total_q1 integer;
	v_total_q2 integer;
	v_total_count integer;
	v_temp_q1 integer;
	v_temp_q2 integer;
	v_temp_count integer;
	v_columns_exist boolean;
	v_seen_non_null_q1 boolean;
	v_seen_non_null_q2 boolean;
	v_temp_has_q1 boolean;
	v_temp_has_q2 boolean;
	v_avg_q1_text text;
	v_avg_q2_text text;
	v_lot_summary_msg text;
	v_campaign_summary_msg text;
	v_combo_table text;
	v_table_exists boolean;
	v_criticity integer;
	v_conditions text[];
	v_combo_issue_found boolean := false;
	v_any_issue_found boolean := false;
	v_lot_view_name text;
	v_view_exists boolean;
	v_arc_divide_tolerance float := 0.05;

BEGIN

	SET search_path = 'pg_temp', 'cm', 'public';
	v_schemaname := 'cm';

	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;


    v_fid := (p_data->'data'->'parameters'->>'functionFid')::integer;
    v_project_type := COALESCE(p_data->'data'->'parameters'->>'project_type', 'cm');
    v_campaign_id := (p_data->'data'->'parameters'->>'campaignId')::integer;
	v_lot_id := (p_data->'data'->'parameters'->>'lotId')::integer;
	v_check_management_configs := COALESCE((p_data->'data'->'parameters'->>'checkManagementConfigs')::boolean, false);
	v_check_data_related := COALESCE((p_data->'data'->'parameters'->>'checkDataRelated')::boolean, false);

    IF v_fid IS NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'Missing parameter: functionFid');
    END IF;

	IF v_campaign_id IS NULL THEN
		RETURN json_build_object('status', 'error', 'message', 'Missing parameter: campaignId');
	END IF;

	-- SECTION[epic=checkproject]: Manage temporary tables
	DROP TABLE IF EXISTS t_audit_check_data;
	CREATE TEMP TABLE t_audit_check_data (LIKE cm.audit_check_data INCLUDING ALL);

	DROP TABLE IF EXISTS t_cm_arc;
	CREATE TEMP TABLE t_cm_arc (
		arc_id integer primary key,
		arccat_id varchar,
		expl_id integer,
		fid integer,
		the_geom geometry,
		descript text
	);

	DROP TABLE IF EXISTS t_cm_node;
	CREATE TEMP TABLE t_cm_node (
		node_id integer primary key,
		nodecat_id varchar,
		expl_id integer,
		fid integer,
		the_geom geometry,
		descript text
	);

	DROP TABLE IF EXISTS t_cm_connec;
	CREATE TEMP TABLE t_cm_connec (
		connec_id integer primary key,
		conneccat_id varchar,
		expl_id integer,
		fid integer,
		the_geom geometry,
		descript text
	);

	DROP TABLE IF EXISTS t_cm_link;
	CREATE TEMP TABLE t_cm_link (
		link_id integer primary key,
		linkcat_id varchar,
		expl_id integer,
		fid integer,
		the_geom geometry,
		descript text
	);

	-- ENDSECTION


	-- fill log table
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, 'CONTROL DE CALIDAD');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, '------------------------------');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 3, '');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 3, 'ERRORES CRÍTICOS');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 3, '----------------------');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 2, '');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 2, 'ALERTAS');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 2, '--------------');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 1, '');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 1, 'INFO');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 1, '-------');

	-- SECTION[epic=checkproject]: Check for empty combo-populating tables
    FOREACH v_combo_table IN ARRAY ARRAY['sys_typevalue', 'cat_team', 'om_campaign', 'cat_organization']
    LOOP
        EXECUTE format('SELECT EXISTS (SELECT 1 FROM cm.%I LIMIT 1)', v_combo_table) INTO v_table_exists;
        
        IF NOT v_table_exists THEN
            INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
            VALUES (
                v_fid,
                current_user,
                2, -- Warning level
                format('WARNING: Table cm.%I is empty. Related combo boxes in the UI may be empty.', v_combo_table),
                1
            );
        END IF;
    END LOOP;
	-- ENDSECTION

	-- SECTION[epic=checkproject]: Perform outlier checks based on config_outlayers
	-- Check if outlier rules are configured
	IF NOT EXISTS (SELECT 1 FROM cm.config_outlayers) THEN
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
		VALUES (v_fid, current_user, 1, 'INFO: No outlier rules configured in config_outlayers table.', 0);
	ELSE
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
		VALUES (v_fid, current_user, 1, format('INFO: Starting outlier validation - checking %s configured rules.', (SELECT count(*) FROM cm.config_outlayers)), 0);
		
		FOR v_rec IN SELECT * FROM cm.config_outlayers
		LOOP
			v_conditions := ARRAY[]::text[];
			IF v_rec.min_value IS NOT NULL THEN
				v_conditions := array_append(v_conditions, format('%I < %s', v_rec.column_name, v_rec.min_value));
			END IF;
			IF v_rec.max_value IS NOT NULL THEN
				v_conditions := array_append(v_conditions, format('%I > %s', v_rec.column_name, v_rec.max_value));
			END IF;

			IF array_length(v_conditions, 1) > 0 THEN
				v_querytext := format(
					'SELECT %I FROM PARENT_SCHEMA.%I WHERE %s',
					v_rec.column_name,
					v_rec.feature_type,
					array_to_string(v_conditions, ' OR ')
				);

				EXECUTE 'SELECT count(*) FROM (' || v_querytext || ') AS outliers' INTO v_count;
			ELSE
				v_count := 0;
			END IF;

			IF v_count > 0 THEN
				-- Determine criticity level
				IF v_rec.except_error IS TRUE THEN
					v_criticity := 3; -- ERROR
				ELSE
					v_criticity := 2; -- WARNING
				END IF;

				INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
				VALUES (
					v_fid,
					current_user,
					v_criticity,
					-- Use the custom message if provided, otherwise a default one
					COALESCE(v_rec.except_message, format('Found %s outlier(s) for field %I in table %I.', v_count, v_rec.column_name, v_rec.feature_type)),
					v_count
				);
			ELSE
				INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
				VALUES (
					v_fid,
					current_user,
					1, -- Info level
					format('INFO: All values for field %I in table %I are within the defined range.', v_rec.column_name, v_rec.feature_type),
					0
				);
			END IF;
		END LOOP;
		
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
		VALUES (v_fid, current_user, 1, 'INFO: Outlier validation completed successfully.', 0);
	END IF;
    -- ENDSECTION

	-- SECTION[epic=checkproject]: Check for arcs without nodes
	FOR v_rec IN
		SELECT 'om_campaign_x_arc' AS table_name, 'campaign_id' AS id_column, v_campaign_id AS id_value
		UNION ALL
		SELECT 'om_campaign_lot_x_arc' AS table_name, 'lot_id' AS id_column, v_lot_id AS id_value
	LOOP
		IF v_rec.id_value IS NOT NULL THEN
			-- For campaign tables, get geometry directly. For lot tables, join with parent schema
			IF v_rec.table_name LIKE '%lot_x_%' THEN
				v_querytext := format(
					'SELECT cx.arc_id, a.the_geom FROM cm.%I cx 
					 JOIN PARENT_SCHEMA.arc a ON cx.arc_id = a.arc_id 
					 WHERE (cx.node_1 IS NULL OR cx.node_2 IS NULL) AND cx.%I = %s',
					v_rec.table_name, v_rec.id_column, v_rec.id_value
				);
			ELSE
				v_querytext := format(
					'SELECT arc_id, the_geom FROM cm.%I WHERE (node_1 IS NULL OR node_2 IS NULL) AND %I = %s',
					v_rec.table_name, v_rec.id_column, v_rec.id_value
				);
			END IF;

			FOR v_rec_check IN EXECUTE v_querytext
			LOOP
				INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
				VALUES (
					v_fid,
					current_user,
					3, -- Critical Error
					format('ERROR: Arc ID %s in table %s is missing node_1 or node_2. Please run topocontrol.', v_rec_check.arc_id, v_rec.table_name),
					1
				);

				INSERT INTO t_cm_arc(arc_id, descript, the_geom, fid)
				VALUES (v_rec_check.arc_id, 'Arc missing start/end node', v_rec_check.the_geom, v_fid);

				v_any_issue_found := true;
			END LOOP;
		END IF;
	END LOOP;
	-- ENDSECTION

	-- SECTION[epic=checkproject]: Find and flag nodes that should divide arcs
	DECLARE
		v_nodes_flagged integer := 0;
		v_node_to_flag_rec RECORD;
	BEGIN
		-- Only process campaign nodes since lot nodes don't have node_type column
		IF v_campaign_id IS NOT NULL THEN
			v_querytext := format(
				'SELECT n.node_id
				 FROM PARENT_SCHEMA.node n
				 JOIN cm.om_campaign_x_node cx ON n.node_id = cx.node_id
				 JOIN PARENT_SCHEMA.cat_feature_node cfn ON cx.node_type = cfn.id
				 WHERE cx.campaign_id = %s AND (cfn.isarcdivide IS NULL OR cfn.isarcdivide = false)
				   AND EXISTS (
					 SELECT 1 FROM PARENT_SCHEMA.arc a
					 WHERE ST_DWithin(n.the_geom, a.the_geom, %s)
					   AND a.node_1 <> n.node_id AND a.node_2 <> n.node_id
					   AND a.arc_id IN (SELECT arc_id FROM cm.om_campaign_x_arc WHERE campaign_id = %s)
				   )',
				v_campaign_id, v_arc_divide_tolerance, v_campaign_id
			);

			FOR v_node_to_flag_rec IN EXECUTE v_querytext
			LOOP
				-- Update the cat_feature_node table instead of the node table
				-- Get node_type from the campaign table
				DECLARE
					v_node_type integer;
				BEGIN
					-- Get node_type from campaign table
					SELECT node_type INTO v_node_type FROM cm.om_campaign_x_node WHERE node_id = v_node_to_flag_rec.node_id LIMIT 1;
					
					IF v_node_type IS NOT NULL THEN
						UPDATE PARENT_SCHEMA.cat_feature_node 
						SET isarcdivide = true 
						WHERE id = v_node_type;
						v_nodes_flagged := v_nodes_flagged + 1;
					END IF;
				EXCEPTION
					WHEN OTHERS THEN
						INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
						VALUES (v_fid, current_user, 2, format('WARNING: Error flagging node %s for arc division. Error: %s', v_node_to_flag_rec.node_id, SQLERRM));
				END;
			END LOOP;
		END IF;

		IF v_nodes_flagged > 0 THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message, fcount)
			VALUES (v_fid, current_user, 1, format('INFO: Automatically flagged %s nodes for arc division.', v_nodes_flagged), v_nodes_flagged);
		END IF;
	END;
	-- ENDSECTION

	-- SECTION[epic=checkproject]: Perform Arc Division for flagged nodes
	-- Only process campaign nodes that actually have arcs to divide
	IF v_campaign_id IS NOT NULL THEN
		v_querytext := format(
			'SELECT DISTINCT n.node_id 
			 FROM PARENT_SCHEMA.node n
			 JOIN cm.om_campaign_x_node cx ON n.node_id = cx.node_id
			 JOIN PARENT_SCHEMA.cat_feature_node cfn ON cx.node_type = cfn.id
			 WHERE cx.campaign_id = %s AND cfn.isarcdivide = true
			   AND EXISTS (
				 SELECT 1 FROM PARENT_SCHEMA.arc a
				 WHERE ST_DWithin(n.the_geom, a.the_geom, %s)
				   AND a.node_1 <> n.node_id AND a.node_2 <> n.node_id
				   AND a.arc_id IN (SELECT arc_id FROM cm.om_campaign_x_arc WHERE campaign_id = %s)
			   )',
			v_campaign_id, v_arc_divide_tolerance, v_campaign_id
		);

		FOR v_rec_check IN EXECUTE v_querytext
		LOOP
			-- Call the CM-specific arc divide function for each node
			DECLARE
				v_arc_divide_result json;
			BEGIN
				SELECT cm.gw_fct_cm_setarcdivide(json_build_object(
					'feature', json_build_object('id', array[v_rec_check.node_id]),
					'data', json_build_object('parameters', json_build_object('skipInitEndMessage', true))
				)) INTO v_arc_divide_result;

				-- Check the result and log appropriately
				IF v_arc_divide_result->>'status' = 'Accepted' THEN
					INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
					VALUES (v_fid, current_user, 1, 'INFO: ' || (v_arc_divide_result->>'message'));
				ELSE
					INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
					VALUES (v_fid, current_user, 2, 'WARNING: Arc division failed for node ID ' || v_rec_check.node_id || '. ' || (v_arc_divide_result->>'message'));
				END IF;
			EXCEPTION
				WHEN OTHERS THEN
					INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
					VALUES (v_fid, current_user, 2, 'WARNING: Failed to perform arc division for node ID ' || v_rec_check.node_id || '. Error: ' || SQLERRM);
			END;

		END LOOP;
		
		-- Add message if no arc division was performed
		IF NOT EXISTS (
			SELECT 1 FROM t_audit_check_data 
			WHERE fid = v_fid AND error_message LIKE '%INFO: Arc%divided%'
		) THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
			VALUES (v_fid, current_user, 1, 'INFO: No arc division was needed - all nodes are properly connected to their arcs.');
		END IF;
	END IF;
	-- ENDSECTION

	-- SECTION[epic=checkproject]: Get fids to run
	SELECT array_agg(fid) INTO v_fids_to_run
	FROM cm.sys_fprocess
	WHERE
		active AND query_text IS NOT NULL AND (addparam IS NULL) AND function_name ILIKE '%gw_fct_cm_check_project%'
		AND CASE
			WHEN fid IN (200, 201) THEN v_check_management_configs
			WHEN fid IN (202, 203) THEN v_check_data_related
			ELSE TRUE
		END;
	-- ENDSECTION

	-- SECTION[epic=checkproject]: Run checks from feature tables
	IF v_lot_id IS NOT NULL THEN
		-- get lot_id_array
		IF v_lot_id IS NOT NULL THEN
			v_lot_id_array := array[v_lot_id];
		ELSE
			SELECT array_agg(lot_id) INTO v_lot_id_array FROM cm.om_campaign_lot WHERE campaign_id = v_campaign_id GROUP BY campaign_id;
		END IF;

		-- get node, arc, connec, link ids from campaign_lot_x_table
		FOR i IN 1..array_length(v_features_array, 1) LOOP
			v_feature_table_name := v_features_array[i];
			v_feature_id_column := v_feature_table_name || '_id';
			v_feature_cm_table := 'om_campaign_lot_x_' || v_feature_table_name;

			-- get all ids from campaign_lot_x_table
			v_querytext := '
				SELECT lower(feature_type) as feature_type, lower(cf.id) AS child_type, array_agg(ocl.' || v_feature_id_column || ') AS feature_ids
				FROM cm.' || v_feature_cm_table || ' ocl
				JOIN PARENT_SCHEMA.' || v_feature_table_name || ' t ON t.' || v_feature_id_column || ' = ocl.' || v_feature_id_column || '
				JOIN PARENT_SCHEMA.cat_' || v_feature_table_name || ' c ON c.id = t.' || v_feature_table_name || 'cat_id 
				JOIN PARENT_SCHEMA.cat_feature_' || v_feature_table_name || ' cf ON cf.id = c.' || v_feature_table_name || '_type
				WHERE lot_id = ANY($1)
				GROUP BY feature_type, cf.id
			';

			FOR v_rec IN EXECUTE v_querytext USING v_lot_id_array LOOP
				v_feature_view_name := 'PARENT_SCHEMA_' || v_rec.child_type;
				v_feature_table_name := 'om_campaign_lot_x_' || v_rec.feature_type;
				v_feature_id_column := v_rec.feature_type || '_id';

				v_querytext_cfg := '
					SELECT DISTINCT columnname FROM PARENT_SCHEMA.config_form_fields
					WHERE ismandatory
					AND formname ILIKE ''%ve_'||v_rec.feature_type||'_'||v_rec.child_type||'%''
				';

				FOR v_rec_check IN EXECUTE v_querytext_cfg
				LOOP
					EXECUTE
						'SELECT cm.gw_fct_cm_check_fprocess($${"data":{"parameters":{
							"functionFid":' || v_fid || ',
							"checkFid":' || v_check_mandatory_fid || ',
							"replaceParams": ' || 
								jsonb_build_object(
									'table_name', v_feature_view_name,
									'feature_column', v_feature_id_column,
									'feature_ids', array_to_string(v_rec.feature_ids, ','),
									'check_column', v_rec_check.columnname
								)::text || '
						}}}$$::json)'
					INTO v_check_result;
				END LOOP;
			END LOOP;
		END LOOP;
	END IF;
	-- ENDSECTION

	-- SECTION[epic=qindex]: Calculate and update qindex values based on combo fields with value 0
	-- Get current user role

	SELECT r.rolname AS role_name INTO v_current_role
	FROM pg_roles r
	JOIN pg_auth_members m
	ON r.oid = m.roleid
	JOIN pg_roles u ON u.oid = m.member 
	WHERE u.rolname = current_user AND r.rolname ILIKE '%cm%';

	-- Proceed only if a lot is selected and the user has the correct role
	IF v_lot_id IS NOT NULL AND v_current_role IN ('role_cm_org', 'role_cm_admin') THEN

		-- Determine which qindex column to update
		IF v_current_role = 'role_cm_org' THEN
			v_qindex_column := 'qindex1';
		ELSE
			v_qindex_column := 'qindex2';
		END IF;

		-- Iterate through each feature type to update its qindex
		FOREACH v_feature_type_iterator IN ARRAY v_features_array
		LOOP
			v_feature_cat_id_col := v_feature_type_iterator || 'cat_id';

			-- Get distinct subtypes for the feature type in the lot
			v_querytext := format(
				'SELECT DISTINCT lower(T3.%s_type) AS subtype
				 FROM cm.om_campaign_lot_x_%s T1
				 JOIN PARENT_SCHEMA.%s T2 ON T1.%s_id::text = T2.%s_id::text
				 JOIN PARENT_SCHEMA.cat_%s T3 ON T2.%s = T3.id
				 WHERE T1.lot_id = %s AND T2.%s IS NOT NULL',
				 v_feature_type_iterator,
				 v_feature_type_iterator,
				 v_feature_type_iterator, v_feature_type_iterator, v_feature_type_iterator,
				 v_feature_type_iterator,
				 v_feature_cat_id_col,
				 v_lot_id,
				 v_feature_cat_id_col
			);

			FOR v_rec_subtype IN EXECUTE v_querytext
			LOOP
				v_form_name := 've_' || v_feature_type_iterator || '_' || v_rec_subtype.subtype;
				-- Find all 'combo' type columns for the current formname from the PARENT schema
				v_querytext := format(
					'SELECT columnname, dv_isnullvalue
					 FROM PARENT_SCHEMA.config_form_fields
					 WHERE formname = %L AND widgettype LIKE ''combo%%''',
					 v_form_name
				);
				
				FOR v_rec_check IN EXECUTE v_querytext
				LOOP
					-- If NULL is not a valid value for this combo, check for NULLs.
					IF v_rec_check.dv_isnullvalue IS NOT TRUE THEN
						BEGIN
							-- This query now correctly joins to the specific feature subtype VIEW (e.g., PARENT_SCHEMA.ve_node_pr_reduc_valve)
							-- stored in v_form_name. This ensures the column being checked (v_rec_check.columnname) actually exists,
							-- resolving the "column does not exist" error, and simplifies the query by removing a redundant join.
							v_feature_id_column := v_feature_type_iterator || '_id';
							v_querytext := format(
								'SELECT COUNT(T1.*)
								 FROM cm.om_campaign_lot_x_%I T1
								 JOIN PARENT_SCHEMA.%I T2 ON T1.%I::text = T2.%I::text
								 WHERE T1.lot_id = %s AND T2.%I IS NULL',
								 v_feature_type_iterator,
								 v_form_name,
								 v_feature_id_column,
								 v_feature_id_column,
								 v_lot_id,
								 v_rec_check.columnname
							);

							EXECUTE v_querytext INTO v_count;

							IF v_count > 0 THEN
								v_lot_summary_msg := format(
									'WARNING (Lot ID: %s): Found %s records in lot with missing required values for field ''%s'' in subtype ''%s''.',
									v_lot_id, v_count, v_rec_check.columnname, v_rec_subtype.subtype
								);
								INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
								VALUES (v_fid, current_user, 2, v_lot_summary_msg);
								v_combo_issue_found := true;
							END IF;

						EXCEPTION
							WHEN undefined_column THEN
								-- This can happen if the view definition is out of sync with config_form_fields.
								-- This is not an error in the project data, but a configuration mismatch. Log it as INFO.
								v_lot_summary_msg := format(
									'INFO (Lot ID: %s): Configuration mismatch. Field ''%s'' from form ''%s'' not found in the underlying view. Skipping check.',
									v_lot_id, v_rec_check.columnname, v_form_name
								);
								INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
								VALUES (v_fid, current_user, 1, v_lot_summary_msg);
							WHEN OTHERS THEN
								-- Catch any other errors and log them as warnings
								v_lot_summary_msg := format(
									'WARNING (Lot ID: %s): Error checking field ''%s'' in subtype ''%s''. Error: %s',
									v_lot_id, v_rec_check.columnname, v_rec_subtype.subtype, SQLERRM
								);
								INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
								VALUES (v_fid, current_user, 2, v_lot_summary_msg);
						END;
					END IF;
				END LOOP; -- end loop for combo columns
			END LOOP; -- end loop for subtypes
		END LOOP; -- end loop for feature types

		-- Add a final "all clear" message if no combo issues were found for the lot.
		IF NOT v_combo_issue_found THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
			VALUES (v_fid, current_user, 1, 'INFO: All combo box configurations checks passed successfully for this lot.');
		END IF;

	END IF;
	-- ENDSECTION

	-- SECTION[epic=qindex_campaign]: Calculate and update qindex values for campaign based on combo fields with value 0
	IF v_campaign_id IS NOT NULL AND v_current_role IN ('role_cm_org', 'role_cm_admin') THEN

		-- Determine which qindex column to update
		IF v_current_role = 'role_cm_org' THEN
			v_qindex_column := 'qindex1';
		ELSE
			v_qindex_column := 'qindex2';
		END IF;

		-- Iterate through each feature type to update its qindex
		FOREACH v_feature_type_iterator IN ARRAY v_features_array
		LOOP
			v_feature_cat_id_col := v_feature_type_iterator || 'cat_id';

			-- Get distinct subtypes for the feature type in the campaign
			v_querytext := format(
				'SELECT DISTINCT lower(T3.%s_type) AS subtype
				 FROM cm.om_campaign_x_%s T1
				 JOIN PARENT_SCHEMA.%s T2 ON T1.%s_id::text = T2.%s_id::text
				 JOIN PARENT_SCHEMA.cat_%s T3 ON T2.%s = T3.id
				 WHERE T1.campaign_id = %s AND T2.%s IS NOT NULL',
				 v_feature_type_iterator,
				 v_feature_type_iterator,
				 v_feature_type_iterator, v_feature_type_iterator, v_feature_type_iterator,
				 v_feature_type_iterator,
				 v_feature_cat_id_col,
				 v_campaign_id,
				 v_feature_cat_id_col
			);

			FOR v_rec_subtype IN EXECUTE v_querytext
			LOOP
				v_form_name := 've_' || v_feature_type_iterator || '_' || v_rec_subtype.subtype;
				-- Find all 'combo' type columns for the current formname from the PARENT schema
				v_querytext := format(
					'SELECT array_agg(columnname)
					 FROM PARENT_SCHEMA.config_form_fields
					 WHERE formname = %L AND widgettype LIKE ''combo%%''',
					 v_form_name
				);
				EXECUTE v_querytext INTO v_combo_columns;

				-- If combo columns are found in config, verify they exist in the actual table
				IF v_combo_columns IS NOT NULL AND array_length(v_combo_columns, 1) > 0 THEN
					
					v_querytext := format(
						'SELECT array_agg(c.column_name) FROM information_schema.columns c
						 WHERE c.table_schema = ''PARENT_SCHEMA'' AND c.table_name = %L AND c.column_name = ANY(%L)',
						 v_feature_type_iterator, v_combo_columns
					);
					EXECUTE v_querytext INTO v_verified_combo_columns;

					-- If any verified columns remain, build and execute the update
					IF v_verified_combo_columns IS NOT NULL AND array_length(v_verified_combo_columns, 1) > 0 THEN

						-- Construct the calculation part of the query using only verified columns
						SELECT string_agg(format('(CASE WHEN T2.%I IS NOT NULL AND T2.%I::text = ''0'' THEN 1 ELSE 0 END)', columnname, columnname), ' + ')
						INTO v_update_calculation
						FROM unnest(v_verified_combo_columns) AS columnname;

						-- Construct the final UPDATE statement
						v_querytext := format(
							'UPDATE cm.om_campaign_x_%1$s T1 SET %2$I = %3$s
							 FROM PARENT_SCHEMA.%1$s T2
							 JOIN PARENT_SCHEMA.cat_%1$s T3 ON T2.%5$I = T3.id
							 WHERE T1.%1$s_id::text = T2.%1$s_id::text AND T1.campaign_id = %4$s AND lower(T3.%1$s_type) = %6$L',
							v_feature_type_iterator, v_qindex_column, COALESCE(v_update_calculation, '0'),
							v_campaign_id, v_feature_cat_id_col, v_rec_subtype.subtype
						);

						-- Execute the update
						BEGIN
							EXECUTE v_querytext;
						EXCEPTION
							WHEN OTHERS THEN
								INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
								VALUES (v_fid, current_user, 2, format('WARNING: Error updating qindex for campaign %s, feature type %s, subtype %s. Error: %s', 
									v_campaign_id, v_feature_type_iterator, v_rec_subtype.subtype, SQLERRM));
						END;
					END IF;
				END IF;
			END LOOP;
		END LOOP;
	END IF;
	-- ENDSECTION

	-- SECTION[epic=qindex_summary]: Calculate and update summary qindex for lot and campaign
	IF v_lot_id IS NOT NULL THEN
		-- Calculate for lot
		v_total_q1 := 0;
		v_total_q2 := 0;
		v_total_count := 0;
		v_seen_non_null_q1 := false;
		v_seen_non_null_q2 := false;

		FOREACH v_feature_type_iterator IN ARRAY v_features_array
		LOOP
			EXECUTE format('SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = ''cm'' AND table_name = %L AND column_name = ''qindex1'')', 'om_campaign_lot_x_' || v_feature_type_iterator)
			INTO v_columns_exist;

			IF v_columns_exist THEN
				v_querytext := format(
					'SELECT COALESCE(SUM(qindex1), 0), COALESCE(SUM(qindex2), 0), COUNT(*), (COUNT(qindex1) > 0), (COUNT(qindex2) > 0)
					 FROM cm.om_campaign_lot_x_%s
					 WHERE lot_id = %s',
					 v_feature_type_iterator, v_lot_id
				);
			ELSE
				v_querytext := format(
					'SELECT 0, 0, COUNT(*), false, false
					 FROM cm.om_campaign_lot_x_%s
					 WHERE lot_id = %s',
					 v_feature_type_iterator, v_lot_id
				);
			END IF;

			EXECUTE v_querytext INTO v_temp_q1, v_temp_q2, v_temp_count, v_temp_has_q1, v_temp_has_q2;
			v_total_q1 := v_total_q1 + v_temp_q1;
			v_total_q2 := v_total_q2 + v_temp_q2;
			v_total_count := v_total_count + v_temp_count;
			v_seen_non_null_q1 := v_seen_non_null_q1 OR v_temp_has_q1;
			v_seen_non_null_q2 := v_seen_non_null_q2 OR v_temp_has_q2;
		END LOOP;

		IF v_total_count > 0 THEN
			BEGIN
				UPDATE cm.om_campaign_lot
				SET qindex1 = CASE WHEN v_seen_non_null_q1 THEN v_total_q1::decimal / v_total_count ELSE NULL END,
					qindex2 = CASE WHEN v_seen_non_null_q2 THEN v_total_q2::decimal / v_total_count ELSE NULL END
				WHERE lot_id = v_lot_id;
			EXCEPTION
				WHEN OTHERS THEN
					INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
					VALUES (v_fid, current_user, 2, format('WARNING: Error updating lot qindex summary for lot %s. Error: %s', v_lot_id, SQLERRM));
			END;

			v_avg_q1_text := CASE WHEN v_seen_non_null_q1 THEN round(v_total_q1::decimal / v_total_count, 2)::text ELSE 'NULL' END;
			v_avg_q2_text := CASE WHEN v_seen_non_null_q2 THEN round(v_total_q2::decimal / v_total_count, 2)::text ELSE 'NULL' END;

			v_lot_summary_msg := format('Lot %s summary: Q-Index 1 = %s, Q-Index 2 = %s', v_lot_id, v_avg_q1_text, v_avg_q2_text);
		END IF;
	END IF;

	IF v_campaign_id IS NOT NULL THEN
		-- Calculate for campaign
		v_total_q1 := 0;
		v_total_q2 := 0;
		v_total_count := 0;
		v_seen_non_null_q1 := false;
		v_seen_non_null_q2 := false;

		FOREACH v_feature_type_iterator IN ARRAY v_features_array
		LOOP
			EXECUTE format('SELECT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_schema = ''cm'' AND table_name = %L AND column_name = ''qindex1'')', 'om_campaign_x_' || v_feature_type_iterator)
			INTO v_columns_exist;

			IF v_columns_exist THEN
				v_querytext := format(
					'SELECT COALESCE(SUM(qindex1), 0), COALESCE(SUM(qindex2), 0), COUNT(*), (COUNT(qindex1) > 0), (COUNT(qindex2) > 0)
					 FROM cm.om_campaign_x_%s
					 WHERE campaign_id = %s',
					 v_feature_type_iterator, v_campaign_id
				);
			ELSE
				v_querytext := format(
					'SELECT 0, 0, COUNT(*), false, false
					 FROM cm.om_campaign_x_%s
					 WHERE campaign_id = %s',
					 v_feature_type_iterator, v_campaign_id
				);
			END IF;
			EXECUTE v_querytext INTO v_temp_q1, v_temp_q2, v_temp_count, v_temp_has_q1, v_temp_has_q2;
			v_total_q1 := v_total_q1 + v_temp_q1;
			v_total_q2 := v_total_q2 + v_temp_q2;
			v_total_count := v_total_count + v_temp_count;
			v_seen_non_null_q1 := v_seen_non_null_q1 OR v_temp_has_q1;
			v_seen_non_null_q2 := v_seen_non_null_q2 OR v_temp_has_q2;
		END LOOP;

		IF v_total_count > 0 THEN
			BEGIN
				UPDATE cm.om_campaign
				SET qindex1 = CASE WHEN v_seen_non_null_q1 THEN v_total_q1::decimal / v_total_count ELSE NULL END,
					qindex2 = CASE WHEN v_seen_non_null_q2 THEN v_total_q2::decimal / v_total_count ELSE NULL END
				WHERE campaign_id = v_campaign_id;
			EXCEPTION
				WHEN OTHERS THEN
					INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
					VALUES (v_fid, current_user, 2, format('WARNING: Error updating campaign qindex summary for campaign %s. Error: %s', v_campaign_id, SQLERRM));
			END;

			v_avg_q1_text := CASE WHEN v_seen_non_null_q1 THEN round(v_total_q1::decimal / v_total_count, 2)::text ELSE 'NULL' END;
			v_avg_q2_text := CASE WHEN v_seen_non_null_q2 THEN round(v_total_q2::decimal / v_total_count, 2)::text ELSE 'NULL' END;

			v_campaign_summary_msg := format('Campaign %s summary: Q-Index 1 = %s, Q-Index 2 = %s', v_campaign_id, v_avg_q1_text, v_avg_q2_text);
		END IF;
	END IF;
	-- ENDSECTION

	-- SECTION[epic=checkproject]: Get fprocesses
	IF array_length(v_fids_to_run, 1) > 0 THEN
		v_querytext := '
			SELECT fid, fprocess_name
			FROM cm.sys_fprocess
			WHERE project_type = LOWER(' || quote_literal(v_project_type) || ')
			AND active
			AND query_text IS NOT NULL
			AND (addparam IS NULL)
			AND function_name ILIKE ''%gw_fct_cm_check_project%''
			AND fid = ANY(' || quote_literal(v_fids_to_run) || ')
			ORDER BY fid ASC
		';

		FOR v_rec IN EXECUTE v_querytext LOOP
			EXECUTE
				'SELECT cm.gw_fct_cm_check_fprocess($${"data":{"parameters":{"functionFid":' || v_fid || ',"checkFid":' || v_rec.fid || '}}}$$)'
				INTO v_check_result;
			
			-- Remove the issue_found check since the function doesn't return this field
			-- The function will log issues directly to t_audit_check_data
		END LOOP;
	END IF;
	-- ENDSECTION

	-- Insert summary messages at the end
	IF v_lot_summary_msg IS NOT NULL THEN
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, v_lot_summary_msg);
	END IF;
	IF v_campaign_summary_msg IS NOT NULL THEN
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, v_campaign_summary_msg);
	END IF;

	-- Add a final "all clear" message if no issues were found.
	IF NOT v_any_issue_found THEN
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
		VALUES (v_fid, current_user, 1, 'INFO: All project configurations checks passed successfully.');
	END IF;

	-- SECTION[epic=catalog_check]: Check catalog tables
	-- Check if there's data to validate
	IF v_campaign_id IS NULL AND v_lot_id IS NULL THEN
		INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
		VALUES (v_fid, current_user, 1, 'INFO: No campaign or lot selected - skipping catalog validation.');
	ELSE

	RAISE NOTICE 'Starting catalog check with campaign_id: %, lot_id: %', v_campaign_id, v_lot_id;
	
	BEGIN
		        RAISE NOTICE 'Calling gw_fct_cm_check_catalogs function...';
        EXECUTE 'SELECT cm.gw_fct_cm_check_catalogs($${"data":{"projectType":"' || v_project_type || '","version":"' || v_version || '","fromProduction":false,"campaign_id":"' || v_campaign_id || '","lot_id":"' || v_lot_id || '"}}$$)' INTO v_check_result;
		RAISE NOTICE 'Catalog check result status: %', v_check_result->>'status';
		
		-- Parse the catalog check result and insert into audit
		-- Always parse the log messages regardless of status
		FOR v_rec IN SELECT unnest(string_to_array(v_check_result->'body'->>'log', chr(10))) AS log_line
		LOOP
			IF v_rec.log_line != '' THEN
				IF v_rec.log_line LIKE 'ERROR:%' THEN
					INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
					VALUES (v_fid, current_user, 3, v_rec.log_line);
				ELSIF v_rec.log_line LIKE 'WARNING:%' THEN
					INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
					VALUES (v_fid, current_user, 2, v_rec.log_line);
				ELSIF v_rec.log_line LIKE 'INFO:%' THEN
					-- Check if this is a catalog message about new entries being created
					IF v_rec.log_line LIKE '%new catalog entry will be created%' THEN
						INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
						VALUES (v_fid, current_user, 2, 'WARNING: ' || substring(v_rec.log_line from 6)); -- Remove 'INFO: ' prefix and add 'WARNING: '
					ELSIF v_rec.log_line LIKE '%Some features will create new catalog entries%' THEN
						INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
						VALUES (v_fid, current_user, 2, 'WARNING: ' || substring(v_rec.log_line from 6)); -- Remove 'INFO: ' prefix and add 'WARNING: '
					ELSE
						INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
						VALUES (v_fid, current_user, 1, v_rec.log_line);
					END IF;
				END IF;
			END IF;
		END LOOP;
		

	EXCEPTION
		WHEN OTHERS THEN
			INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message)
			VALUES (v_fid, current_user, 3, 'ERROR: Catalog check failed: ' || SQLERRM);
	END;
	END IF;
	-- ENDSECTION

	-- not necessary to fill excep tables
	-- EXECUTE 'SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"fillExcepTables"}}}$$::json)' INTO v_result_info;


	-- SECTION[epic=checkproject]: Build return
	BEGIN
		EXECUTE 'SELECT cm.gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXCEPTION
		WHEN OTHERS THEN
			v_result_info := '{}';
	END;
	
	BEGIN
		EXECUTE 'SELECT cm.gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;
	EXCEPTION
		WHEN OTHERS THEN
			v_result_point := '{}';
	END;

	--EXECUTE 'SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	--EXECUTE 'SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;
	-- ENDSECTION

	-- Control null
	v_version:=COALESCE(v_version,'');
	v_epsg:=COALESCE(v_epsg,0);
	v_uservalues:=COALESCE(v_uservalues,'{}');
	v_result_info:=COALESCE(v_result_info,'{}');
	v_result_point:=COALESCE(v_result_point,'{}');
	v_result_line:=COALESCE(v_result_line,'{}');
	v_result_polygon:=COALESCE(v_result_polygon,'{}');
	v_missing_layers:=COALESCE(v_missing_layers,'{}');
	v_qgis_layers_setpropierties:=COALESCE(v_qgis_layers_setpropierties,true);
	v_qgis_init_guide_map:=COALESCE(v_qgis_init_guide_map,true);

	--return definition for v_audit_check_result
	v_return= ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'" '||
		',"body":{"form":{}'||
			',"data":{ "epsg":'||v_epsg||
					',"userValues":'||v_uservalues||
			    ',"info":'||v_result_info||','||
					'"point":'||v_result_point||','||
					'"line":'||v_result_line||','||
					'"polygon":'||v_result_polygon||','||
					'"missingLayers":'||v_missing_layers||'}'||
			', "variables":{"setQgisLayers":' || v_qgis_layers_setpropierties||', "useGuideMap":'||v_qgis_init_guide_map||'}}}')::json;
	--  Return
	RETURN v_return;

END;
$function$
;
