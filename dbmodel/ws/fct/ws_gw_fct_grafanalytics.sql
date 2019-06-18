/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2702

CREATE OR REPLACE FUNCTION ws_sample.gw_fct_grafanalytics(p_data json)
RETURNS integer AS
$BODY$

/*

TO CONFIGURE
-- set graf_delimiter field on node_type table
-- set to_arc on anl_mincut_inlet_x_macroexploitation (for sectors)
-- set to_arc on tables inp_valve (for presszone), inp_pump (for presszone), inp_shortpipe (for dqa, dma)


TO EXECUTE

SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"MINCUT", "arc":"2001", "parameters":{"id":1, "process":"base"}}}')
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"MINCUT", "arc":"2001", "parameters":{"id":1, "process":"extended"}}}')

SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"MSECTOR"}}')

SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"PZONEA", "upserAttributes":FALSE, "exploitation": 2}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"PZONEA", "upserAttributes":FALSE, "arc":"2001"}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"PZONEN", "upserAttributes":TRUE, "node":"1001"}}');

SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"DMAA","upserAttributes":FALSE, "exploitation": 2}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"DMAA", "upserAttributes":FALSE, "arc":"2001"}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"DMAN", "upserAttributes":TRUE, "node":"1001"}}');

SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"DQAA", "upserAttributes":TRUE, "exploitation": 2}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"DQAA", "upserAttributes":TRUE, "arc":"2001"}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"DQAN", "upserAttributes":TRUE, "node":"1001"}}');

SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"SECTORA", "upserAttributes":FALSE, "exploitation": 2}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"SECTORA", "upserAttributes":FALSE, "arc":"2001"}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"SECTORN", "upserAttributes":TRUE}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"SECTORN", "upserAttributes":TRUE, "node":"113766"}}');
SELECT ws_sample.gw_fct_grafanalytics('{"data":{"grafClass":"SECTORN", "upserAttributes":TRUE, "node":"113952"}}');

delete from ws_sample.audit_log_data;
delete from ws_sample.anl_graf

--RESULTS
SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=34 AND user_name=current_user

SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=43 AND user_name=current_user
SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=44 AND user_name=current_user

SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=45 AND user_name=current_user
SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=46 AND user_name=current_user

SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=47 AND user_name=current_user
SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=48 AND user_name=current_user

SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=49 AND user_name=current_user
SELECT * FROM ws_sample.audit_log_data WHERE fprocesscat_id=30 AND user_name=current_user


*/

DECLARE
affected_rows numeric;
cont1 integer default 0;
v_class text;
v_feature record;
v_expl integer;
v_data json;
v_fprocesscat integer;
v_addparam record;
v_attribute text;
v_arcid text;
v_nodeid text;
v_mincutid integer;
v_mincutprocess text;
v_featuretype text;
v_featureid integer;
v_querytext text;
v_upsertattributes boolean;

