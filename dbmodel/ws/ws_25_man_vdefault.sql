/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

*/


-- ----------------------------
-- Default values of column views
-- ----------------------------

ALTER VIEW "SCHEMA_NAME".v_edit_man_junction ALTER elevation SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_junction ALTER depth SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_junction ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_junction ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_man_tank ALTER elevation SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_tank ALTER depth SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_tank ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_tank ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_man_hydrant ALTER elevation SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_hydrant ALTER depth SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_hydrant ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_hydrant ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_man_valve ALTER elevation SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_valve ALTER depth SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_valve ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_valve ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_man_pump ALTER elevation SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_pump ALTER depth SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_pump ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_pump ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_man_filter ALTER elevation SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_filter ALTER depth SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_filter ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_filter ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_man_meter ALTER elevation SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_meter ALTER depth SET DEFAULT 0;
ALTER VIEW "SCHEMA_NAME".v_edit_man_meter ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_meter ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "SCHEMA_NAME".v_edit_man_pipe ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "SCHEMA_NAME".v_edit_man_pipe ALTER verified SET DEFAULT 'TO REVIEW';

