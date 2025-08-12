/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 11/07/2025
ALTER TABLE arc ADD CONSTRAINT arc_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE connec ADD CONSTRAINT connec_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE gully ADD CONSTRAINT gully_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE link ADD CONSTRAINT link_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);
ALTER TABLE node ADD CONSTRAINT node_dma_id_fkey FOREIGN KEY (dma_id) REFERENCES dma(dma_id);

ALTER TABLE inp_inlet
ADD CONSTRAINT inp_inlet_inlet_type CHECK (inlet_type IN ('GULLY'));

ALTER TABLE inp_inlet
ADD CONSTRAINT inp_inlet_gully_type CHECK (outlet_type IN ('To_network'));

ALTER TABLE inp_inlet
ADD CONSTRAINT inp_inlet_gully_method CHECK (gully_method IN ('W_O'));

ALTER TABLE node DROP CONSTRAINT node_epa_type_check;
ALTER TABLE node ADD CONSTRAINT node_epa_type_check CHECK (epa_type IN ('JUNCTION', 'DIVIDER', 'OUTFALL', 'STORAGE', 'NETGULLY', 'INLET', 'UNDEFINED'));

-- 17/07/2025
ALTER TABLE connec DROP CONSTRAINT IF EXISTS connec_drainzone_id_fkey;
ALTER TABLE arc DROP CONSTRAINT IF EXISTS arc_drainzone_id_fkey;
ALTER TABLE gully DROP CONSTRAINT IF EXISTS gully_drainzone_id_fkey;
ALTER TABLE node DROP CONSTRAINT IF EXISTS node_drainzone_id_fkey;

-- 30/07/2025
ALTER TABLE element DROP CONSTRAINT IF EXISTS element_epa_type_check;
ALTER TABLE "element" ADD CONSTRAINT element_epa_type_check CHECK ((epa_type = ANY (ARRAY['FRPUMP'::text, 'FRWEIR'::text, 'FRORIFICE'::text, 'FROUTLET'::text, 'UNDEFINED'::text])));
ALTER TABLE "element" ADD CONSTRAINT element_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation(expl_id);
ALTER TABLE man_frelem ADD CONSTRAINT man_frelem_node_id_fkey FOREIGN KEY (node_id) REFERENCES node(node_id);

-- 06/08/2025
ALTER TABLE arc ADD CONSTRAINT arc_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id);
ALTER TABLE node ADD CONSTRAINT node_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id);
ALTER TABLE "element" ADD CONSTRAINT element_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES cat_brand(id);

ALTER TABLE arc ADD CONSTRAINT arc_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id);
ALTER TABLE node ADD CONSTRAINT node_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id);
ALTER TABLE "element" ADD CONSTRAINT element_model_id_fkey FOREIGN KEY (model_id) REFERENCES cat_brand_model(id);
