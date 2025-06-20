/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = cm, public, pg_catalog;


CREATE TABLE om_campaign_x_gully (
	id serial4 NOT NULL,
	campaign_id integer NOT NULL,
	gully_id int4 NOT NULL,
	code character varying(30),
	status int2,
	admin_observ text,
	org_observ text,
	CONSTRAINT om_campaign_x_gully_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_x_gully_un UNIQUE (campaign_id, gully_id),
	CONSTRAINT om_campaign_x_gully_campaign_id_fkey FOREIGN KEY (campaign_id) REFERENCES om_campaign (campaign_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE om_campaign_lot_x_gully (
	id serial4 NOT NULL,
	lot_id integer NOT NULL,
	gully_id int4 NOT NULL,
	code character varying(30),
	status int2,
	org_observ text,
	team_observ text,
	update_count integer,
	update_log jsonb,
	qindex1 numeric(12,3),
	qindex2 numeric(12,3),
	action int2,
	the_geom geometry(POINT, SRID_VALUE),
	CONSTRAINT om_campaign_lot_x_gully_pkey PRIMARY KEY (id),
	CONSTRAINT om_campaign_lot_x_gully_un UNIQUE (lot_id, gully_id),
	CONSTRAINT om_campaign_lot_x_gully_lot_id_fkey FOREIGN KEY (lot_id) REFERENCES om_campaign_lot (lot_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE
);

