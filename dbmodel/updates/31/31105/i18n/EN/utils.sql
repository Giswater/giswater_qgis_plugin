/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO dattrib_type VALUES (1, 'dminsector', 'Dynamic mapzone defined as a minimun portion of network limited by operative valves', 'ws');
INSERT INTO dattrib_type VALUES (2, 'pipehazard', 'Number of hydrometers afected in case of break of pipe', 'ws');
INSERT INTO dattrib_type VALUES (3, 'dinletsector', 'Dynamic mapzone defined as area supplied from the same inlet','ws');
INSERT INTO dattrib_type VALUES (4, 'dstaticpress', 'In function of inlet, value of the static pressure using inlet eletavion on feature elevation', 'ws');
