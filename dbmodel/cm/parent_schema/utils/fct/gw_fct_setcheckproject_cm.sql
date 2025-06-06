CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setcheckproject_cm(p_data json)
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
    v_project_type := COALESCE(p_data->'data'->'parameters'->>'project_type', 'cm');  -- Forzar 'cm' si no viene

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

    FOR v_rec IN EXECUTE v_querytext LOOP
        EXECUTE
            'SELECT SCHEMA_NAME.gw_fct_check_fprocess_cm($${"data":{"parameters":{"functionFid":' || v_fid || ',"checkFid":' || v_rec.fid || '}}}$$)'
            INTO v_check_result;

        v_results := v_results || jsonb_build_array(json_build_object(
            'checkFid', v_rec.fid,
            'checkName', v_rec.fprocess_name,
            'result', v_check_result
        ));
    END LOOP;

    RETURN json_build_object(
        'status', 'ok',
        'checks', v_results
    );
END;
$function$
;
