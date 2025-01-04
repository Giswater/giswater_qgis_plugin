/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- Part of code of this inundation function have been provided by Claudia Dragoste (Aigües de Manresa, SA)


--FUNCTION CODE: 2680

CREATE OR REPLACE FUNCTION ws40000.gw_fct_pg2epa_check_network(p_data json)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT ws40000.gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"test1","fid":227}}}')::json; -- when is called from go2epa

CREATE TEMP TABLE temp_t_anlgraph (LIKE ws40000.temp_anlgraph INCLUDING ALL);
CREATE TEMP TABLE temp_t_anlgraph (LIKE ws40000.temp_anlgraph INCLUDING ALL);
drop table temp_t_anlgraph;

select * from ws40000.temp_t_anlgraph

--RESULTS
SELECT node_id FROM temp_anl_node WHERE fid = 233 AND cur_user=current_user
SELECT arc_id FROM temp_anl_arc WHERE fid = 232 AND cur_user=current_user
SELECT node_id FROM temp_anl_node WHERE fid = 139 AND cur_user=current_user
SELECT * FROM temp_audit_check_data WHERE fid = 139
SELECT * FROM temp_anlgraph;

-- fid: main:139
	other: 227,231,233,228,404,431,454

*/

DECLARE

v_rec record;
v_project_type text;
v_affectedrows numeric;
v_cont integer default 0;
v_buildupmode int2;
v_result_id text;
v_boundaryelem text;
v_error_context text;
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
v_return json;

