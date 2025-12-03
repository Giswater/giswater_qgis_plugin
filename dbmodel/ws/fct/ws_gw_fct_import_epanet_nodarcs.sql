-- Function code: 3382

-- DROP FUNCTION SCHEMA_NAME.gw_fct_import_epanet_nodarcs(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_import_epanet_nodarcs(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_import_epanet_nodarcs($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "pumps": {"featureClass": "PUMP", "catalog": "PUMP"},"fcv": {"featureClass": "FL_CONTR_VALVE", "catalog": "FCV"},"tcv": {"featureClass": "THROTTLE_VALVE", "catalog": "TCV"}}}$$);

-- fid:

*/

DECLARE
v_fid integer = 239;
v_version text;
v_data record;
v_json_aux json;
v_feature_class text;
v_workcat_id text;
v_nodecat text;
v_epatype text;
v_mantablename text;
v_epatablename text;
rpt_rec record;
v_epsg integer;
v_point_geom public.geometry;
v_thegeom public.geometry;
v_node_id int;
v_toarc int;
v_node1 int;
v_node2 int;
v_arc_id int;
v_elevation float;
v_errcontext text;
v_msgerr json;

v_result_info json;

BEGIN

    --  Search path
    SET search_path = "SCHEMA_NAME", public;

    -- get system parameters
    SELECT giswater, epsg INTO v_version, v_epsg FROM sys_version ORDER BY id DESC LIMIT 1;

    -- get function parameters
    v_workcat_id = ((p_data ->>'data')::json->>'workcatId')::text;

    -- Starting process
    PERFORM gw_fct_manage_temp_tables(('{"data":{"parameters":{"fid": '||v_fid||', "project_type": "WS", "action": "CREATE", "group": "LOG"}}}')::json);

    -- set node topocontrol=false
    UPDATE config_param_system SET value='{"activated":false,"value":0.1}' WHERE "parameter"='edit_node_proximity';
    INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'INFO: Deactivated node proximity check.');
    ALTER TABLE node DISABLE TRIGGER gw_trg_node_arc_divide;
    INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'INFO: Disabled node trigger ''gw_trg_node_arc_divide''.');

    -- loop all arcs that need to be nodes
    FOR v_data IN
        SELECT *
        FROM (
            SELECT *, COUNT(*) OVER (PARTITION BY node_1, node_2) AS cnt
            FROM arc
            WHERE epa_type IN ('VIRTUALVALVE', 'VIRTUALPUMP')
            AND workcat_id = v_workcat_id
        ) subquery
        WHERE cnt = 1
    LOOP
        -- Get nodecat & epatype
        IF v_data.epa_type = 'VIRTUALVALVE' THEN
            v_epatype = 'VALVE';

            v_nodecat = (SELECT valve_type FROM inp_virtualvalve WHERE arc_id = v_data.arc_id);
            v_json_aux = ((p_data ->>'data')::json->>lower(v_nodecat))::json;
            CONTINUE WHEN v_json_aux IS NULL;
            v_nodecat = (v_json_aux->>'catalog')::text;
            v_feature_class = (v_json_aux->>'featureClass')::text;
        ELSIF v_data.epa_type = 'VIRTUALPUMP' THEN
            v_epatype = 'PUMP';

            v_json_aux = ((p_data ->>'data')::json->>'pumps')::json;
            CONTINUE WHEN v_json_aux IS NULL;
            v_nodecat = (v_json_aux->>'catalog')::text;
            v_feature_class = (v_json_aux->>'featureClass')::text;
        ELSE
            v_nodecat = 'SHORTPIPE';
            v_epatype = 'SHORTPIPE';
        END IF;
        INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('INFO: Processing nodarc ',v_data.arc_id,' (',v_epatype,').'));

        -- getting man_table to work with
        SELECT man_table, epa_table INTO v_mantablename, v_epatablename
        FROM cat_feature cf
        JOIN sys_feature_class sf ON cf.feature_class = sf.id
        JOIN sys_feature_epa_type se ON sf.epa_default = se.id
        WHERE cf.id = v_feature_class;

        -- defining geometry of new node

        -- point geometry
        v_thegeom = ST_LineInterpolatePoint(v_data.the_geom, 0.5);

        -- defining new node parameters
        v_node_id = v_data.arc_id;
        SELECT arc_id INTO v_toarc FROM arc WHERE node_1=v_data.node_2 LIMIT 1;

        -- Introducing new node transforming line into point
        INSERT INTO node (node_id, nodecat_id, epa_type, sector_id, dma_id, expl_id, muni_id, state, state_type, the_geom)
        VALUES (v_node_id, v_nodecat, v_epatype, v_data.sector_id, v_data.dma_id, v_data.expl_id, v_data.muni_id, v_data.state, v_data.state_type, v_thegeom);

        INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '    Inserted into node.');

        EXECUTE 'INSERT INTO '||v_mantablename||' VALUES ('||quote_literal(v_node_id)||')';

        INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('    Inserted into ',v_mantablename,'.'));

        IF v_epatablename = 'inp_pump' THEN
            INSERT INTO inp_pump (node_id, power, curve_id, speed, pattern_id, status, pump_type) -- TODO: there is no energyvalue in inp_virtualpump
            SELECT v_node_id, power, curve_id, speed, pattern_id, status, pump_type FROM inp_virtualpump WHERE arc_id=v_data.arc_id;

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '    Inserted into inp_pump.');

            UPDATE man_pump SET to_arc = v_toarc WHERE node_id = v_node_id;

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('    Updated to_arc=',v_toarc,'.'));

        ELSIF v_epatablename = 'inp_valve' THEN
            INSERT INTO inp_valve (node_id, valve_type, custom_dint, setting, curve_id, minorloss) -- TODO: there is no status in inp_valve, but there wasn't in 3.6 either...
            SELECT v_node_id, valve_type, diameter, setting, curve_id, minorloss FROM inp_virtualvalve WHERE arc_id=v_data.arc_id;

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '    Inserted into inp_valve.');

            UPDATE man_valve SET to_arc = v_toarc WHERE node_id = v_node_id;

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('    Updated to_arc=',v_toarc,'.'));
        ELSE
            INSERT INTO inp_shortpipe (node_id, status) SELECT v_node_id, status FROM inp_pipe WHERE arc_id=v_data.arc_id;

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '    Inserted into inp_shortpipe.');
        END IF;

        -- get old nodes
        SELECT node_1, node_2 INTO v_node1, v_node2 FROM arc WHERE arc_id=v_data.arc_id;

        -- calculate elevation from old nodes
        v_elevation = ((SELECT top_elev FROM node WHERE node_id=v_node1) + (SELECT top_elev FROM node WHERE node_id=v_node2))/2;

        -- reconnect topology - handle special nodes (TANK, RESERVOIR, etc.) differently
        -- Check node_1
        IF (SELECT epa_type FROM node WHERE node_id=v_node1) = 'JUNCTION'
            AND (SELECT count(*) FROM arc WHERE node_1=v_node1 OR node_2=v_node1) < 3 THEN
            -- Normal junction: reconnect all arcs to new node
            UPDATE arc SET node_1=v_node_id WHERE node_1=v_node1 AND arc_id!=v_data.arc_id;
			-- Update geometry
			UPDATE arc
			SET the_geom = ST_SetPoint(the_geom, 0, v_thegeom)
			WHERE node_1=v_node_id AND arc_id!=v_data.arc_id;

            UPDATE arc SET node_2=v_node_id WHERE node_2=v_node1 AND arc_id!=v_data.arc_id;
			-- Update geometry
			UPDATE arc
			SET the_geom = ST_SetPoint(the_geom, ST_NumPoints(the_geom) - 1, v_thegeom)
			WHERE node_2=v_node_id AND arc_id!=v_data.arc_id;
            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('    Reconnected junction ',v_node1,'.'));
        ELSE
            -- Special node (TANK, RESERVOIR, etc.): create virtual arc to connect it to new node
            INSERT INTO arc (node_1, node_2, arccat_id, epa_type, sector_id, dma_id, expl_id, muni_id, state, state_type, the_geom)
            VALUES (v_node_id, v_node1, 'VARC', 'PIPE', v_data.sector_id, v_data.dma_id, v_data.expl_id, v_data.muni_id, v_data.state, v_data.state_type,
                ST_MakeLine(v_thegeom, (SELECT the_geom FROM node WHERE node_id=v_node1)))
            RETURNING arc_id INTO v_arc_id;

            INSERT INTO man_varc (arc_id) VALUES (v_arc_id);

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('    Created virtual arc ',v_arc_id,' to keep node ',v_node1,' (',
                (SELECT epa_type FROM node WHERE node_id=v_node1),').'));
        END IF;

        -- Check node_2
        IF (SELECT epa_type FROM node WHERE node_id=v_node2) = 'JUNCTION'
            AND (SELECT count(*) FROM arc WHERE node_1=v_node2 OR node_2=v_node2) < 3 THEN
            -- Normal junction: reconnect all arcs to new node
            UPDATE arc SET node_1=v_node_id WHERE node_1=v_node2 AND arc_id!=v_data.arc_id;
			-- Update geometry
			UPDATE arc
			SET the_geom = ST_SetPoint(the_geom, 0, v_thegeom)
			WHERE node_1=v_node_id AND arc_id!=v_data.arc_id;

            UPDATE arc SET node_2=v_node_id WHERE node_2=v_node2 AND arc_id!=v_data.arc_id;
			UPDATE arc
			SET the_geom = ST_SetPoint(the_geom, ST_NumPoints(the_geom) - 1, v_thegeom)
			WHERE node_2=v_node_id AND arc_id!=v_data.arc_id;

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('    Reconnected junction ',v_node2,'.'));
        ELSE
            -- Special node (TANK, RESERVOIR, etc.): create virtual arc to connect it to new node
            INSERT INTO arc (node_1, node_2, arccat_id, epa_type, sector_id, dma_id, expl_id, muni_id, state, state_type, the_geom)
            VALUES (v_node_id, v_node2, 'VARC', 'PIPE', v_data.sector_id, v_data.dma_id, v_data.expl_id, v_data.muni_id, v_data.state, v_data.state_type,
                ST_MakeLine(v_thegeom, (SELECT the_geom FROM node WHERE node_id=v_node2)))
            RETURNING arc_id INTO v_arc_id;

            INSERT INTO man_varc (arc_id) VALUES (v_arc_id);

            INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, concat('    Created virtual arc ',v_arc_id,' to keep node ',v_node2,' (',
                (SELECT epa_type FROM node WHERE node_id=v_node2),'.'));
        END IF;

        -- Delete old arc
        DELETE FROM arc WHERE arc_id=v_data.arc_id;
        INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '    Deleted old arc.');

        -- Delete old junctions
        DELETE FROM node WHERE node_id IN (v_node1, v_node2) AND epa_type='JUNCTION';
        INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '    Deleted old junctions.');

        -- update elevation of new node
        UPDATE node SET top_elev = v_elevation, the_geom = the_geom WHERE node_id=v_node_id;
        INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, '    Updated node elevation and geometry.');

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

    -- update man_valve status and to_arc
    UPDATE man_valve mv
        SET closed = CASE
            WHEN v.status = 'CLOSED' THEN TRUE
            WHEN v.status IN ('OPEN', 'ACTIVE') THEN FALSE
            END,
        to_arc = CASE
            WHEN v.status IN ('ACTIVE', 'CLOSED') THEN mv.to_arc
            ELSE NULL
            END
        FROM inp_virtualvalve v
        join arc a on v.arc_id = a.arc_id
    WHERE mv.node_id = v.arc_id
    and a.workcat_id = v_workcat_id and a.state = 0;

    -- set node topocontrol=true
    UPDATE config_param_system SET value='{"activated":true,"value":0.1}' WHERE "parameter"='edit_node_proximity';
    INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'INFO: Activated node proximity check.');
    ALTER TABLE node ENABLE TRIGGER gw_trg_node_arc_divide;
    INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 4, 'INFO: Enabled node trigger ''gw_trg_node_arc_divide''.');

    -- collect log messages
    SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result_info
    FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND criticity > 1 order by criticity desc, id asc) row;

    PERFORM gw_fct_manage_temp_tables(('{"data":{"parameters":{"fid":'||v_fid||', "project_type":"WS", "action":"DROP", "group":"LOG"}}}')::json);

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
