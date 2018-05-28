/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_inlet_flowtrace(result_id_arg integer)
RETURNS integer AS
$BODY$
DECLARE
affected_rows numeric;
cont1 integer default 0;
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	delete FROM anl_mincut_arc_x_node where user_name=current_user;
	delete FROM anl_mincut_result_arc where result_id=result_id_arg;

	-- fill the graf table
	insert into anl_mincut_arc_x_node (
	select  arc.arc_id, node1.node_id, current_user, left(node1.nodecat_id,4), node2.node_id, left(node2.nodecat_id,4), 0, 0
	from v_edit_arc arc
	inner join v_edit_node AS node1 on arc.node_1 = node1.node_id
	inner join v_edit_node AS node2 on arc.node_2 = node2.node_id
	union all
	select  arc.arc_id, node1.node_id, current_user, left(node1.nodecat_id,4), node2.node_id, left(node2.nodecat_id,4), 0, 0
	from v_edit_arc arc
	inner join v_edit_node AS node1 on arc.node_2 = node1.node_id
	inner join v_edit_node AS node2 on arc.node_1 = node2.node_id);
	
	
	-- Delete from the graf table all that rows that only exists one time (it means that arc don't have the correct topology)
	DELETE FROM anl_mincut_arc_x_node WHERE arc_id IN 
	(SELECT a.arc_id FROM 
	(SELECT count(*) AS count, arc_id FROM anl_mincut_arc_x_node GROUP BY 2 HAVING count(*)=1 ORDER BY 2)a);
		
		
	-- Init valves on graf table
	UPDATE anl_mincut_arc_x_node 
	SET flag1=2
	FROM anl_mincut_result_valve WHERE result_id=result_id_arg AND (proposed=TRUE OR closed=TRUE)
	AND anl_mincut_arc_x_node.node_ID = anl_mincut_result_valve.node_id 
	AND user_name=current_user;

	-- Init inlets on graf table
	UPDATE anl_mincut_arc_x_node
	SET flag1=1, water=1 
	FROM anl_mincut_inlet_x_exploitation 
	JOIN selector_expl ON selector_expl.expl_id=anl_mincut_inlet_x_exploitation.expl_id 
	WHERE anl_mincut_arc_x_node.node_id=anl_mincut_inlet_x_exploitation.node_id 
	AND anl_mincut_arc_x_node.node_id NOT IN (select node_id FROM anl_mincut_result_node WHERE result_id=result_id_arg)
	AND cur_user=current_user AND anl_mincut_arc_x_node.user_name=current_user; 

	-- inundation process
	LOOP
	cont1 = cont1+1;

		update anl_mincut_arc_x_node n
		set water= 1, flag1=n.flag1+1
		from v_anl_mincut_flowtrace a
		where n.node_id = a.node_id and
		n.arc_id = a.arc_id;

		GET DIAGNOSTICS affected_rows =row_count;

		exit when affected_rows = 0;
		EXIT when cont1 = 200;

	END LOOP;

	-- update to false the dry valves (water=0) on both sides
	WITH result_valve_false AS (
		SELECT 
		anl_mincut_result_valve.node_id, sum(water) as sumwater FROM anl_mincut_arc_x_node, anl_mincut_result_valve 
		where user_name=current_user 
		AND result_id=result_id_arg AND anl_mincut_result_valve.node_id=anl_mincut_arc_x_node.node_id_a
		group by 1)
		
		UPDATE anl_mincut_result_valve SET proposed=FALSE 
		FROM result_valve_false WHERE result_valve_false.node_id=anl_mincut_result_valve.node_id
		AND result_id=result_id_arg AND sumwater=0;
	 

	-- insert into result table the dry arcs (water=0)
	WITH result_arc AS (
		SELECT 
		anl_mincut_arc_x_node.arc_id,
		max(anl_mincut_arc_x_node.water) AS water
		FROM anl_mincut_arc_x_node
		GROUP BY anl_mincut_arc_x_node.arc_id, user_name
		having max(anl_mincut_arc_x_node.water) = 0 and user_name=current_user)

		insert into anl_mincut_result_arc (result_id, arc_id)
		select distinct on (arc_id) result_id_arg, result_arc.arc_id
		from result_arc left join anl_mincut_result_arc on result_arc.arc_id = anl_mincut_result_arc.arc_id;
		
RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
