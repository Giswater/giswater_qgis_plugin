/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_edit_inp_connec INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_edit_inp_connec FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_inp_connec();


CREATE TRIGGER gw_trg_edit_inp_arc_pipe INSTEAD OF INSERT OR UPDATE OR DELETE
ON SCHEMA_NAME.v_edit_inp_pipe FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_edit_inp_arc('inp_pipe'); 

DROP TRIGGER IF EXISTS gw_trg_edit_dqa ON v_edit_dqa;
CREATE TRIGGER gw_trg_edit_dqa INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_dqa 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_dqa('dqa');

DROP TRIGGER IF EXISTS gw_trg_edit_macrodqa ON v_edit_macrodqa;
CREATE TRIGGER gw_trg_edit_macrodqa INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_macrodqa 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_macrodqa('macrodqa');

DROP TRIGGER IF EXISTS gw_trg_edit_presszone ON v_edit_presszone;
CREATE TRIGGER gw_trg_edit_presszone INSTEAD OF INSERT OR DELETE OR UPDATE ON v_edit_presszone 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_presszone('presszone');  

DROP TRIGGER IF EXISTS gw_trg_vi_patterns ON SCHEMA_NAME.vi_patterns;
CREATE TRIGGER gw_trg_vi_patterns INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_patterns FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_patterns');

DROP TRIGGER IF EXISTS gw_trg_vi_title ON SCHEMA_NAME.vi_title;
CREATE TRIGGER gw_trg_vi_title INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_title FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_title');

DROP TRIGGER IF EXISTS gw_trg_vi_curves ON SCHEMA_NAME.vi_curves;
CREATE TRIGGER gw_trg_vi_curves INSTEAD OF INSERT OR UPDATE OR DELETE ON SCHEMA_NAME.vi_curves FOR EACH ROW EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_vi('vi_curves');
