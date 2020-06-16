/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/06/16

DROP TRIGGER IF EXISTS gw_trg_ui_mincut_result_cat ON v_ui_anl_mincut_result_cat;
CREATE TRIGGER gw_trg_ui_mincut_result_cat INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_ui_mincut FOR EACH ROW EXECUTE PROCEDURE gw_trg_ui_mincut_result_cat();