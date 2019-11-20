/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--20/11/2019
UPDATE config_api_form_fields SET dv_isnullvalue = true WHERE formtype='form' AND (column_id='pattern' OR column_id ='pattern_id') 
AND formname != 'inp_pattern' AND formname != 'inp_pattern_value';

UPDATE config_api_form_fields SET dv_isnullvalue = true WHERE formtype='form' AND column_id='curve_id' AND formname != 'inp_curve';