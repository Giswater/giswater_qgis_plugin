/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = SCHEMA_NAME, public, pg_catalog;


UPDATE sys_table SET sys_role='role_basic' WHERE id='anl_connec';
UPDATE sys_table SET sys_role='role_basic' WHERE id='anl_node';
UPDATE sys_table SET sys_role='role_basic' WHERE id='anl_arc';


insert into config_form_tabs (formname, tabname, label, tooltip, sys_role, orderby, device) VALUES
('selector_basic','tab_network','Network','Network','role_basic',-1,'{5}');

insert into om_typevalue values ('network_type','1','WATER SUPPLY');
insert into om_typevalue values ('network_type','2','URBAN DRAINAGE');