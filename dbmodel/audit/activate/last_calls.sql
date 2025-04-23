/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- Active audit fields for trigger layers
UPDATE PARENT_SCHEMA.sys_table SET isaudit = true WHERE
id = ANY (SELECT child_layer FROM PARENT_SCHEMA.cat_feature);

-- Execute the function to do the first snapshot
SELECT audit.gw_fct_setsnapshot($${"description": "First water network snapshot"}$$);
