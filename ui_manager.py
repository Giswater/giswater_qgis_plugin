# -*- coding: utf-8 -*-
from qgis.PyQt import uic, QtCore
from qgis.PyQt.QtWidgets import QMainWindow, QDialog, QDockWidget
import os


def get_ui_class(ui_file_name):
    """ Get UI Python class from @ui_file_name """

    # Folder that contains UI files
    ui_folder_path = os.path.dirname(__file__) + os.sep + 'ui'
    ui_file_path = os.path.abspath(os.path.join(ui_folder_path, ui_file_name))
    return uic.loadUiType(ui_file_path)[0]


FORM_CLASS = get_ui_class('add_doc.ui')
class AddDoc(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_element.ui')
class AddElement(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_lot.ui')
class AddLot(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_picture.ui')
class AddPicture(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('api_composers.ui')
class ApiComposerUi(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('api_toolbox.ui')
class ApiDlgToolbox(QDockWidget, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('api_toolbox_functions.ui')
class ApiFunctionTb(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('add_sum.ui')
class AddSum(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)
        
        
FORM_CLASS = get_ui_class('add_visit.ui')
class AddVisit(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('api_config.ui')
class ApiConfigUi(QMainWindow, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('api_epa_options.ui')
class ApiEpaOptions(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('arc_fusion.ui')
class ArcFusion(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('audit_check_project_result.ui')
class AuditCheckProjectResult(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('cad_add_circle.ui')
class Cad_add_circle(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)
        

FORM_CLASS = get_ui_class('cad_add_point.ui')
class Cad_add_point(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('change_node_type.ui')
class ChangeNodeType(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('csv2pg.ui')
class Csv2Pg(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('doc_management.ui')
class DocManagement(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('draw_profile.ui')
class DrawProfile(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('element_management.ui')
class ElementManagement(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('epa_result_compare_selector.ui')
class EpaResultCompareSelector(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('epa_result_manager.ui')
class EpaResultManager(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_full.ui')
class EventFull(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_standard.ui')
class EventStandard(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_ud_arc_rehabit.ui')
class EventUDarcRehabit(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('event_ud_arc_standard.ui')
class EventUDarcStandard(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('file_manager.ui')
class FileManager(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('gallery.ui')
class Gallery(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('gallery_zoom.ui')
class GalleryZoom(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('hydrology_selector.ui')
class HydrologySelector(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('info_show_info.ui')
class InfoShowInfo(QDialog, FORM_CLASS):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('load_documents.ui')
class LoadDocuments(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('load_profiles.ui')
class LoadProfiles(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut.ui')
class Mincut(QMainWindow, FORM_CLASS):
    dlg_rejected = QtCore.pyqtSignal()
    def __init__(self):
        self.closeMainWin = False
        self.mincutCanceled = True
        QDialog.__init__(self)
        self.setupUi(self)

    def closeEvent(self, event):
        """ Overwrite closeEvent method """

        if self.closeMainWin:
            event.accept()
            if self.mincutCanceled:
                self.dlg_rejected.emit()
                return super(Mincut, self).closeEvent(event)
        else:
            event.accept()
            # QMessageBox.information(self, "", "Press cancel to exit")
            # event.ignore()


FORM_CLASS = get_ui_class('mincut_add_connec.ui')
class Mincut_add_connec(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_add_hydrometer.ui')
class Mincut_add_hydrometer(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_composer.ui')
class MincutComposer(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)        


FORM_CLASS = get_ui_class('mincut_edit.ui')
class Mincut_edit(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_fin.ui')
class Mincut_fin(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('mincut_selector.ui')
class Multi_selector(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('multirow_selector.ui')
class Multirow_selector(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)

FORM_CLASS = get_ui_class('new_workcat.ui')
class NewWorkcat(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('node_replace.ui')
class NodeReplace(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_estimate_result_manager.ui')
class EstimateResultManager(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_estimate_result_new.ui')
class EstimateResultNew(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_estimate_result_selector.ui')
class EstimateResultSelector(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('plan_psector.ui')
class Plan_psector(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('psector_management.ui')
class Psector_management(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('psector_rapport.ui')
class Psector_rapport(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('readsql.ui')
class Readsql(QMainWindow, FORM_CLASS):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('readsql_create_project.ui')
class ReadsqlCreateProject(QMainWindow, FORM_CLASS):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('readsql_create_gis_project.ui')
class ReadsqlCreateGisProject(QMainWindow, FORM_CLASS):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('readsql_rename.ui')
class ReadsqlRename(QMainWindow, FORM_CLASS):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('readsql_show_info.ui')
class ReadsqlShowInfo(QMainWindow, FORM_CLASS):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('selector_date.ui')
class SelectorDate(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('toolbox.ui')
class Toolbox(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('ud_catalog.ui')
class UDcatalog(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('cf_ud_catalog.ui')
class CFUDcatalog(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('visit_management.ui')
class VisitManagement(QDialog, FORM_CLASS):
    def __init__(self):
        super(VisitManagement, self).__init__()
        self.setupUi(self)


FORM_CLASS = get_ui_class('workcat_end.ui')
class WorkcatEnd(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('ws_catalog.ui')
class WScatalog(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('cf_ws_catalog.ui')
class CFWScatalog(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)


FORM_CLASS = get_ui_class('workcat_end_list.ui')
class WorkcatEndList(QDialog, FORM_CLASS):
    def __init__(self):
        QDialog.__init__(self)
        self.setupUi(self)