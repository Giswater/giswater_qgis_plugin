/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3470

CREATE OR REPLACE FUNCTION gw_fct_setcheckproject_cm(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT gw_fct_setcheckproject_cm($${"client":{"device":4, "lang":"es_ES", "version":"4.0.001", "infoType":1, "epsg":25831}, 
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

	-- variables
    v_querytext text;
    v_rec record;
    v_check_result json;

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
	v_campaign integer;
	v_lot integer;

BEGIN

	SET search_path = 'SCHEMA_NAME', public;
	v_schemaname := 'SCHEMA_NAME';

	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;


    v_fid := (p_data->'data'->'parameters'->>'functionFid')::integer;
    v_project_type := COALESCE(p_data->'data'->'parameters'->>'project_type', 'cm');
    v_campaign := p_data->'data'->'parameters'->>'campaignId';
	v_lot := p_data->'data'->'parameters'->>'lotId';

    IF v_fid IS NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'Missing parameter: functionFid');
    END IF;

	-- SECTION[epic=checkproject]: Manage temporary tables
	DROP TABLE IF EXISTS t_audit_check_data;
	CREATE TEMP TABLE t_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);

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

	DROP TABLE IF EXISTS t_cm_connec;
	CREATE TEMP TABLE t_cm_connec (
		connec_id integer primary key,
		conneccat_id varchar,
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

	-- SECTION[epic=checkproject]: Get fprocesses
    v_querytext := '
        SELECT fid, fprocess_name
        FROM SCHEMA_NAME.sys_fprocess
        WHERE project_type = LOWER(' || quote_literal(v_project_type) || ')
        AND active
        AND query_text IS NOT NULL
        AND (addparam IS NULL)
        ORDER BY fid ASC
    ';

    FOR v_rec IN EXECUTE v_querytext LOOP
        EXECUTE
            'SELECT SCHEMA_NAME.gw_fct_check_fprocess_cm($${"data":{"parameters":{"functionFid":' || v_fid || ',"checkFid":' || v_rec.fid || '}}}$$)'
            INTO v_check_result;
    END LOOP;
	-- ENDSECTION

	-- not necessary to fill excep tables
	-- EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"fillExcepTables"}}}$$::json)' INTO v_result_info;


	-- SECTION[epic=checkproject]: Build return
	EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;

	--EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	--EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;
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
