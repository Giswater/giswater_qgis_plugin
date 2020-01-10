/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2234

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_fill_data(varchar);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_pg2epa_fill_data(result_id_var varchar)  RETURNS integer AS $BODY$
DECLARE
   
v_rainfall text;

BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

-- Delete previous results on rpt_inp_node & arc tables
   DELETE FROM rpt_inp_node WHERE result_id=result_id_var;
   DELETE FROM rpt_inp_arc WHERE result_id=result_id_var;
   
-- set all timeseries of raingage using user's value
   v_rainfall:= (SELECT value FROM config_param_user WHERE parameter='inp_options_setallraingages' AND cur_user=current_user);
	
	IF v_rainfall IS NOT NULL THEN
		UPDATE raingage SET timser_id=v_rainfall, rgage_type='TIMESERIES' WHERE expl_id IN (SELECT expl_id FROM selector_expl WHERE cur_user=current_user);
	END IF;

   
-- Insert on node rpt_inp table
-- the strategy of selector_sector is not used for nodes. The reason is to enable the posibility to export the sector=-1. In addition using this it's impossible to export orphan nodes
	INSERT INTO rpt_inp_node (result_id, node_id, top_elev, ymax, elev, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, expl_id, y0, ysur, apond, the_geom)
	SELECT 
	result_id_var,
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, node.state, 
	node.state_type, node.annotation, node.expl_id, y0, ysur, apond, node.the_geom
	FROM inp_selector_sector, node  -- we need to use node to make more easy the relation sector againts exploitation
		LEFT JOIN v_edit_node USING (node_id) -- we need to use v_edit_node to work with sys_* fields
		JOIN inp_junction ON node.node_id=inp_junction.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc UNION SELECT node_2 FROM vi_parent_arc)a ON node.node_id=a.node_id
	UNION
	SELECT 
	result_id_var,
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, node.state, 
	node.state_type, node.annotation, node.expl_id, y0, ysur, apond, node.the_geom
	FROM inp_selector_sector, node 
		LEFT JOIN v_edit_node USING (node_id) 
		JOIN inp_divider ON node.node_id=inp_divider.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc UNION SELECT node_2 FROM vi_parent_arc)a ON node.node_id=a.node_id
	UNION
	SELECT 
	result_id_var,
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, 
	node.state, node.state_type, node.annotation, node.expl_id, y0, ysur, apond, node.the_geom
	FROM inp_selector_sector, node 
		LEFT JOIN v_edit_node USING (node_id) 	
		JOIN inp_storage ON node.node_id=inp_storage.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc UNION SELECT node_2 FROM vi_parent_arc)a ON node.node_id=a.node_id
	UNION
	SELECT 
	result_id_var,
	node.node_id, sys_top_elev, sys_ymax, v_edit_node.sys_elev, node.node_type, node.nodecat_id, node.epa_type, node.sector_id, 
	node.state, node.state_type, node.annotation, node.expl_id, null, null, null, node.the_geom
	FROM inp_selector_sector, node 
		LEFT JOIN v_edit_node USING (node_id)
		JOIN inp_outfall ON node.node_id=inp_outfall.node_id
		JOIN (SELECT node_1 AS node_id FROM vi_parent_arc UNION SELECT node_2 FROM vi_parent_arc)a ON node.node_id=a.node_id;


	-- node onfly transformation of junctions to outfalls (when outfallparam is fill and junction is node sink)
	PERFORM gw_fct_anl_node_sink($${"client":{"device":3, "infoType":100, "lang":"ES"},"feature":{"tableName":"v_edit_inp_junction"},"data":{"parameters":{"saveOnDatabase":true}}}$$);

	UPDATE rpt_inp_node SET epa_type='OUTFALL' FROM anl_node a JOIN inp_junction USING (node_id) 
	WHERE outfallparam IS NOT NULL AND fprocesscat_id=13 AND cur_user=current_user
	AND rpt_inp_node.node_id=a.node_id AND rpt_inp_node.result_id=result_id_var;

-- Insert on arc rpt_inp table
	INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, elevmax1, elevmax2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, length, n, expl_id, the_geom)
	SELECT
	result_id_var,
	v_arc_x_node.arc_id, node_1, node_2, v_arc_x_node.sys_elev1, v_arc_x_node.sys_elev2, v_arc_x_node.arc_type, arccat_id, epa_type, v_arc_x_node.sector_id, v_arc_x_node.state, 
	v_arc_x_node.state_type, v_arc_x_node.annotation, 
	CASE
		WHEN custom_length IS NOT NULL THEN custom_length
		ELSE st_length2d(v_arc_x_node.the_geom)
	END AS length,
	CASE
		WHEN custom_n IS NOT NULL THEN custom_n
		ELSE n
	END AS n,
	v_arc_x_node.expl_id, 
	v_arc_x_node.the_geom
	FROM inp_selector_sector, v_arc_x_node
		LEFT JOIN value_state_type ON id=state_type
		LEFT JOIN cat_arc ON v_arc_x_node.arccat_id = cat_arc.id
		LEFT JOIN cat_mat_arc ON cat_arc.matcat_id = cat_mat_arc.id
		LEFT JOIN inp_conduit ON v_arc_x_node.arc_id = inp_conduit.arc_id
		WHERE ((is_operative IS TRUE) OR (is_operative IS NULL))
		AND v_arc_x_node.sector_id=inp_selector_sector.sector_id AND inp_selector_sector.cur_user=current_user;

    RETURN 1;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;