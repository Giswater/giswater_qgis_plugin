/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO om_visit_parameter_form_type VALUES ('event_standard');
INSERT INTO om_visit_parameter_form_type VALUES ('event_ud_arc_rehabit');
INSERT INTO om_visit_parameter_form_type VALUES ('event_ud_arc_standard');


INSERT INTO om_visit_parameter_cat_action VALUES (1, 'Complementary events');
INSERT INTO om_visit_parameter_cat_action VALUES (2, 'Incompatible events');
INSERT INTO om_visit_parameter_cat_action VALUES (3, 'Redundant events');


