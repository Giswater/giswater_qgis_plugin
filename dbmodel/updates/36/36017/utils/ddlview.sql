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
where username = current_user and e.active and expl_id > 0
order by 1;

CREATE OR REPLACE VIEW vu_macroexploitation as
select distinct on (macroexpl_id) m.* from macroexploitation m
join exploitation using (macroexpl_id)
JOIN config_user_x_expl USING (expl_id)
where username = current_user and m.active and macroexpl_id > 0
order by 1;

CREATE OR REPLACE VIEW vu_macrosector as
select distinct on (macrosector_id) m.* from macrosector m
join sector using (macrosector_id)
JOIN (SELECT DISTINCT sector_id, expl_id FROM node WHERE state > 0) a USING (sector_id)
join exploitation using (expl_id)
JOIN config_user_x_expl USING (expl_id)
where username = current_user and m.active and macrosector_id > 0
order by 1;

CREATE OR REPLACE VIEW vu_ext_municipality as
select m.* from ext_municipality m 
join (SELECT DISTINCT muni_id, expl_id FROM node WHERE state > 0) a USING (muni_id)
JOIN config_user_x_expl USING (expl_id)
where username = current_user and m.active and muni_id > 0;
-------
