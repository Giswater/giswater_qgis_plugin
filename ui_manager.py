# -*- coding: utf-8 -*-
from qgis.PyQt import uic, QtCore
from qgis.PyQt.QtGui import QIcon
from qgis.PyQt.QtWidgets import QAction, QMainWindow, QDialog, QDockWidget, QWhatsThis, QLineEdit
import configparser
import os
import webbrowser
from functools import partial


class GwDockWidget(QDockWidget):

    dlg_closed = QtCore.pyqtSignal()
    
    def __init__(self, subtag=None, position=None):
        super().__init__()
        self.setupUi(self)
        self.subtag = subtag


    def closeEvent(self, event):
        self.dlg_closed.emit()
        return super().closeEvent(event)


class GwDialog(QDialog):

    def __init__(self, subtag=None):
        super().__init__()
        self.setupUi(self)
        self.subtag = subtag
        # Enable event filter
        self.installEventFilter(self)


    def eventFilter(self, object, event):

        if event.type() == QtCore.QEvent.EnterWhatsThisMode and self.isActiveWindow():
            QWhatsThis.leaveWhatsThisMode()
            parser = configparser.ConfigParser()
            path = os.path.dirname(__file__) + '/config/ui_config.config'
            parser.read(path)
            
            if self.subtag is not None:
                tag = f'{self.objectName()}_{self.subtag}'
            else:
                tag = str(self.objectName())

            try:
                web_tag = parser.get('web_tag', tag)
                webbrowser.open_new_tab('https://giswater.org/giswater-manual/#' + web_tag)
            except Exception as e:
                webbrowser.open_new_tab('https://giswater.org/giswater-manual')
            
            return True
        return False


class GwMainWindow(QMainWindow):

    dlg_closed = QtCore.pyqtSignal()
    
    def __init__(self, subtag=None):
        super().__init__()
        self.setupUi(self)
        self.subtag = subtag
        # Enable event filter
        self.installEventFilter(self)


    def closeEvent(self, event):
        self.dlg_closed.emit()
        return super().closeEvent(event)


    def eventFilter(self, object, event):

        if event.type() == QtCore.QEvent.EnterWhatsThisMode and self.isActiveWindow():
            QWhatsThis.leaveWhatsThisMode()
            parser = configparser.ConfigParser()
            path = os.path.dirname(__file__) + '/config/ui_config.config'
            parser.read(path)
        
            if self.subtag is not None:
                tag = f'{self.objectName()}_{self.subtag}'
            else:
                tag = str(self.objectName())
                
            try:
                web_tag = parser.get('web_tag', tag)
                webbrowser.open_new_tab('https://giswater.org/giswater-manual/#' + web_tag)
            except Exception as e:
                webbrowser.open_new_tab('https://giswater.org/giswater-manual')

            return True
        return False


def get_ui_class(ui_file_name, subfolder=None):
    """ Get UI Python class from @ui_file_name """

    # Folder that contains UI files
    ui_folder_path = os.path.dirname(__file__) + os.sep + 'ui'
    if subfolder:
        ui_folder_path += os.sep + subfolder
    ui_file_path = os.path.abspath(os.path.join(ui_folder_path, ui_file_name))
    return uic.loadUiType(ui_file_path)[0]


