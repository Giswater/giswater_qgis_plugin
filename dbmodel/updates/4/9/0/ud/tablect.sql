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

-- 07/05/2026
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_dma_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_omunit_id_fkey;
ALTER TABLE arc ADD CONSTRAINT arc_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_dma_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_omunit_id_fkey;
ALTER TABLE connec ADD CONSTRAINT connec_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_dma_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_minsector_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_minsector_id_fkey FOREIGN KEY (minsector_id) REFERENCES minsector(minsector_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_omunit_id_fkey;
ALTER TABLE gully ADD CONSTRAINT gully_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE link DROP CONSTRAINT IF EXISTS link_dma_id_fkey;
ALTER TABLE link ADD CONSTRAINT link_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE link DROP CONSTRAINT IF EXISTS link_omunit_id_fkey;
ALTER TABLE link ADD CONSTRAINT link_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_dma_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE node DROP CONSTRAINT IF EXISTS node_omunit_id_fkey;
ALTER TABLE node ADD CONSTRAINT node_omunit_id_fkey FOREIGN KEY (omunit_id) REFERENCES omunit(omunit_id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE gully ADD CONSTRAINT gully_expl_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id) ON UPDATE CASCADE ON DELETE RESTRICT;

DO $$
DECLARE
    v_utils boolean;
BEGIN

	SELECT value::boolean INTO v_utils FROM config_param_system WHERE parameter='admin_utils_schema';

	IF v_utils IS true THEN
        ALTER TABLE raingage DROP CONSTRAINT IF EXISTS raingage_muni_id;
        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES utils.municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
    ELSE
        ALTER TABLE raingage DROP CONSTRAINT IF EXISTS raingage_muni_id;
        ALTER TABLE raingage ADD CONSTRAINT raingage_muni_id_fkey FOREIGN KEY (muni_id) REFERENCES ext_municipality(muni_id) ON UPDATE CASCADE ON DELETE RESTRICT;
    END IF;
END; $$;
