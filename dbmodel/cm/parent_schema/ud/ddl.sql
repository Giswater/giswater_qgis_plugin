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
	gullycat_id text,
	gully_type text,
	the_geom public.geometry(point, SRID_VALUE) NULL,
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

--drop table cm.doc_x_gully;
CREATE TABLE cm.doc_x_gully (
	doc_id int4 NOT NULL,
	gully_id int4 NULL,
	gully_uuid uuid NOT NULL,
	CONSTRAINT doc_x_gully_pkey PRIMARY KEY (doc_id, gully_uuid)
);

ALTER TABLE cm.doc_x_gully ADD CONSTRAINT doc_x_gully_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES cm.doc(id) ON DELETE CASCADE ON UPDATE CASCADE;

GRANT ALL ON TABLE cm.doc_x_gully TO role_cm_manager;
GRANT ALL ON TABLE cm.doc_x_gully TO role_cm_field;

CREATE OR REPLACE VIEW v_ui_doc_x_gully
AS
SELECT
	doc_x_gully.doc_id,
	doc_x_gully.gully_id,
	doc.name,
	doc.doc_type,
	doc.path,
	doc.observ,
	doc.date,
	doc.user_name,
	doc_x_gully.gully_uuid
FROM cm.doc_x_gully
JOIN cm.doc ON doc.id::text = doc_x_gully.doc_id::text;

GRANT ALL ON TABLE v_ui_doc_x_gully TO role_cm_manager;
GRANT ALL ON TABLE v_ui_doc_x_gully TO role_cm_field;

