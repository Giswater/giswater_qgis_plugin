/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 31/12/2024

CREATE OR REPLACE VIEW vu_exploitation as
select e.* from exploitation e
JOIN config_user_x_expl USING (expl_id)
where username = current_user and expl_id > 0
order by 1;

select * from config_user_x_expl

CREATE OR REPLACE VIEW vu_macroexploitation as
select distinct on (macroexpl_id) m.* from macroexploitation m
join exploitation using (macroexpl_id)
JOIN config_user_x_expl USING (expl_id)
where username = current_user and macroexpl_id > 0
UNION
select distinct on (macroexpl_id) m.* from macroexploitation m
LEFT join exploitation using (macroexpl_id)
where expl_id IS NULL and macroexpl_id > 0
order by 1;

CREATE OR REPLACE VIEW vu_macrosector as
select distinct on (macrosector_id) m.* from macrosector m
join sector using (macrosector_id)
JOIN (SELECT DISTINCT sector_id, expl_id FROM node WHERE state > 0) a USING (sector_id)
join exploitation using (expl_id)
JOIN config_user_x_expl USING (expl_id)
where username = current_user and macrosector_id > 0
UNION
select distinct on (macrosector_id) m.* from macrosector m
LEFT join sector using (macrosector_id)
where sector_id IS NULL and macrosector_id > 0
order by 1;

CREATE OR REPLACE VIEW vu_ext_municipality as
select m.* from ext_municipality m 
join (SELECT DISTINCT muni_id, expl_id FROM node WHERE state > 0) a USING (muni_id)
JOIN config_user_x_expl USING (expl_id)
where username = current_user and muni_id > 0
UNION
select m.* from ext_municipality m 
LEFT join (SELECT DISTINCT muni_id, expl_id FROM node WHERE state > 0) a USING (muni_id)
where a.muni_id IS NULL and muni_id > 0
order by 1;

CREATE OR REPLACE VIEW v_edit_exploitation
AS SELECT exploitation.expl_id,
    exploitation.name,
    exploitation.macroexpl_id,
    exploitation.descript,
    exploitation.undelete,
    exploitation.the_geom,
    exploitation.tstamp,
    exploitation.active
   FROM selector_expl,
    exploitation
  WHERE exploitation.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text
  and active is true;