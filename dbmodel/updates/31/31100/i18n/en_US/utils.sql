/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO audit_cat_error VALUES (3002, 'The selected arc has state=0 (num. node,feature_id)=', 'Please, select another one In order to use mincut, we recommend to disable network state=0.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (3004, 'The selected arc has state=0 (num. node,feature_id)=', 'Please, select another one In order to use mincut, we recommend to disable network state=0.', 2, true, NULL);
INSERT INTO audit_cat_error VALUES (3006, 'There are one or more arc(s) with null nodes. Mincut is broken.','Please review your data',2, true, NULL);
INSERT INTO audit_cat_error VALUES (3008, 'The values of addfields are different for both arcs.','Review your data to make them equal.',2,TRUE,'utils');
