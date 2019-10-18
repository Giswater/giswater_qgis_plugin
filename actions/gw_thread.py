
from time import sleep
from qgis.core import QgsTask, QgsApplication
from qgis.PyQt.QtCore import pyqtSignal, QObject
from .parent import ParentAction
import random
from time import sleep
from ..ui_manager import SelectorDate
from qgis.core import QgsApplication, QgsTask, QgsMessageLog, Qgis
MESSAGE_CATEGORY = 'giswater'
class GwTask(QgsTask):
    """This shows how to subclass QgsTask"""
    def __init__(self, description):
        super().__init__(description, QgsTask.CanCancel)
        self.exception = None
    def run(self):
        """Here you implement your heavy lifting. This method should
        periodically test for isCancelled() to gracefully abort.
        This method MUST return True or False
        raising exceptions will crash QGIS so we handle them internally and
        raise them in self.finished
        """

        QgsMessageLog.logMessage(f'Started task {self.description()}', MESSAGE_CATEGORY, Qgis.Info)
        if self.isCanceled():
            print(f"IS CANCELED")
            return False
        if self.progress() >= 100:
            print(f"IS self.progress()")
            return True

        return True
        # wait_time = self.duration / 1000
        # sleep(wait_time)
        # for i in range(101):
        #     sleep(wait_time)
        #     # use setProgress to report progress
        #     self.setProgress(i)
        #
        #     self.total += random.randint(0, 100)
        #     self.iterations += 1
        #     # check isCanceled() to handle cancellation
        #     if self.isCanceled():
        #         return False
        #     # simulate exceptions to show how to abort task
        #     if random.randint(0, 500) == 42:
        #         # DO NOT raise Exception('bad value!')
        #         # this would crash QGIS
        #         self.exception = Exception('bad value!')
        #         return False
        # return True

    def open_form(self):
        dlg =SelectorDate()
        dlg.open()

    def finished(self, result):
        """This method is automatically called when self.run returns. result
        is the return value from self.run.
        This function is automatically called when the task has completed (
        successfully or otherwise). You just implement finished() to do whatever
        follow up stuff should happen after the task is complete. finished is
        always called from the main thread, so it's safe to do GUI
        operations and raise Python exceptions here.
        """
        if result:
            QgsMessageLog.logMessage(f'Task "{self.description()}" completed', MESSAGE_CATEGORY, Qgis.Success)
        else:
            if self.exception is None:
                QgsMessageLog.logMessage(f'Task "{self.description()}" not successful but without exception ',
                                         MESSAGE_CATEGORY, Qgis.Warning)
            else:
                QgsMessageLog.logMessage(f'Task "{self.description()}" Exception: {self.exception}',
                                         MESSAGE_CATEGORY, Qgis.Critical)
                raise self.exception


    def cancel(self):
        QgsMessageLog.logMessage(f'Task "{self.description()}" was cancelled', MESSAGE_CATEGORY, Qgis.Info)
        super().cancel()
