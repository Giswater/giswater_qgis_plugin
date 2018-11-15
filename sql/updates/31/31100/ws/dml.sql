/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

--01/06/2018
-----------------------
INSERT INTO audit_cat_table VALUES ('anl_mincut_result_cat', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, 'anl_mincut_result_cat_seq', 'id');

--05/06/2018
-----------------------
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_result_conflict_arc', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_result_conflict_valve', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_planified_arc', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_anl_mincut_planified_valve', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, NULL, NULL);
 














