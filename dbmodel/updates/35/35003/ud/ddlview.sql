/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2021/05/02
CREATE OR REPLACE VIEW vi_controls AS 
 SELECT c.text
   FROM (SELECT d.id,
            d.text
           FROM ( SELECT inp_controls.id AS id,
                    inp_controls.text
                   FROM selector_sector,inp_controls
                  WHERE selector_sector.sector_id = inp_controls.sector_id AND selector_sector.cur_user = "current_user"()::text AND inp_controls.active IS NOT FALSE
                  ORDER BY inp_controls.id) d) c
  ORDER BY c.id;
