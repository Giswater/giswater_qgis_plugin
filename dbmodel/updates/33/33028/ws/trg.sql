/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_edit_presszone ON v_edit_presszone;
DROP TRIGGER IF EXISTS gw_trg_edit_dqa ON v_edit_dqa;


CREATE TRIGGER gw_trg_edit_presszone INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_presszone 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_presszone();

CREATE TRIGGER gw_trg_edit_dqa INSTEAD OF INSERT OR UPDATE OR DELETE
ON v_edit_dqa 
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_dqa();