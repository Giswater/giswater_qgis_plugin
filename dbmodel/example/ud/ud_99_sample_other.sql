/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


SELECT gw_fct_plan_result( 'Starting prices', 1, 1, 'Demo prices for reconstruction');


UPDATE plan_arc_x_pavement SET pavcat_id = 'Asphalt';


UPDATE plan_psector_x_arc SET psector_id = 2 WHERE arc_id = 'A252';
UPDATE plan_psector_x_arc SET psector_id = 2 WHERE arc_id = 'A251';
INSERT INTO plan_psector_x_arc VALUES (8, '20608', 2, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (9, 'A157', 2, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (10, 'A177', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (11, 'A178', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (12, 'A239', 1, 0, false, NULL);
INSERT INTO plan_psector_x_arc VALUES (13, 'A179', 1, 0, false, NULL);


INSERT INTO plan_psector_x_node VALUES (5, 'N91', 1, 0, false, NULL);
INSERT INTO plan_psector_x_node VALUES (6, 'N92', 1, 0, false, NULL);
INSERT INTO plan_psector_x_node VALUES (7, 'N94', 1, 0, false, NULL);