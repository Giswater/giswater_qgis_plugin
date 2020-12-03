/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE ext_rtc_scada_dma_period
ADD CONSTRAINT ext_rtc_scada_dma_period_dma_id_cat_period_id_unique UNIQUE (dma_id, cat_period_id);

ALTER TABLE ext_rtc_hydrometer_x_data
ADD CONSTRAINT ext_rtc_hydrometer_x_data_hydrometer_id_cat_period_id_unique UNIQUE (hydrometer_id, cat_period_id);

ALTER TABLE ext_hydrometer_category_x_pattern
ADD CONSTRAINT ext_hydrometer_category_x_pattern_unique UNIQUE (category_id, period_type);

ALTER TABLE node_type DROP CONSTRAINT node_type_epa_table_check;
ALTER TABLE node_type ADD CONSTRAINT node_type_epa_table_check CHECK (epa_table::text = ANY 
(ARRAY['inp_virtualvalve', 'inp_inlet', 'inp_junction', 'inp_pump', 'inp_reservoir', 'inp_tank', 'inp_valve', 'inp_shortpipe']));
