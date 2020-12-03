/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2902

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_inlet_flowtrace(p_result_id text)
RETURNS integer AS
$BODY$

/*
--EXAMPLE
SELECT gw_fct_pg2epa_inlet_flowtrace('testbgeo11')

--RESULTS
SELECT arc_id FROM anl_arc WHERE fid = 139 AND cur_user=current_user
SELECT node_id FROM anl_node WHERE fid = 139 AND cur_user=current_user
SELECT * FROM anl_mincut_arc_x_node  where cur_user=current_user;

fid: 139

*/


DECLARE
v_affectedrows numeric;
v_cont integer default 0;
v_buildupmode int2;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get user values
	v_buildupmode = (SELECT value FROM config_param_user WHERE parameter='inp_options_buildup_mode' AND cur_user=current_user);

	delete FROM anl_mincut_arc_x_node where cur_user=current_user;
	delete FROM anl_arc where cur_user=current_user AND fid = 139;
	delete FROM anl_node where cur_user=current_user AND fid = 139;

	-- fill the graf table
	insert into anl_mincut_arc_x_node (
	select  arc.arc_id, case when node_1 is null then '00000' else node_1 end, current_user, null, case when node_2 is null then '00000' else node_2 end, null, 0, 0
	from rpt_inp_arc arc
	WHERE arc.result_id=p_result_id
	union all
	select  arc.arc_id, case when node_2 is null then '00000' else node_2 end, current_user, null, case when node_1 is null then '00000' else node_1 end, null, 0, 0
	from rpt_inp_arc arc
	WHERE arc.result_id=p_result_id
	) ON CONFLICT (arc_id, node_id, cur_user) DO NOTHING;
	
	-- Delete from the graf table all that rows that only exists one time (it means that arc don't have the correct topology)
	DELETE FROM anl_mincut_arc_x_node WHERE cur_user=current_user AND arc_id IN 
	(SELECT a.arc_id FROM (SELECT count(*) AS count, arc_id FROM anl_mincut_arc_x_node GROUP BY 2 HAVING count(*)=1 ORDER BY 2)a);

	-- init inlets
	IF v_buildupmode = 1 THEN
		UPDATE anl_mincut_arc_x_node
			SET flag1=1, water=1 
			WHERE node_id IN (SELECT node_id FROM rpt_inp_node WHERE (epa_type='RESERVOIR' OR epa_type='INLET' OR epa_type='TANK') and result_id=p_result_id)
			AND anl_mincut_arc_x_node.cur_user=current_user; 

	ELSIF v_buildupmode = 2 THEN 
		UPDATE anl_mincut_arc_x_node
			SET flag1=1, water=1 
			WHERE node_id IN (SELECT node_id FROM rpt_inp_node WHERE (epa_type='RESERVOIR' OR epa_type='INLET') and result_id=p_result_id)
			AND anl_mincut_arc_x_node.cur_user=current_user; 
	END IF;
		
	-- inundation process
	LOOP
	v_cont = v_cont+1;

		update anl_mincut_arc_x_node n
		set water= 1, flag1=n.flag1+1
		from v_anl_mincut_flowtrace a
		where n.node_id = a.node_id and
		n.arc_id = a.arc_id;

		GET DIAGNOSTICS v_affectedrows =row_count;

		exit when v_affectedrows = 0;
		EXIT when v_cont = 200;

	END LOOP;

	-- insert into result table the dry arcs (water=0)
	INSERT INTO anl_arc (fid, result_id, arc_id, the_geom, descript)
	SELECT DISTINCT ON (a.arc_id) 139, p_result_id, a.arc_id, the_geom, 'Arc disconnected from any reservoir'  
		FROM anl_mincut_arc_x_node a
		JOIN rpt_inp_arc b ON a.arc_id=b.arc_id
		GROUP BY a.arc_id, cur_user, the_geom
		having max(water) = 0 and cur_user=current_user;
		
	-- insert into result table the dry nodes (as they are extremal nodes from disconnected arcs, all it's ok
	INSERT INTO anl_node (fid, result_id, node_id, the_geom, descript)
	SELECT 139, p_result_id, rpt_inp_arc.node_1, n.the_geom, 'Node disconnected from any reservoir' FROM rpt_inp_arc JOIN anl_arc USING (arc_id) 
		JOIN rpt_inp_node n ON rpt_inp_arc.node_1=node_id WHERE fid = 139 AND n.result_id = p_result_id AND cur_user=current_user UNION
		SELECT 139, p_result_id, rpt_inp_arc.node_2, n.the_geom, 'Node disconnected from any reservoir' FROM rpt_inp_arc JOIN anl_arc USING (arc_id) 
		JOIN rpt_inp_node n ON rpt_inp_arc.node_2=node_id WHERE fid = 139 AND n.result_id = p_result_id AND cur_user=current_user;

	RETURN v_cont;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
