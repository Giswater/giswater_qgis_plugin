/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TABLE inp_selector_pattern_dma(
id serial PRIMARY KEY,
pattern_id character varying(16),
dma_id integer,
period_id integer,
isunitary boolean,
user_name text,
CONSTRAINT UNIQUE (pattern_id, dma_id, period_id, isunitary)
);


CREATE TABLE inp_selector_pattern_node(
id serial PRIMARY KEY,
pattern_id character varying(16),
node_id  character varying(16),
period_id integer,
isunitary boolean,
user_name text,
CONSTRAINT UNIQUE (pattern_id, node_id, period_id, isunitary)
);

ALTER TABLE inp_pattern ADD COLUMN timesteps integer;
ALTER TABLE inp_pattern ADD COLUMN isunitary boolean DEFAULT TRUE;
ALTER TABLE inp_pattern ADD COLUMN feature json;
ALTER TABLE inp_pattern ADD COLUMN period json;