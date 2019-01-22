/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

CREATE OR REPLACE VIEW v_edit_field_valve AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.elevation,
    v_node.depth,
    v_node.nodetype_id,
    v_node.nodecat_id,
    v_node.cat_matcat_id,
    v_node.cat_pnom,
    v_node.cat_dnom,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.arc_id,
    v_node.parent_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.presszonecat_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetaxis_id,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.postcomplement2,
    v_node.streetaxis2_id,
    v_node.postnumber2,
    v_node.descript,
    v_node.svg,
    v_node.rotation,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.hemisphere,
    v_node.num_value,
    man_valve.closed,
    man_valve.broken,
    man_valve.buried,
    man_valve.irrigation_indicator,
    man_valve.pression_entry,
    man_valve.pression_exit,
    man_valve.depth_valveshaft,
    man_valve.regulator_situation,
    man_valve.regulator_location,
    man_valve.regulator_observ,
    man_valve.lin_meters,
    man_valve.exit_type,
    man_valve.exit_code,
    man_valve.drive_type,
    man_valve.cat_valve2
   FROM v_node
     JOIN man_valve ON man_valve.node_id::text = v_node.node_id::text;



DROP VIEW IF EXISTS "v_anl_mincut_init_point" CASCADE; 
CREATE OR REPLACE VIEW v_anl_mincut_init_point AS
SELECT
 anl_mincut_result_cat.id AS result_id,
    anl_mincut_result_cat.work_order,
    anl_mincut_cat_state.name AS mincut_state,
    anl_mincut_cat_class.name AS mincut_class,
    anl_mincut_result_cat.mincut_type,
    anl_mincut_result_cat.received_date,
    exploitation.name AS expl_name,
    macroexploitation.name AS macroexpl_name,
    ext_municipality.name AS muni_name,
    anl_mincut_result_cat.postcode,
    ext_streetaxis.name AS street_name,
    anl_mincut_result_cat.postnumber,
    anl_mincut_result_cat.anl_cause,
    anl_mincut_result_cat.anl_tstamp,
    anl_mincut_result_cat.anl_user,
    anl_mincut_result_cat.anl_descript,
    anl_mincut_result_cat.anl_feature_id,
    anl_mincut_result_cat.anl_feature_type,
    anl_mincut_result_cat.anl_the_geom,
    anl_mincut_result_cat.forecast_start,
    anl_mincut_result_cat.forecast_end,
    anl_mincut_result_cat.assigned_to,
    anl_mincut_result_cat.exec_start,
    anl_mincut_result_cat.exec_end,
    anl_mincut_result_cat.exec_user,
    anl_mincut_result_cat.exec_descript,
    anl_mincut_result_cat.exec_from_plot,
    anl_mincut_result_cat.exec_depth,
    anl_mincut_result_cat.exec_appropiate
   FROM anl_mincut_result_selector,
    anl_mincut_result_cat
     LEFT JOIN anl_mincut_cat_class ON anl_mincut_cat_class.id = anl_mincut_result_cat.mincut_class
     LEFT JOIN anl_mincut_cat_state ON anl_mincut_cat_state.id = anl_mincut_result_cat.mincut_state
     LEFT JOIN exploitation ON anl_mincut_result_cat.expl_id = exploitation.expl_id
     LEFT JOIN macroexploitation ON anl_mincut_result_cat.macroexpl_id = macroexploitation.macroexpl_id
     LEFT JOIN ext_streetaxis ON anl_mincut_result_cat.streetaxis_id::text = ext_streetaxis.id::text
	 LEFT JOIN ext_municipality ON anl_mincut_result_cat.muni_id = ext_municipality.muni_id
  WHERE anl_mincut_result_selector.result_id = anl_mincut_result_cat.id AND anl_mincut_result_selector.cur_user = "current_user"()::text;

	 