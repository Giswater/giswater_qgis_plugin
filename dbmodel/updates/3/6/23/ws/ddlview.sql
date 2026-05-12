/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW IF EXISTS v_edit_dma;
DROP VIEW IF EXISTS v_edit_exploitation;

CREATE OR REPLACE view v_edit_dma AS
SELECT DISTINCT d.dma_id,
    d.name,
    d.dma_type,
    d.macrodma_id,
    d.descript,
    d.undelete,
    d.expl_id,
    d.minc,
    d.maxc,
    d.effc,
    d.pattern_id,
    d.link,
    d.graphconfig::text,
    d.stylesheet::TEXT,
    d.avg_press,
    d.tstamp,
    d.insert_user,
    d.lastupdate,
    d.lastupdate_user,
    d.the_geom
   FROM SCHEMA_NAME.selector_expl,
    SCHEMA_NAME.dma d
  WHERE (d.expl_id = selector_expl.expl_id AND d.active AND selector_expl.cur_user = "current_user"()::TEXT)
  OR d.expl_id IS NULL
  ORDER BY dma_id;

  CREATE OR REPLACE VIEW v_edit_exploitation
AS SELECT exploitation.expl_id,
    exploitation.name,
    exploitation.macroexpl_id,
    exploitation.descript,
    exploitation.undelete,
    exploitation.avg_press,
    exploitation.the_geom,
    exploitation.tstamp,
    exploitation.active
   FROM selector_expl,
    exploitation
  WHERE exploitation.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
