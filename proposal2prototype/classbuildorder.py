from .unitclass import UnitClass


class ClassBuildOrder:
    """Represents a generic build order, that is, an order to be given to an engineer to construct a structure as
    part of a template, but specified using a UnitClass rather than any specific Unit."""

    @staticmethod
    def safely_create(unit_class: UnitClass, build_orders, tech_level):
        """Safely create a ClassBuildOrder object representing the given UnitClass and a list of BuildOrders.

        The xy-coordinates for all build_orders must match, and the build_orders' units must line up with the
        UnitClass. If these all match, a ClassBuildOrder will be returned. Otherwise, None will be returned."""

        # Make sure build_orders isn't empty.
        if build_orders is None or len(build_orders) == 0:
            print("Notice: ClassBuildOrder.create called with empty build_orders. type(build_orders): {}".format(
                type(build_orders)))
            return None

        # Create a dictionary for UnitClass.matches.
        matchee = {}
        for bo in build_orders:
            matchee[bo.unit.faction] = bo.unit

        # Verify that the UnitClass matches
        if not unit_class.matches(matchee, tech_level):
            return None

        # Verify that the xy-coordinates match
        expected_x = build_orders[0].x
        expected_y = build_orders[0].y
        for bo in build_orders[1:]:
            if bo.x != expected_x or bo.y != expected_y:
                return None

        return ClassBuildOrder(unit_class, expected_x, expected_y)

    def __init__(self, unit_class: UnitClass, x: int, y: int):
        self.unit_class = unit_class
        self.x = x
        self.y = y
