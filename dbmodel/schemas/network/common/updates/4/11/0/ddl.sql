/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 22/05/2026
CREATE TABLE IF NOT EXISTS temp_view_dependencies (
    id serial PRIMARY KEY,
    batch_id integer NOT NULL,
    cur_user text DEFAULT current_user,
    view_schema text NOT NULL,
    view_name text NOT NULL,
    relkind char(1) NOT NULL DEFAULT 'v',
    view_depth integer NOT NULL,
    view_definition text NOT NULL,
    trigger_definition text,
    tstamp timestamp without time zone DEFAULT now(),
    CONSTRAINT temp_view_dependencies_un UNIQUE (batch_id, view_schema, view_name)
);

CREATE INDEX IF NOT EXISTS temp_view_dependencies_batch_id_depth_idx
    ON temp_view_dependencies (batch_id, view_depth);

-- 18/05/2026
DROP VIEW IF EXISTS ve_exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_muni ON exploitation;
DROP TRIGGER IF EXISTS gw_trg_fk_array_array_table_sector ON exploitation;

ALTER TABLE exploitation DROP COLUMN sector_id;
ALTER TABLE exploitation DROP COLUMN muni_id;
