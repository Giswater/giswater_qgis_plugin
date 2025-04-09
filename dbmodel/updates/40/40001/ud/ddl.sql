/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

CREATE TABLE man_link_gully (
	link_id int4 NOT NULL,
	CONSTRAINT man_lgully_pkey PRIMARY KEY (link_id),
	CONSTRAINT man_lgully_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK (((id)::text = ANY (ARRAY['CHAMBER'::text, 'CONDUIT'::text, 'CONNEC'::text, 'GULLY'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'NETELEMENT'::text, 'NETGULLY'::text, 'NETINIT'::text, 'OUTFALL'::text, 'SIPHON'::text, 'STORAGE'::text, 'VALVE'::text, 'VARC'::text, 'WACCEL'::text, 'WJUMP'::text, 'WWTP'::text, 'ELEMENT'::text, 'LINK'::text, 'ORIFICE'::text, 'VFLWREG'::text, 'WEIR'::text, 'PUMP'::text, 'LINK_CONNEC'::text, 'LINK_GULLY'::text])));
