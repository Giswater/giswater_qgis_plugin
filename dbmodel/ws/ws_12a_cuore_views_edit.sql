/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


DROP VIEW IF EXISTS v_edit_man_tank CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tank AS 
 SELECT node.node_id,
    node.elevation AS tank_elevation,
    node.depth AS tank_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS tank_state,
    node.annotation AS tank_annotation,
    node.observ AS tank_observ,
    node.comment AS tank_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS tank_soilcat_id,
    node.category_type AS tank_category_type,
    node.fluid_type AS tank_fluid_type,
    node.location_type AS tank_location_type,
    node.workcat_id AS tank_workcat_id,
    node.workcat_id_end AS tank_workcat_id_end,
    node.buildercat_id AS tank_buildercat_id,
    node.builtdate AS tank_builtdate,
    node.ownercat_id AS tank_ownercat_id,
    node.adress_01 AS tank_adress_01,
    node.adress_02 AS tank_adress_02,
    node.adress_03 AS tank_adress_03,
    node.descript AS tank_descript,
    cat_node.svg AS tank_cat_svg,
    node.rotation AS tank_rotation,
    node.link AS tank_link,
    node.verified,
    node.the_geom,
    node.undelete,
    node.label_x AS tank_label_x,
    node.label_y AS tank_label_y,
    node.label_rotation AS tank_label_rotation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    man_tank.vmax AS tank_vmax,
    man_tank.area AS tank_area,
    man_tank.chlorination AS tank_chlorination,
    man_tank.function AS tank_function,
	node.code AS tank_code,
	node.publish,
	node.inventory,
	node.end_date AS tank_end_date,
	node.macrodma_id,
	man_tank.pol_id,
	exploitation.descript AS expl_name
FROM expl_selector, node
	LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_tank ON man_tank.node_id::text = node.node_id::text
     LEFT JOIN inp_tank ON inp_tank.node_id::text = man_tank.node_id::text
	 JOIN exploitation ON node.expl_id=exploitation.expl_id
	WHERE ((node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text);

	
	DROP VIEW IF EXISTS v_edit_man_tank_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_tank_pol AS 
 SELECT node.node_id,
    node.elevation AS tank_elevation,
    node.depth AS tank_depth,
    node.node_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    cat_node.pnom AS cat_pnom,
    cat_node.dnom AS cat_dnom,
    node.epa_type,
    node.sector_id,
    node.state AS tank_state,
    node.annotation AS tank_annotation,
    node.observ AS tank_observ,
    node.comment AS tank_comment,
    node.dma_id,
    dma.presszonecat_id,
    node.soilcat_id AS tank_soilcat_id,
    node.category_type AS tank_category_type,
    node.fluid_type AS tank_fluid_type,
    node.location_type AS tank_location_type,
    node.workcat_id AS tank_workcat_id,
    node.workcat_id_end AS tank_workcat_id_end,
    node.buildercat_id AS tank_buildercat_id,
    node.builtdate AS tank_builtdate,
    node.ownercat_id AS tank_ownercat_id,
    node.adress_01 AS tank_adress_01,
    node.adress_02 AS tank_adress_02,
    node.adress_03 AS tank_adress_03,
    node.descript AS tank_descript,
    cat_node.svg AS tank_cat_svg,
    node.rotation AS tank_rotation,
    node.link AS tank_link,
    node.verified,
    node.undelete,
    node.label_x AS tank_label_x,
    node.label_y AS tank_label_y,
    node.label_rotation AS tank_label_rotation,
    inp_tank.initlevel,
    inp_tank.minlevel,
    inp_tank.maxlevel,
    inp_tank.diameter,
    man_tank.vmax AS tank_vmax,
    man_tank.area AS tank_area,
    man_tank.chlorination AS tank_chlorination,
    man_tank.function AS tank_function,
	node.code AS tank_code,
	node.publish,
	node.inventory,
	node.end_date AS tank_end_date,
	node.macrodma_id,
	man_tank.pol_id,
	polygon.the_geom,
	exploitation.descript AS expl_name	
FROM expl_selector, node
	LEFT JOIN cat_node ON node.nodecat_id::text = cat_node.id::text
     LEFT JOIN dma ON node.dma_id::text = dma.dma_id::text
     JOIN man_tank ON man_tank.node_id::text = node.node_id::text
     LEFT JOIN inp_tank ON inp_tank.node_id::text = man_tank.node_id::text
	 JOIN polygon ON polygon.pol_id=man_tank.pol_id
	 JOIN exploitation ON node.expl_id=exploitation.expl_id
	WHERE ((node.expl_id)::text=(expl_selector.expl_id)::text
	AND expl_selector.cur_user="current_user"()::text);


