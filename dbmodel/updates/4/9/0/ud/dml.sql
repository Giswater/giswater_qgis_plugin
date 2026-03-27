/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE config_form_fields SET dv_querytext='SELECT category_type as id, category_type as idval FROM man_type_category WHERE ((featurecat_id is null OR ''GULLY''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='category_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT location_type as id, location_type as idval FROM man_type_location WHERE ((featurecat_id is null OR ''GULLY''=ANY(feature_type))) AND active IS TRUE ' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='location_type' AND tabname='tab_data';
UPDATE config_form_fields SET dv_querytext='SELECT function_type as id, function_type as idval FROM man_type_function WHERE ((featurecat_id is null OR ''GULLY''=ANY(feature_type))) AND active IS TRUE' WHERE formname='ve_gully' AND formtype='form_feature' AND columnname='function_type' AND tabname='tab_data';
