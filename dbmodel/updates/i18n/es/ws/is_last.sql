/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO node_type VALUES ('ARQUETA SIMPLE', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ARQUETA CONTROL', 'REGISTER', 'VALVE', 'man_register', 'inp_valve', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ARQUETA BYPASS', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ARQUETA VÁLVULAS', 'REGISTER', 'JUNCTION', 'man_register', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('ACOMETIDA', 'NETWJOIN', 'JUNCTION', 'man_netwjoin', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('VASO EXPANSIÓN', 'EXPANSIONTANK', 'JUNCTION', 'man_expansiontank', 'inp_junction', 'om_visit_x_node');
INSERT INTO node_type VALUES ('JUNTA DILATACIÓN', 'FLEXUNION', 'JUNCTION', 'man_flexunion', 'inp_junction', 'om_visit_x_node');