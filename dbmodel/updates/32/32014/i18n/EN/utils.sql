/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO plan_typevalue VALUES ('psector_status', 0, 'EXECUTED', 'Psector done');
INSERT INTO plan_typevalue VALUES ('psector_status', 1, 'ONGOING', 'Psector on course');
INSERT INTO plan_typevalue VALUES ('psector_status', 2, 'PLANNED', 'Psector planned');
INSERT INTO plan_typevalue VALUES ('psector_status', 3, 'CANCELED', 'Psector canceled');

INSERT INTO om_typevalue VALUES ('visit_cat_status', 1, 'Started');
INSERT INTO om_typevalue VALUES ('visit_cat_status', 2, 'Stand-by');
INSERT INTO om_typevalue VALUES ('visit_cat_status', 3, 'Canceled');
INSERT INTO om_typevalue VALUES ('visit_cat_status', 4, 'Finished');