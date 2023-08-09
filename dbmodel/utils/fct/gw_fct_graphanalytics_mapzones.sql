/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this have been received helpfull assistance from Enric Amat (FISERSA) and Claudia Dragoste (Aigües de Girona SA)

--FUNCTION CODE: 2710

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mapzones(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mapzones(p_data json)
RETURNS json AS
$BODY$

/*

------------
TO CONFIGURE
------------

set graph_delimiter field on node_type table (below an example). It's not mandatory but provides more consistency to the analyzed data

UPDATE node_type 
SET graph_delimiter='NONE';
SET graph_delimiter='SECTOR' WHERE type IN ('SOURCE','WATERWELL', 'ETAP' 'TANK');

UPDATE sector SET graphconfig='[{"nodeParent":"1", "toArc":[2,3,4]}, {"nodeParent":"5", "toArc":[6,7,8]}]';
UPDATE dma SET graphconfig='[{"nodeParent":"11", "toArc":[12,13,14]}, {"nodeParent":"5", "toArc":[16,17,18]}]';
UPDATE dqa SET graphconfig='[{"nodeParent":"21", "toArc":[22,23,24]}, {"nodeParent":"5", "toArc":[26,27,28]}]';
UPDATE cat_preszone SET graphconfig='[{"nodeParent":"31", "toArc":[32,33,34]}, {"nodeParent":"35", "toArc":[36,37,38]}]';

update arc set sector_id=0, dma_id=0, dqa_id=0, presszone_id=0;
update node set sector_id=0, dma_id=0, dqa_id=0,  presszone_id=0;
update connec set sector_id=0, dma_id=0, dqa_id=0, presszone_id=0


----------------
-- QUERY SAMPLE
SELECT gw_fct_graphanalytics_mapzones('{"data":{"parameters":{"graphClass":"DRAINZONE", "exploitation":[1], "macroExploitation":[1], "commitChanges":true, "updateMapZone":2, "geomParamUpdate":15, "usePlanPsector":false, "forceOpen":[1,2,3], "forceClosed":[2,3,4]}}}');

SELECT gw_fct_graphanalytics_mapzones('{"data":{"parameters":{"graphClass":"PRESSZONE", "exploitation":[1,2], "commitChanges":true, "updateMapZone":2, "geomParamUpdate":15, "usePlanPsector":false}}}');


SELECT SCHEMA_NAME.gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":5367}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"PRESSZONE", "exploitation":"1", "floodOnlyMapzone":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "valueForDisconnected":"0", "updateMapZone":"5", "geomParamUpdate":"100"}}}$$);

if exploitation not exists > macroexploitation

---------------------------------
TO CHECK PROBLEMS, RUN MODE DEBUG
---------------------------------

1) CONTEXT 
SET search_path='ws', public;
UPDATE arc SET dma_id=0 where expl_id IN (1,2)


2) RUN
SELECT gw_fct_graphanalytics_mapzones('{"data":{"parameters":{"graphClass":"DQA", "exploitation": "[1]",  "updateMapZone":2,""geomParamUpdate":15}}}');
SELECT SCHEMA_NAME.gw_fct_graphanalytics_mapzones($${"data":{"parameters":{"graphClass":"DMA", "exploitation": "[1]","updateMapZone":2,"geomParamUpdate":15, "valueForDisconnected":"9"}}}$$);

INSTRUCTIONS
flag: 0 open, 1 closed
water: 0 dry, 1 wet

3) ANALYZE: 

Look graph flooders (flag=0 and graphdelimiter node)
SELECT node_1 AS node_id, arc_id AS to_arc FROM temp_anlgraph WHERE flag=0 AND node_1 IN (
SELECT DISTINCT node_id::integer FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN temp_anlgraph e ON a.node_id::integer=e.node_1::integer WHERE graph_delimiter IN ('DQA', 'SECTOR'))

SELECT node_1 AS node_id, arc_id AS to_arc FROM temp_anlgraph WHERE flag=0 AND node_1 IN (
SELECT DISTINCT node_id::integer FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN temp_anlgraph e ON a.node_id::integer=e.node_1::integer WHERE graph_delimiter IN ('DMA', 'SECTOR'))

Look for the graph stoppers (flag=1)
SELECT arc_id, node_1 FROM temp_anlgraph where flag=1 order by node_1

-- fid: 147, 125, 146, 145, 144, 130

*/

DECLARE

v_affectrow numeric;
v_cont1 integer default 0;
v_class text;
v_feature record;
v_expl_json json;
v_expl_id integer;
v_macroexpl json;
v_data json;
v_fid integer;
v_featureid integer;
v_text text;
v_querytext text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count integer = 0;
v_version text;
v_table text;
v_field text;
v_fieldmp text;
v_srid integer;
v_input json;
v_count1 integer;
v_count2 integer;
v_count3 integer;
v_geomparamupdate float;
v_updatemapzgeom integer = 0;
v_geomparamupdate_divide float;
v_visible_layer text;
v_concavehull float = 0.9;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_checkdata text;  -- FULL / PARTIAL / NONE
v_mapzonename text;
v_parameters json;
v_usepsector boolean;
v_error boolean = false;
v_nodemapzone text;
rec_conflict record;
v_valuefordisconnected integer;
v_floodonlymapzone text;
v_islastupdate boolean;
v_commitchanges boolean;
v_project_type text;
v_psectors_query_arc text;
v_psectors_query_node text;
v_psectors_query_connec text;
v_psectors_query_gully text;
v_query_arc text;
v_query_node text;
v_query_connec text;
v_query_gully text;
v_query_link text;
v_dscenario_valve text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select system values
	SELECT giswater, epsg, upper(project_type) INTO v_version, v_srid, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT value::boolean INTO v_islastupdate FROM config_param_system WHERE parameter='edit_mapzones_set_lastupdate';

	-- get dialog variables
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'graphClass');
	v_expl_json = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_expl_id = json_array_elements_text(v_expl_json);
	v_macroexpl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'macroExploitation');
	v_floodonlymapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodOnlyMapzone');
	v_valuefordisconnected = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'valueForDisconnected');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_parameters = (SELECT ((p_data::json->>'data')::json->>'parameters'));
	v_commitchanges = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'commitChanges');
	v_checkdata = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'checkData');
	v_dscenario_valve = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'dscenario_valve');

	-- profilactic controls
	IF v_dscenario_valve = '' THEN v_dscenario_valve = NULL; END IF;
	IF v_floodonlymapzone = '' THEN v_floodonlymapzone = NULL; END IF;
	v_floodonlymapzone = REPLACE(REPLACE (v_floodonlymapzone,'[','') ,']','');

	-- set fid:
	IF v_class = 'PRESSZONE' THEN 
		v_fid=146;
		v_table = 'presszone';
		v_field = 'presszone_id';
		v_fieldmp = 'presszone_id';
		v_visible_layer ='v_edit_presszone';
		v_mapzonename = 'name';
			
	ELSIF v_class = 'DMA' THEN 
		v_fid=145;
		v_table = 'dma';
		v_field = 'dma_id';
		v_fieldmp = 'dma_id';
		v_visible_layer ='v_edit_dma';
		v_mapzonename = 'name';
			
	ELSIF v_class = 'DQA' THEN 
		v_fid=144;
		v_table = 'dqa';
		v_field = 'dqa_id';
		v_fieldmp = 'dqa_id';
		v_visible_layer ='v_edit_dqa';
		v_mapzonename = 'name';
			
	ELSIF v_class = 'SECTOR' THEN 
		v_fid=130;
		v_table = 'sector';
		v_field = 'sector_id';
		v_fieldmp = 'sector_id';
		v_visible_layer ='v_edit_sector';
		v_mapzonename = 'name';
		
	ELSIF v_class = 'DRAINZONE' THEN 
		v_fid=481;
		v_table = 'drainzone';
		v_field = 'drainzone_id';
		v_fieldmp = 'drainzone_id';
		v_visible_layer ='v_edit_drainzone';
		v_mapzonename = 'name';	
	ELSE	
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3090", "function":"2710","debug_msg":null, "is_process":true}}$$);'  INTO v_audit_result;
	END IF;

		
	---create temp tables necessaries for quality check
	CREATE TEMP TABLE temp_audit_check_data (LIKE SCHEMA_NAME.audit_check_data INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_arc (LIKE SCHEMA_NAME.anl_arc INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_node (LIKE SCHEMA_NAME.anl_node INCLUDING ALL);
	CREATE TEMP TABLE temp_anl_connec (LIKE SCHEMA_NAME.anl_connec INCLUDING ALL);

	-- data quality analysis
	IF v_checkdata = 'FULL' THEN
	
		-- om data quality analysis
		v_input = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{ "fid":',v_fid,',"parameters":{"selectionMode":"userSelectors"}}}')::json;
		PERFORM gw_fct_om_check_data(v_input);
		SELECT count(*) INTO v_count1 FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND criticity=3 AND result_id IS NOT NULL;

		DELETE FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND error_message ='' AND criticity=1;

		-- graph quality analysis
		v_input = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{ "fid":',v_fid,',"selectionMode":"userSelectors", "graphClass":',quote_ident(v_class),'}}}')::json;
		PERFORM gw_fct_graphanalytics_check_data(v_input);
		SELECT count(*) INTO v_count2 FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND criticity=3 AND result_id IS NOT NULL;

		DELETE FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND result_id IS NULL;

	ELSIF v_checkdata = 'PARTIAL' THEN

		-- graph quality analysis
		v_input = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{ "fid":',v_fid,',"selectionMode":"userSelectors", "graphClass":',quote_ident(v_class),'}}}')::json;
		PERFORM gw_fct_graphanalytics_check_data(v_input);
		SELECT count(*) INTO v_count2 FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND criticity=3 AND result_id IS NOT NULL;

	ELSE
		IF v_class != 'DRAINZONE' THEN
			IF (SELECT count(*) FROM config_graph_valve WHERE active is TRUE) < 1 THEN
				DELETE FROM temp_audit_check_data WHERE fid = v_fid and cur_user = current_user;
				INSERT INTO temp_audit_check_data (error_message, fid, cur_user, criticity) VALUES ('ERROR: config_graph_valve table is not configured', v_fid, current_user, 3);
				v_count1 = 1;
			END IF;
		END IF;
	END IF;

	v_count = coalesce(v_count1,0) + coalesce(v_count2,0);

	-- check criticity of data in order to continue or not
	IF v_count > 0 THEN
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid=v_fid AND criticity > 1 order by criticity desc, id asc) row;

		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		
		--  Return
		RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Mapzones dynamic analysis canceled. Data is not ready to work with"}, "version":"'||v_version||'"'||
		',"body":{"form":{}, "data":{ "info":'||v_result_info||'}}}')::json;	

	END IF;

	
	IF v_audit_result IS NOT NULL OR (SELECT (value::json->>(v_class))::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status') IS FALSE THEN
			
		INSERT INTO temp_audit_check_data (fid, criticity, error_message)
		VALUES (v_fid, 3, concat('ERROR-',v_fid,': Dynamic analysis for ',v_class,'''s is not configured on database. Please update system variable ''utils_graphanalytics_status'' to enable it '));
	ELSE	
		--create temporal tables

		CREATE TEMP TABLE temp_t_anlgraph (LIKE SCHEMA_NAME.temp_anlgraph INCLUDING ALL);
		CREATE TEMP TABLE temp_t_data (LIKE SCHEMA_NAME.temp_data INCLUDING ALL);
		CREATE TEMP TABLE temp_t_arc (LIKE SCHEMA_NAME.arc INCLUDING ALL);
		CREATE TEMP TABLE temp_t_node (LIKE SCHEMA_NAME.node INCLUDING ALL);
		CREATE TEMP TABLE temp_t_connec (LIKE SCHEMA_NAME.connec INCLUDING ALL);
		CREATE TEMP TABLE temp_t_link (LIKE SCHEMA_NAME.link INCLUDING ALL);

		IF v_project_type = 'UD' THEN
			CREATE TEMP TABLE temp_t_gully (LIKE SCHEMA_NAME.gully INCLUDING ALL);
			CREATE TEMP TABLE temp_drainzone (LIKE SCHEMA_NAME.drainzone INCLUDING ALL);
		ELSE
			CREATE TEMP TABLE temp_om_waterbalance_dma_graph (LIKE SCHEMA_NAME.om_waterbalance_dma_graph INCLUDING ALL);
			CREATE TEMP TABLE temp_sector (LIKE SCHEMA_NAME.sector INCLUDING ALL);
			CREATE TEMP TABLE temp_dma (LIKE SCHEMA_NAME.dma INCLUDING ALL);
			CREATE TEMP TABLE temp_presszone (LIKE SCHEMA_NAME.presszone INCLUDING ALL);
			CREATE TEMP TABLE temp_dqa (LIKE SCHEMA_NAME.dqa INCLUDING ALL);
		END IF;

		--create temporal view
		CREATE OR REPLACE TEMP VIEW v_temp_anlgraph AS
		 SELECT temp_t_anlgraph.arc_id,
		    temp_t_anlgraph.node_1,
		    temp_t_anlgraph.node_2,
		    temp_t_anlgraph.flag,
		    a2.flag AS flagi,
		    a2.value,
		    a2.trace
		   FROM temp_t_anlgraph
		     JOIN ( SELECT temp_t_anlgraph_1.arc_id,
			    temp_t_anlgraph_1.node_1,
			    temp_t_anlgraph_1.node_2,
			    temp_t_anlgraph_1.water,
			    temp_t_anlgraph_1.flag,
			    temp_t_anlgraph_1.checkf,
			    temp_t_anlgraph_1.value,
			    temp_t_anlgraph_1.trace
			   FROM temp_t_anlgraph temp_t_anlgraph_1
			  WHERE temp_t_anlgraph_1.water = 1) a2 ON temp_t_anlgraph.node_1::text = a2.node_2::text
			  WHERE temp_t_anlgraph.flag < 2 AND temp_t_anlgraph.water = 0 AND a2.flag = 0;
			
		IF v_usepsector IS  TRUE THEN
			v_psectors_query_arc = ' AND a.arc_id NOT IN (SELECT arc_id FROM v_plan_psector_arc WHERE plan_state = 0) OR a.arc_id IN (SELECT arc_id FROM v_plan_psector_arc WHERE plan_state = 1)';
			v_psectors_query_node = 'AND n.node_id NOT IN (SELECT node_id FROM v_plan_psector_node WHERE plan_state = 0) OR n.node_id IN (SELECT node_id FROM v_plan_psector_node WHERE plan_state = 1)';
			v_psectors_query_connec = 'AND c.connec_id NOT IN (SELECT connec_id FROM v_plan_psector_connec WHERE plan_state = 0) OR c.connec_id IN (SELECT connec_id FROM v_plan_psector_connec WHERE plan_state = 1)';
			IF v_project_type='UD' THEN
				v_psectors_query_gully = 'AND g.gully_id NOT IN (SELECT gully_id FROM v_plan_psector_gully WHERE plan_state = 0) OR g.gully_id IN (SELECT gully_id FROM v_plan_psector_gully WHERE plan_state = 1)';
			END IF;
		ELSE
			v_psectors_query_arc='';
			v_psectors_query_node='';
			v_psectors_query_connec='';
			v_psectors_query_gully='';
		END IF;

		-- reset rtc_scada_x_dma or rtc_scada_x_dma
		IF v_class = 'DMA' THEN

			INSERT INTO temp_om_waterbalance_dma_graph SELECT * FROM om_waterbalance_dma_graph;
			EXECUTE 'DELETE FROM temp_om_waterbalance_dma_graph
			WHERE node_id IN 
			(SELECT node_id FROM temp_om_waterbalance_dma_graph
			JOIN node n USING (node_id)
			WHERE n.expl_id = '||v_expl_id||' '||v_psectors_query_node||');';
		END IF;

		-- start build log message
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('MAPZONES DYNAMIC SECTORITZATION - ', upper(v_class)));
		IF upper(v_class) ='PRESSZONE' THEN
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('------------------------------------------------------------------'));
		ELSE
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('----------------------------------------------------------'));
		END IF;
		
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Use psectors: ', upper(v_usepsector::text)));
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Mapzone constructor method: ', upper(v_updatemapzgeom::text)));
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Update feature mapzone attributes: ', upper(v_commitchanges::text)));
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Previous data quality control: ', v_checkdata));
		
		IF v_floodonlymapzone IS NOT NULL THEN
			INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat('Flood only mapzone have been ACTIVATED, ',v_field, ':',v_floodonlymapzone,'.'));
		END IF;	
		
		INSERT INTO temp_audit_check_data (fid, error_message) VALUES (v_fid, concat(''));
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '-----------');
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, 'DETAILS');
		INSERT INTO temp_audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 0, '----------');

		-- message for updatefeature false
		IF v_commitchanges IS FALSE THEN 
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, concat('INFO: Mapzone attribute on arc/node/connec features keeps same value previous function. Nothing have been updated by this process'));
		END IF;

		-- fill temporal tables
        IF v_usepsector IS  TRUE THEN
			v_query_arc = 'SELECT a.* FROM arc a JOIN v_edit_arc USING (arc_id) WHERE a.expl_id='||v_expl_id;
			v_query_node = 'SELECT n.* FROM node n JOIN v_edit_node USING (node_id) WHERE n.expl_id='||v_expl_id;
			v_query_connec = 'SELECT c.* FROM connec c JOIN v_edit_connec USING (connec_id) WHERE c.expl_id='||v_expl_id;
			v_query_link = 'SELECT l.* FROM link l JOIN v_edit_link USING (link_id) WHERE l.expl_id='||v_expl_id;
			IF v_project_type='UD' THEN
				v_query_gully = 'SELECT g.* FROM gully g JOIN v_edit_gully USING (gully_id) WHERE g.expl_id='||v_expl_id;
			END IF;
		ELSE
			v_query_arc = 'SELECT * FROM arc WHERE state=1 AND expl_id='||v_expl_id;
			v_query_node = 'SELECT * FROM node WHERE state=1 AND expl_id='||v_expl_id;
			v_query_connec = 'SELECT * FROM connec WHERE state=1 AND expl_id='||v_expl_id;
			v_query_link = 'SELECT * FROM link WHERE state=1 AND expl_id='||v_expl_id;
			IF v_project_type='UD' THEN
				v_query_gully = 'SELECT * FROM gully WHERE expl_id='||v_expl_id;
			END IF;
		END IF;
        
		EXECUTE 'INSERT INTO temp_t_arc '||v_query_arc;

		EXECUTE 'INSERT INTO temp_t_node '||v_query_node;

		EXECUTE 'INSERT INTO temp_t_connec '||v_query_connec;

		EXECUTE 'INSERT INTO temp_t_link '||v_query_link;

		IF v_project_type = 'UD' THEN
			EXECUTE 'INSERT INTO temp_t_gully '||v_query_gully;
		END IF;
	
		-- update temp_t_connec in order to get correct arc_id (for planified features, arc_id from parent layer is NULL)
		UPDATE temp_t_connec t SET arc_id=c.arc_id FROM v_edit_connec c WHERE t.connec_id=c.connec_id;

		IF v_class = 'SECTOR' THEN
			EXECUTE 'INSERT INTO temp_'||v_table||' SELECT * FROM '||v_table||' WHERE active is true AND sector_id IN (SELECT distinct '||v_field||' FROM temp_t_arc)';
		ELSE 
			EXECUTE 'INSERT INTO temp_'||v_table||' SELECT * FROM '||v_table||' WHERE active is true AND expl_id = '||v_expl_id;
		END IF;

		EXECUTE 'UPDATE temp_'||v_table||' SET the_geom = null';
			
		-- reset elements to 0
		IF v_floodonlymapzone IS NULL THEN
			v_querytext = 'UPDATE temp_t_arc a SET '||quote_ident(v_field)||' = 0 WHERE a.expl_id = '||v_expl_id||'';
			EXECUTE v_querytext;
			v_querytext = 'UPDATE temp_t_node a SET '||quote_ident(v_field)||' = 0 WHERE a.expl_id = '||v_expl_id||'';
			EXECUTE v_querytext;
			v_querytext = 'UPDATE temp_t_connec a SET '||quote_ident(v_field)||' = 0 WHERE a.expl_id = '||v_expl_id||'';
			EXECUTE v_querytext;

			IF v_project_type='UD' THEN
				v_querytext = 'UPDATE temp_t_gully a SET '||quote_ident(v_field)||' = 0 WHERE a.expl_id = '||v_expl_id||'';
				EXECUTE v_querytext;
			END IF;	
		ELSE
			v_querytext = 'UPDATE temp_t_arc SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||'::integer IN ('||v_floodonlymapzone||')';
			EXECUTE v_querytext;
			v_querytext = 'UPDATE temp_t_node SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||'::integer IN ('||v_floodonlymapzone||')';
			EXECUTE v_querytext;
			v_querytext = 'UPDATE temp_t_connec SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||'::integer IN ('||v_floodonlymapzone||')';
			EXECUTE v_querytext;

			IF v_project_type='UD' THEN
				v_querytext = 'UPDATE temp_t_gully SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||'::integer IN ('||v_floodonlymapzone||')';
				EXECUTE v_querytext;
			END IF;		
		END IF;

		-- fill the graph table
		IF v_class = 'DRAINZONE' THEN
			EXECUTE 'INSERT INTO temp_t_anlgraph (arc_id, node_1, node_2, water, flag, checkf)
			SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0 FROM temp_t_arc a JOIN value_state_type ON state_type=id 
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND value_state_type.is_operative=TRUE AND a.state = 1 and expl_id='||v_expl_id||' '||v_psectors_query_arc||';';
		ELSE
			EXECUTE 'INSERT INTO temp_t_anlgraph (arc_id, node_1, node_2, water, flag, checkf)
			SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0 FROM temp_t_arc a JOIN value_state_type ON state_type=id 
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND value_state_type.is_operative=TRUE AND a.state = 1  and expl_id='||v_expl_id||' '||v_psectors_query_arc||'
			UNION
			SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0 FROM temp_t_arc a JOIN value_state_type ON state_type=id 
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND value_state_type.is_operative=TRUE AND a.state = 1  and expl_id='||v_expl_id||' '||v_psectors_query_arc||';';
		END IF;

		-- close custom nodes acording config parameters
		EXECUTE 'UPDATE temp_t_anlgraph SET flag = 1 WHERE node_1 IN (SELECT json_array_elements_text((graphconfig->>''forceClosed'')::json) FROM '
		||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';
		EXECUTE 'UPDATE temp_t_anlgraph SET flag = 1 WHERE node_2 IN (SELECT json_array_elements_text((graphconfig->>''forceClosed'')::json) FROM '
		||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';

		-- set header node for mapzones
		v_text = 'SELECT node_id::integer  FROM( SELECT ((json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'') as node_id 
		FROM '||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)a WHERE node_id ~ ''^[0-9]+$''';

		-- close boundary conditions acording config_graph_valve (flag=1)
		IF v_class !='DRAINZONE' THEN
			v_querytext  = 'UPDATE temp_t_anlgraph SET flag=1 WHERE 
				node_1::integer IN (
				SELECT a.node_id::integer FROM temp_t_node a JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
				LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer 
				JOIN temp_t_anlgraph e ON a.node_id::integer=e.node_1::integer 
				JOIN config_graph_valve v ON v.id = c.id
				WHERE closed=TRUE
				AND v.active IS TRUE)';
			EXECUTE v_querytext;

			v_querytext  = 'UPDATE temp_t_anlgraph SET flag=1 WHERE 
				node_2::integer IN (
				SELECT (a.node_id::integer) FROM temp_t_node a JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
				LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer 
				JOIN temp_t_anlgraph e ON a.node_id::integer=e.node_1::integer 
				JOIN config_graph_valve v ON v.id = c.id
				WHERE closed=TRUE
				AND v.active IS TRUE)';
			EXECUTE v_querytext;

			IF v_dscenario_valve IS NOT NULL THEN
			--close valve
			raise notice 'v_dd';
				v_querytext  = 'UPDATE temp_t_anlgraph SET flag=1 WHERE 
				node_1::integer IN (
				SELECT a.node_id::integer 
				FROM temp_t_node a 
				JOIN inp_dscenario_shortpipe s ON a.node_id = s.node_id
				WHERE status=''CLOSED''
				AND dscenario_id = '||v_dscenario_valve||'::integer)';
			EXECUTE v_querytext;

			v_querytext  = 'UPDATE temp_t_anlgraph SET flag=1 WHERE 
				node_2::integer IN (
				SELECT a.node_id::integer 
				FROM temp_t_node a 
				JOIN inp_dscenario_shortpipe s ON a.node_id = s.node_id
				WHERE status=''CLOSED''
				AND dscenario_id = '||v_dscenario_valve||'::integer)';
			EXECUTE v_querytext;
			
			--òpen valve
			v_querytext  = 'UPDATE temp_t_anlgraph SET flag=0 WHERE 
				node_1::integer IN (
				SELECT a.node_id::integer 
				FROM temp_t_node a 
				JOIN inp_dscenario_shortpipe s ON a.node_id = s.node_id
				WHERE status=''OPEN''
				AND dscenario_id = '||v_dscenario_valve||'::integer)';
			EXECUTE v_querytext;

			v_querytext  = 'UPDATE temp_t_anlgraph SET flag=0 WHERE 
				node_2::integer IN (
				SELECT a.node_id::integer 
				FROM temp_t_node a 
				JOIN inp_dscenario_shortpipe s ON a.node_id = s.node_id
				WHERE status=''OPEN''
				AND dscenario_id = '||v_dscenario_valve||'::integer)';
			EXECUTE v_querytext;
			END IF;
		END IF;

		-- open custom nodes acording config parameters
		EXECUTE 'UPDATE temp_t_anlgraph SET flag = 0 WHERE node_1 IN (SELECT json_array_elements_text((graphconfig->>''forceOpen'')::json) FROM '
		||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';
		EXECUTE 'UPDATE temp_t_anlgraph SET flag = 0 WHERE node_2 IN (SELECT json_array_elements_text((graphconfig->>''forceOpen'')::json) FROM '
		||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';
    
		-- close customized stoppers acording on graphconfig column on mapzone table
		EXECUTE 'UPDATE temp_t_anlgraph SET flag = 1 WHERE node_1 IN (SELECT (json_array_elements_text((graphconfig->>''stopper'')::json)) as node_id FROM '||quote_ident(v_table)||')';
		EXECUTE 'UPDATE temp_t_anlgraph SET flag = 1 WHERE node_2 IN (SELECT (json_array_elements_text((graphconfig->>''stopper'')::json)) as node_id FROM '||quote_ident(v_table)||')';

		-- close checkvalves on the opposite sense where they are working
		IF v_class !='DRAINZONE' THEN
			UPDATE temp_t_anlgraph SET flag=1 WHERE id IN (
			SELECT id FROM temp_t_anlgraph JOIN (
			SELECT node_id, to_arc from config_graph_checkvalve order by 1,2) a 
			ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_2::integer);
		END IF;

		-- close custom nodes acording init parameters
		UPDATE temp_t_anlgraph SET flag = 1 WHERE node_1 IN (SELECT json_array_elements_text((v_parameters->>'forceClosed')::json));
		UPDATE temp_t_anlgraph SET flag = 1 WHERE node_2 IN (SELECT json_array_elements_text((v_parameters->>'forceClosed')::json));
		
		-- open custom nodes acording init parameters
		UPDATE temp_t_anlgraph SET flag = 0 WHERE node_1 IN (SELECT json_array_elements_text((v_parameters->>'forceOpen')::json));
		UPDATE temp_t_anlgraph SET flag = 0 WHERE node_2 IN (SELECT json_array_elements_text((v_parameters->>'forceOpen')::json));
		
		-- Close mapzone headers
		v_querytext  = 'UPDATE temp_t_anlgraph SET flag=1 WHERE node_1::integer IN ('||v_text||')';
		EXECUTE v_querytext;
		v_querytext  = 'UPDATE temp_t_anlgraph SET flag=1 WHERE node_2::integer IN ('||v_text||')';
		EXECUTE v_querytext;

		--moved after Close mapzone headers
		v_text =  concat ('SELECT * FROM (',v_text,')a JOIN temp_t_anlgraph e ON a.node_id::integer=e.node_1::integer');

		-- Open mapzone headers BUT ONLY ENABLING the right sense (to_arc)			
		IF v_class = 'SECTOR' THEN
			-- sector (sector.graphconfig)
			UPDATE temp_t_anlgraph SET flag=0, isheader = true WHERE id IN (
			SELECT id FROM temp_t_anlgraph JOIN (
			SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
			json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
			as to_arc from sector 
			where graphconfig is not null and active is true order by 1,2) a 
			ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);
		
		ELSIF v_class = 'DMA' THEN
			-- dma (dma.graphconfig)
			UPDATE temp_t_anlgraph SET flag=0, isheader = true WHERE id IN (
			SELECT id FROM temp_t_anlgraph JOIN (
			SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
			json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
			as to_arc from dma 
			where graphconfig is not null and active is true order by 1,2) a
			ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);

		ELSIF v_class = 'DQA' THEN
			-- dqa (dqa.graphconfig)
			UPDATE temp_t_anlgraph SET flag=0, isheader = true WHERE id IN (
			SELECT id FROM temp_t_anlgraph JOIN (
			SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
			json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
			as to_arc from dqa  
			where graphconfig is not null and active is true order by 1,2) a
			ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);

		ELSIF v_class = 'PRESSZONE' THEN
			-- presszone (presszone.graphconfig)
			UPDATE temp_t_anlgraph SET flag=0, isheader = true WHERE id IN (
			SELECT id FROM temp_t_anlgraph JOIN (
			SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
			json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
			as to_arc from presszone
			where graphconfig is not null and active is true order by 1,2) a
			ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);		
		END IF;

		IF v_class != 'DRAINZONE' THEN
		
			-- set the starting element (water)
			IF v_floodonlymapzone IS NULL THEN
				v_querytext = 'UPDATE temp_t_anlgraph SET water=1, trace = '||v_fieldmp||'::integer 
				FROM '||v_table||' WHERE graphconfig is not null and active is true AND flag=0 
				AND node_1 IN (SELECT (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' as node_id)';
				EXECUTE v_querytext;
			ELSE
				v_querytext = 'UPDATE temp_t_anlgraph SET water=1, trace = '||v_fieldmp||'::integer 
				FROM '||v_table||' WHERE graphconfig is not null and active is true AND '||v_fieldmp||'::integer IN ('||v_floodonlymapzone||') AND flag=0 
				AND node_1 IN (SELECT (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' as node_id)';
				EXECUTE v_querytext;
			END IF;
		ELSE 
			v_querytext = 'UPDATE temp_t_anlgraph SET water=1, flag=0, trace = '||v_fieldmp||'::integer 
			FROM '||v_table||' WHERE graphconfig is not null and active is true
			AND node_1 IN (SELECT (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' as node_id)';
			EXECUTE v_querytext;

		END IF;	

		-- inundation process
		LOOP						
			v_count = v_count+1;
			UPDATE temp_t_anlgraph n SET water=1, trace = a.trace FROM v_temp_anlgraph a where n.node_1::integer = a.node_1::integer AND n.arc_id = a.arc_id;	
			GET DIAGNOSTICS v_affectrow = row_count;
			raise notice 'v_count --> %' , v_count;
			EXIT WHEN v_affectrow = 0;
			EXIT WHEN v_count = 5000;
		END LOOP;

		RAISE NOTICE 'Finish engine....';

		RAISE NOTICE ' Update temporal table of arcs';
		v_querytext = 'UPDATE temp_t_arc SET '||quote_ident(v_field)||' = trace FROM temp_t_anlgraph t WHERE temp_t_arc.arc_id = t.arc_id AND water = 1 AND trace is not null';
		EXECUTE v_querytext;

		RAISE NOTICE ' Update temporal table of nodes';
		-- update disconnected nodes from parent arcs
		v_querytext = 'UPDATE temp_t_node SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM temp_t_arc a WHERE a.arc_id=temp_t_node.arc_id';
		EXECUTE v_querytext;

		-- update whole nodes
		EXECUTE 'UPDATE temp_t_node SET '||quote_ident(v_field)||' = trace FROM (
		SELECT distinct on(node) node, trace FROM(
		select node, count(*) c, trace FROM(
		select id, node, arc_id, trace, flag from(
		select id, node_1 node, arc_id, trace, flag from temp_t_anlgraph where trace > 0 and flag = 0
		union all
		select id, node_2, arc_id, trace, flag from temp_t_anlgraph where trace > 0 and flag = 0)a
		order by node
		)b group by node, trace order by 1, 2 desc
		)c order by node, c desc)a
		WHERE node = node_id';
		
		RAISE NOTICE ' Update temporal tables of connecs, links and gullies';
		-- used connec using v_edit_arc because the exploitation filter (same before)
		v_querytext = 'UPDATE temp_t_connec SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM temp_t_arc a WHERE a.arc_id=temp_t_connec.arc_id';
		EXECUTE v_querytext;

		v_querytext = 'UPDATE temp_t_connec a SET '||quote_ident(v_field)||' = 0 WHERE connec_id IN (SELECT connec_id FROM v_plan_psector_connec WHERE plan_state = 0)';
		EXECUTE v_querytext;

		IF v_project_type='WS' THEN
			v_querytext = 'UPDATE temp_t_link SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM temp_t_connec a WHERE a.connec_id=temp_t_link.feature_id';
			EXECUTE v_querytext;

		ELSIF v_project_type='UD' THEN
			v_querytext = 'UPDATE temp_t_gully SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM temp_t_arc a WHERE a.arc_id=temp_t_gully.arc_id';
			EXECUTE v_querytext;
		END IF;	

		IF v_islastupdate IS TRUE THEN
		
			v_querytext = 'UPDATE temp_t_arc SET lastupdate = now(), lastupdate_user=current_user FROM temp_t_anlgraph t WHERE temp_t_arc.arc_id = t.arc_id AND water = 1';
			EXECUTE v_querytext;

			v_querytext = 'UPDATE temp_t_node SET lastupdate = now(), lastupdate_user=current_user FROM temp_t_arc a WHERE a.arc_id=temp_t_node.arc_id';
			EXECUTE v_querytext;

			EXECUTE 'UPDATE temp_t_node SET lastupdate = now(), lastupdate_user=current_user  FROM (
			SELECT distinct on(node) node, trace FROM(

			select node, count(*) c, trace FROM(
			select id, node, arc_id, trace, flag from(
			select id, node_1 node, arc_id, trace, flag from temp_t_anlgraph where trace > 0 and flag = 0
			union all
			select id, node_2, arc_id, trace, flag from temp_t_anlgraph where trace > 0 and flag = 0)a
			order by node
			)b group by node, trace order by 1, 2 desc
			
			)c order by node, c desc)a
			WHERE node = node_id';

			v_querytext = 'UPDATE temp_t_connec SET lastupdate = now(), lastupdate_user=current_user FROM temp_t_arc a WHERE a.arc_id=temp_t_connec.arc_id';
			EXECUTE v_querytext;

			IF v_project_type='UD' THEN
				v_querytext = 'UPDATE temp_t_gully SET lastupdate = now(), lastupdate_user=current_user FROM temp_t_arc a WHERE a.arc_id=temp_t_gully.arc_id';
				EXECUTE v_querytext;
			END IF;	
		END IF;

		-- recalculate staticpressure (fid=147)
		IF v_fid=146 THEN

			RAISE NOTICE ' Update staticpressure';

			INSERT INTO temp_t_data (fid, feature_type, feature_id, log_message)
			SELECT 147, 'node', n.node_id, 
			concat('{"staticpressure":',case when (pz.head - n.elevation::float + (case when n.depth is null then 0 else n.depth end)::float) is null 
			then 0 ELSE (pz.head - n.elevation::float + (case when n.depth is null then 0 else n.depth end)) END, '}')
			FROM temp_t_node n 
			JOIN 
				(SELECT distinct on(node) node as node_id, trace as presszone_id FROM(
				select node, count(*) c, trace FROM(
				select id, node, arc_id, trace, flag from(
				select id, node_1 node, arc_id, trace, flag from temp_t_anlgraph where trace > 0 and flag = 0
				union all
				select id, node_2, arc_id, trace, flag from temp_t_anlgraph where trace > 0 and flag = 0)a
				order by node
				)b group by node, trace order by 1, 2 desc
				)c order by node, c desc) t USING (node_id)
			JOIN presszone pz ON pz.presszone_id = t.presszone_id::text;		

			-- update on node table those elements connected on graph
			UPDATE temp_t_node SET staticpressure=(log_message::json->>'staticpressure')::float FROM temp_t_data a WHERE a.feature_id=node_id 
			AND fid=147 AND cur_user=current_user;
			
			-- update on node table those elements disconnected from graph
			EXECUTE 'UPDATE temp_t_node SET staticpressure=(staticpress1-(staticpress1-staticpress2)*st_linelocatepoint(temp_t_arc.the_geom, n.the_geom))::numeric(12,3)
				FROM temp_t_arc, temp_t_node n
				WHERE st_dwithin(temp_t_arc.the_geom, n.the_geom, 0.05::double precision) AND temp_t_arc.state = 1 AND n.state = 1 
				and n.arc_id IS NOT NULL AND temp_t_node.node_id=n.node_id and n.expl_id='||v_expl_id||' '||v_psectors_query_node||';';
				
			-- updat connec table
			EXECUTE 'UPDATE temp_t_connec SET staticpressure =(b.head - b.elevation + (case when b.depth is null then 0 else b.depth end)::float) FROM 
				(SELECT connec_id, head, elevation, depth FROM temp_t_connec c
				JOIN presszone USING (presszone_id)
				WHERE state = 1 AND c.expl_id='||v_expl_id||' '||v_psectors_query_connec||') b
				WHERE temp_t_connec.connec_id=b.connec_id;';
		END IF;

		IF v_updatemapzgeom > 0 THEN		
			-- message
			INSERT INTO temp_audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 1, concat('INFO: ',v_class,' values for features and geometry of the mapzone has been modified by this process'));
		END IF;

		IF v_floodonlymapzone IS NULL THEN

			RAISE NOTICE 'Check for conflicts';
			
			IF v_class != 'DRAINZONE' THEN

				-- manage conflicts (nodes no headers and no stoppers with different mapzones)
				FOR rec_conflict IN EXECUTE 'SELECT DISTINCT mapzone FROM (WITH qt AS (
					SELECT node_id, mpz FROM (SELECT node_id, mpz FROM 
					(SELECT arc_id, node_1 as node_id, '||v_field||'::text  as mpz FROM temp_t_arc a WHERE expl_id = '||v_expl_id||' and state = 1 '||v_psectors_query_arc||'
					UNION SELECT arc_id, node_2, '||v_field||'::text FROM temp_t_arc a WHERE expl_id = '||v_expl_id||' and state = 1 '||v_psectors_query_arc||') a JOIN 
					(SELECT DISTINCT ON (arc_id) arc_id, flag, isheader FROM temp_t_anlgraph)b USING (arc_id) 
					WHERE flag = 0 and isheader is not true group by node_id, mpz
					) a group by node_id, mpz)
					SELECT DISTINCT ON (node_id) node_id, concat(quote_literal(a.mpz),'','', quote_literal(b.mpz)) as mapzone FROM qt a JOIN qt b USING (node_id)
					WHERE a.mpz::text != b.mpz::text AND a.mpz::text !=''0'' AND b.mpz::text !=''0'') a'

				LOOP
					RAISE NOTICE 'Managing conflicts -> %', rec_conflict;
			
					-- update & count features
					--arc
					EXECUTE 'UPDATE temp_t_arc t SET '||v_field||' = -1 FROM temp_t_arc a WHERE a.state = 1 and a.expl_id = '||v_expl_id||' and t.arc_id =a.arc_id AND t.'||v_field||'::text IN ('||
					rec_conflict.mapzone||') '||v_psectors_query_arc||';';
					GET DIAGNOSTICS v_count1 = row_count;
					
					-- node
					EXECUTE 'UPDATE temp_t_node t SET '||v_field||' = -1 FROM temp_t_node a WHERE  a.state = 1 and a.expl_id = '||v_expl_id||' and t.node_id = a.node_id AND t.'||v_field||'::text IN ('||
					rec_conflict.mapzone||') '||v_psectors_query_node||';';

					-- connec
					EXECUTE 'UPDATE temp_t_connec t SET '||v_field||'  = -1 FROM temp_t_connec a WHERE a.state = 1 and a.expl_id = '||v_expl_id||' and t.connec_id = a.connec_id AND t.'||v_field||'::text IN ('||
					rec_conflict.mapzone||') '||v_psectors_query_connec||';';
					GET DIAGNOSTICS v_count = row_count;

					-- log
					INSERT INTO temp_audit_check_data (fid,  criticity, error_message)
					VALUES (v_fid, 2, concat('WARNING-395: There is a conflict against ',upper(v_table),'''s (',rec_conflict.mapzone,') with ',v_count1,' arc(s) and ',v_count,' connec(s) affected.'));
							
					-- update mapzone geometry
					EXECUTE 'UPDATE '||v_table||' SET the_geom = null WHERE '||v_fieldmp||'::text IN ('||rec_conflict.mapzone||')';

					-- setting the graph for conflict
					EXECUTE 'UPDATE temp_t_anlgraph t SET water = -1 FROM temp_t_arc a WHERE a.state = 1 and a.expl_id = '||v_expl_id||' and t.arc_id = a.arc_id AND a.'||v_field||'::integer = -1 '||
					v_psectors_query_arc||'';
				END LOOP;
			END IF;

			-- create log
			IF v_project_type='UD' THEN
				v_querytext = ' INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				SELECT '||v_fid||', 0, concat('||v_mapzonename||','' with '', arcs, '' Arcs, '',nodes, '' Nodes, '', case when connecs is null then 0 else connecs end, '' Connecs and '',
				 case when gullies is null then 0 else gullies end, '' Gullies'')
				FROM (SELECT '||(v_field)||', count(*) as arcs FROM temp_t_arc a WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_arc||
				' GROUP BY '||(v_field)||')e
				LEFT JOIN (SELECT '||(v_field)||', count(*) as nodes FROM temp_t_node n WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_node||
				' GROUP BY '||(v_field)||')b USING ('||(v_field)||')
				LEFT JOIN (SELECT '||(v_field)||', count(*) as connecs FROM temp_t_connec c WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_connec||
				' GROUP BY '||(v_field)||')c USING ('||(v_field)||')
				LEFT JOIN (SELECT '||(v_field)||', count(*) as gullies FROM temp_t_gully g WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_gully||
				' GROUP BY '||(v_field)||')d USING ('||(v_field)||')
				JOIN '||(v_table)||' p ON e.'||(v_field)||' = p.'||(v_field);
				EXECUTE v_querytext;
			ELSE 
				v_querytext = ' INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				SELECT '||v_fid||', 0, concat('||v_mapzonename||','' with '', arcs, '' Arcs, '',nodes, '' Nodes and '', case when connecs is null then 0 else connecs end, '' Connecs'')
				FROM (SELECT '||(v_field)||', count(*) as arcs FROM temp_t_arc a WHERE state = 1 and expl_id = '||v_expl_id||' and  '||(v_field)||'::integer > 0 '||v_psectors_query_arc||' GROUP BY '||(v_field)||')e
				LEFT JOIN (SELECT '||(v_field)||', count(*) as nodes FROM temp_t_node n WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_node||
				' GROUP BY '||(v_field)||')b USING ('||(v_field)||')
				LEFT JOIN (SELECT '||(v_field)||', count(*) as connecs FROM temp_t_connec c WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_connec||
				' GROUP BY '||(v_field)||')c USING ('||(v_field)||')
				JOIN '||(v_table)||' p ON e.'||(v_field)||' = p.'||(v_field);
				EXECUTE v_querytext;
			END IF;
				
		ELSE
			IF v_project_type='UD' THEN
				v_querytext = ' INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				SELECT '||v_fid||', 0, concat('||v_mapzonename||','' with '', arcs, '' Arcs, '',nodes, '' Nodes, '', case when connecs is null then 0 else connecs end, '' Connecs and '',
				 case when gullies is null then 0 else gullies end, '' Gullies'')
				FROM (SELECT '||(v_field)||', count(*) as arcs FROM temp_t_arc a  WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_arc||' GROUP BY '||(v_field)||')e
				LEFT JOIN (SELECT '||(v_field)||', count(*) as nodes FROM temp_t_node n WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_node||
				' GROUP BY '||(v_field)||')b USING ('||(v_field)||')
				LEFT JOIN (SELECT '||(v_field)||', count(*) as connecs FROM temp_t_connec c WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_connec||
				' GROUP BY '||(v_field)||')c USING ('||(v_field)||')
				LEFT JOIN (SELECT '||(v_field)||', count(*) as gullies FROM temp_t_gully g WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_gully||
				' GROUP BY '||(v_field)||')d USING ('||(v_field)||')
				JOIN '||(v_table)||' p ON e.'||(v_field)||' = p.'||(v_field)||'
				WHERE a.'||(v_field)||'::text = '||quote_literal(v_floodonlymapzone);
				EXECUTE v_querytext;
			ELSE
				v_querytext = ' INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				SELECT '||v_fid||', 0, concat('||v_mapzonename||','' with '', arcs, '' Arcs, '',nodes, '' Nodes and '', case when connecs is null then 0 else connecs end, '' Connecs'')
				FROM (SELECT '||(v_field)||', count(*) as arcs FROM temp_t_arc a WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_arc||
				' GROUP BY '||(v_field)||')e
				LEFT JOIN (SELECT '||(v_field)||', count(*) as nodes FROM temp_t_node n WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_node||
				' GROUP BY '||(v_field)||')b USING ('||(v_field)||')
				LEFT JOIN (SELECT '||(v_field)||', count(*) as connecs FROM temp_t_connec c WHERE state = 1 and expl_id = '||v_expl_id||' and '||(v_field)||'::integer > 0 '||v_psectors_query_connec||
				' GROUP BY '||(v_field)||')c USING ('||(v_field)||')
				JOIN '||(v_table)||' p ON e.'||(v_field)||' = p.'||(v_field)||'
				WHERE p.'||(v_field)||'::text = '||quote_literal(v_floodonlymapzone)||'::text';
				EXECUTE v_querytext;
			END IF;
		END IF;
		
		IF v_floodonlymapzone IS NULL THEN

			RAISE NOTICE 'Disconnected arcs';
			select count(*) INTO v_count FROM 
			(SELECT DISTINCT arc_id FROM temp_t_arc JOIN temp_t_anlgraph USING (arc_id) WHERE water = 0 group by (arc_id) having count(arc_id)=2)a;
			IF v_count > 0 THEN
				INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' arc''s have been disconnected'));
			ELSE
				INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 1, concat('INFO: 0 arc''s have been disconnected'));
			END IF;
		
			RAISE NOTICE 'Disconnected connecs';
			IF v_count > 0 THEN 
				select count(*) INTO v_count FROM 
				(SELECT DISTINCT connec_id FROM temp_t_connec JOIN temp_t_anlgraph USING (arc_id) WHERE water = 0 group by (arc_id, connec_id) having count(arc_id)=2 )a;
				IF v_count > 0 THEN
					INSERT INTO temp_audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' connec''s have been disconnected'));
				ELSE
					INSERT INTO temp_audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
				END IF;
			ELSE
				INSERT INTO temp_audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
			END IF;
			
			RAISE NOTICE 'Disconnected gullies';
			IF v_project_type='UD' THEN
				IF v_count > 0 THEN 
					select count(*) INTO v_count FROM 
					(SELECT DISTINCT gully_id FROM temp_t_gully JOIN temp_t_arc USING (arc_id) WHERE water = 0 group by (arc_id, gully_id) having count(arc_id)=2 )a;
					IF v_count > 0 THEN
						INSERT INTO temp_audit_check_data (fid, criticity, error_message)
						VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' gullies have been disconnected'));
					ELSE
						INSERT INTO temp_audit_check_data (fid, criticity, error_message)
						VALUES (v_fid, 1, concat('INFO: 0 gullies have been disconnected'));
					END IF;
				ELSE
					INSERT INTO temp_audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 1, concat('INFO: 0 gullies have been disconnected'));
				END IF;
			END IF;
		END IF;

		--update of fields 'lastupdate' and 'lastupdate_user'	
		v_querytext = 'UPDATE temp_'||quote_ident(v_table)||' set lastupdate=now(), lastupdate_user=current_user 
		where '||quote_ident(v_field)||' IN (SELECT distinct '||quote_ident(v_field)||' FROM temp_t_arc JOIN temp_t_anlgraph USING (arc_id))';
		EXECUTE v_querytext;

		-- insert spacer for warning and info
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '');
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, '');
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, '');
		INSERT INTO temp_audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  0, '');
	END IF;

	-- update geometry of mapzones
	IF v_updatemapzgeom = 0 THEN
		-- do nothing
		
	ELSIF  v_updatemapzgeom = 1 THEN
	
		-- concave polygon
		v_querytext = '	UPDATE temp_'||(v_table)||' set the_geom = st_multi(a.the_geom) 
			FROM (with polygon AS (SELECT st_collect (the_geom) as g, '||quote_ident(v_field)||' FROM temp_t_arc a  
			JOIN temp_t_anlgraph USING (arc_id) 
			WHERE state > 0  AND water = 1 and expl_id = '||v_expl_id||'   group by '||quote_ident(v_field)||') 
			SELECT '||quote_ident(v_field)||
			', CASE WHEN st_geometrytype(st_concavehull(g, '||v_concavehull||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||
			v_concavehull||'), 2)::geometry(Polygon,'||(v_srid)||')
			ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||(v_srid)||') END AS the_geom FROM polygon
			)a WHERE a.'||quote_ident(v_field)||'= temp_'||(v_table)||'.'||quote_ident(v_fieldmp)||' AND temp_'||(v_table)||'.'||
			quote_ident(v_fieldmp)||' NOT IN (''0'', ''-1'')';
				
		EXECUTE v_querytext;

	ELSIF  v_updatemapzgeom = 2 THEN
	
		-- pipe buffer
		v_querytext = '	UPDATE temp_'||(v_table)||' set the_geom = geom FROM
			(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from temp_t_arc a 
			JOIN temp_t_anlgraph USING (arc_id) 
			where a.state > 0 AND water = 1 AND '||quote_ident(v_field)||'::integer > 0 and expl_id = '||v_expl_id||'  group by '||quote_ident(v_field)||')a 
			WHERE a.'||quote_ident(v_field)||'= temp_'||(v_table)||'.'||quote_ident(v_fieldmp);

			/*
			UPDATE drainzone set the_geom = geom FROM (
				SELECT drainzone_id, st_multi(st_buffer(st_collect(the_geom),10)) as geom from arc 
				 where arc.state = 1 AND drainzone_id::integer > 0 GROUP BY drainzone_id
			)a WHERE a.drainzone_id=drainzone.drainzone_id;
			*/
				
		EXECUTE v_querytext;

	ELSIF  v_updatemapzgeom = 3 THEN
	
		-- use plot and pipe buffer
		v_querytext = '	UPDATE temp_'||(v_table)||' set the_geom = geom FROM
			(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
			(SELECT '||quote_ident(v_field)||', st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from temp_t_arc a
			JOIN temp_t_anlgraph USING (arc_id) 
			where a.state > 0 AND water = 1 AND  '||quote_ident(v_field)||'::integer > 0 and expl_id = '||v_expl_id||' group by '||quote_ident(v_field)||'
			UNION
			SELECT '||quote_ident(v_field)||', st_collect(ext_plot.the_geom) as geom FROM  ext_plot, temp_t_connec a
			JOIN temp_t_anlgraph USING (arc_id) 
			WHERE a.state > 0 and a.expl_id = '||v_expl_id||' 
			AND '||quote_ident(v_field)||'::integer > 0  AND water = 1
			AND st_dwithin(a.the_geom, ext_plot.the_geom, 0.001)
			group by '||quote_ident(v_field)||'	
			)a group by '||quote_ident(v_field)||')b 
			WHERE b.'||quote_ident(v_field)||'= temp_'||(v_table)||'.'||quote_ident(v_fieldmp);

			/*
			UPDATE dma set the_geom = geom FROM(
			SELECT dma_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
			(SELECT dma_id, st_buffer(st_collect(the_geom), 10) as geom from v_edit_arc 
			JOIN temp_t_anlgraph USING (arc_id) 
			where dma_id::integer > 0 group by dma_id
			UNION
			SELECT dma_id, st_collect(ext_plot.the_geom) as geom FROM v_edit_connec, ext_plot
			WHERE dma_id::integer > 0 
			AND v_edit_connec.dma_id IN
			(SELECT DISTINCT dma_id FROM v_edit_arc JOIN anl_arc USING (arc_id) WHERE fid = 145 and cur_user = current_user)
			AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
			group by dma_id	
			)a group by dma_id
			)b WHERE b.dma_id=dma.dma_id;
			*/

		EXECUTE v_querytext;

	ELSIF  v_updatemapzgeom = 4 THEN

		v_geomparamupdate_divide = v_geomparamupdate/2;
		
		-- use link and pipe buffer
		v_querytext = '	UPDATE temp_'||(v_table)||' set the_geom = geom FROM
			(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
			(SELECT '||quote_ident(v_field)||', st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from temp_t_arc a JOIN temp_t_anlgraph USING (arc_id) 
			where a.state > 0  AND water = 1 AND a.'||quote_ident(v_field)||'::integer > 0 and a.expl_id = '||v_expl_id||' group by '||quote_ident(v_field)||'
			UNION
			SELECT a.'||quote_ident(v_field)||', (st_buffer(st_collect(temp_t_link.the_geom),'||v_geomparamupdate_divide||',''endcap=flat join=round'')) 
			as geom FROM temp_t_link, temp_t_connec a
			JOIN temp_t_anlgraph USING (arc_id) 
			WHERE a.'||quote_ident(v_field)||'::integer > 0  AND water = 1
			AND a.state > 0	AND temp_t_link.feature_id = connec_id and temp_t_link.feature_type = ''CONNEC'' and a.expl_id = '||v_expl_id||'
			group by a.'||quote_ident(v_field)||'	
			)c group by '||quote_ident(v_field)||')b 
			WHERE b.'||quote_ident(v_field)||'= temp_'||(v_table)||'.'||quote_ident(v_fieldmp);
			raise notice 'v_querytext,%',v_querytext;

			/*
			UPDATE dma set the_geom = geom FROM
			(
			SELECT dma_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
			(SELECT dma_id, st_buffer(st_collect(the_geom), 5) as geom from temp_t_arc 
			where dma_id::integer > 0  group by dma_id
			UNION
			SELECT c.dma_id, (st_buffer(st_collect(link.the_geom),5/2, ,'endcap=flat join=round')) 
			as geom FROM v_edit_link link, connec c
			WHERE c.dma_id:::integer > 0 
			AND link.feature_id = connec_id and link.feature_type = 'CONNEC'
			group by c.dma_id	
			)a group by dma_id
			)b 
			WHERE b.dma_id=dma.dma_id
			*/

		EXECUTE v_querytext;
		
	ELSIF v_updatemapzgeom = 5 THEN

		v_geomparamupdate_divide = v_geomparamupdate/2;

		/* example of querytext that could be implemented on config_param_system
		UPDATE v_table set the_geom = geom FROM
		(SELECT v_field, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
		(SELECT v_field, st_buffer(st_collect(the_geom), v_geomparamupdate) as geom 
		FROM v_edit_arc arc
		JOIN temp_t_anlgraph USING (arc_id) 
		where arc.state = 1 AND water = 1 AND v_field::INTEGER> 0 group by v_field
		UNION
		SELECT v_field, st_collect(z.geom) as geom FROM v_crm_zone z
		join v_edit_node using (node_id)
		JOIN temp_t_anlgraph ON  node_id = node_1
		WHERE v_edit_node.state = 1 AND water = 1 AND v_field::INTEGER> 0
		group by v_field
		)a group by v_field)b 
		WHERE b.v_field=v_table.v_fieldmp
		*/

		SELECT value into v_querytext FROM config_param_system WHERE parameter='utils_graphanalytics_custom_geometry_constructor';
		EXECUTE 'SELECT replace(replace(replace(replace(replace('||quote_literal(v_querytext)||',''v_table'', '||quote_literal(v_table)||'),
		''v_fieldmp'', '||quote_literal(v_fieldmp)||'), ''v_field'', '||quote_literal(v_field)||'), ''v_fid'', '||quote_literal(v_fid)||'),
		 ''v_geomparamupdate'', '||quote_literal(v_geomparamupdate)||')'
		INTO v_querytext;

		EXECUTE v_querytext;
		
	ELSIF v_updatemapzgeom = 6 THEN --EPA SUBCATCH

	END IF;	


	RAISE NOTICE 'Getting results';
	
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM temp_audit_check_data WHERE cur_user="current_user"() AND fid IN (v_fid) order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	IF v_floodonlymapzone IS NULL THEN
	
		v_result = null;
		IF v_commitchanges IS TRUE THEN
			-- disconnected arcs
			SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
			SELECT jsonb_build_object(
			     'type',       'Feature',
			    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
			    'properties', to_jsonb(row) - 'the_geom'
			) AS feature
			FROM 
			(SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Disconnected'::text as descript, the_geom FROM temp_t_arc JOIN temp_t_anlgraph USING (arc_id) WHERE water = 0 
			group by (arc_id, arccat_id, state, expl_id, the_geom) having count(arc_id)=2
			UNION
			SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM temp_t_arc JOIN temp_t_anlgraph USING (arc_id) WHERE water = -1 
			group by (arc_id, arccat_id, state, expl_id, the_geom) having count(arc_id)=2
			) row) features;

			v_result := COALESCE(v_result, '{}'); 
			v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 
		END IF;

		-- disconnected connecs
		v_result = null;
			
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		     'type',       'Feature',
		    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		    'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT DISTINCT ON (connec_id) connec_id, connecat_id, c.state, c.expl_id, 'Disconnected'::text as descript, c.the_geom FROM temp_t_connec c JOIN temp_t_anlgraph USING (arc_id) WHERE water = 0
		group by (arc_id, connec_id, connecat_id, state, expl_id, the_geom) having count(arc_id)=2
		UNION
		SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM temp_t_connec c JOIN temp_t_anlgraph USING (arc_id) WHERE water = -1
		group by (arc_id, connec_id, connecat_id, state, expl_id, the_geom) having count(arc_id)=2
		UNION			
		SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Orphan'::text as descript, the_geom FROM temp_t_connec c WHERE arc_id IS NULL
		) row) features;

		v_result := COALESCE(v_result, '{}'); 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 
	END IF;	

	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Mapzones dynamic analysis done succesfull';
	ELSE
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;
	END IF;

	-- value4disconnected
	IF v_valuefordisconnected IS NOT NULL OR v_valuefordisconnected <> 0 THEN
		EXECUTE 'UPDATE temp_t_arc t SET '||v_field||' = '||v_valuefordisconnected||' WHERE t.'||v_field||'::text IN (''0'',''-1'')';
		EXECUTE 'UPDATE temp_t_node t SET '||v_field||' = '||v_valuefordisconnected||' WHERE t.'||v_field||'::text  IN (''0'',''-1'')';
		EXECUTE 'UPDATE temp_t_connec t SET '||v_field||'  = '||v_valuefordisconnected||' WHERE t.'||v_field||'::text  IN (''0'',''-1'')';
	END IF;

	------ end of multi-transactional event
	IF v_commitchanges IS FALSE THEN  -- all features in order to make a more complex log
	
		
		-- arc elementS
		EXECUTE 'SELECT jsonb_agg(features.feature) 
		FROM (
		SELECT jsonb_build_object(
		    ''type'',       ''Feature'',
		    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
		    ''properties'', to_jsonb(row) - ''the_geom''
		) AS feature
		FROM 
		(SELECT * FROM 
		(SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, ''0'' as mapzone_id, the_geom, ''Disconnected''::text as descript  FROM temp_t_arc JOIN temp_t_anlgraph USING (arc_id) WHERE water = 0 
		group by (arc_id, arccat_id, state, expl_id, the_geom) having count(arc_id)=2
		UNION
		SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, NULL as mapzone_id, the_geom, ''Conflict''::text as descript FROM temp_t_arc JOIN temp_t_anlgraph USING (arc_id) WHERE water = -1 
		group by (arc_id, arccat_id, state, expl_id, the_geom) having count(arc_id)=2
		) a 
		UNION
		SELECT DISTINCT ON (arc_id) arc_id, arccat_id, t.state, t.expl_id, t.'||v_field||'::TEXT as mapzone_id, t.the_geom, m.name as descript FROM temp_t_arc t 
		JOIN '||v_table||' m USING ('||v_field||') WHERE '||v_field||'::integer >0
		) row ) features'
		INTO v_result;


		v_result := COALESCE(v_result, '{}'); 
		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

		v_result = null;

		-- polygons 
		EXECUTE 'SELECT jsonb_agg(features.feature) 
		FROM (
	  	SELECT jsonb_build_object(
	    ''type'',       ''Feature'',
	    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
	    ''properties'', to_jsonb(row) - ''the_geom''
	  	) AS feature
	  	FROM (SELECT  t.'||v_field||' as mapzone_id, m.name  as descript, '||v_fid||' as fid, t.the_geom FROM temp_'||v_table||' t JOIN '||v_table||' m USING ('||v_field||')) row) features'
		INTO v_result;

		v_result := COALESCE(v_result, '{}'); 
		v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}');

		-- moving to anl tables
		DELETE FROM anl_arc WHERE fid=v_fid AND cur_user=current_user;
		EXECUTE 'INSERT INTO anl_arc (arc_id, expl_id, fid, cur_user, the_geom, '||v_field||') SELECT arc_id, expl_id, '||v_fid||', current_user, the_geom, '||v_field||' FROM temp_t_arc';

		v_visible_layer = NULL;
	ELSIF v_commitchanges IS TRUE THEN

		-- setting variables in order to enhace performance
		UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'edit_typevalue_fk_disable' AND cur_user = current_user;
		UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'edit_node2arc_update_disable' AND cur_user = current_user;
		UPDATE config_param_system SET value = 'TRUE' WHERE parameter = 'admin_skip_audit';

		-- specific values for different graphclass
		IF v_class = 'DMA' THEN
			
			RAISE NOTICE 'Filling om_waterbalance_dma_graph ';
		
			v_querytext = 'INSERT INTO temp_om_waterbalance_dma_graph (node_id, '||quote_ident(v_field)||', flow_sign)
			(SELECT DISTINCT n.node_id, a.'||quote_ident(v_field)||',
			CASE 
			WHEN n.'||quote_ident(v_field)||' =a.'||quote_ident(v_field)||' then 1
			ELSE -1
			END AS flow_sign
			FROM temp_t_node n
			JOIN value_state_type sn ON sn.state =n.state AND sn.id=n.state_type
			JOIN temp_t_arc a  ON a.node_1 =n.node_id or a.node_2 =n.node_id 
			JOIN value_state_type sa ON sa.state =a.state AND sa.id=a.state_type
			WHERE sn.is_operative =true AND sa.is_operative =true AND 
			n.node_id IN
			(SELECT json_array_elements(graphconfig->''use'')->>''nodeParent'' as nodeparent
			FROM '||quote_ident(v_table)||' WHERE active=true)
			AND a.'||quote_ident(v_field)||' IN
			(SELECT '||quote_ident(v_field)||'
			FROM '||quote_ident(v_table)||' WHERE active=true
			)
			) ON CONFLICT (node_id, dma_id) DO NOTHING';
			EXECUTE v_querytext;

			EXECUTE 'DELETE FROM om_waterbalance_dma_graph
			WHERE node_id IN 
			(SELECT node_id FROM om_waterbalance_dma_graph
			JOIN node n USING (node_id)
			WHERE n.expl_id = '||v_expl_id||' '||v_psectors_query_node||');';

			INSERT INTO om_waterbalance_dma_graph SELECT * FROM temp_om_waterbalance_dma_graph ON CONFLICT (dma_id, node_id) DO NOTHING;
			
		ELSIF v_class = 'SECTOR' THEN

			DELETE FROM node_border_sector WHERE node_id IN (SELECT node_id FROM temp_t_node WHERE expl_id=v_expl_id AND state=1);

			INSERT INTO node_border_sector
			WITH arcs AS (SELECT arc_id, node_1, node_2, sector_id FROM temp_t_arc WHERE state>0)
			SELECT node_id, a1.sector_id
			FROM  temp_t_node 
			JOIN arcs a1 ON node_id=node_1 
			where a1.sector_id != temp_t_node.sector_id AND expl_id=v_expl_id 
			UNION 
			SELECT node_id, a2.sector_id
			FROM  temp_t_node 
			JOIN arcs a2 ON node_id=node_2 
			where a2.sector_id != temp_t_node.sector_id AND expl_id=v_expl_id  ON CONFLICT (node_id, sector_id) DO NOTHING;		
		END IF;

		-- mapzone
		v_querytext = 'UPDATE '||v_table||' SET the_geom = t.the_geom FROM temp_'||v_table||' t WHERE t.'||v_field||' = '||v_table||'.'||v_field;
		EXECUTE v_querytext;

		-- arcs
		v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||', lastupdate = a.lastupdate FROM temp_t_arc a WHERE a.arc_id=arc.arc_id';
		EXECUTE v_querytext;
		IF v_class = 'PRESSZONE' THEN
			-- static pressure for arcs
			UPDATE arc SET staticpress1 = n.staticpressure FROM temp_t_node n WHERE node_id = node_1;
			UPDATE arc SET staticpress2 = n.staticpressure FROM temp_t_node n WHERE node_id = node_2;
		END IF;

		-- node
		v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = n.'||quote_ident(v_field)||', lastupdate = n.lastupdate FROM temp_t_node n WHERE n.node_id=node.node_id';
		EXECUTE v_querytext;
		IF v_class = 'PRESSZONE' THEN
			UPDATE node SET staticpressure = n.staticpressure FROM temp_t_node n WHERE n.node_id=node.node_id;
		END IF;

		-- connec
		v_querytext = 'UPDATE connec SET '||quote_ident(v_field)||' = c.'||quote_ident(v_field)||', lastupdate = c.lastupdate FROM temp_t_connec c WHERE c.connec_id=connec.connec_id';
		EXECUTE v_querytext;
		IF v_class = 'PRESSZONE' THEN
			UPDATE connec SET staticpressure = c.staticpressure FROM temp_t_connec c WHERE c.connec_id=connec.connec_id;
		END IF;

		IF v_project_type = 'WS' THEN

			--link
			v_querytext = 'UPDATE link SET '||quote_ident(v_field)||' = l.'||quote_ident(v_field)||' FROM temp_t_link l WHERE l.link_id=link.link_id';
			EXECUTE v_querytext;

		ELSIF v_project_type = 'UD' THEN
		
			-- gully
			v_querytext = 'UPDATE gully SET '||quote_ident(v_field)||' = g.'||quote_ident(v_field)||', lastupdate = g.lastupdate FROM temp_t_gully g WHERE g.gully_id=gully.gully_id';
			EXECUTE v_querytext;
		END IF;	
		
		-- restore values for temporal variables
		UPDATE config_param_user SET value = 'FALSE' WHERE parameter = 'edit_typevalue_fk_disable' AND cur_user = current_user;
		UPDATE config_param_user SET value = 'FALSE' WHERE parameter = 'edit_node2arc_update_disable' AND cur_user = current_user;
		UPDATE config_param_system SET value = 'FALSE' WHERE parameter = 'admin_skip_audit';
	END IF;
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 
	v_level := COALESCE(v_level, 0); 
	v_message := COALESCE(v_message, ''); 
	v_version := COALESCE(v_version, ''); 

	DROP VIEW v_temp_anlgraph;
	DROP TABLE temp_t_anlgraph;
	DROP TABLE temp_t_data;
	DROP TABLE temp_audit_check_data;
	DROP TABLE temp_anl_arc;
	DROP TABLE temp_anl_node;
	DROP TABLE temp_anl_connec;
	DROP TABLE temp_t_arc;
	DROP TABLE temp_t_node;
	DROP TABLE temp_t_connec;
	DROP TABLE temp_t_link;

	IF v_project_type = 'UD' THEN
		DROP TABLE temp_t_gully;
		DROP TABLE temp_drainzone;
	ELSE
		DROP TABLE temp_om_waterbalance_dma_graph;
		DROP TABLE temp_sector;
		DROP TABLE temp_presszone;
		DROP TABLE temp_dma;
		DROP TABLE temp_dqa;
	END IF;
	
	--  Return
	RETURN  gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}, "data":{ "info":'||v_result_info||','||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||','||
					  '"polygon":'||v_result_polygon||'}'||'}}')::json, 2710, null, ('{"visible": ["'||v_visible_layer||'"]}')::json, null)::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' ||
	to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

