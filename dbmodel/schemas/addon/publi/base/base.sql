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

CREATE TABLE config_process (
	function_name text NOT NULL,
	description text NULL,
	selector_config jsonb NULL,
	active bool NOT NULL DEFAULT true,
	CONSTRAINT config_process_pkey PRIMARY KEY (function_name)
);

CREATE TABLE config_materialized_views (
	viewname text NOT NULL,
	description text NULL,
	selector_config jsonb NULL,
	active bool NOT NULL DEFAULT true,
	CONSTRAINT config_materialized_views_pkey PRIMARY KEY (viewname)
);

/*

Examples:

INSERT INTO config_process (function_name, description, selector_config, active)
VALUES (
	'gw_fct_refresh_materialized_views',
	'Refresh all active materialized views',
	NULL,
	true
);

INSERT INTO config_process (function_name, description, selector_config, active)
VALUES (
	'gw_fct_daily_update_hydrometers',
	'Daily update of hydrometers',
	'{"ws": {"selector_expl": [1, 2], "selector_state": [1]}}, "ud": {"selector_expl": [1, 2], "selector_state": [1]}}'::jsonb,
	true
);


INSERT INTO config_materialized_views (viewname, description, selector_config, active)
VALUES (
	'vm_ws_ve_node',
	'View of nodes in WS',
	NULL, -- select all in selectors
	true
);

INSERT INTO config_materialized_views (viewname, description, selector_config, active)
VALUES (
	'vm_ws_ve_arc',
	'View of arcs in WS',
	'{"ws": {"selector_expl": [1, 2], "selector_state": [1]}}'::jsonb,
	true
);

INSERT INTO config_materialized_views (viewname, description, selector_config, active)
VALUES (
	'vm_example_view',
	'Example view with selector config for both schemas',
	'{"ws": {"selector_expl": [1, 2], "selector_state": [1]}, "ud": {"selector_expl": [1, 2], "selector_state": [1]}}'::jsonb,
	true
);

*/
