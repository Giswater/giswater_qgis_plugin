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
