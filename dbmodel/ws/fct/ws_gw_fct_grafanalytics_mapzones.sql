/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2710

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mapzones(p_data json)
RETURNS integer AS
$BODY$

/*
TO CONFIGURE
set graf_delimiter field on node_type table
set to_arc on anl_mincut_inlet_x_macroexploitation (for sectors)
set to_arc on tables inp_valve (for presszone), inp_pump (for presszone), inp_shortpipe (for dqa, dma)


TO EXECUTE
-- for any exploitation you want
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"presszone", "exploitation": "[1,2]"}, "upsertFeature":TRUE}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"dma", "exploitation": "[1,2]"}, "upsertFeature":TRUE}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"dqa", "exploitation": "[1,2]"}, "upsertFeature":TRUE}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"sector", "exploitation": "[1,2]"}, "upsertFeature":TRUE}}');

-- for one specific node
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"presszone", "node":"113952"}, "upsertFeature":TRUE}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"dqa", "node":"113952"}, "upsertFeature":TRUE}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"dma", "node":"113952"}, "upsertFeature":TRUE}}');
SELECT gw_fct_grafanalytics_mapzones('{"data":{"parameters":{"grafClass":"sector", "node":"113952"}, "upsertFeature":TRUE}}');


TO SEE RESULTS ON LOG TABLE
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=48 AND user_name=current_user group by log_message order by 2 --PZONE
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=44 AND user_name=current_user group by log_message order by 2 --dqa
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=45 AND user_name=current_user group by log_message order by 2 --dma
SELECT count(*), log_message FROM audit_log_data WHERE fprocesscat_id=30 AND user_name=current_user group by log_message order by 2 --sector


TO SEE RESULTS ON SYSTEM TABLES (IN CASE OF "upsertFeature":"TRUE")
SELECT count(presszonecat_id), presszonecat_id from v_edit_arc  group by presszonecat_id
SELECT count(dma_id), dma_id from v_edit_arc  group by dma_id
SELECT count(dma_id), dma_id from v_edit_node  group by dma_id
SELECT count(sector_id), sector_id from v_edit_arc group by sector_id
SELECT count(sector_id), sector_id from v_edit_node group by sector_id
SELECT count(value_param) , value_param from man_addfields_value WHERE parameter_id=57 group by value_param -- dqa (pipes)
*/

DECLARE

