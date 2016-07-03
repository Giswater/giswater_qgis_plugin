/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



ALTER TABLE "SCHEMA_NAME"."picture" ADD FOREIGN KEY ("event_id") REFERENCES "SCHEMA_NAME"."event" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."picture" ADD FOREIGN KEY ("tagcat_id") REFERENCES "SCHEMA_NAME"."cat_tag" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

