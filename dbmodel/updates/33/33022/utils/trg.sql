/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_edit_address ON v_ext_address;
CREATE TRIGGER gw_trg_edit_address INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_ext_address FOR EACH ROW
EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_address();

DROP TRIGGER IF EXISTS gw_trg_edit_plot ON v_ext_plot;
CREATE TRIGGER gw_trg_edit_plot INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_ext_plot
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_plot();

DROP TRIGGER IF EXISTS gw_trg_edit_streetaxis ON v_ext_streetaxis;
CREATE TRIGGER gw_trg_edit_streetaxis INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_ext_streetaxis
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_streetaxis();

DROP TRIGGER IF EXISTS gw_trg_edit_samplepoint ON v_edit_samplepoint;
CREATE TRIGGER gw_trg_edit_samplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON SCHEMA_NAME.v_edit_samplepoint 
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_samplepoint('samplepoint');