/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE presszone DROP CONSTRAINT IF EXISTS presszone_presszone_type_check;
ALTER TABLE sys_style ADD CONSTRAINT sys_style_pkey PRIMARY KEY (layername, styleconfig_id);
ALTER TABLE sys_style ALTER COLUMN styleconfig_id SET NOT NULL;

ALTER TABLE element ADD CONSTRAINT element_brand_id FOREIGN KEY (brand_id) references cat_brand(id);
ALTER TABLE element ADD CONSTRAINT element_model_id FOREIGN KEY (model_id) references cat_brand_model(id);



DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        ALTER TABLE pond ADD CONSTRAINT pond_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
        ALTER TABLE "pool" ADD CONSTRAINT pool_muni_id FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id);
    ELSE
        ALTER TABLE pond ADD CONSTRAINT pond_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
        ALTER TABLE "pool" ADD CONSTRAINT pool_muni_id FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id);
    END IF;
END; $$;