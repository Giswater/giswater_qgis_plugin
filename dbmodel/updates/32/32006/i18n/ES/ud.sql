/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO cat_feature VALUES ('ACOMETIDA_FICTICIA', 'CONNEC', 'CONNEC');
INSERT INTO cat_feature VALUES ('SUMIDERO_FICTICIO', 'GULLY', 'GULLY');

INSERT INTO connec_type VALUES ('ACOMETIDA_FICTICIA', 'CONNEC', 'man_connec', TRUE, TRUE);
INSERT INTO gully_type VALUES ('SUMIDERO_FICTICIO', 'GULLY', 'man_gully', TRUE, TRUE);
