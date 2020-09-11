/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/07/22

DROP TRIGGER IF EXISTS gw_trg_edit_address ON v_ext_address;
CREATE TRIGGER gw_trg_edit_address INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_ext_address FOR EACH ROW
EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_address();

DROP TRIGGER IF EXISTS gw_trg_edit_streetaxis ON v_ext_streetaxis;
CREATE TRIGGER gw_trg_edit_streetaxis INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_ext_streetaxis
FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_streetaxis();

-- 2020/07/27

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON v_edit_cad_auxcircle;
CREATE TRIGGER gw_trg_edit_cad_auxcircle INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_edit_cad_auxcircle FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_cad_aux('circle');

DROP TRIGGER IF EXISTS gw_trg_edit_cad_aux ON v_edit_cad_auxpoint;
CREATE TRIGGER gw_trg_edit_cad_auxpoint INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_edit_cad_auxpoint FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_cad_aux('point');

DROP TRIGGER IF EXISTS gw_trg_config_control ON config_form_fields;
CREATE TRIGGER gw_trg_config_control BEFORE INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.config_form_fields FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('config_form_fields');

CREATE INDEX anl_connec_index
  ON anl_connec
  USING gist
  (the_geom);
  
  
ALTER TABLE temp_csv DROP CONSTRAINT temp_csv2pg_csv2pgcat_id_fkey2;

ALTER TABLE temp_csv
  ADD CONSTRAINT temp_csv_fid_fkey FOREIGN KEY (fid)
      REFERENCES sys_fprocess (fid) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE RESTRICT;
