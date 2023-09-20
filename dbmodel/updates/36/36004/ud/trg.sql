/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_ui_element INSTEAD OF
INSERT OR DELETE OR UPDATE
ON v_ui_element_x_gully 
FOR EACH ROW EXECUTE FUNCTION gw_trg_ui_element('element_x_gully');


DROP TRIGGER IF EXISTS gw_trg_vi_transects ON vi_transects;
CREATE TRIGGER gw_trg_vi_transects INSTEAD OF INSERT OR UPDATE OR DELETE ON vi_transects
FOR EACH ROW EXECUTE PROCEDURE gw_trg_vi('vi_transects');

DROP TRIGGER IF EXISTS gw_trg_edit_inp_transects ON v_edit_inp_transects;
CREATE TRIGGER gw_trg_edit_inp_transects INSTEAD OF INSERT OR UPDATE OR DELETE ON v_edit_inp_transects
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_inp_transects();
