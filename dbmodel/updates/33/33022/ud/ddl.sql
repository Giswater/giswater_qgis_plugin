/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/01/10
ALTER TABLE node RENAME sys_elev TO _sys_elev;
ALTER TABLE arc RENAME sys_length TO _sys_length;
ALTER TABLE arc RENAME sys_y1 TO _sys_y1;
ALTER TABLE arc RENAME sys_y2 TO _sys_y2;