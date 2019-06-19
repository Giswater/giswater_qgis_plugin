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
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"PRESSZONE", "upsertAttributes":"TRUE", "exploitation": "[1,2]"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"DMA", "upsertAttributes":"TRUE", "exploitation": "[1,2]"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"DQA", "upsertAttributes":"TRUE", "exploitation": "[1,2]"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"SECTOR", "upsertAttributes":"TRUE", "exploitation": "[1,2]"}}');

-- for one specific node
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"PRESSZONE", "upserAttributes":"TRUE", "node":"113952"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"DQA", "upserAttributes":"TRUE", "node":"113952"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"DMA", "upserAttributes":"TRUE", "node":"113952"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mapzones('{"data":{"grafClass":"SECTOR", "upserAttributes":"TRUE", "node":"113952"}}');


TO SEE RESULTS ON LOG TABLE
SELECT count(*), log_message FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=48 AND user_name=current_user group by log_message order by 2 --PZONE
SELECT count(*), log_message FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=44 AND user_name=current_user group by log_message order by 2 --DQA
SELECT count(*), log_message FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=45 AND user_name=current_user group by log_message order by 2 --DMA
SELECT count(*), log_message FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=30 AND user_name=current_user group by log_message order by 2 --SECTOR


TO SEE RESULTS ON SYSTEM TABLES (IN CASE OF "upsertAttributes":"TRUE")
SELECT count(presszonecat_id), presszonecat_id from SCHEMA_NAME.v_edit_arc  group by presszonecat_id
SELECT count(dma_id), dma_id from SCHEMA_NAME.v_edit_arc  group by dma_id
SELECT count(dma_id), dma_id from SCHEMA_NAME.v_edit_node  group by dma_id
SELECT count(sector_id), sector_id from SCHEMA_NAME.v_edit_arc group by sector_id
SELECT count(sector_id), sector_id from SCHEMA_NAME.v_edit_node group by sector_id
SELECT count(value_param) , value_param from SCHEMA_NAME.man_addfields_value WHERE parameter_id=57 group by value_param -- dqa (pipes)
*/

