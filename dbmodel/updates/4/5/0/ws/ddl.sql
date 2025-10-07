/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE IF NOT EXISTS om_mincut_conflict (
    id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
    mincut_id integer NOT NULL,
    CONSTRAINT om_mincut_conflict_mincut_id_fkey FOREIGN KEY (mincut_id) REFERENCES om_mincut(id) ON DELETE CASCADE ON UPDATE CASCADE
);
