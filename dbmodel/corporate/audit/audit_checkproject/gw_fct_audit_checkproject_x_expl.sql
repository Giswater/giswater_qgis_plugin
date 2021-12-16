
/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--FUNCTION CODE: XXXX



CREATE OR REPLACE FUNCTION audit.gw_fct_audit_checkproject_x_expl(p_data json)
  RETURNS json AS
$BODY$

 /*EXAMPLE
SELECT audit.gw_fct_audit_checkproject_x_expl($${"client":
{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"schemaName":"ws_sample35"}}}$$)::text;
*/


DECLARE

    v_schema text;
    rec_expl text;
    v_result_info json;
    v_error_context text;
    v_version text;
    v_expl_x_user boolean;
BEGIN

--  Set search path to local schema
    SET search_path = "audit", public;

    v_schema = json_extract_path_text(p_data,'data','parameters','schemaName');

    EXECUTE 'SELECT giswater FROM '||v_schema||'.sys_version order by id desc limit 1'
    INTO  v_version;
    
    EXECUTE 'SELECT value::boolean FROM '||v_schema||'.config_param_system WHERE parameter = ''admin_exploitation_x_user'''
    INTO  v_expl_x_user;
    

    IF v_expl_x_user IS TRUE THEN
        FOR rec_expl IN EXECUTE 'SELECT expl_id FROM '||v_schema||'.exploitation WHERE active IS TRUE AND expl_id > 0' LOOP

            EXECUTE 'DELETE FROM '||v_schema||'.selector_expl WHERE cur_user=current_user';
            -- by the moment only useful when exploitations and sectors are exactly the same
            EXECUTE 'DELETE FROM '||v_schema||'.selector_sector WHERE cur_user=current_user';

            EXECUTE 'INSERT INTO '||v_schema||'.selector_expl
            VALUES ('||quote_literal(rec_expl)||', current_user)';
            -- by the moment only useful when exploitations and sectors are exactly the same
            EXECUTE 'INSERT INTO '||v_schema||'.selector_sector
            VALUES ('||quote_literal(rec_expl)||', current_user)';

            EXECUTE 'SELECT '||v_schema||'.gw_fct_setcheckproject ($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, 
            "feature":{}, "data":{"initProject":false, "isAudit":true, "selectionMode":"userSelectors"}}$$);';

        END LOOP;
        
        EXECUTE 'UPDATE audit.anl_node a SET expl_id = b.expl_id, 
        source = jsonb_build_object(''schema'','||quote_literal(v_schema)||', ''expl_id'',b.expl_id) FROM '||v_schema||'.node b
        WHERE a.node_id=b.node_id AND a.expl_id IS NULL;';

        EXECUTE 'UPDATE audit.anl_arc a SET expl_id = b.expl_id, 
        source = jsonb_build_object(''schema'','||quote_literal(v_schema)||', ''expl_id'',b.expl_id) FROM '||v_schema||'.arc b
        WHERE a.arc_id=b.arc_id AND a.expl_id IS NULL;';

    ELSE
        RAISE EXCEPTION 'Executing project check by exploitation is only available in case of having activated the variable admin_exploitation_x_user from config_param_system';
    END IF;

-- Control nulls
    v_result_info := COALESCE(v_result_info, '{}'); 
    
    -- Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{ "info":'||v_result_info||','||
                '"point":{"geometryType":"", "values":[]}'||','||
                '"line":{"geometryType":"", "values":[]}'||','||
                '"polygon":{"geometryType":"", "values":[]}'||
               '}}'||
        '}')::json;


        --  Exception handling
    /*EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_error_context = pg_exception_context;  
    RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_error_context) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;*/
      

END;
$BODY$
LANGUAGE plpgsql;
