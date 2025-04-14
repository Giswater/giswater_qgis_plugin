/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE config_form_fields SET iseditable = true where columnname ='to_arc';


update config_form_fields set hidden = false where columnname = 'macrodma_id' and formname in ('v_edit_dma');
update config_form_fields 
set hidden = false, columnname = 'macrodma', dv_querytext  = 'SELECT name as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL', label= 'macrodma_id' 
where columnname = 'macrodma_id' and formname in ('v_ui_dma');

update config_form_fields set hidden = false where columnname = 'macrodqa_id' and formname in ('v_edit_dqa');
update config_form_fields 
set hidden = false, columnname = 'macrodqa', dv_querytext  = 'SELECT name as id, name as idval FROM macrodqa WHERE macrodqa_id IS NOT NULL', label= 'macrodqa_id' 
where columnname = 'macrodqa_id' and formname in ('v_ui_dqa');

update config_form_fields set hidden = false where columnname = 'macrosector_id' and formname in ('v_edit_sector');
update config_form_fields 
set hidden = false, columnname = 'macrosector', dv_querytext  = 'SELECT name as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL', label= 'macrosector_id' 
where columnname = 'macrosector_id' and formname in ('v_ui_sector');