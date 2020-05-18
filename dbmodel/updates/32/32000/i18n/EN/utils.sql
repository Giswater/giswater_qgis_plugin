/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

INSERT INTO config_api_message VALUES (10, 2, 'No class visit', NULL, 'alone');
INSERT INTO config_api_message VALUES (20, 0, 'sucessfully deleted', NULL, 'withfeature');
INSERT INTO config_api_message VALUES (30, 1, 'does not exists, impossible to delete it', NULL, 'withfeature');
INSERT INTO config_api_message VALUES (50, 0, 'sucessfully updated', NULL, 'withfeature');
INSERT INTO config_api_message VALUES (40, 0, 'sucessfully inserted', NULL, 'withfeature');
INSERT INTO config_api_message VALUES (60, 1, 'Visit class have been changed. Previous data have been deleted', NULL, 'alone');
INSERT INTO config_api_message VALUES (70, 0, 'Visit manager have been initialized', NULL, 'alone');
INSERT INTO config_api_message VALUES (80, 0, 'Visit manager have been finished', NULL, 'alone');
INSERT INTO config_api_message VALUES (90, 0, 'Lot succesfully saved', NULL, 'alone');
INSERT INTO config_api_message VALUES (100, 0, 'Lot succesfully deleted', NULL, 'alone');