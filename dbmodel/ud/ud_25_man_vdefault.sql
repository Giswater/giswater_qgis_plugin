/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

*/


-- ----------------------------
-- Default values of column views
-- ----------------------------



ALTER VIEW "sample_ud".v_edit_man_junction ALTER top_elev SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_junction ALTER ymax SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_junction ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "sample_ud".v_edit_man_junction ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "sample_ud".v_edit_man_outfall ALTER top_elev SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_outfall ALTER ymax SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_outfall ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "sample_ud".v_edit_man_outfall ALTER verified SET DEFAULT 'TO REVIEW';

ALTER VIEW "sample_ud".v_edit_man_storage ALTER top_elev SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_storage ALTER ymax SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_storage ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "sample_ud".v_edit_man_storage ALTER verified SET DEFAULT 'TO REVIEW';



-- ----------------------------
-- Default values of arc editing views
-- ----------------------------

ALTER VIEW "sample_ud".v_edit_man_conduit ALTER y1 SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_conduit ALTER y2 SET DEFAULT 0;
ALTER VIEW "sample_ud".v_edit_man_conduit ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "sample_ud".v_edit_man_conduit ALTER verified SET DEFAULT 'TO REVIEW';

