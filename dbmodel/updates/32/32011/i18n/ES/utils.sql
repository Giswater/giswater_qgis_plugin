/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO om_visit_cat_status VALUES (1, 'En curso', NULL);
INSERT INTO om_visit_cat_status VALUES (2, 'Stand by', NULL);
INSERT INTO om_visit_cat_status VALUES (3, 'Cancelada', NULL);
INSERT INTO om_visit_cat_status VALUES (4, 'Cerrada', NULL);

INSERT INTO om_visit_filetype_x_extension VALUES ('Documento', 'doc');
INSERT INTO om_visit_filetype_x_extension VALUES ('Pdf', 'pdf');
INSERT INTO om_visit_filetype_x_extension VALUES ('Imagen', 'jpg');
INSERT INTO om_visit_filetype_x_extension VALUES ('Imagen', 'png');
INSERT INTO om_visit_filetype_x_extension VALUES ('Video', 'mp4');




