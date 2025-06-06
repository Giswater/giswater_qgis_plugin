CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_check_fprocess_cm(p_data json)
RETURNS json LANGUAGE plpgsql AS $$
DECLARE
    v_checkfid integer;
    v_query text;
    v_result json;
BEGIN
    CREATE TEMP TABLE IF NOT EXISTS t_audit_check_data (
        id serial PRIMARY KEY,
        fid integer,
        cur_user text,
        criticity integer,
        error_message text,
        geom_type text,
        the_geom geometry
    ) ON COMMIT DROP;

    v_checkfid := (p_data->'data'->'parameters'->>'checkFid')::integer;

    SELECT query_text INTO v_query
      FROM SCHEMA_NAME.sys_fprocess_cm
     WHERE fid = v_checkfid;

    IF v_query IS NULL THEN
        RETURN json_build_object('status','error','message','No query_text found');
    END IF;

    PERFORM set_config('search_path', 'cm,public', false);

    BEGIN
        EXECUTE format('SELECT json_agg(t) FROM (%s) t', v_query) INTO v_result;
    EXCEPTION WHEN OTHERS THEN
        RETURN json_build_object('status','error','message',SQLERRM);
    END;

    RETURN json_build_object(
        'status','ok',
        'result', COALESCE(v_result, '[]')
    );
END;
$$;
