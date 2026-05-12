/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
-- Part of code of this inundation function have been provided by Claudia Dragoste (Aigües de Manresa, SA)


--FUNCTION CODE: 2680

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_network(p_data json)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"test1","fid":227}}}')::json; -- when is called from go2epa
-- fid: main:139

SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE}, "data":{"resultId":"test1", "step":"1"}}$$); -- PRE-PROCESS
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE}, "data":{"resultId":"test1", "step":"2"}}$$); -- AUTOREPAIR
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE}, "data":{"resultId":"test1", "step":"3"}}$$); -- CHECK DATA
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE}, "data":{"resultId":"test1", "step":"4"}}$$); -- STRUCTURE DATA
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE}, "data":{"resultId":"test1", "step":"5"}}$$); -- CHECK GRAPH

*/

DECLARE

v_rec record;
v_project_type text;
v_cont integer default 0;
v_result_id text;
v_fid integer;
v_querytext text;
v_count integer = 0;
v_min float;
v_max float;
v_version text;
v_networkstats json;
v_sumlength numeric (12,2);
v_linkoffsets text;
v_deldisconnetwork boolean;
v_deldrynetwork boolean;
v_removedemands boolean;
v_minlength float;
v_demand numeric (12,4);
v_networkmode integer;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get input data
	v_result_id = ((p_data->>'data')::json->>'parameters')::json->>'resultId';
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';

	-- get project type
	v_project_type = (SELECT project_type FROM sys_version ORDER BY id DESC LIMIT 1);
	v_version = (SELECT giswater FROM sys_version ORDER BY id DESC LIMIT 1);

	-- get options data
	SELECT value INTO v_linkoffsets FROM config_param_user WHERE parameter = 'inp_options_link_offsets' AND cur_user = current_user;
	SELECT value INTO v_minlength FROM config_param_user WHERE parameter = 'inp_options_minlength' AND cur_user = current_user;
	v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);

	-- get user variables
	v_deldisconnetwork = (SELECT value::json->>'delDisconnNetwork' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_deldrynetwork = (SELECT value::json->>'delDryNetwork' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
	v_removedemands = (SELECT value::json->>'removeDemandOnDryNodes' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;

	-- preparing table for check disconnected/dry network (139/232)
	DROP TABLE IF EXISTS temp_t_pgr_go2epa_arc; CREATE TEMP TABLE temp_t_pgr_go2epa_arc AS SELECT * FROM temp_t_arc;
	DROP TABLE IF EXISTS temp_t_pgr_go2epa_node; CREATE TEMP TABLE temp_t_pgr_go2epa_node AS SELECT * FROM temp_t_node;

	IF v_project_type = 'WS' THEN
		UPDATE temp_t_pgr_go2epa_node n SET dma_id = -2;
		UPDATE temp_t_pgr_go2epa_arc SET dma_id = -2;
	END IF;

	UPDATE temp_t_pgr_go2epa_node n SET sector_id = 0, omzone_id=0;
	UPDATE temp_t_pgr_go2epa_arc SET sector_id = 0, omzone_id=0;


	-- update graph for disconnected (139)
    UPDATE temp_t_pgr_go2epa_node n SET sector_id = c.component
    FROM pgr_connectedcomponents('
            SELECT a.id, n1.id as source, n2.id as target, 1 as cost 
			FROM temp_t_pgr_go2epa_arc a
			join temp_t_pgr_go2epa_node n1 on n1.node_id = node_1
			join temp_t_pgr_go2epa_node n2 on n2.node_id = node_2
        ') c
    WHERE n.id::int = c.node;

	-- setting those node with sectors without inlet to sector_id = 0
	UPDATE temp_t_pgr_go2epa_node SET sector_id = 0 WHERE sector_id NOT IN
	(SELECT DISTINCT sector_id FROM (SELECT DISTINCT sector_id, epa_type FROM temp_t_pgr_go2epa_node WHERE epa_type IN ('INLET', 'RESERVOIR', 'TANK', 'OUTFALL'))a);

	-- update arc graph
	UPDATE temp_t_pgr_go2epa_arc SET sector_id = n.sector_id FROM temp_t_pgr_go2epa_node n WHERE node_id =  node_1;
	UPDATE temp_t_pgr_go2epa_arc SET sector_id = n.sector_id FROM temp_t_pgr_go2epa_node n WHERE node_id =  node_2;

	IF v_project_type = 'WS' THEN

		-- update arc graph for dry (232)
		DELETE FROM temp_t_pgr_go2epa_arc WHERE status = 'CLOSED';

		-- update node graph for dry (232) using dma_id
	    UPDATE temp_t_pgr_go2epa_node n SET dma_id = c.component
	    FROM pgr_connectedcomponents('
            SELECT a.id, n1.id as source, n2.id as target, 1 as cost 
			FROM temp_t_pgr_go2epa_arc a
			join temp_t_pgr_go2epa_node n1 on n1.node_id = node_1
			join temp_t_pgr_go2epa_node n2 on n2.node_id = node_2
	        ') c
	    WHERE n.id::int = c.node;

		-- setting those node with dma_id without inlet to dma_id = 0
		UPDATE temp_t_pgr_go2epa_node SET dma_id = -2 WHERE dma_id NOT IN
		(SELECT DISTINCT dma_id FROM (SELECT DISTINCT dma_id, epa_type FROM temp_t_pgr_go2epa_node WHERE epa_type IN ('INLET', 'RESERVOIR', 'TANK'))a);

		-- update arc graph
		UPDATE temp_t_pgr_go2epa_arc SET dma_id = n.dma_id FROM temp_t_pgr_go2epa_node n WHERE node_id =  node_1;
		UPDATE temp_t_pgr_go2epa_arc SET dma_id = n.dma_id FROM temp_t_pgr_go2epa_node n WHERE node_id =  node_2;

	END IF;

	-- getting sys_fprocess to be executed
	IF v_networkmode = 4 THEN
		v_querytext = '
			SELECT * FROM sys_fprocess 
			WHERE project_type IN (lower('||quote_literal(v_project_type)||'), ''utils'') 
			AND addparam IS NULL 
			AND query_text IS NOT NULL 
			AND function_name ILIKE ''%pg2epa_check%'' AND function_name NOT ILIKE ''%pg2epa_check_data%''
			AND active ORDER BY fid ASC
		';
	ELSE
		v_querytext = '
			SELECT * FROM sys_fprocess 
			WHERE project_type IN (lower('||quote_literal(v_project_type)||'), ''utils'') 
			AND addparam IS NULL 
			AND query_text IS NOT NULL 
			AND function_name ILIKE ''%pg2epa_check%'' AND function_name NOT ILIKE ''%pg2epa_check_data%'' AND function_name NOT ILIKE ''%pg2epa_check_networkmode_connec%''
			AND function_name NOT ILIKE ''%pg2epa_check_result%''
			AND active ORDER BY fid ASC
		';
	END IF;

	-- loop for checks
	FOR v_rec IN EXECUTE v_querytext
	LOOP
		EXECUTE 'SELECT gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid":'||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';
	END LOOP;

	-- remove disconnected network
	IF v_deldisconnetwork THEN

		UPDATE temp_t_arc a SET sector_id = t.sector_id FROM temp_t_pgr_go2epa_arc t WHERE t.sector_id = 0 AND t.arc_id = a.arc_id;
		UPDATE temp_t_node a SET sector_id = t.sector_id FROM temp_t_pgr_go2epa_node t WHERE t.sector_id = 0 AND t.node_id = a.node_id;
		DELETE FROM temp_t_arc WHERE sector_id = 0;
		DELETE FROM temp_t_node WHERE sector_id = 0;
		GET DIAGNOSTICS v_count = row_count;

		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2,
			concat('WARNING-227: {delDisconnectNetwork} is enabled and ',v_count,' arcs have been removed.'));
		ELSE
			INSERT INTO t_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1,
			concat('INFO: {delDisconnectNetwork} is enabled but nothing have been removed.'));
		END IF;
	END IF;

	-- remove dry network
	IF v_deldrynetwork THEN

		UPDATE temp_t_arc a SET dma_id = t.dma_id FROM temp_t_pgr_go2epa_arc t WHERE t.dma_id = -2 AND t.arc_id = a.arc_id;
		UPDATE temp_t_node a SET dma_id = t.dma_id FROM temp_t_pgr_go2epa_node t WHERE t.dma_id = -2 AND t.node_id = a.node_id;
		DELETE FROM temp_t_arc WHERE dma_id = -2;
		DELETE FROM temp_t_node WHERE dma_id = -2;
		GET DIAGNOSTICS v_count = row_count;

		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2,
			concat('WARNING-227: {delDryNetwork} is enabled and ',v_count,' arcs have been removed.'));
		ELSE
			INSERT INTO t_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1,
			concat('INFO: {delDryNetwork} is enabled but nothing have been removed.'));
		END IF;
	END IF;

	-- remove dry demands
	IF v_removedemands THEN
		UPDATE temp_t_node n SET demand = 0, addparam = gw_fct_json_object_set_key(a.addparam::json, 'removedDemand'::text, true::boolean)
		FROM temp_t_pgr_go2epa_node a WHERE a.node_id = n.node_id AND a.dma_id = -2;
		GET DIAGNOSTICS v_count = row_count;

		IF v_count > 0 THEN
			INSERT INTO t_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2, concat(
			'WARNING-227: {removeDemandsOnDryNetwork} is enabled and demand from ',v_count,' nodes have been removed'));
		ELSE
			INSERT INTO t_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, concat('INFO: {removeDemandsOnDryNetwork} is enabled but no dry nodes have been found.'));
		END IF;
		DELETE FROM t_audit_check_data WHERE fid = 227 AND error_message like '%Dry node(s) with demand%' AND cur_user = current_user;
	END IF;


	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,concat(''));
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,concat('BASIC STATS'));
	INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,concat('-------------------'));

	IF v_project_type =  'WS' THEN

		SELECT sum(length)/1000 INTO v_sumlength FROM temp_t_arc;
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Total length (Km) : ',v_sumlength,'.'));

		SELECT min(top_elev), max(top_elev) INTO v_min, v_max FROM temp_t_node;
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(length), max(length) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'PIPE';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for pipe length. Minimun and maximum values are: (',v_min,' - ',v_max,' ).'));

		SELECT min(diameter), max(diameter) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'PIPE';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for pipe diameter. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(roughness), max(roughness) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'PIPE';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for pipe roughness. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		v_networkstats = gw_fct_json_object_set_key((select json_build_object('sector', array_agg(sector_id)) FROM selector_sector where cur_user=current_user and sector_id > 0)
		 ,'Total Length (Km)', v_sumlength);

	ELSIF v_project_type  ='UD' THEN

		SELECT sum(length)/1000 INTO v_sumlength FROM temp_t_arc;
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Total length (Km) : ',coalesce(v_sumlength,0::numeric),'.'));

		IF v_linkoffsets  = 'ELEVATION' THEN

			UPDATE temp_t_arc SET length = null where length = 0;

			SELECT min(((elevmax1-elevmax2)/coalesce(length,0.1))::numeric(12,4)), max(((elevmax1-elevmax2)/coalesce(length,0.1)::numeric(12,4)))
			INTO v_min, v_max FROM temp_t_arc;
			INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
			concat('Data analysis for conduit slope. Values from [',v_min,'] to [',v_max,'] have been found.'));
		END IF;

		SELECT min(length), max(length) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for conduit length. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(n), max(n) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for conduit manning roughness coeficient. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(elevmax1), max(elevmax1) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for conduit z1. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(elevmax2), max(elevmax2) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for conduit z2. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(slope), max(slope) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for conduit slope. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(elev), max(elev) INTO v_min, v_max FROM temp_t_node;
		INSERT INTO t_audit_check_data (fid, criticity, error_message) VALUES (v_fid, 0,
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		v_networkstats = gw_fct_json_object_set_key((select json_build_object('sector', array_agg(sector_id))
		FROM selector_sector where cur_user=current_user and sector_id > 0),
		'Total Length (Km)', v_sumlength);
	END IF;

	-- set rpt_cat_result table with network stats
	INSERT INTO t_rpt_cat_result (result_id, network_stats) VALUES (v_result_id, v_networkstats);

	--  Return
	RETURN '{"status":"ok"}';

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
