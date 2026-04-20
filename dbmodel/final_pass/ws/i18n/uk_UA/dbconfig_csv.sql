/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;
UPDATE config_csv AS t SET alias = v.alias, descript = v.descript FROM (
	VALUES
	(234, 'Імпорт db prices', 'Файл csv повинен містити наступні стовпці в тих самих позиціях: id, unit, descript, text, price.  - Стовпець price має бути числовим з двома десятковими.  - Ви можете вибрати назву каталогу для цих цін, встановивши мітку імпорту.'),
    (235, 'Імпорт елементів', 'Файл csv повинен містити наступні стовпці в тих самих позиціях: Id (arc_id, node_id, connec_id), code, elementcat_id, observ, comment, num_elements, state type (id), workcat_id, verified (вибрати з edit_typevalue>value_verified). - Поля спостережень (observ) та коментарів (comment) є необов''язковими - УВАГА! Поле label імпорту має бути заповнене типом елементу (node, arc, connec)'),
    (238, 'Імпорт om visit', 'Щоб використати цей параметр функції імпорту csv, ви повинні перед виконанням налаштувати системний параметр ''utils_csv2pg_om_visit_parameters''. Також ми рекомендуємо перед роботою прочитати анотації всередині функції, щоб вона працювала якнайкраще.'),
    (384, 'Імпорт inp кривих', 'Функція для автоматизації імпорту файлів кривих inp. Файл csv повинен містити наступні стовпці в тих самих позиціях: curve_id, x_value, y_value, curve_type (для проекту WS або UD значення curve_type різняться. Перевірте посібник користувача)'),
    (386, 'Імпорт inp шаблонів', 'Функція для автоматизації імпорту файлів шаблонів inp. Файл csv повинен містити наступні стовпці в тих самих позиціях: pattern_id, pattern_type, factor1,.......,factorn. Для WS використовуйте до factor18, допускається повторення рядків. Для UD використовуйте до factor24. Більше ніж один рядок для одного шаблону не дозволяється'),
    (444, 'Імпорт cat_feature_arc', 'Файл csv повинен містити наступні стовпці в тій самій точній послідовності:  id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active'),
    (469, 'Імпорт scada значень', 'Імпорт scada значень до таблиці ext_rtc_scada_x_data відповідно до прикладного файлу scada_values.csv'),
    (470, 'Імпорт водомір_x_дані', 'Файл csv повинен містити такі поля: водомір_id, cat_period_id, сума, дата_значення (необов''язково), тип_значення (необов''язково), статус_значення (необов''язково), стан_значення (необов''язково)'),
    (471, 'Імпорт значень періоду crm', 'Файл csv повинен містити такі поля: id, start_date, end_date, period_seconds (необов''язково), code'),
    (445, 'Імпорт cat_feature_node', 'CSV-файл повинен містити наступні стовпці в точно такому самому порядку: id, system_id, epa_default, isarcdivide, isprofilesurface, choose_hemisphere, code_autofill, double_geom, num_arcs, graph_delimiter, shortcut_key, link_path, descript, active'),
    (446, 'Імпорт cat_feature_connec', 'Файл csv повинен містити наступні стовпці в точно такому ж порядку: id, system_id, epa_default, code_autofill, shortcut_key, link_path, descript, active'),
    (448, 'Імпорт cat_node', 'Файл csv повинен містити наступні стовпці в точно такому ж порядку: id, nodetype_id, matcat_id, pnom, dnom, dint, dext, shape, descript, link, brand, model, svg, estimated_depth, cost_unit, cost, active, label, ischange, acoeff'),
    (449, 'Імпорт cat_connec', 'Файл csv повинен містити наступні стовпці в точно такому ж порядку: id, connectype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, active, label'),
    (450, 'Імпорт cat_arc', 'Файл csv повинен містити наступні стовпці в точно такому ж порядку: id, arctype_id, matcat_id, pnom, dnom, dint, dext, descript, link, brand, model, svg, z1, z2, width, area, estimated_depth, bulk, cost_unit, cost, m2bottom_cost, m3protec_cost, active, label, shape, acoeff, connect_cost'),
    (500, 'Імпорт стану клапана', 'Файл csv повинен містити такі поля: dscenario_name, node_id, status'),
    (501, 'Імпорт вимог dscenario', 'Файл csv повинен містити такі поля: dscenario_name, feature_id, feature_type, value, demand_type, pattern_id, source'),
    (504, 'Імпорт Добових Значень Витратоміра', 'Імпорт Добових Значень Витратоміра В Таблицю ext_rtc_scada_x_data Відповідно До Файлу Прикладу scada_flowmeter_daily_values.csv'),
    (506, 'Імпорт Агрегованих Значень Витратоміра', 'Імпорт Агрегованих Значень Витратоміра В Таблицю ext_rtc_scada_x_data Відповідно До Файлу Прикладу scada_flowmeter_agg_values.csv'),
    (514, 'Імпорт Netscenario Закритих Клапанів', 'CSV-файл повинен містити наступні поля: netscenario_id, node_id, closed')
) AS v(fid, alias, descript)
WHERE t.fid = v.fid;

