/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE ext_cat_period ADD CONSTRAINT ext_cat_period_period_type_fkey FOREIGN KEY (period_type)
REFERENCES ext_cat_period_type (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE config_api_form ADD CONSTRAINT config_api_form_formname_unique UNIQUE (formname);

ALTER TABLE config_api_tableinfo_x_infotype ADD CONSTRAINT config_api_tableinfo_x_infotype_tableinfo_id_unique UNIQUE (tableinfo_id);

ALTER TABLE config_api_form_tabs ADD CONSTRAINT config_api_form_tabs_formname_tabname_device_unique UNIQUE(formname,tabname,device);


ALTER TABLE config_api_visit ADD CONSTRAINT config_api_visit_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE config_api_visit_x_featuretable ADD CONSTRAINT config_api_visit_x_featuretable_visitclass_id_fkey FOREIGN KEY (visitclass_id)
REFERENCES om_visit_class (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;