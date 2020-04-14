/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/04/14
UPDATE config_api_form_fields set layout_order = 4 WHERE (formname = 've_connec' OR formname = 'v_edit_connec') AND column_id = 'state_type';
UPDATE config_api_form_fields set layout_order = 3 WHERE (formname = 've_connec' OR formname = 'v_edit_connec') AND column_id = 'state';
