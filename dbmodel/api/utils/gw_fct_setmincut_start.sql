CREATE OR REPLACE FUNCTION "SCHEMA_NAME"."gw_fct_setmincut_start"(p_mincut_id int4, p_device int4) RETURNS pg_catalog.json AS $BODY$
DECLARE

api_version json;
v_mincut_class int2;
v_mincut_feature text;
    
BEGIN

--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--  Update values
    UPDATE anl_mincut_result_cat SET mincut_state=1, exec_start=now(), exec_user=current_user WHERE id=p_mincut_id;

-- Get mincut class and mincut feature
    SELECT mincut_class INTO v_mincut_class FROM anl_mincut_result_cat WHERE id=p_mincut_id;

    IF v_mincut_class=1 THEN
    v_mincut_feature = 'arc';
    ELSIF v_mincut_class=2 THEN
    v_mincut_feature = 'connec';
    ELSIF v_mincut_class=3 THEN
    v_mincut_feature = 'hydrometer';
    END IF;

--    Return
     RETURN  SCHEMA_NAME.gw_fct_getmincut(null, null, null, p_mincut_id::integer, p_device, v_mincut_feature, 'lang');


--    Exception handling
    EXCEPTION WHEN OTHERS THEN 
        RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE COST 100;

