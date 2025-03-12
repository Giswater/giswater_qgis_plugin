/*
Copyright © 2023 by BGEO. All rights reserved.
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = ud, public, pg_catalog;

CREATE TRIGGER gw_trg_om_visit_singlevent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_arc_singlevent
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('arc');

CREATE TRIGGER gw_trg_om_visit_singlevent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_connec_singlevent 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('connec');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_connexio_neteja 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('17');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_emb_incidencia 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('11');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_emb_neteja 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('10');

CREATE TRIGGER gw_trg_om_visit_singlevent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_gully_singlevent 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('gully');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_incidencia 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('12');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_node_incidencia
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('18');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_node_neteja 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('16');

CREATE TRIGGER gw_trg_om_visit_singlevent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_node_singlevent 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_singlevent('node');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_chamber 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('7');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_embornal 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('2');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_escomesa 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('1');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_inici 
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('9');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_outfall
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('5');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_pou
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('8');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_tram
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('3');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_unio
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('4');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_revisio_valve
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('6');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_tram_insp
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('14');

CREATE TRIGGER gw_trg_om_visit_multievent AFTER INSERT OR DELETE OR UPDATE ON ud.tve_visit_tram_neteja
FOR EACH ROW EXECUTE FUNCTION gw_trg_om_visit_multievent('15');

