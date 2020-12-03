/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/26

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
	dma.stylesheet::text AS stylesheet
   FROM selector_expl,dma
  WHERE dma.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


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
	dqa.stylesheet::text AS stylesheet
   FROM selector_expl,dqa
  WHERE dqa.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;

DROP VIEW IF EXISTS v_edit_presszone;
CREATE OR REPLACE VIEW v_edit_presszone AS 
 SELECT presszone.presszone_id,
    presszone.name,
    presszone.expl_id,
    presszone.the_geom,
    presszone.grafconfig::text AS grafconfig,
	presszone.head,
    presszone.stylesheet::text AS stylesheet
   FROM selector_expl,presszone
  WHERE presszone.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;


CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.grafconfig::text AS grafconfig,
    sector.stylesheet::text AS stylesheet
   FROM selector_sector, sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;

