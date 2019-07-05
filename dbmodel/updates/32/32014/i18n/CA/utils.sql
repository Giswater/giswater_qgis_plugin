/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO plan_typevalue VALUES ('psector_status', 0, 'EXECUTAT', 'Psector fet');
INSERT INTO plan_typevalue VALUES ('psector_status', 1, 'EN CURS', 'Psector en curs');
INSERT INTO plan_typevalue VALUES ('psector_status', 2, 'PLANIFICAT', 'Psector planificat');
INSERT INTO plan_typevalue VALUES ('psector_status', 3, 'CANCEL.LAT', 'Psector cancel.lat');

INSERT INTO om_typevalue VALUES ('visit_cat_status', 1, 'Iniciada');
INSERT INTO om_typevalue VALUES ('visit_cat_status', 2, 'Stand-by');
INSERT INTO om_typevalue VALUES ('visit_cat_status', 3, 'Cancel·lada');
INSERT INTO om_typevalue VALUES ('visit_cat_status', 4, 'Finalitzada');