/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DROP INDEX IF EXISTS link_exit_id;
CREATE INDEX link_exit_id
  ON link
  USING btree
  (exit_id COLLATE pg_catalog."default");

