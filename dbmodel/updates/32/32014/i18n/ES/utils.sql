/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO plan_typevalue VALUES ('psector_status', 0, 'EJECUTADO', 'Psector done');
INSERT INTO plan_typevalue VALUES ('psector_status', 1, 'EN CURSO', 'Psector on course');
INSERT INTO plan_typevalue VALUES ('psector_status', 2, 'PLANIFICADO', 'Psector planned');
INSERT INTO plan_typevalue VALUES ('psector_status', 3, 'CANCELADO', 'Psector canceled');