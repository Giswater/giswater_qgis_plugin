/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- Execute the function to do the first snapshot
SELECT SCHEMA_NAME.gw_fct_set_snapshot('First water network snapshot');


-- Activate audit
SELECT PARENT_SCHEMA.gw_fct_audit_schema('enable');
