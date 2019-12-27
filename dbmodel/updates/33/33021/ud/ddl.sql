/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2019/12/27
COMMENT ON TABLE node IS 'FIELD sys_elev IS NOT USED. Value is calculated on the fly on views';
COMMENT ON TABLE arc IS 'FIELD sys_length IS NOT USED. Value is calculated on the fly on views';
COMMENT ON TABLE arc IS 'FIELDS sys_y1, sys_y2 ARE IS NOT USED. Values are calculated on the fly on views';