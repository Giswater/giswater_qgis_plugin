/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2234

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_fill_data(varchar);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_fill_data(result_id_var varchar)  RETURNS integer AS $BODY$
DECLARE
    


BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

-- Upsert on rpt_cat_table
	DELETE FROM rpt_cat_result WHERE result_id=result_id_var;
	INSERT INTO rpt_cat_result (result_id) VALUES (result_id_var);
	
-- Upsert on node rpt_inp result manager table
	DELETE FROM inp_selector_result WHERE cur_user=current_user;
	INSERT INTO inp_selector_result (result_id, cur_user) VALUES (result_id_var, current_user);

-- Upsert on node rpt_inp table
	INSERT INTO rpt_inp_node (result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, expl_id, y0, ysur, apond, the_geom)
	SELECT 
	result_id_var,
	v_node.node_id, sys_top_elev, sys_ymax, sys_elev, node_type, nodecat_id, epa_type, v_node.sector_id, v_node.state, v_node.state_type, annotation, expl_id, y0, ysur, apond, the_geom
	FROM inp_selector_sector, v_node 
		LEFT JOIN value_state_type ON id=state_type
		JOIN inp_junction ON v_node.node_id=inp_junction.node_id
		WHERE ((is_operative IS TRUE) OR (is_operative IS NULL))
		AND v_node.sector_id=inp_selector_sector.sector_id AND inp_selector_sector.cur_user=current_user
	UNION
	SELECT 
	result_id_var,
	v_node.node_id, sys_top_elev, sys_ymax, sys_elev, node_type, nodecat_id, epa_type, v_node.sector_id, v_node.state, v_node.state_type, annotation, expl_id, y0, ysur, apond, the_geom
	FROM inp_selector_sector, v_node 
		LEFT JOIN value_state_type ON id=state_type
		JOIN inp_divider ON v_node.node_id=inp_divider.node_id
		WHERE ((is_operative IS TRUE) OR (is_operative IS NULL))
		AND v_node.sector_id=inp_selector_sector.sector_id AND inp_selector_sector.cur_user=current_user
	UNION
	SELECT 
	result_id_var,
	v_node.node_id, sys_top_elev, sys_ymax, sys_elev, node_type, nodecat_id, epa_type, v_node.sector_id, v_node.state, v_node.state_type, annotation, expl_id, y0, ysur, apond, the_geom
	FROM inp_selector_sector, v_node 
		LEFT JOIN value_state_type ON id=state_type
		JOIN inp_storage ON v_node.node_id=inp_storage.node_id
		WHERE ((is_operative IS TRUE) OR (is_operative IS NULL))
		AND v_node.sector_id=inp_selector_sector.sector_id AND inp_selector_sector.cur_user=current_user
	UNION
	SELECT 
	result_id_var,
	v_node.node_id, sys_top_elev, sys_ymax, sys_elev, node_type, nodecat_id, epa_type, v_node.sector_id, v_node.state, v_node.state_type, annotation, expl_id, null, null, null, the_geom
	FROM inp_selector_sector, v_node 
		LEFT JOIN value_state_type ON id=state_type
		JOIN inp_outfall ON v_node.node_id=inp_outfall.node_id
		WHERE ((is_operative IS TRUE) OR (is_operative IS NULL))
		AND v_node.sector_id=inp_selector_sector.sector_id AND inp_selector_sector.cur_user=current_user;



-- Upsert on arc rpt_inp table
	INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, n, expl_id, the_geom)
	SELECT
	result_id_var,
	v_arc_x_node.arc_id, node_1, node_2, v_arc_x_node.sys_elev1, v_arc_x_node.sys_elev2, v_arc_x_node.arc_type, arccat_id, epa_type, v_arc_x_node.sector_id, v_arc_x_node.state, 
	v_arc_x_node.state_type, annotation, st_length2d(the_geom),
	CASE
		WHEN custom_n IS NOT NULL THEN custom_n
		ELSE n
	END AS n,
	expl_id, 
	the_geom
	FROM inp_selector_sector, v_arc_x_node
		LEFT JOIN value_state_type ON id=state_type
		JOIN cat_arc ON v_arc_x_node.arccat_id = cat_arc.id
		JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
		LEFT JOIN inp_conduit ON v_arc_x_node.arc_id = inp_conduit.arc_id
		WHERE ((is_operative IS TRUE) OR (is_operative IS NULL))
		AND v_arc_x_node.sector_id=inp_selector_sector.sector_id AND inp_selector_sector.cur_user=current_user;

    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;