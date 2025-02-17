from .. import SEC
from ..inp import SwmmInput
from .macros import nodes_dict, calc_slope
from .tags import get_link_tags
from ..sections import CrossSection, Loss, Vertices
from ..sections import Junction, Storage, Outfall, Coordinate, DryWeatherFlow, Inflow, RainfallDependentInfiltrationInflow, Treatment
from ..sections.link import _Link, Conduit, Orifice, Outlet, Pump, Weir
import shape_generator


class SuperConduit(Conduit, CrossSection, Loss, Vertices):
    def __init__(self, inp, conduit, cross_section, loss=None, vertices=None, tag=None):
        self.inp = inp
        Conduit.__init__(self, **conduit.to_dict_())
        CrossSection.__init__(self, **cross_section.to_dict_())
        if loss is not None:
            Loss.__init__(self, **loss.to_dict_())
        if vertices is not None:
            Vertices.__init__(self, **vertices.to_dict_())
        self.tag = tag

        self._nodes = nodes_dict(self.inp)

    @classmethod
    def from_inp(cls, inp, label):
        """

        Args:
            inp (swmm_api.SwmmInput): SWMM input-file data.
            label (str): label of the conduit.

        Returns:
            SuperConduit: conduit object with combined attrubutes.
        """
        if SEC.CONDUITS in inp and label in inp.CONDUITS:
            loss = None
            if SEC.LOSSES in inp and label in inp.LOSSES:
                loss = inp.LOSSES[label]

            vertices = None
            if SEC.VERTICES in inp and label in inp.VERTICES:
                vertices = inp.VERTICES[label]
            tag = None
            tags = get_link_tags(inp)
            if SEC.TAGS in inp and label in tags:
                tag = tags[label]
            return cls(inp, inp.CONDUITS[label], inp.XSECTIONS[label], loss, vertices, tag)

    @property
    def curve_obj(self):
        if self.shape == CrossSection.SHAPES.CUSTOM:
            return self.inp.CURVES[self.curve_name]

    @property
    def shape_generator(self):
        if self.shape == CrossSection.SHAPES.CUSTOM:
            return shape_generator.CrossSection.from_curve(self.curve_obj, height=self.height)
        elif self.shape == CrossSection.SHAPES.IRREGULAR:
            return  # Todo: I don't know how
        elif self.shape in [CrossSection.SHAPES.RECT_OPEN, CrossSection.SHAPES.RECT_CLOSED]:
            return  # Todo: Rect
        else:
            return shape_generator.swmm_std_cross_sections(self.shape, height=self.height)

    @property
    def profil_area(self):
        if self.shape == CrossSection.SHAPES.CUSTOM:
            return self.shape_generator.area_v
        elif self.shape == CrossSection.SHAPES.IRREGULAR:
            return  # Todo: I don't know how
        elif self.shape in [CrossSection.SHAPES.RECT_OPEN, CrossSection.SHAPES.RECT_CLOSED]:
            return self.height * self.parameter_2
        else:
            return self.shape_generator.area_v

    @property
    def from_node_obj(self):
        return self._nodes[self.from_node]

    @property
    def to_node_obj(self):
        return self._nodes[self.to_node]

    @property
    def slope(self):
        return (self.from_node.elevation + self.offset_upstream - (
                self.to_node.elevation + self.offset_downstream)) / self.length


class Node(Junction, Storage, Outfall, Coordinate, DryWeatherFlow, Inflow, RainfallDependentInfiltrationInflow, Treatment):
    def __init__(self):
        Junction.__init__(self)
