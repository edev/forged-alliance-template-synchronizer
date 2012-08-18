dofile('export.lua')

-- Templates containing these IDs won't be synced. T4, etc.
unit_exclusions = {
  'xrb2308', -- Cybran T3 torpedo ambushing system
  'xrb3301', -- Cybran T3 perimeter monitoring system
  'xab2307', -- Aeon T3 rapid fire artillery
  'xab3301', -- Aeon T3 quantum optics facility
  'xab1401', -- Aeon T4 Paragon
  'ueb2401', -- UEF T4 Mavor
  'xeb2402', -- UEF T4 satellite system
  'xsb2401' -- Seraphim T4 supernuke
}

-- Some IDs have the wrong tech level. Overridden here.
-- First two characters of each ID are omitted to simplify this list.
unit_tech_overrides = {
  b3104 = 3, -- T3 omni sensor
  b2301 = 2, -- T2 point defense
  b2108 = 2, -- T2 tactical missile launcher
  b2303 = 2 -- T2 artillery
}

-- Special cases
-- xrb0104: Cybran engineering station, tier 1. Tiers 2 and 3: xrb0204, xrb0304
-- xeb0104: UEF engineering station, tier 1. Tier 2: xeb0204
-- Sonar: b3102 is T1, b3202 is T2, s0305 is T3 (which is mobile, and which Seraphim lacks)
-- T3 sonar: can't be put into templates.
-- Mass extractors: b1103 is T1, b1202 is T2, b1302 is T3. No workaround needed for this script.
-- Torpedo launchers: b2109 is T1, b2205 is T2. No workaround needed for this script.
-- Cybran T2 shields, from ED1 to ED5: urb4202, 4204, 4205, 4206, 4207. (Skips 4203)
-- T3 shields: Cybran doesn't have T3.

function init(filename, backup_filename)
  filename = filename or 'Game.prefs'
  backup_filename = backup_filename or 'old.' .. filename

  dofile(filename)

  profile.profiles[1].build_templates = synchronize(profile.profiles[1].build_templates)
  
  os.remove(backup_filename)
  os.rename(filename, backup_filename)
  io.output(filename)
  io.write(export(profile, 'profile'))
  io.write(export(version, 'version'))
  io.write(export(Windows, 'Windows'))
  io.write(export(options_overrides, 'options_overrides'))
  io.write(export(active_mods, 'active_mods'))
  io.flush()
  io.close()
end

function template_name(template)
  return template.name
end

function template_eq(t1, t2)
  -- TODO Potentially ignore <LOC ueb1101_desc> type prefixes
  return template_name(t1) == template_name(t2)
end

function template_copies(table, template)
  local count = 0
  for i=1, # table do
    if template_eq(table[i], template) then
      count = count + 1
    end
  end
  return count
end

function unit_required_tech_level(unit)
  local o = unit_tech_overrides[string.sub(unit[1], 3)]
  if o ~= nil then
    return o
  else
    return tonumber(string.sub(unit[1], 5, 5))
  end
end

function template_required_tech_level(template)
  local rtl = 1 -- overall required tech level
	local crtl    -- current required tech level (per iteration)
  -- Start at 3 to skip the x- and y-sizes
  for i=3, # template.templateData do
    crtl = unit_required_tech_level(template.templateData[i])
    if crtl > rtl then
      rtl = crtl
    end
  end
  return rtl
end

function template_get_faction_character(template)
  return string.sub(template.icon, 2, 2)
end

function template_unit_is_excluded(unit)
  for i = 1, # unit_exclusions do
    if(unit_exclusions[i] == unit[1]) then return true end
  end
  return false
end

-- Doesn't account for special cases (except Seraphim being expansion)
function _template_convert_uid_dumb(uid, new_faction_character)
  -- To Seraphim: replace the first character with 'x'.
  if new_faction_character == 's' then
    uid = 'x' .. string.sub(uid, 2, -1)
  end
  
  -- From Seraphim: no Aeon, UEF, or Cybran structures that Seraphim has were
  -- added in Forged Alliance, so it's safe to force the first character to 'u'.
  if(string.sub(uid, 2, 2) == 's') then
    uid = 'u' .. string.sub(uid, 2, -1)
  end
  
  -- Any faction (including Seraphim): replace faction character.
  uid = string.sub(uid, 1, 1) .. new_faction_character .. string.sub(uid, 3, -1)
  return uid
end

