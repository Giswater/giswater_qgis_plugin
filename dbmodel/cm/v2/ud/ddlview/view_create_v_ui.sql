/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;


DROP VIEW IF EXISTS ud.v_ui_visit_connexio_neteja;
CREATE OR REPLACE VIEW ud.v_ui_visit_connexio_neteja
AS SELECT ve_visit_connexio_neteja.visit_id,
    ve_visit_connexio_neteja.lot_id,
    ve_visit_connexio_neteja.unit_id,
    ve_visit_connexio_neteja.gully_id,
    ve_visit_connexio_neteja.status_name AS "Estat",
    date(ve_visit_connexio_neteja.startdate) AS startdate,
    date(ve_visit_connexio_neteja.enddate) AS enddate,
    ve_visit_connexio_neteja.tram_exec_visit_v AS "Activitat",
    ve_visit_connexio_neteja.tram_netejat_v AS "Netejat",
    ve_visit_connexio_neteja.tram_res_nivell_v AS "Nivell residus",
    ve_visit_connexio_neteja.tram_incident_v AS "Incidència",
    ve_visit_connexio_neteja.tram_inacces_v AS "No netejat",
    ve_visit_connexio_neteja.tram_cm_sedim AS "Sediment pou",
    ve_visit_connexio_neteja.tram_res_sabo AS "Sabó",
    ve_visit_connexio_neteja.tram_res_oli AS "Oli",
    ve_visit_connexio_neteja.tram_res_greix AS "Greix",
    ve_visit_connexio_neteja.tram_res_sorra AS "Sorra",
    ve_visit_connexio_neteja.tram_res_brossa AS "Brossa",
    ve_visit_connexio_neteja.class_id,
    ve_visit_connexio_neteja.class_name AS "Tipus",
    cat_users.name AS "Usuari",
    ve_visit_connexio_neteja.num_elem_visit AS "Número d'elements",
    date_trunc('second'::text, a.sum) AS "Durada",
    ve_visit_connexio_neteja.tram_observ AS "Observacions",
    ve_visit_connexio_neteja.photo
   FROM ve_visit_connexio_neteja
     JOIN cat_users ON cat_users.id::text = ve_visit_connexio_neteja.user_name::text
     LEFT JOIN ( SELECT om_unit_intervals.unit_id,
            om_unit_intervals.lot_id,
            sum(om_unit_intervals.enddate - om_unit_intervals.startdate) AS sum
           FROM om_unit_intervals
          GROUP BY om_unit_intervals.unit_id, om_unit_intervals.lot_id) a ON a.unit_id = ve_visit_connexio_neteja.unit_id AND a.lot_id = ve_visit_connexio_neteja.lot_id;


DROP VIEW IF EXISTS ud.v_ui_visit_emb_incidencia;
CREATE OR REPLACE VIEW ud.v_ui_visit_emb_incidencia
AS SELECT ve_visit_emb_incidencia.visit_id,
    ve_visit_emb_incidencia.gully_id,
    ve_visit_emb_incidencia.code,
    date(ve_visit_emb_incidencia.startdate) AS startdate,
    date(ve_visit_emb_incidencia.enddate) AS enddate,
    ve_visit_emb_incidencia.emb_incid_tip_v AS "Tipus incidencia",
    ve_visit_emb_incidencia.emb_incid_grau_urgent_v AS "Grau d'urgència",
    ve_visit_emb_incidencia.emb_incid_status_v AS "Estat incidencia",
    ve_visit_emb_incidencia.class_id,
    ve_visit_emb_incidencia.class_name as "Tipus",
    cat_users.name AS "Usuari",
    ve_visit_emb_incidencia.emb_incid_obs AS "Observacions",
    ve_visit_emb_incidencia.photo
   FROM ve_visit_emb_incidencia
     JOIN cat_users ON cat_users.id::text = ve_visit_emb_incidencia.user_name::text;


