/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


ALTER TABLE node DROP CONSTRAINT arc_macrominsector_id_fkey; -- arc_ prefix because wrong name in before version
ALTER TABLE arc DROP CONSTRAINT arc_macrominsector_id_fkey;
ALTER TABLE connec DROP CONSTRAINT connec_macrominsector_id_fkey;
ALTER TABLE link DROP CONSTRAINT link_macrominsector_id_fkey;

-- drop gw_trg_presszone_check_datatype
DELETE FROM sys_function WHERE id=3306;