-- Function code: 3382

-- DROP FUNCTION SCHEMA_NAME.gw_fct_import_epanet_nodarcs(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_epanet_nodarcs(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_epanet_nodarcs($${"data": {"valvesType": "PR_REDUC_VALVE", "pumpsType": "PUMP"}}$$);

-- fid:

*/

DECLARE
v_fid integer = 239;
v_version text;
v_data record;
v_nodecat text;
v_epatype text;
v_type text;
v_pumptype text;
v_mantablename text;
v_valves_type text;
v_pumps_type text;
v_epatablename text;
rpt_rec record;
v_epsg integer;
v_point_geom public.geometry;
v_thegeom public.geometry;
v_node_id text;
v_toarc text;
v_node1 text;
v_node2 text;
v_elevation float;
v_querytext text;
v_errcontext text;

v_isgwproject boolean = FALSE; -- MOST IMPORTANT variable of this function. When true importation will be used making and arc2node reverse transformation for pumps and valves. Only works using Giswater sintaxis of additional pumps
v_delete_prev boolean = true; -- used on dev mode to
i integer=1;
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
    v_valves_type := (p_data ->>'data')::json->>'valvesType'::text;
    v_pumps_type := (p_data ->>'data')::json->>'pumpsType'::text;

    -- Starting process

    -- set node topocontrol=false
    UPDATE config_param_system SET value='{"activated":false,"value":0.1}' WHERE "parameter"='edit_node_proximity';
    ALTER TABLE node DISABLE TRIGGER gw_trg_node_arc_divide;

    -- loop all arcs that need to be nodes
    -- TODO: add where to only transform those on the current import inp
    FOR v_data IN
        SELECT *
        FROM (
            SELECT *, COUNT(*) OVER (PARTITION BY node_1, node_2) AS cnt
            FROM arc
            WHERE epa_type IN ('VIRTUALVALVE', 'VIRTUALPUMP')
        ) subquery
        WHERE cnt = 1
    LOOP
        -- Get nodecat & epatype
        IF v_data.epa_type = 'VIRTUALVALVE' THEN
            v_nodecat = (SELECT valv_type FROM inp_virtualvalve WHERE arc_id = v_data.arc_id);
            v_epatype = 'VALVE';
            v_type = v_valves_type;
        ELSIF v_data.epa_type = 'VIRTUALPUMP' THEN
            v_pumptype = (SELECT pump_type FROM inp_virtualpump WHERE arc_id = v_data.arc_id);

            v_nodecat = 'PUMP';
            v_epatype = 'PUMP';
            v_type = v_pumps_type;
        ELSE
            v_nodecat = 'SHORTPIPE';
            v_epatype = 'SHORTPIPE';
        END IF;

        -- getting man_table to work with
        SELECT man_table, epa_table INTO v_mantablename, v_epatablename
        FROM cat_feature cf
        JOIN sys_feature_class sf ON cf.feature_class = sf.id
        JOIN sys_feature_epa_type se ON sf.epa_default = se.id
        WHERE cf.id = v_type;

        -- defining geometry of new node

        -- point geometry
        v_thegeom = ST_LineInterpolatePoint(v_data.the_geom, 0.5);

        -- defining new node parameters
        v_node_id = v_data.arc_id;
        SELECT arc_id INTO v_toarc FROM arc WHERE node_1=v_data.node_2 LIMIT 1;

        -- Introducing new node transforming line into point
        INSERT INTO node (node_id, nodecat_id, epa_type, sector_id, dma_id, expl_id, muni_id, state, state_type, the_geom)
        VALUES (v_node_id, v_nodecat, v_epatype, 0, 0, v_data.expl_id, v_data.muni_id, 1, 2, v_thegeom);

        EXECUTE 'INSERT INTO '||v_mantablename||' VALUES ('||quote_literal(v_node_id)||')';

        IF v_epatablename = 'inp_pump' THEN
            INSERT INTO inp_pump (node_id, power, curve_id, speed, pattern_id, status, pump_type) -- TODO: there is no energyvalue in inp_virtualpump
            SELECT v_node_id, power, curve_id, speed, pattern_id, status, v_pumptype FROM inp_virtualpump WHERE arc_id=v_data.arc_id;

            UPDATE man_pump SET to_arc = v_toarc WHERE node_id = v_node_id;

        ELSIF v_epatablename = 'inp_valve' THEN
            INSERT INTO inp_valve (node_id, valv_type, custom_dint, setting, curve_id, minorloss) -- TODO: there is no status in inp_valve, but there wasn't in 3.6 either...
            SELECT v_node_id, valv_type, diameter, setting, curve_id, minorloss FROM inp_virtualvalve WHERE arc_id=v_data.arc_id;

            UPDATE man_valve SET to_arc = v_toarc WHERE node_id = v_node_id;
        ELSE
            INSERT INTO inp_shortpipe (node_id, status) SELECT v_node_id, status FROM inp_pipe WHERE arc_id=v_data.arc_id;
        END IF;

        -- get old nodes
        SELECT node_1, node_2 INTO v_node1, v_node2 FROM arc WHERE arc_id=v_data.arc_id;

        -- calculate elevation from old nodes
        v_elevation = ((SELECT elevation FROM node WHERE node_id=v_node1) + (SELECT elevation FROM node WHERE node_id=v_node2))/2;

        -- reconnect topology
        UPDATE arc SET node_1=v_node_id WHERE node_1=v_node1 OR node_1=v_node2;
        UPDATE arc SET node_2=v_node_id WHERE node_2=v_node1 OR node_2=v_node2;

        -- downgrade to obsolete arcs and nodes
        UPDATE arc SET state=0,state_type=2 WHERE arc_id=v_data.arc_id;
        UPDATE node SET state=0,state_type=2 WHERE node_id IN (v_node1, v_node2);

        -- update elevation of new node
        UPDATE node SET elevation = v_elevation, the_geom = the_geom WHERE node_id=v_node_id;

    END LOOP;

    --     to_arc on shortpipes
    --    UPDATE inp_shortpipe SET to_arc = b.to_arc FROM
    --        (
    --        select a.arc_id, n.arc_id AS to_arc from inp_pipe
    --        JOIN arc a USING (arc_id)
    --        JOIN (SELECT arc_id, node_1 FROM arc UNION SELECT arc_id, node_2 FROM arc)n ON a.node_2 = n.node_1
    --        WHERE
    --        a.arc_id != n.arc_id
    --        and status = 'CV')b
    --    WHERE  b.arc_id = inp_shortpipe.node_id; -- TODO: add where to only transform those on the current import inp

    -- additional pumps are not transformed into nodes
    --    INSERT INTO inp_pump_additional (node_id, order_id, power, curve_id, speed, pattern_id, status)
    --    select
    --    arc_id,
    --    1, -- TODO: get order_id somehow
    --    power, curve_id, speed, pattern_id, status -- , energyvalue -- TODO: what to do with this? there is no energyvalue in inp_virtualpump
    --    from inp_virtualpump; -- TODO: add where to only transform those on the current import inp
    -- update state=0 pump additionals
    --    UPDATE arc SET state = 0 WHERE arc_id IN (SELECT arc_id FROM inp_virtualpump); -- here there isn't a WHERE????

    -- delete objects;
    --    DELETE FROM inp_pipe WHERE substring(reverse(arc_id),0,5) = 'a2n_'; -- pumps/valves don't get inserted into inp_pipe...

    INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (239, 1,
    'INFO: Link geometries from VALVES AND PUMPS have been transformed using reverse nod2arc strategy as nodes. Geometry from arcs and nodes are saved using state=0');

    -- set node topocontrol=true
    UPDATE config_param_system SET value='{"activated":true,"value":0.1}' WHERE "parameter"='edit_node_proximity';
    ALTER TABLE node ENABLE TRIGGER gw_trg_node_arc_divide;

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
