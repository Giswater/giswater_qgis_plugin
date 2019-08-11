/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

/*
COMMENT ON TABLE config_api_toolbar_buttons IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table buttons on toolbar are configured.
The function gw_api_gettoolbarbuttons is called when session is started passing the list of project buttons. 
In function of role of user, buttons are parameters are passed to client';
*/

/*
COMMENT ON TABLE config_api_form IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table actions on form are configured
Actions are builded on form using this table, but not are activated
Actions are activated and configurated on tab. 
To activate and configurate actions please use config_api_form_tabs (not attributeTable) or config_api_list (attributeTable)';
*/

COMMENT ON TABLE config_api_form_fields IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table form fields are configured:
The function gw_api_get_formfields is called to build widget forms using this table.
formname: warning with formname. If it is used to work with listFilter fields tablename of an existing relation on database must be mandatory to put here
formtype: There are diferent formtypes:
	feature: the standard one. Used to show fields from feature tables
	info: used to build the infoplan widget
	visit: used on visit forms
	form: used on specific forms (search, mincut)
	catalog: used on catalog forms (workcat and featurecatalog)
	listfilter: used to filter list
	editbuttons:  buttons on form bottom used to edit (accept, cancel)
	navbuttons: buttons on form bottom used to navigate (goback....)
layout_id and layout_order, used to define the position';


COMMENT ON TABLE config_api_images IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table images on forms are configured:
To load a new image into this table use:
INSERT INTO config_api_images (idval, image) VALUES (''imagename'', pg_read_binary_file(''imagename.png'')::bytea)
Image must be located on the server (folder data of postgres instalation path. On linux /var/lib/postgresql/x.x/main, on windows postrgreSQL/x.x/data )';


COMMENT ON TABLE config_api_list IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table lists are configured. There are two types of lists: List on tabs and lists on attribute table
tablename must be mandatory to use a name of an existing relation on database. Code needs to identify the datatype of filter to work with
The field actionfields is required only for list on attribute table (listtype attributeTable). 
In case of different listtype actions must be defined on config_api_form_tabs';


COMMENT ON TABLE config_api_message IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table api messages are configured. The field mtype it means message type and there are two options. With feature or alone.
Using with feature the message is writted using the feature id before. Alone it means tha message is alone without nothing else merged';


COMMENT ON TABLE config_api_visit IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table visit are configured. Use it in combination with the om_visit_class table. Only visits with visitclass_id !=0 must be configured ';


COMMENT ON TABLE config_api_form_tabs IS 
'INSTRUCTIONS TO WORK WITH THIS TABLE:
With this table tabs on form are configured
Field actions is mandatory in exception of attributeTable. In case of attribute table actions must be defined on config_api_list';


COMMENT ON TABLE config_api_visit_x_featuretable
  IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is mandatory to relate table with visitclass. In case of offline funcionality client devices needs projects with tables related only with one visitclass, 
because on the previous download process only one visitclass form per layer stored on project will be downloaded. 
In case of only online projects more than one visitclass must be related to layer.'

