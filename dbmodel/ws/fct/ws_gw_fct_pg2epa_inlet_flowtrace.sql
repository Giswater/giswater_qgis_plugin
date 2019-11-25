/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2680

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_inlet_flowtrace(p_result_id text)
RETURNS integer AS
$BODY$

/*
--EXAMPLE
SELECT gw_fct_pg2epa_inlet_flowtrace('testbgeo11')

--RESULTS
SELECT * FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user
SELECT * FROM anl_mincut_arc_x_node  where user_name=current_user;
*/

DECLARE
affected_roSCHEMA_NAME numeric;
cont1 integer default 0;
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

	delete FROM anl_mincut_arc_x_node where user_name=current_user;
	delete FROM anl_arc where cur_user=current_user AND fprocesscat_id=39;


	-- fill the graf table
	insert into anl_mincut_arc_x_node (
	select  arc.arc_id, case when node_1 is null then '00000' else node_1 end, current_user, null, case when node_2 is null then '00000' else node_2 end, null, 0, 0
	from rpt_inp_arc arc
	WHERE arc.result_id=p_result_id
	union all
	select  arc.arc_id, case when node_2 is null then '00000' else node_2 end, current_user, null, case when node_1 is null then '00000' else node_1 end, null, 0, 0
	from rpt_inp_arc arc
	WHERE arc.result_id=p_result_id
	);
	
	-- Delete from the graf table all that roSCHEMA_NAME that only exists one time (it means that arc don't have the correct topology)
	DELETE FROM anl_mincut_arc_x_node WHERE user_name=current_user AND arc_id IN 
	(SELECT a.arc_id FROM (SELECT count(*) AS count, arc_id FROM anl_mincut_arc_x_node GROUP BY 2 HAVING count(*)=1 ORDER BY 2)a);

	-- init inlets
	UPDATE anl_mincut_arc_x_node
		SET flag1=1, water=1 
		WHERE node_id IN (SELECT node_id FROM rpt_inp_node WHERE epa_type='RESERVOIR' and result_id=p_result_id)
		AND anl_mincut_arc_x_node.user_name=current_user; 

	-- inundation process
	LOOP
	cont1 = cont1+1;

		update anl_mincut_arc_x_node n
		set water= 1, flag1=n.flag1+1
		from v_anl_mincut_flowtrace a
		where n.node_id = a.node_id and
		n.arc_id = a.arc_id;

		GET DIAGNOSTICS affected_roSCHEMA_NAME =row_count;

		exit when affected_roSCHEMA_NAME = 0;
		EXIT when cont1 = 200;

	END LOOP;

	-- insert into result table the dry arcs (water=0)
	INSERT INTO anl_arc (fprocesscat_id, result_id, arc_id, the_geom, descript)
	SELECT DISTINCT ON (a.arc_id) 39, p_result_id, a.arc_id, the_geom, 'Arc disconnected from any reservoir'  
		FROM anl_mincut_arc_x_node a
		JOIN arc b ON a.arc_id=b.arc_id
		GROUP BY a.arc_id, user_name, the_geom
		having max(water) = 0 and user_name=current_user;
		

	-- insert into result table the dry arcs (water=0)
	INSERT INTO anl_node (fprocesscat_id, result_id, node_id, the_geom, descript)
	SELECT 39, p_result_id, node_1, n.the_geom, 'Node disconnected from any reservoir' FROM arc JOIN anl_arc USING (arc_id) 
	JOIN node n ON node_1=node_id WHERE fprocesscat_id=39 AND result_id = p_result_id AND cur_user=current_user UNION
	SELECT 39, p_result_id, node_2, n.the_geom, 'Node disconnected from any reservoir' FROM arc JOIN anl_arc USING (arc_id) 
	JOIN node n ON node_2=node_id WHERE fprocesscat_id=39 AND result_id = p_result_id AND cur_user=current_user;

RETURN cont1;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
