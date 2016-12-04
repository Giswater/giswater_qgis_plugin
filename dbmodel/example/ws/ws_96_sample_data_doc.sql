/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- INSERT INTO cat_tag VALUES ('NO TAG', NULL);
INSERT INTO cat_tag VALUES ('PRIORITY NORMAL', NULL);
INSERT INTO cat_tag VALUES ('PRIORITY HIGH', NULL);


INSERT INTO doc VALUES (2, 'INCIDENT', 'c:/docs/incident.pdf', 'Incident from public works', 'PRIORITY HIGH', '2016-05-31 14:20:25', 'postgres');
INSERT INTO doc VALUES (3, 'OTHER', 'c:/docs/other.pdf', 'Other', 'PRIORITY HIGH', '2016-05-31 14:21:03', 'postgres');
INSERT INTO doc VALUES (1, 'AS_BUILT', 'c:/docs/doc.pdf', 'As built documentation', 'PRIORITY HIGH', '2016-05-31 14:19:39', 'postgres');
INSERT INTO doc VALUES (4, 'PICTURE', 'c:/docs/demo_picture.png', 'Demo picture', 'PRIORITY HIGH', '2016-05-31 14:19:39', 'postgres');


