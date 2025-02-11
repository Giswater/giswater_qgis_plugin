-- Function code: 3384

-- DROP FUNCTION SCHEMA_NAME.gw_fct_import_swmm_flwreg(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_swmm_flwreg(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_swmm_flwreg($${"data": {
    "pump": {
        "featureClass": "FRPUMP",
        "catalog": "FRPUMP-01"
    },
    "orifice": {
        "featureClass": "FRORIFICE",
        "catalog": "FRORIFICE-01"
    },
    "weir": {
        "featureClass": "FRWEIR",
        "catalog": "FRWEIR-01"
    },
    "outlet": {
        "featureClass": "FROUTLET",
        "catalog": "FROUTLET-01"
    }
}}$$);

-- fid:

*/

DECLARE
v_fid integer = 239;
v_version text;
v_epsg integer;

v_data record;
v_count integer;
v_mantablename text;
v_epatablename text;

v_pump_featureclass text;
v_pump_catalog text;
v_orifice_featureclass text;
v_orifice_catalog text;
v_weir_featureclass text;
v_weir_catalog text;
v_outlet_featureclass text;
v_outlet_catalog text;

v_flwreg_id varchar(16);
v_flwregcat_id text;
v_flwreg_length float;
v_toarc text;
v_order_id integer;
v_node_id text;
v_node1 text;
v_node2 text;
v_elevation float;

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
    raise notice 'featureClass -> pumps=%, orifices=%, weirs=%, outlets=%', v_pump_featureclass, v_orifice_featureclass, v_weir_featureclass, v_outlet_featureclass;
    raise notice 'catalog -> pumps=%, orifices=%, weirs=%, outlets=%', v_pump_catalog, v_orifice_catalog, v_weir_catalog, v_outlet_catalog;
    -- Starting process

    -- set node topocontrol=false
    UPDATE config_param_system SET value='{"activated":false,"value":0.1}' WHERE "parameter"='edit_node_proximity';

    -- loop all arcs that need to be flowregulators
    -- TODO: add where to only transform those on the current import inp
    FOR v_data IN
        SELECT *
        FROM arc
        WHERE epa_type IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET') AND state = 1 AND (
            (epa_type = 'PUMP' AND v_pump_featureclass IS NOT NULL) OR
            (epa_type = 'ORIFICE' AND v_orifice_featureclass IS NOT NULL) OR
            (epa_type = 'WEIR' AND v_weir_featureclass IS NOT NULL) OR
            (epa_type = 'OUTLET' AND v_outlet_featureclass IS NOT NULL)
        )
    LOOP
        raise notice 'processing arc -> arc_id=% epa_type=%', v_data.arc_id, v_data.epa_type;
        -- getting man_table to work with
        SELECT man_table, epa_table INTO v_mantablename, v_epatablename
        FROM cat_feature cf
        JOIN sys_feature_class sf ON cf.feature_class = sf.id
        JOIN sys_feature_epa_type se ON sf.epa_default = se.id
        WHERE epa_table like '%flwreg%' AND cf.id = CASE v_data.epa_type
            WHEN 'PUMP' THEN v_pump_featureclass
            WHEN 'ORIFICE' THEN v_orifice_featureclass
            WHEN 'WEIR' THEN v_weir_featureclass
            WHEN 'OUTLET' THEN v_outlet_featureclass
            ELSE NULL
        END;
        raise notice 'v_mantablename=% v_epatablename=%', v_mantablename, v_epatablename;
        -- Get flwreg_length
        SELECT ST_Length(v_data.the_geom) INTO v_flwreg_length;
        raise notice 'v_flwreg_length=%', v_flwreg_length;
        -- Get node_id
        v_node_id := v_data.node_1;
        raise notice 'v_node_id=%', v_node_id;
        -- Get to_arc (arc that has node_1 = flwreg.node_2 or node_2 = flwreg.node_2 (and is not itself OR another flwreg))
        SELECT arc_id INTO v_toarc
        FROM arc
        WHERE (node_1 = v_data.node_2) OR (node_2 = v_data.node_2 AND arc_id != v_data.arc_id AND epa_type NOT IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET')); -- AND epa_type != v_data.arc_id
        raise notice 'v_toarc=%', v_toarc;
        -- Get order_id
        SELECT coalesce(max(order_id), 0)+1 INTO v_order_id
        FROM flwreg
        WHERE node_id = v_node_id AND to_arc = v_toarc;
        raise notice 'v_order_id=%', v_order_id;

        v_flwregcat_id := CASE v_data.epa_type
            WHEN 'PUMP' THEN v_pump_catalog
            WHEN 'ORIFICE' THEN v_orifice_catalog
            WHEN 'WEIR' THEN v_weir_catalog
            WHEN 'OUTLET' THEN v_outlet_catalog
            ELSE NULL
        END;
        -- Insert into flwreg
        INSERT INTO flwreg (node_id, order_id, to_arc, nodarc_id, flwregcat_id, flwreg_length,
                            epa_type, state, state_type, annotation, observ, the_geom)
        VALUES (v_node_id, v_order_id, v_toarc, concat(v_node_id, LEFT(v_data.epa_type, 2), v_order_id), v_flwregcat_id, v_flwreg_length,
                v_data.epa_type, v_data.state, v_data.state_type, v_data.annotation, v_data.observ, v_data.the_geom)
        RETURNING flwreg_id INTO v_flwreg_id;
        raise notice 'inserted into flwreg -> %', v_flwreg_id;
        -- Insert into man table
        EXECUTE 'INSERT INTO '||v_mantablename||' VALUES ('||quote_literal(v_flwreg_id)||', '||quote_literal(v_data.epa_type)||')';
        raise notice 'inserted into man table';
        -- Insert into inp table
        IF v_epatablename = 'inp_flwreg_pump' THEN
            INSERT INTO inp_flwreg_pump (flwreg_id, pump_type, curve_id, status, startup, shutoff)
            SELECT v_flwreg_id, 'TEST', curve_id, status, startup, shutoff FROM inp_pump WHERE arc_id = v_data.arc_id;

        ELSIF v_epatablename = 'inp_flwreg_orifice' THEN
            INSERT INTO inp_flwreg_orifice (
                    flwreg_id, orifice_type, offsetval, cd, orate, flap,
                    shape, geom1, geom2, geom3, geom4)
            SELECT v_flwreg_id, ori_type, offsetval, cd, orate, flap,
                    shape, geom1, geom2, geom3, geom4 FROM inp_orifice WHERE arc_id = v_data.arc_id;

        ELSIF v_epatablename = 'inp_flwreg_weir' THEN
            INSERT INTO inp_flwreg_weir (
                    flwreg_id, weir_type, offsetval, cd, ec, cd2, flap,
                    geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve)
            SELECT v_flwreg_id, weir_type, offsetval, cd, ec, cd2, flap,
                    geom1, geom2, geom3, geom4, surcharge, road_width, road_surf, coef_curve FROM inp_weir WHERE arc_id = v_data.arc_id;

        ELSIF v_epatablename = 'inp_flwreg_outlet' THEN
            INSERT INTO inp_flwreg_outlet (flwreg_id, outlet_type, offsetval, curve_id, cd1, cd2, flap)
            SELECT v_flwreg_id, outlet_type, offsetval, curve_id, cd1, cd2, flap FROM inp_outlet WHERE arc_id = v_data.arc_id;

        END IF;
        raise notice 'inserted into %', v_epatablename;

        -- manage if there are other flowregs
        SELECT count(*) INTO v_count FROM arc WHERE state=1 AND node_1=v_data.node_1 AND node_2=v_data.node_2;

        -- downgrade to obsolete the flowreg in the table arc
        UPDATE arc SET state=0,state_type=2 WHERE arc_id = v_data.arc_id;
        raise notice 'downgraded flowreg in table arc';

        -- if there are multiple flwregs connected to the same nodes, only reconnect arc if it's the last one
        IF v_count <= 1 THEN
            -- reconnect topology
            UPDATE arc SET node_1=v_data.node_1 WHERE node_1=v_data.node_2 AND epa_type NOT IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET');
            UPDATE arc SET node_2=v_data.node_1 WHERE node_2=v_data.node_2 AND epa_type NOT IN ('PUMP', 'ORIFICE', 'WEIR', 'OUTLET');
            raise notice 'reconnected topology';

            -- update the_geom of node_1 for the arc to be reconnected
            UPDATE node SET the_geom = the_geom WHERE node_id=v_data.node_1;
            raise notice 'updated the_geom of node_1';
            -- downgrade to obsolete node_2 of flowreg
            UPDATE node SET state=0,state_type=2 WHERE node_id = v_data.node_2;
            raise notice 'downgraded node_2 of flowreg';
        END IF;
    END LOOP;

    INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (239, 1,
    'INFO: Link geometries from VALVES AND PUMPS have been transformed using reverse nod2arc strategy as nodes. Geometry from arcs and nodes are saved using state=0');

    -- set node topocontrol=true
    UPDATE config_param_system SET value='{"activated":true,"value":0.1}' WHERE "parameter"='edit_node_proximity';

    --Control nulls
    v_version := COALESCE(v_version, '{}');
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
