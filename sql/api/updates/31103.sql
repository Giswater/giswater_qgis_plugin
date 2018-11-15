/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

SELECT setval('SCHEMA_NAME.config_param_system_id_seq', (SELECT max(id) FROM config_param_system), true);

INSERT INTO config_param_system (parameter, value, data_type, context, descript) 
			VALUES ('api_config_parameters', '{"istiled_filterstate":"publish_user", "other":"other"}', 'json', 'System', 'API');


