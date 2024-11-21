import warnings

from ._helpers import SwmmApiInputMacrosWarning
from .. import SEC
from ..sections import CrossSection
from ..inp import SwmmInput


def get_cross_section_maker(inp, link_label):
    """
    Get a cross-section object.

    Object type from the package `SWMM-xsections-shape-generator` to analyse and plot cross-sections.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        link_label (str): label of the link, where the cross-section is wanted

    Returns:
        shape_generator.CrossSection: cross-section object of the selected link
    """
    if SEC.XSECTIONS not in inp:
        return

    if link_label not in inp.XSECTIONS:
        return

    return to_cross_section_maker(inp.XSECTIONS[link_label], inp)


def to_cross_section_maker(xs: CrossSection, inp: SwmmInput = None):
    try:
        import shape_generator
        from shape_generator.swmm_predefined import (Egg, Circular, CircularFilled, RectangularOpen, RectangularClosed,
                                                     RectangularRound, RectangularTriangular, Triangular, Parabolic,
                                                     Power, Trapezoidal)
    except ImportError as e:
        warnings.warn('Missing package: pip install SWMM-xsections-shape-generator', SwmmApiInputMacrosWarning)
        return

    if xs.shape == CrossSection.SHAPES.CUSTOM:
        curve = inp.CURVES[xs.curve_name]
        return shape_generator.CrossSection.from_curve(curve, height=xs.height)

    elif xs.shape == CrossSection.SHAPES.IRREGULAR:  # Todo: I don't know how
        return

    elif xs.shape == CrossSection.SHAPES.CIRCULAR:
        return Circular(xs.height, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.FILLED_CIRCULAR:
        return CircularFilled(xs.height, xs.parameter_2, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.EGG:
        return Egg(xs.height, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.RECT_OPEN:
        return RectangularOpen(xs.height, xs.parameter_2, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.RECT_CLOSED:
        return RectangularClosed(xs.height, xs.parameter_2, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.RECT_ROUND:
        return RectangularRound(xs.height, xs.parameter_2, xs.parameter_3, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.RECT_TRIANGULAR:
        return RectangularTriangular(xs.height, xs.parameter_2, xs.parameter_3, label=xs.link)

    elif xs.shape == CrossSection.SHAPES.TRIANGULAR:
        return Triangular(xs.height, xs.parameter_2, label=xs.link)

    elif xs.shape in (CrossSection.SHAPES.CIRCULAR,
                      CrossSection.SHAPES.EGG,
                      CrossSection.SHAPES.HORSESHOE,
                      CrossSection.SHAPES.GOTHIC,
                      CrossSection.SHAPES.CATENARY,
                      CrossSection.SHAPES.SEMIELLIPTICAL,
                      CrossSection.SHAPES.BASKETHANDLE,
                      CrossSection.SHAPES.SEMICIRCULAR):
        # ++ only Height ++
        return shape_generator.swmm_std_cross_sections(xs.shape, height=xs.height, label=xs.link)

    elif xs.shape in (CrossSection.SHAPES.ARCH,
                      CrossSection.SHAPES.HORIZ_ELLIPSE,
                      CrossSection.SHAPES.VERT_ELLIPSE):
        # ++ Height+Width ++
        return shape_generator.swmm_std_cross_sections(xs.shape, height=xs.height, width=xs.parameter_2, label=xs.link)

    elif xs.shape == CrossSection.SHAPES.PARABOLIC:
        return Parabolic(xs.height, xs.parameter_2, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.POWER:
        return Power(xs.height, xs.parameter_2, xs.parameter_3, label=xs.link)
    elif xs.shape == CrossSection.SHAPES.TRAPEZOIDAL:
        return Trapezoidal(xs.height, xs.parameter_2, xs.parameter_3, xs.parameter_4, label=xs.link)
    else:
        # Todo: ??? Not Implemented: CrossSection.SHAPES.TRAPEZOIDAL, CrossSection.SHAPES.MODBASKETHANDLE
        raise NotImplementedError(f'Shape {xs.shape} is not implemented (yet).')


def profil_area(inp, link_label):
    """
    Get the area of the link with a given cross-section.

    Args:
        inp (swmm_api.SwmmInput): SWMM input-file data.
        link_label (str): label of the link, where the cross-section area is wanted

    Returns:
        float: area of the cross-section in m²
    """
    cs = get_cross_section_maker(inp, link_label)
    if cs is not None:
        return cs.area_v

# def velocity(inp, link_label, flow): # TODO
#     cs = get_cross_section_maker(inp, link_label)
#     if cs is None:
#         return
#     xs = inp.XSECTIONS[link_label]
