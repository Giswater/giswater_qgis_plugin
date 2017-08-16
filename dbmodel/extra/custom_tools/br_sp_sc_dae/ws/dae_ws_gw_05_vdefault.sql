/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

-- ----------------------------
-- Default values of column views
-- ----------------------------

ALTER VIEW v_edit_node ALTER elevation SET DEFAULT 0.00;
ALTER VIEW v_edit_node ALTER depth SET DEFAULT 0.00;
ALTER VIEW v_edit_node ALTER state SET DEFAULT 'EM_SERVIÇO';
ALTER VIEW v_edit_node ALTER verified SET DEFAULT 'A VERIFICAR';

ALTER VIEW v_edit_arc ALTER state SET DEFAULT 'EM_SERVIÇO';
ALTER VIEW v_edit_arc ALTER verified SET DEFAULT 'A VERIFICAR';

ALTER VIEW v_edit_connec ALTER elevation SET DEFAULT 0.00;
ALTER VIEW v_edit_connec ALTER depth SET DEFAULT 0.00;
ALTER VIEW v_edit_connec ALTER state SET DEFAULT 'EM_SERVIÇO';
ALTER VIEW v_edit_connec ALTER verified SET DEFAULT 'A VERIFICAR';

