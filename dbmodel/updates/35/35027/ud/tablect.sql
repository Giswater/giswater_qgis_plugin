	/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/08/12
ALTER TABLE man_chamber DROP CONSTRAINT IF EXISTS man_chamber_pol_id_fkey;
ALTER TABLE man_netgully DROP CONSTRAINT IF EXISTS man_netgully_pol_id_fkey;
ALTER TABLE man_storage DROP CONSTRAINT IF EXISTS man_storage_pol_id_fkey;
ALTER TABLE man_wwtp DROP CONSTRAINT IF EXISTS man_wwtp_pol_id_fkey;


--2022/08/19
ALTER TABLE inp_dscenario_raingage ADD CONSTRAINT inp_dscenario_raingage_dscenario_rg_id_fkey FOREIGN KEY (rg_id)
REFERENCES raingage (rg_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;