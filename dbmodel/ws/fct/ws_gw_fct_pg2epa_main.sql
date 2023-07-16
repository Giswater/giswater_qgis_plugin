/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2646

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_main(p_data json)  
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"1"}}$$); -- PRE-PROCESS
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"2"}}$$); -- AUTOREPAIR
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"3"}}$$); -- CHECK DATA
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"4"}}$$); -- STRUCTURE DATA
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"5"}}$$); -- CHECK GRAPH
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"6"}}$$); -- BUILD INP 
SELECT SCHEMA_NAME.gw_fct_pg2epa_main($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test1", "step":"7"}}$$); -- POST-PROCESS

select * from temp_audit_check_data order by 1 asc


--fid: 227

*/

DECLARE	

v_networkmode integer = 1;
v_return json;
v_input json;
v_result text;
v_onlymandatory_nodarc boolean = false;
v_vnode_trimarcs boolean = false;
v_response integer;
v_message text;
v_setdemand boolean;
v_buildupmode integer;
v_inpoptions json;
v_advancedsettings boolean;
v_file json;
v_body json;
v_onlyexport boolean;
v_checkdata boolean;
v_checknetwork boolean;
v_vdefault boolean;
v_fid integer = 227;
v_error_context text;
v_breakpipes boolean;
v_count integer;
v_step integer=0;
v_autorepair boolean;
v_expl integer = null;
v_sector_0 boolean = false;
	
BEGIN

	-- set search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- get input data
	v_result = (p_data->>'data')::json->>'resultId';
	v_step = (p_data->>'data')::json->>'step';  -- use network previously defined
	v_input = concat('{"data":{"parameters":{"resultId":"',v_result,'", "fid":227}}}')::json;
		
	-- step 0 : preprocess
	IF v_step = 1 THEN

		-- check sector selector
		SELECT count(*) INTO v_count FROM selector_sector WHERE cur_user = current_user;
		IF v_count = 0 THEN
			RETURN ('{"status":"Failed","message":{"level":1, "text":"There is no sector selected. Please select at least one"}}')::json;
		END IF;		

		-- create temp tables
		CREATE TEMP TABLE temp_vnode(
		  id serial NOT NULL,
		  l1 integer,
		  v1 integer,
		  l2 integer,
		  v2 integer,
		  CONSTRAINT temp_vnode_pkey PRIMARY KEY (id));
	  
		CREATE TEMP TABLE temp_link(
		  link_id integer NOT NULL,
		  vnode_id integer,
		  vnode_type text,
		  feature_id character varying(16),
		  feature_type character varying(16),
		  exit_id character varying(16),
		  exit_type character varying(16),
		  state smallint,
		  expl_id integer,
		  sector_id integer,
		  dma_id integer,
		  exit_topelev double precision,
		  exit_elev double precision,
		  the_geom geometry(LineString,SRID_VALUE),
		  the_geom_endpoint geometry(Point,SRID_VALUE),
		  flag boolean,
		  CONSTRAINT temp_link_pkey PRIMARY KEY (link_id));
		
		CREATE TEMP TABLE temp_link_x_arc(
		  link_id integer NOT NULL,
		  vnode_id integer,
		  arc_id character varying(16),
		  feature_type character varying(16),
		  feature_id character varying(16),
		  node_1 character varying(16),
		  node_2 character varying(16),
		  vnode_distfromnode1 numeric(12,3),
		  vnode_distfromnode2 numeric(12,3),
		  exit_topelev double precision,
		  exit_ymax numeric(12,3),
		  exit_elev numeric(12,3),
		  CONSTRAINT temp_link_x_arc_pkey PRIMARY KEY (link_id));

		CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
		CREATE TEMP TABLE temp_audit_log_data (LIKE SCHEMA_NAME.audit_log_data INCLUDING ALL);
		CREATE TEMP TABLE temp_t_table (LIKE SCHEMA_NAME.temp_table INCLUDING ALL);
		CREATE TEMP TABLE temp_t_node (LIKE SCHEMA_NAME.temp_node INCLUDING ALL);
		CREATE TEMP TABLE temp_t_arc (LIKE SCHEMA_NAME.temp_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_t_demand (LIKE SCHEMA_NAME.temp_demand INCLUDING ALL);

		CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
		CREATE TEMP TABLE temp_anl_connec (LIKE SCHEMA_NAME.anl_connec INCLUDING ALL);

		CREATE TEMP TABLE temp_rpt_inp_node (LIKE SCHEMA_NAME.rpt_inp_node INCLUDING ALL);
		CREATE TEMP TABLE temp_rpt_inp_arc (LIKE SCHEMA_NAME.rpt_inp_arc INCLUDING ALL);
		CREATE TEMP TABLE temp_rpt_inp_pattern_value (LIKE SCHEMA_NAME.rpt_inp_pattern_value INCLUDING ALL);

		CREATE TEMP TABLE temp_t_go2epa (LIKE SCHEMA_NAME.temp_go2epa INCLUDING ALL);
		CREATE TEMP TABLE temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);

		-- setting selectors
		v_inpoptions = (SELECT (replace (replace (replace (array_to_json(array_agg(json_build_object((t.parameter),(t.value))))::text,'},{', ' , '),'[',''),']',''))::json 
			FROM (SELECT parameter, value FROM config_param_user 
			JOIN sys_param_user a ON a.id=parameter	WHERE cur_user=current_user AND formname='epaoptions')t);
	
		DELETE FROM rpt_cat_result WHERE result_id=v_result;
		INSERT INTO rpt_cat_result (result_id, inp_options, status, expl_id) VALUES (v_result, v_inpoptions, 1, v_expl);
		DELETE FROM rpt_inp_pattern_value WHERE result_id=v_result;	
		DELETE FROM selector_inp_result WHERE cur_user=current_user;
		INSERT INTO selector_inp_result (result_id, cur_user) VALUES (v_result, current_user);

		-- save previous values to set hydrometer selector
		DELETE FROM temp_table WHERE fid=435 AND cur_user=current_user;
		INSERT INTO temp_table (fid, text_column)
		SELECT 435, (array_agg(state_id)) FROM selector_hydrometer WHERE cur_user=current_user;

		-- reset selector
		INSERT INTO selector_hydrometer SELECT id, current_user FROM ext_rtc_hydrometer_state
		ON CONFLICT (state_id, cur_user) DO NOTHING;

		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 1/7-Preprocess workflow...... done succesfully"}}'::json;
		RETURN v_return;

	-- step 1 : autorepair epa-type
	ELSIF v_step = 2 THEN 

		PERFORM gw_fct_pg2epa_autorepair_epatype($${"client":{"device":4, "infoType":1, "lang":"ES"}}$$);
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 2/7-Autorepair epa_type...... done succesfully"}}'::json;
		RETURN v_return;

	-- step 2: check data
	ELSIF v_step = 3 THEN 

		PERFORM gw_fct_pg2epa_check_data(v_input);
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 3/7-Check data...... done succesfully"}}'::json;
		RETURN v_return;
	
	-- step 4: structure data
	ELSIF v_step = 4 THEN 
	
		-- get user parameteres
		v_networkmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_networkmode' AND cur_user=current_user);
		IF v_networkmode = 1 THEN v_onlymandatory_nodarc = TRUE; END IF;
		
		v_buildupmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_buildup_mode' AND cur_user=current_user);
		v_advancedsettings = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_advancedsettings' AND cur_user=current_user)::boolean;
		v_vdefault = (SELECT value::json->>'status' FROM config_param_user WHERE parameter='inp_options_vdefault' AND cur_user=current_user);
		IF (SELECT count(expl_id) FROM selector_expl WHERE cur_user = current_user) = 1 THEN
			v_expl = (SELECT expl_id FROM selector_expl WHERE cur_user = current_user);
		END IF;

		-- get debug parameters
		v_setdemand = (SELECT value::json->>'setDemand' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
		v_breakpipes = (SELECT (value::json->>'breakPipes')::json->>'status' FROM config_param_user WHERE parameter='inp_options_debug' AND cur_user=current_user)::boolean;
		
		RAISE NOTICE '4.1 - Fill temp tables';
		PERFORM gw_fct_pg2epa_fill_data(v_result);

		RAISE NOTICE '4.2 - Call gw_fct_pg2epa_nod2arc function';
		PERFORM gw_fct_pg2epa_nod2arc(v_result, v_onlymandatory_nodarc, false);

		RAISE NOTICE '4.3 - Call gw_fct_pg2epa_doublenod2arc';
		PERFORM gw_fct_pg2epa_nod2arc_double(v_result);
				
		RAISE NOTICE '4.4 - Call gw_fct_pg2epa_pump_additional function';
		PERFORM gw_fct_pg2epa_pump_additional(v_result);

		RAISE NOTICE '4.5 - manage varcs';
		PERFORM gw_fct_pg2epa_manage_varc(v_result);	

		RAISE NOTICE '4.6 - Trim arcs';
		IF v_networkmode IN (3,4) THEN
		
			IF v_breakpipes THEN
				PERFORM gw_fct_pg2epa_breakpipes(v_result);
			END IF;
			-- execute vnodetrim arcs
			SELECT gw_fct_pg2epa_vnodetrimarcs(v_result) INTO v_response;
		END IF;

		RAISE NOTICE '4.7 - Execute buildup model';
		IF v_buildupmode = 1 THEN
			PERFORM gw_fct_pg2epa_buildup_supply(v_result);
			
		ELSIF v_buildupmode = 2 THEN
			PERFORM gw_fct_pg2epa_buildup_transport(v_result);
		END IF;

		RAISE NOTICE '4.8 - Set default values';
		IF v_vdefault THEN
			PERFORM gw_fct_pg2epa_vdefault(v_input);
		END IF;

		RAISE NOTICE '4.9 - Set ceros';
		UPDATE temp_t_node SET elevation = 0 WHERE elevation IS NULL;
		UPDATE temp_t_node SET addparam = replace (addparam, '""','null');
		
		RAISE NOTICE '4.10 - Set length > 0.05 when length is 0';
		UPDATE temp_t_arc SET length=0.05 WHERE length=0;

		RAISE NOTICE '4.11 - Set demands & patterns';
		TRUNCATE temp_demand;
		IF v_setdemand THEN
			PERFORM gw_fct_pg2epa_demand(v_result);		
		END IF;

		RAISE NOTICE '4.12 - Setting valve status';
		PERFORM gw_fct_pg2epa_valve_status(v_result);

		
		RAISE NOTICE '4.13 - Profilactic last control';

		-- arcs without nodes
		UPDATE temp_t_arc t SET epa_type = 'TODELETE' FROM (SELECT a.id FROM temp_t_arc a LEFT JOIN temp_t_node ON node_1=node_id WHERE temp_t_node.node_id is null) a WHERE t.id = a.id;
		UPDATE temp_t_arc t SET epa_type = 'TODELETE' FROM (SELECT a.id FROM temp_t_arc a LEFT JOIN temp_t_node ON node_2=node_id WHERE temp_t_node.node_id is null) a WHERE t.id = a.id;

		INSERT INTO temp_audit_log_data (fid, feature_id, feature_type, log_message) 
		SELECT v_fid, arc_id, 'ARC', '23 - Profilactic last delete' FROM temp_t_arc WHERE epa_type  ='TODELETE';
		
		DELETE FROM temp_t_arc WHERE epa_type = 'TODELETE';

		-- nodes without arcs
		UPDATE temp_t_node t SET epa_type = 'TODELETE' FROM 
		(SELECT id FROM temp_t_node LEFT JOIN (SELECT node_1 as node_id FROM temp_t_arc UNION SELECT node_2 FROM temp_t_arc) a USING (node_id) WHERE a.node_id IS NULL) a 
		WHERE t.id = a.id;

		INSERT INTO temp_audit_log_data (fid, feature_id, feature_type, log_message) 
		SELECT v_fid, node_id, 'NODE', '23 - Profilactic last delete' FROM temp_t_node WHERE epa_type  ='TODELETE';
			
		DELETE FROM temp_t_node WHERE epa_type = 'TODELETE';
		
		-- update diameter when is null USING neighbourg from node_1
		UPDATE temp_t_arc SET diameter = dint FROM (
		SELECT node_1 as n1, diameter dint FROM temp_t_arc UNION SELECT node_2, diameter FROM temp_t_arc
		)t WHERE t.dint IS NOT NULL AND t.n1 = node_1 AND diameter IS NULL;
		UPDATE temp_t_arc SET diameter = dint FROM (
		SELECT node_1 as n1, diameter dint FROM temp_t_arc UNION SELECT node_2, diameter FROM temp_t_arc
		)t WHERE t.dint IS NOT NULL AND t.n1 = node_2 AND diameter IS NULL;

		-- update diameter when is null USING neighbourg from node_2
		UPDATE temp_t_arc SET diameter = dint FROM (
		SELECT node_1 as n2, diameter dint FROM temp_t_arc UNION SELECT node_2, diameter FROM temp_t_arc
		)t WHERE t.dint IS NOT NULL AND t.n2 = node_1 AND diameter IS NULL;
		UPDATE temp_t_arc SET diameter = dint FROM (
		SELECT node_2 as n2, diameter dint FROM temp_t_arc UNION SELECT node_2, diameter FROM temp_t_arc
		)t WHERE t.dint IS NOT NULL AND t.n2 = node_2 AND diameter IS NULL;

		-- other null values
		UPDATE temp_t_arc SET minorloss = 0 WHERE minorloss IS NULL;

		UPDATE temp_t_arc SET epa_type = 'VIRTUALVALVE' FROM arc WHERE arc.epa_type  ='VIRTUALVALVE' AND arc.arc_id = temp_t_arc.arc_id;

		-- for those elements like filter o flowmeter which they do not have the attribute on the inventory table
		UPDATE temp_t_arc SET status = 'OPEN' WHERE status IS NULL OR status = '';
		
		UPDATE temp_t_node SET dqa_id = 0 WHERE dqa_id IS NULL;
		UPDATE temp_t_arc SET dqa_id = 0 WHERE dqa_id IS NULL;
		
		UPDATE temp_t_node SET dma_id = 0 WHERE dma_id IS NULL;
		UPDATE temp_t_arc SET dma_id = 0 WHERE dma_id IS NULL;
		
		UPDATE temp_t_node SET presszone_id = 0 WHERE presszone_id IS NULL;
		UPDATE temp_t_arc SET presszone_id = 0 WHERE presszone_id IS NULL;

		-- remove pattern when breakPipes is enabled	
		IF v_breakpipes THEN
			UPDATE temp_t_node n SET pattern_id  = ';VNODE BRKPIPE' , demand = 0 FROM temp_table t WHERE n.node_id = concat('VN',t.id);				
		END IF;

		RAISE NOTICE '4.14 - Move from temp tables to rpt_inp tables';
		UPDATE temp_t_arc SET result_id  = v_result;
		UPDATE temp_t_node SET result_id  = v_result;
		INSERT INTO temp_rpt_inp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, 
		the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition,dma_id, presszone_id, dqa_id, minsector_id)
		SELECT result_id, node_id, elevation, case when elev is null then elevation else elev end, node_type, nodecat_id, epa_type, sector_id, state, 
		state_type, annotation, demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition,dma_id, presszone_id, dqa_id, minsector_id
		FROM temp_t_node;
		INSERT INTO temp_rpt_inp_arc 
		(result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, 
		the_geom, expl_id, flw_code, minorloss, addparam, arcparent,dma_id, presszone_id, dqa_id, minsector_id)
		SELECT result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, 
		status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent,dma_id, presszone_id, dqa_id, minsector_id
		FROM temp_t_arc;
		
		-- move patterns used
		INSERT INTO temp_rpt_inp_pattern_value (result_id, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18)
		SELECT  v_result, pattern_id, factor_1, factor_2, factor_3, factor_4, factor_5, factor_6, factor_7, factor_8, 
			factor_9, factor_10, factor_11, factor_12, factor_13, factor_14, factor_15, factor_16, factor_17, factor_18 
			from inp_pattern_value p 
			WHERE 
			pattern_id IN (SELECT distinct (pattern_id) FROM inp_dscenario_demand d, selector_inp_dscenario s WHERE cur_user = current_user AND d.dscenario_id = s.dscenario_id
						   AND pattern_id IS NOT NULL UNION SELECT distinct (pattern_id) FROM temp_t_node WHERE pattern_id IS NOT NULL)
			order by pattern_id, id;

		PERFORM gw_fct_pg2epa_dscenario(v_result);

		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 4/7-Structure data,scenario data and boundary conditions...... done succesfully"}}'::json;
		RETURN v_return;		
		
	-- step 5: analyze graph
	ELSIF v_step=5 THEN

		PERFORM gw_fct_pg2epa_check_network(v_input);	
		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 5/7-Graph analytics...... done succesfully"}}'::json;
		RETURN v_return;

	-- step 6: create json return
	ELSIF v_step=6 THEN

		TRUNCATE temp_node;
		TRUNCATE temp_arc;
	
		-- moving data from temporal tables
		INSERT INTO temp_node SELECT * FROM temp_t_node;
		INSERT INTO temp_arc SELECT * FROM temp_t_arc;
		INSERT INTO temp_demand SELECT * FROM temp_t_demand;
		INSERT INTO rpt_inp_pattern_value SELECT * FROM temp_rpt_inp_pattern_value;	

		SELECT gw_fct_pg2epa_check_result(v_input) INTO v_return ;
		SELECT gw_fct_pg2epa_export_inp(p_data) INTO v_file;
		v_body = gw_fct_json_object_set_key((v_return->>'body')::json, 'file', v_file);
		v_return = gw_fct_json_object_set_key(v_return, 'body', v_body);
		v_return = replace(v_return::text, '"message":{"level":1, "text":"Data quality analysis done succesfully"}', 
		'"message":{"level":1, "text":"Step export INP file 6/7-Writing the INP file...... done succesfully"}')::json;
		RETURN v_return;	

	-- step 7: post-proces
	ELSIF v_step=7 THEN
	
		-- move nodes data
		INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, 
		the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition,dma_id, presszone_id, dqa_id, minsector_id)
		SELECT result_id, node_id, elevation, case when elev is null then elevation else elev end, node_type, nodecat_id, epa_type, sector_id, state, 
		state_type, annotation, demand, the_geom, expl_id, pattern_id, addparam, nodeparent, arcposition,dma_id, presszone_id, dqa_id, minsector_id
		FROM temp_rpt_inp_node;
		
		-- move arcs data
		INSERT INTO rpt_inp_arc 
		(result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, 
		the_geom, expl_id, flw_code, minorloss, addparam, arcparent,dma_id, presszone_id, dqa_id, minsector_id)
		SELECT result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, 
		status, the_geom, expl_id, flw_code, minorloss, addparam, arcparent,dma_id, presszone_id, dqa_id, minsector_id
		FROM temp_rpt_inp_arc;

		-- restore hydrometer selector
		DELETE FROM selector_hydrometer WHERE cur_user = current_user;
		INSERT INTO selector_hydrometer (state_id, cur_user)
		select unnest(text_column::integer[]), current_user from temp_table where fid=435 and cur_user=current_user
		ON CONFLICT (state_id, cur_user) DO NOTHING;

		-- drop temp tables
		DROP TABLE IF EXISTS temp_vnode;
		DROP TABLE IF EXISTS temp_link;
		DROP TABLE IF EXISTS temp_link_x_arc;
		DROP TABLE IF EXISTS temp_audit_check_data;
		DROP TABLE IF EXISTS temp_audit_log_data;
		DROP TABLE IF EXISTS temp_t_table;
		DROP TABLE IF EXISTS temp_t_node;
		DROP TABLE IF EXISTS temp_t_arc;
		DROP TABLE IF EXISTS temp_t_demand;
		DROP TABLE IF EXISTS temp_anl_arc;
		DROP TABLE IF EXISTS temp_anl_node;
		DROP TABLE IF EXISTS temp_anl_connec;
		DROP TABLE IF EXISTS temp_rpt_inp_node;
		DROP TABLE IF EXISTS temp_rpt_inp_arc;
		DROP TABLE IF EXISTS temp_rpt_inp_pattern_value;
		DROP TABLE IF EXISTS temp_t_go2epa;
		DROP TABLE IF EXISTS temp_t_anlgraph;

		v_return = '{"status": "Accepted", "message":{"level":1, "text":"Export INP file 7/7-Postprocess workflow...... done succesfully"}}'::json;
		RETURN v_return;
	END IF;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;