-- Function code: 3384

-- DROP FUNCTION SCHEMA_NAME.gw_fct_import_swmm_flwreg(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_swmm_flwreg(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_swmm_flwreg($${"data": {
    "pump": {
        "featureClass": "PUMP",
        "catalog": "PUMP-01"
    },
    "orifice": {
        "featureClass": "ORIFICE",
        "catalog": "ORIFICE-01"
    },
    "weir": {
        "featureClass": "EWEIR",
        "catalog": "WEIR-01"
    },
    "outlet": {
        "featureClass": "OUTLET",
        "catalog": "OUTLET-01"
    }
}}$$);

-- fid: 239

*/

DECLARE
v_fid integer = 239;
v_version text;
v_epsg integer;

v_data record;
v_count integer;
v_mantablename text;
v_epatablename text;
v_epa_type text;

v_pump_featureclass text;
v_pump_catalog text;
v_orifice_featureclass text;
v_orifice_catalog text;
v_weir_featureclass text;
v_weir_catalog text;
v_outlet_featureclass text;
v_outlet_catalog text;
v_pump_ids int[];
v_orifice_ids int[];
v_weir_ids int[];
v_outlet_ids int[];
v_state smallint;

v_flwreg_id integer;
v_flwregcat_id text;
v_flwreg_length float;
v_toarc integer;
v_node_id integer;
v_node1 integer;
v_node2 integer;
v_elevation float;
v_node1_geom geometry;

v_querytext text;
v_errcontext text;
v_msgerr json;
v_result json;
v_result_info json;
v_debugmode boolean;
v_status text = 'Accepted';

BEGIN

    --  Search path
    SET search_path = "SCHEMA_NAME", public;

    -- get system parameters
    SELECT giswater, epsg INTO v_version, v_epsg FROM sys_version ORDER BY id DESC LIMIT 1;

    -- get input data
    v_pump_featureclass := ((p_data ->>'data')::json->>'pump')::json->>'featureClass'::text;
    v_pump_catalog := ((p_data ->>'data')::json->>'pump')::json->>'catalog'::text;
    v_orifice_featureclass := ((p_data ->>'data')::json->>'orifice')::json->>'featureClass'::text;
    v_orifice_catalog := ((p_data ->>'data')::json->>'orifice')::json->>'catalog'::text;
    v_weir_featureclass := ((p_data ->>'data')::json->>'weir')::json->>'featureClass'::text;
    v_weir_catalog := ((p_data ->>'data')::json->>'weir')::json->>'catalog'::text;
    v_outlet_featureclass := ((p_data ->>'data')::json->>'outlet')::json->>'featureClass'::text;
    v_outlet_catalog := ((p_data ->>'data')::json->>'outlet')::json->>'catalog'::text;
    v_pump_ids := CASE
        WHEN ((p_data ->>'data')::json->'pump') IS NOT NULL AND ((p_data ->>'data')::json->'pump'->'ids') IS NOT NULL
        THEN ARRAY(SELECT json_array_elements_text(((p_data ->>'data')::json->'pump'->'ids')))::int[]
        ELSE ARRAY[]::int[]
    END;
    v_orifice_ids := CASE
        WHEN ((p_data ->>'data')::json->'orifice') IS NOT NULL AND ((p_data ->>'data')::json->'orifice'->'ids') IS NOT NULL
        THEN ARRAY(SELECT json_array_elements_text(((p_data ->>'data')::json->'orifice'->'ids')))::int[]
        ELSE ARRAY[]::int[]
    END;
    v_weir_ids := CASE
        WHEN ((p_data ->>'data')::json->'weir') IS NOT NULL AND ((p_data ->>'data')::json->'weir'->'ids') IS NOT NULL
        THEN ARRAY(SELECT json_array_elements_text(((p_data ->>'data')::json->'weir'->'ids')))::int[]
        ELSE ARRAY[]::int[]
    END;
    v_outlet_ids := CASE
        WHEN ((p_data ->>'data')::json->'outlet') IS NOT NULL AND ((p_data ->>'data')::json->'outlet'->'ids') IS NOT NULL
        THEN ARRAY(SELECT json_array_elements_text(((p_data ->>'data')::json->'outlet'->'ids')))::int[]
        ELSE ARRAY[]::int[]
    END;
    v_state := ((p_data ->>'data')::json->>'state')::smallint;
    -- Starting process
    PERFORM gw_fct_manage_temp_tables(('{"data":{"parameters":{"fid": '||v_fid||', "project_type": "UD", "action": "CREATE", "group": "LOG"}}}')::json);
    -- set node topocontrol=false
    UPDATE config_param_system SET value='{"activated":false,"value":0.1}' WHERE "parameter"='edit_node_proximity';
    INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'INFO: Deactivated node proximity check.');

    -- loop all arcs that need to be flowregulators
    -- TODO: add where to only transform those on the current import inp
    FOR v_data IN
        SELECT *
        FROM arc
        WHERE epa_type IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET') AND state = v_state AND arc_id IN (SELECT UNNEST(v_pump_ids || v_orifice_ids || v_weir_ids || v_outlet_ids))
    LOOP
        CONTINUE WHEN v_data.epa_type = 'PUMP' AND v_pump_featureclass IS NULL;
        CONTINUE WHEN v_data.epa_type = 'ORIFICE' AND v_orifice_featureclass IS NULL;
        CONTINUE WHEN v_data.epa_type = 'WEIR' AND v_weir_featureclass IS NULL;
        CONTINUE WHEN v_data.epa_type = 'OUTLET' AND v_outlet_featureclass IS NULL;

        INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'INFO: Processing arc "'||v_data.arc_id||'" ('||v_data.epa_type||').');
        -- getting man_table to work with
        v_mantablename = 'man_frelem';
        v_epatablename = CASE v_data.epa_type
            WHEN 'PUMP' THEN 'inp_frpump'
            WHEN 'ORIFICE' THEN 'inp_frorifice'
            WHEN 'WEIR' THEN 'inp_frweir'
            WHEN 'OUTLET' THEN 'inp_froutlet'
            ELSE NULL
        END;

        -- Get flwreg_length
        SELECT ST_Length(v_data.the_geom) INTO v_flwreg_length;
        -- Get node_id
        v_node_id := v_data.node_1;
        -- Get node1_geom
        SELECT the_geom INTO v_node1_geom FROM node WHERE node_id = v_node_id;
        -- Get to_arc (arc that has node_1 = flwreg.node_2 or node_2 = flwreg.node_2 (and is not itself OR another flwreg))
        SELECT arc_id INTO v_toarc
        FROM arc
        WHERE (node_1 = v_data.node_2) OR (node_2 = v_data.node_2 AND arc_id != v_data.arc_id AND epa_type NOT IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET')); -- AND epa_type != v_data.arc_id

        v_flwregcat_id := CASE v_data.epa_type
            WHEN 'PUMP' THEN v_pump_catalog
            WHEN 'ORIFICE' THEN v_orifice_catalog
            WHEN 'WEIR' THEN v_weir_catalog
            WHEN 'OUTLET' THEN v_outlet_catalog
            ELSE NULL
        END;
        SELECT id INTO v_epa_type FROM sys_feature_epa_type WHERE epa_table = v_epatablename;

        -- Insert into element
        INSERT INTO element (elementcat_id, state, state_type, expl_id, muni_id, sector_id, epa_type, observ, the_geom)
        VALUES (v_flwregcat_id, v_data.state, v_data.state_type, v_data.expl_id, v_data.muni_id, v_data.sector_id, v_epa_type, v_data.observ, v_node1_geom)
        RETURNING element_id INTO v_flwreg_id;
        INSERT INTO t_audit_check_data (fid, criticity, error_message)
        VALUES (v_fid, 4, '    Inserted into element with element_id='||v_flwreg_id||'.');

        -- Insert into man table
        INSERT INTO man_frelem (element_id, node_id, to_arc, flwreg_length)
        VALUES (v_flwreg_id, v_node_id, v_toarc, v_flwreg_length);
        INSERT INTO t_audit_check_data (fid, criticity, error_message)
        VALUES (v_fid, 4, '    Inserted into '||v_mantablename||'.');

        -- Insert into inp table
        IF v_epatablename = 'inp_frpump' THEN
            INSERT INTO inp_frpump (element_id, curve_id, status, startup, shutoff)
            SELECT v_flwreg_id, curve_id, status, startup, shutoff FROM inp_pump WHERE arc_id = v_data.arc_id;

        ELSIF v_epatablename = 'inp_frorifice' THEN
            INSERT INTO inp_frorifice (
                    element_id, orifice_type, offsetval, cd, orate, flap,
                    shape, geom1, geom2, geom3, geom4)
            SELECT v_flwreg_id, ori_type, offsetval, cd, orate, flap,
                    shape, geom1, geom2, geom3, geom4 FROM inp_orifice WHERE arc_id = v_data.arc_id;

        ELSIF v_epatablename = 'inp_frweir' THEN
            INSERT INTO inp_frweir (
                    element_id, weir_type, offsetval, cd, ec, cd2, flap,
                    geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve)
            SELECT v_flwreg_id, weir_type, offsetval, cd, ec, cd2, flap,
                    geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve FROM inp_weir WHERE arc_id = v_data.arc_id;

        ELSIF v_epatablename = 'inp_froutlet' THEN
            INSERT INTO inp_froutlet (element_id, outlet_type, offsetval, curve_id, cd1, cd2, flap)
            SELECT v_flwreg_id, outlet_type, offsetval, curve_id, cd1, cd2, flap FROM inp_outlet WHERE arc_id = v_data.arc_id;

        END IF;
        INSERT INTO t_audit_check_data (fid, criticity, error_message)
        VALUES (v_fid, 4, '    Inserted into '||v_epatablename||'.');

        -- Insert into element_x_node
        INSERT INTO element_x_node (element_id, node_id)
        VALUES (v_flwreg_id, v_node_id);
        INSERT INTO t_audit_check_data (fid, criticity, error_message)
        VALUES (v_fid, 4, '    Inserted into element_x_node.');

        -- manage if there are other flowregs
        SELECT count(*) INTO v_count FROM arc WHERE state=1 AND node_1=v_data.node_1 AND node_2=v_data.node_2;

        -- downgrade to obsolete the flowreg in the table arc
        UPDATE arc SET state=0,state_type=2 WHERE arc_id = v_data.arc_id;
        INSERT INTO t_audit_check_data (fid, criticity, error_message)
        VALUES (v_fid, 4, '    Downgraded element in table arc.');

        -- if there are multiple flwregs connected to the same nodes, only reconnect arc if it's the last one
        IF v_count <= 1 THEN
            -- reconnect topology
            UPDATE arc SET node_1=v_data.node_1 WHERE node_1=v_data.node_2 AND epa_type NOT IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET');
            UPDATE arc SET node_2=v_data.node_1 WHERE node_2=v_data.node_2 AND epa_type NOT IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET');
            INSERT INTO t_audit_check_data (fid, criticity, error_message)
            VALUES (v_fid, 4, '    Reconnected topology (moved extremal nodes of arcs connected to element).');
            -- update the_geom of node_1 for the arc to be reconnected
            UPDATE node SET the_geom = the_geom WHERE node_id=v_data.node_1;
            INSERT INTO t_audit_check_data (fid, criticity, error_message)
            VALUES (v_fid, 4, '    Updated the_geom of node_1 (for the arc to be reconnected).');
            -- downgrade to obsolete node_2 of flowreg
            UPDATE node SET state=0,state_type=2 WHERE node_id = v_data.node_2;
            INSERT INTO t_audit_check_data (fid, criticity, error_message)
            VALUES (v_fid, 4, '    Downgraded node_2 of flwreg.');
        END IF;
    END LOOP;

    INSERT INTO t_audit_check_data (fid, criticity, error_message)
    VALUES (v_fid, 4, 'Process finished.');

    -- set node topocontrol=true
    UPDATE config_param_system SET value='{"activated":true,"value":0.1}' WHERE "parameter"='edit_node_proximity';
    INSERT INTO t_audit_check_data (fid, criticity, error_message)
    VALUES (v_fid, 4, 'Reactivated node proximity check.');

    -- collect log messages
    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result_info
    FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND criticity > 1 order by criticity desc, id asc) row;

    PERFORM gw_fct_manage_temp_tables(('{"data":{"parameters":{"fid":'||v_fid||', "project_type":"UD", "action":"DROP", "group":"LOG"}}}')::json);

    --Control nulls
    v_version := COALESCE(v_version, '');
    v_result_info := COALESCE(v_result_info, '{}');

    -- Return
    RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Import succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
             ',"data":{ "info":'||v_result_info||
               '}}'||
        '}')::json;

    -- Exception handling
    EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
     RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$function$
;
