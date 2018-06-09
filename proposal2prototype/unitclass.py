from .unit import Unit


class UnitClass:
    """Represents an equivalence class of units, one of each faction (where any may be None)."""

    def __init__(self, name: str) -> None:
        super(UnitClass, self).__init__()
        self._dict = {}
        self.name = name

    def set(self, faction: str, unit: Unit) -> None:
        self._dict[faction] = unit

    def get(self, faction: str):
        return self._dict[faction]

    def tech_level(self) -> int:
        """Returns the maximum tech level of all units in the equivalence class."""

        # tl: tech level.
        tl: int = 0
        for unit in self._dict.values():
            tl = max(tl, unit.tech_level)
        return tl

    def matches(self, units: dict, tech_level) -> bool:
        """Returns True if the UnitClass is compatible with the unit set. Returns False otherwise."""

        if tech_level < self.tech_level():
            # This UnitClass would elevate the tech level of at least one template. So it can't match.
            return False

        for (faction, unit) in units.items():
            if self._dict[faction] is None:
                # Skip this faction.
                continue

            if self._dict[faction] != units[faction]:
                # Mismatch.
                return False

        # Success.
        return True


def create_unit_classes(units):
    """Creates an ordered list of UnitClasses. Any and all UnitClasses required for the test inputs should appear here.
    """

    t1mex = UnitClass("T1 Mass Extractor")
    t1mex.set('a', units['uab1103'])
    t1mex.set('e', units['ueb1103'])
    t1mex.set('r', units['urb1103'])
    t1mex.set('s', units['usb1103'])

    t1mstor = UnitClass("T1 Mass Storage")
    t1mstor.set('a', units['uab1106'])
    t1mstor.set('e', units['ueb1106'])
    t1mstor.set('r', units['urb1106'])
    t1mstor.set('s', units['usb1106'])

    t3shield = UnitClass("T3 Heavy Shield Generator")
    t3shield.set('a', units['uab4301'])
    t3shield.set('e', units['ueb4301'])
    t3shield.set('r', units['urb4202'])
    t3shield.set('s', units['xsb4301'])

    t2shield = UnitClass("T2 Shield Generator")
    t2shield.set('a', units['uab4202'])
    t2shield.set('e', units['ueb4202'])
    t2shield.set('r', units['urb4202'])
    t2shield.set('s', units['xsb4202'])

    t3pd = UnitClass("T3 Point Defense")
    t3pd.set("a", units['uab2301'])
    t3pd.set("e", units['xeb2306'])
    t3pd.set("r", units['urb2301'])
    t3pd.set("s", units['xsb2301'])

    t2pd = UnitClass("T2 Point Defense")
    t2pd.set("a", units['uab2301'])
    t2pd.set("e", units['ueb2301'])
    t2pd.set("r", units['urb2301'])
    t2pd.set("s", units['xsb2301'])

    t2tmd = UnitClass("T2 Tactical Missile Defense")
    t2tmd.set("a", units['uab4201'])
    t2tmd.set("e", units['ueb4201'])
    t2tmd.set("r", units['urb4201'])
    t2tmd.set("s", units['xsb4201'])

    t3aa = UnitClass("T3 Anti-Air Defense")
    t3aa.set("a", units['uab2304'])
    t3aa.set("e", units['ueb2304'])
    t3aa.set("r", units['urb2304'])
    t3aa.set("s", units['xsb2304'])

    return [
        t1mex,
        t1mstor,
        t3shield,
        t2shield,
        t3pd,
        t2pd,
        t2tmd,
        t3aa,
    ]
