/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;


ALTER TABLE IF EXISTS ud.tve_visit_arc_singlevent RENAME TO ve_visit_arc_singlevent;
ALTER TABLE IF EXISTS ud.tve_visit_connec_singlevent RENAME TO ve_visit_connec_singlevent;
ALTER TABLE IF EXISTS ud.tve_visit_connexio_neteja RENAME TO ve_visit_connexio_neteja;
ALTER TABLE IF EXISTS ud.tve_visit_emb_incidencia RENAME TO ve_visit_emb_incidencia;
ALTER TABLE IF EXISTS ud.tve_visit_emb_neteja RENAME TO ve_visit_emb_neteja;
ALTER TABLE IF EXISTS ud.tve_visit_gully_singlevent RENAME TO ve_visit_gully_singlevent;
ALTER TABLE IF EXISTS ud.tve_visit_incidencia RENAME TO ve_visit_incidencia;
ALTER TABLE IF EXISTS ud.tve_visit_node_incidencia RENAME TO ve_visit_node_incidencia;
ALTER TABLE IF EXISTS ud.tve_visit_node_neteja RENAME TO ve_visit_node_neteja;
ALTER TABLE IF EXISTS ud.tve_visit_node_singlevent RENAME TO ve_visit_node_singlevent;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_chamber RENAME TO ve_visit_revisio_chamber;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_embornal RENAME TO ve_visit_revisio_embornal;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_escomesa RENAME TO ve_visit_revisio_escomesa;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_inici RENAME TO ve_visit_revisio_inici;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_outfall RENAME TO ve_visit_revisio_outfall;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_pou RENAME TO ve_visit_revisio_pou;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_tram RENAME TO ve_visit_revisio_tram;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_unio RENAME TO ve_visit_revisio_unio;
ALTER TABLE IF EXISTS ud.tve_visit_revisio_valve RENAME TO ve_visit_revisio_valve;
ALTER TABLE IF EXISTS ud.tve_visit_tram_insp RENAME TO ve_visit_tram_insp;
ALTER TABLE IF EXISTS ud.tve_visit_tram_neteja RENAME TO ve_visit_tram_neteja;