/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/12/23
COMMENT ON TABLE sector IS 'FIELD nodeparent IS DEPRECATED';
COMMENT ON TABLE dma IS 'FIELD nodeparent IS DEPRECATED';
COMMENT ON TABLE dqa IS 'FIELD nodeparent IS DEPRECATED';
COMMENT ON TABLE cat_presszone IS 'FIELD nodeparent IS DEPRECATED';
COMMENT ON TABLE anl_mincut_x_exploitation IS 'FIELD toarc IS DEPRECATED';

-- 2019/12/24
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_node", "column":"ischange", "dataType":"boolean","isUtils":"False"}}$$);
