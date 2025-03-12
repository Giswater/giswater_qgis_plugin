/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;


CREATE TABLE tve_visit_arc_singlevent AS SELECT * FROM ve_visit_arc_singlevent;
CREATE TABLE tve_visit_connec_singlevent AS SELECT * FROM ve_visit_connec_singlevent;
CREATE TABLE tve_visit_connexio_neteja AS SELECT * FROM ve_visit_connexio_neteja;
CREATE TABLE tve_visit_emb_incidencia AS SELECT * FROM ve_visit_emb_incidencia;
CREATE TABLE tve_visit_emb_neteja AS SELECT * FROM ve_visit_emb_neteja;
CREATE TABLE tve_visit_gully_singlevent AS SELECT * FROM ve_visit_gully_singlevent;
CREATE TABLE tve_visit_incidencia AS SELECT * FROM ve_visit_incidencia;
CREATE TABLE tve_visit_node_incidencia AS SELECT * FROM ve_visit_node_incidencia;
CREATE TABLE tve_visit_node_neteja AS SELECT * FROM ve_visit_node_neteja;
CREATE TABLE tve_visit_node_singlevent AS SELECT * FROM ve_visit_node_singlevent;
CREATE TABLE tve_visit_revisio_chamber AS SELECT * FROM ve_visit_revisio_chamber;
CREATE TABLE tve_visit_revisio_embornal AS SELECT * FROM ve_visit_revisio_embornal;
CREATE TABLE tve_visit_revisio_escomesa AS SELECT * FROM ve_visit_revisio_escomesa;
CREATE TABLE tve_visit_revisio_inici AS SELECT * FROM ve_visit_revisio_inici;
CREATE TABLE tve_visit_revisio_outfall AS SELECT * FROM ve_visit_revisio_outfall;
CREATE TABLE tve_visit_revisio_pou AS SELECT * FROM ve_visit_revisio_pou;
CREATE TABLE tve_visit_revisio_tram AS SELECT * FROM ve_visit_revisio_tram;
CREATE TABLE tve_visit_revisio_unio AS SELECT * FROM ve_visit_revisio_unio;
CREATE TABLE tve_visit_revisio_valve AS SELECT * FROM ve_visit_revisio_valve;
CREATE TABLE tve_visit_tram_insp AS SELECT * FROM ve_visit_tram_insp;
CREATE TABLE tve_visit_tram_neteja AS SELECT * FROM ve_visit_tram_neteja;


