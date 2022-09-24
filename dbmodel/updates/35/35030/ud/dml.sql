/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/09/21
ALTER TABLE inp_dscenario_flwreg_outlet ALTER COLUMN outlet_type DROP NOT NULL;
ALTER TABLE inp_dscenario_flwreg_weir ALTER COLUMN weir_type DROP NOT NULL;
ALTER TABLE inp_dscenario_flwreg_orifice ALTER COLUMN ori_type DROP NOT NULL;