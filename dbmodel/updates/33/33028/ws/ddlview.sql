/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/02/10

DROP VIEW IF EXISTS v_ui_node_x_relations;
CREATE OR REPLACE VIEW v_ui_node_x_relations AS 
SELECT row_number() OVER (ORDER BY node_id) AS rid,
parent_id as node_id,
nodetype_id,
nodecat_id,
node_id as child_id,
code,
sys_type
FROM v_edit_node WHERE parent_id IS NOT NULL;


DROP VIEW IF EXISTS v_edit_presszone;
CREATE OR REPLACE VIEW v_edit_presszone AS 
 SELECT cat_presszone.id,
    cat_presszone.descript,
    cat_presszone.expl_id,
    cat_presszone.the_geom,
    cat_presszone.grafconfig::text
   FROM selector_expl,
    cat_presszone
  WHERE cat_presszone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_dma;
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
    dma.grafconfig::text
   FROM selector_expl,
    dma
  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_dqa;
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
    dqa.grafconfig::text
   FROM selector_expl,
    dqa
  WHERE dqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_presszone;
CREATE OR REPLACE VIEW v_edit_presszone AS 
 SELECT cat_presszone.id,
    cat_presszone.descript,
    cat_presszone.expl_id,
    cat_presszone.the_geom,
    cat_presszone.grafconfig::text
   FROM selector_expl,
    cat_presszone
  WHERE cat_presszone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


DROP VIEW IF EXISTS v_edit_sector;
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.grafconfig
   FROM inp_selector_sector,
    sector
  WHERE sector.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;
