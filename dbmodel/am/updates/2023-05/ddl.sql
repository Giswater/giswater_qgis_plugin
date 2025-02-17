/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public;

ALTER TABLE config_catalog_def ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE value_result_type ADD PRIMARY KEY (id);
ALTER TABLE value_status ADD PRIMARY KEY (id);