DROP VIEW IF EXISTS ud.v_ui_visit_emb_neteja;
CREATE OR REPLACE VIEW ud.v_ui_visit_emb_neteja
AS SELECT ve_visit_emb_neteja.visit_id,
    ve_visit_emb_neteja.lot_id,
    ve_visit_emb_neteja.gully_id,
    ve_visit_emb_neteja.status_name AS "Estat",
    date(ve_visit_emb_neteja.startdate) AS startdate,
    date(ve_visit_emb_neteja.enddate) AS enddate,
    ve_visit_emb_neteja.emb_netejat_v AS "Netejat",
    ve_visit_emb_neteja.emb_res_nivell_v AS "Nivell residus",
    ve_visit_emb_neteja.emb_incident_v AS "Incidencia",
    ve_visit_emb_neteja.emb_res_organic AS "Orgànic",
    ve_visit_emb_neteja.emb_res_ciment AS "Ciment",
    ve_visit_emb_neteja.emb_res_sorra AS "Sorra",
    ve_visit_emb_neteja.emb_res_quimics AS "Químics",
    ve_visit_emb_neteja.emb_mosquits AS "Mosquits",
    ve_visit_emb_neteja.emb_rates AS "Rates",
    ve_visit_emb_neteja.emb_paneroles AS "Paneroles",
    ve_visit_emb_neteja.class_id,
    ve_visit_emb_neteja.class_name as "Tipus",
    cat_users.name AS "Usuari",
    ve_visit_emb_neteja.emb_observ AS "Observacions",
    ve_visit_emb_neteja.photo
   FROM ve_visit_emb_neteja
     JOIN cat_users ON cat_users.id::text = ve_visit_emb_neteja.user_name::text;


DROP VIEW IF EXISTS ud.v_ui_visit_node_incidencia;
CREATE OR REPLACE VIEW ud.v_ui_visit_node_incidencia
AS SELECT ve_visit_node_incidencia.visit_id,
    ve_visit_node_incidencia.node_id,
    ve_visit_node_incidencia.code,
    date(ve_visit_node_incidencia.startdate) AS startdate,
    date(ve_visit_node_incidencia.enddate) AS enddate,
    ve_visit_node_incidencia.node_incid_tip_v AS "Tipus incidencia",
    ve_visit_node_incidencia.node_incid_grau_urgent_v AS "Grau d'urgència",
    ve_visit_node_incidencia.node_incid_status_v AS "Estat incidencia",
    ve_visit_node_incidencia.class_id,
    ve_visit_node_incidencia.class_name as "Tipus",
    cat_users.name AS "Usuari",
    ve_visit_node_incidencia.node_incid_obs AS "Observacions",
    ve_visit_node_incidencia.photo
   FROM ve_visit_node_incidencia
     JOIN cat_users ON cat_users.id::text = ve_visit_node_incidencia.user_name::text;


