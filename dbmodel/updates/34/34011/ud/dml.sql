/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
UPDATE sys_table SET id='inp_subcatchment' WHERE id='subcatchment';

UPDATE sys_foreignkey SET target_table = 'inp_subcatchment'  WHERE target_table = 'subcatchment';
