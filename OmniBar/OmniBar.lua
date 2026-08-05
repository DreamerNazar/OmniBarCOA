
-- OmniBar by Jordon
-- Backported to 3.3.5a By Jammin
-- There might be some wrong cooldowns/timers, you're welcome to change it yourself, under the table "cooldowns" around line 56. Should be self-explanatory. Eg: 
-- 	[26297]   = { default = true, duration = 180,  class = "GENERAL" },                                       --Berserking        // 26297 is Berserking Spell ID, duration is the cooldown duration.

local classTable = tcopy(Enum.ClassFile)
tinsert(classTable, "GENERAL")

local specTable = {
	[Enum.Class.HERO] = { "HERO" }
}

if not LOCALIZED_CLASS_SPEC_NAMES then -- remove when added to patches
	LOCALIZED_CLASS_SPEC_NAMES = {
		["BARBARIAN"] = {
			["BRUTALITY"] = "Brutality",
			["TACTICS"] = "Tactics",
			["ANCESTRY"] = "Ancestry",
		},
		["WITCHDOCTOR"] = {
			["VOODOO"] = "Voodoo",
			["BREWING"] = "Brewing",
			["SHADOWHUNTING"] = "Shadowhunting",
		},
		["DEMONHUNTER"] = {
			["SLAYING"] = "Slaying",
			["DEMONOLOGY"] = "Demonology",
			["FELBLOOD"] = "Felblood",
		},
		["WITCHHUNTER"] = {
			["INQUISITION"] = "Inquisition",
			["DARKNESS"] = "Darkness",
			["WITCHKNIGHT"] = "Witch Knight",
			["BOLTSLINGER"] = "Boltslinger",
		},
		["STORMBRINGER"] = {
			["LIGHTNING"] = "Lightning",
			["GIFTS"] = "Gifts",
			["WIND"] = "Wind",
		},
		["FLESHWARDEN"] = {
			["HELLFIRE"] = "Hellfire",
			["WAR"] = "War",
			["DEFIANCE"] = "Defiance",
		},
		["GUARDIAN"] = {
			["GLADIATOR"] = "Gladiator",
			["PROTECTION"] = "Protection",
			["INSPIRATION"] = "Inspiration",
		},
		["MONK"] = {
			["FIGHTING"] = "Fighting",
			["RUNES"] = "Runes",
			["DISCIPLINE"] = "Discipline",
		},
		["SONOFARUGAL"] = {
			["BLOOD"] = "Blood",
			["FEROCITY"] = "Ferocity",
			["PACKLEADER"] = "Packleader",
			["FLESHWEAVER"] = "Fleshweaver",
		},
		["RANGER"] = {
			["DUELING"] = "Dueling",
			["ARCHERY"] = "Archery",
			["SURVIVAL"] = "Survival",
		},
		["PROPHET"] = {
			["STALKING"] = "Stalking",
			["FORTITUDE"] = "Fortitude",
			["VENOM"] = "Venom",
			["VIZIER"] = "Vizier",
		},
		["PYROMANCER"] = {
			["DESTRUCTION"] = "Destruction",
			["INCINERATION"] = "Incineration",
			["DRACONIC"] = "Draconic",
		},
		["CULTIST"] = {
			["CORRUPTION"] = "Corruption",
			["GODBLADE"] = "Godblade",
			["INFLUENCE"] = "Influence",
		},
		["NECROMANCER"] = {
			["RIME"] = "Rime",
			["ANIMATION"] = "Animation",
			["DEATH"] = "Death",
		},
		["SUNCLERIC"] = {
			["BLESSINGS"] = "Blessings",
			["SERAPHIM"] = "Seraphim",
			["PIETY"] = "Piety",
		},
		["TINKER"] = {
			["INVENTION"] = "Invention",
			["MECHANICS"] = "Mechanics",
			["FIREARMS"] = "Firearms",
		},
		["REAPER"] = {
			["SOUL"] = "Soul",
			["REAPING"] = "Reaping",
			["DOMINATION"] = "Domination",
		},
		["WILDWALKER"] = {
			["GEOMANCY"] = "Geomancy",
			["PRIMAL"] = "Primal",
			["MOUNTAINKING"] = "Mountain King",
			["LIFE"] = "Life",
		},
		["STARCALLER"] = {
			["ASTRALWARFARE"] = "Astral Warfare",
			["MOONBOW"] = "Moonbow",
			["TIDES"] = "Tides",
		},
		["SPIRITMAGE"] = {
			["RUNIC"] = "Runic",
			["ARCANE"] = "Arcane",
			["RIFTBLADE"] = "Riftblade",
		},
		["CHRONOMANCER"] = {
			["DUALITY"] = "Duality",
			["TIME"] = "Time",
			["DISPLACEMENT"] = "Displacement",
		},
	}
end

for class, specs in pairs(LOCALIZED_CLASS_SPEC_NAMES) do
	local classID = Enum.Class[class]
	specTable[classID] = {}
	for spec in pairs(specs) do
		tinsert(specTable[classID], spec)
	end
end

local function GetClassInfoByID(classID)
	return classID, classTable[classID];
end

local function GetNumSpecializationsForClassID(classID)
	return #specTable[classID];
end

local function GetSpecializationInfoForClassID(classID, i)
	return (classID-1)*3+i, specTable[classID][i];
end

local function GetCooldownTimes(cooldownFrame)
	return cooldownFrame.startTime, cooldownFrame.duration;
end

