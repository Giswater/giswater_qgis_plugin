/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/13
UPDATE config_api_form_fields SET tooltip = 'pjoint_id - Identificador del punto de unión con la red' WHERE column_id = 'pjoint_id' AND tooltip = 'pjoint_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'pjoint_type - Tipo de punto de unión con la red' WHERE column_id = 'pjoint_type' AND tooltip = 'pjoint_type' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'feature_id - Identificador del elemento al cual se conecta' WHERE column_id = 'feature_id' AND tooltip = 'feature_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'featurecat_id - Catálogo del elemento al cual se conecta' WHERE column_id = 'featurecat_id' AND tooltip = 'featurecat_id' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'inventory - Para establecer si el elemento pertenece o debe pertenecer a inventario o no' WHERE column_id = 'inventory' AND tooltip = 'inventory' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'publish - Para establecer si el elemento es publicable o no' WHERE column_id = 'publish' AND tooltip = 'publish' AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'undelete - Para establecer si el elemento no se puede eliminar' WHERE column_id = 'undelete' AND tooltip = 'undelete' AND formtype='feature';


UPDATE config_api_form_fields SET tooltip = 'pol_id - Identificador del polígono relacionado' WHERE column_id = 'pol_id' AND tooltip IS NULL AND formtype='feature';
UPDATE config_api_form_fields SET tooltip = 'name - Nombre específico del elemento' WHERE column_id = 'name' AND tooltip IS NULL AND formtype='feature';
