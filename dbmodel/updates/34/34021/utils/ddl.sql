/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/09/30
DROP VIEW IF EXISTS v_edit_typevalue;

DROP TRIGGER IF EXISTS gw_trg_notify ON cat_work;

ALTER TABLE cat_work ALTER COLUMN id TYPE character varying(255);