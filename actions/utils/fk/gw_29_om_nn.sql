/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE om_visit_parameter ALTER COLUMN parameter_type DROP NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN feature_type DROP NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN form_type DROP NOT NULL;

ALTER TABLE om_visit ALTER COLUMN visitcat_id DROP NOT NULL;

ALTER TABLE om_visit_event ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_event ALTER COLUMN parameter_id DROP NOT NULL;


ALTER TABLE om_visit_event_photo ALTER COLUMN visit_id DROP NOT NULL;

ALTER TABLE om_visit_x_node ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_x_node ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE om_visit_x_arc ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_x_arc ALTER COLUMN arc_id DROP NOT NULL;

ALTER TABLE om_visit_x_connec ALTER COLUMN visit_id DROP NOT NULL;
ALTER TABLE om_visit_x_connec ALTER COLUMN connec_id DROP NOT NULL;

ALTER TABLE om_psector ALTER COLUMN psector_type DROP NOT NULL;
ALTER TABLE om_psector ALTER COLUMN result_id DROP NOT NULL;

ALTER TABLE om_rec_result_node ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN nodecat_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN node_type DROP NOT NULL;

ALTER TABLE om_rec_result_arc ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN arccat_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN arc_type DROP NOT NULL;


ALTER TABLE om_rec_result_node ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN node_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN nodecat_id DROP NOT NULL;
ALTER TABLE om_rec_result_node ALTER COLUMN node_type DROP NOT NULL;

ALTER TABLE om_rec_result_arc ALTER COLUMN result_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN arc_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN sector_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN "state" DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN arccat_id DROP NOT NULL;
ALTER TABLE om_rec_result_arc ALTER COLUMN arc_type DROP NOT NULL;




--SET
ALTER TABLE om_visit_parameter ALTER COLUMN parameter_type SET NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN feature_type SET NOT NULL;
ALTER TABLE om_visit_parameter ALTER COLUMN form_type SET NOT NULL;

ALTER TABLE om_visit ALTER COLUMN visitcat_id SET NOT NULL;

ALTER TABLE om_visit_event ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_event ALTER COLUMN parameter_id SET NOT NULL;


ALTER TABLE om_visit_event_photo ALTER COLUMN visit_id SET NOT NULL;

ALTER TABLE om_visit_x_node ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_x_node ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE om_visit_x_arc ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_x_arc ALTER COLUMN arc_id SET NOT NULL;

ALTER TABLE om_visit_x_connec ALTER COLUMN visit_id SET NOT NULL;
ALTER TABLE om_visit_x_connec ALTER COLUMN connec_id SET NOT NULL;

ALTER TABLE om_psector ALTER COLUMN psector_type SET NOT NULL;
ALTER TABLE om_psector ALTER COLUMN result_id SET NOT NULL;

ALTER TABLE om_reh_result_node ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN nodecat_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN node_type SET NOT NULL;

ALTER TABLE om_reh_result_arc ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN arccat_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN arc_type SET NOT NULL;


ALTER TABLE om_reh_result_node ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN node_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN nodecat_id SET NOT NULL;
ALTER TABLE om_reh_result_node ALTER COLUMN node_type SET NOT NULL;

ALTER TABLE om_reh_result_arc ALTER COLUMN result_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN arc_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN sector_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN "state" SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN arccat_id SET NOT NULL;
ALTER TABLE om_reh_result_arc ALTER COLUMN arc_type SET NOT NULL;