function orderByTimeLeft()
	table.sort(_G["OmniBar"].active, function(x, y)
		if x.cooldown.finish ~= nil and y.cooldown.finish ~= nil then
			if x.cooldown.finish > y.cooldown.finish then
				return false;
			else --if x.cooldown.finish < y.cooldown.finish then
				return true;
			end
		else
			return false;
		end
	end)
end
local band = bit.band


local addonName, L = ...

local cooldowns = {

	--GENERAL (racials)
	[26297]   = { default = true, duration = 180,  class = "GENERAL" },                                       --Berserking
	[20572]   = { default = true, duration = 120,  class = "GENERAL" },                                       --Blood Fury
	[20589]   = { default = true, duration = 60,  class = "GENERAL" },                                        --Escape Artist
	[28880]   = { default = true, duration = 180,  class = "GENERAL" },                                       --Gift of the Naaru
	[28730]   = { default = true, duration = 120,  class = "GENERAL" },                                       --Arcane Torrent
	[58984]   = { default = true, duration = 120,  class = "GENERAL" },                                       --Shadowmeld
	[20594]   = { default = true, duration = 90,  class = "GENERAL" },                                        --Stoneform
	[20549]   = { default = true, duration = 60,  class = "GENERAL" },                                        --War Stomp
	[59752]   = { default = true, duration = 120,  class = "GENERAL" },                                       --Every Man For Himself
	[7744]    = { default = true, duration = 120,  class = "GENERAL" },                                       --Will of the Forsaken
}


-- Merge Conquest of Azeroth cooldowns (loaded from CoA_Cooldowns.lua)
if OmniBarCoA and OmniBarCoA.cooldowns then
	for spellID, spell in pairs(OmniBarCoA.cooldowns) do
		cooldowns[spellID] = spell
	end
end

local cooldownLookup = {}
for spellID in pairs(cooldowns) do
	local name = GetSpellInfo(spellID)
	if name then
		cooldownLookup[name] = spellID
	end
end

 
local order = {}
order["GENERAL"] = 1
if OmniBarCoA and OmniBarCoA.classOrder then
	for index, class in ipairs(OmniBarCoA.classOrder) do
		order[class] = index + 1
	end
end

local resets = {
	-- Add CoA cooldown-reset spells here when known
}

-- Defaults
local defaults = {
	size                 = 40,
	columns              = 8,
	padding              = 2,
	locked               = false,
	center               = false,
	border               = true,
	noHighlightTarget    = false,
	noHighlightFocus     = true,
	growUpward           = true,
	showUnused           = false,
	adaptive             = false,
	unusedAlpha          = 0.45,
	swipeAlpha           = 0.65,
	noCooldownCount      = false,
	noArena              = false,
	noRatedBattleground  = false,
	noBattleground       = false,
	noWorld              = false,
	noAshran             = false,
	noMultiple           = false,
	noGlow               = false,
	noTooltips           = false,
}

local OmniBar

local Masque = LibStub and LibStub("Masque", true)

local SETTINGS_VERSION = 2

local MAX_DUPLICATE_ICONS = 5

local BASE_ICON_SIZE = 36

local ASHRAN_MAP_ID = 978

StaticPopupDialogs["OMNIBAR_CONFIRM_RESET"] = {
	text = CONFIRM_RESET_SETTINGS,
	button1 = YES,
	button2 = NO,
	OnAccept = function()
		OmniBar_Reset(OmniBar)
		if OmniBarOptions then OmniBarOptions:refresh() end

		-- Refresh the cooldowns
		i = 1
		while _G["OmniBarOptionsPanel" .. i] do
			_G["OmniBarOptionsPanel" .. i]:refresh()
			i = i + 1
		end
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	enterClicksFirstButton = true
}

for spellID,_ in pairs(cooldowns) do
	local name, _, icon = GetSpellInfo(spellID)
	cooldowns[spellID].icon = icon
	cooldowns[spellID].name = name
end

local COA_CLASS_ORDER = OmniBarCoA and OmniBarCoA.classOrder or {
	"BARBARIAN", "WITCHDOCTOR", "DEMONHUNTER", "WITCHHUNTER", "STORMBRINGER",
	"FLESHWARDEN", "GUARDIAN", "MONK", "SONOFARUGAL", "RANGER", "PROPHET",
	"PYROMANCER", "CULTIST", "NECROMANCER", "SUNCLERIC", "TINKER", "REAPER",
	"WILDWALKER", "STARCALLER", "SPIRITMAGE", "CHRONOMANCER",
}

local COA_CLASS_NAMES = OmniBarCoA and OmniBarCoA.classNames or {
	BARBARIAN = "Barbarian",
	WITCHDOCTOR = "Witch Doctor",
	DEMONHUNTER = "Felsworn",
	WITCHHUNTER = "Witch Hunter",
	STORMBRINGER = "Stormbringer",
	FLESHWARDEN = "Knight of Xoroth",
	GUARDIAN = "Guardian",
	MONK = "Templar",
	SONOFARUGAL = "Bloodmage",
	RANGER = "Ranger",
	PROPHET = "Venomancer",
	PYROMANCER = "Pyromancer",
	CULTIST = "Cultist",
	NECROMANCER = "Necromancer",
	SUNCLERIC = "Sun Cleric",
	TINKER = "Tinker",
	REAPER = "Reaper",
	WILDWALKER = "Primalist",
	STARCALLER = "Starcaller",
	SPIRITMAGE = "Runemaster",
	CHRONOMANCER = "Chronomancer",
}

