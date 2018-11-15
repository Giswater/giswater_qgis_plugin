/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

--DROP
ALTER TABLE doc ALTER COLUMN "path" DROP NOT NULL;
ALTER TABLE doc ALTER COLUMN "doc_type" DROP NOT NULL;

ALTER TABLE doc_x_node ALTER COLUMN doc_id DROP NOT NULL;
ALTER TABLE doc_x_node ALTER COLUMN node_id DROP NOT NULL;

ALTER TABLE doc_x_arc ALTER COLUMN doc_id DROP NOT NULL;
ALTER TABLE doc_x_arc ALTER COLUMN arc_id DROP NOT NULL;

ALTER TABLE doc_x_connec ALTER COLUMN doc_id DROP NOT NULL;
ALTER TABLE doc_x_connec ALTER COLUMN connec_id DROP NOT NULL;

ALTER TABLE doc_x_visit ALTER COLUMN doc_id DROP NOT NULL;
ALTER TABLE doc_x_visit ALTER COLUMN visit_id DROP NOT NULL;

--CREATE
ALTER TABLE doc ALTER COLUMN "path" SET NOT NULL;
ALTER TABLE doc ALTER COLUMN "doc_type" SET NOT NULL;

ALTER TABLE doc_x_node ALTER COLUMN doc_id SET NOT NULL;
ALTER TABLE doc_x_node ALTER COLUMN node_id SET NOT NULL;

ALTER TABLE doc_x_arc ALTER COLUMN doc_id SET NOT NULL;
ALTER TABLE doc_x_arc ALTER COLUMN arc_id SET NOT NULL;

ALTER TABLE doc_x_connec ALTER COLUMN doc_id SET NOT NULL;
ALTER TABLE doc_x_connec ALTER COLUMN connec_id SET NOT NULL;

ALTER TABLE doc_x_visit ALTER COLUMN doc_id SET NOT NULL;
ALTER TABLE doc_x_visit ALTER COLUMN visit_id SET NOT NULL;


