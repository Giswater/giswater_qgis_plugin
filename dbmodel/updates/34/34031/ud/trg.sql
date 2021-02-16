DROP TRIGGER IF EXISTS gw_trg_plan_psector_delete_gully ON plan_psector_x_gully;
CREATE TRIGGER gw_trg_plan_psector_delete_gully
AFTER DELETE ON plan_psector_x_gully
FOR EACH ROW EXECUTE PROCEDURE gw_trg_plan_psector_delete('gully');

DROP TRIGGER IF EXISTS gw_trg_plan_psector_x_gully ON plan_psector_x_gully;
CREATE TRIGGER gw_trg_plan_psector_x_gully
BEFORE INSERT OR UPDATE OF gully_id, state
ON plan_psector_x_gully FOR EACH ROW
EXECUTE PROCEDURE gw_trg_plan_psector_x_gully();


