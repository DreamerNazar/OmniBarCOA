-- Conquest of Azeroth cooldowns for OmniBar
-- Display names differ from client fileString tokens (e.g. Templar -> MONK).
-- Add / edit spells here. Format:
--   [spellID] = { default = true, duration = 60, class = "BARBARIAN" }, -- Name
-- Source: https://coatavern.com (recoveryTime / "X sec cooldown")

OmniBarCoA = OmniBarCoA or {}

-- Client fileString tokens in a stable options order
OmniBarCoA.classOrder = {
	"BARBARIAN",
	"WITCHDOCTOR",
	"DEMONHUNTER",
	"WITCHHUNTER",
	"STORMBRINGER",
	"FLESHWARDEN",
	"GUARDIAN",
	"MONK",
	"SONOFARUGAL",
	"RANGER",
	"PROPHET",
	"PYROMANCER",
	"CULTIST",
	"NECROMANCER",
	"SUNCLERIC",
	"TINKER",
	"REAPER",
	"WILDWALKER",
	"STARCALLER",
	"SPIRITMAGE",
	"CHRONOMANCER",
}

-- Fallback labels when LOCALIZED_CLASS_NAMES_MALE is missing a CoA class
OmniBarCoA.classNames = {
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

-- PvP-relevant cooldowns only (interrupts, CC, major defensives/offensives).
-- Verified against CoA Tavern; expand via tools/fetch_coa_cooldowns.py or manually.
OmniBarCoA.cooldowns = {
	-- BARBARIAN (Barbarian)
	[804729] = { default = true, duration = 20, class = "BARBARIAN" }, -- Ancestor's Call

	-- WITCHHUNTER (Witch Hunter)
	[501380] = { default = true, duration = 60, class = "WITCHHUNTER" }, -- Brand of the Unworthy

	-- SPIRITMAGE (Runemaster)
	[500121] = { default = true, duration = 90, class = "SPIRITMAGE" }, -- Eye of the Beholder
}
