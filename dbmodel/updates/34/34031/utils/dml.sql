/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2021/02/11
INSERT INTO config_param_system VALUES ('edit_connect_autoupdate_dma', 'TRUE', 'If true, after connect to network, gully or connec will have the same dma as its pjoint. If false, this value won''t propagate', 'Connect autoupdate dma', NULL, NULL, FALSE, NULL, 'utils', NULL, NULL, 'boolean');

