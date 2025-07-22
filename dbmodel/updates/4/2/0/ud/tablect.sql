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