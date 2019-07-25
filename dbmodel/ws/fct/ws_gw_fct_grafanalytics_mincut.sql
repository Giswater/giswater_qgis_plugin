/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2708

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_grafanalytics_mincut(p_data json)
RETURNS integer AS
$BODY$

/*
TO EXECUTE

SELECT SCHEMA_NAME.gw_fct_grafanalytics_mincut('{"data":{"grafClass":"MINCUT", "arc":"2001", "parameters":{"id":-1, "process":"base"}}}')
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mincut('{"data":{"grafClass":"MINCUT", "arc":"2001", "parameters":{"id":-1, "process":"extended"}}}')

*/


DECLARE
v_class text;
v_feature record;
v_data json;
v_arcid text;
v_mincutid integer;
v_mincutprocess text;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_class = (SELECT (p_data::json->>'data')::json->>'grafClass');
	v_mincutprocess = ((SELECT (p_data::json->>'data')::json->>'parameters')::json->>'process');
	v_arcid = (SELECT (p_data::json->>'data')::json->>'arc');
	v_mincutid = ((SELECT (p_data::json->>'data')::json->>'parameters')::json->>'id');

	-- reset graf & audit_log tables
	DELETE FROM anl_graf where user_name=current_user;
	
	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);
	DELETE FROM selector_psector WHERE cur_user=current_user;
	
	-- create graf
	INSERT INTO anl_graf ( grafclass, arc_id, node_1, node_2, water, flag, checkf, user_name )
	SELECT  v_class, arc_id, node_1, node_2, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT  v_class, arc_id, node_2, node_1, 0, 0, 0, current_user FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;
	
	
	-- set boundary conditions of graf table	
	IF v_mincutprocess = 'base' THEN
		UPDATE anl_graf SET flag=2
		FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND ((unaccess = FALSE AND broken = FALSE) OR (broken = TRUE))
		AND anl_graf.node_1 = anl_mincut_result_valve.node_id AND user_name=current_user;
			
	ELSIF v_mincutprocess = 'extended' THEN 
		UPDATE anl_graf SET flag=2
		FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND closed=TRUE AND anl_graf.node_1 = anl_mincut_result_valve.node_id AND user_name=current_user;
	END IF;
				
	-- reset water flag
	UPDATE anl_graf SET water=0 WHERE user_name=current_user AND grafclass=v_class;
	
	--call engine function
	v_data = '{"grafClass":"'||v_class||'", "arc":"'|| v_arcid ||'"}';
	RAISE NOTICE 'v_data % ' , v_data ;
	PERFORM gw_fct_grafanalytics_engine(v_data);
	
	-- insert arc results into table
	EXECUTE 'INSERT INTO anl_mincut_result_arc (result_id, arc_id)
		SELECT '||v_mincutid||', a.arc_id FROM (SELECT arc_id, max(water) as water FROM anl_graf WHERE grafclass=''MINCUT''
		AND water=1 GROUP by arc_id) a JOIN v_edit_arc b ON a.arc_id=b.arc_id';

	-- insert node results into table
	EXECUTE 'INSERT INTO anl_mincut_result_node (result_id, node_id)
		SELECT '||v_mincutid||', b.node_1 FROM (SELECT node_1 FROM
		(SELECT node_1,water FROM anl_graf WHERE grafclass=''MINCUT'' UNION SELECT node_2,water FROM anl_graf WHERE grafclass=''MINCUT'')a
		GROUP BY node_1, water HAVING water=1) b';

	-- insert delimiters into table
	IF v_mincutprocess = 'base' THEN
		EXECUTE 'UPDATE anl_mincut_result_valve SET proposed=TRUE WHERE result_id = '||v_mincutid||' AND node_id IN 
			(SELECT b.node_1 FROM (SELECT node_1 FROM
			(SELECT node_1,water FROM anl_graf WHERE grafclass=''MINCUT'' UNION ALL SELECT node_2,water FROM anl_graf WHERE grafclass=''MINCUT'')a
			GROUP BY node_1, water HAVING water=1 AND count(node_1)=1) b)';
			
	ELSIF v_mincutprocess = 'extended' THEN
		EXECUTE 'INSERT INTO anl_mincut_result_node (result_id, node_id)
			SELECT '||v_mincutid||', b.node_1 FROM (SELECT node_1 FROM
			(SELECT node_1,water FROM anl_graf WHERE grafclass=''MINCUT'' UNION ALL SELECT node_2,water FROM anl_graf WHERE grafclass=''MINCUT'')a
			GROUP BY node_1, water HAVING water=1 AND count(node_1)=2) b';
	END IF;
	

RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