DROP VIEW IF EXISTS ud.v_ui_visit_node_neteja;
CREATE OR REPLACE VIEW ud.v_ui_visit_node_neteja
AS SELECT ve_visit_node_neteja.visit_id,
    ve_visit_node_neteja.lot_id,
    ve_visit_node_neteja.unit_id,
    ve_visit_node_neteja.node_id,
    ve_visit_node_neteja.status_name as "Estat",
    date(ve_visit_node_neteja.startdate) AS startdate,
    date(ve_visit_node_neteja.enddate) AS enddate,
    ve_visit_node_neteja.tram_exec_visit_v AS "Activitat",
    ve_visit_node_neteja.tram_netejat_v AS "Netejat",
    ve_visit_node_neteja.tram_res_nivell_v AS "Nivell residus",
    ve_visit_node_neteja.tram_incident_v AS "Incidència",
    ve_visit_node_neteja.tram_inacces_v AS "No netejat",
    ve_visit_node_neteja.tram_kg AS "Kg extrets",
    ve_visit_node_neteja.tram_cm_sedim AS "Sediment pou",
    ve_visit_node_neteja.tram_res_sabo AS "Sabó",
    ve_visit_node_neteja.tram_res_oli AS "Oli",
    ve_visit_node_neteja.tram_res_greix AS "Greix",
    ve_visit_node_neteja.tram_res_sorra AS "Sorra",
    ve_visit_node_neteja.tram_res_brossa AS "Brossa",
    ve_visit_node_neteja.tram_paneroles AS "Paneroles",
    ve_visit_node_neteja.tram_rates AS "Rates",
    ve_visit_node_neteja.class_id,
    ve_visit_node_neteja.class_name as "Tipus",
    cat_users.name AS "Usuari",
    ve_visit_node_neteja.num_elem_visit AS "Número d'elements",
    date_trunc('second'::text, a.sum) AS "Durada",
    ve_visit_node_neteja.tram_observ AS "Observacions",
    ve_visit_node_neteja.photo
   FROM ve_visit_node_neteja
     JOIN cat_users ON cat_users.id::text = ve_visit_node_neteja.user_name::text
     LEFT JOIN ( SELECT om_unit_intervals.unit_id,
            om_unit_intervals.lot_id,
            sum(om_unit_intervals.enddate - om_unit_intervals.startdate) AS sum
           FROM om_unit_intervals
          GROUP BY om_unit_intervals.unit_id, om_unit_intervals.lot_id) a ON a.unit_id = ve_visit_node_neteja.unit_id AND a.lot_id = ve_visit_node_neteja.lot_id;


DROP VIEW IF EXISTS ud.v_ui_visit_tram_insp;
CREATE OR REPLACE VIEW ud.v_ui_visit_tram_insp
AS SELECT ve_visit_tram_insp.visit_id,
    ve_visit_tram_insp.lot_id,
    ve_visit_tram_insp.arc_id,
    date(ve_visit_tram_insp.startdate) AS startdate,
    date(ve_visit_tram_insp.enddate) AS enddate,
    ve_visit_tram_insp.insp_tram_n_inici AS "Node inici",
    ve_visit_tram_insp.insp_tram_sino_v AS "S'ha inspeccionat?",
    ve_visit_tram_insp.insp_tram_complet_v AS "Inspecció completa?",
    ve_visit_tram_insp.insp_tram_incident_v AS "Perquè no?",
    ve_visit_tram_insp.insp_tram_ml_revisats AS "Ml revisats",
    ve_visit_tram_insp.insp_tram_estat_v AS "Conservació general",
    ve_visit_tram_insp.insp_tram_paneroles_v AS "Paneroles",
    ve_visit_tram_insp.insp_tram_rates_v AS "Rates",
    ve_visit_tram_insp.insp_tram_sedim_v AS "Sediments",
    ve_visit_tram_insp.insp_tram_sedim_dada AS "Ml sediment",
    ve_visit_tram_insp.insp_tram_fangs AS "Fangs",
    ve_visit_tram_insp.insp_tram_sorra AS "Sorra neta",
    ve_visit_tram_insp.insp_tram_runa AS "Runa",
    ve_visit_tram_insp.insp_tram_greixos AS "Greixos/Sabons",
    ve_visit_tram_insp.insp_tram_ensorraments AS "Ensorraments",
    ve_visit_tram_insp.insp_tram_esquerdes AS "Tram esquerdat",
    ve_visit_tram_insp.insp_tram_deforma AS "Tram deformat",
    ve_visit_tram_insp.insp_tram_danys_solera AS "Solera danyada",
    ve_visit_tram_insp.insp_tram_claveg_pen AS "Clavegueró penetrant",
    ve_visit_tram_insp.insp_tram_trencaments AS "Trencaments",
    ve_visit_tram_insp.insp_tram_beurada_cim AS "Beurada de ciment",
    ve_visit_tram_insp.insp_tram_aboc_formigo AS "Abocament de formigó",
    ve_visit_tram_insp.insp_tram_filtracio AS "Filtració d'aigua",
    ve_visit_tram_insp.insp_tram_forat AS "Forat punt connexió claveg",
    ve_visit_tram_insp.insp_tram_entrada_arrels AS "Entrada arrels",
    ve_visit_tram_insp.insp_tram_juntes_defec AS "Juntes separades/defctuoses",
    ve_visit_tram_insp.insp_tram_empelt_defec AS "Empelt defectuós",
    ve_visit_tram_insp.insp_tram_minutatge AS "Minutatge vídeo",
    ve_visit_tram_insp.class_id,
    ve_visit_tram_insp.class_name as "Tipus",
    cat_users.name AS "Usuari",
    ve_visit_tram_insp.insp_tram_obs AS "Observacions"
   FROM ve_visit_tram_insp
     JOIN cat_users ON cat_users.id::text = ve_visit_tram_insp.user_name::text;


