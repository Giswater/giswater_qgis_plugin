/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


alter table archived_psector_gully add column psector_descript text;
 
drop table archived_psector_link;

CREATE TABLE archived_psector_link  (
	id serial4 NOT NULL,
	psector_id int4 NOT NULL,
	psector_state int2 NOT NULL,
	doable bool NOT NULL,
	addparam json NULL,
	audit_tstamp timestamp DEFAULT now() NULL,
	audit_user text DEFAULT CURRENT_USER NULL,
	action varchar(16) NOT NULL,
 	link_id integer,
	code text NULL,
	sys_code text NULL,
	top_elev1 float8 NULL,
	y1 numeric(12, 4) NULL,
	exit_id int4 NULL,
	exit_type varchar(16) NULL,
	top_elev2 float8 NULL,
	y2 numeric(12, 4) NULL,
	feature_type varchar(16) NULL,
	feature_id int4 NULL,
	link_type varchar(30) NOT NULL,
	linkcat_id varchar(30) NOT NULL,
	state int2 NOT NULL,
	state_type int2 NULL,
	expl_id int4 DEFAULT 0 NOT NULL,
	expl_id2 int4 DEFAULT 0 NOT NULL,
	muni_id int4 DEFAULT 0 NOT NULL,
	sector_id int4 DEFAULT 0 NOT NULL,
	dma_id int4 DEFAULT 0 NULL,
	dwfzone_id int4 DEFAULT 0 NULL,
	omzone_id int4 DEFAULT 0 NULL,
	drainzone_outfall _int4 NULL,
	dwfzone_outfall _int4 NULL,
	location_type varchar(50) NULL,
	_fluid_type varchar(50) NULL,
	fluid_type int4 DEFAULT 0 NOT NULL,
	custom_length numeric(12, 2) NULL,
	sys_slope numeric(12, 3) NULL,
	annotation text NULL,
	observ text NULL,
	"comment" text NULL,
	descript varchar(254) NULL,
	link varchar(512) NULL,
	num_value numeric(12, 3) NULL,
	workcat_id varchar(255) NULL,
	workcat_id_end varchar(255) NULL,
	builtdate date NULL,
	enddate date NULL,
	brand_id varchar(50) NULL,
	model_id varchar(50) NULL,
	private_linkcat_id varchar(30) NULL,
	verified int2 NULL,
	uncertain bool NULL,
	userdefined_geom bool NULL,
	datasource int4 NULL,
	is_operative bool NULL,
	lock_level int4 NULL,
	expl_visibility _int2 NULL,
	created_at timestamptz DEFAULT now() NULL,
	created_by varchar(50) DEFAULT CURRENT_USER NULL,
	updated_at timestamptz NULL,
	updated_by varchar(50) NULL,
	the_geom public.geometry(linestring, SRID_VALUE) NULL,
	CONSTRAINT archived_psector_link_pkey PRIMARY KEY (id)
);
CREATE INDEX archived_psector_link_exit_id ON archived_psector_link USING btree (exit_id);
CREATE INDEX archived_psector_link_expl_visibility_idx ON ud421.link USING btree (expl_visibility);
CREATE INDEX archived_psector_link_feature_id ON archived_psector_link USING btree (feature_id);
CREATE INDEX archived_psector_link_index ON archived_psector_link USING gist (the_geom);
CREATE INDEX archived_psector_link_muni ON archived_psector_link USING btree (muni_id);

