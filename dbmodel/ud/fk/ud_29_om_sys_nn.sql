--DROP
ALTER TABLE om_visit_x_gully ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_x_gully ALTER COLUMN gully_id DROP NOT NULL;

--SET
ALTER TABLE om_visit_x_gully ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_x_gully ALTER COLUMN gully_id SET NOT NULL;

