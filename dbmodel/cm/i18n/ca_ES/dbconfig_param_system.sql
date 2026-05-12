/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/


SET search_path = cm, public, public;
UPDATE config_param_system AS t SET label = v.label, descript = v.descript FROM (
	VALUES
	('admin_campaign_type', NULL, 'Variable per especificar quin tipus de campanya volem veure en crear-la'),
    ('basic_selector_tab_campaign', 'Variables selectores', 'Variable per configurar totes les opcions relacionades amb la cerca de la pestanya específica'),
    ('basic_selector_tab_lot', 'Variables selectores', 'Variable per configurar totes les opcions relacionades amb la cerca de la pestanya específica')
) AS v(parameter, label, descript)
WHERE t.parameter = v.parameter;

