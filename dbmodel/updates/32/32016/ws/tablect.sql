/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE arc ADD CONSTRAINT arc_dqa_id_fkey FOREIGN KEY (dqa_id)
REFERENCES dqa (dqa_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node ADD CONSTRAINT node_dqa_id_fkey FOREIGN KEY (dqa_id)
REFERENCES dqa (dqa_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT connec_dqa_id_fkey FOREIGN KEY (dqa_id)
REFERENCES dqa (dqa_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE dqa DROP CONSTRAINT IF EXISTS dqa_expl_id_fkey;
ALTER TABLE macrodqa DROP CONSTRAINT IF EXISTS macrodqa_expl_id_fkey;

ALTER TABLE dqa ADD CONSTRAINT dqa_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE macrodqa ADD CONSTRAINT macrodqa_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;



ALTER TABLE inp_inlet  ADD CONSTRAINT inp_inlet_node_id_fkey FOREIGN KEY (node_id)      
REFERENCES node (node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_inlet  ADD CONSTRAINT inp_inlet_curve_id_fkey FOREIGN KEY (curve_id)      
REFERENCES inp_curve_id (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE inp_inlet  ADD CONSTRAINT inp_inlet_pattern_id_fkey FOREIGN KEY (pattern_id)      
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;



ALTER TABLE minsector  ADD CONSTRAINT minsector_dma_id_fkey FOREIGN KEY (dma_id)      
REFERENCES dma (dma_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE minsector  ADD CONSTRAINT minsector_dqa_id_fkey FOREIGN KEY (dqa_id)      
REFERENCES dqa (dqa_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE minsector  ADD CONSTRAINT minsector_presszonecat_id_fkey FOREIGN KEY (presszonecat_id)      
REFERENCES cat_presszone (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE minsector  ADD CONSTRAINT minsector_sector_id_fkey FOREIGN KEY (sector_id)      
REFERENCES sector (sector_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE minsector  ADD CONSTRAINT minsector_expl_id_fkey FOREIGN KEY (expl_id)      
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;