DROP VIEW IF EXISTS ud.v_ui_visit_tram_neteja;
CREATE OR REPLACE VIEW ud.v_ui_visit_tram_neteja
AS SELECT ve_visit_tram_neteja.visit_id,
    ve_visit_tram_neteja.lot_id,
    ve_visit_tram_neteja.unit_id,
    ve_visit_tram_neteja.arc_id,
    ve_visit_tram_neteja.status_name AS "Estat",
    date(ve_visit_tram_neteja.startdate) AS startdate,
    date(ve_visit_tram_neteja.enddate) AS enddate,
    ve_visit_tram_neteja.tram_exec_visit_v AS "Activitat",
    ve_visit_tram_neteja.tram_netejat_v AS "Netejat",
    ve_visit_tram_neteja.tram_res_nivell_v AS "Nivell residus",
    ve_visit_tram_neteja.tram_incident_v AS "Incidència",
    ve_visit_tram_neteja.tram_inacces_v AS "No netejat",
    ve_visit_tram_neteja.tram_cm_sedim AS "Sediment pou",
    ve_visit_tram_neteja.tram_res_sabo AS "Sabó",
    ve_visit_tram_neteja.tram_res_oli AS "Oli",
    ve_visit_tram_neteja.tram_res_greix AS "Greix",
    ve_visit_tram_neteja.tram_res_sorra AS "Sorra",
    ve_visit_tram_neteja.tram_res_brossa AS "Brossa",
    ve_visit_tram_neteja.tram_res_ciment AS "Beurada",
    ve_visit_tram_neteja.tram_res_colorant AS "Colorant",
    ve_visit_tram_neteja.tram_res_tros_tub AS "Trossos tub",
    ve_visit_tram_neteja.tram_paneroles AS "Paneroles",
    ve_visit_tram_neteja.tram_rates AS "Rates",
    ve_visit_tram_neteja.tram_contrapendent_v AS "Neteja contrapendent",
    ve_visit_tram_neteja.tram_regis_no_adj_v AS "Des de registre no adjcent",
    ve_visit_tram_neteja.class_id,
    ve_visit_tram_neteja.class_name as "Tipus",
    cat_users.name AS "Usuari",
    ve_visit_tram_neteja.num_elem_visit AS "Número d'elements",
    date_trunc('second'::text, a.sum) AS "Durada",
    ve_visit_tram_neteja.tram_observ AS "Observacions",
    ve_visit_tram_neteja.photo
   FROM ve_visit_tram_neteja
     JOIN cat_users ON cat_users.id::text = ve_visit_tram_neteja.user_name::text
     LEFT JOIN ( SELECT om_unit_intervals.unit_id,
            om_unit_intervals.lot_id,
            sum(om_unit_intervals.enddate - om_unit_intervals.startdate) AS sum
           FROM om_unit_intervals
          GROUP BY om_unit_intervals.unit_id, om_unit_intervals.lot_id) a ON a.unit_id = ve_visit_tram_neteja.unit_id AND a.lot_id = ve_visit_tram_neteja.lot_id;

