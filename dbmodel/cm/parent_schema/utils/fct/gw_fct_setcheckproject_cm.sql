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
BEGIN
    v_fid := (p_data->'data'->'parameters'->>'functionFid')::integer;
    v_project_type := COALESCE(p_data->'data'->'parameters'->>'project_type', 'SCHEMA_NAME');

    IF v_fid IS NULL THEN
        RETURN json_build_object('status', 'error', 'message', 'Missing parameter: functionFid');
    END IF;

    v_querytext := '
        SELECT fid, fprocess_name
        FROM SCHEMA_NAME.sys_fprocess_SCHEMA_NAME
        WHERE project_type = LOWER(' || quote_literal(v_project_type) || ')
        AND active
        AND query_text IS NOT NULL
        AND (addparam IS NULL)
        ORDER BY fid ASC
    ';

    FOR v_rec IN EXECUTE v_querytext LOOP
        EXECUTE
            'SELECT SCHEMA_NAME.gw_fct_check_fprocess_SCHEMA_NAME($${"data":{"parameters":{"functionFid":' || v_fid || ',"checkFid":' || v_rec.fid || '}}}$$)'
            INTO v_check_result;

    END LOOP;
   
    DELETE FROM audit_check_data WHERE fid in (select fid from t_audit_check_data) and cur_user=current_user;
	INSERT INTO audit_check_data SELECT * FROM t_audit_check_data;


    RETURN json_build_object(
        'status', 'Accepted',
        'message', json_build_object(
        	'level', 1,
        	'text', 'Data quality analysis done succesfully'
        ),
        'version', 0,
        'body', json_build_object(
        	'form', json_build_object(),
        	'data', json_build_object(
        		'info', json_build_object(),
				'point', json_build_object(),
				'line', json_build_object(),
				'polygon', json_build_object()
        	)
        )
    );
END;
$function$
;
