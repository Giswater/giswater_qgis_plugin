/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
ALTER TABLE anl_mincut_inlet_x_exploitation RENAME to config_mincut_inlet;
ALTER TABLE anl_mincut_valve RENAME to config_mincut_valve;
ALTER TABLE anl_mincut_checkvalve RENAME to config_mincut_checkvalve;
ALTER TABLE typevalue_fk RENAME to config_typevalue_fk;