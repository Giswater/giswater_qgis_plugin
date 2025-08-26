/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE TABLE IF NOT EXISTS audit.snapshot (
    date DATE DEFAULT CURRENT_DATE,
    description TEXT NULL,
    tables TEXT[] NULL,
    "schema" text,
    CONSTRAINT snapshot_pkey PRIMARY KEY (date, "schema")
);
