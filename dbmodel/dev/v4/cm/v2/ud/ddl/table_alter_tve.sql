/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;


ALTER TABLE ud.tve_visit_connexio_neteja ADD CONSTRAINT tve_visit_connexio_neteja_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_emb_incidencia ADD CONSTRAINT tve_visit_emb_incidencia_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_emb_neteja ADD CONSTRAINT tve_visit_emb_neteja_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_gully_singlevent ADD CONSTRAINT tve_visit_gully_singlevent_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_incidencia ADD CONSTRAINT tve_visit_incidencia_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_node_incidencia ADD CONSTRAINT tve_visit_node_incidencia_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_node_neteja ADD CONSTRAINT tve_visit_node_neteja_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_node_singlevent ADD CONSTRAINT tve_visit_node_singlevent_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_revisio_chamber ADD CONSTRAINT tve_visit_revisio_chamber_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_revisio_embornal ADD CONSTRAINT tve_visit_revisio_embornal_pk PRIMARY KEY (visit_id, gully_id);
ALTER TABLE ud.tve_visit_revisio_escomesa ADD CONSTRAINT tve_visit_revisio_escomesa_pk PRIMARY KEY (visit_id, connec_id);
ALTER TABLE ud.tve_visit_revisio_inici ADD CONSTRAINT tve_visit_revisio_inici_pk PRIMARY KEY (visit_id, node_id);
ALTER TABLE ud.tve_visit_revisio_outfall ADD CONSTRAINT tve_visit_revisio_outfall_pk PRIMARY KEY (visit_id, node_id);
ALTER TABLE ud.tve_visit_revisio_pou ADD CONSTRAINT tve_visit_revisio_pou_pk PRIMARY KEY (visit_id, node_id);
ALTER TABLE ud.tve_visit_revisio_tram ADD CONSTRAINT tve_visit_revisio_tram_pk PRIMARY KEY (visit_id, arc_id);
ALTER TABLE ud.tve_visit_revisio_unio ADD CONSTRAINT tve_visit_revisio_unio_pk PRIMARY KEY (visit_id, node_id);
ALTER TABLE ud.tve_visit_revisio_valve ADD CONSTRAINT tve_visit_revisio_valve_pk PRIMARY KEY (visit_id, node_id);
ALTER TABLE ud.tve_visit_tram_insp ADD CONSTRAINT tve_visit_tram_insp_pk PRIMARY KEY (visit_id);
ALTER TABLE ud.tve_visit_tram_neteja ADD CONSTRAINT tve_visit_tram_neteja_pk PRIMARY KEY (visit_id);
