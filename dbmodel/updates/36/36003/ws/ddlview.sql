/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP VIEW v_minsector;

CREATE VIEW v_edit_minsector AS 
SELECT 
minsector_id, 
code,
dma_id, 
dqa_id, 
presszone_id, 
sector_id, 
m.expl_id, 
num_border, 
num_connec, 
num_hydro, 
length,
descript,
addparam, 
the_geom
FROM selector_expl, minsector m
  WHERE m.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;
