/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--DROP CONSTRAINT
ALTER TABLE config_api_form_fields DROP CONSTRAINT config_api_form_fields_pkey2;

ALTER TABLE config_api_visit DROP CONSTRAINT config_api_visit_fkey;
ALTER TABLE config_api_visit DROP CONSTRAINT config_api_visit_formname_key;

ALTER TABLE om_visit_class_x_parameter DROP CONSTRAINT om_visit_class_x_parameter_class_fkey;


ALTER TABLE rpt_selector_compare DROP CONSTRAINT rpt_selector_compare_result_id_cur_user_unique;

ALTER TABLE rpt_selector_hourly_compare DROP CONSTRAINT time_compare_cur_user_unique;

DROP INDEX shortcut_unique;

--ADD CONSTRAINT
ALTER TABLE config_api_form_fields ADD CONSTRAINT config_api_form_fields_pkey2 UNIQUE(formname, formtype, column_id);

ALTER TABLE config_api_visit ADD CONSTRAINT config_api_visit_formname_key UNIQUE(formname);
ALTER TABLE config_api_visit  ADD CONSTRAINT config_api_visit_fkey FOREIGN KEY (visitclass_id) 
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit_class_x_parameter ADD CONSTRAINT om_visit_class_x_parameter_class_fkey FOREIGN KEY (class_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE om_visit_class_x_parameter ADD CONSTRAINT om_visit_class_x_parameter_class_fkey FOREIGN KEY (class_id) 
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE rpt_selector_compare ADD CONSTRAINT rpt_selector_compare_result_id_cur_user_unique UNIQUE(result_id, cur_user);

ALTER TABLE rpt_selector_hourly_compare ADD CONSTRAINT time_compare_cur_user_unique UNIQUE("time", cur_user);

CREATE UNIQUE INDEX shortcut_unique ON cat_feature USING btree (shortcut_key COLLATE pg_catalog."default");
