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


CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_arc
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('plan_psector_x_arc');

CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_node
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('plan_psector_x_node');

CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON plan_psector_x_connec
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('plan_psector_x_connec');



CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON arc
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('arc');

CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON node
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('node');

CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON connec
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('connec');

CREATE TRIGGER gw_trg_refresh_state_expl_matviews AFTER INSERT OR UPDATE OR DELETE ON link
FOR EACH STATEMENT EXECUTE PROCEDURE gw_trg_refresh_state_expl_matviews('link');