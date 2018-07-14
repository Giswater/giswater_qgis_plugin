/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO sys_csv2pg_cat VALUES (1, 'Importar precios a la base de datos', 'Importar precios a la base de datos', 
'El fichero csv debe tener estas columnas por orden: id, unit, descript, text, price.
- La columna price deber ser tipo numerico con dos decimales.
- Puedes escoger un catalogo para los precios importados asignandolo a Import label.
- Atencion: el fichero csv debe tener una fila de encabezado', 'role_master');
INSERT INTO sys_csv2pg_cat VALUES (2, 'Importar tabla de visitas a nodos', 'Importar tabla de visitas a nodos', 'El fichero csv debe tener estas columnas por orden: node_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (3, 'Importar elementos', 'Importar elementos', 
'El fichero csv debe tener estas columnas por orden: feature_id, elementcat_id, observ, comment, num_elements. 
- A Import label se debe establecer el tipo de elemento que quieres importar (node, arc, connec, gully).
- Los campos Observ y Comment son opcionales.
- Atencion: el fichero csv debe tener una fila de encabezado', 'role_admin');
INSERT INTO sys_csv2pg_cat VALUES (4, 'Importar campos adicionales', 'Importar campos adicionales', 'El fichero csv debe tener estas columnas por orden: 
feature_id (puede ser arc, node o connec), parameter_id (a escoger de la tabla man_addfields_parameter), value_param. 
- Atencion: el fichero csv debe tener una fila de encabezado', 'role_admin');
INSERT INTO sys_csv2pg_cat VALUES (5, 'Importar tabla de visitas a arco', 'Importar tabla de visitas a arco', 'El fichero csv debe tener estas columnas por orden: arc_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (6, 'Importar tabla de visitas a connec', 'Importar tabla de visitas a connec', 'El fichero csv debe tener estas columnas por orden: connec_id, unit', 'role_om');
INSERT INTO sys_csv2pg_cat VALUES (7, 'Importar tabla de visitas a gully', 'Importar tabla de visitas a gully', 'El fichero csv debe tener estas columnas por orden: gully_id, unit', 'role_om');