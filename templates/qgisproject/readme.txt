PROTOCOL TO CREATE CUSTOM TEMPLATES
-----------------------------------
1) Check QGIS project is what you like
	- Simbology
	- Variables
	- Layers and staff

2) Configure config/dev.config file
	- folder_path
	- labels
	WARNING: [xml_set] is no operative yet. Only works [text_replace]


3) Replace by hand only one time on project header for mapcanvas extent
      <xmin>__XMIN__</xmin>
      <ymin>__YMIN__</ymin>
      <xmax>__XMAX__</xmax>
      <ymax>__YMAX__</ymax>
	  
4) Execute CREATE QGIS TEMPLATE BUTTON (tab others on Giswater button). 
	WARNING: To see the button you need the variable devoloper_mode=TRUE on config/giswater.config
	