-- Class cooldown panels are registered by OmniBar itself (not Options),
-- so classic CLASS_SORT_ORDER tabs can never appear from an old Options file.
local function OmniBar_GetClassPanelName(token)
	if token == "GENERAL" then
		return "General"
	end
	return COA_CLASS_NAMES[token] or token
end

local function OmniBar_CreateClassOptionsPanel(token, subIndex)
	local panel = CreateFrame("Frame", "OmniBarOptionsPanel"..subIndex)
	panel.spells = {}
	panel.parent = "OmniBar"
	panel.name = OmniBar_GetClassPanelName(token)

	local index, parent, left = 1
	for spellID, cooldown in pairs(cooldowns) do
		if not cooldown.parent and cooldown.class == token then
			local spell = CreateFrame("CheckButton", "OmniBarOptionsPanel"..subIndex.."Item"..index, panel, "OptionsCheckButtonTemplate")
			local text, _, icon = GetSpellInfo(spellID)
			if text then
				if string.len(text) > 25 then
					text = string.sub(text, 0, 22) .. "..."
				end
				if CreateSquareTextureMarkup then
					text = CreateSquareTextureMarkup(icon, 22) .. " " .. text
				else
					text = text
				end
			else
				text = tostring(spellID)
			end
			_G["OmniBarOptionsPanel"..subIndex.."Item"..index.."Text"]:SetText(text)

			spell:SetScript("OnShow", function(self)
				if OmniBar.settings.cooldowns[spellID] and (OmniBar.settings.cooldowns[spellID].enabled or OmniBar.settings.cooldowns[spellID].enabled == false) then
					self:SetChecked(OmniBar.settings.cooldowns[spellID].enabled)
				elseif cooldowns[spellID].default == false then
					self:SetChecked(false)
				else
					self:SetChecked(true)
				end
			end)

			spell.spellID = spellID
			spell:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
				GameTooltip:SetSpellByID(self.spellID)
			end)
			spell:SetScript("OnLeave", function()
				GameTooltip:Hide()
			end)

			spell.setFunc = function(value)
				if not OmniBar.settings.cooldowns[spellID] then OmniBar.settings.cooldowns[spellID] = {} end
				local enabled = value == "1"
				OmniBar.settings.cooldowns[spellID].enabled = enabled
				spell:SetChecked(enabled)
				if enabled then
					OmniBar_CreateIcon(OmniBar)
				end
				OmniBar_RefreshIcons(OmniBar)
				OmniBar_UpdateIcons(OmniBar)
			end

			if index > 1 then
				if (index - 1) % 2 == 0 then
					spell:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 0, -2)
					parent = spell
				else
					spell:SetPoint("TOPLEFT", left, "TOPLEFT", 190, 0)
				end
			else
				spell:SetPoint("TOPLEFT", 24, -24)
				parent = spell
			end
			left = spell
			index = index + 1
			table.insert(panel.spells, spell)
		end
	end

	if index == 1 then
		local hint = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		hint:SetPoint("TOPLEFT", 24, -24)
		hint:SetText("No cooldowns configured yet. Add spells in CoA_Cooldowns.lua")
	end

	panel.refresh = function(self)
		for i = 1, #self.spells do
			self.spells[i]:SetChecked(OmniBar_IsSpellEnabled(OmniBar, self.spells[i].spellID))
		end
	end
	InterfaceOptions_AddCategory(panel)
end

local function OmniBar_RegisterCoAOptionsPanels()
	OmniBar_CreateClassOptionsPanel("GENERAL", 1)
	for i, token in ipairs(COA_CLASS_ORDER) do
		OmniBar_CreateClassOptionsPanel(token, i + 1)
	end
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar CoA|r: options panels = General + "..#COA_CLASS_ORDER.." CoA classes")
end

-- create a lookup table to translate spec names into IDs
local specNames = {}
for classID = 1, MAX_CLASSES  do
	local _, classToken = GetClassInfoByID(classID)
	specNames[classToken] = {}
	for i = 1, GetNumSpecializationsForClassID(classID) do
		local id, name = GetSpecializationInfoForClassID(classID, i)
		specNames[classToken][name] = id
	end
end

local function IsHostilePlayer(unit)
	if not unit then return end
	local reaction = UnitReaction("player", unit)
	if not reaction then return end -- out of range
	return UnitIsPlayer(unit) and reaction < 4 and not UnitIsPossessed(unit)
end

function OmniBar_ShowAnchor(self)
	if self.disabled or self.settings.locked or #self.active > 0 then
		--self.anchor:Hide() NEED TO FIX THIS, THIS SHIT Fucks everything
		self.anchor.background:SetVertexColor(0,0,0,0)
		self.anchor.text:SetText("")
	else
		self.anchor.background:SetAlpha(1)
		self.anchor.text:SetText("OmniBar")
	end
end

local newspell = true
function OmniBar_CreateIcon(self)
	if InCombatLockdown() then return end
	self.numIcons = self.numIcons + 1
	local f = CreateFrame("Button", self:GetName().."Icon"..self.numIcons, self.anchor, "OmniBarButtonTemplate")
	table.insert(self.icons, f)
end

local function SpellBelongsToSpec(spellID, specID)
	if not specID then return true end
	if not cooldowns[spellID].specID then return true end
	for i = 1, #cooldowns[spellID].specID do
		if cooldowns[spellID].specID[i] == specID then return true end
	end
	return false
end

