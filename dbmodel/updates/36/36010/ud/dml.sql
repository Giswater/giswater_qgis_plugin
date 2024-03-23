/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2024/3/23
update config_form_fields set dv_isnullvalue = true  
where columnname in ('arccat_id','curve_id','expl_id','flap','form_type','gate','lidco_id','matcat_id','ori_type','outfall_type','pattern_id','poll_id','rgage_type' ,'timser_id', 'weir_type')
and formname like '%dscenario%';

update config_form_fields set widgetcontrols = (replace(widgetcontrols::text, '"nullValue":false','"nullValue":true'))::json 
where columnname in ('arccat_id','curve_id','expl_id','flap','form_type','gate','lidco_id','matcat_id','ori_type','outfall_type','pattern_id','poll_id','rgage_type' ,'timser_id', 'weir_type') 
and formname like '%dscenario%';

