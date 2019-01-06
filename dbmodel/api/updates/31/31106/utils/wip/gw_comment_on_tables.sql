COMMENT ON TABLE SCHEMA_NAME.config_api_toolbar_buttons IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
With this table buttons on toolbar are configured.
The function gw_api_gettoolbarbuttons is called when session is started passing the list of project buttons. 
In function of role of user, buttons are parameters are passed to client';


COMMENT ON TABLE SCHEMA_NAME.config_api_form_actions IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
Wiht this table actions on form are configured
Actions are builded on form using this table, but not are activated
Actions are activated and configurated on tab. 
To activate and configurate actions please use config_api_form_tabs (not attributeTable) or config_api_list (attributeTable)';


COMMENT ON TABLE SCHEMA_NAME.config_api_form_fields IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
Wiht this table form fields are configured:
The function gw_api_get_formfields is called to build widget forms usint this table.
formname
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


COMMENT ON TABLE SCHEMA_NAME.config_api_images IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
Wiht this table images on forms are configured:
To load a new image into this table use:
INSERT INTO config_api_images (idval, image) VALUES (''imagename'', pg_read_binary_file(''imagename.png'')::bytea)
Image must be located on the server (folder data of postgres instalation path)';


COMMENT ON TABLE SCHEMA_NAME.config_api_list IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
With this table lists are configured. There are two types of lists: List on tabs and lists on attribute table
The field actionfields is required only for list on attribute table (listtype attributeTable). 
In case of different listtype actions must be defined on config_api_form_tabs';


COMMENT ON TABLE SCHEMA_NAME.config_api_message IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
With this table api messages are configured';


COMMENT ON TABLE SCHEMA_NAME.config_api_visit IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
With this table visit are configured. Use it in combination with the om_visit_class table. Only visits with visitclass_id !=0 must be configured ';


COMMENT ON TABLE SCHEMA_NAME.config_api_form_tabs IS 
'INSTRUCIONS TO WORK WITH THIS TABLE:
Wiht this table tabs on form are configured
Field actions is mandatory in exception of attributeTable. In case of attribute table actions must be defined on config_api_list';


