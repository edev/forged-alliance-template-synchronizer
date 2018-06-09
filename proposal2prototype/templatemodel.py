from .buildorder import BuildOrder
from .classbuildorder import ClassBuildOrder
from .unit import Unit
from .unitclass import UnitClass


class TemplateModel:
    """Represents a set of compatible templates in the form of a list of ClassBuildOrders."""

    @staticmethod
    def create(unit_classes, templates, tech_level):
        """Constructs a list of ClassBuildOrders from multiple lists of BuildOrders.

        unit_classes: a list of UnitClass objects representing the first-match list of unit classes.
        templates: a list of templates (see below).
        tech_level: the tech level of engineer required to build the templates. This will restrict UnitClasses.

        After unit_classes, pass in any desired lists of BuildOrder objects. Within each list, each BuildOrder.unit
        should be of the same faction. (This requirement is not verified, since this is a prototype.) Each list
        represents one template. If the templates are compatible, a list of ClassBuildOrders will be created,
        and a TemplateModel will be returned. If not, None will be returned."""

        # If all goes well, we'll put cbo_list in a TemplateModel and return that.
        cbo_list = []

        # We'll need one index per input template, since we won't advance indices when we match None within a UnitClass.
        indices = [0] * len(templates)

        # We'll keep going through the loop until there are no more unmatched BuildOrders in any of the templates.
        keep_going = TemplateModel.__check_indices(indices, templates)
        while keep_going:
            # Create a list of build_orders we're going to check.
            build_orders = []
            for i in range(len(templates)):
                if indices[i] < len(templates[i]):
                    # Append build_orders only when the indices are in-bounds.
                    build_orders.append(templates[i][indices[i]])

            # Scan through unit classes until we find a match - hopefully. Accept the first match.
            cbo = None
            for uc in unit_classes:
                # Attempt to create a ClassBuildOrder from uc and build_orders.
                cbo = ClassBuildOrder.safely_create(uc, build_orders, tech_level)

                if type(cbo) is ClassBuildOrder:
                    # Creation succeeded! This is our match.
                    cbo_list.append(cbo)
                    break
                else:
                    # Creation failed. Not a valid combo. Try the next UnitClass.
                    continue

            if type(cbo) is ClassBuildOrder:
                # Match found.

                # Update indices, but only for factions whose build_orders are not None.
                for i in range(len(indices)):
                    if cbo.unit_class.get( templates[i][0].unit.faction ) is not None:
                        indices[i] += 1
            else:
                # Uh oh. Incompatible templates.

                # Join all of the uid strings
                uid_list = []
                uids = ", "     # Initially, just the delimiter for String.join.
                for i in range(len(templates)):
                    if indices[i] < len(templates[i]):
                        uid_list.append(templates[i][indices[i]].unit.uid)
                uids = uids.join(uid_list)

                print("Could not find a match for {}".format(uids))
                return None

            # Check whether we should still keep going.
            keep_going = TemplateModel.__check_indices(indices, templates)

        # We've successfully built cbo_list without encountering any errors, and we've fully processed all templates.
        # Great! So, time to build the TemplateModel and return it.
        tm = TemplateModel()
        tm.class_build_orders = cbo_list
        return tm

    @staticmethod
    def __check_indices(indices, templates) -> bool:
        """Returns true if at least one template has not been fully processed. Returns false otherwise."""

        if len(indices) != len(templates):
            raise ValueError("there must be the same number of indices as templates.")

        for num in range(len(indices)):
            if indices[num] < len(templates[num]):
                return True
        return False
