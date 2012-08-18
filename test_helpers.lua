function assert_eq(expr, expected_value, errmsg)
  if expr ~= expected_value then 
    -- Prepare to print tables if needed
    local s_expected, s_expr
    if type(expected_value) == 'table' then
      s_expected = export(expected_value)
    else
      s_expected = tostring(expected_value)
    end
    if type(expr) == 'table' then
      s_expr = export(expr)
    else
      s_expr = tostring(expr)
    end

    print(errmsg .. ':')
    print('Expected: ' .. s_expected)
    print('Got: ' .. s_expr)
  end
end

function assert_neq(expr, expected_value, errmsg)
  if expr == expected_value then
    local s_expected, s_expr
    if type(expected_value) == 'table' then
      s_expected = export(expected_value)
    else
      s_expected = tostring(expected_value)
    end
    if type(expr) == 'table' then
      s_expr = export(expr)
    else
      s_expr = tostring(expr)
    end

    print(errmsg .. ':')
    print('Expected (not to get): ' .. s_expected)
    print('Got: ' .. s_expr)
  end
end

-- Units: unit ID or list of unit IDs. String or table.
function generate_test_template(units, name, icon)
  local retval = {
    templateData = {
      2, -- x and y dimensions don't matter for our purposes, and detecting
         -- them accurately would require extracting units.scd.
      2
    },
  }

  if units ~= nil then
    name = name or 'Test template'
    if type(units) == 'table' then
      icon = icon or units[1]
    else
      units = {units}
      icon = icon or units[1]
    end
    
    retval.name = name
    retval.icon = icon
    
    for i = 1, #units do
      -- Fabricate a unique build command for each uid passed in
      table.insert(retval.templateData, {units[i], i, i, i})
    end
  else
    print('Error: units is a required argument.')
    retval = nil
  end

  return retval
end

function test_special_unit_case(new_faction_character,
                                message,
                                input_units,
                                expected_units)
  assert_eq(
    export(
      template_faction_convert(
        generate_test_template(input_units),
        new_faction_character)),
    export(
      generate_test_template(expected_units)),
    message)
end

