/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;



-- 2020/02/28
DROP TRIGGER IF EXISTS gw_trg_config_control ON config_api_form_fields;
CREATE TRIGGER gw_trg_edit_config_sysfields INSTEAD OF UPDATE
ON ve_config_sysfields  FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_config_sysfields();

CREATE TRIGGER gw_trg_edit_config_addfields INSTEAD OF UPDATE
ON ve_config_addfields FOR EACH ROW EXECUTE PROCEDURE gw_trg_edit_config_addfields();
 