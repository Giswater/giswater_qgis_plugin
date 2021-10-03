/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2021/10/03
INSERT INTO inp_typevalue VALUES ('inp_options_networkmode','4','PJOINT & CONNEC (ALL NODARCS)');
UPDATE connec SET epa_type = 'JUNCTION';