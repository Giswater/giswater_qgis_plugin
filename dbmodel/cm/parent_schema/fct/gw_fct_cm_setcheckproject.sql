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

BEGIN

	SET search_path = 'cm', public;
	v_schemaname := 'cm';

	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;


    v_fid := (p_data->'data'->'parameters'->>'functionFid')::integer;
    v_project_type := COALESCE(p_data->'data'->'parameters'->>'project_type', 'cm');
    v_campaign_id := p_data->'data'->'parameters'->>'campaignId';
	v_lot_id := p_data->'data'->'parameters'->>'lotId';
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
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 3, 'ERRORES CRÍTICOS');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 3, '----------------------');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 2, '');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 2, 'ALERTAS');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 2, '--------------');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 1, '');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 1, 'INFO');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 1, '-------');
	INSERT INTO t_audit_check_data (fid, cur_user, criticity, error_message) VALUES (v_fid, current_user, 4, '');

	v_fids_to_run := '{}'::integer[];
    IF v_check_management_configs IS TRUE THEN
        v_fids_to_run := array_cat(v_fids_to_run, ARRAY[200, 201]);
    END IF;
    IF v_check_data_related IS TRUE THEN
        v_fids_to_run := array_cat(v_fids_to_run, ARRAY[202, 203]);
    END IF;

	-- SECTION[epic=checkproject]: Check mandatory fields and foreign keys constraints
	IF v_campaign_id IS NOT NULL AND v_check_data_related IS TRUE THEN
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
		END LOOP;
	END IF;
	-- ENDSECTION

	-- not necessary to fill excep tables
	-- EXECUTE 'SELECT gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"fillExcepTables"}}}$$::json)' INTO v_result_info;


	-- SECTION[epic=checkproject]: Build return
	EXECUTE 'SELECT cm.gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT cm.gw_fct_cm_create_logreturn($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;

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
