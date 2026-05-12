/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_csv AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(385, 'Імпорт inp timeseries', 'Функція для допомоги в імпорті часових рядів для моделей inp. Файл csv повинен містити наступні стовпці в тих самих позиціях: timseries, timser_type, times_type, descript, expl_id, date, hour, time, value (заповнюйте date/hour для ABSOLUTE або time для RELATIVE)'),
    (408, 'Імпорт istram nodes', NULL),
    (409, 'Імпорт istram arcs', NULL),
    (445, 'Імпорт cat_feature_node', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, system_id, epa_default, isarcdivide, isprofilesurface, code_autofill, choose_hemisphere, double_geom, num_arcs, isexitupperintro, shortcut_key, link_path, descript, active'),
    (446, 'Імпорт cat_feature_connec', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, system_id, code_autofill, double_geom, shortcut_key, link_path, descript, active'),
    (447, 'Імпорт cat_feature_gully', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, system_id, epa_default, code_autofill, double_geom, shortcut_key, link_path, descript, active'),
    (448, 'Імпорт cat_node', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, matcat_id, shape, geom1, geom2, geom3, descript, link, brand, model, svg, estimated_y, cost_unit, cost, active, label, node_type, acoeff'),
    (449, 'Імпорт cat_connec', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, matcat_id, shape, geom1, geom2, geom3, geom4, geom_r, descript, link, brand, model, svg, active, label, connec_type'),
    (450, 'Імпорт cat_arc', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, matcat_id, shape, geom1, geom2, geom3, geom4, geom5, geom6,geom7, geom8, geom_r, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, tsect_id, curve_id, arc_type, acoeff, connect_cost'),
    (451, 'Імпорт cat_grate', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, matcat_id, length, width, total_area, effective_area, n_barr_l, n_barr_w, n_barr_diag, a_param, b_param, descript, link, brand, model, svg, active, label, gully_type'),
    (527, 'Імпорт DWF', 'Функція для імпорту значень DWF. Файл CSV повинен містити наступні стовпці в тій самій точній послідовності:   dwfscenario_id, node_id, value, pat1, pat2, pat3, pat4'),
    (234, 'Імпорт db prices', 'Файл csv повинен містити наступні стовпці в тих самих позиціях: id, unit, descript, text, price.  - Стовпець price має бути числовим з двома десятковими.  - Ви можете вибрати назву каталогу для цих цін, встановивши мітку імпорту.'),
    (235, 'Імпорт елементів', 'Файл csv повинен містити наступні стовпці в тих самих позиціях: Id (arc_id, node_id, connec_id), code, elementcat_id, observ, comment, num_elements, state type (id), workcat_id, verified (вибрати з edit_typevalue>value_verified). - Поля спостережень (observ) та коментарів (comment) є необов''язковими - УВАГА! Поле label імпорту має бути заповнене типом елементу (node, arc, connec)'),
    (238, 'Імпорт om visit', 'Щоб використати цей параметр функції імпорту csv, ви повинні перед виконанням налаштувати системний параметр ''utils_csv2pg_om_visit_parameters''. Також ми рекомендуємо перед роботою прочитати анотації всередині функції, щоб вона працювала якнайкраще.'),
    (384, 'Імпорт inp кривих', 'Функція для автоматизації імпорту файлів кривих inp. Файл csv повинен містити наступні стовпці в тих самих позиціях: curve_id, x_value, y_value, curve_type (для проекту WS або UD значення curve_type різняться. Перевірте посібник користувача)'),
    (386, 'Імпорт inp шаблонів', 'Функція для автоматизації імпорту файлів шаблонів inp. Файл csv повинен містити наступні стовпці в тих самих позиціях: pattern_id, pattern_type, factor1,.......,factorn. Для WS використовуйте до factor18, допускається повторення рядків. Для UD використовуйте до factor24. Більше ніж один рядок для одного шаблону не дозволяється'),
    (444, 'Імпорт cat_feature_arc', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active'),
    (469, 'Імпорт scada значень', 'Імпорт scada значень до таблиці ext_rtc_scada_x_data відповідно до прикладного файлу scada_values.csv'),
    (470, 'Імпорт водомір_x_дані', 'Файл csv повинен містити такі поля: водомір_id, cat_period_id, сума, дата_значення (необов''язково), тип_значення (необов''язково), статус_значення (необов''язково), стан_значення (необов''язково)'),
    (471, 'Імпорт значень періоду crm', 'Файл csv повинен містити такі поля: id, start_date, end_date, period_seconds (необов''язково), code')
) AS v(fid, alias, descript)
WHERE t.fid = v.fid;

