/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE "om_visit_parameter" DROP CONSTRAINT IF EXISTS "om_visit_parameter_parameter_type_fkey";
ALTER TABLE "om_visit_parameter" DROP CONSTRAINT IF EXISTS "om_visit_parameter_criticity_fkey";
ALTER TABLE "om_visit_parameter" DROP CONSTRAINT IF EXISTS "om_visit_parameter_feature_type_fkey";
ALTER TABLE "om_visit_parameter" DROP CONSTRAINT IF EXISTS "om_visit_parameter_form_type_fkey";

ALTER TABLE "om_visit" DROP CONSTRAINT IF EXISTS "om_visit_om_visit_cat_id_fkey";
ALTER TABLE "om_visit" DROP CONSTRAINT IF EXISTS "om_visit_expl_id_fkey";

ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_visit_id_fkey";
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_parameter_id_fkey";
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_position_id_fkey";

ALTER TABLE "om_visit_event_photo" DROP CONSTRAINT IF EXISTS "om_visit_event_foto_event_id_fkey";
ALTER TABLE "om_visit_event_photo" DROP CONSTRAINT IF EXISTS "om_visit_event_foto_visit_id_fkey";


ALTER TABLE "om_visit_x_node" DROP CONSTRAINT IF EXISTS "om_visit_x_node_visit_id_fkey";
ALTER TABLE "om_visit_x_node" DROP CONSTRAINT IF EXISTS "om_visit_x_node_node_id_fkey";

ALTER TABLE "om_visit_x_arc" DROP CONSTRAINT IF EXISTS "om_visit_x_arc_visit_id_fkey";
ALTER TABLE "om_visit_x_arc" DROP CONSTRAINT IF EXISTS "om_visit_x_arc_arc_id_fkey";

ALTER TABLE "om_visit_x_connec" DROP CONSTRAINT IF EXISTS "om_visit_x_connec_visit_id_fkey";
ALTER TABLE "om_visit_x_connec" DROP CONSTRAINT IF EXISTS "om_visit_x_connec_connec_id_fkey";

ALTER TABLE "om_psector"  DROP CONSTRAINT IF EXISTS "om_psector_psector_type_fkey";
ALTER TABLE "om_psector" DROP CONSTRAINT IF EXISTS "om_psector_expl_id_fkey";
ALTER TABLE "om_psector" DROP CONSTRAINT IF EXISTS "om_psector_sector_id_fkey";
ALTER TABLE "om_psector" DROP CONSTRAINT IF EXISTS "om_psector_priority_fkey";
ALTER TABLE "om_psector" DROP CONSTRAINT IF EXISTS "om_psector_result_id_fkey";

ALTER TABLE "om_psector_selector" DROP CONSTRAINT IF EXISTS "om_psector_selector_psector_id_fkey";

ALTER TABLE "om_psector_x_arc" DROP CONSTRAINT IF EXISTS "om_psector_x_arc_arc_id_fkey";
ALTER TABLE "om_psector_x_arc" DROP CONSTRAINT IF EXISTS "om_psector_x_arc_psector_id_fkey";

ALTER TABLE "om_psector_x_node" DROP CONSTRAINT IF EXISTS "om_psector_x_node_node_id_fkey";
ALTER TABLE "om_psector_x_node" DROP CONSTRAINT IF EXISTS "om_psector_x_node_psector_id_fkey";

ALTER TABLE "om_psector_x_other" DROP CONSTRAINT IF EXISTS "om_psector_x_other_price_id_fkey";
ALTER TABLE "om_psector_x_other" DROP CONSTRAINT IF EXISTS "om_psector_x_other_psector_id_fkey";

ALTER TABLE "om_rec_result_node"  DROP CONSTRAINT IF EXISTS "om_rec_result_node_result_id_fkey";

ALTER TABLE "om_rec_result_arc" DROP CONSTRAINT IF EXISTS "om_rec_result_arc_result_id_fkey";

ALTER TABLE "om_reh_result_node"  DROP CONSTRAINT IF EXISTS "om_reh_result_node_result_id_fkey";

ALTER TABLE "om_reh_result_arc" DROP CONSTRAINT IF EXISTS "om_reh_result_arc_result_id_fkey";

