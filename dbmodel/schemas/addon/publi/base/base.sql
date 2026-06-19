/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = publi, public;

CREATE TABLE publi.vm_refresh_list (
	id serial4 NOT NULL,
	mv_name text NOT NULL,
	CONSTRAINT vm_refresh_list_mv_name_key UNIQUE (mv_name),
	CONSTRAINT vm_refresh_list_pkey PRIMARY KEY (id)
);

