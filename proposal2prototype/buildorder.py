from .unit import Unit


class BuildOrder:
    """Represents a build order, that is, a specific order to be issued to an engineer to construct a structure,
    in a template."""

    def __init__(self, unit: Unit, x: int, y: int):
        self.unit = unit
        self.x = x
        self.y = y