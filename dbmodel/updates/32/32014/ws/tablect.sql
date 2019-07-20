/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE node_type ADD CONSTRAINT node_type_graf_delimiter_check CHECK (graf_delimiter::text = ANY (ARRAY['NONE','MINSECTOR', 'PRESSZONE', 'DQA', 'DMA', 'SECTOR']));

ALTER TABLE inp_pattern_value ALTER COLUMN _factor_19 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_20 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_21 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_22 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_23 DROP DEFAULT;
ALTER TABLE inp_pattern_value ALTER COLUMN _factor_24 DROP DEFAULT;