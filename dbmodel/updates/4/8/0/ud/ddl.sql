/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 02/02/2026
DROP VIEW IF EXISTS v_ui_doc;
DROP VIEW IF EXISTS v_ui_doc_x_psector;
DROP VIEW IF EXISTS v_ui_doc_x_visit;
DROP VIEW IF EXISTS v_ui_doc_x_workcat;
DROP VIEW IF EXISTS v_ui_doc_x_node;
DROP VIEW IF EXISTS v_ui_doc_x_arc;
DROP VIEW IF EXISTS v_ui_doc_x_connec;
DROP VIEW IF EXISTS v_ui_doc_x_gully;
DROP VIEW IF EXISTS v_ui_doc_x_link;
DROP VIEW IF EXISTS v_ui_doc_x_element;
DROP VIEW IF EXISTS v_ui_om_visit_x_doc;
ALTER TABLE doc ADD COLUMN code varchar(30);
UPDATE doc SET code = id;
ALTER SEQUENCE doc_seq RESTART WITH 1;
UPDATE doc SET id = nextval('doc_seq'::regclass); 



ALTER TABLE doc_x_link DROP CONSTRAINT doc_x_link_doc_id_fkey;
ALTER TABLE doc_x_psector DROP CONSTRAINT doc_x_psector_doc_id_fkey;
ALTER TABLE doc_x_workcat DROP CONSTRAINT doc_x_workcat_doc_id_fkey;
ALTER TABLE doc_x_visit DROP CONSTRAINT doc_x_visit_doc_id_fkey;
ALTER TABLE doc_x_node DROP CONSTRAINT doc_x_node_doc_id_fkey;
ALTER TABLE doc_x_arc DROP CONSTRAINT doc_x_arc_doc_id_fkey;
ALTER TABLE doc_x_connec DROP CONSTRAINT doc_x_connec_doc_id_fkey;
ALTER TABLE doc_x_gully DROP CONSTRAINT doc_x_gully_doc_id_fkey;
ALTER TABLE doc_x_element DROP CONSTRAINT doc_x_element_fkey_doc_id;



ALTER TABLE doc_x_link ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_psector ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_workcat ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_visit ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_node ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_arc ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_connec ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_gully ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc_x_element ALTER COLUMN doc_id TYPE int4 USING doc_id::int4;
ALTER TABLE doc ALTER COLUMN id TYPE int4 USING id::int4;
