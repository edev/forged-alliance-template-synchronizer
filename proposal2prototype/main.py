from proposal2prototype.template_groups import create_template_groups, tech_level as tg_level
from proposal2prototype.templatemodel import TemplateModel
from proposal2prototype.unit import create_units
from proposal2prototype.unitclass import create_unit_classes


if __name__ == "__main__":
    # 1. Create a dictionary of Units, keyed by UID strings. These are the canonical Unit objects.
    units = create_units()

    # 2. Create a list of UnitClasses to search through, in order. This is the first-match list of classes.
    unit_classes = create_unit_classes(units)

    # Create a list of template groups to be passed into TemplateModel.
    template_groups = create_template_groups(units)

    # Create TemplateModels.
    template_models = []
    for tgroup in template_groups:
        # Attempt to create a TM from the tgroup; only append if the return is a TM (rather than None).
        tm = TemplateModel.create(unit_classes, tgroup, tg_level(tgroup))
        if type(tm) is TemplateModel:
            template_models.append(tm)

    # Display resulting templates.
    print("We can now generate the following templates from our TemplateModels:\n")
    for tm in template_models:
        for faction in ['a', 'e', 'r', 's']:
            for cbo in tm.class_build_orders:
                print("{} at ({}, {})".format(
                    cbo.unit_class.get(faction).name,
                    cbo.x,
                    cbo.y
                ))
            print()