DECLARE
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

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_class = (SELECT (p_data::json->>'data')::json->>'grafClass');
	v_expl = (SELECT (p_data::json->>'data')::json->>'exploitation');
	v_nodeid = (SELECT (p_data::json->>'data')::json->>'node');
	v_upsertattributes = (SELECT (p_data::json->>'data')::json->>'upsertAttributes');
	v_expl = (SELECT (p_data::json->>'data')::json->>'exploitation');

	-- set fprocesscat
	IF v_class = 'PRESSZONE' THEN v_fprocesscat=48; 
	ELSIF v_class = 'DQA' THEN v_fprocesscat=44;
	ELSIF v_class = 'DMA' THEN v_fprocesscat=45; 
	ELSIF v_class = 'SECTOR' THEN v_fprocesscat=30; 
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
		(SELECT distinct(macroexpl_id) FROM SCHEMA_NAME.exploitation JOIN (SELECT (json_array_elements_text(v_expl))::integer AS expl)a  ON expl=expl_id);
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
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id LEFT JOIN man_valve d ON a.node_id=d.node_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'',''PRESSZONE'')';
	
	ELSIF v_class = 'DMA' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id LEFT JOIN man_valve d ON a.node_id=d.node_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'',''DMA'')';

	ELSIF v_class = 'DQA' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id LEFT JOIN man_valve d ON a.node_id=d.node_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'',''DQA'')';

	ELSIF v_class = 'SECTOR' THEN
		-- query text to select graf_delimiters
		v_text = 'SELECT a.node_id FROM node a JOIN cat_node b ON nodecat_id=b.id JOIN node_type c ON c.id=b.nodetype_id LEFT JOIN man_valve d ON a.node_id=d.node_id JOIN anl_graf e ON a.node_id=e.node_1
			  WHERE graf_delimiter IN (''SECTOR'')';

	END IF;

	-- update boundary conditions setting flag=2 for all nodes that fits on graf delimiters and closed valves
	EXECUTE 'UPDATE anl_graf SET flag=2 WHERE node_1 IN('||v_text||' OR (graf_delimiter=''MINSECTOR'' AND closed=TRUE))';

	-- update boundary conditions disabling sense for graf delimiters not allowed on inp_pump table
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM SCHEMA_NAME.anl_graf WHERE node_1 IN (SELECT node_1 FROM SCHEMA_NAME.anl_graf JOIN SCHEMA_NAME.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on inp_pump table
				SELECT id FROM SCHEMA_NAME.anl_graf JOIN SCHEMA_NAME.inp_pump ON to_arc = arc_id AND node_1=node_id)
				AND flag=2;

	-- update boundary conditions disabling sense for graf delimiters not allowed on inp_valve table
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM SCHEMA_NAME.anl_graf WHERE node_1 IN (SELECT node_1 FROM SCHEMA_NAME.anl_graf JOIN SCHEMA_NAME.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on inp_valve table
				SELECT id FROM SCHEMA_NAME.anl_graf JOIN SCHEMA_NAME.inp_valve ON to_arc = arc_id AND node_1=node_id)
				AND flag=2;
				
	-- update boundary conditions disabling sense for graf delimiters not allowed on inp_shortpipe table
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM SCHEMA_NAME.anl_graf WHERE node_1 IN (SELECT node_1 FROM SCHEMA_NAME.anl_graf JOIN SCHEMA_NAME.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on inp_shortpipe table
				SELECT id FROM SCHEMA_NAME.anl_graf JOIN SCHEMA_NAME.inp_shortpipe ON to_arc = arc_id AND node_1=node_id)
				AND flag=2;
				
	-- update boundary conditions disabling sense for graf delimiters not allowed on anl_mincut_inlet_x_exploitation table
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM SCHEMA_NAME.anl_graf WHERE node_1 IN (SELECT node_1 FROM SCHEMA_NAME.anl_graf JOIN SCHEMA_NAME.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on anl_mincut_inlet_x_exploitation table
				SELECT id FROM SCHEMA_NAME.anl_graf JOIN (SELECT node_id, json_array_elements_text(to_arc) as to_arc FROM SCHEMA_NAME.anl_mincut_inlet_x_exploitation)a  ON to_arc = arc_id AND node_1=node_id
				) AND flag=2;
	
	-- starting process
	LOOP
		--EXIT WHEN v_cont1 = -1;
		v_cont1 = v_cont1+1;

		-- reset water flag
		UPDATE anl_graf SET water=0 WHERE user_name=current_user AND grafclass=v_class;
				
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

		--call engine function
		v_data = '{"grafClass":"'||v_class||'", "node":"'|| (v_featureid) ||'"}';

		--RAISE NOTICE 'v_text %', v_text;		
		RAISE NOTICE 'v_data %', v_data;
		PERFORM gw_fct_grafanalytics_engine(v_data);
		
		-- insert arc results into audit table

		raise notice '% % %', v_fprocesscat, v_featureid, v_class;
		EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			SELECT '||v_fprocesscat||', cat_arctype_id, a.arc_id, '||(v_featureid)||' 
			FROM (SELECT arc_id, max(water) as water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' 
			AND water=1 GROUP by arc_id) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';
	
		-- insert node results into audit table
		EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			SELECT '||v_fprocesscat||', nodetype_id, b.node_id, '||(v_featureid)||' FROM (SELECT node_1 as node_id FROM
			(SELECT node_1,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' UNION SELECT node_2,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||')a
			GROUP BY node_1, water HAVING water=1)b JOIN v_edit_node c USING(node_id)';

		-- insert node delimiters into audit table
		EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			SELECT '||v_fprocesscat||', nodetype_id, b.node_id, -1 FROM (SELECT node_1 as node_id FROM
			(SELECT node_1,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' UNION ALL SELECT node_2,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||')a
			GROUP BY node_1, water HAVING water=1 AND count(node_1)=2)b JOIN v_edit_node USING(node_id)';	
	END LOOP;
	
	IF v_upsertattributes THEN 

		-- upsert msector/dqa/dinlet-staticpress/pipehazard results on man_addfields table
		FOR v_addparam IN SELECT * FROM man_addfields_parameter WHERE (default_value::json->>'fprocesscat_id')=v_fprocesscat::text
		LOOP
			--upsert fields
			DELETE FROM man_addfields_value WHERE feature_id IN (SELECT feature_id FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat) AND parameter_id = v_addparam.id;
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) 
			SELECT feature_id, v_addparam.id, log_message FROM audit_log_data WHERE feature_type=v_addparam.cat_feature_id AND fprocesscat_id=v_fprocesscat
			ON CONFLICT DO NOTHING;
		END LOOP;

		IF v_fprocesscat=48 THEN

			-- upsert presszone on parent tables
			UPDATE node SET presszonecat_id=a.id FROM audit_log_data JOIN (SELECT id, json_array_elements_text(nodeparent)::integer as nodeparent 
							      FROM cat_presszone)a ON nodeparent=log_message::integer WHERE feature_id=node_id AND fprocesscat_id=48 AND user_name=current_user;
			UPDATE arc SET presszonecat_id=a.id FROM audit_log_data JOIN (SELECT id, json_array_elements_text(nodeparent)::integer as nodeparent 
							      FROM cat_presszone)a ON nodeparent=log_message::integer WHERE feature_id=arc_id AND  fprocesscat_id=48 AND user_name=current_user;
			UPDATE connec SET presszonecat_id = arc.presszonecat_id FROM arc WHERE arc.arc_id=connec.arc_id;
			
		ELSIF v_fprocesscat=45 THEN
			
			-- upsert dma on parent tables
			UPDATE node SET dma_id=a.dma_id FROM audit_log_data JOIN (SELECT dma_id, json_array_elements_text(nodeparent)::integer as nodeparent 
							      FROM dma)a ON nodeparent=log_message::integer WHERE feature_id=node_id AND fprocesscat_id=45 AND user_name=current_user;
			UPDATE arc SET dma_id=a.dma_id FROM audit_log_data JOIN (SELECT dma_id, json_array_elements_text(nodeparent)::integer as nodeparent 
							      FROM dma)a ON nodeparent=log_message::integer WHERE feature_id=arc_id AND  fprocesscat_id=45 AND user_name=current_user;
			UPDATE connec SET dma_id = arc.dma_id FROM arc WHERE arc.arc_id=connec.arc_id;

		ELSIF v_fprocesscat=30 THEN
			-- upsert sector on parent tables
			UPDATE node SET sector_id=a.sector_id FROM audit_log_data JOIN (SELECT sector_id, json_array_elements_text(nodeparent)::integer as nodeparent 
							      FROM sector)a ON nodeparent=log_message::integer WHERE feature_id=node_id AND fprocesscat_id=30 AND user_name=current_user;
			UPDATE arc SET sector_id=a.sector_id FROM audit_log_data JOIN (SELECT sector_id, json_array_elements_text(nodeparent)::integer as nodeparent 
							      FROM sector)a ON nodeparent=log_message::integer WHERE feature_id=arc_id AND  fprocesscat_id=30 AND user_name=current_user;
			UPDATE connec SET sector_id = arc.sector_id FROM arc WHERE arc.arc_id=connec.arc_id;
			
			-- in addition to minsector trigger staticpressure (fprocesscat_id=46)
			DELETE FROM audit_log_data WHERE fprocesscat_id=46 AND user_name=current_user;
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) SELECT 46, 'node', n.node_id, (a.log_message::float - n.elevation) 
			FROM node n JOIN audit_log_data a ON feature_id=node_id WHERE fprocesscat_id=30 AND user_name=current_user;

			-- get addfield parameter related to staticpressure (fprocesscat_id=46)
			SELECT * INTO v_addparam FROM man_addfields_parameter WHERE (default_value::json->>'fprocesscat_id')=46::text;

			-- upsert parameter
			DELETE FROM man_addfields_value WHERE feature_id IN (SELECT feature_id FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat) AND parameter_id = v_addparam.id;
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) 
			SELECT feature_id, v_addparam.id, log_message FROM audit_log_data WHERE feature_type=v_addparam.cat_feature_id AND fprocesscat_id=46;		
			
		END IF;

	END IF;

RETURN v_cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
