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

local function classFileCandidates(token)
	local names = { token }
	if OmniBarCoA.classNames and OmniBarCoA.classNames[token] then
		names[#names + 1] = OmniBarCoA.classNames[token]
	end
	-- CamelCase from TOKEN: SUNCLERIC -> Suncleric is wrong; prefer known display names only
	return names
end

local function specsForClassFile(classFile)
	local specs = { "None" }
	if not (C_ClassInfo and C_ClassInfo.GetAllSpecs) then
		return specs
	end
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
	return specs
end

-- Harvest cooldown rows for one CoA token via GetSpellsByClass / GetTalentsByClass.
local function harvestClassSpells(token, minCd)
	minCd = minCd or MIN_CD_DEFAULT
	local api = C_CharacterAdvancement
	if not (api and api.GetSpellsByClass) then
		return {}, "GetSpellsByClass missing"
	end
	local byId = {}
	local tried = {}
	local function tryFile(classFile)
		if not classFile or tried[tostring(classFile)] then return end
		tried[tostring(classFile)] = true
		local classArg = classFile
		if CharacterAdvancementUtil and CharacterAdvancementUtil.GetClassDBCByFile then
			local ok, dbc = pcall(CharacterAdvancementUtil.GetClassDBCByFile, classFile)
			if ok and dbc then classArg = dbc end
		end
		for _, spec in ipairs(specsForClassFile(classFile)) do
			local lists = {}
			local ok, list = pcall(api.GetSpellsByClass, classArg, spec, true)
			if ok then lists[#lists + 1] = list end
			if api.GetTalentsByClass then
				local ok2, list2 = pcall(api.GetTalentsByClass, classArg, spec, true)
				if ok2 then lists[#lists + 1] = list2 end
			end
			for _, lst in ipairs(lists) do
				if type(lst) == "table" then
					for _, entry in ipairs(lst) do
						for _, spellID in ipairs(entrySpellIds(entry)) do
							local name = GetSpellInfo(spellID)
							if name and not SKIP_NAMES[string.lower(name)] and not isPassive(spellID, name) then
								local duration = baseCooldownSeconds(spellID)
								if duration >= minCd then
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
							end
						end
					end
				end
			end
		end
	end

	tryFile(token)
	for _, alt in ipairs(classFileCandidates(token)) do
		tryFile(alt)
	end
	-- rawClassSamples-style names from CA (DemonHunter, SunCleric, …)
	local camel = token:lower():gsub("^(.)", string.upper)
	tryFile(camel)
	if token == "SUNCLERIC" then tryFile("SunCleric") end
	if token == "WITCHDOCTOR" then tryFile("WitchDoctor") end
	if token == "DEMONHUNTER" then tryFile("DemonHunter") end
	if token == "WITCHHUNTER" then tryFile("WitchHunter") end
	if token == "SONOFARUGAL" then tryFile("SonOfArugal") end
	if token == "SPIRITMAGE" then tryFile("Runemaster") end
	if token == "PROPHET" then tryFile("Venomancer") end
	if token == "WILDWALKER" then tryFile("Primalist") end
	if token == "FLESHWARDEN" then
		tryFile("Fleshwarden")
		tryFile("KnightOfXoroth")
		tryFile("Knight of Xoroth")
	end
	if token == "MONK" then tryFile("Templar") end

	local rows = {}
	for _, row in pairs(byId) do
		rows[#rows + 1] = row
	end
	table.sort(rows, function(a, b) return (a.name or "") < (b.name or "") end)
	return rows, "GetSpellsByClass"
end

local function knownCooldownIds()
	local known = {}
	if OmniBarCoA and OmniBarCoA.cooldowns then
		for id in pairs(OmniBarCoA.cooldowns) do
			known[id] = true
		end
	end
	return known
end

-- Diff CA spells vs OmniBarCoA.cooldowns. /obgaps [all|CLASS] [apply]
function OmniBar_FindGaps(opts)
	opts = opts or {}
	local minCd = tonumber(opts.minCd) or MIN_CD_DEFAULT
	local apply = opts.apply and true or false
	local tokens = opts.tokens
	if not tokens then
		if opts.all then
			tokens = OmniBarCoA.classOrder or {}
		else
			local file = C_Player and C_Player.GetClass and C_Player:GetClass()
				or select(2, UnitClass("player"))
			local token = normalizeToken(file)
			if not token then
				msg("cannot resolve player class token from " .. tostring(file))
				return
			end
			tokens = { token }
		end
	end

	local known = knownCooldownIds()
	local gaps = {}
	local perClass = {}
	for _, token in ipairs(tokens) do
		token = normalizeToken(token) or token
		local rows = harvestClassSpells(token, minCd)
		local missing = {}
		for _, row in ipairs(rows) do
			if not known[row.id] then
				missing[#missing + 1] = row
				gaps[#gaps + 1] = row
			end
		end
		perClass[token] = { total = #rows, missing = #missing }
		msg(string.format("%s: CA=%d  missing_from_OmniBar=%d", token, #rows, #missing))
		for i = 1, math.min(8, #missing) do
			local r = missing[i]
			msg(string.format("  + [%d] %s %ds", r.id, r.name, r.duration))
		end
		if #missing > 8 then
			msg(string.format("  … +%d more", #missing - 8))
		end
	end

	local db = ensureDB()
	db.gaps = gaps
	db.gapSummary = perClass
	db.gapWhen = time()

	if apply and #gaps > 0 then
		db.extra = db.extra or {}
		db.rows = db.rows or {}
		local byId = {}
		for _, r in ipairs(db.rows) do byId[r.id] = r end
		local added = 0
		for _, row in ipairs(gaps) do
			if not byId[row.id] then
				db.rows[#db.rows + 1] = row
				byId[row.id] = row
				added = added + 1
			end
			db.extra[row.id] = row
			-- live-merge into loaded table so /ob options see them after refresh
			if OmniBarCoA and OmniBarCoA.cooldowns and not OmniBarCoA.cooldowns[row.id] then
				OmniBarCoA.cooldowns[row.id] = {
					default = row.default,
					duration = row.duration,
					class = row.class,
				}
			end
		end
		table.sort(db.rows, function(a, b)
			if a.class == b.class then return (a.name or "") < (b.name or "") end
			return a.class < b.class
		end)
		db.count = #db.rows
		db.lua = buildLua(db.rows)
		msg(string.format("apply: queued %d gaps into OmniBarDB.coaScan (live-merged %d). /reload + import_coa_scan.ps1",
			#gaps, added))
	else
		msg(string.format("gaps total=%d — review, then |cffffd100/obgaps apply|r (or /obgaps all apply)", #gaps))
	end
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

-- Find spell IDs by name substring (works on any character via GetSpellInfo).
-- Usage:
--   /obfind Chosen of the Light
--   /obfind Judgement Day
--   /obadd 524913 SUNCLERIC   -- manually queue a hit into coaScan.extra
local FIND_RANGES = {
	{ 300000, 302500 },
	{ 500000, 582500 },
	{ 645000, 682500 },
	{ 700000, 812000 },
	{ 1397000, 1400000 },
}

local findState

local function findStop(reason)
	if findState and findState.frame then
		findState.frame:SetScript("OnUpdate", nil)
	end
	if reason then msg(reason) end
	findState = nil
end

local function findTick(frame, elapsed)
	if not findState then return end
	findState.budget = (findState.budget or 0) + elapsed
	-- ~8ms worth of work per frame budget approximated by count
	local steps = 0
	local maxSteps = 400
	while steps < maxSteps do
		local st = findState
		if st.ri > #FIND_RANGES then
			local db = ensureDB()
			db.findHits = st.hits
			db.findQuery = st.query
			db.findHistory = db.findHistory or {}
			db.findHistory[st.query] = st.hits
			msg(string.format("find done: query=\"%s\" hits=%d (saved findHits + findHistory). /reload or /obadd <id> CLASS",
				st.query, #st.hits))
			for i = 1, math.min(20, #st.hits) do
				local h = st.hits[i]
				msg(string.format("  [%d] %s  cd=%ds", h.id, h.name, h.duration))
			end
			findStop()
			return
		end
		local range = FIND_RANGES[st.ri]
		local id = st.cur
		if id > range[2] then
			st.ri = st.ri + 1
			if st.ri <= #FIND_RANGES then
				st.cur = FIND_RANGES[st.ri][1]
			end
		else
			local name = GetSpellInfo(id)
			if name and name:lower():find(st.query, 1, true) then
				local duration = baseCooldownSeconds(id)
				st.hits[#st.hits + 1] = {
					id = id,
					name = name,
					duration = duration,
					rank = select(2, GetSpellInfo(id)),
				}
				msg(string.format("  hit [%d] %s (%ds)", id, name, duration))
			end
			st.cur = id + 1
			st.scanned = (st.scanned or 0) + 1
			if st.scanned % 25000 == 0 then
				msg(string.format("find progress… scanned %d ids, hits=%d", st.scanned, #st.hits))
			end
		end
		steps = steps + 1
	end
end

function OmniBar_FindSpellByName(query)
	query = strtrim(query or "")
	if query == "" then
		msg("usage: /obfind <name substring>   e.g. /obfind Chosen of the Light")
		return
	end
	if findState then
		msg("find already running — wait or /reload")
		return
	end
	local frame = CreateFrame("Frame")
	findState = {
		query = query:lower(),
		ri = 1,
		cur = FIND_RANGES[1][1],
		hits = {},
		scanned = 0,
		frame = frame,
	}
	msg(string.format("searching for \"%s\" across CoA spell id ranges…", query))
	frame:SetScript("OnUpdate", findTick)
end

SLASH_OMNIBARFIND1 = "/obfind"
SlashCmdList["OMNIBARFIND"] = function(msgText)
	OmniBar_FindSpellByName(msgText)
end

SLASH_OMNIBARADD1 = "/obadd"
SlashCmdList["OMNIBARADD"] = function(msgText)
	msgText = strtrim(msgText or "")
	local id, token = msgText:match("^(%d+)%s+(%S+)$")
	id = tonumber(id)
	token = token and normalizeToken(token)
	if not id or not token then
		msg("usage: /obadd <spellId> <CLASS>   e.g. /obadd 524913 SUNCLERIC")
		return
	end
	local name = GetSpellInfo(id) or ("Spell " .. id)
	local duration = baseCooldownSeconds(id)
	if duration <= 0 then duration = 60 end
	local db = ensureDB()
	db.extra = db.extra or {}
	db.extra[id] = {
		id = id,
		name = name,
		duration = duration,
		class = token,
		default = defaultFor(name, duration),
	}
	-- also merge into lua preview rows if present
	if db.rows then
		local found
		for _, r in ipairs(db.rows) do
			if r.id == id then
				r.name, r.duration, r.class, r.default = name, duration, token, defaultFor(name, duration)
				found = true
				break
			end
		end
		if not found then
			db.rows[#db.rows + 1] = db.extra[id]
		end
		db.count = #db.rows
		db.lua = buildLua(db.rows)
	end
	msg(string.format("queued [%d] %s %ds %s — /reload then import", id, name, duration, token))
end

SLASH_OMNIBARGAPS1 = "/obgaps"
SlashCmdList["OMNIBARGAPS"] = function(msgText)
	msgText = strtrim(msgText or "")
	local opts = { apply = false, all = false }
	if msgText:find("%f[%a]apply%f[%A]") then
		opts.apply = true
		msgText = msgText:gsub("%f[%a]apply%f[%A]", " ")
	end
	if msgText:find("%f[%a]all%f[%A]") then
		opts.all = true
		msgText = msgText:gsub("%f[%a]all%f[%A]", " ")
	end
	msgText = strtrim(msgText)
	local minVal = msgText:match("min%s+(%d+)")
	if minVal then
		opts.minCd = tonumber(minVal)
		msgText = msgText:gsub("min%s+%d+", " ")
		msgText = strtrim(msgText)
	end
	if msgText ~= "" and not opts.all then
		local token = normalizeToken(msgText) or string.upper(msgText)
		opts.tokens = { token }
	end
	OmniBar_FindGaps(opts)
end
