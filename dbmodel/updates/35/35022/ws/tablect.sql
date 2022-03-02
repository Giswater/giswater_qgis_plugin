/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2022/02/18
DROP RULE IF EXISTS dqa_undefined ON dqa;
CREATE RULE dqa_undefined AS ON UPDATE TO dqa
WHERE NEW.dqa_id = 0 OR OLD.dqa_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS dqa_del_undefined ON dqa;
CREATE RULE dqa_del_undefined AS ON DELETE TO dqa
WHERE OLD.dqa_id = 0 DO INSTEAD NOTHING;

DROP RULE IF EXISTS dqa_conflict ON dqa;
CREATE RULE dqa_conflict AS ON UPDATE TO dqa
WHERE NEW.dqa_id = -1 OR OLD.dqa_id = -1 DO INSTEAD NOTHING;

DROP RULE IF EXISTS dqa_del_conflict ON dqa;
CREATE RULE dqa_del_conflict AS ON DELETE TO dqa
WHERE OLD.dqa_id = -1 DO INSTEAD NOTHING;

DROP RULE IF EXISTS presszone_undefined ON presszone;
CREATE RULE presszone_undefined AS ON UPDATE TO presszone
WHERE NEW.presszone_id = '0' OR OLD.presszone_id = '0' DO INSTEAD NOTHING;

DROP RULE IF EXISTS presszone_del_undefined ON presszone;
CREATE RULE presszone_del_undefined AS ON DELETE TO presszone
WHERE OLD.presszone_id = '0' DO INSTEAD NOTHING;

DROP RULE IF EXISTS presszone_conflict ON presszone;
CREATE RULE presszone_conflict AS ON UPDATE TO presszone
WHERE NEW.presszone_id = '-1' OR OLD.presszone_id = '-1' DO INSTEAD NOTHING;

DROP RULE IF EXISTS presszone_del_conflict ON presszone;
CREATE RULE presszone_del_uconflict AS ON DELETE TO presszone
WHERE OLD.presszone_id = '-1' DO INSTEAD NOTHING;