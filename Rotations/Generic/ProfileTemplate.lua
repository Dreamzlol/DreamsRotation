--------------------------------
-- DreamsRotations - Class Spec PvE
-- Version - 1.0.0
-- Author - Dreams
--------------------------------
-- Changelog
-- 1.0.0 Initial release
--------------------------------
local ni = ...

local items = {
    settingsfile = "DreamsRotations - Class Spec PvE.json",
    {
        type = "title",
        text = "|cff00ccffDreamsRotations |cffffffff- Class Spec PvE - |cff888888v1.0.0",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff00ccffMain Settings",
    },
    {
        type = "separator",
    },
    {
        type = "entry",
        text = "\124T" .. select(3, GetSpellInfo(453)) .. ":26:26\124t Racial",
        tooltip = "Every Man for Himself if you are stunned or feared, Blood Fury if your target is a Boss, Stoneform if you have a Poison or Disease Debuff, Beserking if your target is a Boss, Will of the Forsaken if you are feared, charm or sleep effect",
        enabled = true,
        key = "racial",
    },
    {
        type = "separator",
    },
    {
        type = "title",
        text = "|cff00ccffRotation Settings",
    },
    {
        type = "separator",
    },
}

local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
        and v.key ~= nil
        and v.key == name then
            return v.value, v.enabled
        end
    end
end

local function onload()
    ni.GUI.AddFrame("DreamsRotations - Class Spec PvE", items);
end

local function onunload()
    ni.GUI.DestroyFrame("DreamsRotations - Class Spec PvE");
end

local spell = {
    startattack = GetSpellInfo(6603),
}

local item = {
    food = GetSpellInfo(45548),
    drink = GetSpellInfo(57073),
}

local race = UnitRace("player");

local queue = {
    "Pause Rotation",
    "Auto Target",
    "Racial",
}

local abilities = {
    ["Pause Rotation"] = function()
        if IsMounted()
        or UnitIsDeadOrGhost("player")
        or UnitIsDeadOrGhost("target")
        or UnitUsingVehicle("player")
        or UnitInVehicle("player")
        or not UnitAffectingCombat("player")
        or ni.unit.ischanneling("player")
        or ni.unit.iscasting("player")
        or ni.unit.buff("player", item.food)
        or ni.unit.buff("player", item.drink) then
            return true;
        end
    end,

    ["Auto Target"] = function()
        local _, enabled = GetSetting("autotarget")
        if enabled then
            if UnitAffectingCombat("player")
            and ((ni.unit.exists("target")
            and UnitIsDeadOrGhost("target")
            and not UnitCanAttack("player", "target"))
            or not ni.unit.exists("target")) then
                ni.player.runtext("/targetenemy")
                return true;
            end
        end
	end,

    ["Racial"] = function()
        local _, enabled = GetSetting("racial")
        if enabled then
            if ni.unit.isstunned("player")
            or ni.unit.isfleeing("player")
            and ni.spell.available(spell.everymanforhimself)
            and race == "Human" then
                ni.spell.cast(spell.everymanforhimself)
            end

            if ni.unit.isboss("target")
            and ni.spell.available(spell.bloodfury)
            and race == "Orc" then
                ni.spell.cast(spell.bloodfury)
            end

            if ni.unit.isboss("target")
            and ni.spell.available(spell.beserking)
            and race == "Troll" then
                ni.spell.cast(spell.beserking)
            end

            if ni.unit.debufftype("player", "Poison|Disease")
            and ni.spell.available(spell.stoneform)
            and race == "Dwarf" then
                ni.spell.cast(spell.stoneform)
            end

            if ni.unit.isfleeing("player")
            and ni.spell.available(spell.willoftheforsaken)
            and race == "Undead" then
                ni.spell.cast(spell.willoftheforsaken)
            end
        end
    end,
}
ni.bootstrap.profile("DreamsRotations - Class Spec PvE", queue, abilities, onload, onunload)
