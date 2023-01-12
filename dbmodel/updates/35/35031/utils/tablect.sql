/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2023/01/09
CREATE OR REPLACE RULE cat_feature_del_link AS
    ON DELETE TO cat_feature
    WHERE (old.id = 'LINK')
    DO INSTEAD NOTHING;
    
CREATE OR REPLACE RULE cat_feature_upd_link AS
    ON UPDATE TO cat_feature
    WHERE (old.id = 'LINK')
    DO INSTEAD NOTHING;