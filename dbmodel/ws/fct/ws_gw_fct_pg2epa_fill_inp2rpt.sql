/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_fill_inp2rpt(varchar);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_fill_inp2rpt(result_id_var varchar)  RETURNS integer AS $BODY$
DECLARE
    
   

BEGIN

-- Upsert on node rpt_inp result manager table
	DELETE FROM inp_selector_result WHERE cur_user=current_user;
	INSERT INTO inp_selector_result (result_id, cur_user) VALUES (result_id_var, current_user);

-- Upsert on node rpt_inp table
	DELETE FROM rpt_inp_node WHERE result_id=result_id_var;
	INSERT INTO rpt_inp_node (result_id, node_id, elevation, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, the_geom)
	SELECT 
	result_id_var,
	node_id, elevation, elevation-depth as elev, nodetype_id, nodecat_id, epa_type, sector_id, state, annotation, the_geom
	FROM v_node 
		JOIN inp_selector_sector ON inp_selector_sector.sector_id=v_node.sector_id
		JOIN value_state_type ON id=state_type
		WHERE (is_operative IS TRUE) OR (is_operative IS NULL);

-- Upsert on arc rpt_inp table
	DELETE FROM rpt_inp_arc WHERE result_id=result_id_var;
	INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, diameter, roughness, the_geom)
	SELECT
	result_id_var,
	v_arc_x_node.arc_id, node_1, node_2, v_arc_x_node.arctype_id, arccat_id, epa_type, sector_id, v_arc_x_node.state, v_arc_x_node.state_type, annotation,
	CASE
		WHEN custom_dint IS NOT NULL THEN custom_dint
		ELSE dint
	END AS diameter, 
	CASE
		WHEN custom_roughness IS NOT NULL THEN custom_roughness
		ELSE roughness
	END AS roughness,
	length,
	the_geom
	FROM v_arc_x_node
		JOIN inp_selector_sector ON inp_selector_sector.sector_id=v_node.sector_id
		JOIN value_state_type ON id=state_type
		JOIN cat_arc ON v_arc_x_node.arccat_id = cat_arc.id
		JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
		JOIN inp_pipe ON v_arc_x_node.arc_id = inp_pipe.arc_id
		JOIN inp_cat_mat_roughness ON inp_cat_mat_roughness.matcat_id = cat_mat_arc.id 
		WHERE (now()::date - builtdate)/365 >= inp_cat_mat_roughness.init_age and (now()::date - builtdate)/365 < inp_cat_mat_roughness.end_age
		AND (is_operative IS TRUE) OR (is_operative IS NULL);

    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;