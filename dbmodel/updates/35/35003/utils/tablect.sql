/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2021/02/27
ALTER TABLE om_visit_x_node DROP CONSTRAINT IF EXISTS om_visit_x_node_unique;
ALTER TABLE om_visit_x_node ADD CONSTRAINT om_visit_x_node_unique UNIQUE(node_id, visit_id);

ALTER TABLE om_visit_x_arc DROP CONSTRAINT IF EXISTS om_visit_x_arc_unique;
ALTER TABLE om_visit_x_arc ADD CONSTRAINT om_visit_x_arc_unique UNIQUE(arc_id, visit_id);

ALTER TABLE om_visit_x_connec DROP CONSTRAINT IF EXISTS om_visit_x_connec_unique ;
ALTER TABLE om_visit_x_connec ADD CONSTRAINT om_visit_x_connec_unique UNIQUE(connec_id, visit_id);

ALTER TABLE config_form_list DROP CONSTRAINT IF EXISTS config_form_list_pkey;
ALTER TABLE config_form_list ADD CONSTRAINT config_form_list_pkey PRIMARY KEY (listname, device);

-- 2021/04/13
ALTER TABLE config_form_list ALTER COLUMN listtype DROP NOT NULL;
