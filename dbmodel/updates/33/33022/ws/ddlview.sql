/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/01/10
CREATE OR REPLACE VIEW v_edit_presszone AS 
 SELECT cat_presszone.id,
    cat_presszone.descript,
    cat_presszone.expl_id,
	cat_presszone.the_geom,
	grafconfig
   FROM selector_expl,
    cat_presszone
  WHERE cat_presszone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

  
  
CREATE OR REPLACE VIEW v_edit_dqa AS 
 SELECT dqa.dqa_id,
    dqa.name,
    dqa.expl_id,
    dqa.macrodqa_id,
    dqa.descript,
    dqa.undelete,
    dqa.the_geom,
    dqa.pattern_id,
    dqa.dqa_type,
    dqa.link,
	grafconfig
   FROM selector_expl,
    dqa
  WHERE dqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

  
CREATE OR REPLACE VIEW v_edit_dma AS 
 SELECT dma.dma_id,
    dma.name,
    dma.macrodma_id,
    dma.descript,
    dma.the_geom,
    dma.undelete,
    dma.expl_id,
    dma.pattern_id,
    dma.link,
    dma.minc,
    dma.maxc,
    dma.effc,
	grafconfig
   FROM selector_expl,
    dma
  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

  
  CREATE OR REPLACE VIEW vi_parent_dma AS 
 SELECT DISTINCT ON (dma.dma_id) dma.dma_id,
    dma.name,
    dma.expl_id,
    dma.macrodma_id,
    dma.descript,
    dma.undelete,
    dma.the_geom,
    dma.minc,
    dma.maxc,
    dma.effc,
    dma.pattern_id,
    dma.link,
    dma.grafconfig
   FROM dma
     JOIN vi_parent_arc USING (dma_id);
  
  
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
	grafconfig
   FROM inp_selector_sector,
    sector
  WHERE sector.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

  
  
CREATE OR REPLACE VIEW v_minsector AS 
 SELECT minsector_id,
    minsector.dma_id,
    minsector.dqa_id,
    minsector.presszonecat_id,
    minsector.sector_id,
    minsector.expl_id,
    minsector.the_geom
   FROM selector_expl, minsector
  WHERE minsector.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

  

-- 2020/01/16  
CREATE OR REPLACE VIEW v_edit_element AS 
SELECT distinct on (element.element_id) element.element_id,
    element.code,
    element.elementcat_id,
    cat_element.elementtype_id,
    element.serial_number,
    element.state,
    element.state_type,
    element.num_elements,
    element.observ,
    element.comment,
    element.function_type,
    element.category_type,
    element.location_type,
    element.fluid_type,
    element.workcat_id,
    element.workcat_id_end,
    element.buildercat_id,
    element.builtdate,
    element.enddate,
    element.ownercat_id,
    element.rotation,
    concat(element_type.link_path, element.link) AS link,
    element.verified,
    case when element.the_geom is not null then element.the_geom
		when node.the_geom is not null then node.the_geom
		when connec.the_geom is not null then connec.the_geom
		when arc.the_geom is not null then st_lineinterpolatepoint (arc.the_geom, 0.5)::geometry(point,SRID_VALUE)
		else null::geometry(point,SRID_VALUE)
    end as the_geom,
    element.label_x,
    element.label_y,
    element.label_rotation,
    element.publish,
    element.inventory,
    element.undelete,
    element.expl_id
   FROM selector_expl, element
     JOIN v_state_element ON element.element_id::text = v_state_element.element_id::text
     JOIN cat_element ON element.elementcat_id::text = cat_element.id::text
     JOIN element_type ON element_type.id::text = cat_element.elementtype_id::text
     LEFT JOIN element_x_node c ON c.element_id=element.element_id
     LEFT JOIN element_x_arc a ON a.element_id=element.element_id
     LEFT JOIN element_x_connec b ON b.element_id=element.element_id
     LEFT JOIN node USING (node_id)
     LEFT JOIN connec USING (connec_id)
     LEFT JOIN arc ON arc.arc_id = a.arc_id
  WHERE element.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
  