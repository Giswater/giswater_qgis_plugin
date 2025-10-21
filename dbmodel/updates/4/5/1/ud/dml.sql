/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''GULLY''', '''GULLY''=ANY(feature_type)')
WHERE columnname = 'function_type'
AND formname ILIKE 've_gully%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''GULLY''', '''GULLY''=ANY(feature_type)')
WHERE columnname = 'category_type'
AND formname ILIKE 've_gully%';

UPDATE config_form_fields
SET dv_querytext = REPLACE(dv_querytext, 'feature_type=''GULLY''', '''GULLY''=ANY(feature_type)')
WHERE columnname = 'location_type'
AND formname ILIKE 've_gully%';