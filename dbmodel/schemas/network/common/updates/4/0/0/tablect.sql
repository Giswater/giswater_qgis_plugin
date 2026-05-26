/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 04/12/2024
ALTER TABLE doc_x_psector ADD CONSTRAINT doc_x_psector_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_workcat ADD CONSTRAINT doc_x_workcat_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_visit ADD CONSTRAINT doc_x_visit_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_node ADD CONSTRAINT doc_x_node_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_arc ADD CONSTRAINT doc_x_arc_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE doc_x_connec ADD CONSTRAINT doc_x_connec_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES doc(id) ON UPDATE CASCADE ON DELETE CASCADE;

DROP RULE IF EXISTS insert_plan_psector_x_arc ON arc;
DROP RULE IF EXISTS insert_plan_psector_x_node ON node;

-- 19/11/24
UPDATE rpt_cat_result SET iscorporate = false WHERE iscorporate IS NULL;

ALTER TABLE rpt_cat_result ALTER COLUMN iscorporate SET NOT NULL;
ALTER TABLE rpt_cat_result ALTER COLUMN iscorporate SET DEFAULT false;