/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association

*/


-- ----------------------------
-- Default values of column views
-- ----------------------------


ALTER VIEW "sample_ud".v_edit_node ALTER top_elev SET DEFAULT 0.00;
ALTER VIEW "sample_ud".v_edit_node ALTER ymax SET DEFAULT 0.00;
ALTER VIEW "sample_ud".v_edit_node ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "sample_ud".v_edit_node ALTER verified SET DEFAULT 'TO REVIEW';


ALTER VIEW "sample_ud".v_edit_arc ALTER y1 SET DEFAULT 0.00;
ALTER VIEW "sample_ud".v_edit_arc ALTER y2 SET DEFAULT 0.00;
ALTER VIEW "sample_ud".v_edit_arc ALTER state SET DEFAULT 'ON_SERVICE';
ALTER VIEW "sample_ud".v_edit_arc ALTER verified SET DEFAULT 'TO REVIEW';

