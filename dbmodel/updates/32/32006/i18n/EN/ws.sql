/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO cat_feature VALUES ('VCONNEC', 'WJOIN', 'CONNEC') ON CONFLICT (id) DO NOTHING;
INSERT INTO connec_type VALUES ('VCONNEC', 'WJOIN', 'man_wjoin', TRUE, TRUE, 'Virtual connec') ON CONFLICT (id) DO NOTHING;

INSERT INTO anl_mincut_cat_state VALUES (3, 'Canceled', NULL) ON CONFLICT (id) DO UPDATE SET name='Canceled';


