/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this have been received helpfull assistance from Enric Amat (FISERSA) and Claudia Dragoste (Aigües de Girona SA)

--FUNCTION CODE: 2710

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_mapzones(json);
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



----------
TO EXECUTE
----------
select * from exploitation


----------------
-- QUERY SAMPLE
SELECT gw_fct_graphanalytics_mapzones('{"data":{"parameters":{"graphClass":"DMA", "exploitation":[1], "macroExploitation":[1], 
"updateFeature":true, "updateMapZone":2, "geomParamUpdate":15, "usePlanPsector":false, "forceOpen":[1,2,3], "forceClosed":[2,3,4]}}}');

SELECT gw_fct_graphanalytics_mapzones('{"data":{"parameters":{"graphClass":"PRESSZONE", "exploitation":[1], 
"updateFeature":true, "updateMapZone":2, "geomParamUpdate":15, "usePlanPsector":false}}}');


 SELECT SCHEMA_NAME.gw_fct_graphanalytics_mapzones_advanced($${"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":5367}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"graphClass":"PRESSZONE", "exploitation":"1", "floodOnlyMapzone":null, "floodFromNode":null, "forceOpen":null, "forceClosed":null, "usePlanPsector":"false", "valueForDisconnected":"0", "updateMapZone":"5", "geomParamUpdate":"100"}}}$$);

hieracy
-------
if floodfromnode not exits 
	if exploitation not exists
		macroexploitation

if updatefeature
	updatemapzone

---------------
TEST EXAMPLE WITHOUT MODIFY SYSTEM VALUES
SELECT SCHEMA_NAME.gw_fct_graphanalytics_mapzones('{"data":{"parameters":{"graphClass":"DMA", "macroExploitation":[1], "updateFeature":false, "updateMapZone":0, "geomParamUpdate":4}}}');

SELECT t.id, t.arc_id, t.trace, dma."name", arc.the_geom FROM temp_anlgraph t 
JOIN arc USING (arc_id)
JOIN dma ON dma.dma_id = trace
WHERE water = 1;

----------------
UPDATE SCHEMA_NAME.presszone set the_geom = null where expl_id  =1

SELECT dma_id from SCHEMA_NAME.arc

--SECTOR
SELECT count(*), log_message FROM audit_log_data WHERE fid=130 AND cur_user=current_user group by log_message order by 2 --SECTOR
SELECT sector_id, count(sector_id) from v_edit_arc group by sector_id order by 1;

-- DMA
SELECT count(*), log_message FROM audit_log_data WHERE fid=145 AND cur_user=current_user group by log_message order by 2 --DMA
SELECT dma_id, count(dma_id) from v_edit_arc  group by dma_id order by 1;
UPDATE arc SET dma_id=0

-- DQA
SELECT count(*), log_message FROM audit_log_data WHERE fid=144 AND cur_user=current_user group by log_message order by 2 --DQA
SELECT dqa_id, count(dma_id) from v_edit_arc  group by dqa_id order by 1;

-- PRESZZONE
SELECT count(*), log_message FROM audit_log_data WHERE fid=48 AND cur_user=current_user group by log_message order by 2 --PZONE
SELECT presszone_id, count(presszone_id) from v_edit_arc  group by presszone_id order by 1;


---------------------------------
TO CHECK PROBLEMS, RUN MODE DEBUG
---------------------------------

1) CONTEXT 
SET search_path='SCHEMA_NAME', public;
UPDATE arc SET dma_id=0 where expl_id IN (1,2)


2) RUN
SELECT gw_fct_graphanalytics_mapzones('{"data":{"parameters":{"graphClass":"DQA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":2,""geomParamUpdate":15,"debug":"true"}}}');

