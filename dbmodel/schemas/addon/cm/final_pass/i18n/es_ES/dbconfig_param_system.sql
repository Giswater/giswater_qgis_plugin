/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_param_system AS t SET label = v.label, descript = v.descript FROM (
	VALUES
	('admin_campaign_type', NULL, 'Variable para especificar el tipo de campaña que queremos ver al crearla'),
    ('basic_selector_tab_campaign', 'Selector variables', 'Variable para configurar todas las opciones relacionadas con la búsqueda de la ficha especifica'),
    ('basic_selector_tab_lot', 'Selector variables', 'Variable para configurar todas las opciones relacionadas con la búsqueda de la ficha especifica')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

