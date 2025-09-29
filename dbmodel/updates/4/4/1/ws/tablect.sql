/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE IF EXISTS plan_psector_x_connec DROP CONSTRAINT IF EXISTS plan_psector_x_connec_link_id_fkey;
ALTER TABLE IF EXISTS plan_psector_x_connec ADD CONSTRAINT plan_psector_x_connec_link_id_fkey FOREIGN KEY (link_id) REFERENCES link(link_id) ON UPDATE CASCADE ON DELETE SET NULL;
