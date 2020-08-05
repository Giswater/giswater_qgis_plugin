
# From api_parent.py
from qgis.core import QgsPointXY, QgsVectorLayer
from qgis.core import QgsExpression, QgsFeatureRequest, QgsGeometry
from qgis.gui import QgsVertexMarker, QgsMapToolEmitPoint, QgsDateTimeEdit
from qgis.PyQt.QtCore import Qt, QSettings, QTimer, QDate, QStringListModel
from qgis.PyQt.QtGui import QColor, QStandardItemModel, QStandardItem
from qgis.PyQt.QtWidgets import QLineEdit, QSizePolicy, QWidget, QComboBox, QGridLayout, QSpacerItem, QLabel, QCheckBox
from qgis.PyQt.QtWidgets import QCompleter, QToolButton, QFrame, QSpinBox, QDoubleSpinBox, QDateEdit, QAction
from qgis.PyQt.QtWidgets import QTableView, QTabWidget, QPushButton, QTextEdit, QApplication
from qgis.PyQt.QtSql import QSqlTableModel

import os
import re
import subprocess
import sys
import webbrowser
from functools import partial

from .. import global_vars
from lib import qt_tools
from ..actions.HyperLinkLabel import HyperLinkLabel
from ..map_tools.snapping_utils_v3 import SnappingConfigManager
from ..ui_manager import DialogTextUi

# From parent.py
from qgis.core import QgsCategorizedSymbolRenderer, QgsExpression, QgsFeatureRequest, QgsGeometry, QgsPointLocator, \
	QgsPointXY, QgsProject, QgsRectangle, QgsRendererCategory,  QgsSimpleFillSymbolLayer, QgsSnappingConfig, QgsSymbol, \
	QgsVectorLayer
from qgis.gui import QgsRubberBand
from qgis.PyQt.QtCore import Qt, QDate, QStringListModel, QTimer
from qgis.PyQt.QtWidgets import QGroupBox, QAbstractItemView, QTableView, QFileDialog, QApplication, QCompleter, \
	QAction, QWidget, QComboBox, QCheckBox, QPushButton, QLineEdit, QDoubleSpinBox, QTextEdit
from qgis.PyQt.QtGui import QIcon, QColor, QCursor, QPixmap
from qgis.PyQt.QtSql import QSqlTableModel, QSqlQueryModel

import random
import configparser
import os
import re
import subprocess
import sys
import webbrowser
if 'nt' in sys.builtin_module_names:
	import ctypes

from functools import partial

from .. import global_vars
from lib import qt_tools
from ..actions.add_layer import AddLayer
from ..map_tools.snapping_utils_v3 import SnappingConfigManager

from ..ui_manager import DialogTextUi, GwDialog, GwMainWindow


