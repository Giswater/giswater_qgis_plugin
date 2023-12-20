/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 20/12/2023
DROP TRIGGER gw_trg_typevalue_fk ON cat_arc_shape;
ALTER TABLE cat_arc_shape DROP CONSTRAINT cat_arc_shape_check;
INSERT INTO cat_arc_shape VALUES ('UNKNOWN','UNKNOWN');
ALTER TABLE cat_arc_shape ADD CONSTRAINT cat_arc_shape_check CHECK (epa::text = ANY (ARRAY['VERT_ELLIPSE'::character varying::text, 'ARCH'::character varying::text, 'BASKETHANDLE'::character varying::text, 'CIRCULAR'::character varying::text, 'CUSTOM'::character varying::text, 'DUMMY'::character varying::text, 'EGG'::character varying::text, 'FILLED_CIRCULAR'::character varying::text, 'FORCE_MAIN'::character varying::text, 'HORIZ_ELLIPSE'::character varying::text, 'HORSESHOE'::character varying::text, 'IRREGULAR'::character varying::text, 'MODBASKETHANDLE'::character varying::text, 'PARABOLIC'::character varying::text, 'POWER'::character varying::text, 'RECT_CLOSED'::character varying::text, 'RECT_OPEN'::character varying::text, 'RECT_ROUND'::character varying::text, 'RECT_TRIANGULAR'::character varying::text, 'SEMICIRCULAR'::character varying::text, 'SEMIELLIPTICAL'::character varying::text, 'TRAPEZOIDAL'::character varying::text, 'TRIANGULAR'::character varying::text, 'VIRTUAL'::character varying::text, 'UNKNOWN'::character varying::text]));

