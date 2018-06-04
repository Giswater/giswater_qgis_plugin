/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


--SET LC_MESSAGES TO 'en_US.UTF-8';

SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO anl_mincut_cat_cause VALUES ('Accidental', NULL);
INSERT INTO anl_mincut_cat_cause VALUES ('Planificado', NULL);


INSERT INTO anl_mincut_cat_class VALUES (1, 'Cierre de red', NULL);
INSERT INTO anl_mincut_cat_class VALUES (2, 'Cierre de acometidas', NULL);
INSERT INTO anl_mincut_cat_class VALUES (3, 'Cierre de abonados', NULL);


INSERT INTO anl_mincut_cat_state VALUES (1, 'En proceso', NULL);
INSERT INTO anl_mincut_cat_state VALUES (2, 'Finalizado', NULL);
INSERT INTO anl_mincut_cat_state VALUES (0, 'Planificado', NULL);


INSERT INTO anl_mincut_cat_type VALUES ('Test', true);
INSERT INTO anl_mincut_cat_type VALUES ('Demo', true);
INSERT INTO anl_mincut_cat_type VALUES ('Real', false);

