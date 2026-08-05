-- In-game CoA cooldown scanner for OmniBar.
-- Uses Ascension Character Advancement APIs (same source CoARU uses).
-- Usage in chat:
--   /obscan           -- scan all CoA classes, min CD 8s
--   /obscan 12        -- Barbarian only (class file token via OmniBarCoA)
--   /obscan BARBARIAN -- same
--   /obscan min 20    -- raise minimum cooldown filter
-- After scan: /reload, then import SavedVariables with tools/import_coa_scan.ps1

OmniBarCoA = OmniBarCoA or {}

local MIN_CD_DEFAULT = 8

local DISPLAY_TO_TOKEN = {
	["Barbarian"] = "BARBARIAN",
	["Witch Doctor"] = "WITCHDOCTOR",
	["Felsworn"] = "DEMONHUNTER",
	["Witch Hunter"] = "WITCHHUNTER",
	["Stormbringer"] = "STORMBRINGER",
	["Knight of Xoroth"] = "FLESHWARDEN",
	["Guardian"] = "GUARDIAN",
	["Templar"] = "MONK",
	["Bloodmage"] = "SONOFARUGAL",
	["Son of Arugal"] = "SONOFARUGAL",
	["Ranger"] = "RANGER",
	["Venomancer"] = "PROPHET",
	["Pyromancer"] = "PYROMANCER",
	["Cultist"] = "CULTIST",
	["Necromancer"] = "NECROMANCER",
	["Sun Cleric"] = "SUNCLERIC",
	["Tinker"] = "TINKER",
	["Reaper"] = "REAPER",
	["Primalist"] = "WILDWALKER",
	["Starcaller"] = "STARCALLER",
	["Runemaster"] = "SPIRITMAGE",
	["Chronomancer"] = "CHRONOMANCER",
}

-- Alternate fileString tokens seen in Ascension / other addons
local ALIAS_TO_TOKEN = {
	KNIGHTOFXOROTH = "FLESHWARDEN",
	["KNIGHT_OF_XOROTH"] = "FLESHWARDEN",
	FLESHWARDEN = "FLESHWARDEN",
	SONOFARUGAL = "SONOFARUGAL",
	["SON_OF_ARUGAL"] = "SONOFARUGAL",
}

local KEYWORDS = {
	"interrupt", "silence", "stun", "fear", "hex", "kick", "bash", "counter",
	"dispel", "immunity", "shield", "bubble", "wall", "vanish", "cloak",
	"reflect", "grounding", "brand", "charge", "leap", "blink", "dash",
}

local SKIP_NAMES = {
	["every man for himself"] = true,
	["axe and fist weapons specialization"] = true,
	["axe specialization"] = true,
	["fist weapons"] = true,
}

local tip = CreateFrame("GameTooltip", "OmniBarScanTooltip", nil, "GameTooltipTemplate")
tip:SetOwner(UIParent, "ANCHOR_NONE")

local function msg(text)
	DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99OmniBar Scan|r: " .. text)
end

local function normalizeToken(raw)
	if raw == nil then return nil end
	local s = tostring(raw)
	if OmniBarCoA.classNames and OmniBarCoA.classNames[s] then
		return s
	end
	if DISPLAY_TO_TOKEN[s] then
		return DISPLAY_TO_TOKEN[s]
	end
	local upper = string.upper(s:gsub("[%s%-_]+", ""))
	if ALIAS_TO_TOKEN[upper] then
		return ALIAS_TO_TOKEN[upper]
	end
	if ALIAS_TO_TOKEN[string.upper(s)] then
		return ALIAS_TO_TOKEN[string.upper(s)]
	end
	if OmniBarCoA.classNames and OmniBarCoA.classNames[upper] then
		return upper
	end
	-- "Knight of Xoroth" -> KNIGHTOFXOROTH -> FLESHWARDEN
	if DISPLAY_TO_TOKEN[s] then
		return DISPLAY_TO_TOKEN[s]
	end
	local spaced = s:gsub("(%u)", " %1"):gsub("^%s+", "")
	if DISPLAY_TO_TOKEN[spaced] then
		return DISPLAY_TO_TOKEN[spaced]
	end
	-- Class DBC / numeric id fallback via CharacterAdvancementUtil if present
	if CharacterAdvancementUtil and CharacterAdvancementUtil.GetClassFileByDBC then
		local ok, file = pcall(CharacterAdvancementUtil.GetClassFileByDBC, raw)
		if ok and file and tostring(file) ~= s then
			return normalizeToken(file)
		end
	end
	return nil
