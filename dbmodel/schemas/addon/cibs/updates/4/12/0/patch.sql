/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = cibs, public, pg_catalog;

CREATE TABLE IF NOT EXISTS cibs.sys_version (
    id serial4 NOT NULL,
    giswater varchar(16) NOT NULL,
    project_type varchar(16) NOT NULL,
    postgres varchar(512) NOT NULL,
    postgis varchar(512) NOT NULL,
    "date" timestamp(6) NOT NULL DEFAULT now(),
    "language" varchar(50) NOT NULL,
    epsg int4 NOT NULL,
    addparam jsonb NULL,
    CONSTRAINT sys_version_pkey PRIMARY KEY (id)
);
