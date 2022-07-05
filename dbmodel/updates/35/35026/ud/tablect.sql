/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/06/11
ALTER TABLE cat_feature_gully ADD CONSTRAINT cat_feature_gully_inp_check CHECK (epa_default::text = ANY (ARRAY['GULLY'::text, 'UNDEFINED'::text]));

ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_gratecat2_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_gratecat2_id_fkey FOREIGN KEY (gratecat2_id) REFERENCES cat_grate (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE man_netgully DROP CONSTRAINT IF EXISTS man_netgully_gratecat2_id_fkey;
ALTER TABLE man_netgully ADD CONSTRAINT man_netgully_gratecat2_id_fkey FOREIGN KEY (gratecat2_id) REFERENCES cat_grate (id) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_epa_type_check;
ALTER TABLE node ADD CONSTRAINT node_epa_type_check 
CHECK (epa_type::text = ANY (ARRAY['JUNCTION'::text, 'STORAGE'::text, 'DIVIDER'::text, 'OUTFALL'::text, 'NETGULLY'::text, 'UNDEFINED'::text]));

ALTER TABLE cat_feature_node DROP CONSTRAINT cat_feature_node_inp_check;
ALTER TABLE cat_feature_node
ADD CONSTRAINT cat_feature_node_inp_check CHECK (epa_default::text = ANY (ARRAY['JUNCTION'::text, 'STORAGE'::text, 'DIVIDER'::text, 'OUTFALL'::text, 'NETGULLY'::text, 'UNDEFINED'::text]));
