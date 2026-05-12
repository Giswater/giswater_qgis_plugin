/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;

DROP VIEW IF EXISTS ud.ve_visit_arc_singlevent;
DROP VIEW IF EXISTS ud.ve_visit_connec_singlevent;
DROP VIEW IF EXISTS ud.ve_visit_connexio_neteja;
DROP VIEW IF EXISTS ud.ve_visit_emb_incidencia;
DROP VIEW IF EXISTS ud.ve_visit_emb_incidencia_filter;
DROP VIEW IF EXISTS ud.ve_visit_emb_neteja;
DROP VIEW IF EXISTS ud.ve_visit_emb_neteja_aux;
DROP VIEW IF EXISTS ud.ve_visit_emb_neteja_filter;
DROP VIEW IF EXISTS ud.ve_visit_emb_neteja_filter_data;
DROP VIEW IF EXISTS ud.ve_visit_emb_neteja_filter_lot;
DROP VIEW IF EXISTS ud.ve_visit_gully_singlevent;
DROP VIEW IF EXISTS ud.ve_visit_incidencia;
DROP VIEW IF EXISTS ud.ve_visit_incidencia_filter;
DROP VIEW IF EXISTS ud.ve_visit_node_incidencia;
DROP VIEW IF EXISTS ud.ve_visit_node_incidencia_filter;
DROP VIEW IF EXISTS ud.ve_visit_node_neteja;
DROP VIEW IF EXISTS ud.ve_visit_node_singlevent;
DROP VIEW IF EXISTS ud.ve_visit_revisio_chamber;
DROP VIEW IF EXISTS ud.ve_visit_revisio_embornal;
DROP VIEW IF EXISTS ud.ve_visit_revisio_escomesa;
DROP VIEW IF EXISTS ud.ve_visit_revisio_inici;
DROP VIEW IF EXISTS ud.ve_visit_revisio_outfall;
DROP VIEW IF EXISTS ud.ve_visit_revisio_pou;
DROP VIEW IF EXISTS ud.ve_visit_revisio_tram;
DROP VIEW IF EXISTS ud.ve_visit_revisio_unio;
DROP VIEW IF EXISTS ud.ve_visit_revisio_valve;
DROP VIEW IF EXISTS ud.ve_visit_tram_insp;
DROP VIEW IF EXISTS ud.ve_visit_tram_insp_aux;
DROP VIEW IF EXISTS ud.ve_visit_tram_neteja;