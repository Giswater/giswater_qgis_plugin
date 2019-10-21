/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO plan_typevalue VALUES ('psector_status', 0, 'EXECUTED', 'Psector done') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO plan_typevalue VALUES ('psector_status', 1, 'ONGOING', 'Psector on course') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO plan_typevalue VALUES ('psector_status', 2, 'PLANNED', 'Psector planned') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO plan_typevalue VALUES ('psector_status', 3, 'CANCELED', 'Psector canceled') ON CONFLICT (typevalue, id) DO NOTHING;

INSERT INTO om_typevalue VALUES ('visit_cat_status', 1, 'Started') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('visit_cat_status', 2, 'Stand-by') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('visit_cat_status', 3, 'Canceled') ON CONFLICT (typevalue, id) DO NOTHING;
INSERT INTO om_typevalue VALUES ('visit_cat_status', 4, 'Finished') ON CONFLICT (typevalue, id) DO NOTHING;