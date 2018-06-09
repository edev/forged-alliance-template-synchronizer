class Unit:
    """Represents an in-game unit from a build template, with canonical (hopefully correct) information about it.

    This class corrects for inaccuracies in UIDs. For instance, some structures have UIDs that indicate a different
    tech level than the structures actually have, so this UID-encoded information cannot be treated as correct.

    This is a prototype class, but the eventual C# implementation may be able to read a Lua .bp file to load information
    from the canonical source the game itself uses."""

    def __init__(self, name: str, uid: str, tech_level: int, faction: str) -> None:
        super().__init__()

        self.name = name
        self.uid = uid
        self.tech_level = tech_level
        self.faction = faction


def create_units():
    """Creates a dictionary of Units keyed by uid. Any and all units required for the test inputs should appear here."""

    return {
        # T1 Mass Extractors
        'uab1103': Unit("Aeon T1 Mass Extractor", "uab1103", 1, "a"),
        'ueb1103': Unit("UEF T1 Mass Extractor", "ueb1103", 1, "e"),
        'urb1103': Unit("Cybran T1 Mass Extractor", "urb1103", 1, "r"),
        'usb1103': Unit("Seraphim T1 Mass Extractor", "usb1103", 1, "s"),

        # T1 Mass Storage
        'uab1106': Unit("Aeon T1 Mass Storage", "uab1106", 1, "a"),
        'ueb1106': Unit("UEF T1 Mass Storage", "ueb1106", 1, "e"),
        'urb1106': Unit("Cybran T1 Mass Storage", "urb1106", 1, "r"),
        'usb1106': Unit("Seraphim T1 Mass Storage", "usb1106", 1, "s"),

        # T3 Shield Generator
        'uab4301': Unit("Aeon T3 Heavy Shield Generator", "uab4301", 3, "a"),
        'ueb4301': Unit("UEF T3 Heavy Shield Generator", "ueb4301", 3, "e"),
        'xsb4301': Unit("Seraphim T3 Heavy Shield Generator", "xsb4301", 3, "s"),

        # T2 Shield Generator
        'uab4202': Unit("Aeon T2 Shield Generator", "uab4202", 2, "a"),
        'ueb4202': Unit("UEF T2 Shield Generator", "ueb4202", 2, "e"),
        'urb4202': Unit("Cybran T2 Shield Generator", "urb4202", 2, "r"),
        'xsb4202': Unit("Seraphim T2 Shield Generator", "xsb4202", 2, "s"),

        # T3 Heavy Point Defense
        'xeb2306': Unit("UEF T3 Heavy Point Defense", "xeb2306", 3, "e"),

        # T2 Point Defense
        'uab2301': Unit('Aeon T2 Point Defense', 'uab2301', 2, 'a'),
        'ueb2301': Unit('UEF T2 Point Defense', 'uab2301', 2, 'e'),
        'urb2301': Unit('Cybran T2 Point Defense', 'uab2301', 2, 'r'),
        'xsb2301': Unit('Seraphim T2 Point Defense', 'uab2301', 2, 's'),

        # T2 Tactical Missile Defense
        'uab4201': Unit("Aeon T2 Tactical Missile Defense", "uab4201", 2, "a"),
        'ueb4201': Unit("UEF T2 Tactical Missile Defense", "uab4201", 2, "e"),
        'urb4201': Unit("Cybran T2 Tactical Missile Defense", "uab4201", 2, "r"),
        'xsb4201': Unit("Seraphim T2 Tactical Missile Defense", "uab4201", 2, "s"),

        # T3 AA Defense
        'uab2304': Unit("Aeon T3 Anti-Air Defense", 'uab2304', 3, 'a'),
        'ueb2304': Unit("UEF T3 Anti-Air Defense", 'uab2304', 3, 'e'),
        'urb2304': Unit("Cybran T3 Anti-Air Defense", 'uab2304', 3, 'r'),
        'xsb2304': Unit("Seraphim T3 Anti-Air Defense", 'uab2304', 3, 's'),
    }
