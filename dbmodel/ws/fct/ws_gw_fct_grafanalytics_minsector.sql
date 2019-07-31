/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2706

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_minsector(p_data json)
RETURNS integer AS
$BODY$

/*
delete from anl_graf
TO EXECUTE
SELECT SCHEMA_NAME.gw_fct_grafanalytics_minsector('{"data":{"exploitation":"[1,2]", "upsertFeature":"TRUE"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_minsector('{"data":{"arc":"2002", "upsertFeature":"TRUE" }}')

delete from SCHEMA_NAME.audit_log_data;
delete from SCHEMA_NAME.anl_graf

SELECT * FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=34 AND user_name=current_user

*/

DECLARE
affected_rows numeric;
cont1 integer default 0;
v_class text = 'MINSECTOR';
v_feature record;
v_expl json;
v_data json;
v_fprocesscat integer;
v_addparam record;
v_attribute text;
v_arcid text;
v_featuretype text;
v_featureid integer;
v_querytext text;
v_upsertattributes boolean;
v_arc text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_expl = (SELECT (p_data::json->>'data')::json->>'exploitation');
	v_arcid = (SELECT (p_data::json->>'data')::json->>'arc');
	v_upsertattributes = (SELECT (p_data::json->>'data')::json->>'upsertFeature');
	v_expl = (SELECT (p_data::json->>'data')::json->>'exploitation');

	-- set variables
	v_fprocesscat=34;  
	v_featuretype='arc';
	
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
	UPDATE anl_graf SET flag=2 FROM node_type a JOIN cat_node b ON a.id=nodetype_id JOIN node c ON nodecat_id=b.id 
	WHERE c.node_id=anl_graf.node_1 AND graf_delimiter !='NONE' ;
			
	-- starting process
	LOOP
		EXIT WHEN cont1 = -1;
		cont1 = cont1+1;

		-- reset water flag
		UPDATE anl_graf SET water=0 WHERE user_name=current_user AND grafclass=v_class;

		------------------
		-- starting engine
		-- when arc_id is provided as a parameter
		IF v_arcid IS NULL THEN
			SELECT a.arc_id INTO v_arc FROM (SELECT arc_id, max(checkf) as checkf FROM anl_graf WHERE grafclass=v_class GROUP by arc_id) a 
			JOIN v_edit_arc b ON a.arc_id=b.arc_id WHERE checkf=0 LIMIT 1;
		END IF;

		EXIT WHEN v_arc IS NULL;
				
		-- set the starting element
		v_querytext = 'UPDATE anl_graf SET flag=1, water=1, checkf=1 WHERE arc_id='||quote_literal(v_arc)||' AND anl_graf.user_name=current_user AND grafclass='||quote_literal(v_class); 
		RAISE NOTICE '%', v_querytext;
			
		EXECUTE v_querytext;

		-- inundation process
		LOOP	
			cont1 = cont1+1;
			UPDATE anl_graf n SET water= 1, flag=n.flag+1, checkf=1 FROM v_anl_graf a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id AND n.grafclass=v_class;
			GET DIAGNOSTICS affected_rows =row_count;
			EXIT WHEN affected_rows = 0;
			EXIT WHEN cont1 = 100;
		END LOOP;
		
		-- finish engine
		----------------
		
		-- insert arc results into audit table
		EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			SELECT '||v_fprocesscat||', cat_arctype_id, a.arc_id, '||(v_arc)||' 
			FROM (SELECT arc_id, max(water) as water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' 
			AND water=1 GROUP by arc_id) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';
	
		-- insert node results into audit table
		EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			SELECT '||v_fprocesscat||', nodetype_id, b.node_id, '||(v_arc)||' FROM (SELECT node_1 as node_id FROM
			(SELECT node_1,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' UNION SELECT node_2,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||')a
			GROUP BY node_1, water HAVING water=1)b JOIN v_edit_node c USING(node_id)';

		-- insert node delimiters into audit table
		EXECUTE 'INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			SELECT '||v_fprocesscat||', nodetype_id, b.node_id, 0 FROM (SELECT node_1 as node_id FROM
			(SELECT node_1,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||' UNION ALL SELECT node_2,water FROM anl_graf WHERE grafclass='||quote_literal(v_class)||')a
			GROUP BY node_1, water HAVING water=1 AND count(node_1)=1)b JOIN v_edit_node USING(node_id)';

		-- delete duplicate delimiter
		DELETE FROM audit_log_data WHERE feature_id IN (SELECT feature_id FROM audit_log_data WHERE fprocesscat_id=34 AND log_message = '0') AND fprocesscat_id=34 AND log_message::integer > 0;
		
	END LOOP;
	
	IF v_upsertattributes THEN 
		-- due URN concept whe can update massively feature from audit_log_data without check if is arc/node/connec.....
		UPDATE arc SET minsector_id = log_message::integer FROM audit_log_data a WHERE fprocesscat_id=34 AND a.feature_id=arc_id;
		UPDATE node SET minsector_id = log_message::integer FROM audit_log_data a WHERE fprocesscat_id=34 AND a.feature_id=node_id;
		UPDATE connec SET minsector_id = log_message::integer FROM audit_log_data a WHERE fprocesscat_id=34 AND a.feature_id=connec_id;
	END IF;

RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