BEGIN

    -- Search path
    SET search_path = "ws_sample", public;

	-- get variables
	v_class = (SELECT (p_data::json->>'data')::json->>'grafClass');
	v_expl = (SELECT (p_data::json->>'data')::json->>'exploitation');
	v_mincutprocess = ((SELECT (p_data::json->>'data')::json->>'parameters')::json->>'process');
	v_nodeid = (SELECT (p_data::json->>'data')::json->>'node');
	v_arcid = (SELECT (p_data::json->>'data')::json->>'arc');
	v_mincutid = ((SELECT (p_data::json->>'data')::json->>'parameters')::json->>'id');
	v_upsertattributes = (SELECT (p_data::json->>'data')::json->>'upsertAttributes');
	v_expl = (SELECT (p_data::json->>'data')::json->>'exploitation');

	-- set fprocesscat
	IF v_class = 'MINCUT' THEN v_fprocesscat=NULL; v_featuretype='arc';
	ELSIF v_class = 'MSECTOR' THEN v_fprocesscat=34;  v_featuretype='arc';
	ELSIF v_class = 'PZONEA' THEN v_fprocesscat=43; v_attribute=quote_ident('presszonecat_id');  v_featuretype='arc';
	ELSIF v_class = 'PZONEN' THEN v_fprocesscat=44; v_featuretype='node';
	ELSIF v_class = 'DMAA' THEN v_fprocesscat=45; v_attribute=quote_ident('dma_id'); v_featuretype='arc';
	ELSIF v_class = 'DMAN' THEN v_fprocesscat=46; v_featuretype='node';
	ELSIF v_class = 'DQAA' THEN v_fprocesscat=47; v_attribute=NULL; v_featuretype='arc';
	ELSIF v_class = 'DQAN' THEN v_fprocesscat=48; v_featuretype='node';
	ELSIF v_class = 'SECTORA' THEN v_fprocesscat=49; v_attribute=quote_ident('sector_id'); v_featuretype='arc';
	ELSIF v_class = 'SECTORN' THEN v_fprocesscat=30; v_attribute=quote_literal(v_nodeid); v_featuretype='node';
	END IF;

	-- reset graf & audit_log tables
	DELETE FROM anl_graf where user_name=current_user;
	DELETE FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat AND user_name=current_user;

	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	DELETE FROM selector_psector WHERE cur_user=current_user;
	DELETE FROM selector_expl WHERE cur_user=current_user;
	INSERT INTO selector_expl SELECT expl_id FROM exploitation where macroexpl_id = (SELECT macroexpl_id WHERE expl_id=v_expl);

	-- create graf
	INSERT INTO anl_graf ( grafclass, arc_id, node_1, node_2, water, flag, checkf, user_name )
	SELECT  v_class, arc_id, node_1, node_2, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT  v_class, arc_id, node_2, node_1, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;
	
	
	-- set boundary conditions of graf table	
	IF v_class = 'MINCUT' THEN
		-- Init valves on graf table
		IF v_mincutprocess = 'base' THEN
			UPDATE anl_graf SET flag=2
			FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND unaccess = FALSE AND broken = FALSE AND anl_graf.node_1 = anl_mincut_result_valve.node_id AND user_name=current_user;
			
		ELSIF v_mincutprocess = 'extended' THEN
			UPDATE anl_graf SET flag=2
			FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND closed=TRUE AND anl_graf.node_1 = anl_mincut_result_valve.node_id AND user_name=current_user;
		END IF;
		
	ELSIF v_class = 'MSECTOR' THEN
		UPDATE anl_graf SET flag=2 FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
		WHERE c.node_id=anl_graf.node_1 AND graf_delimiter !='NONE' ;
		
	ELSIF v_class = 'PZONEA' OR v_class = 'PZONEN' THEN

		UPDATE anl_graf SET flag=2 FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id JOIN man_valve d ON c.node_id=d.node_id
		WHERE c.node_id=anl_graf.node_1 AND graf_delimiter IN ('SECTOR','PRESSZONE', 'MINSECTOR') AND closed=true ;

		-- query text used below for recurrent selection of starting nodes 
		v_querytext = 'SELECT node_id FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
				JOIN anl_graf ON node_1=node_id WHERE graf_delimiter=''PRESSZONE'' AND checkf=0 LIMIT 1';
	
	ELSIF v_class = 'DMAA'  OR v_class = 'DMAN' THEN
		UPDATE anl_graf SET flag=2 FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id JOIN man_valve d ON c.node_id=d.node_id
		WHERE c.node_id=anl_graf.node_1 AND graf_delimiter IN ('SECTOR','DMA','MINSECTOR') AND closed=true ;

		-- query text used below for recurrent selection of starting nodes 
		v_querytext = 'SELECT node_id FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
				JOIN anl_graf ON node_1=node_id WHERE graf_delimiter=''DMA'' AND checkf=0 LIMIT 1';

	ELSIF v_class = 'DQAA'  OR v_class = 'DQAN' THEN
		UPDATE anl_graf SET flag=2 FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id JOIN man_valve d ON c.node_id=d.node_id
		WHERE c.node_id=anl_graf.node_1 AND graf_delimiter IN ('SECTOR','DQA','MINSECTOR') AND closed=true ;

		-- query text used below for recurrent selection of starting nodes 
		v_querytext = 'SELECT node_id FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
				JOIN anl_graf ON node_1=node_id WHERE graf_delimiter=''DQA'' AND checkf=0 LIMIT 1';

	ELSIF v_class = 'SECTORA' OR v_class = 'SECTORN' THEN
		UPDATE anl_graf SET flag=2 FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id JOIN man_valve d ON c.node_id=d.node_id
		WHERE c.node_id=anl_graf.node_1 AND graf_delimiter IN ('SECTOR','MINSECTOR') AND closed=true ;

		-- query text used below for recurrent selection of starting nodes 
		v_querytext = 'SELECT node_id FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
				JOIN anl_graf ON node_1=node_id WHERE graf_delimiter=''SECTOR'' AND checkf=0 LIMIT 1';

	END IF;

	-- rectificate graf table (for determinated nodes enabled only one sense)
	
	-- UPDATE rows where flag=2 AND direction for specified node is not allowed (inp_pump.to_arc)
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM ws_sample.anl_graf WHERE node_1 IN (SELECT node_1 FROM ws_sample.anl_graf JOIN ws_sample.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on inp_pump table
				SELECT id FROM ws_sample.anl_graf JOIN ws_sample.inp_pump ON to_arc = arc_id AND node_1=node_id)
				AND flag=2;

	-- UPDATE rows WHERE flag=2 (to flag=0) AND direction for especified node_id is not allowed (inp_valve.to_arc)
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM ws_sample.anl_graf WHERE node_1 IN (SELECT node_1 FROM ws_sample.anl_graf JOIN ws_sample.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on inp_valve table
				SELECT id FROM ws_sample.anl_graf JOIN ws_sample.inp_vale ON to_arc = arc_id AND node_1=node_id)
				AND flag=2;
				
	-- UPDATE rows WHERE flag=2 (to flag=0) AND direction for especified node_id is not allowed (inp_shortpipe.to_arc)
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM ws_sample.anl_graf WHERE node_1 IN (SELECT node_1 FROM ws_sample.anl_graf JOIN ws_sample.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on inp_shortpipe table
				SELECT id FROM ws_sample.anl_graf JOIN ws_sample.inp_shortpipe ON to_arc = arc_id AND node_1=node_id)
				AND flag=2;
				
	-- UPDATE rows WHERE flag=2 (to flag=0) AND direction for especified node_id is not allowed (anl_mincut_inlet_x_exploitation)
	UPDATE anl_graf SET flag=0 WHERE id IN (
				-- all rows where node_id participates AS node_1
				SELECT id FROM ws_sample.anl_graf WHERE node_1 IN (SELECT node_1 FROM ws_sample.anl_graf JOIN ws_sample.inp_pump ON to_arc = arc_id AND node_1=node_id) EXCEPT 
				-- especific rows where node_id participates AS node_1 and related arc_id is allowed on anl_mincut_inlet_x_exploitation table
				SELECT id FROM ws_sample.anl_graf JOIN (SELECT node_id, json_array_elements_text(to_arc) as to_arc FROM ws_sample.anl_mincut_inlet_x_exploitation)a  ON to_arc = arc_id AND node_1=node_id
				) AND flag=2;
				
	-- starting process
	LOOP
		EXIT WHEN cont1 = -1;
		cont1 = cont1+1;

		-- reset water flag
		UPDATE anl_graf SET water=0 WHERE user_name=current_user AND grafclass=v_class;
		
		IF v_arcid IS NULL AND v_featuretype='arc' THEN
			SELECT * INTO v_feature FROM (SELECT arc_id, max(checkf) as checkf FROM anl_graf WHERE grafclass=v_class GROUP by arc_id) a 
			JOIN v_edit_arc b ON a.arc_id=b.arc_id WHERE checkf=0 LIMIT 1;
			EXIT WHEN v_feature.arc_id IS NULL;
			v_featureid = v_feature.arc_id;
			
		ELSIF v_nodeid IS NULL AND v_featuretype='node' THEN
			v_querytext = 'SELECT * FROM ('||v_querytext||') a ';
			IF v_querytext IS NOT NULL THEN
				EXECUTE v_querytext INTO v_feature;
				RAISE NOTICE 'v_querytext %', v_querytext;
			END IF;
			v_featureid = v_feature.node_id;
			v_attribute=v_featureid;
			EXIT WHEN v_featureid IS NULL;
			
		ELSIF v_arcid IS NOT NULL THEN
			v_featureid = v_arcid;
			cont1 = -1;
			
		ELSIF v_nodeid IS NOT NULL THEN
			v_featureid = v_nodeid;
			v_attribute=v_featureid;
			cont1 = -1;
		END IF;

		--call engine function
		v_data = '{"grafClass":"'||v_class||'", "'|| quote_ident(v_featuretype) ||'":"'|| (v_featureid) ||'"}';
		
		RAISE NOTICE 'v_data %', v_data;
		RAISE NOTICE ' v_attribute % ', v_attribute;
		PERFORM gw_fct_grafanalytics_engine(v_data);
		

		IF v_class = 'MINCUT' THEN -- for mincut
			-- insert arc results into audit table
			EXECUTE 'INSERT INTO anl_mincut_result_arc (result_id, arc_id)
				SELECT '||v_mincutid||', a.arc_id FROM (SELECT arc_id, max(water) as water FROM anl_graf WHERE grafclass=''MINCUT''
				AND water=1 GROUP by arc_id) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';

			-- insert node results into audit table
			EXECUTE 'INSERT INTO anl_mincut_result_node (result_id, node_id)
				SELECT '||v_mincutid||', b.node_1 FROM (SELECT node_1 FROM
				(SELECT node_1,water FROM anl_graf WHERE grafclass=''MINCUT'' UNION SELECT node_2,water FROM anl_graf WHERE grafclass=''MINCUT'')a
				GROUP BY node_1, water HAVING water=1) b';

			-- insert node delimiters into audit table
			EXECUTE 'INSERT INTO anl_mincut_result_node (result_id, node_id)
				SELECT '||v_mincutid||', b.node_1 FROM (SELECT node_1 FROM
				(SELECT node_1,water FROM anl_graf WHERE grafclass=''MINCUT'' UNION ALL SELECT node_2,water FROM anl_graf WHERE grafclass=''MINCUT'')a
				GROUP BY node_1, water HAVING water=1 AND count(node_1)=2) b';

		ELSIF  v_class = 'MSECTOR' OR  v_class = 'DQAA' OR  v_class = 'DQAN' THEN
		
			-- insert arc results into audit table
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
			
		ELSE 
			-- insert arc results into audit table
			EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
				SELECT '||v_fprocesscat||', cat_arctype_id, a.arc_id, '||(v_attribute)||' 
				FROM (SELECT arc_id, max(water) as water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' 
				AND water=1 GROUP by arc_id) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';
	
			-- insert node results into audit table
			EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
				SELECT '||v_fprocesscat||', nodetype_id, b.node_id, '||(v_attribute)||' FROM (SELECT node_1 as node_id FROM
				(SELECT node_1,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' UNION SELECT node_2,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||')a
				GROUP BY node_1, water HAVING water=1)b JOIN v_edit_node c USING(node_id)';

			-- insert node delimiters into audit table
			EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
				SELECT '||v_fprocesscat||', nodetype_id, b.node_id, -1 FROM (SELECT node_1 as node_id FROM
				(SELECT node_1,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' UNION ALL SELECT node_2,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||')a
				GROUP BY node_1, water HAVING water=1 AND count(node_1)=2)b JOIN v_edit_node USING(node_id)';	
		END IF;
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

		-- upsert presszone on parent tables
		UPDATE node SET presszonecat_id = log_message FROM audit_log_data WHERE feature_id=node_id AND fprocesscat_id=43 AND user_name=current_user;
		UPDATE ws_sample.arc SET presszonecat_id = log_message FROM ws_sample.audit_log_data WHERE feature_id=arc_id AND fprocesscat_id=43 AND user_name=current_user;
		UPDATE connec SET presszonecat_id = arc.presszonecat_id FROM arc WHERE arc.arc_id=connec.arc_id;
			
		-- upsert dma on parent tables
		UPDATE node SET dma_id = log_message::integer FROM audit_log_data WHERE feature_id=node_id AND fprocesscat_id=45 AND user_name=current_user;
		UPDATE arc SET dma_id = log_message::integer FROM audit_log_data WHERE feature_id=arc_id AND fprocesscat_id=45 AND user_name=current_user;
		UPDATE connec SET dma_id = arc.dma_id FROM arc WHERE arc.arc_id=connec.arc_id;
	
		-- upsert sector on parent tables
		UPDATE node SET sector_id = log_message::integer FROM audit_log_data WHERE feature_id=node_id AND fprocesscat_id=49 AND user_name=current_user;
		UPDATE arc SET sector_id = log_message::integer FROM audit_log_data WHERE feature_id=arc_id AND fprocesscat_id=49 AND user_name=current_user;
		UPDATE connec SET sector_id = arc.sector_id FROM arc WHERE arc.arc_id=connec.arc_id;

		-- especial case on inlet in order to catch derivated values as static pressure
		IF v_fprocesscat=30 THEN

			-- trigger staticpressure (fprocesscat_id=50)
			DELETE FROM audit_log_data WHERE fprocesscat_id=50 AND user_name=current_user;
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) SELECT 50, 'node', n.node_id, (a.log_message::float - n.elevation) 
			FROM node n JOIN audit_log_data a ON feature_id=node_id WHERE fprocesscat_id=47 AND user_name=current_user;

			-- get addfield parameter related to staticpressure (fprocesscat_id=48)
			SELECT * INTO v_addparam FROM man_addfields_parameter WHERE (default_value::json->>'fprocesscat_id')=48::text;

			-- upsert parameter
			DELETE FROM man_addfields_value WHERE feature_id IN (SELECT feature_id FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat) AND parameter_id = v_addparam.id;
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) 
			SELECT feature_id, v_addparam.id, log_message FROM audit_log_data WHERE feature_type=v_addparam.cat_feature_id AND fprocesscat_id=v_fprocesscat;		
		END IF;
	END IF;

RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
