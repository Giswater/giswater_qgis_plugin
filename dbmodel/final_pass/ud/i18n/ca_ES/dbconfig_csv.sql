/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_csv AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(385, 'Importar inp timeseries', 'Funció per ajudar la importació de sèries temporals per models inp. El fitxer csv ha de contenir les següents columnes en la mateixa posició: timseries, timser_type, times_type, descript, expl_id, date, hour, time, value (ompliu date/hour per ABSOLUTE o time per RELATIVE)'),
    (408, 'Importar istram nodes', NULL),
    (409, 'Importar istram arcs', NULL),
    (445, 'Importar cat_feature_node', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte:  id, system_id, epa_default, isarcdivide, isprofilesurface, code_autofill, choose_hemisphere, double_geom, num_arcs, isexitupperintro, shortcut_key, link_path, descript, active'),
    (446, 'Importar cat_feature_connec', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte:  id, system_id, code_autofill, double_geom, shortcut_key, link_path, descript, active'),
    (447, 'Importar cat_feature_gully', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte:  id, system_id, epa_default, code_autofill, double_geom, shortcut_key, link_path, descript, active'),
    (448, 'Importar cat_node', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte:  id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, cost, active, label, node_type, acoeff'),
    (449, 'Importar cat_connec', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte:  id, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand, model, svg, active, label, connec_type'),
    (450, 'Importar cat_arc', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte:  id, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6,geom7, geom8, geom_r, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, tsect_id, curve_id, arc_type, acoeff, connect_cost'),
    (451, 'Importar cat_grate', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte:  id, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, label, gully_type'),
    (527, 'Importar DWF', 'Funció per importar valors DWF. El fitxer CSV ha de contenir les següents columnes en el mateix ordre:   dwfscenario_id, node_id, value, pat1, pat2, pat3, pat4'),
    (234, 'Importar preus db', 'El fitxer csv ha de contenir les següents columnes a la mateixa posició: id, unit, descript, text, price. - La columna price ha de ser numèrica amb dos decimals. - Pots triar un nom de catàleg per a aquests preus definint una etiqueta d''importació.'),
    (235, 'Importar elements', 'El fitxer csv ha de contenir les següents columnes a la mateixa posició: Id (arc_id, node_id, connec_id), code, elementcat_id, observ, comment, num_elements, state type (id), workcat_id, verified (triar de edit_typevalue>value_verified). - Els camps Observations i comments són opcionals - ATENCIÓ! L''etiqueta d''importació s''ha d''omplir amb el tipus d''element (node, arc, connec)'),
    (238, 'Importar om visit', 'Per utilitzar aquest paràmetre de la funció d''importació csv necessites configurar abans d''executar-lo el paràmetre del sistema ''utils_csv2pg_om_visit_parameters''. També recomanem llegir abans les anotacions dins la funció per a que funcioni tan bé com sigui possible amb'),
    (384, 'Importar corbes inp', 'Funció per automatitzar la importació d''arxius de corbes inp. El fitxer csv ha de contenir les següents columnes a la mateixa posició: curve_id, x_value, y_value, curve_type (per a projecte WS O projecte UD curve_type té valors diferents. Consulta el manual d''usuari)'),
    (386, 'Importar inp patterns', 'Funció per automatitzar la importació d''arxius de patrons inp.  El fitxer csv ha de contenir les següents columnes en la mateixa posició:  pattern_id, pattern_type, factor1,.......,factorn.  Per WS utilitzeu fins a factor18, repetint files si cal.  Per UD utilitzeu fins a factor24. No s''accepta més d''una fila per patró'),
    (444, 'Importar cat_feature_arc', 'El fitxer csv ha de contenir les següents columnes en el mateix ordre exacte: id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active'),
    (469, 'Importar valors scada', 'Importar valors scada a la taula ext_rtc_scada_x_data segons el fitxer d''exemple scada_values.csv'),
    (470, 'Importar hydrometer_x_data', 'El fitxer csv ha de tenir els següents camps: hydrometer_id, cat_period_id, sum, value_date (opcional), value_type (opcional), value_status (opcional), value_state (opcional)'),
    (471, 'Importar valors de període crm', 'El fitxer csv ha de tenir els següents camps: id, start_date, end_date, period_seconds (opcional), code')
) AS v(fid, alias, descript)
WHERE t.fid = v.fid;

