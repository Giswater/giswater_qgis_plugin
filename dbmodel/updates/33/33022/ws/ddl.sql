/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/01/10
DROP VIEW IF EXISTS v_edit_dqa;
DROP VIEW IF EXISTS v_edit_presszone;
DROP VIEW vi_parent_dma;


ALTER TABLE sector DROP nodeparent;
ALTER TABLE dma DROP nodeparent;
ALTER TABLE dqa DROP nodeparent;
ALTER TABLE cat_presszone DROP nodeparent;
ALTER TABLE anl_mincut_inlet_x_exploitation RENAME to_arc TO _to_arc;