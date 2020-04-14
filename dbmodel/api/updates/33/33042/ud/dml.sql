/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/04/14
UPDATE config_api_form_fields set layoutname = 'lyt_data_1' WHERE column_id = 'width' AND
(formname = 've_node_chamber' OR formname = 've_node_pump_station' OR formname = 've_node_weir');
