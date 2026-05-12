/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;

DROP TRIGGER IF EXISTS gw_trg_om_visit_singlevent ON ve_visit_arc_singlevent;
DROP TRIGGER IF EXISTS gw_trg_om_visit_singlevent ON ve_visit_connec_singlevent;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_connexio_neteja;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_emb_incidencia;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_emb_neteja;
DROP TRIGGER IF EXISTS gw_trg_om_visit_singlevent ON ve_visit_gully_singlevent;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_incidencia;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_incidencia_filter;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_node_incidencia;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_node_neteja;
DROP TRIGGER IF EXISTS gw_trg_om_visit_singlevent ON ve_visit_node_singlevent;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_chamber;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_embornal;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_escomesa;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_inici;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_outfall;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_pou;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_tram;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_unio;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_revisio_valve;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_tram_insp;
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_tram_neteja;