function OmniBar_AddIconsByClass(self, class, sourceGUID, specID)
	for spellID, spell in pairs(cooldowns) do
		if OmniBar_IsSpellEnabled(self, spellID) and spell.class == class and SpellBelongsToSpec(spellID, specID) then
			OmniBar_AddIcon(self, spellID, sourceGUID, nil, true, specID)
		end
	end
end

local function IconIsSource(iconGUID, guid)
	if not guid then return end
	if string.len(iconGUID) == 1 then
		-- arena target
		return UnitGUID("arena"..iconGUID) == guid
	end
	return iconGUID == guid
end

function OmniBar_UpdateBorders(self)
	for i = 1, #self.active do
		local border
		local guid = self.active[i].sourceGUID
		if guid then
			if not self.settings.noHighlightFocus and IconIsSource(guid, UnitGUID("focus")) then
				self.active[i].FocusTexture:SetAlpha(0.4)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			if not self.settings.noHighlightTarget and IconIsSource(guid, UnitGUID("target")) then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)

				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		else
			local class = select(2, UnitClass("focus"))
			if not self.settings.noHighlightFocus and class and IsHostilePlayer("focus") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(0.4)
				border = true
			else
				self.active[i].FocusTexture:SetAlpha(0)
			end
			class = select(2, UnitClass("target"))
			if not self.settings.noHighlightTarget and class and IsHostilePlayer("target") and class == self.active[i].class then
				self.active[i].FocusTexture:SetAlpha(0)
				self.active[i].TargetTexture:SetAlpha(1)
				--self.active[i].flash:SetAlpha(1)
				border = true
			else
				self.active[i].TargetTexture:SetAlpha(0)
			end
		end

		-- Set dim
		--self.active[i]:SetAlpha(self.settings.unusedAlpha and self.active[i].cooldown:GetCooldownTimes() == 0 and not border and
		--	self.settings.unusedAlpha or 1)
	end
end

