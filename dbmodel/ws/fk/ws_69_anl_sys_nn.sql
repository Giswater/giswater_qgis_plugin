--DROP
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN polygon_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_node ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_node ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_arc ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_arc ALTER COLUMN arc_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_connec ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_connec ALTER COLUMN connec_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN hydrometer_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_valve ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_valve ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE anl_mincut_result_selector ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE anl_mincut_result_selector ALTER COLUMN cur_user DROP NOT NULL;


--SET
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_polygon ALTER COLUMN polygon_id SET NOT NULL;

ALTER TABLE anl_mincut_result_node ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_node ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE anl_mincut_result_arc ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_arc ALTER COLUMN arc_id SET NOT NULL;

ALTER TABLE anl_mincut_result_connec ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_connec ALTER COLUMN connec_id SET NOT NULL;

ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_hydrometer ALTER COLUMN hydrometer_id SET NOT NULL;

ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_valve_unaccess ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE anl_mincut_result_valve ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_valve ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE anl_mincut_result_selector ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE anl_mincut_result_selector ALTER COLUMN cur_user SET NOT NULL;