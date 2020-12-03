/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/12/27
UPDATE cat_node SET ischange=2; -- 2: it means maybe, and due this all it works....

-- 2020/01/07
DELETE FROM audit_cat_param_user WHERE id='hydrantcat_vdefault';