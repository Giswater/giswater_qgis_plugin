/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP TRIGGER IF EXISTS gw_trg_config_control ON audit_cat_param_user;
CREATE TRIGGER gw_trg_config_control BEFORE INSERT OR UPDATE OR DELETE
ON audit_cat_param_user FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('sys_param_user');

DROP TRIGGER IF EXISTS gw_trg_config_control ON config_api_form_fields;
CREATE TRIGGER gw_trg_config_control BEFORE INSERT OR UPDATE OR DELETE
ON config_api_form_fields FOR EACH ROW EXECUTE PROCEDURE gw_trg_config_control('config_api_form_fields');