end

local function entrySpellIds(entry)
	local out = {}
	if type(entry) ~= "table" then return out end
	local sp = entry.Spells
	if type(sp) == "table" then
		for _, x in ipairs(sp) do
			local id = tonumber(x)
			if not id and type(x) == "table" then
				id = tonumber(x.SpellID or x.ID or x.Spell)
			end
			if id then out[#out + 1] = id end
		end
	elseif type(sp) == "string" or type(sp) == "number" then
		for d in tostring(sp):gmatch("%d+") do
			out[#out + 1] = tonumber(d)
		end
	end
	return out
end

local function tooltipCooldownSeconds(spellID)
	tip:ClearLines()
	if tip.SetSpellByID then
		tip:SetSpellByID(spellID)
	elseif tip.SetHyperlink then
		tip:SetHyperlink("spell:" .. spellID)
	else
		return 0
	end
	for i = 1, tip:NumLines() do
		local left = _G["OmniBarScanTooltipTextLeft" .. i]
		local text = left and left:GetText()
		if text then
			local minCd = text:match("(%d+)%s*[Mm]in%s*[Cc]ooldown")
			if minCd then return tonumber(minCd) * 60 end
			local secCd = text:match("(%d+)%s*[Ss]ec%s*[Cc]ooldown")
			if secCd then return tonumber(secCd) end
			minCd = text:match("(%d+)%s*мин")
			if minCd and text:lower():find("восстанов") then return tonumber(minCd) * 60 end
			secCd = text:match("(%d+)%s*сек")
			if secCd and text:lower():find("восстанов") then return tonumber(secCd) end
		end
	end
	return 0
end

local function baseCooldownSeconds(spellID)
	if GetSpellBaseCooldown then
		local ok, a, b = pcall(GetSpellBaseCooldown, spellID)
		if ok then
			-- Retail-style: durationMs, gcdMs. Classic forks may return seconds.
			local dur = tonumber(a) or 0
			if dur >= 1000 then
				return math.floor(dur / 1000)
			end
			if dur > 0 then
				return math.floor(dur)
			end
			-- some clients put ms in second return
			local dur2 = tonumber(b) or 0
			if dur2 >= 1000 then
				return math.floor(dur2 / 1000)
			end
		end
	end
	return tooltipCooldownSeconds(spellID)
end

local function isPassive(spellID, name)
	local rank = select(2, GetSpellInfo(spellID))
	if rank and tostring(rank):lower() == "passive" then
		return true
	end
	tip:ClearLines()
	if tip.SetSpellByID then
		tip:SetSpellByID(spellID)
	elseif tip.SetHyperlink then
		tip:SetHyperlink("spell:" .. spellID)
	end
	for i = 1, tip:NumLines() do
		local left = _G["OmniBarScanTooltipTextLeft" .. i]
		local text = left and left:GetText()
		if text and text:lower():find("passive") then
			return true
		end
	end
	return false
end

local function defaultFor(name, duration)
	local key = string.lower(name or "")
	for _, k in ipairs(KEYWORDS) do
		if key:find(k, 1, true) then
			return true
		end
	end
	return duration >= 45
end

local function ensureDB()
	OmniBarDB = OmniBarDB or {}
	OmniBarDB.coaScan = OmniBarDB.coaScan or {}
	return OmniBarDB.coaScan
end

local function collectEntries()
	local api = C_CharacterAdvancement
	if not api then
		return nil, "C_CharacterAdvancement missing"
	end
	if api.GetAllEntries then
		local ok, all = pcall(api.GetAllEntries)
		if not (ok and type(all) == "table") then
			ok, all = pcall(api.GetAllEntries, api)
		end
		if ok and type(all) == "table" then
			return all, "GetAllEntries"
		end
	end
	-- Fallback: current class only via GetSpellsByClass
	if api.GetSpellsByClass then
		local classFile = C_Player and C_Player.GetClass and C_Player:GetClass()
			or select(2, UnitClass("player"))
		local class = CharacterAdvancementUtil and CharacterAdvancementUtil.GetClassDBCByFile
			and CharacterAdvancementUtil.GetClassDBCByFile(classFile) or classFile
		local specs = { "None" }
		if C_ClassInfo and C_ClassInfo.GetAllSpecs then
			local ok, all = pcall(C_ClassInfo.GetAllSpecs, C_ClassInfo, classFile)
			if not (ok and type(all) == "table") then
				ok, all = pcall(C_ClassInfo.GetAllSpecs, classFile)
			end
			if ok and type(all) == "table" then
				for _, s in ipairs(all) do
					if type(s) == "table" then s = s.Name or s.ID end
					if s then specs[#specs + 1] = s end
				end
			end
		end
		local merged = {}
		for _, spec in ipairs(specs) do
			local ok, list = pcall(api.GetSpellsByClass, class, spec, true)
			if ok and type(list) == "table" then
				for _, e in ipairs(list) do
					if type(e) == "table" then
						e.Class = e.Class or classFile
						merged[#merged + 1] = e
					end
				end
			end
			if api.GetTalentsByClass then
				local ok2, list2 = pcall(api.GetTalentsByClass, class, spec, true)
				if ok2 and type(list2) == "table" then
					for _, e in ipairs(list2) do
						if type(e) == "table" then
							e.Class = e.Class or classFile
							merged[#merged + 1] = e
						end
					end
				end
			end
		end
		if #merged > 0 then
			return merged, "GetSpellsByClass:" .. tostring(classFile)
		end
	end
	return nil, "no usable Character Advancement API"
end

local function buildLua(rows)
	local lines = {}
	local current = nil
	for _, r in ipairs(rows) do
		if r.class ~= current then
			lines[#lines + 1] = string.format("\t-- %s", r.class)
			current = r.class
		end
		local flag = r.default and "true" or "false"
		local safe = (r.name or ("Spell " .. r.id)):gsub("%-%-", "-")
		lines[#lines + 1] = string.format(
			"\t[%d] = { default = %s, duration = %d, class = \"%s\" }, -- %s",
			r.id, flag, r.duration, r.class, safe
		)
	end
	return table.concat(lines, "\n")
end

function OmniBar_ScanCooldowns(opts)
	opts = opts or {}
	local minCd = tonumber(opts.minCd) or MIN_CD_DEFAULT
	local onlyToken = opts.token and normalizeToken(opts.token) or nil

	local entries, source = collectEntries()
	if not entries then
		msg("|cffff0000" .. tostring(source) .. "|r")
		return
	end
	msg("source=" .. tostring(source) .. ", entries=" .. #entries .. ", minCd=" .. minCd
		.. (onlyToken and (", class=" .. onlyToken) or ", class=ALL"))

	local byId = {}
	local classHits = {}
	local unknownClasses = {}
	local rawClassSamples = {}

	local function absorbSpell(spellID, token)
		local name = GetSpellInfo(spellID)
		if not name or SKIP_NAMES[string.lower(name)] or isPassive(spellID, name) then
			return
		end
		local duration = baseCooldownSeconds(spellID)
		if duration < minCd then
			return
		end
		local prev = byId[spellID]
		if not prev or prev.duration < duration then
			byId[spellID] = {
				id = spellID,
				name = name,
				duration = duration,
				class = token,
				default = defaultFor(name, duration),
			}
		end
	end

	for _, entry in ipairs(entries) do
		if type(entry) == "table" then
			local rawClass = entry.Class or entry.ClassFile or entry.OwnerClass or entry.class
			local key = tostring(rawClass or "?")
			rawClassSamples[key] = (rawClassSamples[key] or 0) + 1
			local token = normalizeToken(rawClass)
			if not token then
				unknownClasses[key] = (unknownClasses[key] or 0) + 1
			elseif (not onlyToken or token == onlyToken) then
				classHits[token] = (classHits[token] or 0)
				for _, spellID in ipairs(entrySpellIds(entry)) do
					classHits[token] = classHits[token] + 1
					absorbSpell(spellID, token)
				end
			end
		end
	end

	-- Also harvest the currently played class via GetSpellsByClass (covers CA gaps).
	local playerFile = C_Player and C_Player.GetClass and C_Player:GetClass()
		or select(2, UnitClass("player"))
	local playerToken = normalizeToken(playerFile)
	if playerToken and (not onlyToken or onlyToken == playerToken) and C_CharacterAdvancement and C_CharacterAdvancement.GetSpellsByClass then
		local classArg = CharacterAdvancementUtil and CharacterAdvancementUtil.GetClassDBCByFile
			and CharacterAdvancementUtil.GetClassDBCByFile(playerFile) or playerFile
		local specs = { "None" }
		if C_ClassInfo and C_ClassInfo.GetAllSpecs then
			local ok, all = pcall(C_ClassInfo.GetAllSpecs, C_ClassInfo, playerFile)
			if not (ok and type(all) == "table") then
				ok, all = pcall(C_ClassInfo.GetAllSpecs, playerFile)
			end
			if ok and type(all) == "table" then
				for _, s in ipairs(all) do
					if type(s) == "table" then s = s.Name or s.ID end
					if s then specs[#specs + 1] = s end
				end
			end
		end
		local added = 0
		for _, spec in ipairs(specs) do
			local lists = {}
			local ok, list = pcall(C_CharacterAdvancement.GetSpellsByClass, classArg, spec, true)
			if ok then lists[#lists + 1] = list end
			if C_CharacterAdvancement.GetTalentsByClass then
				local ok2, list2 = pcall(C_CharacterAdvancement.GetTalentsByClass, classArg, spec, true)
				if ok2 then lists[#lists + 1] = list2 end
			end
			for _, list in ipairs(lists) do
				if type(list) == "table" then
					for _, entry in ipairs(list) do
						for _, spellID in ipairs(entrySpellIds(entry)) do
							local before = byId[spellID]
							absorbSpell(spellID, playerToken)
							if byId[spellID] and not before then
								added = added + 1
								classHits[playerToken] = (classHits[playerToken] or 0) + 1
							end
						end
					end
				end
			end
		end
		msg(string.format("player class %s (%s): +%d spells from GetSpellsByClass",
			tostring(playerToken), tostring(playerFile), added))
	end

	local rows = {}
	for _, row in pairs(byId) do
		rows[#rows + 1] = row
	end
	table.sort(rows, function(a, b)
		if a.class == b.class then
			return (a.name or "") < (b.name or "")
		end
		return a.class < b.class
	end)

	local luaBody = buildLua(rows)
	local db = ensureDB()
	db.when = time()
	db.source = source
	db.minCd = minCd
	db.token = onlyToken
	db.count = #rows
	db.rows = rows
	db.lua = luaBody
	db.classHits = classHits
	db.unknownClasses = unknownClasses
	db.rawClassSamples = rawClassSamples
	db.playerClass = playerFile
	db.playerToken = playerToken

	local classes = 0
	for _ in pairs(classHits) do classes = classes + 1 end
	msg(string.format("kept |cffffd100%d|r cooldowns across |cffffd100%d|r classes", #rows, classes))

	local unkN = 0
	for raw, n in pairs(unknownClasses) do
		unkN = unkN + 1
		if unkN <= 12 then
			msg(string.format("|cffff9900unknown Class|r %s (x%d)", tostring(raw), n))
		end
	end
	if unkN == 0 then
		msg("no unknown Class values")
	elseif unkN > 12 then
		msg(string.format("...and %d more unknown Class keys (see OmniBarDB.coaScan.unknownClasses)", unkN - 12))
	end

	msg("saved to OmniBarDB.coaScan — do |cffffd100/reload|r, then run tools/import_coa_scan.ps1")
	if #rows > 0 then
		msg("preview:")
		for i = 1, math.min(5, #rows) do
			local r = rows[i]
			msg(string.format("  [%d] %s %ds %s", r.id, r.name, r.duration, r.class))
		end
	end
end

SLASH_OMNIBARCLASS1 = "/obclass"
SlashCmdList["OMNIBARCLASS"] = function()
	local loc, file = UnitClass("player")
	local token = normalizeToken(file)
	msg(string.format("UnitClass => loc=%s file=%s => token=%s",
		tostring(loc), tostring(file), tostring(token)))
	if C_Player and C_Player.GetClass then
		local ok, v = pcall(C_Player.GetClass, C_Player)
		msg(string.format("C_Player:GetClass => %s (token=%s)", tostring(ok and v or v), tostring(normalizeToken(ok and v or nil))))
	end
	if Enum and Enum.ClassFile then
		local hits = {}
		for k, v in pairs(Enum.ClassFile) do
			if type(k) == "string" and (k:find("FLESH") or k:find("XOROTH") or k:find("KNIGHT") or k:find("WARDEN")) then
				hits[#hits + 1] = k .. "=" .. tostring(v)
			end
		end
		if #hits > 0 then
			msg("Enum.ClassFile matches: " .. table.concat(hits, ", "))
		else
			msg("Enum.ClassFile: no FLESH/XOROTH/KNIGHT keys (dump may be sparse)")
		end
	end
	if LOCALIZED_CLASS_NAMES_MALE then
		for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
			if tostring(v):find("Xoroth") or k:find("FLESH") or k:find("XOROTH") or k:find("KNIGHT") then
				msg(string.format("LOCALIZED_CLASS_NAMES_MALE[%s]=%s", tostring(k), tostring(v)))
			end
		end
	end
end

SLASH_OMNIBARSCAN1 = "/obscan"
SlashCmdList["OMNIBARSCAN"] = function(msgText)
	msgText = strtrim(msgText or "")
	local opts = {}
	if msgText ~= "" then
		local minArg, minVal = msgText:match("^(min)%s+(%d+)$")
		if minArg then
			opts.minCd = tonumber(minVal)
		elseif msgText:match("^%d+$") then
			-- class id from Tavern map (12 = Barbarian) if present in fetch script mapping
			local idMap = {
				[12] = "BARBARIAN", [13] = "WITCHDOCTOR", [14] = "DEMONHUNTER",
				[15] = "WITCHHUNTER", [16] = "STORMBRINGER", [17] = "FLESHWARDEN",
				[18] = "GUARDIAN", [19] = "MONK", [20] = "SONOFARUGAL",
				[21] = "RANGER", [22] = "CHRONOMANCER", [23] = "NECROMANCER",
				[24] = "PYROMANCER", [25] = "CULTIST", [26] = "STARCALLER",
				[27] = "SUNCLERIC", [28] = "TINKER", [29] = "PROPHET",
				[30] = "REAPER", [31] = "WILDWALKER", [32] = "SPIRITMAGE",
			}
			opts.token = idMap[tonumber(msgText)] or msgText
		else
			opts.token = msgText
		end
	end
	OmniBar_ScanCooldowns(opts)
end
