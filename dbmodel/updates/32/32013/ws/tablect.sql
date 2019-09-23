/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE rpt_inp_pattern_value ADD CONSTRAINT rpt_inp_pattern_value_dma_id_fkey FOREIGN KEY (dma_id)
REFERENCES dma (dma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE rpt_inp_pattern_value ADD CONSTRAINT rpt_inp_pattern_value_result_id_fkey FOREIGN KEY (result_id)
REFERENCES rpt_cat_result (result_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;