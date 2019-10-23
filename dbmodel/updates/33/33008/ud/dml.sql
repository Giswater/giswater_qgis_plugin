/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE audit_cat_function SET input_params='{"featureType":["gully"]}' WHERE input_params='{"featureType":"gully"}';

UPDATE audit_cat_function set input_params = '{"featureType":["node","connec","gully", "vnode"]}' WHERE function_name = 'gw_fct_update_elevation_from_dem';