/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

alter table archived_psector_link add column y1 numeric(12,3);
alter table archived_psector_link rename column depth2 to y2;

alter table archived_psector_link add column dwfzone_id integer;

