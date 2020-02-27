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
INSERT INTO anl_mincut_result_cat values (-1);
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mincut('{"data":{"arc":"2001", "step":1, "parameters":{"id":-1}}}')
SELECT SCHEMA_NAME.gw_fct_grafanalytics_mincut('{"data":{"arc":"2001", "step":2, "parameters":{"id":-1}}}')
*/

DECLARE
v_class text = 'MINCUT';
v_feature record;
v_data json;
v_arcid text;
v_mincutid integer;
v_mincutstep integer;
v_arc integer;
v_querytext text;
affected_rows numeric;
cont1 integer default 0;
v_arctwin integer;
v_nodetwin integer;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_mincutstep = (SELECT (p_data::json->>'data')::json->>'step');
	v_arc = (SELECT (p_data::json->>'data')::json->>'arc');
	v_mincutid = ((SELECT (p_data::json->>'data')::json->>'parameters')::json->>'id');


	-- reset graf & audit_log tables
	DELETE FROM temp_anlgraf;
	
	-- reset selectors
	DELETE FROM selector_state WHERE cur_user=current_user;
	INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

	-- create graf
	INSERT INTO temp_anlgraf (arc_id, node_1, node_2, water, flag, checkf )
	SELECT arc_id::integer, node_1::integer, node_2::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
	UNION
	SELECT arc_id::integer, node_2::integer, node_1::integer, 0, 0, 0 FROM v_edit_arc JOIN value_state_type ON state_type=id 
	WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;
	
	-- set boundary conditions of graf table
	IF v_mincutstep = 1 THEN 
		-- setting on the graf matrix proposable valves
		UPDATE temp_anlgraf SET flag=1
		FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND ((unaccess = FALSE AND broken = FALSE))
		AND (temp_anlgraf.node_1 = anl_mincut_result_valve.node_id::integer OR temp_anlgraf.node_2 = anl_mincut_result_valve.node_id::integer);
		
	ELSIF v_mincutstep = 2 THEN 
		-- setting on the graf matrix only proposed valves on step1
		UPDATE temp_anlgraf SET flag=1 
		FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND proposed = TRUE
		AND (temp_anlgraf.node_1 = anl_mincut_result_valve.node_id::integer OR temp_anlgraf.node_2 = anl_mincut_result_valve.node_id::integer);
	END IF;
	-- setting the graf matrix with closed valves
	UPDATE temp_anlgraf SET flag=1 
	FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND closed=TRUE 
	AND (temp_anlgraf.node_1 = anl_mincut_result_valve.node_id::integer OR temp_anlgraf.node_2 = anl_mincut_result_valve.node_id::integer);
	
	-- setting the graf matrix with tanks
	UPDATE temp_anlgraf SET flag=1 
	FROM anl_mincut_inlet_x_exploitation 
	WHERE (temp_anlgraf.node_1 = anl_mincut_inlet_x_exploitation.node_id::integer OR temp_anlgraf.node_2 = anl_mincut_inlet_x_exploitation.node_id::integer);

	-- reset water flag
	UPDATE temp_anlgraf SET water=0;
	
	------------------
	-- starting engine

	-- get arc_id twin in case of exists to remove results (arc twin is that arc closest choosed arc connected with valve)
	-- 1) get node twin
	v_nodetwin = (select node_id FROM (SELECT node_1 AS node_id FROM temp_anlgraf WHERE arc_id = v_arc UNION 
		SELECT node_2 FROM temp_anlgraf WHERE arc_id = v_arc)a WHERE node_id::varchar IN 
		     (SELECT node_id FROM anl_mincut_result_valve WHERE result_id=v_mincutid AND ((unaccess = FALSE AND broken = FALSE))));
	-- get arc_id twin
	SELECT arc_id INTO v_arctwin FROM temp_anlgraf WHERE (node_1 = v_nodetwin OR node_2 = v_nodetwin) AND arc_id <> v_arc;
	
	-- 2) set the starting element
	v_querytext = 'UPDATE temp_anlgraf SET water=1 , flag = 1 WHERE arc_id='||quote_literal(v_arc); 
	EXECUTE v_querytext;
	
	EXECUTE v_querytext;-- inundation process
	LOOP	
		cont1 = cont1+1;
		UPDATE temp_anlgraf n SET water= 1, flag=n.flag+1 FROM v_anl_graf a WHERE n.node_1::integer = a.node_1::integer AND n.arc_id::integer = a.arc_id::integer;
		GET DIAGNOSTICS affected_rows =row_count;
		EXIT WHEN affected_rows = 0;
		EXIT WHEN cont1 = 100;
	END LOOP;

	IF v_arctwin IS NOT NULL THEN 
		v_querytext = 'UPDATE temp_anlgraf SET water=0 WHERE arc_id IN (SELECT arc_id FROM temp_anlgraf WHERE arc_id='||quote_literal(v_arctwin)||' LIMIT 1)';
		EXECUTE v_querytext;
	END IF;
	
	-- finish engine
	----------------
	-- insert arc results into table
	EXECUTE 'INSERT INTO anl_mincut_result_arc (result_id, arc_id, the_geom)
		SELECT '||v_mincutid||', a.arc_id, the_geom FROM (SELECT DISTINCT arc_id FROM temp_anlgraf WHERE water=1)a
		JOIN arc ON arc.arc_id::integer=a.arc_id
		ON CONFLICT (arc_id, result_id) DO NOTHING';

	-- insert node results into table
	EXECUTE 'INSERT INTO anl_mincut_result_node (result_id, node_id, the_geom)
		SELECT '||v_mincutid||', b.node_1, the_geom FROM (SELECT DISTINCT node_1, the_geom FROM
		(SELECT node_1,water FROM temp_anlgraf UNION SELECT node_2,water FROM temp_anlgraf)a
		JOIN node ON node.node_id::integer = a.node_1
		GROUP BY node_1, water, the_geom HAVING water=1) b
		ON CONFLICT (node_id, result_id) DO NOTHING';

	-- insert valve results into table
	IF v_mincutstep = 1 THEN 
		v_querytext = 'UPDATE anl_mincut_result_valve SET proposed=TRUE WHERE proposed IS NULL AND result_id = '||v_mincutid||' AND node_id IN 
			(SELECT node_1::varchar(16) FROM (
			select id, arc_id, node_1, node_2, water, flag, checkf from temp_anlgraf UNION select id, arc_id, node_2, node_1, water, flag, checkf from temp_anlgraf 
			)a group by node_1  having sum(flag) = 5)';
		EXECUTE v_querytext;

	ELSIF v_mincutstep = 2 THEN 
		v_querytext = 'UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE proposed IS NULL AND result_id = '||v_mincutid||' AND node_id IN 
			(SELECT node_1::varchar(16) FROM (
			select id, arc_id, node_1, node_2, water, flag, checkf from temp_anlgraf UNION select id, arc_id, node_2, node_1, water, flag, checkf from temp_anlgraf 
			)a group by node_1  having sum(water) > 1 and sum(flag) > 2)';
		EXECUTE v_querytext;
	
	END IF;

	v_querytext = 'UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE proposed IS NULL AND result_id = '||v_mincutid||' AND node_id IN 
			(SELECT node_1::varchar(16) FROM (
			select id, arc_id, node_1, node_2, water, flag, checkf from temp_anlgraf UNION select id, arc_id, node_2, node_1, water, flag, checkf from temp_anlgraf 
			)a group by node_1  having sum(flag) = 6)';
	EXECUTE v_querytext;
	
	-- set proposed = false for broken valves
	v_querytext = 'UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE broken = TRUE AND result_id = '||v_mincutid;
	EXECUTE v_querytext;	

	-- set proposed = false for closed valves
	v_querytext = 'UPDATE anl_mincut_result_valve SET proposed=FALSE WHERE closed = TRUE AND result_id = '||v_mincutid;
	EXECUTE v_querytext;

	
RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
