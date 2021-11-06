/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/11/05
ALTER TABLE connec DROP CONSTRAINT connec_pjoint_type_ckeck;
ALTER TABLE connec ADD CONSTRAINT connec_pjoint_type_ckeck 
CHECK (pjoint_type::text = ANY (ARRAY['NODE'::character varying::text, 'VNODE'::character varying::text, 'CONNEC'::character varying::text, 'GULLY'::character varying::text]));

ALTER TABLE gully DROP CONSTRAINT gully_pjoint_type_ckeck;
ALTER TABLE gully ADD CONSTRAINT gully_pjoint_type_ckeck 
CHECK (pjoint_type::text = ANY (ARRAY['NODE'::character varying::text, 'VNODE'::character varying::text, 'CONNEC'::character varying::text, 'GULLY'::character varying::text]));
