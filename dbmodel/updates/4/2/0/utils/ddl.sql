/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"ext_rtc_hydrometer_x_data", "column":"crm_number", "dataType":"text"}}$$);

-- 05/08/2025
ALTER TABLE plan_psector ADD COLUMN workcat_id_plan text;
ALTER TABLE plan_psector ADD CONSTRAINT plan_psector_workcat_id_plan_fkey FOREIGN KEY (workcat_id_plan) REFERENCES cat_work(id) ON DELETE RESTRICT ON UPDATE CASCADE;
CREATE INDEX idx_plan_psector_workcat_id_plan ON plan_psector(workcat_id_plan);

ALTER TABLE config_form_fields ADD COLUMN field_layoutorder int4 NULL;
