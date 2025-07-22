/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 3/1/2024
ALTER TABLE arc ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE node ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE connec ALTER COLUMN dma_id DROP NOT NULL;
ALTER TABLE link ALTER COLUMN dma_id DROP NOT NULL;


CREATE INDEX plan_netscenario_arc_dma_index ON plan_netscenario_arc USING btree (dma_id);
CREATE INDEX plan_netscenario_arc_presszone_index ON plan_netscenario_arc USING btree (presszone_id);
CREATE INDEX plan_netscenario_arc_geom_index ON plan_netscenario_arc USING gist (the_geom);

CREATE INDEX plan_netscenario_node_dma_index ON plan_netscenario_node USING btree (dma_id);
CREATE INDEX plan_netscenario_node_presszone_index ON plan_netscenario_node USING btree (presszone_id);
CREATE INDEX plan_netscenario_node_geom_index ON plan_netscenario_node USING gist (the_geom);

CREATE INDEX plan_netscenario_connec_dma_index ON plan_netscenario_connec USING btree (dma_id);
CREATE INDEX plan_netscenario_connec_presszone_index ON plan_netscenario_connec USING btree (presszone_id);
CREATE INDEX plan_netscenario_connec_geom_index ON plan_netscenario_connec USING gist (the_geom);