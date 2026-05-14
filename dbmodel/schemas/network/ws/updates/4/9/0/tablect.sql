/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 13/04/2026
CREATE INDEX IF NOT EXISTS man_netwjoin_customer_code_idx ON man_netwjoin USING btree (customer_code);

-- 28/04/2026
ALTER TABLE sys_feature_class ADD CONSTRAINT sys_feature_cat_check CHECK (id::text = ANY (
    ARRAY['EXPANSIONTANK'::text, 'FILTER'::text, 'FLEXUNION'::text, 'FOUNTAIN'::text, 'GREENTAP'::text, 'HYDRANT'::text, 'JUNCTION'::text, 'MANHOLE'::text, 'METER'::text,
    'NETELEMENT'::text, 'NETSAMPLEPOINT'::text, 'NETWJOIN'::text, 'PIPE'::text, 'PUMP'::text, 'REDUCTION'::text, 'REGISTER'::text, 'SOURCE'::text, 'TANK'::text, 'TAP'::text, 'VALVE'::text,
    'VARC'::text, 'WATERWELL'::text, 'WJOIN'::text, 'WTP'::text, 'PIPELINK'::text, 'VLINK'::text, 'VCONNEC'::text, 'ELEMENT'::text, 'GENELEM'::text, 'FRELEM'::text, 'SAMPLEPOINT'::text]));

-- 07/05/2026
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_brand_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_model_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE link DROP CONSTRAINT IF EXISTS link_minsector_id_fkey;
ALTER TABLE link ADD CONSTRAINT link_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE link DROP CONSTRAINT IF EXISTS link_sector_id;
ALTER TABLE link ADD CONSTRAINT link_sector_id FOREIGN KEY (sector_id) REFERENCES sector(sector_id) ON UPDATE CASCADE ON DELETE RESTRICT;
