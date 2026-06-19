/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = publi, public;

CREATE TABLE publi.sys_version (
	id serial4 NOT NULL,
	giswater varchar(16) NOT NULL,
	project_type varchar(16) NOT NULL,
	postgres varchar(512) NOT NULL,
	postgis varchar(512) NOT NULL,
	"date" timestamp(6) DEFAULT now() NOT NULL,
	"language" varchar(50) NOT NULL,
	epsg int4 NOT NULL,
    addparam jsonb,
	CONSTRAINT sys_version_pkey PRIMARY KEY (id)
);

CREATE TABLE publi.vm_refresh_list (
	id serial4 NOT NULL,
	mv_name text NOT NULL,
	CONSTRAINT vm_refresh_list_mv_name_key UNIQUE (mv_name),
	CONSTRAINT vm_refresh_list_pkey PRIMARY KEY (id)
);

