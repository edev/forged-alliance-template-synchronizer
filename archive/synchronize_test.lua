-- Designed to be run from the parent folder, not from /test.
dofile('synchronize.lua')
dofile('export.lua')
dofile('test_helpers.lua')

-- template_eq
assert_eq(template_eq(generate_test_template('ueb1301'),
                      generate_test_template('ueb1301')),
          true,
          'template_eq (true)')
            
assert_neq(template_eq(generate_test_template('urb1101', 'Template 1'),
                       generate_test_template('ueb1101', 'Template 2')),
           true,
           'template_eq (false)')
            
-- template_name
assert_eq(template_name(generate_test_template('ueb1101', 'Name')),
          'Name',
          'template_name')

-- template_copies
assert_eq(template_copies({generate_test_template('urb1101'),
                           generate_test_template('urb1101'),
                           generate_test_template('urb1101')},
                           generate_test_template('urb1101')),
          3,
          'template_copies')

-- unit_required_tech_level
assert_eq(unit_required_tech_level(generate_test_template('ueb1106').templateData[3]),
          1,
          'unit_required_tech_level (3)')
            
assert_eq(unit_required_tech_level(generate_test_template('uab2108').templateData[3]),
          2,
          'unit_required_tech_level (override)')

-- template_required_tech_level
assert_eq(template_required_tech_level(generate_test_template('ueb1206')),
          2,
          'template_required_tech_level')

-- template_get_faction_character
assert_eq(template_get_faction_character(generate_test_template('ueb1206')),
          'e',
          'template_get_faction_character')

-- template_unit_is_excluded
assert_eq(template_unit_is_excluded(generate_test_template('ueb1206').templateData[3]),
          false,
          'template_unit_is_excluded (false)')

assert_eq(template_unit_is_excluded(generate_test_template('ueb2401').templateData[3]),
          true,
          'template_unit_is_excluded (true)')

-- _template_convert_uid_dumb
assert_eq(_template_convert_uid_dumb('xab0102', 'e'),
          'xeb0102',
          '_template_convert_uid_dumb')
          
assert_eq(_template_convert_uid_dumb('uab0102', 's'),
          'xsb0102',
          '_template_convert_uid_dumb (to Seraphim)')
          
assert_eq(_template_convert_uid_dumb('xsb0102', 'r'),
          'urb0102',
          '_template_convert_uid_dumb (from Seraphim)')

-- template_convert_unit_id
assert_eq(template_convert_unit_id('xab0102', 'e'),
          'xeb0102',
          'template_convert_unit_id')
          
assert_eq(template_convert_unit_id('uab0102', 's'),
          'xsb0102',
          'template_convert_unit_id (to Seraphim case)')
          
assert_eq(template_convert_unit_id('xsb0102', 'r'),
          'urb0102',
          'template_convert_unit_id (from Seraphim)')
          
-- Special unit cases: relevant code is in template_convert_unit_id,
-- but testing with template_faction_convert forces interaction with exclusions.
-- Thus, if a special case is excluded AND programmatically handled,
-- it'll show up as an error here.

assert_eq(template_faction_convert(generate_test_template('xrb0104'), 's'),
          nil,
          'template_convert_unit_id (Cybran engineering station, to Seraphim)')

test_special_unit_case('e',
                       'template_convert_unit_id (Cybran engineering station, to UEF)',
                       {'xrb0104'},
                       {'xeb0104'})

assert_eq(template_faction_convert(generate_test_template('xeb0104'), 'a'),
          nil,
          'template_convert_unit_id (UEF engineering station, to Aeon)')

test_special_unit_case('r',
                       'template_convert_unit_id (UEF engineering station, to Cybran)',
                       {'xeb0104'},
                       {'xrb0104'})

test_special_unit_case('r',
                       'template_convert_unit_id (Seraphim T3 shield, to Cybran T2)',
                       {'sxb4301'},
                       {'urb4202'})

test_special_unit_case('e',
                       'template_convert_unit_id (Cybran T2 shield, to UEF T2 shield)',
                       {'urb4202'},
                       {'ueb4202'})

test_special_unit_case('e',
                       'template_convert_unit_id (Cybran T2 shield, to UEF T3 shield)',
                       {'urb4202', 'urb1302'},
                       {'ueb4301', 'ueb1302'})
test_special_unit_case('e',
                       'template_convert_unit_id (Seraphim T2 PD, to UEF T3 Heavy PD)',
                       {'xsb2301', 'xsb3104'}, -- Omni sensor (tech level override)
                       {'xeb2306', 'ueb3104'})

test_special_unit_case('e',
                       'template_convert_unit_id (Seraphim T2 PD, to UEF T2 PD)',
                       {'xsb2301'},
                       {'ueb2301'})

test_special_unit_case('r',
                       'template_convert_unit_id (UEF T3 Heavy PD, to Cybran T2 PD)',
                       {'xeb2306'},
                       {'urb2301'})

-- template_faction_convert
assert_eq(template_faction_convert(generate_test_template('xab1401'), 's'),
          nil,
          'template_faction_convert (excluded template)')
          
  -- Tests Cybran shield conversion and T2 point defense tech override together.
  -- (T2 Point defense has a UID that implies that it's T3.)
assert_eq(export(template_faction_convert(generate_test_template('urb4202'), 's')),
          export(generate_test_template('xsb4202')),
          'template_faction_convert (Cybran shield and point defense, to Seraphim)')

-- synchronize_template
assert_eq(export(synchronize_template(generate_test_template('urb4202'))),
          export({generate_test_template('uab4202'),
                  generate_test_template('ueb4202'),
                  generate_test_template('urb4202'),
                  generate_test_template('xsb4202')}),
          'synchronize_template')
          
assert_eq(export(synchronize_template(generate_test_template('xrb2308'))),
          export({ generate_test_template('xrb2308') }),
          'synchronize_template (excluded template)')

                   
-- synchronize
assert_eq(export(synchronize({generate_test_template('urb4202')})),
          export({generate_test_template('uab4202'),
                  generate_test_template('ueb4202'),
                  generate_test_template('urb4202'),
                  generate_test_template('xsb4202')}),
          'synchronize')
