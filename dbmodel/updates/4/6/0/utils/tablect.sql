/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


ALTER TABLE node ADD CONSTRAINT node_sys_code_unique UNIQUE (sys_code);
ALTER TABLE arc ADD CONSTRAINT arc_sys_code_unique UNIQUE (sys_code);
ALTER TABLE connec ADD CONSTRAINT connec_sys_code_unique UNIQUE (sys_code);
ALTER TABLE "element" ADD CONSTRAINT element_sys_code_unique UNIQUE (sys_code);
