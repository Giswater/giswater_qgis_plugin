/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = publi, public;

CREATE TABLE sys_version (
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

CREATE TABLE config_matviews_refresh (
	viewname text NOT NULL,
	description text NULL,
	active bool NOT NULL DEFAULT true,
	CONSTRAINT config_matviews_refresh_pkey PRIMARY KEY (viewname)
);

