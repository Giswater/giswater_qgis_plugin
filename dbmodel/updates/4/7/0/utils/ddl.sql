/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 07/01/2026
ALTER TABLE anl_polygon ALTER COLUMN the_geom TYPE geometry(MULTIPOLYGON, SRID_VALUE) USING the_geom;

-- 13/01/2026
CREATE TABLE inp_family(
    family_id character varying(100) NOT NULL,
    descript text,
    age integer,
    PRIMARY KEY (family_id)
);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"cat_material", "column":"family", "dataType":"varchar(100)", "isUtils":"False"}}$$);

ALTER TABLE cat_material ADD CONSTRAINT fk_cat_material_family FOREIGN KEY (family) REFERENCES inp_family(family_id);
