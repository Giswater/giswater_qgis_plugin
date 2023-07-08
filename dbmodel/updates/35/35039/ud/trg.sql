/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME ,public;

create trigger gw_trg_vi_outlets instead of insert or delete or update on vi_outlets 
for each row execute function ud.gw_trg_vi('vi_outlets');