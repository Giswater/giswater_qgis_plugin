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
TO CONFIGURE
set graf_delimiter field on node_type table
set to_arc on anl_mincut_inlet_x_macroexploitation (for SECTORs)
set to_arc on tables inp_valve (for presszone), inp_pump (for presszone), inp_shortpipe (for DQA, DMA)


update arc set sector_id=0, dma_id=0, dqa_id=0, presszonecat_id=0;
update node set sector_id=0, dma_id=0, dqa_id=0,  presszonecat_id=0;
update connec set sector_id=0, dma_id=0, dqa_id=0, presszonecat_id=0

TO EXECUTE
-- for any exploitation you want
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"PRESSZONE","exploitation":"[1,2]",
"updateFeature":"TRUE","updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DQA", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","concaveHullParam":0.85}}}');

SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"SECTOR", "exploitation": "[1,2]", 
"updateFeature":"TRUE", "updateMapZone":"TRUE","concaveHullParam":0.85}}}');


-- for one specific node
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"PRESSZONE", "node":"113952", "updateFeature":TRUE}}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DQA", "node":"113952", "updateFeature":TRUE}}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"DMA", "node":"113952", "updateFeature":TRUE}}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"SECTOR", "node":"113952", "updateFeature":TRUE}}}');


TO SEE RESULTS ON LOG TABLE
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=48 AND user_name=current_user group by log_message order by 2 --PZONE
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=44 AND user_name=current_user group by log_message order by 2 --DQA
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=45 AND user_name=current_user group by log_message order by 2 --DMA
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=30 AND user_name=current_user group by log_message order by 2 --SECTOR


TO SEE RESULTS ON SYSTEM TABLES (IN CASE OF "updateFeature":"TRUE")
SELECT presszonecat_id, count(presszonecat_id) from v_edit_arc  group by presszonecat_id order by 1;
SELECT dma_id, count(dma_id) from v_edit_arc  group by dma_id order by 1;
SELECT dqa_id, count(dma_id) from v_edit_arc  group by dqa_id order by 1;
SELECT sector_id, count(sector_id) from v_edit_arc group by sector_id order by 1;
*/

DECLARE