affected_rows numeric;
cont1 integer default 0;
v_cont1 integer default 0;
v_class text;
v_feature record;
v_expl json;
v_data json;
v_fprocesscat integer;
v_addparam record;
v_attribute text;
v_nodeid text;
v_featureid integer;
v_text text;
v_querytext text;
v_upsertattributes boolean;
v_mapzone integer;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_class = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'grafClass');
	v_nodeid = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'node');
	v_upsertattributes = (SELECT ((p_data::json->>'data')::json->>'upsertFeature');
	v_expl = (SELECT ((p_data::json->>'data')::json->>'parameters')::json->>'exploitation');

	-- set fprocesscat
	IF v_class = 'presszone' THEN v_fprocesscat=46; 
	ELSIF v_class = 'dma' THEN v_fprocesscat=45; 
	ELSIF v_class = 'dqa' THEN v_fprocesscat=44;
	ELSIF v_class = 'sector' THEN v_fprocesscat=30; 
	END IF;

	-- reset graf & audit_log tables
	DELETE FROM anl_graf where user_name=current_user;
	DELETE FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat AND user_name=current_user;

	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	DELETE FROM selector_psector WHERE cur_user=current_user;
	
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
	IF v_class = 'presszone' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''sector'',''presszone'')';
	
	ELSIF v_class = 'dma' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''sector'',''dma'')';

	ELSIF v_class = 'dqa' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''sector'',''dqa'')';

	ELSIF v_class = 'sector' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''sector'')';

	END IF;


		-- update boundary conditions setting flag=2 for all nodes that fits on graf delimiters and closed valves
		v_querytext  = 'UPDATE anl_graf SET flag=2 WHERE node_1 IN('||v_text||' UNION
				SELECT (a.node_id) FROM node a 	JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id 
				LEFT JOIN man_valve d ON a.node_id=d.node_id JOIN anl_graf e ON a.node_id=e.node_1 WHERE (graf_delimiter=''MINsector'' AND closed=TRUE))';
	
		RAISE NOTICE 'v_querytext %', v_querytext;
		
		EXECUTE v_querytext;

		-- open boundary conditions enabling sense for graf delimiters allowed on inp_pump/inp_valve/inp_shortpipe/inlet_x_exps tables
		UPDATE anl_graf SET flag=0 WHERE id IN ( SELECT id FROM anl_graf JOIN inp_pump ON to_arc = arc_id WHERE node_1=node_id);
		UPDATE anl_graf SET flag=0 WHERE id IN ( SELECT id FROM anl_graf JOIN inp_valve ON to_arc = arc_id WHERE node_1=node_id);
		UPDATE anl_graf SET flag=0 WHERE id IN ( SELECT id FROM anl_graf JOIN inp_shortpipe ON to_arc = arc_id WHERE node_1=node_id);
		UPDATE anl_graf SET flag=0 WHERE id IN (SELECT id FROM anl_graf JOIN (SELECT node_id, json_array_elements_text(to_arc) as to_arc 
		FROM anl_mincut_inlet_x_exploitation)a ON to_arc = arc_id WHERE node_1=node_id);

	-- starting process
	LOOP
	
		EXIT WHEN v_cont1 = -1;
		v_cont1 = v_cont1+1;
		
		IF v_nodeid IS NULL THEN
			v_querytext = 'SELECT * FROM ('||v_text||' AND checkf=0 LIMIT 1)a';
			IF v_querytext IS NOT NULL THEN
				EXECUTE v_querytext INTO v_feature;
			END IF;
			raise notice 'v_querytext %',v_querytext;
			v_featureid = v_feature.node_id;
			EXIT WHEN v_featureid IS NULL;
			
		ELSIF v_nodeid IS NOT NULL THEN
			v_featureid = v_nodeid;
			v_cont1 = -1;
		END IF;

		-- reset water flag
		UPDATE anl_graf SET water=0 WHERE user_name=current_user AND grafclass=v_class;
			
		------------------
		-- starting engine

		-- set the starting element
		v_querytext = 'UPDATE anl_graf SET flag=flag+1, water=1, checkf=1 WHERE node_1='||quote_literal(v_featureid)||'  
		AND anl_graf.user_name=current_user AND grafclass='||quote_literal(v_class); 
		EXECUTE v_querytext;

		-- inundation process
		LOOP	
			cont1 = cont1+1;
			UPDATE anl_graf n SET water= 1, flag=n.flag+1, checkf=1 FROM v_anl_graf a where flagi < 3 AND n.node_1 = a.node_1 AND n.arc_id = a.arc_id AND n.grafclass=v_class;
			GET DIAGNOSTICS affected_rows =row_count;
			EXIT WHEN affected_rows = 0;
			EXIT WHEN cont1 = 200;
		END LOOP;
		-- finish engine
		----------------
		
		-- insert arc results into audit table
		raise notice '% % %', v_fprocesscat, v_featureid, v_class;
		EXECUTE 'INSERT INTO anl_arc (fprocesscat_id, arccat_id, arc_id, the_geom, descript) 
			SELECT '||v_fprocesscat||', arccat_id, a.arc_id, the_geom, '||(v_featureid)||' 
			FROM (SELECT arc_id, max(water) as water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' AND user_name=current_user
			AND water=1 GROUP by arc_id, flag having flag < 3) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';

		-- insert node results into audit table
		EXECUTE 'INSERT INTO anl_node (fprocesscat_id, nodecat_id, node_id, the_geom, descript) 
			SELECT '||v_fprocesscat||', nodecat_id, b.node_id, the_geom, '||(v_featureid)||' FROM (SELECT node_1 as node_id FROM anl_graf 
			WHERE water >0 AND grafclass='||quote_literal(v_class)||' AND user_name=current_user)a
			JOIN v_edit_node b USING (node_id)';
				
	END LOOP;
	
	IF v_upsertattributes THEN 

		IF v_fprocesscat=46 THEN -- presszone

			-- upsert presszone on parent tables
			UPDATE arc SET presszonecat_id = b.id FROM anl_arc a join (SELECT id, json_array_elements_text(nodeparent) as nodeparent from cat_presszone) b 
			ON  nodeparent = descript WHERE fprocesscat_id=46 AND a.arc_id=arc_id;
			UPDATE node SET presszonecat_id = b.id FROM anl_node a join (SELECT id, json_array_elements_text(nodeparent) as nodeparent from cat_presszone) b 
			ON  nodeparent = descript WHERE fprocesscat_id=46 AND a.node_id=node_id;
			--UPDATE connec SET presszonecat_id = b.id FROM anl_connec a join (SELECT id, json_array_elements_text(nodeparent) as nodeparent from cat_presszone) b 
			--ON  nodeparent = descript WHERE fprocesscat_id=46 AND a.arc_id=connec_id;
						
		ELSIF v_fprocesscat=45 THEN -- dma
			
			-- upsert dma on parent tables
			UPDATE arc SET dma_id = b.dma_id FROM anl_arc a join (SELECT dma_id, json_array_elements_text(nodeparent) as nodeparent from dma) b 
			ON  nodeparent = descript WHERE fprocesscat_id=45 AND a.arc_id=arc_id;
			UPDATE node SET dma_id = b.dma_id FROM anl_node a join (SELECT dma_id, json_array_elements_text(nodeparent) as nodeparent from dma) b 
			ON  nodeparent = descript WHERE fprocesscat_id=45 AND a.node_id=node_id;
			--UPDATE connec SET dma_id = b.dma_id FROM anl_connec a join (SELECT dma_id, json_array_elements_text(nodeparent) as nodeparent from dma) b 
			--ON  nodeparent = descript WHERE fprocesscat_id=45 AND a.feature_id=connec_id;


		ELSIF v_fprocesscat=44 THEN -- dqa
		
			-- upsert dqa on parent tables
			UPDATE arc SET dqa_id = b.dqa_id FROM anl_arc a join (SELECT dqa_id, json_array_elements_text(nodeparent) as nodeparent from dqa) b 
			ON  nodeparent = descript WHERE fprocesscat_id=44 AND a.arc_id=arc_id;
			UPDATE node SET dqa_id = b.dqa_id FROM anl_node a join (SELECT dqa_id, json_array_elements_text(nodeparent) as nodeparent from dqa) b 
			ON  nodeparent = descript WHERE fprocesscat_id=44 AND a.node_id=node_id;
			--UPDATE connec SET dqa_id = b.dqa_id FROM anl_connec a join (SELECT dqa_id, json_array_elements_text(nodeparent) as nodeparent from dqa) b 
			--ON  nodeparent = descript WHERE fprocesscat_id=44 AND a.feature_id=connec_id;

		ELSIF v_fprocesscat=30 THEN -- sector
			
			-- upsert sector on parent tables
			UPDATE arc SET sector_id = b.sector_id FROM anl_arc a join (SELECT sector_id, json_array_elements_text(nodeparent) as nodeparent from sector) b 
			ON  nodeparent = descript WHERE fprocesscat_id=30 AND a.arc_id=arc_id;
			UPDATE node SET sector_id = b.sector_id FROM anl_node a join (SELECT sector_id, json_array_elements_text(nodeparent) as nodeparent from sector) b 
			ON  nodeparent = descript WHERE fprocesscat_id=30 AND a.node_id=node_id;
			--UPDATE connec SET sector_id = b.sector_id FROM anl_connec a join (SELECT sector_id, json_array_elements_text(nodeparent) as nodeparent from sector) b 
			--ON  nodeparent = descript WHERE fprocesscat_id=30 AND a.connec_id=connec_id;
			
			-- get sectornodeparent elevation
			
			-- recalculate staticpressure (fprocesscat_id=47)
			DELETE FROM audit_log_data WHERE fprocesscat_id=47 AND user_name=current_user;
			
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) SELECT 47, 'node', n.node_id, (a.log_message::float - n.elevation) 
			FROM node n JOIN audit_log_data a ON a.feature_id=node_id WHERE fprocesscat_id=30 AND user_name=current_user;
			
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) SELECT 47, 'connec', n.connec_id, (a.log_message::float - n.elevation) 
			FROM connec n JOIN audit_log_data a ON a.feature_id=connec_id WHERE fprocesscat_id=30 AND user_name=current_user;
			
			-- update staticpressure on parent tables
			UPDATE node SET staticpressure=log_message::float FROM audit_log_data a WHERE a.feature_id=node_id AND fprocesscat_id=47 AND user_name=current_user;
			UPDATE connec SET staticpressure=log_message::float FROM audit_log_data a WHERE a.feature_id=connec_id AND fprocesscat_id=47 AND user_name=current_user;
		END IF;
	END IF;
	
	-- todo:
	-- update selectors of anl_arc & anl_node

RETURN v_cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
