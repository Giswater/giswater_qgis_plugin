/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO om_visit_cat_status VALUES (1, 'Started', NULL);
INSERT INTO om_visit_cat_status VALUES (2, 'Stand-by', NULL);
INSERT INTO om_visit_cat_status VALUES (3, 'Canceled', NULL);
INSERT INTO om_visit_cat_status VALUES (4, 'Finished', NULL);

INSERT INTO om_visit_filetype_x_extension VALUES ('Document', 'doc')
ON CONFLICT (filetype, fextension) DO NOTHING;
INSERT INTO om_visit_filetype_x_extension VALUES ('Pdf', 'pdf')
ON CONFLICT (filetype, fextension) DO NOTHING;
INSERT INTO om_visit_filetype_x_extension VALUES ('Image', 'jpg')
ON CONFLICT (filetype, fextension) DO NOTHING;
INSERT INTO om_visit_filetype_x_extension VALUES ('Image', 'png')
ON CONFLICT (filetype, fextension) DO NOTHING;
INSERT INTO om_visit_filetype_x_extension VALUES ('Video', 'mp4')
ON CONFLICT (filetype, fextension) DO NOTHING;







