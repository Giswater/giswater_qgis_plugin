/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

update config_param_system set value= '{"status":false , "diameter":150, "maxDistance":15}',
parameter = 'edit_link_link2network' where "parameter" ='edit_link_check_arcdnom';
