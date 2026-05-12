/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;


ALTER VIEW ud.ve_visit_arc_singlevent RENAME TO ve_visit_arc_singlevent_old;
ALTER VIEW ud.ve_visit_connec_singlevent RENAME TO ve_visit_connec_singlevent_old;
ALTER VIEW ud.ve_visit_connexio_neteja RENAME TO ve_visit_connexio_neteja_old;
ALTER VIEW ud.ve_visit_emb_incidencia RENAME TO ve_visit_emb_incidencia_old;
ALTER VIEW ud.ve_visit_emb_neteja RENAME TO ve_visit_emb_neteja_old;
ALTER VIEW ud.ve_visit_gully_singlevent RENAME TO ve_visit_gully_singlevent_old;
ALTER VIEW ud.ve_visit_incidencia RENAME TO ve_visit_incidencia_old;
ALTER VIEW ud.ve_visit_node_incidencia RENAME TO ve_visit_node_incidencia_old;
ALTER VIEW ud.ve_visit_node_neteja RENAME TO ve_visit_node_neteja_old;
ALTER VIEW ud.ve_visit_node_singlevent RENAME TO ve_visit_node_singlevent_old;
ALTER VIEW ud.ve_visit_revisio_chamber RENAME TO ve_visit_revisio_chamber_old;
ALTER VIEW ud.ve_visit_revisio_embornal RENAME TO ve_visit_revisio_embornal_old;
ALTER VIEW ud.ve_visit_revisio_escomesa RENAME TO ve_visit_revisio_escomesa_old;
ALTER VIEW ud.ve_visit_revisio_inici RENAME TO ve_visit_revisio_inici_old;
ALTER VIEW ud.ve_visit_revisio_outfall RENAME TO ve_visit_revisio_outfall_old;
ALTER VIEW ud.ve_visit_revisio_pou RENAME TO ve_visit_revisio_pou_old;
ALTER VIEW ud.ve_visit_revisio_tram RENAME TO ve_visit_revisio_tram_old;
ALTER VIEW ud.ve_visit_revisio_unio RENAME TO ve_visit_revisio_unio_old;
ALTER VIEW ud.ve_visit_revisio_valve RENAME TO ve_visit_revisio_valve_old;
ALTER VIEW ud.ve_visit_tram_insp RENAME TO ve_visit_tram_insp_old;
ALTER VIEW ud.ve_visit_tram_neteja RENAME TO ve_visit_tram_neteja_old;