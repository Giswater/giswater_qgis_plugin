/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/07/11

ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_exploitation_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_muni_id_fkey FOREIGN KEY (muni_id)
REFERENCES ext_municipality (muni_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_streetaxis ADD CONSTRAINT om_streetaxis_unique UNIQUE(muni_id, id);

ALTER TABLE man_tank DROP CONSTRAINT IF EXISTS man_tank_pol_id_fkey;
ALTER TABLE man_fountain DROP CONSTRAINT IF EXISTS man_fountain_pol_id_fkey;
ALTER TABLE man_register DROP CONSTRAINT IF EXISTS man_register_pol_id_fkey;