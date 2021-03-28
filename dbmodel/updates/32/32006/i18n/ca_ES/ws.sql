/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO cat_feature VALUES ('ESCOMESA_FICTICIA', 'WJOIN', 'CONNEC');
INSERT INTO connec_type VALUES ('ESCOMESA_FICTICIA', 'WJOIN', 'man_wjoin',  TRUE, TRUE, 'Connec fictici');

INSERT INTO anl_mincut_cat_state VALUES (3, 'Cancel.lat', NULL) ON CONFLICT (id) DO UPDATE SET name='Cancel.lat';



