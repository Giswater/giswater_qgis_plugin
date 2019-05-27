/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE inp_junction ADD custom_pattern_id character varying (16);

ALTER TABLE ext_rtc_scada_dma_period ADD custom_pattern_id character varying (16);

CREATE TABLE inp_pattern_x_pattern(
id serial PRIMARY KEY,
pattern_id character varying(16),
pattern_id2 character varying(16),
CONSTRAINT inp_pattern_x_pattern_unique UNIQUE (pattern_id, pattern_id2)
);

ALTER TABLE inp_pattern ADD COLUMN timesteps integer;
ALTER TABLE inp_pattern ADD COLUMN isunitary boolean DEFAULT TRUE;
ALTER TABLE inp_pattern ADD COLUMN feature json;
ALTER TABLE inp_pattern ADD COLUMN period json;