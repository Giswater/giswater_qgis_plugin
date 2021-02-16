DROP TRIGGER IF EXISTS gw_trg_plan_psector_delete_arc ON plan_psector_x_arc;
CREATE TRIGGER gw_trg_plan_psector_delete_arc
AFTER DELETE ON plan_psector_x_arc
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_delete('arc');

DROP TRIGGER IF EXISTS gw_trg_plan_psector_delete_node ON plan_psector_x_node;
CREATE TRIGGER gw_trg_plan_psector_delete_node
AFTER DELETE ON plan_psector_x_node
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_delete('node');

DROP TRIGGER IF EXISTS gw_trg_plan_psector_delete_connec ON plan_psector_x_connec;
CREATE TRIGGER gw_trg_plan_psector_delete_connec
AFTER DELETE ON plan_psector_x_connec
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_delete('connec');

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_arc ON plan_psector_x_arc;
CREATE TRIGGER gw_trg_plan_psector_x_arc
BEFORE INSERT OR UPDATE OF arc_id, state
ON plan_psector_x_arc FOR EACH ROW
EXECUTE PROCEDURE gw_trg_plan_psector_x_arc();

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_node ON plan_psector_x_node;
CREATE TRIGGER gw_trg_plan_psector_x_node
BEFORE INSERT OR UPDATE OF node_id, state
ON plan_psector_x_node FOR EACH ROW
EXECUTE PROCEDURE gw_trg_plan_psector_x_node();

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_connec ON plan_psector_x_connec;
CREATE TRIGGER gw_trg_plan_psector_x_connec
BEFORE INSERT OR UPDATE OF connec_id, state
ON plan_psector_x_connec FOR EACH ROW
EXECUTE PROCEDURE gw_trg_plan_psector_x_connec();