function OmniBar_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local name = ...
		if name ~= addonName then return end
		self:UnregisterEvent("ADDON_LOADED")
		OmniBar = self
		self.icons = {}
		self.active = {}
		self.cooldowns = cooldowns
		self.cooldownLookup = cooldownLookup
		self.detected = {}
		self.specs = {}
		self.coaClassOrder = COA_CLASS_ORDER
		self.coaClassNames = COA_CLASS_NAMES
		self.BASE_ICON_SIZE = BASE_ICON_SIZE
		self.numIcons = 0
		self:RegisterForDrag("LeftButton")

		-- Load the settings
		OmniBar_LoadSettings(self)

		-- Create the icons
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_CreateIcon(self)
			end
		end

		-- Create the duplicate icons
		for i = 1, MAX_DUPLICATE_ICONS do
			OmniBar_CreateIcon(self)
		end
		OmniBar_ShowAnchor(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)

		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("PLAYER_ENTERING_WORLD")
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("PLAYER_FOCUS_CHANGED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		self:RegisterEvent("ARENA_OPPONENT_UPDATE")
		self:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")

		-- Add Options Panel category + CoA class tabs (registered here, not in Options)
		local frame = CreateFrame("Frame", "OmniBarOptions")
		frame:SetScript("OnShow", function(self)
			if not self.init then
				LoadAddOn("OmniBar_Options")
				self:refresh()
				local i = 1
				while _G["OmniBarOptionsPanel" .. i] do
					if _G["OmniBarOptionsPanel" .. i].refresh then
						_G["OmniBarOptionsPanel" .. i]:refresh()
					end
					i = i + 1
				end
				self.init = true
			end
		end)
		frame.name = addonName
		InterfaceOptions_AddCategory(frame)
		OmniBar_RegisterCoAOptionsPanels()
		InterfaceAddOnsList_Update()

	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, event, sourceGUID, sourceName,sourceFlags, _, dstName, dstFlags, spellID, spellName = ...
		if self.disabled then return end
		if (band(sourceFlags, 0x00000040) == 0x00000040 and event == "SPELL_CAST_SUCCESS") then 
			if cooldownLookup[spellName] then
				spellID = cooldownLookup[spellName]
			end

			if cooldowns[spellID] then
				OmniBar_AddIcon(self, spellID, sourceGUID, sourceName)
			end

			-- Check if we need to reset any cooldowns
			if resets[spellID] then
				for i = 1, #self.active do
					if self.active[i] and self.active[i].spellID and self.active[i].sourceGUID and self.active[i].sourceGUID == sourceGUID and self.active[i].cooldown:IsVisible() then
						-- cooldown belongs to this source
						for j = 1, #resets[spellID] do
							if resets[spellID][j] == self.active[i].spellID then
								self.active[i].cooldown:Hide()
								OmniBar_CooldownFinish(self.active[i].cooldown, true)
								return
							end
						end
					end
				end
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
		OmniBar_OnEvent(self, "ZONE_CHANGED_NEW_AREA")
		wipe(self.detected)
		wipe(self.specs)
		if self.zone == "arena" then OmniBar_OnEvent(self, "ARENA_OPPONENT_UPDATE") end

	elseif event == "ZONE_CHANGED_NEW_AREA" then
		local _, zone = IsInInstance()
		if zone == "none" then
			SetMapToCurrentZone()
			zone = GetCurrentMapAreaID()
		end
		local rated = false
		self.disabled = (zone == "arena" and self.settings.noArena) or
			(rated and self.settings.noRatedBattleground) or
			(zone == "pvp" and self.settings.noBattleground and not rated) or
			(zone == ASHRAN_MAP_ID and self.settings.noAshran) or 
			(zone ~= "arena" and zone ~= "pvp" and zone ~= ASHRAN_MAP_ID and self.settings.noWorld)
		self.zone = zone
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_ShowAnchor(self)

	--[[elseif event == "UPDATE_BATTLEFIELD_SCORE" then
		for i = 1, GetNumBattlefieldScores() do
			local name, _,_,_,_,_,_,_, classToken, _,_,_,_,_,_, talentSpec = GetBattlefieldScore(i)
			if name and specNames[classToken] and specNames[classToken][talentSpec] then
				self.specs[name] = specNames[classToken][talentSpec]
			end
		end]]--

	--CHANGES:Lanrutcon: MoP functions that can't be implemented (e.g. "GetArenaOpponentSpec") commented
	--elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or event == "ARENA_OPPONENT_UPDATE" then
	--	for i = 1, 5 do
	--		local specID = GetArenaOpponentSpec(i)
	--		if specID and specID > 0 then
	--			-- only add icons if show unused is checked
	--			if not self.settings.showUnused then return end
	--			if not self.detected[i] then
	--				local class = select(7, GetSpecializationInfoByID(specID))
	--				OmniBar_AddIconsByClass(self, class, i, specID)
	--				self.detected[i] = class
	--			end
	--		end
	--	end

	elseif event == "PLAYER_TARGET_CHANGED" or event == "PLAYER_FOCUS_CHANGED" or event == "PLAYER_REGEN_DISABLED" then
		-- update icon borders
		OmniBar_UpdateBorders(self)

		-- we don't need to add in arena
		if self.zone == "arena" then return end

		-- only add icons if show adaptive is checked
		if not self.settings.showUnused or not self.settings.adaptive then return end

		-- only add icons when we're in combat
		if event == "PLAYER_TARGET_CHANGED" and not InCombatLockdown() then return end

		local unit = "playertarget"
		if IsHostilePlayer(unit) then
			local guid = UnitGUID(unit)
			local _, class = UnitClass(unit)
			if class then
				if self.detected[guid] then return end
				self.detected[guid] = class
				OmniBar_AddIconsByClass(self, class)
			end
		end
	end
end
function OmniBar_LoadSettings(self, specific)
	if (not OmniBarDB) or (not OmniBarDB.version) or OmniBarDB.version ~= SETTINGS_VERSION then
		OmniBarDB = { version = SETTINGS_VERSION, Default = {} }
		for k,v in pairs(defaults) do
			OmniBarDB.Default[k] = v
		end
	end
	local profile = UnitName("player").." - "..GetRealmName()
	if specific then
		OmniBarDB[profile] = nil
		if specific ~= 0 then
			-- Copy the current settings
			OmniBarDB[profile] = {}
			for a,b in pairs(OmniBarDB.Default) do
				if type(b) == "table" then
					OmniBarDB[profile][a] = {}
					for c,d in pairs(b) do
						if type(d) == "table" then
							OmniBarDB[profile][a][c] = {}
							for e,f in pairs(d) do
								OmniBarDB[profile][a][c][e] = f
							end
						else
							OmniBarDB[profile][a][c] = d
						end
					end
				else
					OmniBarDB[profile][a] = b
				end
			end
		end
	end
	self.profile = OmniBarDB[profile] and profile or "Default"
	self.settings = OmniBarDB[self.profile]

	self.settings.cooldowns = self.settings.cooldowns or {}

	-- Set the scale
	self.anchor:SetScale(self.settings.size/BASE_ICON_SIZE)

	-- Refresh if we toggled specific
	if specific then
		OmniBar_LoadPosition(self)
		OmniBar_RefreshIcons(self)
		OmniBar_UpdateIcons(self)
		OmniBar_Center(self)
	end	
end

function OmniBar_Reset(self)
	local profile = UnitName("player").." - "..GetRealmName()
	OmniBarDB.Default = {}
	for k,v in pairs(defaults) do
		OmniBarDB.Default[k] = v
	end
	OmniBarDB[profile] = nil
	OmniBar_LoadSettings(self, 0)
end

function OmniBar_SavePosition(self)
	local point, _, relativePoint, xOfs, yOfs = self:GetPoint()
	if not self.settings.position then 
		self.settings.position = {}
	end
	self.settings.position.point = point
	self.settings.position.relativePoint = relativePoint
	self.settings.position.xOfs = xOfs
	self.settings.position.yOfs = yOfs
end
function OmniBar_LoadPosition(self)
	self:ClearAllPoints()
	if self.settings.position then
		self:SetPoint(self.settings.position.point, UIParent, self.settings.position.relativePoint,
			self.settings.position.xOfs, self.settings.position.yOfs)
	else
		self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	end
end
function OmniBar_IsSpellEnabled(self, spellID)
	if not spellID then return end
	-- Check for an explicit rule
	if self.settings.cooldowns and self.settings.cooldowns[spellID] then
		if self.settings.cooldowns[spellID].enabled then
			return true
		end
	elseif cooldowns[spellID].default then
		-- Not user-set, but a default cooldown
		return true
	end
end
function OmniBar_Center(self)
	local parentWidth = UIParent:GetWidth()
	local clamp = self.settings.center and (1 - parentWidth)/2 or 0
	self:SetClampRectInsets(clamp, -clamp, 0, 0)
	clamp = self.settings.center and (self.anchor:GetWidth() - parentWidth)/2 or 0
	self.anchor:SetClampRectInsets(clamp, -clamp, 0, 0)
end
function OmniBar_CooldownFinish(self, force)
	local icon = self:GetParent()
	if icon.cooldown and GetCooldownTimes(icon.cooldown) and GetCooldownTimes(icon.cooldown) > 0 and not force then return end -- not complete
	local charges = icon.charges
	if charges then
		charges = charges - 1
		if charges > 0 then
			-- remove a charge
			icon.charges = charges
			icon.Count:SetText(charges)
			OmniBar_StartCooldown(icon:GetParent():GetParent(), icon, GetTime())
			return
		end
	end

	local bar = icon:GetParent():GetParent()

	if not bar.settings.showUnused then
		icon:Hide()
	else
		if icon.TargetTexture:GetAlpha() == 0 and
			icon.FocusTexture:GetAlpha() == 0 and
			bar.settings.unusedAlpha then
				icon:SetAlpha(bar.settings.unusedAlpha)
		end
	end
	bar:StopMovingOrSizing()
	OmniBar_Position(bar)
end

function OmniBar_RefreshIcons(self)
	-- Hide all the icons
	for i = 1, self.numIcons do
		if self.icons[i].MasqueGroup then
			--self.icons[i].MasqueGroup:Delete()
			self.icons[i].MasqueGroup = nil
		end
		self.icons[i].TargetTexture:SetAlpha(0)
		self.icons[i].FocusTexture:SetAlpha(0)
		--self.icons[i].flash:SetAlpha(0)
		--self.icons[i].NewItemTexture:SetAlpha(0)
		self.icons[i].cooldown:SetCooldown(0, 0)
		self.icons[i].cooldown:Hide()
		self.icons[i]:Hide()
	end
	wipe(self.active)

	if self.disabled then return end

	if self.settings.showUnused and not self.settings.adaptive then
		for spellID,_ in pairs(cooldowns) do
			if OmniBar_IsSpellEnabled(self, spellID) then
				OmniBar_AddIcon(self, spellID, nil, nil, true)
			end
		end
	end
	OmniBar_Position(self)
end

function OmniBar_StartCooldown(self, icon, start)
	icon.cooldown:SetCooldown(start, icon.duration)
	icon.cooldown.startTime = start;
	icon.cooldown.duration = icon.duration;
	icon.cooldown.finish = start + icon.duration
	--icon.cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
	icon:SetAlpha(1)
	

		local bar = icon:GetParent():GetParent()
	icon.totalElapsed = 0;
	icon:SetScript("OnUpdate", function(self, elapsed)
		self.totalElapsed = self.totalElapsed + elapsed;
		if(self.totalElapsed > self.cooldown.duration) then
			self.totalElapsed = 0;
		if not bar.settings.showUnused then
			self:Hide()
		else
			if self.TargetTexture:GetAlpha() == 0 and
				self.FocusTexture:GetAlpha() == 0 and
				bar.settings.unusedAlpha then
					icon:SetAlpha(bar.settings.unusedAlpha)
					self.cooldown:Hide()
			end
		end
			self:SetScript("OnUpdate", nil);
		end
	end);
	orderByTimeLeft();
	OmniBar_Position(self);
	bar:StopMovingOrSizing()
end


function OmniBar_AddIcon(self, spellID, sourceGUID, sourceName, init, test, specID)


	-- Check for parent spellID
	local originalSpellID = spellID
	if cooldowns[spellID].parent then spellID = cooldowns[spellID].parent end

	if not OmniBar_IsSpellEnabled(self, spellID) then return end
	local icon, duplicate

	-- Try to reuse a visible frame
	for i = 1, #self.active do
		if self.active[i].spellID == spellID then
			duplicate = true
			-- check if we can use this icon, but not when initializing arena opponents
			if not init or self.zone ~= "arena" then
				-- use icon if not bound to a sourceGUID
				if not self.active[i].sourceGUID then
					duplicate = nil
					icon = self.active[i]
					break
				end

				-- if it's the same source, reuse the icon
				if sourceGUID and IconIsSource(self.active[i].sourceGUID, sourceGUID) then
					duplicate = nil
					icon = self.active[i]
					break
				end

			end
		end
	end

	-- We couldn't find a visible frame to reuse, try to find an unused
	if not icon then
		if self.settings.noMultiple and duplicate then return end
		for i = 1, #self.icons do
			if not self.icons[i]:IsVisible() then
				icon = self.icons[i]
				icon.specID = nil
				break
			end
		end
	end


	-- We couldn't find a frame to use
	if not icon then return end

	local now = GetTime()

	if specID then
		icon.specID = specID
	else
		if sourceName and sourceName ~= COMBATLOG_FILTER_STRING_UNKNOWN_UNITS and self.specs[sourceName] then
			icon.specID = self.specs[sourceName]
		end
	end

	icon.class = cooldowns[spellID].class
	icon.sourceGUID = sourceGUID
	icon.icon:SetTexture(cooldowns[spellID].icon)
	icon.spellID = spellID
	icon.added = now

	if icon.charges and cooldowns[originalSpellID].charges and icon:IsVisible() then
		local start, duration = GetCooldownTimes(icon.cooldown)
		if icon.cooldown.finish and icon.cooldown.finish - GetTime() > 1 then
			-- add a charge
			local charges = icon.charges + 1
			icon.charges = charges
			icon.Count:SetText(charges)
			if not self.settings.noGlow then
				animate(icon);
			end
			return icon
		end
	elseif cooldowns[originalSpellID].charges then
		icon.charges = 1
		icon.Count:SetText("1")
	else
		icon.charges = nil
		--icon.Count:SetText(nil) dont touch I think
	end
	if cooldowns[originalSpellID].duration then
		if type(cooldowns[originalSpellID].duration) == "table" then
			if icon.specID and cooldowns[originalSpellID].duration[icon.specID] then
				icon.duration = cooldowns[originalSpellID].duration[icon.specID]
			else
				icon.duration = cooldowns[originalSpellID].duration.default
			end
		else
			icon.duration = cooldowns[originalSpellID].duration
		end
	else -- child doesn't have a custom duration, use parent
		if type(cooldowns[spellID].duration) == "table" then
			if icon.specID and cooldowns[spellID].duration[icon.specID] then
				icon.duration = cooldowns[spellID].duration[icon.specID]
			else
				icon.duration = cooldowns[spellID].duration.default
			end
		else
			icon.duration = cooldowns[spellID].duration
		end
	end

	-- We don't want duration to be too long if we're just testing
	if test then icon.duration = 5 end


	icon:Show()

	if not init then
		OmniBar_StartCooldown(self, icon, now)
		if not self.settings.noGlow then
			animate(icon);
		end
	end

	return icon
end

function OmniBar_UpdateIcons(self)
	for i = 1, self.numIcons do
		-- Set show text
		--self.icons[i].cooldown:SetHideCountdownNumbers(self.settings.noCooldownCount and true or false)
		self.icons[i].cooldown.noCooldownCount = self.settings.noCooldownCount and true

		-- Set swipe alpha
		--self.icons[i].cooldown:SetSwipeColor(0, 0, 0, self.settings.swipeAlpha or 0.65)
		-- Set border
		if self.settings.border then
			self.icons[i].icon:SetTexCoord(0, 0, 0, 1, 1, 0, 1, 1)
		else
			self.icons[i].icon:SetTexCoord(0.07, 0.9, 0.07, 0.9)
		end

		-- Set dim
		self.icons[i]:SetAlpha(self.settings.unusedAlpha and self.settings.unusedAlpha or 1)

		-- Masque
		if self.icons[i].MasqueGroup then self.icons[i].MasqueGroup:ReSkin() end

	end
end

function OmniBar_Test(self)
	self.disabled = nil

	OmniBar_RefreshIcons(self)
	for k,v in pairs(cooldowns) do
		OmniBar_AddIcon(self, k, nil, nil, nil, true)
	end
end

local function ExtractDigits(str)
	if not str then return 0 end
	if type(str) == "number" then return str end
	local num = str:gsub("%D", "")
	return tonumber(num) or 0
end

function OmniBar_Position(self)

	local numActive = #self.active
	if numActive == 0 then
		-- Show the anchor if needed
		OmniBar_ShowAnchor(self)
		return
	end

	-- Keep cooldowns together by class
	if self.settings.showUnused then
		table.sort(self.active, function(a, b)
			local x, y = ExtractDigits(a.sourceGUID), ExtractDigits(b.sourceGUID)
			if a.class == b.class then
				if x < y then return true end
				if x == y then return a.spellID < b.spellID end
			end
			return order[a.class] < order[b.class]
		end)
	else
		-- if we aren't showing unused, just sort by added time
		table.sort(self.active, function(a, b)
			return a.added == b.added and a.spellID < b.spellID or a.added < b.added
		end)
	end

	local count, rows = 0, 1
	local grow = self.settings.growUpward and 1 or -1
	local padding = self.settings.padding and self.settings.padding or 0
	for i = 1, numActive do
		if self.settings.locked then
			self.active[i]:EnableMouse(false)
		else
			self.active[i]:EnableMouse(true)
		end
		self.active[i]:ClearAllPoints()
		local columns = self.settings.columns and self.settings.columns > 0 and self.settings.columns < numActive and
			self.settings.columns or numActive
		if i > 1 then
			count = count + 1
			if count >= columns then
				self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, (BASE_ICON_SIZE+padding)*rows*grow)
				count = 0
				rows = rows + 1
			else
				self.active[i]:SetPoint("TOPLEFT", self.active[i-1], "TOPRIGHT", padding, 0)
			end
			
		else
			self.active[i]:SetPoint("CENTER", OmniBarIcons, "CENTER", (-BASE_ICON_SIZE-padding)*(columns-1)/2, 0)
		end
	end
	
	OmniBar_ShowAnchor(self)
