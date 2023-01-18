/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2022/11/15

ALTER TABLE arc ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id)
REFERENCES drainzone (drainzone_id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id)
REFERENCES drainzone (drainzone_id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id)
REFERENCES drainzone (drainzone_id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT arc_drainzone_id_fkey FOREIGN KEY (drainzone_id)
REFERENCES drainzone (drainzone_id) MATCH SIMPLE
ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE IF EXISTS sys_feature_cat
ADD CONSTRAINT sys_feature_cat_check CHECK (id::text = ANY (ARRAY['CHAMBER'::character varying, 'CONDUIT'::character varying, 
	'CONNEC'::character varying, 'GULLY'::character varying, 'JUNCTION'::character varying, 'MANHOLE'::character varying, 
	'NETELEMENT'::character varying, 'NETGULLY'::character varying, 'NETINIT'::character varying, 'OUTFALL'::character varying, 
	'SIPHON'::character varying, 'STORAGE'::character varying, 'VALVE'::character varying, 'VARC'::character varying, 'WACCEL'::character varying, 
	'WJUMP'::character varying, 'WWTP'::character varying, 'ELEMENT'::character varying, 'LINK'::character varying]::text[]));
