/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;

ALTER TABLE SCHEMA_NAME.cat_arc_shape ADD CONSTRAINT cat_arc_shape_check CHECK (id IN ('ARCH','BASKETHANDLE','CIRCULAR','CUSTOM','DUMMY','EGG','FILLED_CIRCULAR','FORCE_MAIN','HORIZ_ELLIPSE','HORSESHOE','IRREGULAR','MODBASKETHANDLE','PARABOLIC','POWER','RECT_CLOSED','RECT_OPEN','RECT_ROUND','RECT_TRIANGULAR','SEMICIRCULAR','SEMIELLIPTICAL','TRAPEZOIDAL','TRIANGULAR','VIRTUAL'));
ALTER TABLE SCHEMA_NAME.sys_feature_type ADD CONSTRAINT sys_feature_type_check CHECK (id IN ('ARC','CONNEC','ELEMENT','GULLY','LINK','NODE','VNODE'));
ALTER TABLE SCHEMA_NAME.sys_feature_cat ADD CONSTRAINT sys_feature_cat_check CHECK (id IN ('CHAMBER','CONDUIT','CONNEC','GULLY','JUNCTION','MANHOLE','NETELEMENT','NETGULLY','NETINIT','OUTFALL','SIPHON','STORAGE','VALVE','VARC','WACCEL','WJUMP','WWTP'));