affected_rows 		numeric;
cont1 				integer default 0;
v_cont1 			integer default 0;
v_class 			text;
v_feature 			record;
v_expl 				json;
v_data 				json;
v_fprocesscat_id 	integer;
v_nodeid 			text;
v_featureid 		integer;
v_text 				text;
v_querytext 		text;
v_updatetattributes boolean;
v_updatemapzgeom	boolean;
v_result_info 		json;
v_result_point		json;
v_result_line 		json;
v_result_polygon	json;
v_result 			text;
v_count				json;
v_version			text;
v_table				text;
v_field 			text;
v_fieldmp 			text;
v_srid 				integer;
v_concavehull		float;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'grafClass');
	v_nodeid = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'node');
	v_updatetattributes = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateFeature');
	v_updatemapzgeom = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'updateMapZone');
	v_concavehull = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'concaveHullParam');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');

	-- select config values
	SELECT giswater, epsg INTO v_version, v_srid FROM version order by 1 desc limit 1;

	-- set fprocesscat
	IF v_class = 'PRESSZONE' THEN 
		v_fprocesscat_id=46;
		v_table = 'cat_presszone';
		v_field = 'presszonecat_id';
		v_fieldmp = 'id';
		
	ELSIF v_class = 'DMA' THEN 
		v_fprocesscat_id=45; 
		v_table = 'dma';
		v_field = 'dma_id';
		v_fieldmp = 'dma_id';
		
	ELSIF v_class = 'DQA' THEN 
		v_fprocesscat_id=44;
		v_table = 'dqa';
		v_field = 'dqa_id';
		v_fieldmp = 'dqa_id';
		
	ELSIF v_class = 'SECTOR' THEN 
		v_fprocesscat_id=30; 
		v_table = 'sector';
		v_field = 'sector_id';
		v_fieldmp = 'sector_id';
	END IF;

	-- reset graf & audit_log tables
	DELETE FROM anl_arc where cur_user=current_user and fprocesscat_id=v_fprocesscat_id;
	DELETE FROM anl_node where cur_user=current_user and fprocesscat_id=v_fprocesscat_id;
	DELETE FROM anl_graf where user_name=current_user;
	DELETE FROM audit_check_data WHERE fprocesscat_id=v_fprocesscat_id AND user_name=current_user;

	-- Starting process
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, concat('MAPZONES DYNAMIC SECTORITZATION - ', upper(v_class)));
	INSERT INTO audit_check_data (fprocesscat_id, error_message) VALUES (v_fprocesscat_id, concat('----------------------------------------------------------'));
	
	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	DELETE FROM selector_pSECTOR WHERE cur_user=current_user;
	
	-- reset exploitation
	IF v_expl IS NOT NULL THEN
		DELETE FROM selector_expl WHERE cur_user=current_user;
		INSERT INTO selector_expl (expl_id, cur_user) SELECT expl_id, current_user FROM exploitation where macroexpl_id IN 
		(SELECT distinct(macroexpl_id) FROM exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl)a  ON expl=expl_id);
	END IF;

	-- create graf
	INSERT INTO anl_graf ( grafclass, arc_id, node_1, node_2, water, flag, checkf, user_name )
	SELECT  v_class, arc_id, node_1, node_2, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT  v_class, arc_id, node_2, node_1, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;

	-- set boundary conditions of graf table	
	IF v_class = 'PRESSZONE' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'',''PRESSZONE'')';
	
	ELSIF v_class = 'DMA' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'',''DMA'')';

	ELSIF v_class = 'DQA' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'',''DQA'')';

	ELSIF v_class = 'SECTOR' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'')';
	END IF;

		-- close boundary conditions setting flag=1 for all nodes that fits on graf delimiters and closed valves
		v_querytext  = 'UPDATE anl_graf SET flag=1 WHERE 
				node_1 IN('||v_text||' UNION
				SELECT (a.node_id) FROM node a 	JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id 
				LEFT JOIN man_valve d ON a.node_id=d.node_id JOIN anl_graf e ON a.node_id=e.node_1 WHERE (graf_delimiter=''MINSECTOR'' AND closed=TRUE))
				OR node_2 IN ('||v_text||' UNION
				SELECT (a.node_id) FROM node a 	JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id 
				LEFT JOIN man_valve d ON a.node_id=d.node_id JOIN anl_graf e ON a.node_id=e.node_1 WHERE (graf_delimiter=''MINSECTOR'' AND closed=TRUE))
				AND user_name=current_user';
	
		EXECUTE v_querytext;

		-- open boundary conditions enabling sense for graf delimiters allowed on inp_pump/inp_valve/inp_shortpipe/inp_inlet tables
		UPDATE anl_graf SET flag=0 WHERE id IN ( SELECT id FROM anl_graf JOIN inp_pump ON to_arc = arc_id WHERE node_1=node_id) AND user_name=current_user;
		UPDATE anl_graf SET flag=0 WHERE id IN ( SELECT id FROM anl_graf JOIN inp_valve ON to_arc = arc_id WHERE node_1=node_id AND user_name=current_user);
		UPDATE anl_graf SET flag=0 WHERE id IN ( SELECT id FROM anl_graf JOIN inp_shortpipe ON to_arc = arc_id WHERE node_1=node_id) AND user_name=current_user;
		UPDATE anl_graf SET flag=0 WHERE id IN (SELECT id FROM anl_graf JOIN inp_inlet ON to_arc  = arc_id WHERE node_1=node_id 
		UNION SELECT id FROM anl_graf JOIN inp_reservoir ON to_arc  = arc_id WHERE node_1=node_id) AND user_name=current_user;

	-- starting process
	LOOP
	
		EXIT WHEN v_cont1 = -1;
		v_cont1 = v_cont1+1;
		
		IF v_nodeid IS NULL THEN
			v_querytext = 'SELECT * FROM ('||v_text||' AND checkf=0 LIMIT 1)a';
			IF v_querytext IS NOT NULL THEN
				EXECUTE v_querytext INTO v_feature;
			END IF;

			v_featureid = v_feature.node_id;
			EXIT WHEN v_featureid IS NULL;
			
		ELSIF v_nodeid IS NOT NULL THEN
			v_featureid = v_nodeid;
			v_cont1 = -1;
		END IF;

		raise notice 'v_querytext %', v_querytext;

		-- reset water flag
		UPDATE anl_graf SET water=0 WHERE user_name=current_user AND grafclass=v_class;
			
		------------------
		-- starting engine

		-- set the starting element (water)
		v_querytext = 'UPDATE anl_graf SET water=1 WHERE node_1='||quote_literal(v_featureid)||'  
		AND flag=0 AND anl_graf.user_name=current_user AND grafclass='||quote_literal(v_class); 
		EXECUTE v_querytext;

		-- set the starting element (check)
		v_querytext = 'UPDATE anl_graf SET checkf=1 WHERE node_1='||quote_literal(v_featureid)||'  
		AND anl_graf.user_name=current_user AND grafclass='||quote_literal(v_class); 
		EXECUTE v_querytext;

		cont1 = 0;

		-- inundation process
		LOOP	
			cont1 = cont1+1;
			
			UPDATE anl_graf n SET water= 1, flag=n.flag+1, checkf=1 FROM v_anl_graf a where n.node_1 = a.node_1 AND n.arc_id = a.arc_id AND n.grafclass=v_class;
			
			GET DIAGNOSTICS affected_rows =row_count;
			EXIT WHEN affected_rows = 0;
			EXIT WHEN cont1 = 200;
			raise notice 'cont1 FINAL % v_feature %', cont1, v_featureid;
		END LOOP;
		
		-- finish engine
		----------------
		
		-- insert arc results into audit table	
		EXECUTE 'INSERT INTO anl_arc (fprocesscat_id, arccat_id, arc_id, the_geom, descript) 
			SELECT  DISTINCT ON (arc_id) '||v_fprocesscat_id||', arccat_id, a.arc_id, the_geom, '||(v_featureid)||' 
			FROM (SELECT arc_id FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' AND user_name=current_user AND water=1) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';

		-- insert node results into audit table
		EXECUTE 'INSERT INTO anl_node (fprocesscat_id, nodecat_id, node_id, the_geom, descript) 
			SELECT DISTINCT ON (node_id) '||v_fprocesscat_id||', nodecat_id, b.node_id, the_geom, '||(v_featureid)||' FROM (SELECT node_1 as node_id FROM anl_graf 
			WHERE water >0 AND grafclass='||quote_literal(v_class)||' AND user_name=current_user)a
			JOIN v_edit_node b USING (node_id)';
			
		-- message
		SELECT count(*) INTO v_count FROM anl_arc WHERE fprocesscat_id=v_fprocesscat_id AND descript=v_featureid::text AND cur_user=current_user;
		
		INSERT INTO audit_check_data (fprocesscat_id, error_message) 
		VALUES (v_fprocesscat_id, concat('INFO: Mapzone type ', v_class ,' for node: ',v_featureid ,' have been identified. Total number of arcs is :', v_count));

		raise notice 'PROCESS % FEATURE % COUNT % CLASS %', v_fprocesscat_id, v_featureid, v_count, v_class;

	END LOOP;

	-- update feature atributes
	IF v_updatetattributes THEN 

		-- upsert arc table
		v_querytext = 'UPDATE arc SET '||quote_ident(v_field)||' = b.'||quote_ident(v_fieldmp)||' 
				FROM anl_arc a join (SELECT '||quote_ident(v_fieldmp)||', json_array_elements_text(nodeparent) as nodeparent from '
				||quote_ident(v_table)||') b	ON  nodeparent = descript WHERE fprocesscat_id='||v_fprocesscat_id||' AND a.arc_id=arc.arc_id AND cur_user=current_user';
		EXECUTE v_querytext;

		-- upsert node table
		v_querytext = 'UPDATE node SET '||quote_ident(v_field)||' = b.'||quote_ident(v_fieldmp)||' 
				FROM anl_node a join (SELECT  '||quote_ident(v_fieldmp)||', json_array_elements_text(nodeparent) as nodeparent from '
				||quote_ident(v_table)||') b ON  nodeparent = descript WHERE fprocesscat_id='||v_fprocesscat_id||' AND a.node_id=node.node_id AND cur_user=current_user';
		EXECUTE v_querytext;

		-- used v_edit_connec to the exploitation filter. Rows before is not neeeded because on table anl_* is data filtered by the process...
		v_querytext = 'UPDATE v_edit_connec SET '||quote_ident(v_field)||' = arc.'||quote_ident(v_field)||' FROM arc WHERE arc.arc_id=v_edit_connec.arc_id';
		EXECUTE v_querytext;

		-- recalculate staticpressure (fprocesscat_id=47)
		IF v_fprocesscat_id=30 THEN 
		
			DELETE FROM audit_log_data WHERE fprocesscat_id=47 AND user_name=current_user;
	
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) SELECT 47, 'node', n.node_id, 
			concat('{"staticpressure":',(a.elevation - n.elevation::float), ', "nodeparent":"',anl_node.descript,'"}')
			FROM node n 
			JOIN anl_node USING (node_id) 
			JOIN node a ON a.node_id=anl_node.descript
			WHERE fprocesscat_id=30 AND cur_user=current_user;

			-- update staticpressure on node / connec tables
			UPDATE node SET staticpressure=(log_message::json->>'staticpressure')::float FROM audit_log_data a WHERE a.feature_id=node_id AND fprocesscat_id=47 AND user_name=current_user;

			UPDATE v_edit_connec SET staticpressure = (b.elevation-v_edit_connec.elevation) FROM 
				(SELECT connec_id, a.elevation FROM connec JOIN (SELECT a.sector_id, node_id, elevation FROM 
					(SELECT json_array_elements_text(nodeparent) as node_id, sector_id FROM sector)a JOIN node USING (node_id))a
				USING (sector_id)) b
				WHERE v_edit_connec.connec_id=b.connec_id;
		END IF;

		-- message
		INSERT INTO audit_check_data (fprocesscat_id, error_message) 
		VALUES (v_fprocesscat_id, concat('WARNING: Attribute ', v_class ,' on arc/node/connec features have been updated by this process'));

	END IF;

	-- update geometry of mapzones
	IF v_updatemapzgeom THEN

		v_querytext = '	UPDATE '||quote_ident(v_table)||' set the_geom = st_multi(a.the_geom) 
				FROM (with polygon AS (SELECT st_collect (the_geom) as g, '||quote_ident(v_field)||' FROM arc group by '||quote_ident(v_field)||') 
				SELECT '||quote_ident(v_field)||
				', CASE WHEN st_geometrytype(st_concavehull(g, '||v_concavehull||')) = ''ST_Polygon''::text THEN st_buffer(st_concavehull(g, '||
				v_concavehull||'), 3)::geometry(Polygon,'||(v_srid)||')
				ELSE st_expand(st_buffer(g, 3::double precision), 1::double precision)::geometry(Polygon,'||(v_srid)||') END AS the_geom FROM polygon
				)a WHERE a.'||quote_ident(v_field)||'='||quote_ident(v_table)||'.'||quote_ident(v_fieldmp);

		EXECUTE v_querytext;	

		-- message
		INSERT INTO audit_check_data (fprocesscat_id, error_message) 
		VALUES (v_fprocesscat_id, concat('WARNING: Geometry of mapzone ',v_class ,' have been modified by this process'));
	END IF;

	-- set selector
	DELETE FROM selector_audit WHERE cur_user=current_user;
	INSERT INTO selector_audit (fprocesscat_id, cur_user) VALUES (v_fprocesscat_id, current_user);
	

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=v_fprocesscat_id order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	/*
	-- points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=v_fprocesscat_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

	-- lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=v_fprocesscat_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');

	-- polygons
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, pol_id, pol_type, state, expl_id, descript, the_geom FROM anl_polygon WHERE cur_user="current_user"() AND fprocesscat_id=v_fprocesscat_id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_polygon = concat ('{"geometryType":"Polygon", "values":',v_result, '}');

	*/
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}');
	

--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Mapzones dynamic analysis done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}, "data":{ "info":'||v_result_info||'}}}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
