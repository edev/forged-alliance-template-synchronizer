-- The specific function of this exporter is to match precisely the export
-- format of Game.prefs as created by Supreme Commander: Forged Alliance.

indentation_text = '    ' -- Change this if you want to use tabs, etc.
omit_numeric_table_keys = true

-- Note: based on my research, there doesn't appear to be a good way
-- to access a variable's name at runtime, so the top call to export
-- must provide it. If it is not provided, no assignment to the variable will
-- be created. Instead, the value will simply be exported.

-- Known limitation: table (dict) keys are assumed to be either numbers or strings.
-- If you need to use booleans, tables, etc. as table keys, modify accordingly.
function export(var, var_name, indentation, use_comma)
  indentation = indentation or 0
  use_comma = use_comma or false
  local retval = ''


  --------------------
  -- Handle strings --
  --------------------
  
  -- Note: functions, userdata, and threads are NOT exported! They are skipped.
  if type(var) == 'string' then
    retval = string.format('%q', var)
    

  ---------------------------------------
  -- Handle numbers, booleans, and nil --
  ---------------------------------------

  elseif type(var) == 'number' or
         type(var) == 'boolean' or
         type(var) == 'nil' then
    retval = tostring(var)
    

  ---------------------------------
  -- Handle tables (recursively) --
  ---------------------------------

  elseif type(var) == 'table' then
    retval = retval .. '{'
    local iteration = 0
    for k, v in pairs(var) do
      if type(k) == 'number' then
        if omit_numeric_table_keys then
          retval = retval .. export(v, nil, indentation + 1, iteration > 0)
        else
          -- If requested, explicitly set the numeric key. Not used SCFA.
          retval = retval .. export(v, '[' .. k .. ']', indentation + 1, iteration > 0)
        end
      else
        -- Key isn't a number; assume it's a string, because this is all
        -- that falls in the purview of SCFA's Game.prefs file.
        if _simple_string_key(k) then
          retval = retval .. export(v, k, indentation + 1, iteration > 0)
        else
          retval = retval .. export(v, '["' .. k .. '"]', indentation + 1, iteration > 0)
        end
      end
      iteration = iteration + 1
    end
     -- Could leave an extra comma, but oh well.
    retval = retval .. '\n' .. string.rep(indentation_text, indentation) .. '}'
  end
  
  -- Prefix the value with an assignment to var_name, if provided.
  -- Also add proper indentation.
  if var_name ~= nil then
    retval = string.rep(indentation_text, indentation) .. var_name .. ' = ' .. retval
  else
    retval = string.rep(indentation_text, indentation) .. retval
  end
  

  -----------------------
  -- End previous line --
  -----------------------
  if use_comma then
    retval = ',\n' .. retval
  else
    retval = '\n' .. retval
  end
  
  return retval
end

function _simple_string_key(key)
  if string.len(string.gsub(key, '[a-zA-Z0-9_]', '')) == 0 then
    return true
  else
    return false
  end
end

function _export_table(t)
  
end

-- NOTE: Tables CANNOT have numbers for keys, so if the type of a key returned from a pairs() iteration is 'number', it's an index to a value with no associated name.
