/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO sys_fprocess (fid,fprocess_name,project_type,"source",isaudit,fprocess_type,active)
VALUES (640,'Dynamic omunit analysis','ud','core',true,'Function process',true);
