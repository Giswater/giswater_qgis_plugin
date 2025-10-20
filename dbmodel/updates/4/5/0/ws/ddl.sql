/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE IF NOT EXISTS om_mincut_conflict (
    id uuid DEFAULT gen_random_uuid(),
    mincut_id integer NOT NULL,
    CONSTRAINT om_mincut_conflict_pkey PRIMARY KEY (id, mincut_id),
    CONSTRAINT om_mincut_conflict_mincut_id_fkey FOREIGN KEY (mincut_id) REFERENCES om_mincut(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE INDEX IF NOT EXISTS om_mincut_conflict_mincut_id_idx ON om_mincut_conflict (mincut_id);

ALTER TABLE selector_mincut_result ADD COLUMN IF NOT EXISTS result_type text;

ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS closed bool NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS broken bool NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS unaccess bool NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS to_arc int4 NULL;
ALTER TABLE minsector_mincut_valve ADD COLUMN IF NOT EXISTS changestatus bool NULL;

ALTER TABLE om_mincut_valve ADD COLUMN IF NOT EXISTS changestatus bool NULL;
