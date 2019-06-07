/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO cat_feature VALUES ('VCONNEC', 'CONNEC', 'CONNEC') ON CONFLICT (id) DO NOTHING;
INSERT INTO cat_feature VALUES ('VGULLY', 'GULLY', 'GULLY') ON CONFLICT (id) DO NOTHING;
INSERT INTO connec_type VALUES ('VCONNEC', 'CONNEC', 'man_connec', TRUE, TRUE) ON CONFLICT (id) DO NOTHING;
INSERT INTO gully_type VALUES ('VGULLY', 'GULLY', 'man_gully', TRUE, TRUE) ON CONFLICT (id) DO NOTHING;