end


SLASH_OmniBar1 = "/ob"
SLASH_OmniBar2 = "/omnibar"
SlashCmdList.OmniBar = function(msg)
	local cmd, arg1 = string.split(" ", string.lower(msg))

	if cmd == "lock" or cmd == "unlock" then
		OmniBar.settings.locked = cmd == "lock" and true or false
		OmniBar_Position(OmniBar)
		if OmniBarOptionsPanelLock then OmniBarOptionsPanelLock:SetChecked(OmniBar.settings.locked) end

	elseif cmd == "reset" then
		StaticPopup_Show("OMNIBAR_CONFIRM_RESET")

	elseif cmd == "test" then
		OmniBar_Test(OmniBar)

	else
		if LoadAddOn("OmniBar_Options") then
			InterfaceOptionsFrame_OpenToCategory(addonName)
			InterfaceOptionsFrame_OpenToCategory(addonName)
		end

	end

end

local animationsCount = 5;
local animations = {};
local borderFrame, borderT, flashFrame, flashT, animationGroup, animationGroupTwo, alphaF1,alphaF2, alpha1, alpha2, alpha3, alpha4, scale1;
for i = 1, animationsCount do

	--Border Frame
	borderframe = CreateFrame("Frame");
  
	--Border Texture
	borderT = borderframe:CreateTexture(nil, "OVERLAY")
	borderT:SetTexture("Interface\\AddOns\\OmniBar\\UI-ActionButton-Border.blp");
	borderT:SetAlpha(0);
	borderT:SetAllPoints();
	borderT:SetBlendMode("ADD");
	borderT:SetVertexColor(0.0,0.4392156862745098,0.8666666666666667)
  
	--Flash Frame
    flashFrame = CreateFrame("Frame");
	
	--Flash Texture
	flashT = flashFrame:CreateTexture(nil, "OVERLAY")
	flashT:SetTexture("Interface\\AddOns\\OmniBar\\Bags.blp");
	flashT:SetHeight(95);
	flashT:SetWidth(95);
	flashT:SetAlpha(0);
	flashT:SetAllPoints();
	flashT:SetBlendMode("ADD");
	flashT:SetTexCoord(0.35546875,0.00390625,0.35546875,0.0078125)

	--{"bags-glow-purple", [[Interface\ContainerFrame\Bags.BLP]], 39, 39, 0.5234375, 0.67578125, 0.0078125, 0.3125, false, false},
	--{"bags-glow-blue", [[Interface\ContainerFrame\Bags.BLP]], 39, 39, 0.36328125, 0.515625, 0.328125, 0.6328125, false, false},
	--{"bags-glow-orange", [[Interface\ContainerFrame\Bags.BLP]], 39, 39, 0.36328125, 0.515625, 0.6484375, 0.953125, false, false},
	--{"bags-glow-green", [[Interface\ContainerFrame\Bags.BLP]], 39, 39, 0.36328125, 0.515625, 0.0078125, 0.3125, false, false},
	--{"bags-glow-heirloom", [[Interface\ContainerFrame\Bags.BLP]], 39, 39, 0.68359375, 0.8359375, 0.0078125, 0.3125, false, false},
	--{"bags-glow-white", [[Interface\ContainerFrame\Bags.BLP]], 39, 39, 0.84375, 0.99609375, 0.0078125, 0.3125, false, false},
	--{"bags-glow-flash", [[Interface\ContainerFrame\Bags.BLP]], 90, 90, 0.00390625, 0.35546875, 0.0078125, 0.7109375, false, false},
  
	--FLASH
	animationGroupTwo = flashT:CreateAnimationGroup();
  
	scaleF = animationGroupTwo:CreateAnimation("Scale");
	scaleF:SetScale(2, 2);
	scaleF:SetDuration(0);
	scaleF:SetOrder(1);

	alphaF1 = animationGroupTwo:CreateAnimation("Alpha");
	alphaF1:SetChange(1);
	alphaF1:SetDuration(0);
	alphaF1:SetOrder(1);
	alphaF1:SetSmoothing("OUT")

	alphaF2 = animationGroupTwo:CreateAnimation("Alpha");
	alphaF2:SetChange(-1);
	alphaF2:SetDuration(1);
	alphaF2:SetOrder(2);
	alphaF2:SetSmoothing("OUT")

	--BLUE BORDER
	animationGroup = borderT:CreateAnimationGroup();

	scale1 = animationGroup:CreateAnimation("Scale");
	scale1:SetScale(2, 2);
	scale1:SetDuration(0);
	scale1:SetOrder(1);

	alpha1 = animationGroup:CreateAnimation("Alpha");
	alpha1:SetChange(1);
	alpha1:SetDuration(1);
	alpha1:SetOrder(1);
	alpha1:SetSmoothing("OUT")

	alpha2 = animationGroup:CreateAnimation("Alpha");
	alpha2:SetChange(-0.6);
	alpha2:SetDuration(1);
	alpha2:SetOrder(2);

	alpha3 = animationGroup:CreateAnimation("Alpha");
	alpha3:SetChange(0.6);
	alpha3:SetDuration(1);
	alpha3:SetOrder(3);

	alpha4 = animationGroup:CreateAnimation("Alpha");
	alpha4:SetChange(-1);
	alpha4:SetDuration(1);
	alpha4:SetOrder(4);
  
	animations[i] = {borderFrame = borderframe, flashFrame = flashFrame, animationGroup = animationGroup, animationGroupTwo = animationGroupTwo};
end

local animationNum = 1;
function animate(button)

  if (not button:IsVisible()) then
    return true;
  end

  local animation = animations[animationNum];
  local borderFrame = animation.borderFrame;
  local animationGroup = animation.animationGroup;

  borderFrame:SetFrameStrata(button:GetFrameStrata());
  borderFrame:SetFrameLevel(button:GetFrameLevel() + 10);
  borderFrame:SetAllPoints(button);

  animationGroup:Stop();
  animationGroup:Play();
  
  local flashFrame = animation.flashFrame;
  local animationGroupTwo = animation.animationGroupTwo;

  flashFrame:SetFrameStrata(button:GetFrameStrata());
  flashFrame:SetFrameLevel(button:GetFrameLevel() + 10);
  flashFrame:SetAllPoints(button);

  animationGroupTwo:Stop();
  animationGroupTwo:Play();

  animationNum = (animationNum % animationsCount) + 1;

  return true;
end