class ParentUtils:
	
	def __init__(self, iface, settings, controller, plugin_dir):
		
		# From parent.py
		self.iface = iface
		self.canvas = self.iface.mapCanvas()
		self.settings = settings
		self.controller = controller
		self.plugin_dir = plugin_dir
		self.dao = self.controller.dao
		self.schema_name = self.controller.schema_name
		self.project_type = None
		self.plugin_version = self.get_plugin_version()
		self.add_layer = AddLayer(iface, settings, controller, plugin_dir)
		self.user_current_layer = None
		self.rubber_point = None
		self.rubber_polygon = None
		
		# From api_parent.py
		self.dlg_is_destroyed = None
		self.tabs_removed = 0
		self.tab_type = None
		self.list_update = []
		self.temp_layers_added = []
	
	
	# From parent.py
	def init_rubber_polygon(self):
	
		try:
			self.rubber_polygon = QgsRubberBand(self.canvas, 2)
			self.rubber_polygon.setColor(Qt.darkRed)
			self.rubber_polygon.setIconSize(20)
		except:
			pass
	
	
	def init_rubber_point(self):
		try:
			self.rubber_point = QgsRubberBand(self.canvas, 0)
			self.rubber_point.setColor(Qt.yellow)
			self.rubber_point.setIconSize(10)
		except:
			pass
	
	
	def set_controller(self, controller):
		""" Set controller class """
		
		self.controller = controller
		self.schema_name = self.controller.schema_name
	
	
	def open_web_browser(self, dialog, widget=None):
		""" Display url using the default browser """
		
		if widget is not None:
			url = qt_tools.getWidgetText(dialog, widget)
			if url == 'null':
				url = 'http://www.giswater.org'
		else:
			url = 'http://www.giswater.org'
		
		webbrowser.open(url)
	
	
	def get_plugin_version(self):
		""" Get plugin version from metadata.txt file """
		
		# Check if metadata file exists
		metadata_file = os.path.join(self.plugin_dir, 'metadata.txt')
		if not os.path.exists(metadata_file):
			message = "Metadata file not found"
			self.controller.show_warning(message, parameter=metadata_file)
			return None
		
		metadata = configparser.ConfigParser()
		metadata.read(metadata_file)
		plugin_version = metadata.get('general', 'version')
		if plugin_version is None:
			message = "Plugin version not found"
			self.controller.show_warning(message)
		
		return plugin_version
	
	
	def get_file_dialog(self, dialog, widget):
		""" Get file dialog """
		
		# Check if selected file exists. Set default value if necessary
		file_path = qt_tools.getWidgetText(dialog, widget)
		if file_path is None or file_path == 'null' or not os.path.exists(str(file_path)):
			folder_path = self.plugin_dir
		else:
			folder_path = os.path.dirname(file_path)
			
			# Open dialog to select file
		os.chdir(folder_path)
		file_dialog = QFileDialog()
		file_dialog.setFileMode(QFileDialog.AnyFile)
		message = "Select file"
		folder_path, filter_ = file_dialog.getOpenFileName(parent=None, caption=self.controller.tr(message))
		if folder_path:
			qt_tools.setWidgetText(dialog, widget, str(folder_path))
	
	
	def get_folder_dialog(self, dialog, widget):
		""" Get folder dialog """
		
		# Check if selected folder exists. Set default value if necessary
		folder_path = qt_tools.getWidgetText(dialog, widget)
		if folder_path is None or folder_path == 'null' or not os.path.exists(folder_path):
			folder_path = os.path.expanduser("~")
		
		# Open dialog to select folder
		os.chdir(folder_path)
		file_dialog = QFileDialog()
		file_dialog.setFileMode(QFileDialog.Directory)
		message = "Select folder"
		folder_path = file_dialog.getExistingDirectory(
			parent=None, caption=self.controller.tr(message), directory=folder_path)
		if folder_path:
			qt_tools.setWidgetText(dialog, widget, str(folder_path))
	
	
	def load_settings(self, dialog=None):
		""" Load QGIS settings related with dialog position and size """
		
		if dialog is None:
			dialog = self.dlg
		
		try:
			x = self.controller.plugin_settings_value(dialog.objectName() + "_x")
			y = self.controller.plugin_settings_value(dialog.objectName() + "_y")
			width = self.controller.plugin_settings_value(dialog.objectName() + "_width", dialog.property('width'))
			height = self.controller.plugin_settings_value(dialog.objectName() + "_height", dialog.property('height'))
			
			if int(x) < 0 or int(y) < 0:
				dialog.resize(int(width), int(height))
			else:
				screens = ctypes.windll.user32
				screen_x = screens.GetSystemMetrics(78)
				screen_y = screens.GetSystemMetrics(79)
				if int(x) > screen_x:
					x = int(screen_x) - int(width)
				if int(y) > screen_y:
					y = int(screen_y)
				dialog.setGeometry(int(x), int(y), int(width), int(height))
		except:
			pass
	
	
	def save_settings(self, dialog=None):
		""" Save QGIS settings related with dialog position and size """
		
		if dialog is None:
			dialog = self.dlg
		
		self.controller.plugin_settings_set_value(dialog.objectName() + "_width", dialog.property('width'))
		self.controller.plugin_settings_set_value(dialog.objectName() + "_height", dialog.property('height'))
		self.controller.plugin_settings_set_value(dialog.objectName() + "_x", dialog.pos().x() + 8)
		self.controller.plugin_settings_set_value(dialog.objectName() + "_y", dialog.pos().y() + 31)
	
	
	def get_last_tab(self, dialog, selector_name):
		""" Get the name of the last tab used by the user from QSettings()
		:param dialog: QDialog
		:param selector_name: Name of the selector (String)
		:return: Name of the last tab used by the user (string)
		"""
		
		tab_name = self.controller.plugin_settings_value(f"{dialog.objectName()}_{selector_name}")
		return tab_name
	
	
	def save_current_tab(self, dialog, tab_widget, selector_name):
		""" Save the name of current tab used by the user into QSettings()
		:param dialog: QDialog
		:param tab_widget:  QTabWidget
		:param selector_name: Name of the selector (String)
		"""
		
		index = tab_widget.currentIndex()
		tab = tab_widget.widget(index)
		if tab:
			tab_name = tab.objectName()
			dlg_name = dialog.objectName()
			self.controller.plugin_settings_set_value(f"{dlg_name}_{selector_name}", tab_name)
	
	
	def open_dialog(self, dlg=None, dlg_name=None, info=True, maximize_button=True, stay_on_top=True, title=None):
		""" Open dialog """
		
		# Check database connection before opening dialog
		if not self.controller.check_db_connection():
			return
		
		if dlg is None or type(dlg) is bool:
			dlg = self.dlg
		
		# Set window title
		if title is not None:
			dlg.setWindowTitle(title)
		else:
			if dlg_name:
				self.controller.manage_translation(dlg_name, dlg)
		
		# Manage stay on top, maximize/minimize button and information button
		# if info is True maximize flag will be ignored
		# To enable maximize button you must set info to False
		flags = Qt.WindowCloseButtonHint
		if info:
			flags |= Qt.WindowSystemMenuHint | Qt.WindowContextHelpButtonHint
		else:
			if maximize_button:
				flags |= Qt.WindowMinMaxButtonsHint
		
		if stay_on_top:
			flags |= Qt.WindowStaysOnTopHint
		
		dlg.setWindowFlags(flags)
		
		# Open dialog
		if issubclass(type(dlg), GwDialog):
			dlg.open()
		elif issubclass(type(dlg), GwMainWindow):
			dlg.show()
		else:
			dlg.show()
	
	
	def close_dialog(self, dlg=None):
		""" Close dialog """
		
		if dlg is None or type(dlg) is bool:
			dlg = self.dlg
		try:
			self.save_settings(dlg)
			dlg.close()
			map_tool = self.canvas.mapTool()
			# If selected map tool is from the plugin, set 'Pan' as current one
			if map_tool.toolName() == '':
				self.iface.actionPan().trigger()
		except AttributeError:
			pass
		except Exception as e:
			self.controller.log_info(type(e).__name__)
	
	
	def multi_row_selector(self, dialog, tableleft, tableright, field_id_left, field_id_right, name='name',
						   hide_left=[0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
									  23, 24, 25, 26, 27, 28, 29, 30], hide_right=[1, 2, 3], aql=""):
		"""
		:param dialog:
		:param tableleft: Table to consult and load on the left side
		:param tableright: Table to consult and load on the right side
		:param field_id_left: ID field of the left table
		:param field_id_right: ID field of the right table
		:param name: field name (used in add_lot.py)
		:param hide_left: Columns to hide from the left table
		:param hide_right: Columns to hide from the right table
		:param aql: (add query left) Query added to the left side (used in basic.py def basic_exploitation_selector())
		:return:
		"""
		
		# fill QTableView all_rows
		tbl_all_rows = dialog.findChild(QTableView, "all_rows")
		tbl_all_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
		schema_name = self.schema_name.replace('"', '')
		query_left = f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
		query_left += f"(SELECT {schema_name}.{tableleft}.{name} FROM {schema_name}.{tableleft}"
		query_left += f" RIGHT JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"
		query_left += f" WHERE cur_user = current_user)"
		query_left += f" AND  {field_id_left} > -1"
		query_left += aql
		
		self.fill_table_by_query(tbl_all_rows, query_left + f" ORDER BY {name};")
		self.hide_colums(tbl_all_rows, hide_left)
		tbl_all_rows.setColumnWidth(1, 200)
		
		# fill QTableView selected_rows
		tbl_selected_rows = dialog.findChild(QTableView, "selected_rows")
		tbl_selected_rows.setSelectionBehavior(QAbstractItemView.SelectRows)
		
		query_right = f"SELECT {tableleft}.{name}, cur_user, {tableleft}.{field_id_left}, {tableright}.{field_id_right}"
		query_right += f" FROM {schema_name}.{tableleft}"
		query_right += f" JOIN {schema_name}.{tableright} ON {tableleft}.{field_id_left} = {tableright}.{field_id_right}"
		
		query_right += " WHERE cur_user = current_user"
		
		self.fill_table_by_query(tbl_selected_rows, query_right + f" ORDER BY {name};")
		self.hide_colums(tbl_selected_rows, hide_right)
		tbl_selected_rows.setColumnWidth(0, 200)
		
		# Button select
		dialog.btn_select.clicked.connect(partial(self.multi_rows_selector, tbl_all_rows, tbl_selected_rows,
												  field_id_left, tableright, field_id_right, query_left, query_right, field_id_right))
		
		# Button unselect
		query_delete = f"DELETE FROM {schema_name}.{tableright}"
		query_delete += f" WHERE current_user = cur_user AND {tableright}.{field_id_right}="
		dialog.btn_unselect.clicked.connect(partial(self.unselector, tbl_all_rows, tbl_selected_rows, query_delete,
													query_left, query_right, field_id_right))
		
		# QLineEdit
		dialog.txt_name.textChanged.connect(partial(self.query_like_widget_text, dialog, dialog.txt_name,
													tbl_all_rows, tableleft, tableright, field_id_right, field_id_left, name, aql))
		
		# Order control
		tbl_all_rows.horizontalHeader().sectionClicked.connect(partial(self.order_by_column, tbl_all_rows, query_left))
		tbl_selected_rows.horizontalHeader().sectionClicked.connect(
			partial(self.order_by_column, tbl_selected_rows, query_right))
	
	
	def order_by_column(self, qtable, query, idx):
		"""
		:param qtable: QTableView widget
		:param query: Query for populate QsqlQueryModel
		:param idx: The index of the clicked column
		:return:
		"""
		oder_by = {0: "ASC", 1: "DESC"}
		sort_order = qtable.horizontalHeader().sortIndicatorOrder()
		col_to_sort = qtable.model().headerData(idx, Qt.Horizontal)
		query += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
		self.fill_table_by_query(qtable, query)
		self.refresh_map_canvas()
	
	
	def hide_colums(self, widget, comuns_to_hide):
		for i in range(0, len(comuns_to_hide)):
			widget.hideColumn(comuns_to_hide[i])
	
	
	def unselector(self, qtable_left, qtable_right, query_delete, query_left, query_right, field_id_right):
		
		selected_list = qtable_right.selectionModel().selectedRows()
		if len(selected_list) == 0:
			message = "Any record selected"
			self.controller.show_warning(message)
			return
		expl_id = []
		for i in range(0, len(selected_list)):
			row = selected_list[i].row()
			id_ = str(qtable_right.model().record(row).value(field_id_right))
			expl_id.append(id_)
		for i in range(0, len(expl_id)):
			self.controller.execute_sql(query_delete + str(expl_id[i]))
		
		# Refresh
		oder_by = {0: "ASC", 1: "DESC"}
		sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
		idx = qtable_left.horizontalHeader().sortIndicatorSection()
		col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
		query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
		self.fill_table_by_query(qtable_left, query_left)
		
		sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
		idx = qtable_right.horizontalHeader().sortIndicatorSection()
		col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
		query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
		self.fill_table_by_query(qtable_right, query_right)
		self.refresh_map_canvas()
	
	
	def multi_rows_selector(self, qtable_left, qtable_right, id_ori,
							tablename_des, id_des, query_left, query_right, field_id):
		"""
			:param qtable_left: QTableView origin
			:param qtable_right: QTableView destini
			:param id_ori: Refers to the id of the source table
			:param tablename_des: table destini
			:param id_des: Refers to the id of the target table, on which the query will be made
			:param query_right:
			:param query_left:
			:param field_id:
		"""
		
		selected_list = qtable_left.selectionModel().selectedRows()
		
		if len(selected_list) == 0:
			message = "Any record selected"
			self.controller.show_warning(message)
			return
		expl_id = []
		curuser_list = []
		for i in range(0, len(selected_list)):
			row = selected_list[i].row()
			id_ = qtable_left.model().record(row).value(id_ori)
			expl_id.append(id_)
			curuser = qtable_left.model().record(row).value("cur_user")
			curuser_list.append(curuser)
		for i in range(0, len(expl_id)):
			# Check if expl_id already exists in expl_selector
			sql = (f"SELECT DISTINCT({id_des}, cur_user)"
				   f" FROM {tablename_des}"
				   f" WHERE {id_des} = '{expl_id[i]}' AND cur_user = current_user")
			row = self.controller.get_row(sql)
			
			if row:
				# if exist - show warning
				message = "Id already selected"
				self.controller.show_info_box(message, "Info", parameter=str(expl_id[i]))
			else:
				sql = (f"INSERT INTO {tablename_des} ({field_id}, cur_user) "
					   f" VALUES ({expl_id[i]}, current_user)")
				self.controller.execute_sql(sql)
		
		# Refresh
		oder_by = {0: "ASC", 1: "DESC"}
		sort_order = qtable_left.horizontalHeader().sortIndicatorOrder()
		idx = qtable_left.horizontalHeader().sortIndicatorSection()
		col_to_sort = qtable_left.model().headerData(idx, Qt.Horizontal)
		query_left += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
		self.fill_table_by_query(qtable_right, query_right)
		
		sort_order = qtable_right.horizontalHeader().sortIndicatorOrder()
		idx = qtable_right.horizontalHeader().sortIndicatorSection()
		col_to_sort = qtable_right.model().headerData(idx, Qt.Horizontal)
		query_right += f" ORDER BY {col_to_sort} {oder_by[sort_order]}"
		self.fill_table_by_query(qtable_left, query_left)
		self.refresh_map_canvas()
	
	
	def fill_table(self, widget, table_name, set_edit_strategy=QSqlTableModel.OnManualSubmit, expr_filter=None):
		""" Set a model with selected filter.
		Attach that model to selected table """
		
		if self.schema_name not in table_name:
			table_name = self.schema_name + "." + table_name
		
		# Set model
		self.model = QSqlTableModel()
		self.model.setTable(table_name)
		self.model.setEditStrategy(set_edit_strategy)
		self.model.setSort(0, 0)
		self.model.select()
		
		# Check for errors
		if self.model.lastError().isValid():
			self.controller.show_warning(self.model.lastError().text())
		
		# Attach model to table view
		widget.setModel(self.model)
		if expr_filter:
			widget.model().setFilter(expr_filter)
	
	
	def fill_table_by_query(self, qtable, query):
		"""
		:param qtable: QTableView to show
		:param query: query to set model
		"""
		
		model = QSqlQueryModel()
		model.setQuery(query)
		qtable.setModel(model)
		qtable.show()
		
		# Check for errors
		if model.lastError().isValid():
			self.controller.show_warning(model.lastError().text())
	
	
	def query_like_widget_text(self, dialog, text_line, qtable, tableleft, tableright, field_id_r, field_id_l,
							   name='name', aql=''):
		""" Fill the QTableView by filtering through the QLineEdit"""
		
		schema_name = self.schema_name.replace('"', '')
		query = qt_tools.getWidgetText(dialog, text_line, return_string_null=False).lower()
		sql = (f"SELECT * FROM {schema_name}.{tableleft} WHERE {name} NOT IN "
			   f"(SELECT {tableleft}.{name} FROM {schema_name}.{tableleft}"
			   f" RIGHT JOIN {schema_name}.{tableright}"
			   f" ON {tableleft}.{field_id_l} = {tableright}.{field_id_r}"
			   f" WHERE cur_user = current_user) AND LOWER({name}::text) LIKE '%{query}%'"
			   f"  AND  {field_id_l} > -1")
		sql += aql
		self.fill_table_by_query(qtable, sql)
	
	
	def set_icon(self, widget, icon):
		""" Set @icon to selected @widget """
		
		# Get icons folder
		icons_folder = os.path.join(self.plugin_dir, 'icons')
		icon_path = os.path.join(icons_folder, str(icon) + ".png")
		if os.path.exists(icon_path):
			widget.setIcon(QIcon(icon_path))
		else:
			self.controller.log_info("File not found", parameter=icon_path)
	
	
	def check_expression(self, expr_filter, log_info=False):
		""" Check if expression filter @expr_filter is valid """
		
		if log_info:
			self.controller.log_info(expr_filter)
		expr = QgsExpression(expr_filter)
		if expr.hasParserError():
			message = "Expression Error"
			self.controller.log_warning(message, parameter=expr_filter)
			return False, expr
		
		return True, expr
	
	
	def refresh_map_canvas(self, restore_cursor=False):
		""" Refresh all layers present in map canvas """
		
		self.canvas.refreshAllLayers()
		for layer_refresh in self.canvas.layers():
			layer_refresh.triggerRepaint()
		
		if restore_cursor:
			self.set_cursor_restore()
	
	
	def set_cursor_wait(self):
		""" Change cursor to 'WaitCursor' """
		QApplication.setOverrideCursor(Qt.WaitCursor)
	
	
	def set_cursor_restore(self):
		""" Restore to previous cursors """
		QApplication.restoreOverrideCursor()
	
	
	def get_cursor_multiple_selection(self):
		""" Set cursor for multiple selection """
		
		path_folder = os.path.join(os.path.dirname(__file__), os.pardir)
		path_cursor = os.path.join(path_folder, 'icons', '201.png')
		if os.path.exists(path_cursor):
			cursor = QCursor(QPixmap(path_cursor))
		else:
			cursor = QCursor(Qt.ArrowCursor)
		
		return cursor
	
	
	def set_table_columns(self, dialog, widget, table_name, sort_order=0, isQStandardItemModel=False, schema_name=None):
		""" Configuration of tables. Set visibility and width of columns """
		
		widget = qt_tools.getWidget(dialog, widget)
		if not widget:
			return
		
		if schema_name is not None:
			config_table = f"{schema_name}.config_form_tableview"
		else:
			config_table = f"config_form_tableview"
		
		# Set width and alias of visible columns
		columns_to_delete = []
		sql = (f"SELECT columnindex, width, alias, status"
			   f" FROM {config_table}"
			   f" WHERE tablename = '{table_name}'"
			   f" ORDER BY columnindex")
		rows = self.controller.get_rows(sql, log_info=False)
		if not rows:
			return
		
		for row in rows:
			if not row['status']:
				columns_to_delete.append(row['columnindex'] - 1)
			else:
				width = row['width']
				if width is None:
					width = 100
				widget.setColumnWidth(row['columnindex'] - 1, width)
				widget.model().setHeaderData(row['columnindex'] - 1, Qt.Horizontal, row['alias'])
		
		# Set order
		if isQStandardItemModel:
			widget.model().sort(sort_order, Qt.AscendingOrder)
		else:
			widget.model().setSort(sort_order, Qt.AscendingOrder)
			widget.model().select()
		# Delete columns
		for column in columns_to_delete:
			widget.hideColumn(column)
		
		return widget
	
	
	def connect_signal_selection_changed(self, option):
		""" Connect signal selectionChanged """
		
		try:
			if option == "mincut_connec":
				self.canvas.selectionChanged.connect(partial(self.snapping_selection_connec))
			elif option == "mincut_hydro":
				self.canvas.selectionChanged.connect(partial(self.snapping_selection_hydro))
		except Exception:
			pass
	
	
	def disconnect_signal_selection_changed(self):
		""" Disconnect signal selectionChanged """
		
		try:
			self.canvas.selectionChanged.disconnect()
		except Exception:
			pass
		finally:
			self.iface.actionPan().trigger()
	
	
	def set_label_current_psector(self, dialog):
		
		sql = ("SELECT t1.name FROM plan_psector AS t1 "
			   " INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value "
			   " WHERE t2.parameter='plan_psector_vdefault' AND cur_user = current_user")
		row = self.controller.get_row(sql)
		if not row:
			return
		qt_tools.setWidgetText(dialog, 'lbl_vdefault_psector', row[0])
	
	
	def multi_rows_delete(self, widget, table_name, column_id):
		""" Delete selected elements of the table
		:param QTableView widget: origin
		:param table_name: table origin
		:param column_id: Refers to the id of the source table
		"""
		
		# Get selected rows
		selected_list = widget.selectionModel().selectedRows()
		if len(selected_list) == 0:
			message = "Any record selected"
			self.controller.show_warning(message)
			return
		
		inf_text = ""
		list_id = ""
		for i in range(0, len(selected_list)):
			row = selected_list[i].row()
			id_ = widget.model().record(row).value(str(column_id))
			inf_text += f"{id_}, "
			list_id += f"'{id_}', "
		inf_text = inf_text[:-2]
		list_id = list_id[:-2]
		message = "Are you sure you want to delete these records?"
		title = "Delete records"
		answer = self.controller.ask_question(message, title, inf_text)
		if answer:
			sql = f"DELETE FROM {table_name}"
			sql += f" WHERE {column_id} IN ({list_id})"
			self.controller.execute_sql(sql)
			widget.model().select()
	
	
	def select_features_by_expr(self, layer, expr):
		""" Select features of @layer applying @expr """
		
		if not layer:
			return
		
		if expr is None:
			layer.removeSelection()
		else:
			it = layer.getFeatures(QgsFeatureRequest(expr))
			# Build a list of feature id's from the previous result and select them
			id_list = [i.id() for i in it]
			if len(id_list) > 0:
				layer.selectByIds(id_list)
			else:
				layer.removeSelection()
	
	
	def hide_void_groupbox(self, dialog):
		""" Hide empty groupbox """
		
		grb_list = {}
		grbox_list = dialog.findChildren(QGroupBox)
		for grbox in grbox_list:
			
			widget_list = grbox.findChildren(QWidget)
			if len(widget_list) == 0:
				grb_list[grbox.objectName()] = 0
				grbox.setVisible(False)
		
		return grb_list
	
	
	def zoom_to_selected_features(self, layer, geom_type=None, zoom=None):
		""" Zoom to selected features of the @layer with @geom_type """
		
		if not layer:
			return
		
		self.iface.setActiveLayer(layer)
		self.iface.actionZoomToSelected().trigger()
		
		if geom_type:
			
			# Set scale = scale_zoom
			if geom_type in ('node', 'connec', 'gully'):
				scale = self.scale_zoom
			
			# Set scale = max(current_scale, scale_zoom)
			elif geom_type == 'arc':
				scale = self.iface.mapCanvas().scale()
				if int(scale) < int(self.scale_zoom):
					scale = self.scale_zoom
			else:
				scale = 5000
			
			if zoom is not None:
				scale = zoom
			
			self.iface.mapCanvas().zoomScale(float(scale))
	
	
	def make_list_for_completer(self, sql):
		""" Prepare a list with the necessary items for the completer
		:param sql: Query to be executed, where will we get the list of items (string)
		:return list_items: List with the result of the query executed (List) ["item1","item2","..."]
		"""
		
		rows = self.controller.get_rows(sql)
		list_items = []
		if rows:
			for row in rows:
				list_items.append(str(row[0]))
		return list_items
	
	
	def set_completer_lineedit(self, qlineedit, list_items):
		""" Set a completer into a QLineEdit
		:param qlineedit: Object where to set the completer (QLineEdit)
		:param list_items: List of items to set into the completer (List)["item1","item2","..."]
		"""
		
		completer = QCompleter()
		completer.setCaseSensitivity(Qt.CaseInsensitive)
		completer.setMaxVisibleItems(10)
		completer.setCompletionMode(0)
		completer.setFilterMode(Qt.MatchContains)
		completer.popup().setStyleSheet("color: black;")
		qlineedit.setCompleter(completer)
		model = QStringListModel()
		model.setStringList(list_items)
		completer.setModel(model)
	
	
	def get_max_rectangle_from_coords(self, list_coord):
		""" Returns the minimum rectangle(x1, y1, x2, y2) of a series of coordinates
		:type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
		"""
		
		coords = list_coord.group(1)
		polygon = coords.split(',')
		x, y = polygon[0].split(' ')
		min_x = x  # start with something much higher than expected min
		min_y = y
		max_x = x  # start with something much lower than expected max
		max_y = y
		for i in range(0, len(polygon)):
			x, y = polygon[i].split(' ')
			if x < min_x:
				min_x = x
			if x > max_x:
				max_x = x
			if y < min_y:
				min_y = y
			if y > max_y:
				max_y = y
		
		return max_x, max_y, min_x, min_y
	
	
	def zoom_to_rectangle(self, x1, y1, x2, y2, margin=5):
		
		rect = QgsRectangle(float(x1) - margin, float(y1) - margin, float(x2) + margin, float(y2) + margin)
		self.canvas.setExtent(rect)
		self.canvas.refresh()
	
	
	def create_action(self, action_name, action_group, icon_num=None, text=None):
		""" Creates a new action with selected parameters """
		
		icon = None
		icon_folder = self.plugin_dir + '/icons/'
		icon_path = icon_folder + icon_num + '.png'
		if os.path.exists(icon_path):
			icon = QIcon(icon_path)
		
		if icon is None:
			action = QAction(text, action_group)
		else:
			action = QAction(icon, text, action_group)
		action.setObjectName(action_name)
		
		return action
	
	
	def set_wait_cursor(self):
		QApplication.instance().setOverrideCursor(Qt.WaitCursor)
	
	
	def set_arrow_cursor(self):
		QApplication.instance().setOverrideCursor(Qt.ArrowCursor)
	
	
	def delete_layer_from_toc(self, layer_name):
		""" Delete layer from toc if exist """
		
		layer = None
		for lyr in list(QgsProject.instance().mapLayers().values()):
			if lyr.name() == layer_name:
				layer = lyr
				break
		if layer is not None:
			# Remove layer
			QgsProject.instance().removeMapLayer(layer)
			
			# Remove group if is void
			root = QgsProject.instance().layerTreeRoot()
			group = root.findGroup('GW Temporal Layers')
			if group:
				layers = group.findLayers()
				if not layers:
					root.removeChildNode(group)
			self.delete_layer_from_toc(layer_name)
	
	
	def create_body(self, form='', feature='', filter_fields='', extras=None):
		""" Create and return parameters as body to functions"""
		
		client = f'$${{"client":{{"device":4, "infoType":1, "lang":"ES"}}, '
		form = f'"form":{{{form}}}, '
		feature = f'"feature":{{{feature}}}, '
		filter_fields = f'"filterFields":{{{filter_fields}}}'
		page_info = f'"pageInfo":{{}}'
		data = f'"data":{{{filter_fields}, {page_info}'
		if extras is not None:
			data += ', ' + extras
		data += f'}}}}$$'
		body = "" + client + form + feature + data
		
		return body
	
	
	def get_composers_list(self):
		
		layour_manager = QgsProject.instance().layoutManager().layouts()
		active_composers = [layout for layout in layour_manager]
		return active_composers
	
	
	def get_composer_index(self, name):
		
		index = 0
		composers = self.get_composers_list()
		for comp_view in composers:
			composer_name = comp_view.name()
			if composer_name == name:
				break
			index += 1
		
		return index
	
	
	def set_restriction(self, dialog, widget_to_ignore, restriction):
		"""
		Set all widget enabled(False) or readOnly(True) except those on the tuple
		:param dialog:
		:param widget_to_ignore: tuple = ('widgetname1', 'widgetname2', 'widgetname3', ...)
		:param restriction: roles that do not have access. tuple = ('role1', 'role1', 'role1', ...)
		:return:
		"""
		
		project_vars = global_vars.get_project_vars()
		role = project_vars['role']
		role = self.controller.get_restriction(role)
		if role in restriction:
			widget_list = dialog.findChildren(QWidget)
			for widget in widget_list:
				if widget.objectName() in widget_to_ignore:
					continue
				# Set editable/readonly
				if type(widget) in (QLineEdit, QDoubleSpinBox, QTextEdit):
					widget.setReadOnly(True)
					widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
				elif type(widget) in (QComboBox, QCheckBox, QTableView, QPushButton):
					widget.setEnabled(False)
	
	
	def set_dates_from_to(self, widget_from, widget_to, table_name, field_from, field_to):
		
		sql = (f"SELECT MIN(LEAST({field_from}, {field_to})),"
			   f" MAX(GREATEST({field_from}, {field_to}))"
			   f" FROM {table_name}")
		row = self.controller.get_row(sql, log_sql=False)
		current_date = QDate.currentDate()
		if row:
			if row[0]:
				widget_from.setDate(row[0])
			else:
				widget_from.setDate(current_date)
			if row[1]:
				widget_to.setDate(row[1])
			else:
				widget_to.setDate(current_date)
	
	
	def get_values_from_catalog(self, table_name, typevalue, order_by='id'):
		
		sql = (f"SELECT id, idval"
			   f" FROM {table_name}"
			   f" WHERE typevalue = '{typevalue}'"
			   f" ORDER BY {order_by}")
		rows = self.controller.get_rows(sql)
		return rows
	
	
	def integer_validator(self, value, widget, btn_accept):
		""" Check if the value is an integer or not.
			This function is called in def set_datatype_validator(self, value, widget, btn)
			widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn)
		"""
		
		if value is None or bool(re.search("^\d*$", value)):
			widget.setStyleSheet(None)
			btn_accept.setEnabled(True)
		else:
			widget.setStyleSheet("border: 1px solid red")
			btn_accept.setEnabled(False)
	
	
	def double_validator(self, value, widget, btn_accept):
		""" Check if the value is double or not.
			This function is called in def set_datatype_validator(self, value, widget, btn)
			widget = getattr(self, f"{widget.property('datatype')}_validator")( value, widget, btn)
		"""
		
		if value is None or bool(re.search("^\d*$", value)) or bool(re.search("^\d+\.\d+$", value)):
			widget.setStyleSheet(None)
			btn_accept.setEnabled(True)
		else:
			widget.setStyleSheet("border: 1px solid red")
			btn_accept.setEnabled(False)
	
	
	def open_file_path(self, filter_="All (*.*)"):
		""" Open QFileDialog """
		msg = self.controller.tr("Select DXF file")
		path, filter_ = QFileDialog.getOpenFileName(None, msg, "", filter_)
		
		return path, filter_
	
	
	def show_exceptions_msg(self, title, msg=""):
		
		cat_exception = {'KeyError': 'Key on returned json from ddbb is missed.'}
		self.dlg_info = DialogTextUi()
		self.dlg_info.btn_accept.setVisible(False)
		self.dlg_info.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_info))
		self.dlg_info.setWindowTitle(title)
		qt_tools.setWidgetText(self.dlg_info, self.dlg_info.txt_infolog, msg)
		self.open_dialog(self.dlg_info, dlg_name='dialog_text')
	
	
	def put_combobox(self, qtable, rows, field, widget_pos, combo_values):
		""" Set one column of a QtableView as QComboBox with values from database.
		:param qtable: QTableView to fill
		:param rows: List of items to set QComboBox (["..", "..."])
		:param field: Field to set QComboBox (String)
		:param widget_pos: Position of the column where we want to put the QComboBox (integer)
		:param combo_values: List of items to populate QComboBox (["..", "..."])
		:return:
		"""
		
		for x in range(0, len(rows)):
			combo = QComboBox()
			row = rows[x]
			# Populate QComboBox
			qt_tools.set_item_data(combo, combo_values, 1)
			# Set QCombobox to wanted item
			qt_tools.set_combo_itemData(combo, str(row[field]), 1)
			# Get index and put QComboBox into QTableView at index position
			idx = qtable.model().index(x, widget_pos)
			qtable.setIndexWidget(idx, combo)
			combo.currentIndexChanged.connect(partial(self.update_status, combo, qtable, x, widget_pos))
	
	
	def update_status(self, combo, qtable, pos_x, widget_pos):
		""" Update values from QComboBox to QTableView
		:param combo: QComboBox from which we will take the value
		:param qtable: QTableView Where update values
		:param pos_x: Position of the row where we want to update value (integer)
		:param widget_pos:Position of the widget where we want to update value (integer)
		:return:
		"""
		
		elem = combo.itemData(combo.currentIndex())
		i = qtable.model().index(pos_x, widget_pos)
		qtable.model().setData(i, elem[0])
		i = qtable.model().index(pos_x, widget_pos + 1)
		qtable.model().setData(i, elem[1])
	
	
	def get_feature_by_id(self, layer, id_, field_id):
		
		expr = "" + str(field_id) + "= '" + str(id_) + "'"
		features = layer.getFeatures(QgsFeatureRequest().setFilterExpression(expr))
		for feature in features:
			if str(feature[field_id]) == str(id_):
				return feature
		return False
	
	
	def document_insert(self, dialog, tablename, field, field_value):
		""" Insert a document related to the current visit
		:param dialog: (QDialog )
		:param tablename: Name of the table to make the queries (string)
		:param field: Field of the table to make the where clause (string)
		:param field_value: Value to compare in the clause where (string)
		"""
		
		doc_id = dialog.doc_id.text()
		if not doc_id:
			message = "You need to insert doc_id"
			self.controller.show_warning(message)
			return
		
		# Check if document already exist
		sql = (f"SELECT doc_id"
			   f" FROM {tablename}"
			   f" WHERE doc_id = '{doc_id}' AND {field} = '{field_value}'")
		row = self.controller.get_row(sql)
		if row:
			msg = "Document already exist"
			self.controller.show_warning(msg)
			return
		
		# Insert into new table
		sql = (f"INSERT INTO {tablename} (doc_id, {field})"
			   f" VALUES ('{doc_id}', '{field_value}')")
		status = self.controller.execute_sql(sql)
		if status:
			message = "Document inserted successfully"
			self.controller.show_info(message)
		
		dialog.tbl_document.model().select()
	
	
	def document_open(self, qtable):
		""" Open selected document """
		
		# Get selected rows
		field_index = qtable.model().fieldIndex('path')
		selected_list = qtable.selectionModel().selectedRows(field_index)
		if not selected_list:
			message = "Any record selected"
			self.controller.show_info_box(message)
			return
		elif len(selected_list) > 1:
			message = "More then one document selected. Select just one document."
			self.controller.show_warning(message)
			return
		
		path = selected_list[0].data()
		# Check if file exist
		if os.path.exists(path):
			# Open the document
			if sys.platform == "win32":
				os.startfile(path)
			else:
				opener = "open" if sys.platform == "darwin" else "xdg-open"
				subprocess.call([opener, path])
		else:
			webbrowser.open(path)
	
	
	def document_delete(self, qtable, tablename):
		""" Delete record from selected rows in tbl_document """
		
		# Get selected rows. 0 is the column of the pk 0 'id'
		selected_list = qtable.selectionModel().selectedRows(0)
		if len(selected_list) == 0:
			message = "Any record selected"
			self.controller.show_info_box(message)
			return
		
		selected_id = []
		for index in selected_list:
			doc_id = index.data()
			selected_id.append(str(doc_id))
		message = "Are you sure you want to delete these records?"
		title = "Delete records"
		answer = self.controller.ask_question(message, title, ','.join(selected_id))
		if answer:
			sql = (f"DELETE FROM {tablename}"
				   f" WHERE id IN ({','.join(selected_id)})")
			status = self.controller.execute_sql(sql)
			if not status:
				message = "Error deleting data"
				self.controller.show_warning(message)
				return
			else:
				message = "Document deleted"
				self.controller.show_info(message)
				qtable.model().select()
	
	
	def get_all_actions(self):
		
		actions_list = self.iface.mainWindow().findChildren(QAction)
		for action in actions_list:
			self.controller.log_info(str(action.objectName()))
			action.triggered.connect(partial(self.show_action_name, action))
	
	
	def show_action_name(self, action):
		self.controller.log_info(str(action.objectName()))
	
	
	def get_points(self, list_coord=None):
		""" Return list of QgsPoints taken from geometry
		:type list_coord: list of coors in format ['x1 y1', 'x2 y2',....,'x99 y99']
		"""
		
		coords = list_coord.group(1)
		polygon = coords.split(',')
		points = []
		
		for i in range(0, len(polygon)):
			x, y = polygon[i].split(' ')
			point = QgsPointXY(float(x), float(y))
			points.append(point)
		
		return points
	
	
	def draw(self, complet_result, margin=None, reset_rb=True, color=QColor(255, 0, 0, 100), width=3):
		try:
			if complet_result['body']['feature']['geometry'] is None:
				return
			if complet_result['body']['feature']['geometry']['st_astext'] is None:
				return
		except KeyError as e:
			return
		list_coord = re.search('\((.*)\)', str(complet_result['body']['feature']['geometry']['st_astext']))
		max_x, max_y, min_x, min_y = self.get_max_rectangle_from_coords(list_coord)
		
		if reset_rb:
			self.resetRubberbands()
		if str(max_x) == str(min_x) and str(max_y) == str(min_y):
			point = QgsPointXY(float(max_x), float(max_y))
			self.draw_point(point, color, width)
		else:
			points = self.get_points(list_coord)
			self.draw_polyline(points, color, width)
		if margin is not None:
			self.zoom_to_rectangle(max_x, max_y, min_x, min_y, margin)
	
	
	def draw_point(self, point, color=QColor(255, 0, 0, 100), width=3, duration_time=None, is_new=False):
		"""
		:param duration_time: integer milliseconds ex: 3000 for 3 seconds
		"""
		
		if self.rubber_point is None:
			self.init_rubber_point()
		
		if is_new:
			rb = QgsRubberBand(self.canvas, 0)
		else:
			rb = self.rubber_point
		
		rb.setColor(color)
		rb.setWidth(width)
		rb.addPoint(point)
		
		# wait to simulate a flashing effect
		if duration_time is not None:
			QTimer.singleShot(duration_time, self.resetRubberbands)
		return rb
	
	
	def hilight_feature_by_id(self, qtable, layer_name, field_id, width, index):
		""" Based on the received index and field_id, the id of the received field_id is searched within the table
		 and is painted in red on the canvas """
		
		self.resetRubberbands()
		layer = self.controller.get_layer_by_tablename(layer_name)
		if not layer: return
		
		row = index.row()
		column_index = qt_tools.get_col_index_by_col_name(qtable, field_id)
		_id = index.sibling(row, column_index).data()
		feature = self.get_feature_by_id(layer, _id, field_id)
		try:
			geometry = feature.geometry()
			self.rubber_polygon.setToGeometry(geometry, None)
			self.rubber_polygon.setColor(QColor(255, 0, 0, 100))
			self.rubber_polygon.setWidth(width)
			self.rubber_polygon.show()
		except AttributeError:
			pass
	
	
	def draw_polyline(self, points, color=QColor(255, 0, 0, 100), width=5, duration_time=None):
		""" Draw 'line' over canvas following list of points
		 :param duration_time: integer milliseconds ex: 3000 for 3 seconds
		 """
		
		if self.rubber_polygon is None:
			self.init_rubber_polygon()
		
		rb = self.rubber_polygon
		polyline = QgsGeometry.fromPolylineXY(points)
		rb.setToGeometry(polyline, None)
		rb.setColor(color)
		rb.setWidth(width)
		rb.show()
		
		# wait to simulate a flashing effect
		if duration_time is not None:
			QTimer.singleShot(duration_time, self.resetRubberbands)
		
		return rb
	
	
	def resetRubberbands(self):
		
		if self.rubber_polygon is not None:
			self.rubber_polygon.reset(2)
		
		if self.rubber_point is not None:
			self.rubber_point.reset(0)
	
	
	def restore_user_layer(self):
		
		if self.user_current_layer:
			self.iface.setActiveLayer(self.user_current_layer)
		else:
			layer = self.controller.get_layer_by_tablename('v_edit_node')
			if layer:
				self.iface.setActiveLayer(layer)
	
	
	
	def set_style_mapzones(self):
		
		extras = f'"mapzones":""'
		body = self.create_body(extras=extras)
		json_return = self.controller.get_json('gw_fct_getstylemapzones', body)
		if not json_return:
			return False
		
		for mapzone in json_return['body']['data']['mapzones']:
			
			# Loop for each mapzone returned on json
			lyr = self.controller.get_layer_by_tablename(mapzone['layer'])
			categories = []
			status = mapzone['status']
			if status == 'Disable':
				pass
			
			if lyr:
				# Loop for each id returned on json
				for id in mapzone['values']:
					# initialize the default symbol for this geometry type
					symbol = QgsSymbol.defaultSymbol(lyr.geometryType())
					symbol.setOpacity(float(mapzone['opacity']))
					
					# Setting simp
					R = random.randint(0, 255)
					G = random.randint(0, 255)
					B = random.randint(0, 255)
					if status == 'Stylesheet':
						try:
							R = id['stylesheet']['color'][0]
							G = id['stylesheet']['color'][1]
							B = id['stylesheet']['color'][2]
						except TypeError:
							R = random.randint(0, 255)
							G = random.randint(0, 255)
							B = random.randint(0, 255)
					
					elif status == 'Random':
						R = random.randint(0, 255)
						G = random.randint(0, 255)
						B = random.randint(0, 255)
					
					# Setting sytle
					layer_style = {'color': '{}, {}, {}'.format(int(R), int(G), int(B))}
					symbol_layer = QgsSimpleFillSymbolLayer.create(layer_style)
					
					if symbol_layer is not None:
						symbol.changeSymbolLayer(0, symbol_layer)
					category = QgsRendererCategory(id['id'], symbol, str(id['id']))
					categories.append(category)
					
					# apply symbol to layer renderer
					lyr.setRenderer(QgsCategorizedSymbolRenderer(mapzone['idname'], categories))
					
					# repaint layer
					lyr.triggerRepaint()
	
	
	def manage_return_manager(self, json_result, sql):
		"""
		Manage options for layers (active, visible, zoom and indexing)
		:param json_result: Json result of a query (Json)
		:param sql: query executed (String)
		:return: None
		"""
		try:
			return_manager = json_result['body']['returnManager']
		except KeyError:
			return
		srid = self.controller.plugin_settings_value('srid')
		try:
			margin = 1
			opacity = 100
			
			if 'zoom' in return_manager and 'margin' in return_manager['zoom']:
				margin = return_manager['zoom']['margin']
			
			if 'style' in return_manager and 'ruberband' in return_manager['style']:
				# Set default values
				width = 3
				color = QColor(255, 0, 0, 125)
				if 'transparency' in return_manager['style']['ruberband']:
					opacity = return_manager['style']['ruberband']['transparency'] * 255
				if 'color' in return_manager['style']['ruberband']:
					color = return_manager['style']['ruberband']['color']
					color = QColor(color[0], color[1], color[2], opacity)
				if 'width' in return_manager['style']['ruberband']:
					width = return_manager['style']['ruberband']['width']
				self.draw(json_result, margin, color=color, width=width)
			
			else:
				
				for key, value in list(json_result['body']['data'].items()):
					if key.lower() in ('point', 'line', 'polygon'):
						if key not in json_result['body']['data']:
							continue
						if 'features' not in json_result['body']['data'][key]:
							continue
						if len(json_result['body']['data'][key]['features']) == 0:
							continue
						
						layer_name = f'{key}'
						if 'layerName' in json_result['body']['data'][key]:
							if json_result['body']['data'][key]['layerName']:
								layer_name = json_result['body']['data'][key]['layerName']
						
						self.delete_layer_from_toc(layer_name)
						
						# Get values for create and populate layer
						counter = len(json_result['body']['data'][key]['features'])
						geometry_type = json_result['body']['data'][key]['geometryType']
						v_layer = QgsVectorLayer(f"{geometry_type}?crs=epsg:{srid}", layer_name, 'memory')
						
						self.add_layer.populate_vlayer(v_layer, json_result['body']['data'], key, counter)
						
						# Get values for set layer style
						opacity = 100
						style_type = json_result['body']['returnManager']['style']
						if 'style' in return_manager and 'transparency' in return_manager['style'][key]:
							opacity = return_manager['style'][key]['transparency'] * 255
						
						if style_type[key]['style'] == 'categorized':
							color_values = {}
							for item in json_result['body']['returnManager']['style'][key]['values']:
								color = QColor(item['color'][0], item['color'][1], item['color'][2], opacity * 255)
								color_values[item['id']] = color
							cat_field = str(style_type[key]['field'])
							size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
							self.add_layer.categoryze_layer(v_layer, cat_field, size, color_values)
						
						elif style_type[key]['style'] == 'random':
							size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
							if geometry_type == 'Point':
								v_layer.renderer().symbol().setSize(size)
							else:
								v_layer.renderer().symbol().setWidth(size)
							v_layer.renderer().symbol().setOpacity(opacity)
						
						elif style_type[key]['style'] == 'qml':
							style_id = style_type[key]['id']
							extras = f'"style_id":"{style_id}"'
							body = self.create_body(extras=extras)
							style = self.controller.get_json('gw_fct_getstyle', body, log_sql=True)
							if 'styles' in style['body']:
								if 'style' in style['body']['styles']:
									qml = style['body']['styles']['style']
									self.add_layer.create_qml(v_layer, qml)
						
						elif style_type[key]['style'] == 'unique':
							color = style_type[key]['values']['color']
							size = style_type['width'] if 'width' in style_type and style_type['width'] else 2
							color = QColor(color[0], color[1], color[2])
							if key == 'point':
								v_layer.renderer().symbol().setSize(size)
							elif key in ('line', 'polygon'):
								v_layer.renderer().symbol().setWidth(size)
							v_layer.renderer().symbol().setColor(color)
							v_layer.renderer().symbol().setOpacity(opacity)
						
						self.iface.layerTreeView().refreshLayerSymbology(v_layer.id())
						self.set_margin(v_layer, margin)
		
		except Exception as e:
			self.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)
	
	
	def manage_layer_manager(self, json_result, sql):
		"""
		Manage options for layers (active, visible, zoom and indexing)
		:param json_result: Json result of a query (Json)
		:return: None
		"""
		
		try:
			layermanager = json_result['body']['layerManager']
		except KeyError:
			return
		
		try:
			
			# force visible and in case of does not exits, load it
			if 'visible' in layermanager:
				for lyr in layermanager['visible']:
					layer_name = [key for key in lyr][0]
					layer = self.controller.get_layer_by_tablename(layer_name)
					if layer is None:
						the_geom = lyr[layer_name]['geom_field']
						field_id = lyr[layer_name]['pkey_field']
						if lyr[layer_name]['group_layer'] is not None:
							group = lyr[layer_name]['group_layer']
						else:
							group = "GW Layers"
						style_id = lyr[layer_name]['style_id']
						self.add_layer.from_postgres_to_toc(layer_name, the_geom, field_id, group=group, style_id=style_id)
					self.controller.set_layer_visible(layer)
			
			# force reload dataProvider in order to reindex.
			if 'index' in layermanager:
				for lyr in layermanager['index']:
					layer_name = [key for key in lyr][0]
					layer = self.controller.get_layer_by_tablename(layer_name)
					if layer:
						self.controller.set_layer_index(layer)
			
			# Set active
			if 'active' in layermanager:
				layer = self.controller.get_layer_by_tablename(layermanager['active'])
				if layer:
					self.iface.setActiveLayer(layer)
			
			# Set zoom to extent with a margin
			if 'zoom' in layermanager:
				layer = self.controller.get_layer_by_tablename(layermanager['zoom']['layer'])
				if layer:
					prev_layer = self.iface.activeLayer()
					self.iface.setActiveLayer(layer)
					self.iface.zoomToActiveLayer()
					margin = layermanager['zoom']['margin']
					self.set_margin(layer, margin)
					if prev_layer:
						self.iface.setActiveLayer(prev_layer)
			
			# Set snnaping options
			if 'snnaping' in layermanager:
				self.snapper_manager = SnappingConfigManager(self.iface)
				if self.snapper_manager.controller is None:
					self.snapper_manager.set_controller(self.controller)
				for layer_name in layermanager['snnaping']:
					layer = self.controller.get_layer_by_tablename(layer_name)
					if layer:
						QgsProject.instance().blockSignals(True)
						layer_settings = self.snapper_manager.snap_to_layer(layer, QgsPointLocator.All, True)
						if layer_settings:
							layer_settings.setType(2)
							layer_settings.setTolerance(15)
							layer_settings.setEnabled(True)
						else:
							layer_settings = QgsSnappingConfig.IndividualLayerSettings(True, 2, 15, 1)
						self.snapper_manager.snapping_config.setIndividualLayerSettings(layer, layer_settings)
						QgsProject.instance().blockSignals(False)
						QgsProject.instance().snappingConfigChanged.emit(
							self.snapper_manager.snapping_config)
				self.snapper_manager.set_snapping_mode()
		
		
		except Exception as e:
			self.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)
	
	
	def set_margin(self, layer, margin):
		
		extent = QgsRectangle()
		extent.setMinimal()
		extent.combineExtentWith(layer.extent())
		xmax = extent.xMaximum() + margin
		xmin = extent.xMinimum() - margin
		ymax = extent.yMaximum() + margin
		ymin = extent.yMinimum() - margin
		extent.set(xmin, ymin, xmax, ymax)
		self.iface.mapCanvas().setExtent(extent)
		self.iface.mapCanvas().refresh()
	
	
	def manage_actions(self, json_result, sql):
		"""
		Manage options for layers (active, visible, zoom and indexing)
		:param json_result: Json result of a query (Json)
		:return: None
		"""
		
		try:
			actions = json_result['body']['python_actions']
		except KeyError:
			return
		try:
			for action in actions:
				try:
					function_name = action['funcName']
					params = action['params']
					getattr(self.controller.gw_actions, f"{function_name}")(**params)
				except AttributeError as e:
					# If function_name not exist as python function
					self.controller.log_warning(f"Exception error: {e}")
				except Exception as e:
					self.controller.log_debug(f"{type(e).__name__}: {e}")
		except Exception as e:
			self.controller.manage_exception(None, f"{type(e).__name__}: {e}", sql)
	
	
	# From api_parent.py
	def get_visible_layers(self, as_list=False):
		""" Return string as {...} or [...] with name of table in DB of all visible layer in TOC """
	
		visible_layer = '{'
		if as_list is True:
			visible_layer = '['
		layers = self.controller.get_layers()
		for layer in layers:
			if self.controller.is_layer_visible(layer):
				table_name = self.controller.get_layer_source_table_name(layer)
				table = layer.dataProvider().dataSourceUri()
				# TODO:: Find differences between PostgreSQL and query layers, and replace this if condition.
				if 'SELECT row_number() over ()' in str(table) or 'srid' not in str(table):
					continue
				
				visible_layer += f'"{table_name}", '
		visible_layer = visible_layer[:-2]
		
		if as_list is True:
			visible_layer += ']'
		else:
			visible_layer += '}'
		return visible_layer
	
	
	def get_editable_layers(self):
		""" Return string as {...}  with name of table in DB of all editable layer in TOC """
		
		editable_layer = '{'
		layers = self.controller.get_layers()
		for layer in layers:
			if not layer.isReadOnly():
				table_name = self.controller.get_layer_source_table_name(layer)
				editable_layer += f'"{table_name}", '
		editable_layer = editable_layer[:-2] + "}"
		return editable_layer
	
	
	def set_completer_object_api(self, completer, model, widget, list_items, max_visible=10):
		""" Set autocomplete of widget @table_object + "_id"
			getting id's from selected @table_object.
			WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
		"""
		
		# Set completer and model: add autocomplete in the widget
		completer.setCaseSensitivity(Qt.CaseInsensitive)
		completer.setMaxVisibleItems(max_visible)
		widget.setCompleter(completer)
		completer.setCompletionMode(1)
		model.setStringList(list_items)
		completer.setModel(model)
	
	
	def set_completer_object(self, dialog, table_object):
		""" Set autocomplete of widget @table_object + "_id"
			getting id's from selected @table_object
		"""
		
		widget = qt_tools.getWidget(dialog, table_object + "_id")
		if not widget:
			return
		
		# Set SQL
		field_object_id = "id"
		if table_object == "element":
			field_object_id = table_object + "_id"
		sql = (f"SELECT DISTINCT({field_object_id})"
			   f" FROM {table_object}")
		
		rows = self.controller.get_rows(sql, log_sql=True)
		if rows is None:
			return
		
		for i in range(0, len(rows)):
			aux = rows[i]
			rows[i] = str(aux[0])
		
		# Set completer and model: add autocomplete in the widget
		self.completer = QCompleter()
		self.completer.setCaseSensitivity(Qt.CaseInsensitive)
		widget.setCompleter(self.completer)
		model = QStringListModel()
		model.setStringList(rows)
		self.completer.setModel(model)
	
	
	def get_feature_by_id(self, layer, id, field_id):
		
		features = layer.getFeatures()
		for feature in features:
			if feature[field_id] == id:
				return feature
		
		return False
	
	
	def get_feature_by_expr(self, layer, expr_filter):
		
		# Check filter and existence of fields
		expr = QgsExpression(expr_filter)
		if expr.hasParserError():
			message = f"{expr.parserErrorString()}: {expr_filter}"
			self.controller.show_warning(message)
			return
		
		it = layer.getFeatures(QgsFeatureRequest(expr))
		# Iterate over features
		for feature in it:
			return feature
		
		return False
	
	
	def check_actions(self, action, enabled):
		
		try:
			action.setChecked(enabled)
		except RuntimeError:
			pass
	
	
	def api_action_help(self, geom_type):
		""" Open PDF file with selected @project_type and @geom_type """
		
		# Get locale of QGIS application
		locale = QSettings().value('locale/userLocale').lower()
		if locale == 'es_es':
			locale = 'es'
		elif locale == 'es_ca':
			locale = 'ca'
		elif locale == 'en_us':
			locale = 'en'
		project_type = self.controller.get_project_type()
		# Get PDF file
		pdf_folder = os.path.join(self.plugin_dir, 'png')
		pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")
		
		# Open PDF if exists. If not open Spanish version
		if os.path.exists(pdf_path):
			os.system(pdf_path)
		else:
			locale = "es"
			pdf_path = os.path.join(pdf_folder, f"{project_type}_{geom_type}_{locale}.png")
			if os.path.exists(pdf_path):
				os.system(pdf_path)
			else:
				message = "File not found"
				self.controller.show_warning(message, parameter=pdf_path)
	
	
	def action_rotation(self, dialog):
		
		# Set map tool emit point and signals
		self.emit_point = QgsMapToolEmitPoint(self.canvas)
		self.previous_map_tool = self.canvas.mapTool()
		self.canvas.setMapTool(self.emit_point)
		self.emit_point.canvasClicked.connect(partial(self.action_rotation_canvas_clicked, dialog))
	
	
	def action_rotation_canvas_clicked(self, dialog, point, btn):
		
		if btn == Qt.RightButton:
			self.canvas.setMapTool(self.previous_map_tool)
			return
		
		existing_point_x = None
		existing_point_y = None
		viewname = self.controller.get_layer_source_table_name(self.layer)
		sql = (f"SELECT ST_X(the_geom), ST_Y(the_geom)"
			   f" FROM {viewname}"
			   f" WHERE node_id = '{self.feature_id}'")
		row = self.controller.get_row(sql)
		if row:
			existing_point_x = row[0]
			existing_point_y = row[1]
		
		if existing_point_x:
			sql = (f"UPDATE node"
				   f" SET hemisphere = (SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}), "
				   f" ST_Point({point.x()}, {point.y()}))))"
				   f" WHERE node_id = '{self.feature_id}'")
			status = self.controller.execute_sql(sql)
			if not status:
				self.canvas.setMapTool(self.previous_map_tool)
				return
		
		sql = (f"SELECT rotation FROM node "
			   f" WHERE node_id = '{self.feature_id}'")
		row = self.controller.get_row(sql)
		if row:
			qt_tools.setWidgetText(dialog, "rotation", str(row[0]))
		
		sql = (f"SELECT degrees(ST_Azimuth(ST_Point({existing_point_x}, {existing_point_y}),"
			   f" ST_Point({point.x()}, {point.y()})))")
		row = self.controller.get_row(sql)
		if row:
			qt_tools.setWidgetText(dialog, "hemisphere", str(row[0]))
			message = "Hemisphere of the node has been updated. Value is"
			self.controller.show_info(message, parameter=str(row[0]))
		self.api_disable_rotation(dialog)
	
	
	def api_disable_rotation(self, dialog):
		""" Disable actionRotation and set action 'Identify' """
		
		action_widget = dialog.findChild(QAction, "actionRotation")
		if action_widget:
			action_widget.setChecked(False)
		try:
			self.emit_point.canvasClicked.disconnect()
			self.canvas.setMapTool(self.previous_map_tool)
		except Exception as e:
			self.controller.log_info(type(e).__name__)
	
	
	def api_action_copy_paste(self, dialog, geom_type, tab_type=None):
		""" Copy some fields from snapped feature to current feature """
		
		# Set map tool emit point and signals
		self.emit_point = QgsMapToolEmitPoint(self.canvas)
		self.canvas.setMapTool(self.emit_point)
		self.canvas.xyCoordinates.connect(self.api_action_copy_paste_mouse_move)
		self.emit_point.canvasClicked.connect(partial(self.api_action_copy_paste_canvas_clicked, dialog, tab_type))
		self.geom_type = geom_type
		
		# Store user snapping configuration
		self.snapper_manager = SnappingConfigManager(self.iface)
		if self.snapper_manager.controller is None:
			self.snapper_manager.set_controller(self.controller)
		self.snapper_manager.store_snapping_options()
		self.snapper = self.snapper_manager.get_snapper()
		
		# Clear snapping
		self.snapper_manager.enable_snapping()
		
		# Set snapping
		layer = self.iface.activeLayer()
		self.snapper_manager.snap_to_layer(layer)
		
		# Set marker
		color = QColor(255, 100, 255)
		self.vertex_marker = QgsVertexMarker(self.canvas)
		if geom_type == 'node':
			self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
		elif geom_type == 'arc':
			self.vertex_marker.setIconType(QgsVertexMarker.ICON_CROSS)
		self.vertex_marker.setColor(color)
		self.vertex_marker.setIconSize(15)
		self.vertex_marker.setPenWidth(3)
	
	
	def api_action_copy_paste_mouse_move(self, point):
		""" Slot function when mouse is moved in the canvas.
			Add marker if any feature is snapped
		"""
		
		# Hide marker and get coordinates
		self.vertex_marker.hide()
		event_point = self.snapper_manager.get_event_point(point=point)
		
		# Snapping
		result = self.snapper_manager.snap_to_current_layer(event_point)
		if not self.snapper_manager.result_is_valid():
			return
		
		# Add marker to snapped feature
		self.snapper_manager.add_marker(result, self.vertex_marker)
	
	
	def api_action_copy_paste_canvas_clicked(self, dialog, tab_type, point, btn):
		""" Slot function when canvas is clicked """
		
		if btn == Qt.RightButton:
			self.api_disable_copy_paste(dialog)
			return
		
		# Get clicked point
		event_point = self.snapper_manager.get_event_point(point=point)
		
		# Snapping
		result = self.snapper_manager.snap_to_current_layer(event_point)
		if not self.snapper_manager.result_is_valid():
			self.api_disable_copy_paste(dialog)
			return
		
		layer = self.iface.activeLayer()
		layername = layer.name()
		
		# Get the point. Leave selection
		snapped_feature = self.snapper_manager.get_snapped_feature(result, True)
		snapped_feature_attr = snapped_feature.attributes()
		
		aux = f'"{self.geom_type}_id" = '
		aux += f"'{self.feature_id}'"
		expr = QgsExpression(aux)
		if expr.hasParserError():
			message = "Expression Error"
			self.controller.show_warning(message, parameter=expr.parserErrorString())
			self.api_disable_copy_paste(dialog)
			return
		
		fields = layer.dataProvider().fields()
		layer.startEditing()
		it = layer.getFeatures(QgsFeatureRequest(expr))
		feature_list = [i for i in it]
		if not feature_list:
			self.api_disable_copy_paste(dialog)
			return
		
		# Select only first element of the feature list
		feature = feature_list[0]
		feature_id = feature.attribute(str(self.geom_type) + '_id')
		msg = (f"Selected snapped feature_id to copy values from: {snapped_feature_attr[0]}\n"
			   f"Do you want to copy its values to the current node?\n\n")
		# Replace id because we don't have to copy it!
		snapped_feature_attr[0] = feature_id
		snapped_feature_attr_aux = []
		fields_aux = []
		
		# Iterate over all fields and copy only specific ones
		for i in range(0, len(fields)):
			if fields[i].name() == 'sector_id' or fields[i].name() == 'dma_id' or fields[i].name() == 'expl_id' \
					or fields[i].name() == 'state' or fields[i].name() == 'state_type' \
					or fields[i].name() == layername + '_workcat_id' or fields[i].name() == layername + '_builtdate' \
					or fields[i].name() == 'verified' or fields[i].name() == str(self.geom_type) + 'cat_id':
				snapped_feature_attr_aux.append(snapped_feature_attr[i])
				fields_aux.append(fields[i].name())
			if self.project_type == 'ud':
				if fields[i].name() == str(self.geom_type) + '_type':
					snapped_feature_attr_aux.append(snapped_feature_attr[i])
					fields_aux.append(fields[i].name())
		
		for i in range(0, len(fields_aux)):
			msg += f"{fields_aux[i]}: {snapped_feature_attr_aux[i]}\n"
		
		# Ask confirmation question showing fields that will be copied
		answer = self.controller.ask_question(msg, "Update records", None)
		if answer:
			for i in range(0, len(fields)):
				for x in range(0, len(fields_aux)):
					if fields[i].name() == fields_aux[x]:
						layer.changeAttributeValue(feature.id(), i, snapped_feature_attr_aux[x])
			
			layer.commitChanges()
			
			# dialog.refreshFeature()
			for i in range(0, len(fields_aux)):
				widget = dialog.findChild(QWidget, tab_type + "_" + fields_aux[i])
				if qt_tools.getWidgetType(dialog, widget) is QLineEdit:
					qt_tools.setWidgetText(dialog, widget, str(snapped_feature_attr_aux[i]))
				elif qt_tools.getWidgetType(dialog, widget) is QComboBox:
					qt_tools.set_combo_itemData(widget, str(snapped_feature_attr_aux[i]), 0)
		
		self.api_disable_copy_paste(dialog)
	
	
	def api_disable_copy_paste(self, dialog):
		""" Disable actionCopyPaste and set action 'Identify' """
		
		action_widget = dialog.findChild(QAction, "actionCopyPaste")
		if action_widget:
			action_widget.setChecked(False)
		
		try:
			self.snapper_manager.recover_snapping_options()
			self.vertex_marker.hide()
			self.canvas.xyCoordinates.disconnect()
			self.emit_point.canvasClicked.disconnect()
		except:
			pass
	
	
	def set_widget_size(self, widget, field):
		
		if 'widgetdim' in field:
			if field['widgetdim']:
				widget.setMaximumWidth(field['widgetdim'])
				widget.setMinimumWidth(field['widgetdim'])
		
		return widget
	
	
	def add_button(self, dialog, field):
		
		widget = QPushButton()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		if 'value' in field:
			widget.setText(field['value'])
		widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
		function_name = 'no_function_associated'
		real_name = widget.objectName()[5:len(widget.objectName())]
		if 'widgetfunction' in field:
			if field['widgetfunction'] is not None:
				function_name = field['widgetfunction']
				exist = self.controller.check_python_function(self, function_name)
				if not exist:
					msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
					self.controller.show_message(msg, 2)
					return widget
			else:
				message = "Parameter button_function is null for button"
				self.controller.show_message(message, 2, parameter=widget.objectName())
		
		kwargs = {'dialog': dialog, 'widget': widget, 'message_level': 1, 'function_name': function_name}
		widget.clicked.connect(partial(getattr(self, function_name), **kwargs))
		
		return widget
	
	
	def add_textarea(self, field):
		""" Add widgets QTextEdit type """
		
		widget = QTextEdit()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		if 'value' in field:
			widget.setText(field['value'])
		if 'iseditable' in field:
			widget.setReadOnly(not field['iseditable'])
			if not field['iseditable']:
				widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
		
		return widget
	
	
	def add_lineedit(self, field):
		""" Add widgets QLineEdit type """
		
		widget = QLineEdit()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		if 'placeholder' in field:
			widget.setPlaceholderText(field['placeholder'])
		if 'value' in field:
			widget.setText(field['value'])
		if 'iseditable' in field:
			widget.setReadOnly(not field['iseditable'])
			if not field['iseditable']:
				widget.setStyleSheet("QLineEdit { background: rgb(242, 242, 242); color: rgb(100, 100, 100)}")
		
		return widget
	
	
	def set_data_type(self, field, widget):
		
		widget.setProperty('datatype', field['datatype'])
		return widget
	
	
	def manage_lineedit(self, field, dialog, widget, completer):
		
		if field['widgettype'] == 'typeahead':
			if 'queryText' not in field or 'queryTextFilter' not in field:
				return widget
			model = QStringListModel()
			widget.textChanged.connect(partial(self.populate_lineedit, completer, model, field, dialog, widget))
		
		return widget
	
	
	def populate_lineedit(self, completer, model, field, dialog, widget):
		""" Set autocomplete of widget @table_object + "_id"
			getting id's from selected @table_object.
			WARNING: Each QLineEdit needs their own QCompleter and their own QStringListModel!!!
		"""
		
		if not widget:
			return
		parent_id = ""
		if 'parentId' in field:
			parent_id = field["parentId"]
		
		extras = f'"queryText":"{field["queryText"]}"'
		extras += f', "queryTextFilter":"{field["queryTextFilter"]}"'
		extras += f', "parentId":"{parent_id}"'
		extras += f', "parentValue":"{qt_tools.getWidgetText(dialog, "data_" + str(field["parentId"]))}"'
		extras += f', "textToSearch":"{qt_tools.getWidgetText(dialog, widget)}"'
		body = self.create_body(extras=extras)
		complet_list = self.controller.get_json('gw_fct_gettypeahead', body)
		if not complet_list:
			return False
		
		list_items = []
		for field in complet_list['body']['data']:
			list_items.append(field['idval'])
		self.set_completer_object_api(completer, model, widget, list_items)
	
	
	def add_tableview(self, complet_result, field):
		""" Add widgets QTableView type """
		
		widget = QTableView()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		function_name = 'no_function_asociated'
		real_name = widget.objectName()[5:len(widget.objectName())]
		if 'widgetfunction' in field:
			if field['widgetfunction'] is not None:
				function_name = field['widgetfunction']
				exist = self.controller.check_python_function(self, function_name)
				if not exist:
					msg = f"widget {real_name} have associated function {function_name}, but {function_name} not exist"
					self.controller.show_message(msg, 2)
					return widget
		
		# Call def gw_api_open_rpt_result(self, widget, complet_result) of class ApiCf
		widget.doubleClicked.connect(partial(getattr(self, function_name), widget, complet_result))
		
		return widget
	
	
	def no_function_associated(self, **kwargs):
		
		widget = kwargs['widget']
		message_level = kwargs['message_level']
		message = f"No function associated to"
		self.controller.show_message(message, message_level, parameter=f"{type(widget)} {widget.objectName()}")
	
	
	def set_headers(self, widget, field):
		
		standar_model = widget.model()
		if standar_model is None:
			standar_model = QStandardItemModel()
		# Related by Qtable
		widget.setModel(standar_model)
		widget.horizontalHeader().setStretchLastSection(True)
		
		# # Get headers
		headers = []
		for x in field['value'][0]:
			headers.append(x)
		# Set headers
		standar_model.setHorizontalHeaderLabels(headers)
		
		return widget
	
	
	def populate_table(self, widget, field):
		
		standar_model = widget.model()
		for item in field['value']:
			row = []
			for value in item.values():
				row.append(QStandardItem(str(value)))
			if len(row) > 0:
				standar_model.appendRow(row)
		
		return widget
	
	
	def set_columns_config(self, widget, table_name, sort_order=0, isQStandardItemModel=False):
		""" Configuration of tables. Set visibility and width of columns """
		
		# Set width and alias of visible columns
		columns_to_delete = []
		sql = (f"SELECT columnindex, width, alias, status FROM config_form_tableview"
			   f" WHERE tablename = '{table_name}' ORDER BY columnindex")
		rows = self.controller.get_rows(sql, log_info=True)
		if not rows:
			return widget
		
		for row in rows:
			if not row['status']:
				columns_to_delete.append(row['columnindex'] - 1)
			else:
				width = row['width']
				if width is None:
					width = 100
				widget.setColumnWidth(row['columnindex'] - 1, width)
				if row['alias'] is not None:
					widget.model().setHeaderData(row['columnindex'] - 1, Qt.Horizontal, row['alias'])
		
		# Set order
		if isQStandardItemModel:
			widget.model().sort(sort_order, Qt.AscendingOrder)
		else:
			widget.model().setSort(sort_order, Qt.AscendingOrder)
			widget.model().select()
		# Delete columns
		for column in columns_to_delete:
			widget.hideColumn(column)
		
		return widget
	
	
	def add_checkbox(self, field):
		
		widget = QCheckBox()
		widget.setObjectName(field['widgetname'])
		widget.setProperty('columnname', field['columnname'])
		if 'value' in field:
			if field['value'] in ("t", "true", True):
				widget.setChecked(True)
		if 'iseditable' in field:
			widget.setEnabled(field['iseditable'])
		return widget
	
	
	def add_combobox(self, field):
		
		widget = QComboBox()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		widget = self.populate_combo(widget, field)
		if 'selectedId' in field:
			qt_tools.set_combo_itemData(widget, field['selectedId'], 0)
			widget.setProperty('selectedId', field['selectedId'])
		else:
			widget.setProperty('selectedId', None)
		
		return widget
	
	
	def fill_child(self, dialog, widget, feature_type, tablename, field_id):
		""" Find QComboBox child and populate it
		:param dialog: QDialog
		:param widget: QComboBox parent
		:param feature_type: PIPE, ARC, JUNCTION, VALVE...
		:param tablename: view of DB
		:param field_id: Field id of tablename
		"""
		
		combo_parent = widget.property('columnname')
		combo_id = qt_tools.get_item_data(dialog, widget)
		
		feature = f'"featureType":"{feature_type}", '
		feature += f'"tableName":"{tablename}", '
		feature += f'"idName":"{field_id}"'
		extras = f'"comboParent":"{combo_parent}", "comboId":"{combo_id}"'
		body = self.create_body(feature=feature, extras=extras)
		result = self.controller.get_json('gw_fct_getchilds', body)
		if not result:
			return False
		
		for combo_child in result['body']['data']:
			if combo_child is not None:
				self.manage_child(dialog, widget, combo_child)
	
	
	def manage_child(self, dialog, combo_parent, combo_child):
		child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
		if child:
			child.setEnabled(True)
			
			self.populate_child(dialog, combo_child)
			if 'widgetcontrols' not in combo_child or not combo_child['widgetcontrols'] or \
					'enableWhenParent' not in combo_child['widgetcontrols']:
				return
			#
			if (str(qt_tools.get_item_data(dialog, combo_parent, 0)) in str(combo_child['widgetcontrols']['enableWhenParent'])) \
					and (qt_tools.get_item_data(dialog, combo_parent, 0) not in (None, '')):
				# The keepDisbled property is used to keep the edition enabled or disabled,
				# when we activate the layer and call the "enable_all" function
				child.setProperty('keepDisbled', False)
				child.setEnabled(True)
			else:
				child.setProperty('keepDisbled', True)
				child.setEnabled(False)
	
	
	def populate_child(self, dialog, combo_child):
		
		child = dialog.findChild(QComboBox, str(combo_child['widgetname']))
		if child:
			self.populate_combo(child, combo_child)
	
	
	def populate_combo(self, widget, field):
		# Generate list of items to add into combo
		
		widget.blockSignals(True)
		widget.clear()
		widget.blockSignals(False)
		combolist = []
		if 'comboIds' in field:
			if 'isNullValue' in field and field['isNullValue']:
				combolist.append(['', ''])
			for i in range(0, len(field['comboIds'])):
				elem = [field['comboIds'][i], field['comboNames'][i]]
				combolist.append(elem)
		
		# Populate combo
		for record in combolist:
			widget.addItem(record[1], record)
		
		return widget
	
	
	def add_frame(self, field, x=None):
		
		widget = QFrame()
		widget.setObjectName(f"{field['widgetname']}_{x}")
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		widget.setFrameShape(QFrame.HLine)
		widget.setFrameShadow(QFrame.Sunken)
		
		return widget
	
	
	def add_label(self, field):
		""" Add widgets QLineEdit type """
		
		widget = QLabel()
		widget.setTextInteractionFlags(Qt.TextSelectableByMouse)
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		if 'value' in field:
			widget.setText(field['value'])
		
		return widget
	
	
	def set_calendar_empty(self, widget):
		""" Set calendar empty when click inner button of QgsDateTimeEdit because aesthetically it looks better"""
		widget.setEmpty()
	
	
	def add_hyperlink(self, field):
		
		widget = HyperLinkLabel()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		if 'value' in field:
			widget.setText(field['value'])
		widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
		widget.resize(widget.sizeHint().width(), widget.sizeHint().height())
		func_name = 'no_function_associated'
		real_name = widget.objectName()[5:len(widget.objectName())]
		if 'widgetfunction' in field:
			if field['widgetfunction'] is not None:
				func_name = field['widgetfunction']
				exist = self.controller.check_python_function(self, func_name)
				if not exist:
					msg = f"widget {real_name} have associated function {func_name}, but {func_name} not exist"
					self.controller.show_message(msg, 2)
					return widget
			else:
				message = "Parameter widgetfunction is null for widget"
				self.controller.show_message(message, 2, parameter=real_name)
		else:
			message = "Parameter not found"
			self.controller.show_message(message, 2, parameter='widgetfunction')
		
		# Call function (self, widget) or def no_function_associated(self, widget=None, message_level=1)
		widget.clicked.connect(partial(getattr(self, func_name), widget))
		
		return widget
	
	
	def add_horizontal_spacer(self):
		
		widget = QSpacerItem(10, 10, QSizePolicy.Expanding, QSizePolicy.Minimum)
		return widget
	
	
	def add_verical_spacer(self):
		
		widget = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
		return widget
	
	
	def add_spinbox(self, field):
		
		widget = None
		if 'value' in field:
			if field['widgettype'] == 'spinbox':
				widget = QSpinBox()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		if 'value' in field:
			if field['widgettype'] == 'spinbox' and field['value'] != "":
				widget.setValue(int(field['value']))
		if 'iseditable' in field:
			widget.setReadOnly(not field['iseditable'])
			if not field['iseditable']:
				widget.setStyleSheet("QDoubleSpinBox { background: rgb(0, 250, 0); color: rgb(100, 100, 100)}")
		
		return widget
	
	
	def draw_polygon(self, points, border=QColor(255, 0, 0, 100), width=3, duration_time=None, fill_color=None):
		""" Draw 'polygon' over canvas following list of points
		:param duration_time: integer milliseconds ex: 3000 for 3 seconds
		"""
		
		if self.rubber_polygon is None:
			self.init_rubber_polygon()
		
		
		rb = self.rubber_polygon
		polygon = QgsGeometry.fromPolygonXY([points])
		rb.setToGeometry(polygon, None)
		rb.setColor(border)
		if fill_color:
			rb.setFillColor(fill_color)
		rb.setWidth(width)
		rb.show()
		
		# wait to simulate a flashing effect
		if duration_time is not None:
			QTimer.singleShot(duration_time, self.resetRubberbands)
		
		return rb
	
	
	def fill_table(self, widget, table_name, filter_=None):
		""" Set a model with selected filter.
		Attach that model to selected table """
		
		if self.schema_name not in table_name:
			table_name = self.schema_name + "." + table_name
		
		# Set model
		model = QSqlTableModel()
		model.setTable(table_name)
		model.setEditStrategy(QSqlTableModel.OnManualSubmit)
		model.setSort(0, 0)
		if filter_:
			model.setFilter(filter_)
		model.select()
		
		# Check for errors
		if model.lastError().isValid():
			self.controller.show_warning(model.lastError().text())
		
		# Attach model to table view
		widget.setModel(model)
	
	
	def populate_basic_info(self, dialog, result, field_id):
		
		fields = result[0]['body']['data']
		if 'fields' not in fields:
			return
		grid_layout = dialog.findChild(QGridLayout, 'gridLayout')
		
		for x, field in enumerate(fields["fields"]):
			
			label = QLabel()
			label.setObjectName('lbl_' + field['label'])
			label.setText(field['label'].capitalize())
			
			if 'tooltip' in field:
				label.setToolTip(field['tooltip'])
			else:
				label.setToolTip(field['label'].capitalize())
			
			widget = None
			if field['widgettype'] in ('text', 'textline') or field['widgettype'] == 'typeahead':
				completer = QCompleter()
				widget = self.add_lineedit(field)
				widget = self.set_widget_size(widget, field)
				widget = self.set_data_type(field, widget)
				if field['widgettype'] == 'typeahead':
					widget = self.manage_lineedit(field, dialog, widget, completer)
				if widget.property('columnname') == field_id:
					self.feature_id = widget.text()
			elif field['widgettype'] == 'datetime':
				widget = self.add_calendar(dialog, field)
				widget = self.set_auto_update_dateedit(field, dialog, widget)
			elif field['widgettype'] == 'hyperlink':
				widget = self.add_hyperlink(field)
			elif field['widgettype'] == 'textarea':
				widget = self.add_textarea(field)
			elif field['widgettype'] in ('combo', 'combobox'):
				widget = QComboBox()
				self.populate_combo(widget, field)
				widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
			elif field['widgettype'] in ('check', 'checkbox'):
				widget = self.add_checkbox(field)
				widget.stateChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
			elif field['widgettype'] == 'button':
				widget = self.add_button(dialog, field)
			
			grid_layout.addWidget(label, x, 0)
			grid_layout.addWidget(widget, x, 1)
		
		verticalSpacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
		grid_layout.addItem(verticalSpacer1)
		
		return result
	
	
	def clear_gridlayout(self, layout):
		"""  Remove all widgets of layout """
		
		while layout.count() > 0:
			child = layout.takeAt(0).widget()
			if child:
				child.setParent(None)
				child.deleteLater()
	
	
	def add_calendar(self, dialog, field):
		
		widget = QgsDateTimeEdit()
		widget.setObjectName(field['widgetname'])
		if 'columnname' in field:
			widget.setProperty('columnname', field['columnname'])
		widget.setAllowNull(True)
		widget.setCalendarPopup(True)
		widget.setDisplayFormat('dd/MM/yyyy')
		if 'value' in field and field['value'] not in ('', None, 'null'):
			date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
			qt_tools.setCalendarDate(dialog, widget, date)
		else:
			widget.clear()
		btn_calendar = widget.findChild(QToolButton)
		
		if field['isautoupdate']:
			_json = {}
			btn_calendar.clicked.connect(partial(self.get_values, dialog, widget, _json))
			btn_calendar.clicked.connect(
				partial(self.accept, dialog, self.complet_result[0], self.feature_id, _json, True, False))
		else:
			btn_calendar.clicked.connect(partial(self.get_values, dialog, widget, self.my_json))
		btn_calendar.clicked.connect(partial(self.set_calendar_empty, widget))
		
		return widget
	
	
	def manage_close_interpolate(self):
		
		self.save_settings(self.dlg_dtext)
		self.remove_interpolate_rb()
	
	
	def activate_snapping(self, complet_result, ep):
		
		self.rb_interpolate = []
		self.interpolate_result = None
		self.resetRubberbands()
		self.dlg_dtext = DialogTextUi()
		self.load_settings(self.dlg_dtext)
		
		qt_tools.setWidgetText(self.dlg_dtext, self.dlg_dtext.txt_infolog, 'Interpolate tool')
		self.dlg_dtext.lbl_text.setText("Please, use the cursor to select two nodes to proceed with the "
										"interpolation\nNode1: \nNode2:")
		
		self.dlg_dtext.btn_accept.clicked.connect(partial(self.chek_for_existing_values))
		self.dlg_dtext.btn_close.clicked.connect(partial(self.close_dialog, self.dlg_dtext))
		self.dlg_dtext.rejected.connect(partial(self.save_settings, self.dlg_dtext))
		self.dlg_dtext.rejected.connect(partial(self.remove_interpolate_rb))
		
		self.open_dialog(self.dlg_dtext, dlg_name='dialog_text')
		
		# Set circle vertex marker
		color = QColor(255, 100, 255)
		self.vertex_marker = QgsVertexMarker(self.canvas)
		self.vertex_marker.setIconType(QgsVertexMarker.ICON_CIRCLE)
		self.vertex_marker.setColor(color)
		self.vertex_marker.setIconSize(15)
		self.vertex_marker.setPenWidth(3)
		
		self.node1 = None
		self.node2 = None
		
		self.canvas.setMapTool(ep)
		# We redraw the selected feature because self.canvas.setMapTool(emit_point) erases it
		self.draw(complet_result[0], None, False)
		
		# Store user snapping configuration
		self.snapper_manager = SnappingConfigManager(self.iface)
		if self.snapper_manager.controller is None:
			self.snapper_manager.set_controller(self.controller)
		self.snapper_manager.store_snapping_options()
		self.snapper = self.snapper_manager.get_snapper()
		
		self.layer_node = self.controller.get_layer_by_tablename("v_edit_node")
		self.iface.setActiveLayer(self.layer_node)
		
		self.canvas.xyCoordinates.connect(partial(self.mouse_move))
		ep.canvasClicked.connect(partial(self.snapping_node, ep))
	
	
	def dlg_destroyed(self, layer=None, vertex=None):
		
		self.dlg_is_destroyed = True
		if layer is not None:
			self.iface.setActiveLayer(layer)
		else:
			if hasattr(self, 'layer'):
				if self.layer is not None:
					self.iface.setActiveLayer(self.layer)
		if vertex is not None:
			self.iface.mapCanvas().scene().removeItem(vertex)
		else:
			if hasattr(self, 'vertex_marker'):
				if self.vertex_marker is not None:
					self.iface.mapCanvas().scene().removeItem(self.vertex_marker)
		try:
			self.canvas.xyCoordinates.disconnect()
		except:
			pass
	
	
	def snapping_node(self, ep, point, button):
		""" Get id of selected nodes (node1 and node2) """
		
		if button == 2:
			self.dlg_destroyed()
			return
		
		# Get coordinates
		event_point = self.snapper_manager.get_event_point(point=point)
		if not event_point:
			return
		# Snapping
		result = self.snapper_manager.snap_to_current_layer(event_point)
		if self.snapper_manager.result_is_valid():
			layer = self.snapper_manager.get_snapped_layer(result)
			# Check feature
			if layer == self.layer_node:
				snapped_feat = self.snapper_manager.get_snapped_feature(result)
				element_id = snapped_feat.attribute('node_id')
				message = "Selected node"
				if self.node1 is None:
					self.node1 = str(element_id)
					rb = self.draw_point(QgsPointXY(result.point()), color=QColor(
						0, 150, 55, 100), width=10, is_new=True)
					self.rb_interpolate.append(rb)
					self.dlg_dtext.lbl_text.setText(f"Node1: {self.node1}\nNode2:")
					self.controller.show_message(message, message_level=0, parameter=self.node1)
				elif self.node1 != str(element_id):
					self.node2 = str(element_id)
					rb = self.draw_point(QgsPointXY(result.point()), color=QColor(
						0, 150, 55, 100), width=10, is_new=True)
					self.rb_interpolate.append(rb)
					self.dlg_dtext.lbl_text.setText(f"Node1: {self.node1}\nNode2: {self.node2}")
					self.controller.show_message(message, message_level=0, parameter=self.node2)
		
		if self.node1 and self.node2:
			self.canvas.xyCoordinates.disconnect()
			ep.canvasClicked.disconnect()
			
			self.iface.setActiveLayer(self.layer)
			self.iface.mapCanvas().scene().removeItem(self.vertex_marker)
			extras = f'"parameters":{{'
			extras += f'"x":{self.last_point[0]}, '
			extras += f'"y":{self.last_point[1]}, '
			extras += f'"node1":"{self.node1}", '
			extras += f'"node2":"{self.node2}"}}'
			body = self.create_body(extras=extras)
			self.interpolate_result = self.controller.get_json('gw_fct_node_interpolate', body, log_sql=True)
			self.add_layer.populate_info_text(self.dlg_dtext, self.interpolate_result['body']['data'])
	
	
	def chek_for_existing_values(self):
		
		text = False
		for k, v in self.interpolate_result['body']['data']['fields'][0].items():
			widget = self.dlg_cf.findChild(QWidget, k)
			if widget:
				text = qt_tools.getWidgetText(self.dlg_cf, widget, False, False)
				if text:
					msg = "Do you want to overwrite custom values?"
					answer = self.controller.ask_question(msg, "Overwrite values")
					if answer:
						self.set_values()
					break
		if not text:
			self.set_values()
	
	
	def set_values(self):
		
		# Set values tu info form
		for k, v in self.interpolate_result['body']['data']['fields'][0].items():
			widget = self.dlg_cf.findChild(QWidget, k)
			if widget:
				widget.setStyleSheet(None)
				qt_tools.setWidgetText(self.dlg_cf, widget, f'{v}')
				widget.editingFinished.emit()
		self.close_dialog(self.dlg_dtext)
	
	
	def remove_interpolate_rb(self):
		
		# Remove the circumferences made by the interpolate
		for rb in self.rb_interpolate:
			self.iface.mapCanvas().scene().removeItem(rb)
	
	
	def mouse_move(self, point):
		
		# Get clicked point
		event_point = self.snapper_manager.get_event_point(point=point)
		
		# Snapping
		result = self.snapper_manager.snap_to_current_layer(event_point)
		if self.snapper_manager.result_is_valid():
			layer = self.snapper_manager.get_snapped_layer(result)
			if layer == self.layer_node:
				self.snapper_manager.add_marker(result, self.vertex_marker)
		else:
			self.vertex_marker.hide()
	
	
	def construct_form_param_user(self, dialog, row, pos, _json):
		
		field_id = ''
		if 'fields' in row[pos]:
			field_id = 'fields'
		elif 'return_type' in row[pos]:
			if row[pos]['return_type'] not in ('', None):
				field_id = 'return_type'
		
		if field_id == '':
			return
		
		for field in row[pos][field_id]:
			if field['label']:
				lbl = QLabel()
				lbl.setObjectName('lbl' + field['widgetname'])
				lbl.setText(field['label'])
				lbl.setMinimumSize(160, 0)
				lbl.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Preferred)
				if 'tooltip' in field:
					lbl.setToolTip(field['tooltip'])
				
				widget = None
				if field['widgettype'] == 'text' or field['widgettype'] == 'linetext':
					widget = QLineEdit()
					if 'isMandatory' in field:
						widget.setProperty('is_mandatory', field['isMandatory'])
					else:
						widget.setProperty('is_mandatory', True)
					widget.setText(field['value'])
					if 'widgetcontrols' in field and field['widgetcontrols']:
						if 'regexpControl' in field['widgetcontrols']:
							if field['widgetcontrols']['regexpControl'] is not None:
								pass
					widget.editingFinished.connect(
						partial(self.get_values_changed_param_user, dialog, None, widget, field, _json))
					widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
				elif field['widgettype'] == 'combo':
					widget = self.add_combobox(field)
					widget.currentIndexChanged.connect(
						partial(self.get_values_changed_param_user, dialog, None, widget, field, _json))
					widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
				elif field['widgettype'] == 'check':
					widget = QCheckBox()
					if field['value'] is not None and field['value'].lower() == "true":
						widget.setChecked(True)
					else:
						widget.setChecked(False)
					widget.stateChanged.connect(partial(self.get_values_changed_param_user,
														dialog, None, widget, field, _json))
					widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
				elif field['widgettype'] == 'datetime':
					widget = QgsDateTimeEdit()
					widget.setAllowNull(True)
					widget.setCalendarPopup(True)
					widget.setDisplayFormat('yyyy/MM/dd')
					date = QDate.currentDate()
					if 'value' in field and field['value'] not in ('', None, 'null'):
						date = QDate.fromString(field['value'].replace('/', '-'), 'yyyy-MM-dd')
					widget.setDate(date)
					widget.dateChanged.connect(partial(self.get_values_changed_param_user,
													   dialog, None, widget, field, _json))
					widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
				elif field['widgettype'] == 'spinbox':
					widget = QDoubleSpinBox()
					if 'value' in field and field['value'] not in(None, ""):
						value = float(str(field['value']))
						widget.setValue(value)
					widget.valueChanged.connect(partial(self.get_values_changed_param_user,
														dialog, None, widget, field, _json))
					widget.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed)
				elif field['widgettype'] == 'button':
					widget = self.add_button(dialog, field)
					widget = self.set_widget_size(widget, field)
				
				# Set editable/readonly
				if type(widget) in (QLineEdit, QDoubleSpinBox):
					if 'iseditable' in field:
						if str(field['iseditable']) == "False":
							widget.setReadOnly(True)
							widget.setStyleSheet("QWidget {background: rgb(242, 242, 242);color: rgb(100, 100, 100)}")
					if type(widget) == QLineEdit:
						if 'placeholder' in field:
							widget.setPlaceholderText(field['placeholder'])
				elif type(widget) in (QComboBox, QCheckBox):
					if 'iseditable' in field:
						if str(field['iseditable']) == "False":
							widget.setEnabled(False)
				widget.setObjectName(field['widgetname'])
				if 'iseditable' in field:
					widget.setEnabled(bool(field['iseditable']))
				
				self.put_widgets(dialog, field, lbl, widget)
	
	
	def put_widgets(self, dialog, field, lbl, widget):
		""" Insert widget into layout """
		
		layout = dialog.findChild(QGridLayout, field['layoutname'])
		if layout in (None, 'null', 'NULL', 'Null'):
			return
		layout.addWidget(lbl, int(field['layoutorder']), 0)
		layout.addWidget(widget, int(field['layoutorder']), 2)
		layout.setColumnStretch(2, 1)
	
	
	def get_values_changed_param_user(self, dialog, chk, widget, field, list, value=None):
		
		elem = {}
		if type(widget) is QLineEdit:
			value = qt_tools.getWidgetText(dialog, widget, return_string_null=False)
		elif type(widget) is QComboBox:
			value = qt_tools.get_item_data(dialog, widget, 0)
		elif type(widget) is QCheckBox:
			value = qt_tools.isChecked(dialog, widget)
		elif type(widget) is QDateEdit:
			value = qt_tools.getCalendarDate(dialog, widget)
		# if chk is None:
		#     elem[widget.objectName()] = value
		elem['widget'] = str(widget.objectName())
		elem['value'] = value
		if chk is not None:
			if chk.isChecked():
				# elem['widget'] = str(widget.objectName())
				elem['chk'] = str(chk.objectName())
				elem['isChecked'] = str(qt_tools.isChecked(dialog, chk))
				# elem['value'] = value
		
		if 'sys_role_id' in field:
			elem['sys_role_id'] = str(field['sys_role_id'])
		list.append(elem)
		self.controller.log_info(str(list))
	
	
	def get_values_checked_param_user(self, dialog, chk, widget, field, _json, value=None):
		
		elem = {}
		elem['widget'] = str(widget.objectName())
		elem['chk'] = str(chk.objectName())
		
		if type(widget) is QLineEdit:
			value = qt_tools.getWidgetText(dialog, widget, return_string_null=False)
		elif type(widget) is QComboBox:
			value = qt_tools.get_item_data(dialog, widget, 0)
		elif type(widget) is QCheckBox:
			value = qt_tools.isChecked(dialog, chk)
		elif type(widget) is QDateEdit:
			value = qt_tools.getCalendarDate(dialog, widget)
		elem['widget'] = str(widget.objectName())
		elem['chk'] = str(chk.objectName())
		elem['isChecked'] = str(qt_tools.isChecked(dialog, chk))
		elem['value'] = value
		if 'sys_role_id' in field:
			elem['sys_role_id'] = str(field['sys_role_id'])
		else:
			elem['sys_role_id'] = 'role_admin'
		
		self.list_update.append(elem)
	
	
	def set_widgets_into_composer(self, dialog, field):
		
		widget = None
		label = None
		if field['label']:
			label = QLabel()
			label.setObjectName('lbl_' + field['widgetname'])
			label.setText(field['label'].capitalize())
			if field['stylesheet'] is not None and 'label' in field['stylesheet']:
				label = self.set_setStyleSheet(field, label)
			if 'tooltip' in field:
				label.setToolTip(field['tooltip'])
			else:
				label.setToolTip(field['label'].capitalize())
		if field['widgettype'] == 'text' or field['widgettype'] == 'typeahead':
			widget = self.add_lineedit(field)
			widget = self.set_widget_size(widget, field)
			widget = self.set_data_type(field, widget)
			widget.editingFinished.connect(partial(self.get_values, dialog, widget, self.my_json))
			widget.returnPressed.connect(partial(self.get_values, dialog, widget, self.my_json))
		elif field['widgettype'] == 'combo':
			widget = self.add_combobox(field)
			widget = self.set_widget_size(widget, field)
			widget.currentIndexChanged.connect(partial(self.get_values, dialog, widget, self.my_json))
			if 'widgetfunction' in field:
				if field['widgetfunction'] is not None:
					function_name = field['widgetfunction']
					# Call def gw_fct_setprint(self, dialog, my_json): of the class ApiManageComposer
					widget.currentIndexChanged.connect(partial(getattr(self, function_name), dialog, self.my_json))
		
		return label, widget
	
	
	def get_values(self, dialog, widget, _json=None):
		
		value = None
		if type(widget) in(QLineEdit, QSpinBox, QDoubleSpinBox) and widget.isReadOnly() is False:
			value = qt_tools.getWidgetText(dialog, widget, return_string_null=False)
		elif type(widget) is QComboBox and widget.isEnabled():
			value = qt_tools.get_item_data(dialog, widget, 0)
		elif type(widget) is QCheckBox and widget.isEnabled():
			value = qt_tools.isChecked(dialog, widget)
		elif type(widget) is QgsDateTimeEdit and widget.isEnabled():
			value = qt_tools.getCalendarDate(dialog, widget)
		# Only get values if layer is editable or if layer not exist(need for ApiManageComposer)
		if not hasattr(self, 'layer') or self.layer.isEditable():
			# If widget.isEditable(False) return None, here control it.
			if str(value) == '' or value is None:
				_json[str(widget.property('columnname'))] = None
			else:
				_json[str(widget.property('columnname'))] = str(value)
	
	
	def set_function_associated(self, dialog, widget, field):
		
		function_name = 'no_function_associated'
		if 'widgetfunction' in field:
			if field['widgetfunction'] is not None:
				function_name = field['widgetfunction']
				exist = self.controller.check_python_function(self, function_name)
				if not exist:
					return widget
		else:
			message = "Parameter not found"
			self.controller.show_message(message, 2, parameter='button_function')
		
		if type(widget) == QLineEdit:
			# Call def gw_fct_setprint(self, dialog, my_json): of the class ApiManageComposer
			widget.editingFinished.connect(partial(getattr(self, function_name), dialog, self.my_json))
			widget.returnPressed.connect(partial(getattr(self, function_name), dialog, self.my_json))
		
		return widget
	
	
	def draw_rectangle(self, result):
		""" Draw lines based on geometry """
		
		if result['geometry'] is None:
			return
		
		list_coord = re.search('\((.*)\)', str(result['geometry']['st_astext']))
		points = self.get_points(list_coord)
		self.draw_polyline(points)
	
	
	def set_setStyleSheet(self, field, widget, wtype='label'):
		
		if field['stylesheet'] is not None:
			if wtype in field['stylesheet']:
				widget.setStyleSheet("QWidget{" + field['stylesheet'][wtype] + "}")
		return widget
	
	
	""" FUNCTIONS ASSOCIATED TO BUTTONS FROM POSTGRES"""
	
	def action_open_url(self, dialog, result):
		
		widget = None
		function_name = 'no_function_associated'
		for field in result['fields']:
			if field['linkedaction'] == 'action_link':
				function_name = field['widgetfunction']
				widget = dialog.findChild(HyperLinkLabel, field['widgetname'])
				break
		
		if widget:
			# Call def  function (self, widget)
			getattr(self, function_name)(widget)
	
	
	def set_open_url(self, widget):
		
		path = widget.text()
		# Check if file exist
		if os.path.exists(path):
			# Open the document
			if sys.platform == "win32":
				os.startfile(path)
			else:
				opener = "open" if sys.platform == "darwin" else "xdg-open"
				subprocess.call([opener, path])
		else:
			webbrowser.open(path)
	
	
	def gw_function_dxf(self, **kwargs):
		""" Function called in def add_button(self, dialog, field): -->
				widget.clicked.connect(partial(getattr(self, function_name), dialog, widget)) """
		
		path, filter_ = self.open_file_path(filter_="DXF Files (*.dxf)")
		if not path:
			return
		
		dialog = kwargs['dialog']
		widget = kwargs['widget']
		complet_result = self.manage_dxf(dialog, path, False, True)
		
		for layer in complet_result['temp_layers_added']:
			self.temp_layers_added.append(layer)
		if complet_result is not False:
			widget.setText(complet_result['path'])
		
		dialog.btn_run.setEnabled(True)
		dialog.btn_cancel.setEnabled(True)
	
	
	def manage_dxf(self, dialog, dxf_path, export_to_db=False, toc=False, del_old_layers=True):
		""" Select a dxf file and add layers into toc
		:param dxf_path: path of dxf file
		:param export_to_db: Export layers to database
		:param toc: insert layers into TOC
		:param del_old_layers: look for a layer with the same name as the one to be inserted and delete it
		:return:
		"""
		
		srid = self.controller.plugin_settings_value('srid')
		# Block the signals so that the window does not appear asking for crs / srid and / or alert message
		self.iface.mainWindow().blockSignals(True)
		dialog.txt_infolog.clear()
		
		sql = "DELETE FROM temp_table WHERE fid = 206;\n"
		self.controller.execute_sql(sql)
		temp_layers_added = []
		for type_ in ['LineString', 'Point', 'Polygon']:
			
			# Get file name without extension
			dxf_output_filename = os.path.splitext(os.path.basename(dxf_path))[0]
			
			# Create layer
			uri = f"{dxf_path}|layername=entities|geometrytype={type_}"
			dxf_layer = QgsVectorLayer(uri, f"{dxf_output_filename}_{type_}", 'ogr')
			
			# Set crs to layer
			crs = dxf_layer.crs()
			crs.createFromId(srid)
			dxf_layer.setCrs(crs)
			
			if not dxf_layer.hasFeatures():
				continue
			
			# Get the name of the columns
			field_names = [field.name() for field in dxf_layer.fields()]
			
			sql = ""
			geom_types = {0: 'geom_point', 1: 'geom_line', 2: 'geom_polygon'}
			for count, feature in enumerate(dxf_layer.getFeatures()):
				geom_type = feature.geometry().type()
				sql += (f"INSERT INTO temp_table (fid, text_column, {geom_types[int(geom_type)]})"
						f" VALUES (206, '{{")
				for att in field_names:
					if feature[att] in (None, 'NULL', ''):
						sql += f'"{att}":null , '
					else:
						sql += f'"{att}":"{feature[att]}" , '
				geometry = self.add_layer.manage_geometry(feature.geometry())
				sql = sql[:-2] + f"}}', (SELECT ST_GeomFromText('{geometry}', {srid})));\n"
				if count != 0 and count % 500 == 0:
					status = self.controller.execute_sql(sql)
					if not status:
						return False
					sql = ""
			
			if sql != "":
				status = self.controller.execute_sql(sql)
				if not status:
					return False
			
			if export_to_db:
				self.add_layer.export_layer_to_db(dxf_layer, crs)
			
			if del_old_layers:
				self.add_layer.delete_layer_from_toc(dxf_layer.name())
			
			if toc:
				if dxf_layer.isValid():
					self.add_layer.from_dxf_to_toc(dxf_layer, dxf_output_filename)
					temp_layers_added.append(dxf_layer)
		
		# Unlock signals
		self.iface.mainWindow().blockSignals(False)
		
		extras = "  "
		for widget in dialog.grb_parameters.findChildren(QWidget):
			widget_name = widget.property('columnname')
			value = qt_tools.getWidgetText(dialog, widget, add_quote=False)
			extras += f'"{widget_name}":"{value}", '
		extras = extras[:-2]
		body = self.create_body(extras)
		result = self.controller.get_json('gw_fct_check_importdxf', None, log_sql=True)
		if not result:
			return False
		
		return {"path": dxf_path, "result": result, "temp_layers_added": temp_layers_added}
	
	
	def manage_all(self, dialog, widget_all):
		
		key_modifier = QApplication.keyboardModifiers()
		status = qt_tools.isChecked(dialog, widget_all)
		index = dialog.main_tab.currentIndex()
		widget_list = dialog.main_tab.widget(index).findChildren(QCheckBox)
		if key_modifier == Qt.ShiftModifier:
			return
		
		for widget in widget_list:
			if widget_all is not None:
				if widget == widget_all or widget.objectName() == widget_all.objectName():
					continue
			widget.blockSignals(True)
			qt_tools.setChecked(dialog, widget, status)
			widget.blockSignals(False)
		
		self.set_selector(dialog, widget_all, False)
	
	
	def get_selector(self, dialog, selector_type, filter=False, widget=None, text_filter=None, current_tab=None,
					 is_setselector=None):
		""" Ask to DB for selectors and make dialog
		:param dialog: Is a standard dialog, from file api_selectors.ui, where put widgets
		:param selector_type: list of selectors to ask DB ['exploitation', 'state', ...]
		"""
		main_tab = dialog.findChild(QTabWidget, 'main_tab')
		
		# Set filter
		if filter is not False:
			main_tab = dialog.findChild(QTabWidget, 'main_tab')
			text_filter = qt_tools.getWidgetText(dialog, widget)
			if text_filter in ('null', None):
				text_filter = ''
			
			# Set current_tab
			index = dialog.main_tab.currentIndex()
			current_tab = dialog.main_tab.widget(index).objectName()
		
		# Profilactic control of nones
		if text_filter is None:
			text_filter = ''
		if is_setselector is None:
			# Built querytext
			form = f'"currentTab":"{current_tab}"'
			extras = f'"selectorType":{selector_type}, "filterText":"{text_filter}"'
			body = self.create_body(form=form, extras=extras)
			json_result = self.controller.get_json('gw_fct_getselectors', body, log_sql=True)
		else:
			json_result = is_setselector
			for x in range(dialog.main_tab.count() - 1, -1, -1):
				dialog.main_tab.widget(x).deleteLater()
		
		if not json_result:
			return False
		
		for form_tab in json_result['body']['form']['formTabs']:
			
			if filter and form_tab['tabName'] != str(current_tab):
				continue
			
			selection_mode = form_tab['selectionMode']
			
			# Create one tab for each form_tab and add to QTabWidget
			tab_widget = QWidget(main_tab)
			tab_widget.setObjectName(form_tab['tabName'])
			tab_widget.setProperty('selector_type', form_tab['selectorType'])
			if filter:
				main_tab.removeTab(index)
				main_tab.insertTab(index, tab_widget, form_tab['tabLabel'])
			else:
				main_tab.addTab(tab_widget, form_tab['tabLabel'])
			
			# Create a new QGridLayout and put it into tab
			gridlayout = QGridLayout()
			gridlayout.setObjectName("grl_" + form_tab['tabName'])
			tab_widget.setLayout(gridlayout)
			field = {}
			i = 0
			
			if 'typeaheadFilter' in form_tab:
				label = QLabel()
				label.setObjectName('lbl_filter')
				label.setText('Filter:')
				if qt_tools.getWidget(dialog, 'txt_filter_' + str(form_tab['tabName'])) is None:
					widget = QLineEdit()
					widget.setObjectName('txt_filter_' + str(form_tab['tabName']))
					widget.setSizePolicy(QSizePolicy.Fixed, QSizePolicy.Fixed)
					widget.textChanged.connect(partial(self.get_selector, self.dlg_selector, selector_type, filter=True,
													   widget=widget, current_tab=current_tab))
					widget.textChanged.connect(partial(self.manage_filter, dialog, widget, 'save'))
					widget.setLayoutDirection(Qt.RightToLeft)
					setattr(self, f"var_txt_filter_{form_tab['tabName']}", '')
				else:
					widget = qt_tools.getWidget(dialog, 'txt_filter_' + str(form_tab['tabName']))
				
				field['layoutname'] = gridlayout.objectName()
				field['layoutorder'] = i
				i = i + 1
				self.put_widgets(dialog, field, label, widget)
				widget.setFocus()
			
			if 'manageAll' in form_tab:
				if (form_tab['manageAll']).lower() == 'true':
					if qt_tools.getWidget(dialog, f"lbl_manage_all_{form_tab['tabName']}") is None:
						label = QLabel()
						label.setObjectName(f"lbl_manage_all_{form_tab['tabName']}")
						label.setText('Check all')
					else:
						label = qt_tools.getWidget(dialog, f"lbl_manage_all_{form_tab['tabName']}")
					
					if qt_tools.getWidget(dialog, f"chk_all_{form_tab['tabName']}") is None:
						widget = QCheckBox()
						widget.setObjectName('chk_all_' + str(form_tab['tabName']))
						widget.stateChanged.connect(partial(self.manage_all, dialog, widget))
						widget.setLayoutDirection(Qt.RightToLeft)
					
					else:
						widget = qt_tools.getWidget(dialog, f"chk_all_{form_tab['tabName']}")
					field['layoutname'] = gridlayout.objectName()
					field['layoutorder'] = i
					i = i + 1
					self.chk_all = widget
					self.put_widgets(dialog, field, label, widget)
			
			for order, field in enumerate(form_tab['fields']):
				label = QLabel()
				label.setObjectName('lbl_' + field['label'])
				label.setText(field['label'])
				
				widget = self.add_checkbox(field)
				widget.stateChanged.connect(partial(self.set_selection_mode, dialog, widget, selection_mode))
				widget.setLayoutDirection(Qt.RightToLeft)
				
				field['layoutname'] = gridlayout.objectName()
				field['layoutorder'] = order + i
				self.put_widgets(dialog, field, label, widget)
			
			vertical_spacer1 = QSpacerItem(20, 40, QSizePolicy.Minimum, QSizePolicy.Expanding)
			gridlayout.addItem(vertical_spacer1)
		
		# Set last tab used by user as current tab
		tabname = json_result['body']['form']['currentTab']
		tab = main_tab.findChild(QWidget, tabname)
		
		if tab:
			main_tab.setCurrentWidget(tab)
		
		if is_setselector is not None and hasattr(self, 'widget_filter'):
			widget = dialog.main_tab.findChild(QLineEdit, f'txt_filter_{tabname}')
			if widget:
				widget.blockSignals(True)
				index = dialog.main_tab.currentIndex()
				tab_name = dialog.main_tab.widget(index).objectName()
				value = getattr(self, f"var_txt_filter_{tab_name}")
				qt_tools.setWidgetText(dialog, widget, f'{value}')
				widget.blockSignals(False)
	
	
	def set_selection_mode(self, dialog, widget, selection_mode):
		""" Manage selection mode
		:param dialog: QDialog where search all checkbox
		:param widget: QCheckBox that has changed status (QCheckBox)
		:param selection_mode: "keepPrevious", "keepPreviousUsingShift", "removePrevious" (String)
		"""
		
		# Get QCheckBox check all
		index = dialog.main_tab.currentIndex()
		widget_list = dialog.main_tab.widget(index).findChildren(QCheckBox)
		tab_name = dialog.main_tab.widget(index).objectName()
		widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')
		
		is_alone = False
		key_modifier = QApplication.keyboardModifiers()
		
		if selection_mode == 'removePrevious' or \
				(selection_mode == 'keepPreviousUsingShift' and key_modifier != Qt.ShiftModifier):
			is_alone = True
			if widget_all is not None:
				widget_all.blockSignals(True)
				qt_tools.setChecked(dialog, widget_all, False)
				widget_all.blockSignals(False)
			self.remove_previuos(dialog, widget, widget_all, widget_list)
		
		self.set_selector(dialog, widget, is_alone)
	
	
	def remove_previuos(self, dialog, widget, widget_all, widget_list):
		""" Remove checks of not selected QCheckBox
		:param dialog: QDialog
		:param widget: QCheckBox that has changed status (QCheckBox)
		:param widget_all: QCheckBox that handles global selection (QCheckBox)
		:param widget_list: List of all QCheckBox in the current tab ([QCheckBox, QCheckBox, ...])
		"""
		
		for checkbox in widget_list:
			# Some selectors.ui dont have widget_all
			if widget_all is not None:
				if checkbox == widget_all or checkbox.objectName() == widget_all.objectName():
					continue
				elif checkbox.objectName() != widget.objectName():
					checkbox.blockSignals(True)
					qt_tools.setChecked(dialog, checkbox, False)
					checkbox.blockSignals(False)
			
			elif checkbox.objectName() != widget.objectName():
				checkbox.blockSignals(True)
				qt_tools.setChecked(dialog, checkbox, False)
				checkbox.blockSignals(False)
	
	
	def set_selector(self, dialog, widget, is_alone):
		"""  Send values to DB and reload selectors
		:param dialog: QDialog
		:param widget: QCheckBox that contains the information to generate the json (QCheckBox)
		:param is_alone: Defines if the selector is unique (True) or multiple (False) (Boolean)
		"""
		
		# Get current tab name
		index = dialog.main_tab.currentIndex()
		tab_name = dialog.main_tab.widget(index).objectName()
		selector_type = dialog.main_tab.widget(index).property("selector_type")
		qgis_project_add_schema = self.controller.plugin_settings_value('gwAddSchema')
		widget_all = dialog.findChild(QCheckBox, f'chk_all_{tab_name}')
		
		if widget_all is None or (widget_all is not None and widget.objectName() != widget_all.objectName()):
			extras = (f'"selectorType":"{selector_type}", "tabName":"{tab_name}", '
					  f'"id":"{widget.objectName()}", "isAlone":"{is_alone}", "value":"{widget.isChecked()}", '
					  f'"addSchema":"{qgis_project_add_schema}"')
		else:
			check_all = qt_tools.isChecked(dialog, widget_all)
			extras = f'"selectorType":"{selector_type}", "tabName":"{tab_name}", "checkAll":"{check_all}",  ' \
					 f'"addSchema":"{qgis_project_add_schema}"'
		
		body = self.create_body(extras=extras)
		json_result = self.controller.get_json('gw_fct_setselectors', body, log_sql=True)
		
		if str(tab_name) == 'tab_exploitation':
			# Reload layer, zoom to layer, style mapzones and refresh canvas
			layer = self.controller.get_layer_by_tablename('v_edit_arc')
			if layer:
				self.iface.setActiveLayer(layer)
				self.iface.zoomToActiveLayer()
			self.set_style_mapzones()
		
		# Refresh canvas
		self.controller.set_layer_index('v_edit_arc')
		self.controller.set_layer_index('v_edit_node')
		self.controller.set_layer_index('v_edit_connec')
		self.controller.set_layer_index('v_edit_gully')
		self.controller.set_layer_index('v_edit_link')
		self.controller.set_layer_index('v_edit_plan_psector')
		
		self.get_selector(dialog, f'"{selector_type}"', is_setselector=json_result)
		
		widget_filter = qt_tools.getWidget(dialog, f"txt_filter_{tab_name}")
		if widget_filter and qt_tools.getWidgetText(dialog, widget_filter, False, False) not in (None, ''):
			widget_filter.textChanged.emit(widget_filter.text())
	
	
	def manage_filter(self, dialog, widget, action):
		index = dialog.main_tab.currentIndex()
		tab_name = dialog.main_tab.widget(index).objectName()
		if action == 'save':
			setattr(self, f"var_txt_filter_{tab_name}", qt_tools.getWidgetText(dialog, widget))
		else:
			setattr(self, f"var_txt_filter_{tab_name}", '')
