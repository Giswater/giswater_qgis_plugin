/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;

ALTER TABLE cat_element DROP CONSTRAINT cat_element_elementtype_id_fkey;
ALTER TABLE cat_element ADD CONSTRAINT cat_element_fkey_element_type FOREIGN KEY (element_type) REFERENCES cat_feature_element(id);
