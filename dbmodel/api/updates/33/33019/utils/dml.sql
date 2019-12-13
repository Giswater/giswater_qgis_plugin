/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_api_form_fields set label='Unitary cost' where formname='infoplan' and column_id='initial_cost';
UPDATE config_api_form_fields set column_id='length', label='Length' where formname='infoplan' and column_id='other_cost';
UPDATE config_api_form_fields set column_id='total_cost', label='Total cost' where formname='infoplan' and column_id='intermediate_cost';