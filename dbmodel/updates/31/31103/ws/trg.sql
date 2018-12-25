/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


DROP TRIGGER IF EXISTS gw_trg_edit_field_valve ON "SCHEMA_NAME".v_edit_field_valve;
CREATE TRIGGER gw_trg_edit_field_valve  INSTEAD OF UPDATE  ON v_edit_field_valve  
FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_field_node('field_valve');