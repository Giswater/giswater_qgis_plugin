/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/12/22
CREATE OR REPLACE VIEW v_edit_sector AS 
 SELECT sector.sector_id,
    sector.name,
    sector.descript,
    sector.macrosector_id,
    sector.the_geom,
    sector.undelete,
    sector.active,
    sector.parent_id
   FROM selector_sector, sector
  WHERE sector.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text;


--2021/12/29
CREATE OR REPLACE VIEW v_edit_inp_curve AS 
 SELECT DISTINCT c.id,
    c.curve_type,
    c.descript,
    c.sector_id,
    c.log
   FROM selector_sector, inp_curve c
  WHERE c.sector_id = selector_sector.sector_id AND selector_sector.cur_user = "current_user"()::text OR c.sector_id IS NULL
  ORDER BY c.id;
