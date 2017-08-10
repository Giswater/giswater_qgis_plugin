/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;
/*
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_visit_id_fkey";
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_parameter_id_fkey";
ALTER TABLE "om_visit_event" DROP CONSTRAINT IF EXISTS "om_visit_event_position_id_fkey";

ALTER TABLE "om_visit_parameter" DROP CONSTRAINT IF EXISTS "om_visit_parameter_parameter_type_fkey";

ALTER TABLE "om_visit_x_node" DROP CONSTRAINT IF EXISTS "om_visit_x_node_visit_id_fkey";
ALTER TABLE "om_visit_x_node" DROP CONSTRAINT IF EXISTS "om_visit_x_node_node_id_fkey";

ALTER TABLE "om_visit_x_arc" DROP CONSTRAINT IF EXISTS "om_visit_x_arc_visit_id_fkey";
ALTER TABLE "om_visit_x_arc" DROP CONSTRAINT IF EXISTS "om_visit_x_arc_arc_id_fkey";

ALTER TABLE "om_visit_x_connec" DROP CONSTRAINT IF EXISTS "om_visit_x_connec_visit_id_fkey";
ALTER TABLE "om_visit_x_connec" DROP CONSTRAINT IF EXISTS "om_visit_x_connec_connec_id_fkey";

ALTER TABLE om_visit DROP CONSTRAINT IF EXISTS "om_visit_expl_id_fkey";

ALTER TABLE om_visit DROP CONSTRAINT IF EXISTS "om_visit_om_visit_cat_id_fkey";

ALTER TABLE "om_visit_parameter_type" DROP CONSTRAINT IF EXISTS "om_visit_parameter_type_criticity_fkey";

ALTER TABLE "om_visit_parameter_type" DROP CONSTRAINT IF EXISTS "om_visit_parameter_type_context_fkey";

ALTER TABLE om_visit_event_photo DROP CONSTRAINT IF EXISTS "om_visit_event_foto_event_id_fkey";
ALTER TABLE om_visit_event_photo DROP CONSTRAINT IF EXISTS "om_visit_event_foto_visit_id_fkey";


ALTER TABLE "om_visit_parameter_type" DROP CONSTRAINT IF EXISTS "om_visit_parameter_type_criticity_fkey";

ALTER TABLE "om_visit_parameter_type" DROP CONSTRAINT IF EXISTS "om_visit_parameter_type_context_fkey";






ALTER TABLE "om_visit_event" ADD CONSTRAINT "om_visit_event_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_event" ADD CONSTRAINT "om_visit_event_parameter_id_fkey" FOREIGN KEY ("parameter_id") REFERENCES "om_visit_parameter" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_event" ADD CONSTRAINT "om_visit_event_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "om_visit_value_position" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_visit_parameter" ADD CONSTRAINT "om_visit_parameter_parameter_type_fkey" FOREIGN KEY ("parameter_type") REFERENCES "om_visit_parameter_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_node" ADD CONSTRAINT "om_visit_x_node_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_node" ADD CONSTRAINT "om_visit_x_node_node_id_fkey" FOREIGN KEY ("node_id") REFERENCES "node" ("node_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_arc" ADD CONSTRAINT "om_visit_x_arc_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_arc" ADD CONSTRAINT "om_visit_x_arc_arc_id_fkey" FOREIGN KEY ("arc_id") REFERENCES "arc" ("arc_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit_x_connec" ADD CONSTRAINT "om_visit_x_connec_visit_id_fkey" FOREIGN KEY ("visit_id") REFERENCES "om_visit" ("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "om_visit_x_connec" ADD CONSTRAINT "om_visit_x_connec_connec_id_fkey" FOREIGN KEY ("connec_id") REFERENCES "connec" ("connec_id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE om_visit  ADD CONSTRAINT om_visit_expl_id_fkey FOREIGN KEY (expl_id) REFERENCES exploitation (expl_id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE om_visit   ADD CONSTRAINT om_visit_om_visit_cat_id_fkey FOREIGN KEY (visitcat_id) REFERENCES om_visit_cat (id) MATCH SIMPLE ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE "om_visit_parameter_type" ADD CONSTRAINT "om_visit_parameter_type_criticity_fkey" FOREIGN KEY ("criticity") REFERENCES "om_visit_value_criticity" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit_parameter_type" ADD CONSTRAINT "om_visit_parameter_type_context_fkey" FOREIGN KEY ("context") REFERENCES "om_visit_value_context" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

 ALTER TABLE om_visit_event_photo ADD CONSTRAINT om_visit_event_foto_event_id_fkey FOREIGN KEY (event_id)      REFERENCES om_visit_event (id) MATCH SIMPLE      ON UPDATE CASCADE ON DELETE RESTRICT;
 ALTER TABLE om_visit_event_photo ADD CONSTRAINT om_visit_event_foto_visit_id_fkey FOREIGN KEY (visit_id)      REFERENCES om_visit (id) MATCH SIMPLE      ON UPDATE CASCADE ON DELETE RESTRICT;
 
 
ALTER TABLE "om_visit_parameter_type" ADD CONSTRAINT "om_visit_parameter_type_criticity_fkey" FOREIGN KEY ("criticity") REFERENCES "om_visit_value_criticity" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "om_visit_parameter_type" ADD CONSTRAINT "om_visit_parameter_type_context_fkey" FOREIGN KEY ("context") REFERENCES "om_visit_value_context" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

*/