function template_convert_unit_id(uid, new_faction_character, required_tech_level)
  -- Only relevant for certain conversions.
  required_tech_level = required_tech_level or 2
  
  -- Programmatically handle special cases
  -- Case: Cybran engineering station. If new faction is UEF, convert.
  -- Else, don't include this unit in the template, but do continue.
  if uid == 'xrb0104' then
    if new_faction_character == 'e' then
      uid = 'xeb0104'
    else
      uid = nil
    end
  -- Case: UEF engineering station. If new faction is Cybran, convert.
  -- Else, don't include this unit in the template, but do continue.
  elseif uid == 'xeb0104' then
    if new_faction_character == 'r' then
      uid = 'xrb0104'
    else
      uid = nil
    end
  -- Case: T3 shields, converting to Cybran: use ED1 T2 shield generator.
  elseif string.sub(uid, 3, -1) == 'b4301' and 
         new_faction_character == 'r' then
    uid = 'urb4202'
  -- Case: Cybran T2 shields. If the template requires T3 (or above), use a T3
  -- shield generator. Otherwise, use a T2 shield generator.
  elseif uid == 'urb4202' then
    if required_tech_level >= 3 then
      uid = _template_convert_uid_dumb('urb4301', new_faction_character)
    else
      uid = _template_convert_uid_dumb(uid, new_faction_character)
    end
  -- Case: T2 point defense to UEF T3. If the template requires T3 (or above),
  -- use T3 point defense. Otherwise, use T2 point defense (standard case).
  elseif string.sub(uid, 3, -1) == 'b2301' and
         new_faction_character == 'e' and
         required_tech_level >= 3 then
    uid = 'xeb2306'
  -- Case: UEF T3 point defense to any other faction's T2 point defense.
  elseif uid == 'xeb2306' then
    -- Pretend it's a T2 PD and convert normally.
    uid = _template_convert_uid_dumb('ueb2301', new_faction_character)
  else
    -- Standard case
    uid = _template_convert_uid_dumb(uid, new_faction_character)
  end

  return uid
end

function table_shallow_copy(t)
  local u = {}
  for k, v in pairs(t) do
    u[k] = v
  end
  return u
end

function template_faction_convert(template, new_faction_character)
  -- Multi-faction templates don't appear in-game.
  -- In-game, you can't select different factions' icons for templates.
  local new_template
  local unit
  local required_tech_level = template_required_tech_level(template)
  -- Bootstrap new_template
  new_template = {
    templateData = {
      template.templateData[1],
      template.templateData[2]
    },
    name = template.name,
    -- Icon name will be nil if someone hacks in an excluded icon
    -- even though the excluded building isn't in the template.
    -- If so, we just won't change it - better than FA wiping Game.prefs!
    icon = template_convert_unit_id(template.icon, 
                                    new_faction_character,
                                    required_tech_level) or template.icon
  }
  for i=3, # template.templateData do
    unit = table_shallow_copy(template.templateData[i])
    if template_unit_is_excluded(unit) then
      new_template = nil -- return nil
      break
    else
      -- Convert unit ID
      unit[1] = template_convert_unit_id(unit[1], 
                                         new_faction_character,
                                         required_tech_level)
      
      if unit[1] ~= nil then
        table.insert(new_template.templateData, unit)
      end
    end
  end

  -- If #templateData <= 2, we have an empty template.
  if new_template == nil or # new_template.templateData <= 2 then
    new_template = nil
  end

  return new_template
end

function synchronize_template(template)
  local retval = {}
  local temp
  local faction = template_get_faction_character(template)
  local factions = {'a', 'e', 'r', 's'}
  
  for _, f in pairs(factions) do
    if faction ~= f then
      temp = template_faction_convert(template, f)
      if type(temp) == 'table' then
        table.insert(retval, temp)
      end
    else
      table.insert(retval, template)
    end
  end
  
  return retval
end

function synchronize(build_templates)
  local retval = {}
  local temp
  local synced_template_names = {}
  
  for i = 1, # build_templates do
    if synced_template_names[build_templates[i].name] then
      -- Skip - already synced
    else
      synced_template_names[build_templates[i].name] = true
      -- If a template appears 3 times, presumably it's been deleted in-game
      -- from one faction. We'll remove it altogether by not including it
      -- in the new list.
      if template_copies(build_templates, build_templates[i]) ~= 3 then
        temp = synchronize_template(build_templates[i])
        if type(temp) == 'table' then
          for j = 1, #temp do
            table.insert(retval, temp[j])
          end
        end
      end
    end
  end
  return retval
end

-- Parse command-line arguments and initialize
-- TODO Find a way to test this programmatically
function _check_for_argument(flag)
  local retval = nil
  for i, v in ipairs(arg) do
    if i >= 1 then -- Don't parse arguments passed to Lua, only those given to us.
      if v == flag and type(arg[i + 1]) == 'string' then
        retval = arg[i + 1]
        break
      end
    end
  end
  return retval
end

filename = _check_for_argument('-f')
backup_filename = _check_for_argument('-b')

init(filename, backup_filename)
