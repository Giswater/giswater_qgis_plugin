/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE INDEX connec_plot_code ON connec USING btree (code);
ALTER TABLE connec ADD CONSTRAINT connec_plot_id_fkey FOREIGN KEY (plot_id) REFERENCES ext_plot(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE cat_feature_node ALTER COLUMN graph_delimiter SET DEFAULT '{NONE}';

-- 13/04/2026
CREATE INDEX IF NOT EXISTS connec_customer_code_idx ON connec USING btree (customer_code);
CREATE INDEX IF NOT EXISTS ext_rtc_hydrometer_customer_code_idx ON ext_rtc_hydrometer USING btree (customer_code);

-- 07/05/2026
ALTER TABLE element DROP CONSTRAINT IF EXISTS element_expl_id_fkey;
ALTER TABLE element ADD CONSTRAINT element_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE element DROP CONSTRAINT IF EXISTS element_sector_id;
ALTER TABLE element ADD CONSTRAINT element_sector_id_fkey FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE element DROP CONSTRAINT IF EXISTS element_brand_id;
ALTER TABLE element DROP CONSTRAINT IF EXISTS element_brand_id_fkey;
ALTER TABLE element ADD CONSTRAINT element_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE element DROP CONSTRAINT IF EXISTS element_model_id;
ALTER TABLE element DROP CONSTRAINT IF EXISTS element_model_id_fkey;
ALTER TABLE element ADD CONSTRAINT element_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_brand_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_minsector_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_model_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_minsector_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_brand_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_minsector_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_model_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE RESTRICT;
