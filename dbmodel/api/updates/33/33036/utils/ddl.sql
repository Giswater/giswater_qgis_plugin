/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--mandatory update on ddl to save value of editability, typeahead, reg_exp columns
UPDATE config_api_form_fields  SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols,'autoupdateReloadFields', (reload_field->>'reload')::json) where reload_field is not null; --reload
UPDATE config_api_form_fields  SET widgetcontrols = gw_fct_json_object_set_key(widgetcontrols,'typeaheadSearchField', typeahead->>'fieldToSearch') where typeahead is not null; --typeahead

DROP VIEW IF EXISTS ve_config_addfields;
DROP VIEW IF EXISTS ve_config_sys_fields;
DROP VIEW IF EXISTS ve_config_sysfields;

-- drop fields
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"isenabled"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"layout_id"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"isnotupdate"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"editability"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"reload_field"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"typeahead"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"field_length"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_api_form_fields", "column":"num_decimals"}}$$);

--rename fields
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_api_form_fields", "column":"action_function", "newName":"linkedaction"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_api_form_fields", "column":"layout_name", "newName":"layoutname"}}$$);


SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"config_api_form_groupbox", "column":"tooltip", "dataType":"text"}}$$);


CREATE TABLE config_api_form_actions
(
  actionname text primary key,
  label text,
  tooltip text  );