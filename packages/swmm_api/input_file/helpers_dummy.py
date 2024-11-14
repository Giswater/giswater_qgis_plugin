import pandas as pd

from swmm_api.input_file.helpers import BaseSectionObject, InpSection, COMMENT_EMPTY_SECTION, dataframe_to_inp_string


class InpSectionDummy(InpSection):
    def __init__(self, section_object):
        super().__init__(section_object)
        self._data = list()

    def __setitem__(self, key, value):
        self._data.append(value)

    @property
    def _identifier(self): ...

    @property
    def _index_labels(self): ...

    def add_obj(self, obj):
        self._data.append(obj)

    def get_objects(self, sort_alphabetical=False):
        return self.objects

    def get_dataframe(self, set_index=True, sort_objects_alphabetical=False):
        if not self:  # if empty
            return pd.DataFrame()
        df = pd.DataFrame([i.to_dict_() for i in self.get_objects(sort_objects_alphabetical)])
        return df

    def keys(self):
        return list(range(len(self._data)))

    def values(self):
        return self.objects

    def to_inp_lines(self, fast=False, sort_objects_alphabetical=False):
        """
        Convert the section to a multi-line ``.inp``-file conform string.

        This function is used for the ``.inp``-file writing

        Args:
            fast (bool): speeding up conversion

                - :obj:`True`: if no special formation of the input file is needed
                - :obj:`False`: section is converted into a table to prettify string output (slower)

            sort_objects_alphabetical (bool): if objects in a section should be sorted alphabetical |
                default: use order of the read inp-file and append new objects

        Returns:
             str: lines of the ``.inp``-file section
        """
        if not self:  # if empty
            return COMMENT_EMPTY_SECTION

        if fast or not self._table_inp_export:
            return '\n'.join(self.iter_inp_lines(sort_objects_alphabetical)) + '\n'
        else:
            return dataframe_to_inp_string(self.get_dataframe(set_index=True,
                                                              sort_objects_alphabetical=sort_objects_alphabetical),
                                           index=False)

    def __iter__(self):
        return self.keys()

    def items(self):
        return zip(range(len(self)), self._data)

    def update(self, d=None, **kwargs):
        self._data += d


class DummySectionObject(BaseSectionObject):
    _identifier = None
    _section_class = InpSectionDummy
    _section_label = None
    # _table_inp_export = False

    def __init__(self, *args, **kwargs):
        n_args = len(args) + len(kwargs)
        args_ = list(args)[::-1]
        for i in range(n_args):
            param_label = f'parameter_{i}'
            if param_label in kwargs:
                self.__setattr__(param_label, kwargs[param_label])
            else:
                self.__setattr__(param_label, args_.pop())
