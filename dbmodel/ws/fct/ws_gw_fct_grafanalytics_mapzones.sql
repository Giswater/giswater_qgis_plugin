/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2710

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mapzones(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mapzones(p_data json)
RETURNS json AS
$BODY$

/*

------------
TO CONFIGURE
------------

set graf_delimiter field on node_type table (below an example). It's not mandatory but provides more consistency to the analyzed data

UPDATE node_type 
SET graf_delimiter='NONE';
SET graf_delimiter='SECTOR' WHERE type IN ('SOURCE','WATERWELL', 'ETAP' 'TANK');

UPDATE sector SET grafconfig='[{"nodeParent":"1", "toArc":[2,3,4]}, {"nodeParent":"5", "toArc":[6,7,8]}]';
UPDATE dma SET grafconfig='[{"nodeParent":"11", "toArc":[12,13,14]}, {"nodeParent":"5", "toArc":[16,17,18]}]';
UPDATE dqa SET grafconfig='[{"nodeParent":"21", "toArc":[22,23,24]}, {"nodeParent":"5", "toArc":[26,27,28]}]';
UPDATE cat_preszone SET grafconfig='[{"nodeParent":"31", "toArc":[32,33,34]}, {"nodeParent":"35", "toArc":[36,37,38]}]';

update arc set sector_id=0, dma_id=0, dqa_id=0, presszone_id=0;
update node set sector_id=0, dma_id=0, dqa_id=0,  presszone_id=0;
update connec set sector_id=0, dma_id=0, dqa_id=0, presszone_id=0


----------
TO EXECUTE
----------
select * from exploitation

-- QUERY SAMPLE
----------------
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation":[1], "floodFromNode":"113766", "checkData":false, 
"updateFeature":true, "updateMapZone":2, "geomParamUpdate":15,"debug":false, "usePlanPsector":false, "forceOpen":[], "forceClosed":[]}}}')

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "exploitation":[1], "macroExploitation":[1], "checkData":false, 
"updateFeature":true, "updateMapZone":2, "geomParamUpdate":15,"debug":false, "usePlanPsector":false, "forceOpen":[1,2,3], "forceClosed":[2,3,4]}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "exploitation":[502],  "checkData":false, 
"updateFeature":true, "updateMapZone":4, "geomParamUpdate":20,"debug":false}}}');


SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "nodeHeader":"113952","exploitation":[1], "macroExploitation":[1], 
"checkData":false, "updateFeature":true, "updateMapZone":2, "geomParamUpdate":15,"debug":false, "usePlanPsector":false, "forceOpen":[1,2,3], "forceClosed":[2,3,4]}}}');
----------------

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
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":2,""geomParamUpdate":15,"debug":"true"}}}');

SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":2,""geomParamUpdate":15,"debug":"true"}}}');

INSTRUCTIONS
flag: 0 open, 1 closed
water: 0 dry, 1 wet

3) ANALYZE: 

Look graf flooders (flag=0 and grafdelimiter node)
SELECT node_1 AS node_id, arc_id AS to_arc FROM temp_anlgraf WHERE flag=0 AND node_1 IN (
SELECT DISTINCT node_id::integer FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN temp_anlgraf e ON a.node_id::integer=e.node_1::integer WHERE graf_delimiter IN ('DQA', 'SECTOR'))

SELECT node_1 AS node_id, arc_id AS to_arc FROM temp_anlgraf WHERE flag=0 AND node_1 IN (
SELECT DISTINCT node_id::integer FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN temp_anlgraf e ON a.node_id::integer=e.node_1::integer WHERE graf_delimiter IN ('DMA', 'SECTOR'))

Look for the graf stoppers (flag=1)
SELECT arc_id, node_1 FROM temp_anlgraf where flag=1 order by node_1

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
v_floodfromnode text;
v_featureid integer;
v_text text;
v_querytext text;
v_updatetattributes boolean default false;
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
v_visible_layer text;
v_concavehull float = 0.9;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_checkdata boolean;
v_mapzonename text;
v_parameters json;
v_usepsector boolean;
v_error boolean = false;
v_nodemapzone text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;
	
	--set current process as users parameter
	DELETE FROM config_param_user  WHERE  parameter = 'utils_cur_trans' AND cur_user =current_user;

	INSERT INTO config_param_user (value, parameter, cur_user)
	VALUES (txid_current(),'utils_cur_trans',current_user );

	-- get variables
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'grafClass');
	v_floodfromnode = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'floodFromNode');
	v_updatetattributes = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateFeature');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_geomparamupdate = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'geomParamUpdate');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');
	v_macroexpl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'macroExploitation');
	v_usepsector = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'usePlanPsector');
	v_debug = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'debug');
	v_checkdata = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'checkData');
	v_parameters = (SELECT ((p_data::json->>'data')::json->>'parameters'));

	IF v_floodfromnode = '' THEN v_floodfromnode = NULL; END IF;

	-- select config values
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version order by 1 desc limit 1;

	-- data quality analysis
	IF v_checkdata THEN
		-- om data quality analysis
		v_input = '{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors"}}}'::json;
		PERFORM gw_fct_om_check_data(v_input);
		SELECT count(*) INTO v_count1 FROM audit_check_data WHERE cur_user="current_user"() AND fid=125 AND criticity=3;

		-- graf quality analysis
		v_input = concat('{"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},"data":{"parameters":{"selectionMode":"userSelectors", "grafClass":',quote_ident(v_class),'}}}')::json;
		PERFORM gw_fct_grafanalytics_check_data(v_input);
		SELECT count(*) INTO v_count2 FROM audit_check_data WHERE cur_user="current_user"() AND fid=211 AND criticity=3;

		v_count = v_count1 + v_count2;
	END IF;

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

	
		-- reset graf & audit_log tables
		DELETE FROM anl_arc where cur_user=current_user and fid=v_fid;
		DELETE FROM anl_node where cur_user=current_user and fid=v_fid;
		TRUNCATE temp_anlgraf;

		DELETE FROM audit_check_data WHERE fid=v_fid AND cur_user=current_user;
			
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
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('----------------------------------------------------------'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Use psectors: ', upper(v_usepsector::text)));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Mapzone constructor method: ', upper(v_updatemapzgeom::text)));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Update feature mapzone attributes: ', upper(v_updatetattributes::text)));
		IF v_floodfromnode IS NOT NULL THEN
			INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('Flood from mode is ENABLED. Graphic log (disconnected arcs & connecs) have been disabled. Used node:',v_floodfromnode,'.'));
		END IF;	
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat(''));


		IF (SELECT (value::json->>(v_class))::boolean FROM config_param_system WHERE parameter='utils_grafanalytics_status') IS FALSE THEN

			RAISE NOTICE 'Mapzone grafanalytics is not enabled to continue';
	
			INSERT INTO audit_check_data (fid, criticity, error_message)
			VALUES (v_fid, 3, concat('ERROR: Dynamic analysis for ',v_class,'''s is not configured on database. Please update system variable ''utils_grafanalytics_status''
			 to enable it '));
		ELSE 
			RAISE NOTICE 'Mapzone grafanalytics is in progress';

			-- start build log message
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, 'ERRORS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 3, '--------------');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, 'WARNINGS');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 2, '--------------');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, 'INFO');
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, NULL, 1, '-------');

			-- reset mapzones (update to 0)
			IF v_floodfromnode IS NULL THEN
				v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = 0 FROM v_edit_arc v WHERE v.arc_id = arc.arc_id ';
				EXECUTE v_querytext;
				v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = 0 FROM v_edit_node v WHERE v.node_id = node.node_id ';
				EXECUTE v_querytext;
				v_querytext = 'UPDATE connec SET '||quote_ident(v_field)||' = 0 FROM v_edit_connec v WHERE v.connec_id = connec.connec_id ';
				EXECUTE v_querytext;
			ELSE
				EXECUTE 'SELECT '||quote_ident(v_field)||' FROM v_edit_node WHERE node_id = '||quote_literal(v_floodfromnode)
				INTO v_nodemapzone;
				IF v_nodemapzone IS NOT NULL THEN
					v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||' = '||quote_literal(v_nodemapzone);
					EXECUTE v_querytext;
					v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||' = '||quote_literal(v_nodemapzone);
					EXECUTE v_querytext;
					v_querytext = 'UPDATE connec SET '||quote_ident(v_field)||' = 0 WHERE '||quote_ident(v_field)||' = '||quote_literal(v_nodemapzone);
					EXECUTE v_querytext;
				END IF;
			END IF;

			-- fill the graf table
			INSERT INTO temp_anlgraf (arc_id, node_1, node_2, water, flag, checkf)
			SELECT  arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
			UNION
			SELECT  arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
			WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;

			-- set boundary conditions of graf table (flag=1 it means water is disabled to flow)
			v_text = 'SELECT ((json_array_elements_text((grafconfig->>''use'')::json))::json->>''nodeParent'')::integer as node_id from '||quote_ident(v_table)||' WHERE grafconfig IS NOT NULL';

			-- close boundary conditions setting flag=1 for all nodes that fits on graf delimiters and closed valves
			v_querytext  = 'UPDATE temp_anlgraf SET flag=1 WHERE 
					node_1::integer IN ('||v_text||' 
					UNION
					SELECT a.node_id::integer FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
					LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer 
					JOIN temp_anlgraf e ON a.node_id::integer=e.node_1::integer 
					JOIN config_valve v ON v.id = c.id
					WHERE closed=TRUE)';
			EXECUTE v_querytext;
			
			v_querytext  = 'UPDATE temp_anlgraf SET flag=1 WHERE 
					node_2::integer IN ('||v_text||' 
					UNION
					SELECT (a.node_id::integer) FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN cat_feature_node c ON c.id=b.nodetype_id 
					LEFT JOIN man_valve d ON a.node_id::integer=d.node_id::integer 
					JOIN temp_anlgraf e ON a.node_id::integer=e.node_1::integer JOIN config_valve v ON v.id = c.id
					WHERE closed=TRUE)';
			EXECUTE v_querytext;

			v_text =  concat ('SELECT * FROM (',v_text,')a JOIN temp_anlgraf e ON a.node_id::integer=e.node_1::integer');

			-- close customized stoppers acording on grafconfig column on mapzone table
			EXECUTE 'UPDATE temp_anlgraf SET flag = 1 WHERE node_1 IN (SELECT (json_array_elements_text((grafconfig->>''stopper'')::json)) as node_id FROM '||quote_ident(v_table)||')';
			EXECUTE 'UPDATE temp_anlgraf SET flag = 1 WHERE node_2 IN (SELECT (json_array_elements_text((grafconfig->>''stopper'')::json)) as node_id FROM '||quote_ident(v_table)||')';

				
			-- open boundary conditions set flag=0 for graf delimiters that have been setted to 1 on query before BUT ONLY ENABLING the right sense (to_arc)
			
			-- in function of graf class
			IF v_class = 'SECTOR' THEN
				-- sector (sector.grafconfig)
				UPDATE temp_anlgraf SET flag=0 WHERE id IN (
					SELECT id FROM temp_anlgraf JOIN (
					SELECT (json_array_elements_text((grafconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((grafconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from sector 
					where grafconfig is not null order by 1,2) a 
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);
			
			ELSIF v_class = 'DMA' THEN
				-- dma (dma.grafconfig)
				UPDATE temp_anlgraf SET flag=0 WHERE id IN (
					SELECT id FROM temp_anlgraf JOIN (
					SELECT (json_array_elements_text((grafconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((grafconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from dma 
					where grafconfig is not null order by 1,2) a
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);

			ELSIF v_class = 'DQA' THEN
				-- dqa (dqa.grafconfig)
				UPDATE temp_anlgraf SET flag=0 WHERE id IN (
				SELECT id FROM temp_anlgraf JOIN (
					SELECT (json_array_elements_text((grafconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((grafconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from dqa  
					where grafconfig is not null order by 1,2) a
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);

			ELSIF v_class = 'PRESSZONE' THEN
				-- presszone (presszone.grafconfig)
				UPDATE temp_anlgraf SET flag=0 WHERE id IN (
				SELECT id FROM temp_anlgraf JOIN (
					SELECT (json_array_elements_text((grafconfig->>'use')::json))::json->>'nodeParent' as node_id, 
					json_array_elements_text(((json_array_elements_text((grafconfig->>'use')::json))::json->>'toArc')::json) 
					as to_arc from presszone
					where grafconfig is not null order by 1,2) a
					ON to_arc::integer=arc_id::integer WHERE node_id::integer=node_1::integer);		
			END IF;

			-- close custom nodes acording init parameters
			UPDATE temp_anlgraf SET flag = 1 WHERE node_1 IN (SELECT json_array_elements_text((v_parameters->>'forceClosed')::json));
			UPDATE temp_anlgraf SET flag = 1 WHERE node_2 IN (SELECT json_array_elements_text((v_parameters->>'forceClosed')::json));

			-- open custom nodes acording init parameters
			UPDATE temp_anlgraf SET flag = 0 WHERE node_1 IN (SELECT json_array_elements_text((v_parameters->>'forceOpen')::json));
			UPDATE temp_anlgraf SET flag = 0 WHERE node_2 IN (SELECT json_array_elements_text((v_parameters->>'forceOpen')::json));

			IF v_debug IS NULL OR v_debug IS FALSE THEN

				-- starting process
				LOOP	

					EXIT WHEN v_cont1 = -1;
					v_cont1 = v_cont1+1;

					IF v_floodfromnode IS NULL THEN
						v_querytext = 'SELECT * FROM ('||v_text||' AND checkf=0 LIMIT 1)a';
						IF v_querytext IS NOT NULL THEN
							--RAISE NOTICE 'v_querytext %', v_querytext;
							EXECUTE v_querytext INTO v_feature;
						END IF;

						v_featureid = v_feature.node_id;
						EXIT WHEN v_featureid IS NULL;
						
					ELSIF v_floodfromnode IS NOT NULL THEN
						v_featureid = v_floodfromnode::integer;
						v_cont1 = -1;
					END IF;

					-- reset water flag
					UPDATE temp_anlgraf SET water=0;

					raise notice '---------------- Feature_id % ', v_featureid;
					
					------------------
					-- starting engine

					-- set the starting element (water)
					v_querytext = 'UPDATE temp_anlgraf SET water=1 WHERE node_1='||quote_literal(v_featureid)||' AND flag=0'; 
					EXECUTE v_querytext;

					-- set the starting element (check)
					v_querytext = 'UPDATE temp_anlgraf SET checkf=1 WHERE node_1='||quote_literal(v_featureid);
					
					EXECUTE v_querytext;

					v_count = 0;

					-- inundation process
					LOOP						
						v_count = v_count+1;
						
						UPDATE temp_anlgraf n SET water= 1, flag=n.flag+1, checkf=1 FROM v_anl_graf a where n.node_1::integer = a.node_1::integer AND n.arc_id = a.arc_id;
						
						GET DIAGNOSTICS v_affectrow = row_count;
						EXIT WHEN v_affectrow = 0;
						EXIT WHEN v_count = 2000;

					END LOOP;
					
					-- finish engine
					----------------

					IF v_error IS NOT TRUE THEN

						-- insert arc results into audit table	
						EXECUTE 'INSERT INTO anl_arc (fid, arccat_id, arc_id, the_geom, descript)
							SELECT  DISTINCT ON (arc_id) '||v_fid||', arccat_id, a.arc_id, the_geom, '||(v_featureid)||' FROM (SELECT arc_id FROM temp_anlgraf
							WHERE water >0) a 
							JOIN arc b ON a.arc_id::integer=b.arc_id::integer';

						-- insert node results into audit table
						EXECUTE 'INSERT INTO anl_node (fid, nodecat_id, node_id, the_geom, descript)
							SELECT DISTINCT ON (node_id) '||v_fid||', nodecat_id, b.node_id, the_geom, '||(v_featureid)||' FROM (SELECT node_1 as node_id
							FROM temp_anlgraf WHERE water >0)a
							JOIN node b ON a.node_id::integer=b.node_id::integer';

						-- message
						SELECT count(*) INTO v_count1 FROM anl_arc WHERE fid=v_fid AND descript=v_featureid::text AND cur_user=current_user;
						SELECT count(*) INTO v_count2 FROM anl_node WHERE fid=v_fid AND descript=v_featureid::text AND cur_user=current_user;
						SELECT count(*) INTO v_count3 FROM anl_arc JOIN connec USING (arc_id) WHERE fid=v_fid AND anl_arc.descript=v_featureid::text
						AND cur_user=current_user;			
					
						INSERT INTO audit_check_data (fid,  criticity, error_message)
						VALUES (v_fid, 1, concat('INFO: ', v_class ,' for node: ',v_featureid ,' have been processed. ARCS (', v_count1, '), NODES (', v_count2, '), CONNECS (', v_count3,')'));
					END IF;
				END LOOP;

				-- update feature atributes
				IF v_updatetattributes THEN

					-- flood from node may be a header or not. In case of won't be a header by this process we can get header from any node
					IF v_floodfromnode IS NOT NULL THEN

						-- getting node header	
						EXECUTE 'SELECT node_id FROM (SELECT a.node_1 as node_id, a.arc_id FROM arc a JOIN anl_arc USING (arc_id) WHERE fid = '||v_fid||' AND cur_user = current_user
							UNION SELECT a.node_2, a.arc_id FROM arc a JOIN anl_arc USING (arc_id) WHERE fid = '||v_fid||' AND cur_user = current_user)a
							JOIN
							(SELECT json_array_elements_text((grafconfig->>''use'')::json)::json->>''nodeParent'' as node_id,
							json_array_elements_text((json_array_elements_text((grafconfig->>''use'')::json)::json->>''toArc'')::json) as arc_id, '||quote_ident(v_fieldmp)||' FROM '||quote_ident(v_table)||') b
							USING (node_id, arc_id)
							LIMIT 1'
							INTO v_floodfromnode;
														
						-- update results
						UPDATE anl_arc SET descript = v_floodfromnode WHERE fid = v_fid;
						UPDATE anl_node SET descript = v_floodfromnode WHERE fid = v_fid;

					END IF;			

					-- update arc table
					v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = b.'||quote_ident(v_fieldmp)||' FROM anl_arc a JOIN 
							(SELECT '||quote_ident(v_fieldmp)||', json_array_elements_text((grafconfig->>''use'')::json)::json->>''nodeParent'' as nodeparent from '||
							quote_ident(v_table)||') b
							 ON  nodeparent = descript WHERE fid='||v_fid||' AND a.arc_id=arc.arc_id AND cur_user=current_user';
					EXECUTE v_querytext;

					-- update node table without graf nodes using node with from v_edit_arc because the exploitation filter. Row before do not needed because table anl_* is filtered by process
					v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM v_edit_arc a WHERE a.arc_id=node.arc_id';
					EXECUTE v_querytext;

					-- update node table with graf nodes
					v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = b.'||quote_ident(v_fieldmp)||' 
							FROM anl_node a join (SELECT  '||quote_ident(v_fieldmp)||', json_array_elements_text((grafconfig->>''use'')::json)::json->>''nodeParent'' 
							as nodeparent from '
							||quote_ident(v_table)||') b ON  nodeparent = descript WHERE fid='||v_fid||' AND a.node_id=node.node_id
							AND cur_user=current_user';
					EXECUTE v_querytext;

					-- used connec using v_edit_arc because the exploitation filter (same before)
					v_querytext = 'UPDATE connec SET '||quote_ident(v_field)||' = a.'||quote_ident(v_field)||' FROM v_edit_arc a WHERE a.arc_id=connec.arc_id';
					EXECUTE v_querytext;
				
					-- recalculate staticpressure (fid=147)
					IF v_fid=146 THEN
					
						DELETE FROM audit_log_data WHERE fid=147 AND cur_user=current_user;
				
						INSERT INTO audit_log_data (fid, feature_type, feature_id, log_message)
						SELECT 147, 'node', n.node_id, 
						concat('{"staticpressure":',case when (pz.head - n.elevation::float + (case when n.depth is null then 0 else n.depth end)::float) is null 
						then 0 ELSE (pz.head - n.elevation::float + (case when n.depth is null then 0 else n.depth end)) END,
						', "nodeparent":"',anl_node.descript,'"}')
						FROM node n 
						JOIN anl_node USING (node_id)
						JOIN 
						(select head, json_array_elements_text((grafconfig->>'use')::json)::json->>'nodeParent' as node_id from presszone) pz ON pz.node_id = anl_node.descript
						WHERE fid=146 AND cur_user=current_user;

						-- update on node table those elements connected on graf
						UPDATE node SET staticpressure=(log_message::json->>'staticpressure')::float FROM audit_log_data a WHERE a.feature_id=node_id 
						AND fid=147 AND cur_user=current_user;
						
						-- update on node table those elements disconnected from graf
						UPDATE node SET staticpressure=(staticpress1-(staticpress1-staticpress2)*st_linelocatepoint(v_edit_arc.the_geom, n.the_geom))::numeric(12,3)
										FROM v_edit_arc,node n
										WHERE st_dwithin(v_edit_arc.the_geom, n.the_geom, 0.05::double precision) AND v_edit_arc.state = 1 AND n.state = 1
										and n.arc_id IS NOT NULL AND node.node_id=n.node_id;
												
						-- updat connec table
						UPDATE v_edit_connec SET staticpressure =(a.head - a.elevation + (case when a.depth is null then 0 else a.depth end)::float) FROM 
							(SELECT connec_id, head, elevation, depth FROM connec
							JOIN presszone USING (presszone_id)) a
							WHERE v_edit_connec.connec_id=a.connec_id;
					END IF;

					IF v_floodfromnode IS NULL THEN
					
						-- disconnected arcs
						SELECT count(*) INTO v_count FROM v_edit_arc WHERE arc_id NOT IN 
						(SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid);
						INSERT INTO audit_check_data (fid, criticity, error_message)
						VALUES (v_fid, 2, concat('WARNING: ', v_count ,' arcs have been disconnected'));

						-- disconnected connecs
						SELECT count(*) INTO v_count FROM v_edit_connec c WHERE arc_id NOT IN 
						(SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid);
						INSERT INTO audit_check_data (fid, criticity, error_message)
						VALUES (v_fid, 2, concat('WARNING: ', v_count ,' connecs have been disconnected'));

					END IF;
				ELSE
					-- message
					INSERT INTO audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 1, concat(
					'INFO: Mapzone attribute on arc/node/connec features keeps same value previous function. Nothing have been updated by this process'));
					INSERT INTO audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 1, concat('INFO: To see results you can query using this values (XX): SECTOR:130, DQA:144, DMA:145, PRESSZONE:146, STATICPRESSURE:147 '));
					INSERT INTO audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 1, concat('SELECT * FROM anl_arc WHERE fid = (XX) AND cur_user=current_user;'));
					INSERT INTO audit_check_data (fid ,criticity, error_message)
					VALUES (v_fid, 1, concat('SELECT * FROM anl_node WHERE fid = (XX) AND cur_user=current_user;'));
				END IF;

				-- update geometry of mapzones
				IF v_updatemapzgeom = 0 THEN
					-- do nothing
				ELSIF  v_updatemapzgeom = 1 THEN
				
					-- concave polygon
					v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = st_multi(a.the_geom) 
							FROM (with polygon AS (SELECT st_collect (the_geom) as g, '||quote_ident(v_field)||' FROM v_edit_arc group by '||quote_ident(v_field)||') 
							SELECT '||quote_ident(v_field)||
							', CASE WHEN st_geometrytype(st_concavehull(g, '||v_concavehull||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||
							v_concavehull||'), 3)::geometry(Polygon,'||(v_srid)||')
							ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||(v_srid)||') END AS the_geom FROM polygon
							)a WHERE a.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp)||' AND '||quote_ident(v_table)||'.'||
							quote_ident(v_fieldmp)||'::text != 0::text';
							
					EXECUTE v_querytext;

				ELSIF  v_updatemapzgeom = 2 THEN
				
					-- pipe buffer
					v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = geom FROM
							(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(the_geom),'||v_geomparamupdate||')) as geom from v_edit_arc where '||
							quote_ident(v_field)||'::text != ''0'' AND v_edit_arc.'||quote_ident(v_field)||' IN
							(SELECT DISTINCT '||quote_ident(v_field)||' FROM v_edit_arc JOIN anl_arc USING (arc_id) WHERE fid = '||v_fid||' and cur_user = current_user)
							group by '||quote_ident(v_field)||')a 
							WHERE a.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp);

							/*
							UPDATE arc set the_geom = geom FROM (
								SELECT dma_id, st_multi(st_buffer(st_collect(the_geom),10)) as geom from v_edit_arc where dma_id::integer > 0 AND v_edit_arc.dma_id IN
								(SELECT DISTINCT dma_id FROM v_edit_arc JOIN anl_arc USING (arc_id) WHERE fid = 145 and cur_user = current_user)
								GROUP BY dma_id
							)a WHERE a.dma_id=dma.dma_id;
							*/

					EXECUTE v_querytext;

				ELSIF  v_updatemapzgeom = 3 THEN
				
					-- use plot and pipe buffer
					v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = geom FROM
								(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
								(SELECT '||quote_ident(v_field)||', st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from v_edit_arc 
								where '||quote_ident(v_field)||'::text != ''0'' AND v_edit_arc.'||quote_ident(v_field)||' IN
								(SELECT DISTINCT '||quote_ident(v_field)||' FROM v_edit_arc JOIN anl_arc USING (arc_id) WHERE fid = '||v_fid||' and cur_user = current_user)
								group by '||quote_ident(v_field)||'
								UNION
								SELECT '||quote_ident(v_field)||', st_collect(ext_plot.the_geom) as geom FROM v_edit_connec, ext_plot
								WHERE '||quote_ident(v_field)||'::text != ''0'' 
								AND v_edit_connec.'||quote_ident(v_field)||' IN
								(SELECT DISTINCT '||quote_ident(v_field)||' FROM v_edit_arc JOIN anl_arc USING (arc_id) WHERE fid = '||v_fid||' and cur_user = current_user)
								AND st_dwithin(v_edit_connec.the_geom, ext_plot.the_geom, 0.001)
								group by '||quote_ident(v_field)||'	
								)a group by '||quote_ident(v_field)||')b 
							WHERE b.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp);

							/*
							UPDATE arc set the_geom = geom FROM(
								SELECT dma_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
								(SELECT dma_id, st_buffer(st_collect(the_geom), 10) as geom from v_edit_arc 
								where dma_id::integer > 0 AND v_edit_arc.dma_id IN
								(SELECT DISTINCT dma_id FROM v_edit_arc JOIN anl_arc USING (arc_id) WHERE fid = 145 and cur_user = current_user)
								group by dma_id
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
			
					-- use link and pipe buffer
					v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = geom FROM
							(SELECT '||quote_ident(v_field)||', st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
							(SELECT '||quote_ident(v_field)||', st_buffer(st_collect(the_geom), '||v_geomparamupdate||') as geom from arc 
							where '||quote_ident(v_field)||'::text != ''0'' AND arc.'||quote_ident(v_field)||' IN
							(SELECT DISTINCT '||quote_ident(v_field)||' FROM arc JOIN anl_arc USING (arc_id) WHERE fid = '||v_fid||' and cur_user = current_user)
							group by '||quote_ident(v_field)||'
							UNION
							SELECT c.'||quote_ident(v_field)||', (st_buffer(st_collect(link.the_geom),'||v_geomparamupdate||'/2)) 
							as geom FROM connec c, v_edit_link link
							WHERE c.'||quote_ident(v_field)||'::text != ''0'' 
							AND c.state > 0
							AND c.'||quote_ident(v_field)||' IN
							(SELECT DISTINCT '||quote_ident(v_field)||' FROM arc JOIN anl_arc USING (arc_id) WHERE fid = '||v_fid||' and cur_user = current_user)
							AND link.feature_id = connec_id and link.feature_type = ''CONNEC''
							group by c.'||quote_ident(v_field)||'	
							)a group by '||quote_ident(v_field)||')b 
						WHERE b.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp);

						/*
						UPDATE dma set the_geom = geom FROM
							(
							SELECT dma_id, st_multi(st_buffer(st_collect(geom),0.01)) as geom FROM
							(SELECT dma_id, st_buffer(st_collect(the_geom), 5) as geom from arc 
							where dma_id::text != '0' AND arc.dma_id IN
							(SELECT DISTINCT dma_id FROM arc JOIN anl_arc USING (arc_id) WHERE fid = 145 and cur_user = current_user)
							group by dma_id
							UNION
							SELECT c.dma_id, (st_buffer(st_collect(link.the_geom),5/2)) 
							as geom FROM v_edit_link link, connec c
							WHERE c.dma_id::text != '0' 
							AND c.dma_id IN
							(SELECT DISTINCT dma_id FROM v_edit_arc JOIN anl_arc USING (arc_id) WHERE fid = 145 and cur_user = current_user)
							AND link.feature_id = connec_id and link.feature_type = 'CONNEC'
							group by c.dma_id	
							)a group by dma_id
							)b 
						WHERE b.dma_id=dma.dma_id
						*/

					EXECUTE v_querytext;
				END IF;

				-- check for intercomunicated mapzones (select if at least one node header has different mazpones from what is configured)
				EXECUTE 'INSERT INTO audit_check_data (fid,  criticity, error_message)
				SELECT '||v_fid||', 3, concat(''OVERLAPED '||v_class||'s: Node '', mpz.node_id ,'' is header of '||v_class||''',''-'', mpz.'||
				v_field||', '' ('',mpz.name,'') but it is assigned to '||v_class||' '', ''-'', n.'||v_field||','' ('',mpz.name,'')'') FROM v_edit_node n
				JOIN 
				(SELECT json_array_elements_text((grafconfig->>''use'')::json)::json->>''nodeParent'' as node_id, '||v_field||', name FROM '||v_table||') mpz
				USING (node_id)
				WHERE n.'||v_field||' != mpz.'||v_field||'';	
					
				IF v_updatemapzgeom > 0 THEN
					-- message
					INSERT INTO audit_check_data (fid, criticity, error_message)
					VALUES (v_fid, 1, concat('INFO: Geometry of mapzone ',v_class ,' have been modified by this process'));
				END IF;

				-- insert spacer for warning and info
				INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  3, '');
				INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  2, '');
				INSERT INTO audit_check_data (fid,  criticity, error_message) VALUES (v_fid,  1, '');
			END IF;
		END IF;
	END IF;
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	IF v_updatetattributes THEN -- only disconnected features to make a simple log


		IF v_floodfromnode IS NULL THEN
			v_result = null;

			-- disconnected arcs
			SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
			SELECT jsonb_build_object(
		     'type',       'Feature',
		    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		    'properties', to_jsonb(row) - 'the_geom'
			) AS feature
			FROM (SELECT arc_id, arccat_id, state, expl_id, 'Disconnected arc'::text as descript, the_geom FROM v_edit_arc WHERE arc_id NOT IN 
			(SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid)) row) features;

			v_result := COALESCE(v_result, '{}'); 
			v_result_line = concat ('{"geometryType":"LineString", "qmlPath":"", "features":',v_result,'}'); 

			-- disconnected connecs
			v_result = null;
			
			SELECT jsonb_agg(features.feature) INTO v_result
			FROM (
			SELECT jsonb_build_object(
		     'type',       'Feature',
		    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		    'properties', to_jsonb(row) - 'the_geom'
			) AS feature
			FROM (SELECT connec_id, connecat_id, c.state, c.expl_id, 'Disconnected connec'::text as descript, c.the_geom FROM v_edit_connec c WHERE arc_id NOT IN 
			(SELECT arc_id FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid)) row) features;

			v_result := COALESCE(v_result, '{}'); 
			v_result_point = concat ('{"geometryType":"Point", "qmlPath":"", "features":',v_result, '}'); 
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
	  	FROM (SELECT a.arc_id, b.'||quote_ident(v_field)||', a.the_geom FROM anl_arc a 
			JOIN (SELECT '||quote_ident(v_fieldmp)||', json_array_elements_text((grafconfig->>''use'')::json)::json->>''nodeParent'' as nodeparent from '||
			quote_ident(v_table)||') b ON  nodeparent = descript 
			WHERE fid='||v_fid||' AND cur_user=current_user) row) features'
		INTO v_result;

		v_result := COALESCE(v_result, '{}'); 

		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');

		-- connec elements
		v_result = null;
		EXECUTE 'SELECT jsonb_agg(features.feature)
		FROM (
	  	SELECT jsonb_build_object(
	    ''type'',       ''Feature'',
	    ''geometry'',   ST_AsGeoJSON(the_geom)::jsonb,
	    ''properties'', to_jsonb(row) - ''the_geom''
	  	) AS feature
	  	FROM (SELECT c.connec_id, b.'||quote_ident(v_field)||', c.the_geom FROM anl_arc a 
			JOIN (SELECT  '||quote_ident(v_fieldmp)||', json_array_elements_text((grafconfig->>''use'')::json)::json->>''nodeParent'' as nodeparent from '||quote_ident(v_table)||')
			 b ON  nodeparent = descript 
			JOIN connec c ON c.arc_id = a.arc_id
			WHERE fid='||v_fid||' AND cur_user=current_user) row) features'
		INTO v_result;

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
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_visible_layer := COALESCE(v_visible_layer, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN  gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}, "data":{ "info":'||v_result_info||','||
					  '"setVisibleLayers":["'||v_visible_layer||'"],'||
  					  '"setStyle":"Mapzones",'||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||
					  '}}}')::json, 2710);

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' ||
	to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;