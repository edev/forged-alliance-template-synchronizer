from proposal2prototype.buildorder import BuildOrder


def tech_level(template_group):
    """Returns the maximum tech level of the template group."""

    tl = 0
    for template in template_group:
        for build_order in template:
            tl = max(tl, build_order.unit.tech_level)
    return tl


def t1mex(units):
    """T1 Mass Extractor templates.

    Designed to be a very basic test."""

    aeon = [
        BuildOrder(
            units['ueb1103'],
            0,
            0
        ),
        BuildOrder(
            units['ueb1106'],
            0,
            -2
        ),
        BuildOrder(
            units['ueb1106'],
            2,
            0
        ),
        BuildOrder(
            units['ueb1106'],
            0,
            2
        ),
        BuildOrder(
            units['ueb1106'],
            -2,
            0
        ),
    ]
    uef = [
        BuildOrder(
            units['ueb1103'],
            0,
            0
        ),
        BuildOrder(
            units['ueb1106'],
            0,
            -2
        ),
        BuildOrder(
            units['ueb1106'],
            2,
            0
        ),
        BuildOrder(
            units['ueb1106'],
            0,
            2
        ),
        BuildOrder(
            units['ueb1106'],
            -2,
            0
        ),
    ]
    return [aeon, uef]


def heavydefenseline(units):
    """T3 Heavy Defense Line, based on UEF spec.

    Designed to test whether the UEF T3 PD and UEF T2 PD both translate correctly and whether the T3 Heavy Shield
    Generators translate correctly to the Cybran T2 Shield Generator."""

    uef = [
        BuildOrder(
            units['ueb4301'],
            0,
            0
        ),
        BuildOrder(
            units['xeb2306'],
            -2,
            8
        ),
        BuildOrder(
            units['ueb4201'],
            -2,
            16
        ),
        BuildOrder(
            units['ueb2304'],
            -2,
            4
        ),
        BuildOrder(
            units['ueb2301'],
            12,
            0
        ),
    ]
    return [uef]


def t2cybrandefenses(units):
    """Designed to test whether T2 structures remain at T2 in a T2 template. Shields and point defense could
    incorrectly translate to T3 but should remain at T2 if the system is correct."""

    cybran = [
        BuildOrder(
            units['urb2301'],   # T2 PD
            0,
            0
        ),
        BuildOrder(
            units['urb4202'],   # T2 shield generator
            2,
            0
        ),
        BuildOrder(
            units['urb4201'],   # T2 TMD
            6,
            0
        )
    ]
    return [cybran]


def t3cybrandefenses(units):
    """Designed to test whether T2 structures translate to T3 in a T3 template. Shields and UEF point defense
    should translate to T3."""
    cybran = [
        BuildOrder(
            units['urb2301'],   # T2 PD
            0,
            0
        ),
        BuildOrder(
            units['urb4202'],   # T2 shield generator
            2,
            0
        ),
        BuildOrder(
            units['urb2304'],   # SAM launcher
            6,
            0
        )
    ]
    return [cybran]


def create_template_groups(units):
    """Creates a list of template groups for the test sequence.

    Each template is a list of BuildOrders.
    Each template group is a list of templates to be passed into TemplateModel.create.

    Returns a list of template groups, i.e. [[template1, template2, template3], [template4, template5], ...]"""

    return [
        # t1mex(units),
        # heavydefenseline(units),
        # t2cybrandefenses(units),
        t3cybrandefenses(units),
    ]