ALTER TABLE "om_visit_parameter_x_parameter" DROP CONSTRAINT IF EXISTS "om_visit_parameter_action_type_fkey";



--ADD
ALTER TABLE "om_visit_parameter" ADD CONSTRAINT "om_visit_parameter_parameter_type_fkey" FOREIGN KEY ("parameter_type") REFERENCES "om_visit_parameter_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_parameter" ADD CONSTRAINT "om_visit_parameter_criticity_fkey" FOREIGN KEY ("criticity") REFERENCES "om_visit_value_criticity" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "om_visit_parameter" ADD CONSTRAINT "om_visit_parameter_feature_type_fkey" FOREIGN KEY ("feature_type") REFERENCES "sys_feature_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "om_visit_parameter" ADD CONSTRAINT "om_visit_parameter_form_type_fkey" FOREIGN KEY ("form_type") REFERENCES "om_visit_parameter_form_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit" ADD CONSTRAINT "om_visit_om_visit_cat_id_fkey" FOREIGN KEY ("visitcat_id") REFERENCES "om_visit_cat" ("id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE "om_visit" ADD CONSTRAINT "om_visit_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "om_visit_event" ADD CONSTRAINT "om_visit_event_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_event" ADD CONSTRAINT "om_visit_event_parameter_id_fkey" FOREIGN KEY ("parameter_id") REFERENCES "om_visit_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_event"  ADD CONSTRAINT "om_visit_event_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "node" ("node_id") ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "om_visit_event_photo" ADD CONSTRAINT "om_visit_event_foto_event_id_fkey" FOREIGN KEY ("event_id") REFERENCES "om_visit_event" ("id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE "om_visit_event_photo" ADD CONSTRAINT "om_visit_event_foto_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") MATCH SIMPLE ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE "om_visit_x_node" ADD CONSTRAINT "om_visit_x_node_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_node" ADD CONSTRAINT "om_visit_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_arc" ADD CONSTRAINT "om_visit_x_arc_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_arc" ADD CONSTRAINT "om_visit_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_connec" ADD CONSTRAINT "om_visit_x_connec_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_connec" ADD CONSTRAINT "om_visit_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_psector"  ADD CONSTRAINT "om_psector_psector_type_fkey" FOREIGN KEY ("psector_type") REFERENCES "om_psector_cat_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector"  ADD CONSTRAINT "om_psector_expl_id_fkey" FOREIGN KEY ("expl_id") REFERENCES "exploitation" ("expl_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector" ADD CONSTRAINT "om_psector_sector_id_fkey" FOREIGN KEY ("sector_id") REFERENCES "sector" ("sector_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector" ADD CONSTRAINT "om_psector_priority_fkey" FOREIGN KEY ("priority") REFERENCES "value_priority" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector" ADD CONSTRAINT "om_psector_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "om_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_psector_selector" ADD CONSTRAINT "om_psector_selector_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "om_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_psector_x_arc" ADD CONSTRAINT "om_psector_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector_x_arc" ADD CONSTRAINT "om_psector_x_arc_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "om_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_psector_x_node" ADD CONSTRAINT "om_psector_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector_x_node" ADD CONSTRAINT "om_psector_x_node_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "om_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_psector_x_other" ADD CONSTRAINT "om_psector_x_other_price_id_fkey" FOREIGN KEY ("price_id") REFERENCES "price_compost" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_psector_x_other" ADD CONSTRAINT "om_psector_x_other_psector_id_fkey" FOREIGN KEY ("psector_id") REFERENCES "om_psector" ("psector_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_rec_result_node" ADD CONSTRAINT "om_rec_result_node_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "om_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_rec_result_arc" ADD CONSTRAINT "om_rec_result_arc_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "om_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_reh_result_node"  ADD CONSTRAINT "om_reh_result_node_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "om_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_reh_result_arc" ADD CONSTRAINT "om_reh_result_arc_result_id_fkey" FOREIGN KEY ("result_id") REFERENCES "om_result_cat" ("result_id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_visit_parameter_x_parameter" ADD CONSTRAINT "om_visit_parameter_action_type_fkey" FOREIGN KEY ("action_type") REFERENCES "om_visit_parameter_cat_action" ("id") ON DELETE CASCADE ON UPDATE CASCADE;










