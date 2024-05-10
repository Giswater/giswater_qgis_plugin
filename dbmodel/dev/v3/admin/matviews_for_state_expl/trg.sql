/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 1/11/2023
CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON selector_expl
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('selector_expl');

CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON selector_psector
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('selector_psector');

CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON selector_state
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('selector_state');

CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_arc
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('plan_psector_x_arc');

CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_node
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('plan_psector_x_node');

CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_connec
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('plan_psector_x_connec');



CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OF expl_id, state, expl_id2 OR DELETE ON arc
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('arc');

CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OF expl_id, state, expl_id2 OR DELETE ON node
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('node');

CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OF expl_id, state, expl_id2 OR DELETE ON connec
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('connec');

CREATE CONSTRAINT TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OF expl_id, state, expl_id2 OR DELETE ON link
DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('link');