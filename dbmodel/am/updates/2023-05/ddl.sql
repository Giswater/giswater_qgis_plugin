/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = am, public;

ALTER TABLE config_catalog_def ADD COLUMN id SERIAL PRIMARY KEY;
ALTER TABLE value_result_type ADD PRIMARY KEY (id);
ALTER TABLE value_status ADD PRIMARY KEY (id);