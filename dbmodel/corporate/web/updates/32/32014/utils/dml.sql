/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO config_param_system VALUES (257, 'api_getinfoelements', '{"key":"", "queryText":"SELECT id as \"Identifier:\" FROM table WHERE id IS NOT NULL ", "idName":"id"}', 'json', 'basic', 'Variable to customize table about getinfoelements function for api. Use \"your_text\" to use alias');
