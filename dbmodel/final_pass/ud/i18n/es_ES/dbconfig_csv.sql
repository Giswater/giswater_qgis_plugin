/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_csv AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(385, 'Importar series temporales inp', 'Función de ayuda a la importación de series temporales para modelos inp. El archivo csv debe contener las siguientes columnas en la misma posición: timeseries, type, mode, date, hour, time, value (fecha/hora para ABSOLUTO o hora para RELATIVO)'),
    (408, 'Importar nodos istram', NULL),
    (409, 'Importar arcos istram', NULL),
    (447, 'Importar cat_feature_gully', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, system_id, epa_default, code_autofill, double_geom, shortcut_key, link_path, descript, active'),
    (451, 'Importar cat_grate', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, matcat_id, longitud, anchura, área_total, área_efectiva, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, label, gully_type'),
    (527, 'Importar DWF', 'Función para importar valores DWF. El archivo CSV debe contener las siguientes columnas en el mismo orden: dwfscenario_id, node_id, value, pat1, pat2, pat3, pat4'),
    (234, 'Precios db importación', 'El archivo csv debe contener las siguientes columnas en la misma posición: id, unidad, descripción, texto, precio. - La columna precio debe ser numérica con dos decimales. - Puede elegir un nombre de catálogo para estos precios estableciendo una etiqueta de importación. '),
    (235, 'Importar elementos', 'El archivo csv debe contener las siguientes columnas en la misma posición: Id (arc_id, node_id, connec_id), code, elementcat_id, observ, comment, num_elements, state type (id), workcat_id, verified (elegir entre edit_typevalue>value_verified). - Los campos observaciones y comentarios son opcionales - ¡ATENCIÓN! La etiqueta de importación debe rellenarse con el tipo de elemento (nodo, arco, conexión).'),
    (238, 'Importación en visita', 'Para utilizar este parámetro de la función import csv es necesario configurar antes de ejecutarla el parámetro del sistema ''utils_csv2pg_om_visit_parameters''. También recomendamos leer antes las anotaciones dentro de la función para trabajar lo mejor posible con'),
    (384, 'Importar curvas inp', 'Función para automatizar la importación de ficheros de curvas inp. El archivo csv debe contener las siguientes columnas en la misma posición: curve_id, x_value, y_value, curve_type (para el proyecto WS O el proyecto UD curve_type tiene valores diferentes. Consulte el manual del usuario)'),
    (386, 'Importar patrones inp', 'Función para automatizar la importación de ficheros de patrones inp. El archivo csv debe contener las siguientes columnas en la misma posición: pattern_id, pattern_type, factor1,.......,factorn. Para WS utilice hasta factor18, repitiendo filas si lo desea. Para UD utilice hasta factor24. No se permite más de una fila por patrón'),
    (444, 'Importar cat_feature_arc', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active'),
    (445, 'Importar cat_feature_node', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, system_id, epa_default, isarcdivide, isprofilesurface, choose_hemisphere, code_autofill, double_geom, num_arcs, graph_delimiter, shortcut_key, link_path, descript, active'),
    (446, 'Importar cat_feature_connec', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active'),
    (448, 'Importar nodo_cat', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, nodetype_id, matcat_id, pnom, dnom, dint, dext, shape, descript, link, brand, model, svg, estimated_depth, cost_unit, cost, active, label, ischange, acoeff'),
    (449, 'Importar cat_connec', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, connectype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, active, label'),
    (450, 'Importar cat_arc', 'El archivo csv debe contener las siguientes columnas en el mismo orden: id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, shape, acoeff, connect_cost'),
    (469, 'Importar valores scada', 'Importar valores scada a la tabla ext_rtc_scada_x_data según el archivo de ejemplo scada_values.csv'),
    (470, 'Importar datos_x_del_hidrómetro', 'El archivo csv debe tener los siguientes campos hydrometer_id, cat_period_id, sum, value_date (opcional), value_type (opcional), value_status (opcional), value_state (opcional)'),
    (471, 'Importar valores de periodo de crm', 'El archivo csv debe tener los siguientes campos id, start_date, end_date, period_seconds (opcional), code')
) AS v(fid, alias, descript)
WHERE t.fid = v.fid;

