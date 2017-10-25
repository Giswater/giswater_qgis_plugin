--DROP
ALTER TABLE om_visit_parameter ALTER COLUMN parameter_type DROP NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN feature_type DROP NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN form_type DROP NOT NULL;

ALTER TABLE om_visit ALTER COLUMN visitcat_id DROP NOT NULL;
ALTER TABLE om_visit ALTER COLUMN expl_id DROP NOT NULL;

ALTER TABLE om_visit_event ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_event ALTER COLUMN parameter_id DROP NOT NULL;


ALTER TABLE om_visit_event_photo ALTER COLUMN visit_id DROP NOT NULL;

ALTER TABLE om_visit_x_node ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_x_node ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE om_visit_x_arc ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_x_arc ALTER COLUMN arc_id DROP NOT NULL;

ALTER TABLE om_visit_x_connec ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_x_connec ALTER COLUMN connec_id DROP NOT NULL;

--SET
ALTER TABLE om_visit_parameter ALTER COLUMN parameter_type SET NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN feature_type SET NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN form_type SET NOT NULL;

ALTER TABLE om_visit ALTER COLUMN visitcat_id SET NOT NULL;
ALTER TABLE om_visit ALTER COLUMN expl_id SET NOT NULL;

ALTER TABLE om_visit_event ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_event ALTER COLUMN parameter_id SET NOT NULL;


ALTER TABLE om_visit_event_photo ALTER COLUMN visit_id SET NOT NULL;

ALTER TABLE om_visit_x_node ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_x_node ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE om_visit_x_arc ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_x_arc ALTER COLUMN arc_id SET NOT NULL;

ALTER TABLE om_visit_x_connec ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_x_connec ALTER COLUMN connec_id SET NOT NULL;