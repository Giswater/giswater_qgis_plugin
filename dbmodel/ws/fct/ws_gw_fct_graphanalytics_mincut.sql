/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)

--FUNCTION CODE: 2708

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_grafanalytics_mincut(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_mincut(p_data json)
RETURNS integer AS
$BODY$

/*
TO EXECUTE
INSERT INTO om_mincut values (-1);
select SCHEMA_NAME.gw_fct_mincut('132328', 'arc', 1718)

for step:1 an initial inundation process must be executed from specific arc
for step:2 all arc on the other side for valves of step1 have been setted before. As result no arc is needed
SELECT SCHEMA_NAME.gw_fct_graphanalytics_mincut('{"data":{"arc":"2001", "step":1, "parameters":{"id":-1}}}')
SELECT SCHEMA_NAME.gw_fct_graphanalytics_mincut('{"data":{"step":2, "parameters":{"id":-1}}}')

*/

DECLARE

v_class text = 'MINCUT';
v_feature record;
v_data json;
v_arcid text;
v_mincutid integer;
v_mincutstep integer;
v_arc text;
v_querytext text;
affected_rows numeric;
cont1 integer default 0;
v_arctwin text;
v_nodetwin text;
v_checkvalve record;
v_isrecursive boolean;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get variables
	v_mincutstep = (SELECT (p_data::json->>'data')::json->>'step');
	v_arc = (SELECT (p_data::json->>'data')::json->>'arc');
	v_mincutid = ((SELECT (p_data::json->>'data')::json->>'parameters')::json->>'id');
	v_isrecursive = ((SELECT (p_data::json->>'data')::json->>'parameters')::json->>'isRecursive');


	IF v_mincutstep = 1 THEN 

		-- reset selectors
		DELETE FROM selector_state WHERE cur_user=current_user;
		INSERT INTO selector_state (state_id, cur_user) VALUES (1, current_user);

		-- reset graph table
		TRUNCATE temp_anlgraph;

		-- create graph
		INSERT INTO temp_anlgraph (arc_id, node_1, node_2, water, flag, checkf )
		SELECT arc_id, node_1, node_2, 0, 0, 0 FROM v_edit_arc 
		WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE
		UNION
		SELECT arc_id, node_2, node_1, 0, 0, 0 FROM v_edit_arc 
		WHERE node_1 IS NOT NULL AND node_2 IS NOT NULL AND is_operative=TRUE;

		-- setup graph closing proposable valves
		UPDATE temp_anlgraph SET flag = 1
		FROM om_mincut_valve WHERE result_id=v_mincutid AND ((unaccess = FALSE AND broken = FALSE))
		AND (temp_anlgraph.node_1 = om_mincut_valve.node_id OR temp_anlgraph.node_2 = om_mincut_valve.node_id);
		
		-- setup graph closing check-valves
		UPDATE temp_anlgraph SET flag = 1 
		FROM config_graph_checkvalve c 
		WHERE (temp_anlgraph.node_1 = c.node_id OR temp_anlgraph.node_2 = c.node_id);
		
		-- setup graph closing closed valves
		UPDATE temp_anlgraph SET flag = 1 
		FROM om_mincut_valve WHERE result_id=v_mincutid AND closed=TRUE 
		AND (temp_anlgraph.node_1 = om_mincut_valve.node_id OR temp_anlgraph.node_2 = om_mincut_valve.node_id);
		
		-- setup graph closing tank's inlet
		UPDATE temp_anlgraph SET flag = 1 

		FROM config_graph_inlet 
		WHERE (temp_anlgraph.node_1 = config_graph_inlet.node_id OR temp_anlgraph.node_2 = config_graph_inlet.node_id);

		-- setup graph reset water flag
		UPDATE temp_anlgraph SET water=0;

		-- set the starting element
		v_querytext = 'UPDATE temp_anlgraph SET water=1 , flag = 1 WHERE arc_id='||quote_literal(v_arc); 
		EXECUTE v_querytext;

		
	ELSIF v_mincutstep = 2 THEN 

		-- setup graph reset water and flag
		UPDATE temp_anlgraph SET water=0, flag=0;

		-- setup graph closing only proposed valves closed on step1
		UPDATE temp_anlgraph SET flag = 1
		FROM om_mincut_valve WHERE result_id=v_mincutid AND proposed = TRUE
		AND (temp_anlgraph.node_1 = om_mincut_valve.node_id OR temp_anlgraph.node_2 = om_mincut_valve.node_id);

		-- setup graph closing check-valves
		UPDATE temp_anlgraph SET flag = 1 
		FROM config_graph_checkvalve c 
		WHERE (temp_anlgraph.node_1 = c.node_id OR temp_anlgraph.node_2 = c.node_id);

		-- setup graph closing closed valves
		UPDATE temp_anlgraph SET flag = 1
		FROM om_mincut_valve WHERE result_id=v_mincutid AND closed=TRUE 
		AND (temp_anlgraph.node_1 = om_mincut_valve.node_id OR temp_anlgraph.node_2 = om_mincut_valve.node_id);

		-- setup graph closing tank's inlet
		UPDATE temp_anlgraph SET flag = 1
		FROM config_graph_inlet 
		WHERE (temp_anlgraph.node_1 = config_graph_inlet.node_id OR temp_anlgraph.node_2 = config_graph_inlet.node_id);
	
		-- set the starting elements
		UPDATE temp_anlgraph SET water=1 , flag = 1 WHERE arc_id::text IN (SELECT arc_id FROM temp_arc WHERE result_id = v_mincutid::text);
		
	END IF;

	-- start engine
	---------------
	UPDATE temp_anlgraph SET checkf = 0;
	
	LOOP	
		cont1 = cont1+1;
		UPDATE temp_anlgraph n SET water = 1, flag = n.flag+1, checkf = checkf + 1 FROM v_anl_graph a WHERE n.node_1 = a.node_1 AND n.arc_id = a.arc_id;
		GET DIAGNOSTICS affected_rows =row_count;
		EXIT WHEN affected_rows = 0;
	END LOOP;

	-- 2) remove results (arc twin as closest choosed arc connected with valve if click on user takes it)
	IF v_mincutstep = 1 THEN 

		UPDATE temp_anlgraph SET water=0 WHERE arc_id IN (

			SELECT distinct (t.arc_id) FROM temp_anlgraph t JOIN 
			(SELECT node_1 AS node_id, arc_id FROM temp_anlgraph WHERE arc_id = v_arc UNION SELECT node_2, arc_id FROM temp_anlgraph WHERE arc_id = v_arc) a
			ON a.node_id = node_1 or a.node_id = node_2
			JOIN om_mincut_valve v on v.node_id = a.node_id::text
			WHERE result_id=v_mincutid AND (unaccess = FALSE AND broken = FALSE)
			AND t.arc_id <> a.arc_id);
	END IF;

	-- finish engine
	----------------
	-- insert arc results into table
	EXECUTE 'INSERT INTO om_mincut_arc (result_id, arc_id, the_geom)
		SELECT '||v_mincutid||', a.arc_id, the_geom FROM (SELECT DISTINCT arc_id FROM temp_anlgraph WHERE water=1)a
		JOIN arc ON arc.arc_id=a.arc_id
		ON CONFLICT (arc_id, result_id) DO NOTHING';

	-- insert node results into table
	EXECUTE 'INSERT INTO om_mincut_node (result_id, node_id, the_geom, node_type)
		SELECT '||v_mincutid||', b.node_1, the_geom, b.nodetype_id FROM (SELECT DISTINCT node_1, the_geom, nodetype_id FROM
		(SELECT node_1,water FROM temp_anlgraph UNION SELECT node_2,water FROM temp_anlgraph)a
		JOIN node ON node.node_id = a.node_1
		JOIN cat_node cn ON node.nodecat_id=cn.id
		GROUP BY node_1, water, the_geom, nodetype_id HAVING water=1) b
		ON CONFLICT (node_id, result_id) DO NOTHING';

	-- insert valve results into table
	IF v_mincutstep = 1 THEN 
		v_querytext = 'UPDATE om_mincut_valve SET proposed=TRUE WHERE proposed IS NULL AND result_id = '||v_mincutid||' AND node_id IN 
			(SELECT node_1::varchar(16) FROM (
			select id, arc_id, node_1, node_2, water, flag from temp_anlgraph where checkf > 0 UNION select id, arc_id, node_2, node_1, water, flag from temp_anlgraph  where checkf > 0 
			)a)';
		EXECUTE v_querytext;

	ELSIF v_mincutstep = 2 THEN 
	
		v_querytext = 'UPDATE om_mincut_valve SET proposed=FALSE WHERE proposed IS NULL AND result_id = '||v_mincutid||' AND node_id IN 
			(SELECT node_1::varchar(16) FROM (
			select id, arc_id, node_1, node_2, water, flag, checkf from temp_anlgraph where checkf > 0 UNION select id, arc_id, node_2, node_1, water, flag, checkf from temp_anlgraph  where checkf > 0 
			)a group by node_1  having sum(water) > 1 and sum(flag) > 2 or  sum(flag) = 6)';
		EXECUTE v_querytext;
	
	END IF;

	-- looking for check-valves
	FOR v_checkvalve IN 
	SELECT config_graph_checkvalve.* FROM om_mincut_valve JOIN config_graph_checkvalve USING (node_id) WHERE proposed = true and result_id = v_mincutid
	AND active IS TRUE
	LOOP
		IF v_checkvalve.to_arc IN (SELECT arc_id FROM om_mincut_arc WHERE result_id = v_mincutid) AND v_isrecursive IS NOT TRUE THEN  -- checkvalve is proposed valve and to_arc is wet

			v_arc = (SELECT distinct(arc_id) FROM temp_anlgraph WHERE (node_1::text = v_checkvalve.node_id OR  node_2::text = v_checkvalve.node_id) AND arc_id::text != v_checkvalve.to_arc::text);
		
			-- mincut must continue
			PERFORM gw_fct_graphanalytics_mincut(concat('{"data":{"arc":"',v_arc,'", "step":1, "parameters":{"isRecursive":true, "id":',v_mincutid,'}}}')::json);

		END IF;
	END LOOP;

	-- set proposed = false for broken valves
	v_querytext = 'UPDATE om_mincut_valve SET proposed=FALSE WHERE broken = TRUE AND result_id = '||v_mincutid;
	EXECUTE v_querytext;	

	-- set proposed = false for closed valves
	v_querytext = 'UPDATE om_mincut_valve SET proposed=FALSE WHERE closed = TRUE AND result_id = '||v_mincutid;
	EXECUTE v_querytext;

	-- set proposed = false for check valves (as they act as automatic mode)
	v_querytext = 'UPDATE om_mincut_valve v SET proposed=FALSE FROM (SELECT node_id FROM config_graph_checkvalve WHERE active IS TRUE ) a 
		       WHERE a.node_id = v.node_id AND result_id = '||v_mincutid;
	EXECUTE v_querytext;

	
RETURN 1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
