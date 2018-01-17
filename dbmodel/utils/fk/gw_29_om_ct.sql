/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP CHECK

ALTER TABLE "om_visit_parameter_form_type" DROP CONSTRAINT IF EXISTS "om_visit_parameter_form_type_check";


-- ADD CHECK

ALTER TABLE SCHEMA_NAME.om_visit_parameter_form_type ADD CONSTRAINT om_visit_parameter_form_type_check CHECK (id IN ('event_standard','event_ud_arc_rehabit','event_ud_arc_standard'));