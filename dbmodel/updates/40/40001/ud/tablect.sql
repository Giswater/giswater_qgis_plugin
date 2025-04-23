/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK
(((id)::text = ANY (ARRAY['CHAMBER'::text, 'CONDUIT'::text, 'CONNEC'::text, 'GULLY'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'NETELEMENT'::text, 'NETGULLY'::text, 'NETINIT'::text,
'OUTFALL'::text, 'SIPHON'::text, 'STORAGE'::text, 'VALVE'::text, 'VARC'::text, 'WACCEL'::text, 'WJUMP'::text, 'WWTP'::text, 'LINK'::text, 'SERVCONNECTION'::text, 'INLETPIPE'::text,
'GENELEM'::text, 'FRELEM'::TEXT])));