BEGIN
	-- Search path
	SET search_path = "ws40000", public;

	-- get input data
	v_result_id = ((p_data->>'data')::json->>'parameters')::json->>'resultId';
	v_fid := ((p_data ->>'data')::json->>'parameters')::json->>'fid';
	
	-- get project type
	v_project_type = (SELECT project_type,gos FROM sys_version ORDER BY id DESC LIMIT 1);
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
	DROP TABLE IF EXISTS t_pgr_go2epa_arc; CREATE TEMP TABLE t_pgr_go2epa_arc AS SELECT * FROM temp_t_arc;
	DROP TABLE IF EXISTS t_pgr_go2epa_node; CREATE TEMP TABLE t_pgr_go2epa_node AS SELECT * FROM temp_t_node;

				DROP TABLE IF EXISTS t_pgr_go2epa_arc; CREATE TEMP TABLE t_pgr_go2epa_arc AS SELECT * FROM arc;
				DROP TABLE IF EXISTS t_pgr_go2epa_node; CREATE TEMP TABLE t_pgr_go2epa_node AS SELECT * FROM node;

	UPDATE t_pgr_go2epa_node n SET sector_id = 0, dma_id=0;
	UPDATE t_pgr_go2epa_arc SET sector_id = 0, dma_id=0;

	-- update graph for disconnected (139)
    UPDATE t_pgr_go2epa_node n SET sector_id = c.component
    FROM pgr_connectedcomponents('
            SELECT arc_id::int AS id, node_1::int AS source, node_2::int AS target, 1 AS cost 
            FROM t_pgr_go2epa_arc WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL
        ') c
    WHERE n.node_id::int = c.node;
	
	-- setting those node with sectors without inlet to sector_id = 0
	UPDATE t_pgr_go2epa_node SET sector_id = 0 WHERE sector_id NOT IN 
	(SELECT DISTINCT sector_id FROM (SELECT DISTINCT sector_id, epa_type FROM t_pgr_go2epa_node WHERE epa_type IN ('INLET', 'RESERVOIR', 'TANK'))a);

	-- update arc graph
	UPDATE t_pgr_go2epa_arc SET sector_id = n.sector_id FROM t_pgr_go2epa_node n WHERE node_id =  node_1;
	UPDATE t_pgr_go2epa_arc SET sector_id = n.sector_id FROM t_pgr_go2epa_node n WHERE node_id =  node_2;

	
	IF v_projectype = 'WS' THEN 
	
		-- update arc graph for dry (232)
		DELETE FROM t_pgr_go2epa_arc WHERE closed = true;

		-- update node graph for dry (232) using dma_id
	    UPDATE t_pgr_go2epa_node n SET dma_id = c.component
	    FROM pgr_connectedcomponents('
	            SELECT arc_id::int AS id, node_1::int AS source, node_2::int AS target, 1 AS cost 
	            FROM t_pgr_go2epa_arc WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL
	        ') c
	    WHERE n.node_id::int = c.node;
		
		-- setting those node with dma_id without inlet to dma_id = 0
		UPDATE t_pgr_go2epa_node SET dma_id = 0 WHERE dma_id IN 
		(SELECT DISTINCT dma_id FROM (SELECT DISTINCT dma_id, epa_type FROM t_pgr_go2epa_node WHERE epa_type IN ('INLET', 'RESERVOIR', 'TANK'))a);

		-- update arc graph
		UPDATE t_pgr_go2epa_arc SET dma_id = 0 FROM t_pgr_go2epa_node n WHERE node_id =  node_1;
		UPDATE t_pgr_go2epa_arc SET dma_id = 0 FROM t_pgr_go2epa_node n WHERE node_id =  node_2;

	END IF;

	-- getting sys_fprocess to be executed
	v_querytext = 'select * from sys_fprocess where project_type in (lower('||quote_literal(v_project_type)||'), ''utils'') 
	and addparam is null and query_text is not null and function_name ilike ''%pg2epa_check%'' and active order by fid asc';

	-- loop for checks
	for v_rec in execute v_querytext		
	loop
		EXECUTE 'select gw_fct_check_fprocess($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
	    "form":{},"feature":{},"data":{"parameters":{"functionFid":'||v_fid||', "checkFid":"'||v_rec.fid||'"}}}$$)';
	end loop;


	-- remove disconnected network
	IF v_deldisconnetwork THEN
		
		UPDATE temp_t_arc a SET sector_id = sector_id FROM t_pgr_go2epa_arc t WHERE t.sector_id = 0 AND t.arc_id = a.arc_id;
		UPDATE temp_t_node a SET sector_id = sector_id FROM t_pgr_go2epa_node t WHERE t.sector_id = 0 AND t.arc_id = a.arc_id;
		DELETE FROM temp_t_arc WHERE sector_id = 0;
		DELETE FROM temp_t_node WHERE sector_id = 0;
		GET DIAGNOSTICS v_count = row_count;

		IF v_count > 0 THEN
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result, 2, 
			concat('WARNING-227: {delDisconnectNetwork} is enabled and ',v_count,' arcs have been removed.'));
		ELSE
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result, 1, 
			concat('INFO: {delDisconnectNetwork} is enabled but nothing have been removed.'));
		END IF;
	END IF;

	-- remove dry network
	IF v_deldrynetwork THEN

		UPDATE temp_t_arc a SET dma_id = dma_id FROM t_pgr_go2epa_arc t WHERE t.dma_id = 0 AND t.arc_id = a.arc_id;
		UPDATE temp_t_node a SET dma_id = dma_id FROM t_pgr_go2epa_node t WHERE t.dma_id = 0 AND t.arc_id = a.arc_id;
		DELETE FROM temp_t_arc WHERE dma_id = 0;
		DELETE FROM temp_t_node WHERE dma_id = 0;
		GET DIAGNOSTICS v_count = row_count;
		
		IF v_count > 0 THEN
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 2, 
			concat('WARNING-227: {delDryNetwork} is enabled and ',v_count,' arcs have been removed.'));
		ELSE
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, 
			concat('INFO: {delDryNetwork} is enabled but nothing have been removed.'));
		END IF;
	END IF;
	
	-- remove dry demands
	IF v_removedemands THEN
		UPDATE temp_t_node n SET demand = 0, addparam = gw_fct_json_object_set_key(a.addparam::json, 'removedDemand'::text, true::boolean) 
		FROM t_pgr_go2epa_node a WHERE a.node_id = n.node_id;
		GET DIAGNOSTICS v_count = row_count;
		
		IF v_count > 0 THEN
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result, 2, concat(
			'WARNING-227: {removeDemandsOnDryNetwork} is enabled and demand from ',v_count,' nodes have been removed'));
		ELSE
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message)
			VALUES (v_fid, v_result, 1, concat('INFO: {removeDemandsOnDryNetwork} is enabled but no dry nodes have been found.'));
		END IF;
		DELETE FROM temp_audit_check_data WHERE fid = 227 AND error_message like '%Dry node(s) with demand%' AND cur_user = current_user;
	END IF;
	

	RAISE NOTICE '7 - Stats';
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,concat(''));
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,concat('BASIC STATS'));
	INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,concat('-------------------'));
	
	IF v_project_type =  'WS' THEN

		SELECT sum(length)/1000 INTO v_sumlength FROM temp_t_arc;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Total length (Km) : ',v_sumlength,'.'));
	
		SELECT min(elevation), max(elevation) INTO v_min, v_max FROM temp_t_node;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(length), max(length) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'PIPE';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for pipe length. Minimun and maximum values are: (',v_min,' - ',v_max,' ).'));
		
		SELECT min(diameter), max(diameter) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'PIPE';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for pipe diameter. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(roughness), max(roughness) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'PIPE';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for pipe roughness. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		v_networkstats = gw_fct_json_object_set_key((select json_build_object('sector', array_agg(sector_id)) FROM selector_sector where cur_user=current_user and sector_id > 0)
		 ,'Total Length (Km)', v_sumlength);

	ELSIF v_project_type  ='UD' THEN

		SELECT sum(length)/1000 INTO v_sumlength FROM temp_t_arc;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Total length (Km) : ',coalesce(v_sumlength,0::numeric),'.'));
		
		IF v_linkoffsets  = 'ELEVATION' THEN
		
			UPDATE temp_t_arc SET length = null where length = 0;
		
			SELECT min(((elevmax1-elevmax2)/coalesce(length,0.1))::numeric(12,4)), max(((elevmax1-elevmax2)/coalesce(length,0.1)::numeric(12,4))) 
			INTO v_min, v_max FROM temp_t_arc;
			INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
			concat('Data analysis for conduit slope. Values from [',v_min,'] to [',v_max,'] have been found.'));
		END IF;
		
		SELECT min(length), max(length) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit length. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(n), max(n) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit manning roughness coeficient. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(elevmax1), max(elevmax1) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit z1. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(elevmax2), max(elevmax2) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit z2. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
	
		SELECT min(slope), max(slope) INTO v_min, v_max FROM temp_t_arc WHERE epa_type = 'CONDUIT';
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for conduit slope. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(elev), max(elev) INTO v_min, v_max FROM temp_t_node;
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, v_result_id, 0,
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));	

		v_networkstats = gw_fct_json_object_set_key((select json_build_object('sector', array_agg(sector_id)) FROM selector_sector where cur_user=current_user and sector_id > 0),
		'Total Length (Km)', v_sumlength);
	END IF;
	
	-- set rpt_cat_result table with network stats
	UPDATE rpt_cat_result SET network_stats = v_networkstats WHERE result_id = v_result_id;
	
	--  Return
	EXECUTE 'SELECT gw_fct_create_return($${"data":{"parameters":{"functionId":2680, "isEmbebed":true}}}$$::json)' INTO v_return;
	RETURN v_return;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