FORM_CLASS = get_ui_class('docker.ui')
class DockerUi(GwDockWidget, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('element.ui')
class ElementUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('add_lot.ui')
class LotUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('visit.ui')
class VisitUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('new_visit.ui')
class NewVisitUi(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('info_basic.ui')
class ApiBasicInfo(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('info_catalog.ui')
class InfoCatalogUi(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('info_full.ui')
class InfoFullUi(GwMainWindow, FORM_CLASS):
    key_pressed = QtCore.pyqtSignal()

    def keyPressEvent(self, event):
        if event.key() == QtCore.Qt.Key_Escape:
            self.key_pressed.emit()
            return super(InfoFullUi, self).keyPressEvent(event)


FORM_CLASS = get_ui_class('fastprint.ui')
class FastPrintUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('config.ui')
class ConfigUi(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('dimensioning.ui')
class DimensioningUi(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('options.ui')
class OptionsUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('search.ui')
class SearchUi(GwDockWidget, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('selector.ui')
class SelectorUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('toolbox_docker.ui')
class ToolboxDockerUi(GwDockWidget, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('toolbox.ui')
class ToolboxUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('arc_fusion.ui')
class ArcFusionUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('project_check.ui')
class ProjectCheckUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('basic_info.ui')
class BasicInfoUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('basic_table.ui')
class BasicTable(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('cad_add_circle.ui')
class Cad_add_circle(GwDialog, FORM_CLASS):
    pass
        

FORM_CLASS = get_ui_class('cad_add_point.ui')
class Cad_add_point(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('change_node_type.ui')
class ChangeNodeType(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('credentials.ui')
class Credentials(GwDialog, FORM_CLASS):

    def __init__(self, subtag=None):

        super().__init__()
        self.txt_pass.setClearButtonEnabled(True)
        icon_path = os.path.dirname(__file__) + os.sep + 'icons' + os.sep + 'eye_open.png'
        self.action = QAction("show")
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action = QAction(icon, "show")
        self.action.triggered.connect(self.show_pass)
        self.txt_pass.addAction(self.action, QLineEdit.TrailingPosition)


    def show_pass(self):

        if self.txt_pass.echoMode() == 0:
            self.txt_pass.setEchoMode(QLineEdit.Password)
            icon_path = os.path.dirname(__file__) + os.sep + 'icons' + os.sep + 'eye_open.png'
            text = "Show password"
        elif self.txt_pass.echoMode() == 2:
            self.txt_pass.setEchoMode(QLineEdit.Normal)
            icon_path = os.path.dirname(__file__) + os.sep + 'icons' + os.sep + 'eye_close.png'
            text = "Hide password"
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action.setIcon(icon)
            self.action.setText(text)


FORM_CLASS = get_ui_class('crm_trace.ui')
class DlgTrace(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('csv2pg.ui')
class Csv2Pg(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('delete_feature.ui')
class DelFeature(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('doc.ui')
class DocUi(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('doc_management.ui')
class DocManagement(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('draw_profile.ui')
class DrawProfile(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('duplicate_psector.ui')
class DupPsector(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('element_management.ui')
class ElementManagement(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('epa_result_compare_selector.ui')
class EpaResultCompareSelector(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('epa_result_manager.ui')
class EpaResultManager(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('event_full.ui')
class EventFull(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('event_standard.ui')
class EventStandard(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('event_ud_arc_rehabit.ui')
class EventUDarcRehabit(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('event_ud_arc_standard.ui')
class EventUDarcStandard(GwDialog, FORM_CLASS):
    pass


# TODO change file and class name to go2epa
FORM_CLASS = get_ui_class('file_manager.ui')
class FileManager(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('gallery.ui')
class Gallery(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('gallery_zoom.ui')
class GalleryZoom(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('hydrology_selector.ui')
class HydrologySelector(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('info_show_info.ui')
class InfoShowInfo(GwDialog, FORM_CLASS):
    pass

# TODO change file and class name to workcat_search
FORM_CLASS = get_ui_class('list_items.ui')
class ListItems(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('load_documents.ui')
class LoadDocuments(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('load_profiles.ui')
class LoadProfiles(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('lot_management.ui')
class LotManagement(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('manage_addfields.ui')
class ManageFields(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('manage_sys_fields.ui')
class ManageSysFields(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('manage_visit_class.ui')
class ManageVisitClass(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('manage_visit_param.ui')
class ManageVisitParam(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('mincut.ui')
class Mincut(GwMainWindow, FORM_CLASS):

    def __init__(self):
        self.closeMainWin = False
        self.mincutCanceled = True
        super().__init__()


FORM_CLASS = get_ui_class('mincut_add_connec.ui')
class Mincut_add_connec(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('mincut_add_hydrometer.ui')
class Mincut_add_hydrometer(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('mincut_composer.ui')
class MincutComposer(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('mincut_edit.ui')
class Mincut_edit(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('mincut_fin.ui')
class Mincut_fin(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('multirow_selector.ui')
class Multirow_selector(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('new_workcat.ui')
class NewWorkcat(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('feature_replace.ui')
class FeatureReplace(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('plan_estimate_result_manager.ui')
class EstimateResultManager(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('plan_estimate_result_new.ui')
class EstimateResultNew(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('plan_estimate_result_selector.ui')
class EstimateResultSelector(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('plan_psector.ui')
class Plan_psector(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('psector_management.ui')
class Psector_management(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('psector_rapport.ui')
class Psector_rapport(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('qm_generator.ui')
class QmGenerator(GwDialog, FORM_CLASS):

    def __init__(self, subtag=None):

        super().__init__()
        self.txt_pass.setClearButtonEnabled(True)
        icon_path = os.path.dirname(__file__) + os.sep + 'icons' + os.sep + 'eye_open.png'
        self.action = QAction("show")
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action = QAction(icon, "show")
        self.action.triggered.connect(self.show_pass)
        self.txt_pass.addAction(self.action, QLineEdit.TrailingPosition)


    def show_pass(self):

        if self.txt_pass.echoMode() == 0:
            self.txt_pass.setEchoMode(QLineEdit.Password)
            icon_path = os.path.dirname(__file__) + os.sep + 'icons' + os.sep + 'eye_open.png'
            text = "Show password"
        elif self.txt_pass.echoMode() == 2:
            self.txt_pass.setEchoMode(QLineEdit.Normal)
            icon_path = os.path.dirname(__file__) + os.sep + 'icons' + os.sep + 'eye_close.png'
            text = "Hide password"
        if os.path.exists(icon_path):
            icon = QIcon(icon_path)
            self.action.setIcon(icon)
            self.action.setText(text)


FORM_CLASS = get_ui_class('readsql.ui')
class Readsql(GwMainWindow, FORM_CLASS):
    dlg_closed = QtCore.pyqtSignal()
    pass


FORM_CLASS = get_ui_class('readsql_create_project.ui')
class ReadsqlCreateProject(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('readsql_create_gis_project.ui')
class ReadsqlCreateGisProject(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('readsql_rename_copy.ui')
class ReadsqlRenameCopy(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('readsql_show_info.ui')
class ReadsqlShowInfo(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('sections.ui')
class Sections(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('selector_date.ui')
class SelectorDate(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('user_management.ui')
class UserManagement(GwMainWindow, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('visit_management.ui')
class VisitManagement(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('workcat_end.ui')
class WorkcatEnd(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('workcat_end_list.ui')
class WorkcatEndList(GwDialog, FORM_CLASS):
    pass


""" Tree Manage forms """
FORM_CLASS = get_ui_class('add_visit.ui', 'tm')
class AddVisitTm(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('event_standard.ui', 'tm')
class EventStandardTm(GwDialog, FORM_CLASS):
    pass

FORM_CLASS = get_ui_class('incident_planning.ui', 'tm')
class IncidentPlanning(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('incident_manager.ui', 'tm')
class IncidentManager(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('info_incident.ui', 'tm')
class InfoIncident(GwDialog, FORM_CLASS):
    pass


FORM_CLASS = get_ui_class('planning_unit.ui', 'tm')
class PlaningUnit(GwDialog, FORM_CLASS):
    pass
