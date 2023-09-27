/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE IF EXISTS plan_netscenario_dma
    ADD CONSTRAINT plan_netscenario_dma_netscenario_id_fkey FOREIGN KEY (netscenario_id)
    REFERENCES plan_netscenario (netscenario_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_presszone
    ADD CONSTRAINT plan_netscenario_presszone_netscenario_id_fkey FOREIGN KEY (netscenario_id)
    REFERENCES plan_netscenario (netscenario_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_arc
    ADD CONSTRAINT plan_netscenario_arc_netscenario_id_dma_id_fkey FOREIGN KEY (netscenario_id, dma_id)
    REFERENCES plan_netscenario_dma (netscenario_id, dma_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_node
    ADD CONSTRAINT plan_netscenario_node_netscenario_id_dma_id_fkey FOREIGN KEY (netscenario_id, dma_id)
    REFERENCES plan_netscenario_dma (netscenario_id, dma_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_connec
    ADD CONSTRAINT plan_netscenario_connec_netscenario_id_dma_id_fkey FOREIGN KEY (netscenario_id, dma_id)
    REFERENCES plan_netscenario_dma (netscenario_id, dma_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;
    
ALTER TABLE IF EXISTS plan_netscenario_arc
    ADD CONSTRAINT plan_netscenario_arc_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id)
    REFERENCES plan_netscenario_presszone (netscenario_id, presszone_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_node
    ADD CONSTRAINT plan_netscenario_node_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id)
    REFERENCES plan_netscenario_presszone (netscenario_id, presszone_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_connec
    ADD CONSTRAINT plan_netscenario_connec_netscenario_id_presszone_id_fkey FOREIGN KEY (netscenario_id, presszone_id)
    REFERENCES plan_netscenario_presszone (netscenario_id, presszone_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE CASCADE;

ALTER TABLE IF EXISTS plan_netscenario_valve ADD CONSTRAINT plan_netscenario_valve_netscenario_id_node_id_fkey FOREIGN KEY (netscenario_id, node_id)
REFERENCES plan_netscenario_node(netscenario_id,node_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;