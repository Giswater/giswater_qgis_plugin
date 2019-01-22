/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2540

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_inlet_flowtrace(result_id_arg integer, p_node_id varchar)
RETURNS integer AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_mincut_inlet_flowtrace(-1, '113766')
SELECT SCHEMA_NAME.gw_fct_mincut_inlet_flowtrace(-1, '113952')

--RESULTS
SELECT feature_id, log_message FROM SCHEMA_NAME.audit_log_data WHERE fprocesscat_id=35 AND user_name=current_user
*/

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
	select  v_edit_arc.arc_id, node1.node_id, current_user, left(node1.nodecat_id,4), node2.node_id, left(node2.nodecat_id,4), 0, 0
	from v_edit_arc
	inner join v_edit_node AS node1 on node_1 = node1.node_id
	inner join v_edit_node AS node2 on node_2 = node2.node_id
	union all
	select  v_edit_arc.arc_id, node1.node_id, current_user, left(node1.nodecat_id,4), node2.node_id, left(node2.nodecat_id,4), 0, 0
	from v_edit_arc
	inner join v_edit_node AS node1 on node_2 = node1.node_id
	inner join v_edit_node AS node2 on node_1 = node2.node_id);
	
	-- Delete from the graf table all that rows that only exists one time (it means that arc don't have the correct topology)
	DELETE FROM anl_mincut_arc_x_node WHERE arc_id IN 
	(SELECT a.arc_id FROM 
	(SELECT count(*) AS count, arc_id FROM anl_mincut_arc_x_node GROUP BY 2 HAVING count(*)=1 ORDER BY 2)a);
		
	-- Init valves on graf table
	UPDATE anl_mincut_arc_x_node 
	SET flag1=2
	FROM anl_mincut_result_valve WHERE result_id=result_id_arg AND (proposed=TRUE OR closed=TRUE)
	AND anl_mincut_arc_x_node.node_id = anl_mincut_result_valve.node_id 
	AND user_name=current_user;

	-- init inlets
	IF p_node_id IS NULL THEN
		-- Init all inlets on graf table
		UPDATE anl_mincut_arc_x_node
		SET flag1=1, water=1 
		FROM anl_mincut_inlet_x_exploitation 
		JOIN selector_expl ON selector_expl.expl_id=anl_mincut_inlet_x_exploitation.expl_id 
		WHERE anl_mincut_arc_x_node.node_id=anl_mincut_inlet_x_exploitation.node_id 
		AND anl_mincut_arc_x_node.node_id NOT IN (select node_id FROM anl_mincut_result_node WHERE result_id=result_id_arg)
		AND cur_user=current_user AND anl_mincut_arc_x_node.user_name=current_user; 
	ELSE 
		-- In only the p_node inlet
		UPDATE anl_mincut_arc_x_node
		SET flag1=1, water=1 
		WHERE node_id=p_node_id
		AND anl_mincut_arc_x_node.user_name=current_user; 
	END IF;

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
		arc_id,
		max(water) AS water
		FROM anl_mincut_arc_x_node
		GROUP BY arc_id, user_name
		having max(water) = 0 and user_name=current_user)

		insert into anl_mincut_result_arc (result_id, arc_id)
		select distinct on (arc_id) result_id_arg, result_arc.arc_id
		from result_arc left join anl_mincut_result_arc on result_arc.arc_id = anl_mincut_result_arc.arc_id;

		-- Working with the case of study of inlet dynamic sector analysis (om_mincut_analysis_dinletsector=true)
		IF (SELECT value::boolean FROM config_param_user WHERE parameter='om_mincut_analysis_dinletsector' AND cur_user=current_user) IS TRUE THEN
			-- insert into log traceability table
			WITH result_arc AS (
				SELECT 
				arc_id,
				max(water) AS water
				FROM SCHEMA_NAME.anl_mincut_arc_x_node
				GROUP BY arc_id, user_name
				having max(water) != 0 and user_name=current_user)
		
			INSERT INTO audit_log_data (fprocesscat_id, feature_type, feature_id, log_message) 
			SELECT  distinct on (result_arc.arc_id) 35, 'arc', result_arc.arc_id, p_node_id 
			from result_arc left join SCHEMA_NAME.anl_mincut_result_arc on result_arc.arc_id = anl_mincut_result_arc.arc_id;
		END IF;
RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
