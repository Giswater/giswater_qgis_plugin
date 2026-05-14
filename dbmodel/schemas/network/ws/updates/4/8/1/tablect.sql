/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 25/03/2026
CREATE INDEX IF NOT EXISTS anl_arc_arccat_id ON anl_arc USING btree (arccat_id);
CREATE INDEX IF NOT EXISTS anl_arc_state ON anl_arc USING btree (state);
CREATE INDEX IF NOT EXISTS anl_arc_expl_id ON anl_arc USING btree (expl_id);
CREATE INDEX IF NOT EXISTS anl_arc_fid ON anl_arc USING btree (fid);
CREATE INDEX IF NOT EXISTS anl_arc_result_id ON anl_arc USING btree (result_id);
CREATE INDEX IF NOT EXISTS anl_arc_node_1 ON anl_arc USING btree (node_1);
CREATE INDEX IF NOT EXISTS anl_arc_node_2 ON anl_arc USING btree (node_2);
CREATE INDEX IF NOT EXISTS anl_arc_dma_id ON anl_arc USING btree (dma_id);
CREATE INDEX IF NOT EXISTS anl_arc_preszone_id ON anl_arc USING btree (presszone_id);
CREATE INDEX IF NOT EXISTS anl_arc_dqa_id ON anl_arc USING btree (dqa_id);
CREATE INDEX IF NOT EXISTS anl_arc_minsector_id ON anl_arc USING btree (minsector_id);
CREATE INDEX IF NOT EXISTS anl_arc_sector_id ON anl_arc USING btree (sector_id);
CREATE INDEX IF NOT EXISTS anl_arc_cur_user ON anl_arc USING btree (cur_user);
CREATE INDEX IF NOT EXISTS anl_arc_sys_type ON anl_arc USING btree (sys_type);

CREATE INDEX IF NOT EXISTS anl_node_nodecat_id ON anl_node USING btree (nodecat_id);
CREATE INDEX IF NOT EXISTS anl_node_state ON anl_node USING btree (state);
CREATE INDEX IF NOT EXISTS anl_node_expl_id ON anl_node USING btree (expl_id);
CREATE INDEX IF NOT EXISTS anl_node_fid ON anl_node USING btree (fid);
CREATE INDEX IF NOT EXISTS anl_node_result_id ON anl_node USING btree (result_id);
CREATE INDEX IF NOT EXISTS anl_node_arc_id ON anl_node USING btree (arc_id);
CREATE INDEX IF NOT EXISTS anl_node_dma_id ON anl_node USING btree (dma_id);
CREATE INDEX IF NOT EXISTS anl_node_preszone_id ON anl_node USING btree (presszone_id);
CREATE INDEX IF NOT EXISTS anl_node_dqa_id ON anl_node USING btree (dqa_id);
CREATE INDEX IF NOT EXISTS anl_node_minsector_id ON anl_node USING btree (minsector_id);
CREATE INDEX IF NOT EXISTS anl_node_sector_id ON anl_node USING btree (sector_id);
CREATE INDEX IF NOT EXISTS anl_node_cur_user ON anl_node USING btree (cur_user);

CREATE INDEX IF NOT EXISTS anl_connec_conneccat_id ON anl_connec USING btree (conneccat_id);
CREATE INDEX IF NOT EXISTS anl_connec_state ON anl_connec USING btree (state);
CREATE INDEX IF NOT EXISTS anl_connec_expl_id ON anl_connec USING btree (expl_id);
CREATE INDEX IF NOT EXISTS anl_connec_fid ON anl_connec USING btree (fid);
CREATE INDEX IF NOT EXISTS anl_connec_result_id ON anl_connec USING btree (result_id);
CREATE INDEX IF NOT EXISTS anl_connec_dma_id ON anl_connec USING btree (dma_id);
CREATE INDEX IF NOT EXISTS anl_connec_cur_user ON anl_connec USING btree (cur_user);


CREATE INDEX IF NOT EXISTS anl_arc_x_node_state ON anl_arc_x_node USING btree (state);
CREATE INDEX IF NOT EXISTS anl_arc_x_node_expl_id ON anl_arc_x_node USING btree (expl_id);
CREATE INDEX IF NOT EXISTS anl_arc_x_node_cur_user ON anl_arc_x_node USING btree (cur_user);
CREATE INDEX IF NOT EXISTS anl_arc_x_node_fid ON anl_arc_x_node USING btree (fid);
CREATE INDEX IF NOT EXISTS anl_arc_x_node_result_id ON anl_arc_x_node USING btree (result_id);