SELECT SCHEMA_NAME.gw_fct_graphanalytics_mapzones($${"data":{"parameters":{"graphClass":"DMA", "exploitation": "[1,2]",
"updateFeature":"TRUE", "updateMapZone":2,"geomParamUpdate":15,"debug":"true", "valueForDisconnected":"9"}}}$$);

 
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
v_expl json;
v_macroexpl json;
v_data json;
v_fid integer;
v_featureid integer;
v_text text;
v_querytext text;
v_updatefeature boolean default false;
v_updatemapzgeom integer default 0;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_result text;
v_count integer;
v_version text;
v_table text;
v_field text;
v_fieldmp text;
v_srid integer;
v_debug boolean;
v_input json;
v_count1 integer;
v_count2 integer;
v_count3 integer;
v_geomparamupdate float;
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

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	--set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );

	UPDATE config_param_user SET value = 'TRUE' WHERE parameter = 'edit_typevalue_fk_disable' AND cur_user = current_user;

	-- get variables
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'graphClass');
	
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_macroexpl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'macroExploitation');

	v_floodonlymapzone = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodOnlyMapzone');
	v_valuefordisconnected = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'valueForDisconnected');
	v_updatefeature = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateFeature');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_debug = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'debug');
	v_parameters = (SELECT ((p_data::json->>'data')::json->>'parameters'));

	IF v_floodonlymapzone = '' THEN v_floodonlymapzone = NULL; END IF;

	v_floodonlymapzone = REPLACE(REPLACE (v_floodonlymapzone,'[','') ,']','');

	-- select config values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
	v_checkdata = (SELECT (value::json->>'checkData') FROM config_param_system WHERE parameter = 'utils_graphanalytics_status');

	SELECT value::boolean INTO v_islastupdate FROM config_param_system WHERE parameter='edit_mapzones_set_lastupdate';

	-- data quality analysis
	IF v_checkdata = 'FULL' THEN
	
		-- om data quality analysis
		v_input = '{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}'::json;
		PERFORM gw_fct_om_check_data(v_input);
		SELECT count(*) INTO v_count1 FROM audit_check_data WHERE cur_user="current_user"() AND fid=125 AND criticity=3 AND result_id IS NOT NULL;

		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=125 AND result_id IS NULL AND error_message ='' AND criticity=1;

		-- graph quality analysis
		v_input = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors", "graphClass":',quote_ident(v_class),'}}}')::json;
		PERFORM gw_fct_graphanalytics_check_data(v_input);
		SELECT count(*) INTO v_count2 FROM audit_check_data WHERE cur_user="current_user"() AND fid=211 AND criticity=3 AND result_id IS NOT NULL;

		DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=211 AND result_id IS NULL;

	ELSIF v_checkdata = 'PARTIAL' THEN

		-- graph quality analysis
		v_input = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors", "graphClass":',quote_ident(v_class),'}}}')::json;
		PERFORM gw_fct_graphanalytics_check_data(v_input);
		SELECT count(*) INTO v_count2 FROM audit_check_data WHERE cur_user="current_user"() AND fid=211 AND criticity=3 AND result_id IS NOT NULL;

	ELSE
		IF (SELECT count(*) FROM config_graph_valve WHERE active is TRUE) < 1 THEN
			DELETE FROM audit_check_data WHERE fid = 211 and cur_user = current_user;
			INSERT INTO audit_check_data (error_message, fid, cur_user, criticity) VALUES ('ERROR: config_graph_valve table is not configured', 211, current_user, 3);
			v_count1 = 1;
		END IF;
	END IF;

	v_count = coalesce(v_count1,0) + coalesce(v_count2,0);

	-- check criticity of data in order to continue or not
	IF v_count > 0 THEN
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND (fid=125 or fid=211) order by criticity desc, id asc) row;

		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		
		--  Return
		RETURN ('{"status":"Accepted", "message":{"level":3, "text":"Mapzones dynamic analysis canceled. Data is not ready to work with"}, "version":"'||v_version||'"'||
		',"body":{"form":{}, "data":{ "info":'||v_result_info||'}}}')::json;	

	END IF;

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
	ELSE
		
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
		"data":{"message":"3090", "function":"2710","debug_msg":null}}$$);'  INTO v_audit_result;

	END IF;

	IF v_audit_result IS NULL THEN
	
		-- reset graph & audit_log tables
		DELETE FROM anl_arc where cur_user=current_user and fid=v_fid;
		DELETE FROM anl_node where cur_user=current_user and fid=v_fid;
		TRUNCATE temp_anlgraph;

		DELETE FROM audit_check_data WHERE fid=v_fid AND cur_user=current_user;

		-- reset rtc_scada_x_dma or rtc_scada_x_dma
		IF v_class = 'DMA' THEN
			DELETE FROM om_waterbalance_dma_graph
			WHERE node_id IN 
			(SELECT node_id FROM om_waterbalance_dma_graph
			JOIN node USING (node_id)
			WHERE expl_id IN (SELECT (json_array_elements_text(v_expl))::integer));
		END IF;
			
		-- save state selector 
		DELETE FROM temp_table WHERE fid=199 AND cur_user=current_user;
		INSERT INTO temp_table (fid, text_column)  
		SELECT 199, (array_agg(state_id)) FROM selector_state WHERE cur_user=current_user;
		
		-- reset state selectors
		DELETE FROM selector_state WHERE cur_user=current_user;
		INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

		-- save expl selector 
		DELETE FROM temp_table WHERE fid=289 AND cur_user=current_user;
		INSERT INTO temp_table (fid, text_column)  
		SELECT 289, (array_agg(expl_id)) FROM selector_expl WHERE cur_user=current_user;

				
		-- reset expl selector
		IF v_expl IS NOT NULL THEN
			DELETE FROM selector_expl WHERE cur_user=current_user;
			INSERT INTO selector_expl (expl_id, cur_user) 
			SELECT expl_id, current_user FROM exploitation WHERE expl_id IN	(SELECT (json_array_elements_text(v_expl))::integer);
		END IF;

		IF v_macroexpl IS NOT NULL THEN
			DELETE FROM selector_expl WHERE cur_user=current_user;
			INSERT INTO selector_expl (expl_id, cur_user) 
			SELECT expl_id, current_user FROM exploitation WHERE macroexpl_id IN (SELECT (json_array_elements_text(v_macroexpl))::integer);
		END IF;

		IF v_usepsector IS NOT TRUE THEN
			-- save psector selector 
			DELETE FROM temp_table WHERE fid=288 AND cur_user=current_user;
			INSERT INTO temp_table (fid, text_column)
			SELECT 288, (array_agg(psector_id)) FROM selector_psector WHERE cur_user=current_user;

			-- set psector selector
			DELETE FROM selector_psector WHERE cur_user=current_user;
		END IF;

		-- start build log message
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('MAPZONES DYNAMIC SECTORITZATION - ', upper(v_class)));
		IF upper(v_class) ='PRESSZONE' THEN
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('------------------------------------------------------------------'));
		ELSE
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('----------------------------------------------------------'));
		END IF;
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Use psectors: ', upper(v_usepsector::text)));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Mapzone constructor method: ', upper(v_updatemapzgeom::text)));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Update feature mapzone attributes: ', upper(v_updatefeature::text)));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Previous data quality control: ', v_checkdata));
		
		IF v_floodonlymapzone IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('''Flood only mapzone'' have been ACTIVATED. Graphic log have been disabled. Used mapzones:',v_floodonlymapzone,'.'));
		END IF;	
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat(''));


		IF (SELECT (value::json->>(v_class))::boolean FROM config_param_system WHERE parameter='utils_graphanalytics_status') IS FALSE THEN

			RAISE NOTICE 'Mapzone graphanalytics is not enabled to continue';
	
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 3, concat('ERROR-',v_fid,': Dynamic analysis for ',v_class,'''s is not configured on database. Please update system variable ''utils_graphanalytics_status'' to enable it '));
		ELSE 
			RAISE NOTICE 'Mapzone graphanalytics is in progress';

			-- start build log message
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '-----------');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');

			IF v_updatefeature THEN 
				-- reset mapzones (update to 0)
				IF v_floodonlymapzone IS NULL THEN
					v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = 0 FROM v_edit_arc v WHERE v.arc_id = arc.arc_id ';
					EXECUTE v_querytext;
					v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = 0 FROM v_edit_node v WHERE v.node_id = node.node_id ';
					EXECUTE v_querytext;
					v_querytext = 'UPDATE connec SET '||quote_ident(v_field)||' = 0 FROM v_edit_connec v WHERE v.connec_id = connec.connec_id ';
					EXECUTE v_querytext;

					IF v_table !='sector' THEN
						v_querytext = 'UPDATE '||quote_ident(v_table)||' SET the_geom = null WHERE expl_id IN 
						(SELECT expl_id FROM selector_expl WHERE cur_user = current_user) AND active IS TRUE';
						EXECUTE v_querytext;
					END IF;					
				ELSE
					v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||'::integer IN ('||v_floodonlymapzone||')';
					EXECUTE v_querytext;
					v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||'::integer IN ('||v_floodonlymapzone||')';
					EXECUTE v_querytext;
					v_querytext = 'UPDATE connec SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||'::integer IN ('||v_floodonlymapzone||')';
					EXECUTE v_querytext;
				END IF;
			END IF;

			-- fill the graph table
			INSERT INTO temp_anlgraph (arc_id, node_1, node_2, water, flag, checkf)
			SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE AND v_edit_arc.state > 0
			UNION
			SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE AND v_edit_arc.state > 0;

			-- close custom nodes acording config parameters
			EXECUTE 'UPDATE temp_anlgraph SET flag = 1 WHERE node_1 IN (SELECT json_array_elements_text((graphconfig->>''forceClosed'')::json) FROM '
			||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';
			EXECUTE 'UPDATE temp_anlgraph SET flag = 1 WHERE node_2 IN (SELECT json_array_elements_text((graphconfig->>''forceClosed'')::json) FROM '
			||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';

			-- set header node for mapzones
			v_text = 'SELECT ((json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'')::integer as node_id 
			FROM '||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE';

			-- close boundary conditions acording config_graph_valve (flag=1)
			v_querytext  = 'UPDATE temp_anlgraph SET flag=1 WHERE 
					node_1::integer IN (
					SELECT a.node_id::integer FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
					LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer 
					JOIN temp_anlgraph e ON a.node_id::integer=e.node_1::integer 
					JOIN config_graph_valve v ON v.id = c.id
					WHERE closed=TRUE
					AND v.active IS TRUE)';
			EXECUTE v_querytext;

			v_querytext  = 'UPDATE temp_anlgraph SET flag=1 WHERE 
					node_2::integer IN (
					SELECT (a.node_id::integer) FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
					LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer 
					JOIN temp_anlgraph e ON a.node_id::integer=e.node_1::integer 
					JOIN config_graph_valve v ON v.id = c.id
					WHERE closed=TRUE
					AND v.active IS TRUE)';

			EXECUTE v_querytext;

			-- open custom nodes acording config parameters
			EXECUTE 'UPDATE temp_anlgraph SET flag = 0 WHERE node_1 IN (SELECT json_array_elements_text((graphconfig->>''forceOpen'')::json) FROM '
			||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';
			EXECUTE 'UPDATE temp_anlgraph SET flag = 0 WHERE node_2 IN (SELECT json_array_elements_text((graphconfig->>''forceOpen'')::json) FROM '
			||quote_ident(v_table)||' WHERE graphconfig IS NOT NULL AND active IS TRUE)';


			-- close checkvalves on the opposite sense where they are working
			UPDATE temp_anlgraph SET flag=1 WHERE id IN (
					SELECT id FROM temp_anlgraph JOIN (
					SELECT node_id, to_arc from config_graph_checkvalve order by 1,2
					) a 
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_2::integer);

			-- close custom nodes acording init parameters
			UPDATE temp_anlgraph SET flag = 1 WHERE node_1 IN (SELECT json_array_elements_text((v_parameters->>'forceClosed')::json));
			UPDATE temp_anlgraph SET flag = 1 WHERE node_2 IN (SELECT json_array_elements_text((v_parameters->>'forceClosed')::json));
			
			-- open custom nodes acording init parameters
			UPDATE temp_anlgraph SET flag = 0 WHERE node_1 IN (SELECT json_array_elements_text((v_parameters->>'forceOpen')::json));
			UPDATE temp_anlgraph SET flag = 0 WHERE node_2 IN (SELECT json_array_elements_text((v_parameters->>'forceOpen')::json));
			
			-- Close mapzone headers
			v_querytext  = 'UPDATE temp_anlgraph SET flag=1 WHERE node_1::integer IN ('||v_text||')';
			EXECUTE v_querytext;
			v_querytext  = 'UPDATE temp_anlgraph SET flag=1 WHERE node_2::integer IN ('||v_text||')';
			EXECUTE v_querytext;

			--moved after Close mapzone headers
			v_text =  concat ('SELECT * FROM (',v_text,')a JOIN temp_anlgraph e ON a.node_id::integer=e.node_1::integer');

			-- Open mapzone headers BUT ONLY ENABLING the right sense (to_arc)			
			IF v_class = 'SECTOR' THEN
				-- sector (sector.graphconfig)
				UPDATE temp_anlgraph SET flag=0, isheader = true WHERE id IN (
					SELECT id FROM temp_anlgraph JOIN (
					SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from sector 
					where graphconfig is not null and active is true order by 1,2) a 
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);
			
			ELSIF v_class = 'DMA' THEN
				-- dma (dma.graphconfig)
				UPDATE temp_anlgraph SET flag=0, isheader = true WHERE id IN (
					SELECT id FROM temp_anlgraph JOIN (
					SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from dma 
					where graphconfig is not null and active is true order by 1,2) a
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);

			ELSIF v_class = 'DQA' THEN
				-- dqa (dqa.graphconfig)
				UPDATE temp_anlgraph SET flag=0, isheader = true WHERE id IN (
				SELECT id FROM temp_anlgraph JOIN (
					SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from dqa  
					where graphconfig is not null and active is true order by 1,2) a
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);

			ELSIF v_class = 'PRESSZONE' THEN
				-- presszone (presszone.graphconfig)
				UPDATE temp_anlgraph SET flag=0, isheader = true WHERE id IN (
				SELECT id FROM temp_anlgraph JOIN (
					SELECT (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((graphconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from presszone
					where graphconfig is not null and active is true order by 1,2) a
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);		
			END IF;
			
			-- set the starting element (water)
			IF v_floodonlymapzone IS NULL THEN
				v_querytext = 'UPDATE temp_anlgraph SET water=1, trace = '||v_fieldmp||'::integer 
				FROM '||v_table||' WHERE graphconfig is not null and active is true AND flag=0 
				AND node_1 IN (SELECT (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' as node_id)';
				EXECUTE v_querytext;
			ELSE
				v_querytext = 'UPDATE temp_anlgraph SET water=1, trace = '||v_fieldmp||'::integer 
				FROM '||v_table||' WHERE graphconfig is not null and active is true AND '||v_fieldmp||'::integer IN ('||v_floodonlymapzone||') AND flag=0 
				AND node_1 IN (SELECT (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent'' as node_id)';
				EXECUTE v_querytext;
			END IF;

			-- inundation process
			LOOP						
				v_count = v_count+1;
				UPDATE temp_anlgraph n SET water=1, trace = a.trace FROM v_anl_graphanalytics_mapzones a where n.node_1::integer = a.node_1::integer AND n.arc_id = a.arc_id;	
				GET DIAGNOSTICS v_affectrow = row_count;
				raise notice 'v_count --> %' , v_count;
				EXIT WHEN v_affectrow = 0;
				EXIT WHEN v_count = 5000;
			END LOOP;

			RAISE NOTICE 'Finish engine....';

			-- update feature atributes
			IF v_updatefeature THEN

				RAISE NOTICE ' Update arcs';

				-- update arc table
				v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = trace FROM temp_anlgraph t WHERE arc.arc_id = t.arc_id AND water = 1';
				EXECUTE v_querytext;

				RAISE NOTICE ' Update nodes';

				-- update disconnected nodes from parent arcs
				v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM v_edit_arc a WHERE a.arc_id=node.arc_id';
				EXECUTE v_querytext;

				-- update whole nodes
				EXECUTE 'UPDATE node SET '||quote_ident(v_field)||' = trace FROM (
				SELECT distinct on(node) node, trace FROM(

				select node, count(*) c, trace FROM(
				select id, node, arc_id, trace, flag from(
				select id, node_1 node, arc_id, trace, flag from temp_anlgraph where trace > 0 and flag = 0
				union all
				select id, node_2, arc_id, trace, flag from temp_anlgraph where trace > 0 and flag = 0)a
				order by node
				)b group by node, trace order by 1, 2 desc
				
				)c order by node, c desc)a
				WHERE node = node_id';
				
				RAISE NOTICE ' Update connecs';
				-- used connec using v_edit_arc because the exploitation filter (same before)
				v_querytext = 'UPDATE connec SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM v_edit_arc a WHERE a.arc_id=connec.arc_id';
				EXECUTE v_querytext;
				
				IF v_islastupdate IS TRUE THEN
					v_querytext = 'UPDATE arc SET lastupdate = now(), lastupdate_user=current_user FROM temp_anlgraph t WHERE arc.arc_id = t.arc_id AND water = 1';
					EXECUTE v_querytext;

					v_querytext = 'UPDATE node SET lastupdate = now(), lastupdate_user=current_user FROM v_edit_arc a WHERE a.arc_id=node.arc_id';
					EXECUTE v_querytext;

					EXECUTE 'UPDATE node SET lastupdate = now(), lastupdate_user=current_user  FROM (
					SELECT distinct on(node) node, trace FROM(

					select node, count(*) c, trace FROM(
					select id, node, arc_id, trace, flag from(
					select id, node_1 node, arc_id, trace, flag from temp_anlgraph where trace > 0 and flag = 0
					union all
					select id, node_2, arc_id, trace, flag from temp_anlgraph where trace > 0 and flag = 0)a
					order by node
					)b group by node, trace order by 1, 2 desc
					
					)c order by node, c desc)a
					WHERE node = node_id';

					v_querytext = 'UPDATE connec SET lastupdate = now(), lastupdate_user=current_user  FROM v_edit_arc a WHERE a.arc_id=connec.arc_id';
					EXECUTE v_querytext;

				END IF;

				-- recalculate staticpressure (fid=147)
				IF v_fid=146 THEN

					RAISE NOTICE ' Update staticpressure';

					DELETE FROM temp_data;
					INSERT INTO temp_data (fid, feature_type, feature_id, log_message)
					SELECT 147, 'node', n.node_id, 
					concat('{"staticpressure":',case when (pz.head - n.elevation::float + (case when n.depth is null then 0 else n.depth end)::float) is null 
					then 0 ELSE (pz.head - n.elevation::float + (case when n.depth is null then 0 else n.depth end)) END, '}')
					FROM node n 
					JOIN 
						(SELECT distinct on(node) node as node_id, trace as presszone_id FROM(
						select node, count(*) c, trace FROM(
						select id, node, arc_id, trace, flag from(
						select id, node_1 node, arc_id, trace, flag from temp_anlgraph where trace > 0 and flag = 0
						union all
						select id, node_2, arc_id, trace, flag from temp_anlgraph where trace > 0 and flag = 0)a
						order by node
						)b group by node, trace order by 1, 2 desc
						)c order by node, c desc) t USING (node_id)
					JOIN presszone pz ON pz.presszone_id = t.presszone_id::text;		

					-- update on node table those elements connected on graph
					UPDATE node SET staticpressure=(log_message::json->>'staticpressure')::float FROM temp_data a WHERE a.feature_id=node_id 
					AND fid=147 AND cur_user=current_user;
					
					-- update on node table those elements disconnected from graph
					UPDATE node SET staticpressure=(staticpress1-(staticpress1-staticpress2)*st_linelocatepoint(v_edit_arc.the_geom, n.the_geom))::numeric(12,3)
									FROM v_edit_arc, node n
									WHERE st_dwithin(v_edit_arc.the_geom, n.the_geom, 0.05::double precision) AND v_edit_arc.state = 1 AND n.state = 1
									and n.arc_id IS NOT NULL AND node.node_id=n.node_id;
					-- updat connec table
					UPDATE connec SET staticpressure =(a.head - a.elevation + (case when a.depth is null then 0 else a.depth end)::float) FROM 
						(SELECT connec_id, head, elevation, depth FROM v_edit_connec
						JOIN presszone USING (presszone_id)) a
						WHERE connec.connec_id=a.connec_id;
				END IF;
	
				IF v_updatemapzgeom > 0 THEN		
					-- message
					INSERT INTO audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 1, concat('INFO: Geometry of mapzone ',v_class ,' have been modified by this process'));
				END IF;

				IF v_floodonlymapzone IS NULL THEN

					RAISE NOTICE 'Disconnected';

					-- disconnected arcs
					select count(*) INTO v_count FROM 
					(SELECT arc_id, count(*) FROM temp_anlgraph WHERE trace is null GROUP BY arc_id HAVING count(*) > 1)a;
					IF v_count > 0 THEN
						INSERT INTO audit_check_data (fid, criticity, error_message)
						VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' arc''s have been disconnected'));
					ELSE
						INSERT INTO audit_check_data (fid, criticity, error_message)
						VALUES (v_fid, 1, concat('INFO: 0 arc''s have been disconnected'));
					END IF;

					-- disconnected connecs
					IF v_count > 0 THEN 
						select count(*) INTO v_count FROM 
						(SELECT arc_id, count(*) FROM temp_anlgraph JOIN v_edit_connec USING (arc_id) WHERE trace is null GROUP BY arc_id HAVING count(*) > 1)a;
						IF v_count > 0 THEN
							INSERT INTO audit_check_data (fid, criticity, error_message)
							VALUES (v_fid, 2, concat('WARNING-',v_fid,': ', v_count ,' connec''s have been disconnected'));
						ELSE
							INSERT INTO audit_check_data (fid, criticity, error_message)
							VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
						END IF;
					ELSE
						INSERT INTO audit_check_data (fid, criticity, error_message)
						VALUES (v_fid, 1, concat('INFO: 0 connec''s have been disconnected'));
					END IF;
					

					RAISE NOTICE 'Check for conflicts';

					-- manage conflicts
					FOR rec_conflict IN EXECUTE 'SELECT concat(quote_literal(m1),'','',quote_literal(m2)) as mapzone, node_id FROM (select n.node_id, n.'||v_field||'::text as m1, a.'||v_field||'::text as m2 from v_edit_node n JOIN 
					(SELECT json_array_elements_text((graphconfig->>''use'')::json)::json->>''nodeParent'' as node_id, '||v_fieldmp||', name FROM '||v_table||' mpz WHERE active is true)a
					USING (node_id))a
					WHERE m1::text != m2::text AND m1::text !=''0'' AND m2::text !=''0'''
					
					/*
					SELECT concat(quote_literal(m1),',',quote_literal(m2)) as mapzone, node_id 
					FROM (select n.node_id, n.presszone_id::text as m1, a.presszone_id::text as m2 from v_edit_node n 
					      JOIN (SELECT json_array_elements_text((graphconfig->>'use')::json)::json->>'nodeParent' as node_id, presszone_id, name FROM presszone mpz WHERE active is true)a	USING (node_id))a
					WHERE m1::text != m2::text AND m1::text !='0' AND m2::text !='0'
					*/

	
					LOOP
						RAISE NOTICE 'Managing conflicts -> %', rec_conflict;
				
						-- update & count features
						--arc
						EXECUTE 'UPDATE arc t SET '||v_field||' = -1 FROM v_edit_arc v WHERE t.arc_id = v.arc_id AND t.'||v_field||'::text IN ('||rec_conflict.mapzone||')';
						GET DIAGNOSTICS v_count1 = row_count;
						
						-- node
						EXECUTE 'UPDATE node t SET '||v_field||' = -1 FROM v_edit_node v WHERE t.node_id = v.node_id AND t.'||v_field||'::text IN ('||rec_conflict.mapzone||')';

						-- connec
						EXECUTE 'UPDATE connec t SET '||v_field||'  = -1 FROM v_edit_connec v WHERE t.connec_id = v.connec_id AND t.'||v_field||'::text IN ('||rec_conflict.mapzone||')';
						GET DIAGNOSTICS v_count = row_count;
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (v_fid, 2, concat('WARNING-395: There is a conflict against ',upper(v_table),'''s (',rec_conflict.mapzone,') with ',v_count1,' arc(s) and ',v_count,' connec(s) affected.'));
								
						-- update mapzone geometry
						EXECUTE 'UPDATE '||v_table||' SET the_geom = null WHERE '||v_fieldmp||'::text IN ('||rec_conflict.mapzone||')';
	
						-- setting the graph for conflict
						EXECUTE 'UPDATE temp_anlgraph t SET water = -1 FROM v_edit_arc v WHERE t.arc_id = v.arc_id AND v.'||v_field||'::integer = -1';
					
					END LOOP;

					-- setting the graph for disconnected
					UPDATE temp_anlgraph t SET water = 9 WHERE water = 0;
					EXECUTE 'UPDATE temp_anlgraph t SET water = 0 FROM v_edit_arc v WHERE t.arc_id = v.arc_id AND v.'||v_field||'::integer = 0';

					-- create log
					v_querytext = ' INSERT INTO audit_check_data (fid, criticity, error_message)
					SELECT '||v_fid||', 1, concat('||v_mapzonename||','' with '', arcs, '' Arcs, '',nodes, '' Nodes and '', case when connecs is null then 0 else connecs end, '' Connecs'')
					FROM (SELECT '||(v_field)||', count(*) as arcs FROM v_edit_arc WHERE '||(v_field)||'::integer > 0 GROUP BY '||(v_field)||')a
					LEFT JOIN (SELECT '||(v_field)||', count(*) as nodes FROM v_edit_node  WHERE '||(v_field)||'::integer > 0 GROUP BY '||(v_field)||')b USING ('||(v_field)||')
					LEFT JOIN (SELECT '||(v_field)||', count(*) as connecs FROM v_edit_connec  WHERE '||(v_field)||'::integer > 0 GROUP BY '||(v_field)||')c USING ('||(v_field)||')
					JOIN '||(v_table)||' p ON a.'||(v_field)||' = p.'||(v_field);
					EXECUTE v_querytext;
				ELSE
					v_querytext = ' INSERT INTO audit_check_data (fid, criticity, error_message)
					SELECT '||v_fid||', 1, concat('||v_mapzonename||','' with '', arcs, '' Arcs, '',nodes, '' Nodes and '', case when connecs is null then 0 else connecs end, '' Connecs'')
					FROM (SELECT '||(v_field)||', count(*) as arcs FROM v_edit_arc  WHERE '||(v_field)||'::integer > 0 GROUP BY '||(v_field)||')a
					LEFT JOIN (SELECT '||(v_field)||', count(*) as nodes FROM v_edit_node  WHERE '||(v_field)||'::integer > 0 GROUP BY '||(v_field)||')b USING ('||(v_field)||')
					LEFT JOIN (SELECT '||(v_field)||', count(*) as connecs FROM v_edit_connec  WHERE '||(v_field)||'::integer > 0GROUP BY '||(v_field)||')c USING ('||(v_field)||')
					JOIN '||(v_table)||' p ON a.'||(v_field)||' = p.'||(v_field)||'
					WHERE a.'||(v_field)||'::text = '||quote_literal(v_floodonlymapzone);
					EXECUTE v_querytext;
				END IF;
			ELSE
				-- message
				INSERT INTO audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 1, concat('INFO: Mapzone attribute on arc/node/connec features keeps same value previous function. Nothing have been updated by this process'));
				INSERT INTO audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 1, concat('INFO: To see results you can query using this values (XX): SECTOR:130, DQA:144, DMA:145, PRESSZONE:146, STATICPRESSURE:147 '));
				INSERT INTO audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 1, concat('SELECT * FROM anl_arc WHERE fid = (XX) AND cur_user=current_user;'));
				INSERT INTO audit_check_data (fid, criticity, error_message)
				VALUES (v_fid, 1, concat('NOTE: This query may load more than once same arc. This will be usefull to check mapzone conflicts because it will show where could be problem'));
			END IF;
			
			-- fill config table for dma
			IF v_class = 'DMA' THEN
				
				RAISE NOTICE 'Filling om_waterbalance_dma_graph ';
			
				v_querytext = 'INSERT INTO om_waterbalance_dma_graph (node_id, '||quote_ident(v_field)||', flow_sign)
				(SELECT DISTINCT n.node_id, a.'||quote_ident(v_field)||',
				CASE 
				WHEN n.'||quote_ident(v_field)||' =a.'||quote_ident(v_field)||' then 1
				ELSE -1
				END AS flow_sign
				FROM node n
				JOIN value_state_type sn ON sn.state =n.state AND sn.id=n.state_type
				JOIN arc a  ON a.node_1 =n.node_id or a.node_2 =n.node_id 
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
			END IF;

			RAISE NOTICE 'Generate geometries';		

			-- update geometry of mapzones
			IF v_updatemapzgeom = 0 THEN
				-- do nothing
			ELSIF  v_updatemapzgeom = 1 THEN
			
				-- concave polygon
				v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = st_multi(a.the_geom) 
						FROM (with polygon AS (SELECT st_collect (the_geom) as g, '||quote_ident(v_field)||' FROM v_edit_arc 
						JOIN temp_anlgraph USING (arc_id) 
						WHERE state > 0  AND water = 1 group by '||quote_ident(v_field)||') 
						SELECT '||quote_ident(v_field)||
						', CASE WHEN st_geometrytype(st_concavehull(g, '||v_concavehull||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||
						v_concavehull||'), 2)::geometry(Polygon,'||(v_srid)||')
						ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||(v_srid)||') END AS the_geom FROM polygon
						)a WHERE a.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp)||' AND '||quote_ident(v_table)||'.'||
						quote_ident(v_fieldmp)||' NOT IN (''0'', ''-1'')';
						
				EXECUTE v_querytext;

			ELSIF  v_updatemapzgeom = 2 THEN
			
				-- pipe buffer
				v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = geom FROM

						(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from v_edit_arc arc 
						JOIN temp_anlgraph USING (arc_id) 
						where arc.state > 0 AND water = 1 AND '||quote_ident(v_field)||'::integer > 0 group by '||quote_ident(v_field)||')a 
						WHERE a.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp);

						/*
						UPDATE presszone set the_geom = geom FROM (
							SELECT presszone_id, st_multi(st_buffer(st_collect(the_geom),10)) as geom from arc 
							 where arc.state > 0 AND dma_id::integer > 0 GROUP BY presszone_id
						)a WHERE a.presszone_id=presszone.presszone_id;
						*/
				EXECUTE v_querytext;

			ELSIF  v_updatemapzgeom = 3 THEN
			
				-- use plot and pipe buffer
				v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = geom FROM
							(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
							(SELECT '||quote_ident(v_field)||', st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from v_edit_arc arc
							JOIN temp_anlgraph USING (arc_id) 
							where arc.state > 0 AND water = 1 AND  '||quote_ident(v_field)||'::integer > 0 group by '||quote_ident(v_field)||'
							UNION
							SELECT '||quote_ident(v_field)||', st_collect(ext_plot.the_geom) as geom FROM  ext_plot, v_edit_connec
							JOIN temp_anlgraph USING (arc_id) 
							WHERE v_edit_connec.state > 0 
							AND '||quote_ident(v_field)||'::integer > 0  AND water = 1
							AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
							group by '||quote_ident(v_field)||'	
							)a group by '||quote_ident(v_field)||')b 
						WHERE b.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp);

						/*
						UPDATE arc set the_geom = geom FROM(
							SELECT dma_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
							(SELECT dma_id, st_buffer(st_collect(the_geom), 10) as geom from v_edit_arc 
							JOIN temp_anlgraph USING (arc_id) 
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
				v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = geom FROM
						(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
						(SELECT '||quote_ident(v_field)||', st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from v_edit_arc arc JOIN temp_anlgraph USING (arc_id) 
						where arc.state > 0  AND water = 1 AND '||quote_ident(v_field)||'::integer > 0 group by '||quote_ident(v_field)||'
						UNION
						SELECT c.'||quote_ident(v_field)||', (st_buffer(st_collect(link.the_geom),'||v_geomparamupdate_divide||',''endcap=flat join=round'')) 
						as geom FROM v_edit_link link, connec c
						JOIN temp_anlgraph USING (arc_id) 
						WHERE c.'||quote_ident(v_field)||'::integer > 0  AND water = 1
						AND c.state > 0	AND link.feature_id = connec_id and link.feature_type = ''CONNEC''
						group by c.'||quote_ident(v_field)||'	
						)a group by '||quote_ident(v_field)||')b 
					WHERE b.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp);

					/*
					UPDATE dma set the_geom = geom FROM
						(
						SELECT dma_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
						(SELECT dma_id, st_buffer(st_collect(the_geom), 5) as geom from arc 
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
				JOIN temp_anlgraph USING (arc_id) 
				where arc.state > 0 AND water = 1 AND v_field::INTEGER> 0 group by v_field
				UNION
				SELECT v_field, st_collect(z.geom) as geom FROM v_crm_zone z
				join v_edit_node using (node_id)
				JOIN temp_anlgraph ON  node_id = node_1
				WHERE v_edit_node.state > 0 AND water = 1 AND v_field::INTEGER> 0
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

			END IF;

			-- insert spacer for warning and info
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '');
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, '');
			INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, '');
		END IF;
	END IF;
	
	RAISE NOTICE 'Getting results';
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid IN (v_fid) order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	IF v_updatefeature THEN -- only disconnected features to make a simple log

		IF v_floodonlymapzone IS NULL THEN
			v_result = null;

			-- disconnected arcs
			SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
			SELECT jsonb_build_object(
		     'type',       'Feature',
		    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		    'properties', to_jsonb(row) - 'the_geom'
			) AS feature
			FROM 
			(SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Disconnected'::text as descript, the_geom FROM v_edit_arc JOIN temp_anlgraph USING (arc_id) WHERE water = 0
			UNION
			SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM v_edit_arc JOIN temp_anlgraph USING (arc_id) WHERE water = -1
			) row) features;

			v_result := COALESCE(v_result, '{}'); 
			v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

			-- disconnected connecs
			v_result = null;
			
			SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
			SELECT jsonb_build_object(
		     'type',       'Feature',
		    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		    'properties', to_jsonb(row) - 'the_geom'
			) AS feature
			FROM (SELECT DISTINCT ON (connec_id) connec_id, connecat_id, c.state, c.expl_id, 'Disconnected'::text as descript, c.the_geom FROM v_edit_connec c JOIN temp_anlgraph USING (arc_id) WHERE water = 0
			UNION
			SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM v_edit_connec c JOIN temp_anlgraph USING (arc_id) WHERE water = -1
			UNION			
			SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Orphan'::text as descript, the_geom FROM v_edit_connec c WHERE dma_id = 0 AND arc_id IS NULL
			) row) features;

			v_result := COALESCE(v_result, '{}'); 
			v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 
		END IF;

	ELSE -- all features in order to make a more complex log

		-- arc elements
		v_result = null;

		EXECUTE 'SELECT jsonb_agg(features.feature) 
		FROM (
	  	SELECT jsonb_build_object(
	    ''type'',       ''Feature'',
	    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
	    ''properties'', to_jsonb(row) - ''the_geom''
	  	) AS feature
	  	FROM (SELECT a.id, a.arc_id, b.'||quote_ident(v_field)||', a.the_geom FROM anl_arc a 
			JOIN (SELECT '||quote_ident(v_fieldmp)||', json_array_elements_text((graphconfig->>''use'')::json)::json->>''nodeParent'' as nodeparent from '||
			quote_ident(v_table)||') b ON  nodeparent = descript 
			WHERE fid='||v_fid||' AND cur_user=current_user) row) features'
		INTO v_result;

		v_result := COALESCE(v_result, '{}'); 
		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');
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

	-- value4disconnecteds
	IF v_valuefordisconnected IS NOT NULL OR v_valuefordisconnected <> 0 THEN

		EXECUTE 'UPDATE arc t SET '||v_field||' = '||v_valuefordisconnected||' FROM v_edit_arc v WHERE t.arc_id = v.arc_id AND t.'||v_field||'::text IN (''0'',''-1'')';
		EXECUTE 'UPDATE node t SET '||v_field||' = '||v_valuefordisconnected||' FROM v_edit_node v WHERE t.node_id = v.node_id AND t.'||v_field||'::text  IN (''0'',''-1'')';
		EXECUTE 'UPDATE connec t SET '||v_field||'  = '||v_valuefordisconnected||' FROM v_edit_connec v WHERE t.connec_id = v.connec_id AND t.'||v_field||'::text  IN (''0'',''-1'')';
	END IF;
			
    -- restore state selector (if it's needed)
	IF v_usepsector IS NOT TRUE THEN
		INSERT INTO selector_psector (psector_id, cur_user)
		select unnest(text_column::integer[]), current_user from temp_table where fid=288 and cur_user=current_user
		ON CONFLICT (psector_id, cur_user) DO NOTHING;
	END IF;

	-- restore state selector
	INSERT INTO selector_state (state_id, cur_user)
	select unnest(text_column::integer[]), current_user from temp_table where fid=199 and cur_user=current_user
	ON CONFLICT (state_id, cur_user) DO NOTHING;

	-- restore expl selector
	INSERT INTO selector_expl (expl_id, cur_user)
	select unnest(text_column::integer[]), current_user from temp_table where fid=289 and cur_user=current_user
	ON CONFLICT (expl_id, cur_user) DO NOTHING;

	UPDATE config_param_user SET value = 'FALSE' WHERE parameter = 'edit_typevalue_fk_disable' AND cur_user = current_user;
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_visible_layer := COALESCE(v_visible_layer, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN  gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}, "data":{ "info":'||v_result_info||','||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||'}'||'}}')::json, 2710, null, ('{"visible": ["'||v_visible_layer||'"]}')::json, null);


	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' ||
	to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;