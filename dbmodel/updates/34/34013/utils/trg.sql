/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/06/05

DROP TRIGGER IF EXISTS gw_trg_edit_samplepoint ON v_edit_samplepoint;
CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON SCHEMA_NAME.v_edit_samplepoint 
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_samplepoint('samplepoint');

-- delete deprecated triggers
DROP TRIGGER IF EXISTS gw_trg_ui_om_result_cat ON v_ui_om_result_cat;

DROP FUNCTION IF EXISTS trg_visit_undone();
DROP FUNCTION IF EXISTS gw_trg_ui_om_result_cat() CASCADE;