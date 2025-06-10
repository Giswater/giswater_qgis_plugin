CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setcheckproject_SCHEMA_NAME(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
DECLARE
    v_fid integer;
    v_project_type text;
    v_querytext text;
    v_rec record;
    v_results jsonb := '[]'::jsonb;  
    v_check_result json;
	v_schemaname text;
	
	v_result_info JSON;
	v_result_point json;
	v_result_line json;
	v_result_polygon json;
	v_uservalues json;
	v_missing_layers json;
	v_qgis_layers_setpropierties boolean;
	v_qgis_init_guide_map boolean;
	v_return json;
	v_version text;
	v_epsg integer;
BEGIN
	
	SET search_path = 'SCHEMA_NAME', public;
	v_schemaname := 'SCHEMA_NAME';
	
	SELECT project_type, giswater, epsg INTO v_project_type, v_version, v_epsg FROM sys_version order by id desc limit 1;


    v_fid := (p_data->'data'->'parameters'->>'functionFid')::integer;
    v_project_type := COALESCE(p_data->'data'->'parameters'->>'project_type', 'SCHEMA_NAME');

    IF v_fid IS NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'Missing parameter: functionFid');
    END IF;

    v_querytext := '
        SELECT fid, fprocess_name
        FROM SCHEMA_NAME.sys_fprocess_cm
        WHERE project_type = LOWER(' || quote_literal(v_project_type) || ')
        AND active
        AND query_text IS NOT NULL
        AND (addparam IS NULL)
        ORDER BY fid ASC
    ';
	
	DROP TABLE IF EXISTS t_audit_check_data;
	CREATE TEMP TABLE t_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
	
	DROP TABLE IF EXISTS t_cm_arc;
	CREATE TEMP TABLE t_cm_arc (
		arc_id integer,
		arccat_id varchar,
		expl_id integer,
		fid integer,
		the_geom geometry,
		descript text
	);

	DROP TABLE IF EXISTS t_cm_node;
	CREATE TEMP TABLE t_cm_node (
		node_id integer,
		nodecat_id varchar,
		expl_id integer,
		fid integer,
		the_geom geometry,
		descript text
	);
	
	DROP TABLE IF EXISTS t_cm_connec;
	CREATE TEMP TABLE t_cm_connec (
		connec_id integer,
		conneccat_id varchar,
		expl_id integer,
		fid integer,
		the_geom geometry,
		descript text
	);

    FOR v_rec IN EXECUTE v_querytext LOOP
        EXECUTE
            'SELECT SCHEMA_NAME.gw_fct_check_fprocess_cm($${"data":{"parameters":{"functionFid":' || v_fid || ',"checkFid":' || v_rec.fid || '}}}$$)'
            INTO v_check_result;
    END LOOP;
   
    DELETE FROM audit_check_data WHERE fid in (select fid from t_audit_check_data) and cur_user=current_user;
	INSERT INTO audit_check_data SELECT * FROM t_audit_check_data;
	


	-- built return
	--EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"info"}}}$$::json)' INTO v_result_info;
	EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"point"}}}$$::json)' INTO v_result_point;

	--EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"line"}}}$$::json)' INTO v_result_line;
	--EXECUTE 'SELECT gw_fct_create_logreturn_cm($${"data":{"parameters":{"type":"polygon"}}}$$::json)' INTO v_result_polygon;

	--EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"CHECKPROJECT"}}}$$)';

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
