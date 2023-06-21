/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP RULE IF EXISTS undelete_macrodqa ON macrodqa;
CREATE RULE undelete_macrodqa AS
ON DELETE TO macrodqa
WHERE (old.undelete = true) DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrodqa_undefined ON macrodqa;
CREATE RULE macrodqa_undefined AS
ON UPDATE TO macrodqa
WHERE ((new.macrodqa_id = 0) OR (old.macrodqa_id = 0)) DO INSTEAD NOTHING;

DROP RULE IF EXISTS macrodqa_del_undefined ON macrodqa;
CREATE RULE macrodqa_del_undefined AS
ON DELETE TO macrodqa
WHERE (old.macrodqa_id = 0) DO INSTEAD NOTHING;
