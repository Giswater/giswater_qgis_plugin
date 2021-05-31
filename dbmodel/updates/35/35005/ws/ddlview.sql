/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/05/23
CREATE OR REPLACE VIEW vp_basic_arc AS 
SELECT arc_id AS nid,
arctype_id AS custom_type
FROM arc
JOIN cat_arc ON id=arccat_id;


CREATE OR REPLACE VIEW vp_basic_node AS 
SELECT node_id AS nid,
nodetype_id AS custom_type
FROM node
JOIN cat_node ON id=nodecat_id;


CREATE OR REPLACE VIEW vp_basic_connec AS 
SELECT connec_id AS nid,
connectype_id AS custom_type
FROM connec
JOIN cat_connec ON id=connecat_id;


--2021/05/31
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
    dma.grafconfig::text AS grafconfig,
    dma.stylesheet::text AS stylesheet,
    dma.active
   FROM selector_expl,dma
  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_edit_macrodqa AS 
 SELECT macrodqa.macrodqa_id,
    macrodqa.name,
    macrodqa.expl_id,
    macrodqa.descript,
    macrodqa.undelete,
    macrodqa.the_geom,
    macrodqa.active
   FROM selector_expl, macrodqa
  WHERE macrodqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


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
    dqa.grafconfig::text AS grafconfig,
    dqa.stylesheet::text AS stylesheet,
    dqa.active
   FROM selector_expl, dqa
  WHERE dqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.grafconfig::text AS grafconfig,
    sector.stylesheet::text AS stylesheet,
    sector.active
   FROM selector_sector, sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_presszone AS 
 SELECT presszone.presszone_id,
    presszone.name,
    presszone.expl_id,
    presszone.the_geom,
    presszone.grafconfig::text AS grafconfig,
    presszone.head,
    presszone.stylesheet::text AS stylesheet,
    presszone.active
   FROM selector_expl, presszone
  WHERE presszone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW ve_pol_fountain AS 
 SELECT man_fountain.pol_id,
    connec.connec_id,
    polygon.the_geom
   FROM connec
   JOIN v_state_connec USING (connec_id) 
   JOIN man_fountain ON man_fountain.connec_id::text = connec.connec_id::text
   JOIN polygon ON polygon.pol_id::text = man_fountain.pol_id::text;