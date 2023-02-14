/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2023/02/13
ALTER TABLE IF EXISTS node DROP CONSTRAINT IF EXISTS node_parent_id_fkey;

ALTER TABLE IF EXISTS node
    ADD CONSTRAINT node_parent_id_fkey FOREIGN KEY (parent_id)
    REFERENCES node (node_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;

ALTER TABLE IF EXISTS arc DROP CONSTRAINT IF EXISTS arc_parent_id_fkey;

ALTER TABLE IF EXISTS arc
    ADD CONSTRAINT arc_parent_id_fkey FOREIGN KEY (parent_id)
    REFERENCES node (node_id) MATCH SIMPLE
    ON UPDATE CASCADE
    ON DELETE RESTRICT;
