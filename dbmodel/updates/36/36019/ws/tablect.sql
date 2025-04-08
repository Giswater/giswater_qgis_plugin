/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


DROP RULE IF EXISTS dqa_conflict ON dqa;
DROP RULE IF EXISTS dqa_undefined ON dqa;
update dqa set macrodqa_id = 0 where macrodqa_id is null;
ALTER TABLE dqa alter column macrodqa_id set default 0;
CREATE RULE dqa_undefined AS ON UPDATE TO dqa WHERE((new.dqa_id = 0) OR (old.dqa_id = 0)) DO INSTEAD NOTHING;
CREATE RULE dqa_conflict AS ON UPDATE TO dqa WHERE((new.dqa_id = -1) OR (old.dqa_id = -1)) DO INSTEAD NOTHING;
