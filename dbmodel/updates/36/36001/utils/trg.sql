/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP TRIGGER gw_trg_link_data ON link;

CREATE TRIGGER gw_trg_link_data  AFTER INSERT OR UPDATE of the_geom ON link
FOR EACH ROW EXECUTE PROCEDURE gw_trg_link_data('link');


-- 23/05/2023
DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_arc_insp;

create trigger gw_trg_om_visit_multievent instead of insert or delete or update on
ve_visit_arc_insp for each row execute function gw_trg_om_visit_multievent('6');

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_arc_leak;

create trigger gw_trg_om_visit_multievent instead of insert or delete or update on
ve_visit_arc_leak for each row execute function gw_trg_om_visit_multievent('1');

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_connec_insp;

create trigger gw_trg_om_visit_multievent instead of insert or delete or update on
ve_visit_connec_insp for each row execute function gw_trg_om_visit_multievent('2');

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_connec_leak;

create trigger gw_trg_om_visit_multievent instead of insert or delete or update on
ve_visit_connec_leak for each row execute function gw_trg_om_visit_multievent('4');

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_node_insp;

create trigger gw_trg_om_visit_multievent instead of insert or delete or update on
ve_visit_node_insp for each row execute function gw_trg_om_visit_multievent('5');

DROP TRIGGER IF EXISTS gw_trg_om_visit_multievent ON ve_visit_node_leak;

create trigger gw_trg_om_visit_multievent instead of insert or delete or update on
ve_visit_node_leak for each row execute function gw_trg_om_visit_multievent('3');



