/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE node_type ADD CONSTRAINT node_type_graf_delimiter_check CHECK (graf_delimiter::text = ANY (ARRAY['NONE','MINSECTOR', 'PRESSZONE', 'DQA', 'DMA', 'SECTOR']));


ALTER TABLE dqa ADD CONSTRAINT dqa_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE dqa ADD CONSTRAINT dqa_macrodqa_id_fkey FOREIGN KEY (macrodqa_id)
REFERENCES macrodqa (macrodqa_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE dqa ADD CONSTRAINT dqa_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE dma ADD CONSTRAINT dma_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;


ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_connec_id_fkey FOREIGN KEY (connec_id)
REFERENCES connec (connec_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE inp_connec ADD CONSTRAINT inp_connec_pattern_id_fkey FOREIGN KEY (pattern_id)
REFERENCES inp_pattern (pattern_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE macrodqa ADD CONSTRAINT macrodqa_expl_id_fkey FOREIGN KEY (expl_id)
REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;