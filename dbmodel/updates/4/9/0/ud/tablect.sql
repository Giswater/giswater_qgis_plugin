/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 20/04/2026
-- update cat_feature_gully column double_geom default value
ALTER TABLE cat_feature_gully ALTER COLUMN double_geom SET DEFAULT '{"activated":false,"value":1}'::JSON;

-- 28/04/2026
ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK
(((id)::text = ANY (ARRAY['CHAMBER'::text, 'CONDUIT'::text, 'CJOIN'::text, 'CONDUITLINK'::text, 'VLINK'::text, 'VCONNEC'::text, 'GINLET'::text, 'VGULLY'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'NETELEMENT'::text, 'NETGULLY'::text, 'NETINIT'::text,
'OUTFALL'::text, 'SIPHON'::text, 'STORAGE'::text, 'VALVE'::text, 'VARC'::text, 'WACCEL'::text, 'WJUMP'::text, 'WWTP'::text,
'GENELEM'::text, 'FRELEM'::TEXT, 'SAMPLEPOINT'::text, 'NETSAMPLEPOINT'::text])));
