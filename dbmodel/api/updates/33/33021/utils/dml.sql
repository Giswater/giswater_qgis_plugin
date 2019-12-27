/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2019/12/23
UPDATE SCHEMA_NAME.config_api_form_fields SET iseditable=false where column_id='arc_id' AND formname LIKE 've_arc%';
UPDATE SCHEMA_NAME.config_api_form_fields SET iseditable=false where column_id='node_id' AND formname LIKE 've_node%';
UPDATE SCHEMA_NAME.config_api_form_fields SET iseditable=false where column_id='connec_id' AND formname LIKE 've_connec%';

UPDATE config_param_system SET context='api_search_visit' WHERE parameter='api_search_visit';