/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


GRANT ALL ON SCHEMA ud30 TO user_dev;
GRANT ALL ON SCHEMA ud30 TO rol_dev;

GRANT ALL ON ALL TABLES IN SCHEMA ud30 TO user_dev;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA ud30 TO rol_dev;