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
SELECT SCHEMA_NAME.gw_fct_grafanalytics_minsector('{"data":{"grafClass":"MINSECTOR", "upsertFeatureAttrib":"TRUE", "exploitation":"[1]"}}');
SELECT SCHEMA_NAME.gw_fct_grafanalytics_minsector('{"data":{"grafClass":"MINSECTOR", "arc":"2002", "upsertFeatureAttrib":"TRUE" }}')

delete from SCHEMA_NAME.audit_log_data;
delete from SCHEMA_NAME.anl_graf

SELECT * FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=34 AND user_name=current_user

*/

DECLARE
affected_rows numeric;
cont1 integer default 0;
v_class text;
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

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_class = (SELECT (p_data::json->>'data')::json->>'grafClass');
	v_expl = (SELECT (p_data::json->>'data')::json->>'exploitation');
	v_arcid = (SELECT (p_data::json->>'data')::json->>'arc');
	v_upsertattributes = (SELECT (p_data::json->>'data')::json->>'upsertFeatureAttrib');
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
		
		IF v_arcid IS NULL THEN
			SELECT * INTO v_feature FROM (SELECT arc_id, max(checkf) as checkf FROM anl_graf WHERE grafclass=v_class GROUP by arc_id) a 
			JOIN v_edit_arc b ON a.arc_id=b.arc_id WHERE checkf=0 LIMIT 1;
			EXIT WHEN v_feature.arc_id IS NULL;
			v_featureid = v_feature.arc_id;			
		ELSIF v_arcid IS NOT NULL THEN
			v_featureid = v_arcid;
			cont1 = -1;
		END IF;

		--call engine function
		v_data = '{"grafClass":"'||v_class||'", "'|| quote_ident(v_featuretype) ||'":"'|| (v_featureid) ||'"}';
		PERFORM gw_fct_grafanalytics_engine(v_data);
		
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
	END LOOP;
	
	IF v_upsertattributes THEN 

		FOR v_addparam IN SELECT * FROM man_addfields_parameter WHERE (default_value::json->>'fprocesscat_id')=v_fprocesscat::text
		LOOP
			--upsert fields
			DELETE FROM man_addfields_value WHERE feature_id IN (SELECT feature_id FROM audit_log_data WHERE fprocesscat_id=v_fprocesscat) AND parameter_id = v_addparam.id;
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param) 
			SELECT feature_id, v_addparam.id, log_message FROM audit_log_data WHERE feature_type=v_addparam.cat_feature_id AND fprocesscat_id=v_fprocesscat
			ON CONFLICT DO NOTHING;
		END LOOP;
	END IF;

RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
