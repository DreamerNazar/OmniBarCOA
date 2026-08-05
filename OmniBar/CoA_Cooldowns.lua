-- Conquest of Azeroth cooldowns for OmniBar
-- Display names differ from client fileString tokens (e.g. Templar -> MONK).
-- Add / edit spells here. Format:
--   [spellID] = { default = true, duration = 60, class = "BARBARIAN" }, -- Name
-- Source: in-game /obscan (C_CharacterAdvancement + GetSpellBaseCooldown)

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

-- Cooldowns with recovery >= 8s from /obscan. default=true ≈ PvP-relevant heuristic.
-- Re-scan: /obscan → /reload → tools/import_coa_scan.ps1 -SyncToAddOns
OmniBarCoA.cooldowns = {
	-- BARBARIAN
	[805780] = { default = false, duration = 15, class = "BARBARIAN" }, -- Ale of The God-King
	[801782] = { default = false, duration = 30, class = "BARBARIAN" }, -- Ancestral Combat
	[500918] = { default = false, duration = 25, class = "BARBARIAN" }, -- Ancestral Roar
	[560518] = { default = false, duration = 30, class = "BARBARIAN" }, -- Berserker Rush
	[804737] = { default = true, duration = 60, class = "BARBARIAN" }, -- Clanlord's Totem
	[500915] = { default = false, duration = 25, class = "BARBARIAN" }, -- Crush
	[806228] = { default = true, duration = 180, class = "BARBARIAN" }, -- Defiance
	[805815] = { default = false, duration = 30, class = "BARBARIAN" }, -- Frozen Tankard
	[800152] = { default = true, duration = 90, class = "BARBARIAN" }, -- Hodir's Wrath
	[802792] = { default = false, duration = 14, class = "BARBARIAN" }, -- Jawbreaker
	[805808] = { default = false, duration = 10, class = "BARBARIAN" }, -- Keg Smash
	[801759] = { default = true, duration = 180, class = "BARBARIAN" }, -- Outrage
	[805804] = { default = true, duration = 120, class = "BARBARIAN" }, -- Ramhorn Rage
	[560532] = { default = true, duration = 120, class = "BARBARIAN" }, -- Skull Smash
	[707584] = { default = true, duration = 45, class = "BARBARIAN" }, -- Spite
	[705156] = { default = false, duration = 30, class = "BARBARIAN" }, -- Splash Zone
	[800637] = { default = false, duration = 25, class = "BARBARIAN" }, -- Storm of Steel
	[804456] = { default = true, duration = 300, class = "BARBARIAN" }, -- Tavern Brawl!
	[801549] = { default = true, duration = 120, class = "BARBARIAN" }, -- Thick Skull
	[500995] = { default = true, duration = 180, class = "BARBARIAN" }, -- War Cry
	[560883] = { default = true, duration = 90, class = "BARBARIAN" }, -- Warband
	-- CHRONOMANCER
	[804436] = { default = false, duration = 15, class = "CHRONOMANCER" }, -- Aether Compression
	[520188] = { default = true, duration = 180, class = "CHRONOMANCER" }, -- Buy Time
	[801292] = { default = false, duration = 30, class = "CHRONOMANCER" }, -- Chromatic Shard
	[805847] = { default = false, duration = 20, class = "CHRONOMANCER" }, -- Clasp of Infinity
	[801271] = { default = true, duration = 90, class = "CHRONOMANCER" }, -- Continuum Restoration
	[561310] = { default = true, duration = 90, class = "CHRONOMANCER" }, -- Desynchronization
	[802790] = { default = true, duration = 120, class = "CHRONOMANCER" }, -- Dimensional Divergence
	[806727] = { default = true, duration = 60, class = "CHRONOMANCER" }, -- Displacement
	[806299] = { default = false, duration = 15, class = "CHRONOMANCER" }, -- Fabric of Time
	[804435] = { default = false, duration = 15, class = "CHRONOMANCER" }, -- Flux Emitter
	[804491] = { default = true, duration = 60, class = "CHRONOMANCER" }, -- Fortify Timeline
	[801281] = { default = true, duration = 90, class = "CHRONOMANCER" }, -- Gravity Bomb
	[570067] = { default = true, duration = 180, class = "CHRONOMANCER" }, -- Incarnation of Chaos
	[520457] = { default = true, duration = 15, class = "CHRONOMANCER" }, -- Infinite Shield
	[520855] = { default = true, duration = 120, class = "CHRONOMANCER" }, -- Mass Babify
	[806335] = { default = false, duration = 30, class = "CHRONOMANCER" }, -- Melt Reality
	[806203] = { default = false, duration = 15, class = "CHRONOMANCER" }, -- Paradox Cannon
	[806296] = { default = false, duration = 30, class = "CHRONOMANCER" }, -- Ripple
	[804438] = { default = false, duration = 15, class = "CHRONOMANCER" }, -- Singularity Core
	[707555] = { default = true, duration = 120, class = "CHRONOMANCER" }, -- Slipstream
	[806315] = { default = true, duration = 120, class = "CHRONOMANCER" }, -- Temporal Anomaly
	[806165] = { default = true, duration = 120, class = "CHRONOMANCER" }, -- Temporal Focus
	[706083] = { default = true, duration = 300, class = "CHRONOMANCER" }, -- The Vast Infinite
	[804441] = { default = true, duration = 120, class = "CHRONOMANCER" }, -- Timeguard
	[503836] = { default = true, duration = 60, class = "CHRONOMANCER" }, -- Unstable Chronoglass
	[801277] = { default = false, duration = 20, class = "CHRONOMANCER" }, -- Waves of Time
	-- CULTIST
	[804670] = { default = true, duration = 90, class = "CULTIST" }, -- Abyssal Ward
	[500712] = { default = false, duration = 30, class = "CULTIST" }, -- Ancient Curse
	[560109] = { default = true, duration = 60, class = "CULTIST" }, -- Corrupt Mind
	[804056] = { default = false, duration = 30, class = "CULTIST" }, -- Crushing Dissonance
	[520345] = { default = true, duration = 120, class = "CULTIST" }, -- Dark Veil
	[806175] = { default = false, duration = 25, class = "CULTIST" }, -- Dreadfall
	[802049] = { default = true, duration = 60, class = "CULTIST" }, -- Eldritch Eye
	[560321] = { default = true, duration = 180, class = "CULTIST" }, -- Eldritch Obelisk
	[582591] = { default = true, duration = 300, class = "CULTIST" }, -- Embrace the Void
	[500704] = { default = false, duration = 35, class = "CULTIST" }, -- Empire's Grasp
	[805115] = { default = true, duration = 90, class = "CULTIST" }, -- End Times
	[800430] = { default = true, duration = 60, class = "CULTIST" }, -- Entropic Singularity
	[800105] = { default = true, duration = 60, class = "CULTIST" }, -- Forbidden Ritual
	[560301] = { default = false, duration = 30, class = "CULTIST" }, -- Hallucination
	[704476] = { default = true, duration = 120, class = "CULTIST" }, -- Hand of Yogg-Saron
	[805114] = { default = true, duration = 180, class = "CULTIST" }, -- Mass Nightmare
	[805572] = { default = false, duration = 20, class = "CULTIST" }, -- Obliteration Beam
	[800432] = { default = true, duration = 90, class = "CULTIST" }, -- Psychic Suppression
	[806250] = { default = true, duration = 45, class = "CULTIST" }, -- Rift
	[572103] = { default = true, duration = 90, class = "CULTIST" }, -- Tentacle of N'Zoth
	[524876] = { default = true, duration = 8, class = "CULTIST" }, -- Twilight Shieldtoss
	[525065] = { default = true, duration = 120, class = "CULTIST" }, -- Twisted Seal
	[520388] = { default = true, duration = 300, class = "CULTIST" }, -- Vision of Doom
	[681104] = { default = true, duration = 180, class = "CULTIST" }, -- Voidborne
	-- DEMONHUNTER
	[801903] = { default = false, duration = 10, class = "DEMONHUNTER" }, -- Annihilan Strike
	[803904] = { default = true, duration = 60, class = "DEMONHUNTER" }, -- Annihilation
	[805239] = { default = true, duration = 120, class = "DEMONHUNTER" }, -- Burning Hatred
	[800209] = { default = true, duration = 45, class = "DEMONHUNTER" }, -- Demonic Will
	[525001] = { default = false, duration = 30, class = "DEMONHUNTER" }, -- Felbane
	[800203] = { default = false, duration = 18, class = "DEMONHUNTER" }, -- Felbreak
	[800204] = { default = true, duration = 20, class = "DEMONHUNTER" }, -- Felhoof Charge
	[555738] = { default = true, duration = 180, class = "DEMONHUNTER" }, -- Fury Unleashed
	[705129] = { default = false, duration = 30, class = "DEMONHUNTER" }, -- Hateforged Barrier
	[806109] = { default = true, duration = 300, class = "DEMONHUNTER" }, -- Illidan's Guile
	[560284] = { default = true, duration = 45, class = "DEMONHUNTER" }, -- Infernal
	[805243] = { default = true, duration = 90, class = "DEMONHUNTER" }, -- Infernal Whipcrack
	[805248] = { default = false, duration = 20, class = "DEMONHUNTER" }, -- Manaburn
	[802058] = { default = true, duration = 120, class = "DEMONHUNTER" }, -- Reckoning
	[800355] = { default = true, duration = 60, class = "DEMONHUNTER" }, -- Sargeras Embrace
	[800225] = { default = true, duration = 90, class = "DEMONHUNTER" }, -- Skull of Gul'dan
	[804823] = { default = true, duration = 180, class = "DEMONHUNTER" }, -- Tyrannical Resolve
	[805240] = { default = false, duration = 10, class = "DEMONHUNTER" }, -- Tyrant's Gaze
	[805235] = { default = true, duration = 60, class = "DEMONHUNTER" }, -- Whispers of the Pit
	-- FLESHWARDEN
	[805679] = { default = true, duration = 120, class = "FLESHWARDEN" }, -- Black Shield
	[524920] = { default = true, duration = 60, class = "FLESHWARDEN" }, -- Burning Blade
	[520295] = { default = true, duration = 60, class = "FLESHWARDEN" }, -- Burning Rage
	[805074] = { default = true, duration = 45, class = "FLESHWARDEN" }, -- Call: Hellfire Abyssal
	[804883] = { default = false, duration = 10, class = "FLESHWARDEN" }, -- Call: Hellfire Imp
	[803185] = { default = true, duration = 90, class = "FLESHWARDEN" }, -- Chains of Malice
	[706756] = { default = true, duration = 90, class = "FLESHWARDEN" }, -- Chains of Xoroth
	[800081] = { default = false, duration = 20, class = "FLESHWARDEN" }, -- Chainwhip
	[804169] = { default = true, duration = 90, class = "FLESHWARDEN" }, -- Curse of Xoroth
	[524913] = { default = true, duration = 120, class = "FLESHWARDEN" }, -- Decimation
	[805669] = { default = true, duration = 60, class = "FLESHWARDEN" }, -- Demon Heart
	[805678] = { default = true, duration = 180, class = "FLESHWARDEN" }, -- Demonic Grit
	[807898] = { default = true, duration = 180, class = "FLESHWARDEN" }, -- Demonic Grit
	[802602] = { default = true, duration = 60, class = "FLESHWARDEN" }, -- Doom
	[805696] = { default = true, duration = 120, class = "FLESHWARDEN" }, -- Hellfire Form
	[802342] = { default = false, duration = 30, class = "FLESHWARDEN" }, -- Hellstorm
	[524897] = { default = false, duration = 40, class = "FLESHWARDEN" }, -- Implosion
	[520294] = { default = true, duration = 120, class = "FLESHWARDEN" }, -- Juggernaut
	[804879] = { default = true, duration = 180, class = "FLESHWARDEN" }, -- Legion's Presence
	[805677] = { default = true, duration = 60, class = "FLESHWARDEN" }, -- Sacrificial Circle
	[801061] = { default = true, duration = 60, class = "FLESHWARDEN" }, -- Xorothian Sigil
	-- GUARDIAN
	[500261] = { default = false, duration = 20, class = "GUARDIAN" }, -- Banner of Conquest
	[500259] = { default = false, duration = 20, class = "GUARDIAN" }, -- Banner of Swiftness
	[802283] = { default = true, duration = 300, class = "GUARDIAN" }, -- Bastion
	[803683] = { default = true, duration = 180, class = "GUARDIAN" }, -- Battle Drums
	[800313] = { default = true, duration = 180, class = "GUARDIAN" }, -- Brace
	[802286] = { default = false, duration = 15, class = "GUARDIAN" }, -- Centurion Strike
	[520835] = { default = true, duration = 300, class = "GUARDIAN" }, -- Champion's Presence
	[802188] = { default = true, duration = 180, class = "GUARDIAN" }, -- Counter Stance
	[500258] = { default = false, duration = 30, class = "GUARDIAN" }, -- Final Verdict
	[300983] = { default = true, duration = 60, class = "GUARDIAN" }, -- Glorious Arena
	[802870] = { default = true, duration = 45, class = "GUARDIAN" }, -- Grand Entrance
	[704418] = { default = false, duration = 40, class = "GUARDIAN" }, -- Hammer of the Law
	[572821] = { default = false, duration = 25, class = "GUARDIAN" }, -- Harrowing Melody
	[803129] = { default = false, duration = 10, class = "GUARDIAN" }, -- Heavy Blow
	[801774] = { default = true, duration = 120, class = "GUARDIAN" }, -- Hero's March
	[803830] = { default = true, duration = 120, class = "GUARDIAN" }, -- Hold the Line
	[705352] = { default = true, duration = 60, class = "GUARDIAN" }, -- Inspiring Presence
	[504151] = { default = true, duration = 120, class = "GUARDIAN" }, -- Knight's Calling
	[803963] = { default = true, duration = 120, class = "GUARDIAN" }, -- Liberation
	[802304] = { default = false, duration = 15, class = "GUARDIAN" }, -- Net Throw
	[801219] = { default = true, duration = 90, class = "GUARDIAN" }, -- Press the Attack
	[300927] = { default = true, duration = 20, class = "GUARDIAN" }, -- Reflective Shield
	[802198] = { default = false, duration = 30, class = "GUARDIAN" }, -- Shrug It Off
	[803956] = { default = true, duration = 90, class = "GUARDIAN" }, -- Song of Battle
	[704420] = { default = true, duration = 300, class = "GUARDIAN" }, -- Voice of an Angel
	-- MONK
	[800424] = { default = true, duration = 150, class = "MONK" }, -- Absolution
	[805417] = { default = true, duration = 90, class = "MONK" }, -- Barrier of Light
	[300513] = { default = true, duration = 60, class = "MONK" }, -- Crusader's Brand
	[527023] = { default = true, duration = 180, class = "MONK" }, -- Divine Charge
	[806153] = { default = true, duration = 120, class = "MONK" }, -- Divine Force
	[705300] = { default = true, duration = 60, class = "MONK" }, -- Eternal Blessing
	[500694] = { default = true, duration = 120, class = "MONK" }, -- Force of Golganneth
	[801481] = { default = true, duration = 120, class = "MONK" }, -- Glory
	[560116] = { default = true, duration = 120, class = "MONK" }, -- Interdict
	[805423] = { default = true, duration = 180, class = "MONK" }, -- Libram of Fervor
	[801461] = { default = true, duration = 180, class = "MONK" }, -- Libram of Tenacity
	[801466] = { default = true, duration = 180, class = "MONK" }, -- Libram of Zeal
	[524739] = { default = false, duration = 30, class = "MONK" }, -- Norgannon's Wrath
	[680953] = { default = true, duration = 180, class = "MONK" }, -- Profound Enlightenment
	[501562] = { default = false, duration = 20, class = "MONK" }, -- Righteous Upheaval
	[801465] = { default = true, duration = 90, class = "MONK" }, -- Silverhand Incantation
	[500678] = { default = true, duration = 180, class = "MONK" }, -- Testament of Fortitude
	[1397742] = { default = true, duration = 180, class = "MONK" }, -- Testament of Hope
	[300514] = { default = true, duration = 180, class = "MONK" }, -- Testament of Strength
	[801455] = { default = true, duration = 60, class = "MONK" }, -- Testament of Will
	[805422] = { default = true, duration = 300, class = "MONK" }, -- Tome of Light
	-- NECROMANCER
	[531130] = { default = false, duration = 15, class = "NECROMANCER" }, -- Animate: Bone Construct
	[805032] = { default = true, duration = 60, class = "NECROMANCER" }, -- Animate: Bone Wraith
	[805428] = { default = true, duration = 120, class = "NECROMANCER" }, -- Animate: Frost Wyrm
	[805048] = { default = true, duration = 120, class = "NECROMANCER" }, -- Animate: Plaguefather
	[805040] = { default = false, duration = 30, class = "NECROMANCER" }, -- Animate: Skeletal Archer
	[805044] = { default = true, duration = 60, class = "NECROMANCER" }, -- Animate: Tomb King
	[561138] = { default = true, duration = 300, class = "NECROMANCER" }, -- Army of the North
	[802121] = { default = true, duration = 120, class = "NECROMANCER" }, -- Bone Tithe
	[504489] = { default = false, duration = 20, class = "NECROMANCER" }, -- Command: Bonefreeze
	[504316] = { default = false, duration = 30, class = "NECROMANCER" }, -- Command: Hook
	[807796] = { default = true, duration = 90, class = "NECROMANCER" }, -- Death's Due
	[804371] = { default = true, duration = 120, class = "NECROMANCER" }, -- Foul Invocation
	[805369] = { default = false, duration = 12, class = "NECROMANCER" }, -- Glacial Tap
	[801739] = { default = false, duration = 30, class = "NECROMANCER" }, -- Heartchill
	[801760] = { default = false, duration = 10, class = "NECROMANCER" }, -- Ice Barrage
	[802132] = { default = false, duration = 30, class = "NECROMANCER" }, -- Lichplague
	[707007] = { default = false, duration = 10, class = "NECROMANCER" }, -- March of the Dead
	[803741] = { default = false, duration = 30, class = "NECROMANCER" }, -- Mass Grave
	[500342] = { default = true, duration = 180, class = "NECROMANCER" }, -- Mutation
	[500933] = { default = true, duration = 120, class = "NECROMANCER" }, -- Phylactery
	[801938] = { default = true, duration = 60, class = "NECROMANCER" }, -- Virulency
	-- PROPHET
	[803196] = { default = false, duration = 20, class = "PROPHET" }, -- Barbed Stinger
	[806154] = { default = true, duration = 300, class = "PROPHET" }, -- Burrow
	[800895] = { default = true, duration = 60, class = "PROPHET" }, -- Catalyst
	[804962] = { default = true, duration = 90, class = "PROPHET" }, -- Celerity
	[808082] = { default = true, duration = 90, class = "PROPHET" }, -- Chrysalis
	[503851] = { default = true, duration = 60, class = "PROPHET" }, -- Contagion
	[800910] = { default = true, duration = 45, class = "PROPHET" }, -- Decay
	[805094] = { default = false, duration = 10, class = "PROPHET" }, -- Expulsion
	[805884] = { default = true, duration = 300, class = "PROPHET" }, -- Extraction
	[504344] = { default = true, duration = 90, class = "PROPHET" }, -- Fungal Assailant
	[800902] = { default = false, duration = 10, class = "PROPHET" }, -- Green Salve
	[804968] = { default = true, duration = 120, class = "PROPHET" }, -- Hive Instinct
	[560248] = { default = false, duration = 40, class = "PROPHET" }, -- Impale
	[804963] = { default = true, duration = 90, class = "PROPHET" }, -- Lifeblood
	[560247] = { default = false, duration = 30, class = "PROPHET" }, -- Locust Swarm
	[805102] = { default = true, duration = 45, class = "PROPHET" }, -- Molt
	[706021] = { default = true, duration = 180, class = "PROPHET" }, -- Mycelial Replenishment
	[804986] = { default = false, duration = 15, class = "PROPHET" }, -- Mycosis
	[804964] = { default = true, duration = 180, class = "PROPHET" }, -- Noxious Empowerment
	[704235] = { default = true, duration = 60, class = "PROPHET" }, -- Pinch
	[803197] = { default = true, duration = 60, class = "PROPHET" }, -- Regrow Exoskeleton
	[504867] = { default = true, duration = 120, class = "PROPHET" }, -- Sepsis Bloom
	[800914] = { default = true, duration = 90, class = "PROPHET" }, -- Serpent Lord's Amulet
	[503923] = { default = true, duration = 90, class = "PROPHET" }, -- Serpent Lord's Ring
	[504352] = { default = true, duration = 180, class = "PROPHET" }, -- Shadra's Aid
	[804978] = { default = true, duration = 180, class = "PROPHET" }, -- Shadra's Lair
	[800887] = { default = false, duration = 16, class = "PROPHET" }, -- Spindlebind
	[680767] = { default = true, duration = 60, class = "PROPHET" }, -- Toxic Communion
	[504347] = { default = true, duration = 90, class = "PROPHET" }, -- Toxic Stride
	-- PYROMANCER
	[802168] = { default = true, duration = 60, class = "PYROMANCER" }, -- Aspect's Blessing
	[511109] = { default = true, duration = 90, class = "PYROMANCER" }, -- Breath of Neltharion
	[520218] = { default = true, duration = 90, class = "PYROMANCER" }, -- Cataclysm
	[800807] = { default = true, duration = 120, class = "PYROMANCER" }, -- Circle of Fire
	[520402] = { default = true, duration = 90, class = "PYROMANCER" }, -- Death From Above
	[802107] = { default = false, duration = 15, class = "PYROMANCER" }, -- Destroyer's Maw
	[806611] = { default = true, duration = 30, class = "PYROMANCER" }, -- Dragon Leap
	[680378] = { default = true, duration = 120, class = "PYROMANCER" }, -- Emberheart
	[802120] = { default = true, duration = 120, class = "PYROMANCER" }, -- Essence of Malygos
	[704823] = { default = true, duration = 60, class = "PYROMANCER" }, -- Fired Up!
	[801905] = { default = false, duration = 8, class = "PYROMANCER" }, -- Firefall
	[802791] = { default = true, duration = 60, class = "PYROMANCER" }, -- Firestorm
	[806148] = { default = true, duration = 90, class = "PYROMANCER" }, -- Gaze of Ysera
	[802167] = { default = true, duration = 300, class = "PYROMANCER" }, -- Grace of Alexstrasza
	[680369] = { default = true, duration = 60, class = "PYROMANCER" }, -- Ignis Ultimatus
	[504380] = { default = false, duration = 20, class = "PYROMANCER" }, -- Inferno Barrier
	[800816] = { default = true, duration = 120, class = "PYROMANCER" }, -- Kael's Command
	[500135] = { default = false, duration = 30, class = "PYROMANCER" }, -- Meteor
	[520488] = { default = true, duration = 60, class = "PYROMANCER" }, -- Neltharion's Resolve
	[805496] = { default = false, duration = 20, class = "PYROMANCER" }, -- Pillar of Flame
	[520019] = { default = true, duration = 60, class = "PYROMANCER" }, -- Pyroclasm
	[704278] = { default = true, duration = 60, class = "PYROMANCER" }, -- Roaring Pyre
	[804230] = { default = true, duration = 60, class = "PYROMANCER" }, -- Sunstrider Array
	[805477] = { default = true, duration = 120, class = "PYROMANCER" }, -- Volcanic Shell
	-- RANGER
	[520578] = { default = true, duration = 90, class = "RANGER" }, -- Adrenaline Rush
	[800685] = { default = false, duration = 20, class = "RANGER" }, -- Backstep
	[800084] = { default = true, duration = 120, class = "RANGER" }, -- Briar Veil
	[570014] = { default = false, duration = 25, class = "RANGER" }, -- Brutal Shot
	[524600] = { default = true, duration = 60, class = "RANGER" }, -- Command Aura
	[804725] = { default = false, duration = 10, class = "RANGER" }, -- Crippling Shot
	[800359] = { default = true, duration = 45, class = "RANGER" }, -- Cutthroat
	[804715] = { default = true, duration = 90, class = "RANGER" }, -- Falcon's Call
	[520628] = { default = true, duration = 90, class = "RANGER" }, -- Freedom
	[520492] = { default = true, duration = 300, class = "RANGER" }, -- Frenzy
	[520753] = { default = true, duration = 180, class = "RANGER" }, -- Guise
	[800360] = { default = false, duration = 25, class = "RANGER" }, -- Hookshot
	[806360] = { default = true, duration = 60, class = "RANGER" }, -- Horn of Alacrity
	[800086] = { default = true, duration = 60, class = "RANGER" }, -- Horn of War
	[524870] = { default = false, duration = 15, class = "RANGER" }, -- Incendiary Shot
	[801435] = { default = false, duration = 18, class = "RANGER" }, -- Knockout
	[520585] = { default = true, duration = 120, class = "RANGER" }, -- Natural Disguise
	[500071] = { default = true, duration = 120, class = "RANGER" }, -- Neurotoxin Arrow
	[801951] = { default = true, duration = 120, class = "RANGER" }, -- Onslaught
	[557325] = { default = true, duration = 60, class = "RANGER" }, -- Outmaneuver
	[800093] = { default = false, duration = 25, class = "RANGER" }, -- Skewer
	[804027] = { default = false, duration = 20, class = "RANGER" }, -- Snapseed
	[803115] = { default = true, duration = 45, class = "RANGER" }, -- Snatch
	[802839] = { default = true, duration = 60, class = "RANGER" }, -- Survival Potion
	[560805] = { default = true, duration = 120, class = "RANGER" }, -- Thalassian Brand
	[500617] = { default = false, duration = 12, class = "RANGER" }, -- Throatpunch
	[803104] = { default = false, duration = 20, class = "RANGER" }, -- Viper's Bite
	[806342] = { default = true, duration = 60, class = "RANGER" }, -- Whipvine Arrow
	[570015] = { default = true, duration = 180, class = "RANGER" }, -- Woodland Adept
	[806368] = { default = false, duration = 15, class = "RANGER" }, -- Woodland Arrow
	-- REAPER
	[680337] = { default = true, duration = 60, class = "REAPER" }, -- Bolstered Form
	[800922] = { default = true, duration = 180, class = "REAPER" }, -- Endbringer
	[806146] = { default = true, duration = 90, class = "REAPER" }, -- Ghastly Screech
	[803995] = { default = true, duration = 180, class = "REAPER" }, -- Harvest Time
	[705413] = { default = true, duration = 120, class = "REAPER" }, -- Harvesting Grounds
	[805718] = { default = true, duration = 120, class = "REAPER" }, -- Jailer's Bargain
	[800845] = { default = true, duration = 180, class = "REAPER" }, -- Limbo
	[803030] = { default = true, duration = 90, class = "REAPER" }, -- Masochistic Rage
	[561102] = { default = true, duration = 480, class = "REAPER" }, -- Sepulchral Renewal
	[573038] = { default = true, duration = 180, class = "REAPER" }, -- Shade
	[806125] = { default = false, duration = 20, class = "REAPER" }, -- Siphon Essence
	[807397] = { default = false, duration = 30, class = "REAPER" }, -- Soul Tap
	[500484] = { default = true, duration = 45, class = "REAPER" }, -- Spectral Scythe
	[805716] = { default = true, duration = 180, class = "REAPER" }, -- Spectral Warden
	[500483] = { default = false, duration = 20, class = "REAPER" }, -- Tormented Souls
	[573071] = { default = false, duration = 15, class = "REAPER" }, -- Withering Touch
	[805258] = { default = false, duration = 30, class = "REAPER" }, -- Wraithblade
	-- SONOFARUGAL
	[806099] = { default = false, duration = 24, class = "SONOFARUGAL" }, -- Aneurysm
	[806212] = { default = false, duration = 20, class = "SONOFARUGAL" }, -- Aortic Assault
	[681077] = { default = true, duration = 90, class = "SONOFARUGAL" }, -- Arterial Bind
	[680680] = { default = true, duration = 90, class = "SONOFARUGAL" }, -- Atherann's Anguish
	[504627] = { default = true, duration = 120, class = "SONOFARUGAL" }, -- Blood Bond
	[800780] = { default = true, duration = 180, class = "SONOFARUGAL" }, -- Blood Craving
	[800782] = { default = true, duration = 150, class = "SONOFARUGAL" }, -- Blood Howl
	[801955] = { default = true, duration = 120, class = "SONOFARUGAL" }, -- Blood Pact
	[504263] = { default = false, duration = 30, class = "SONOFARUGAL" }, -- Blood Veil
	[553267] = { default = true, duration = 180, class = "SONOFARUGAL" }, -- Bloodsurge
	[680828] = { default = true, duration = 60, class = "SONOFARUGAL" }, -- Darkfallen Lament
	[681190] = { default = true, duration = 60, class = "SONOFARUGAL" }, -- Endure the Curse
	[801962] = { default = true, duration = 180, class = "SONOFARUGAL" }, -- Eternal Resolve
	[524865] = { default = true, duration = 180, class = "SONOFARUGAL" }, -- Final Embrace
	[801952] = { default = true, duration = 300, class = "SONOFARUGAL" }, -- Fleshcraft
	[804805] = { default = true, duration = 90, class = "SONOFARUGAL" }, -- Gorge
	[803681] = { default = true, duration = 90, class = "SONOFARUGAL" }, -- Hemal Excision
	[572855] = { default = false, duration = 10, class = "SONOFARUGAL" }, -- Hemoburst
	[524907] = { default = true, duration = 180, class = "SONOFARUGAL" }, -- Hemoglobe
	[681304] = { default = true, duration = 120, class = "SONOFARUGAL" }, -- Hemostasis
	[681403] = { default = false, duration = 30, class = "SONOFARUGAL" }, -- Infuse
	[806310] = { default = true, duration = 120, class = "SONOFARUGAL" }, -- Liquify
	[800776] = { default = false, duration = 30, class = "SONOFARUGAL" }, -- Malediction
	[804811] = { default = false, duration = 40, class = "SONOFARUGAL" }, -- Monstrous Howl
	[500124] = { default = false, duration = 8, class = "SONOFARUGAL" }, -- Night Hunter's Howl
	[680679] = { default = true, duration = 60, class = "SONOFARUGAL" }, -- Purify Blood
	[800490] = { default = false, duration = 15, class = "SONOFARUGAL" }, -- Reave
	[520493] = { default = true, duration = 300, class = "SONOFARUGAL" }, -- Red Thirst
	[800785] = { default = true, duration = 120, class = "SONOFARUGAL" }, -- Sacrificial Rite
	[806177] = { default = true, duration = 60, class = "SONOFARUGAL" }, -- Shadow Howl
	[705734] = { default = true, duration = 180, class = "SONOFARUGAL" }, -- Transfusion
	[804726] = { default = false, duration = 8, class = "SONOFARUGAL" }, -- Vampiric Fang
	[504275] = { default = true, duration = 60, class = "SONOFARUGAL" }, -- Vampyr's Kiss
	[504260] = { default = false, duration = 15, class = "SONOFARUGAL" }, -- Veinburst
	[804207] = { default = true, duration = 120, class = "SONOFARUGAL" }, -- Wicked Howl
	-- SPIRITMAGE
	[801086] = { default = true, duration = 90, class = "SPIRITMAGE" }, -- Convergence
	[500270] = { default = true, duration = 120, class = "SPIRITMAGE" }, -- Echo Rune
	[500121] = { default = true, duration = 180, class = "SPIRITMAGE" }, -- Eye of the Beholder
	[712326] = { default = false, duration = 18, class = "SPIRITMAGE" }, -- Fist of the Ancients
	[805796] = { default = true, duration = 45, class = "SPIRITMAGE" }, -- Fists of Power
	[500118] = { default = false, duration = 15, class = "SPIRITMAGE" }, -- Frigid Blast
	[500501] = { default = true, duration = 180, class = "SPIRITMAGE" }, -- Genesis
	[807842] = { default = false, duration = 20, class = "SPIRITMAGE" }, -- Glacial Rune
	[520099] = { default = true, duration = 45, class = "SPIRITMAGE" }, -- Glyphic Overload
	[520229] = { default = true, duration = 60, class = "SPIRITMAGE" }, -- Granite Resolve
	[500464] = { default = true, duration = 120, class = "SPIRITMAGE" }, -- Guarding Rune
	[801104] = { default = false, duration = 10, class = "SPIRITMAGE" }, -- Hoarfrost
	[645435] = { default = false, duration = 30, class = "SPIRITMAGE" }, -- Hurricane
	[801096] = { default = true, duration = 90, class = "SPIRITMAGE" }, -- Ley Power
	[524952] = { default = true, duration = 45, class = "SPIRITMAGE" }, -- Manuscription
	[804060] = { default = true, duration = 60, class = "SPIRITMAGE" }, -- Permafrost Rune
	[500671] = { default = true, duration = 120, class = "SPIRITMAGE" }, -- Phase Out
	[500296] = { default = true, duration = 300, class = "SPIRITMAGE" }, -- Power Engraving
	[806543] = { default = true, duration = 90, class = "SPIRITMAGE" }, -- Primordial Fury
	[300578] = { default = false, duration = 20, class = "SPIRITMAGE" }, -- Primordial Pulse
	[712299] = { default = true, duration = 12, class = "SPIRITMAGE" }, -- Runic Brand
	[560036] = { default = true, duration = 180, class = "SPIRITMAGE" }, -- Runic Tempest
	[802631] = { default = true, duration = 90, class = "SPIRITMAGE" }, -- Silencing Rune
	[801103] = { default = true, duration = 120, class = "SPIRITMAGE" }, -- Speed Rune
	[804550] = { default = false, duration = 15, class = "SPIRITMAGE" }, -- Thaumaturgy
	[705575] = { default = true, duration = 60, class = "SPIRITMAGE" }, -- Turbulence
	[804232] = { default = true, duration = 120, class = "SPIRITMAGE" }, -- Warding Rune
	[500287] = { default = false, duration = 30, class = "SPIRITMAGE" }, -- Warpdagger
	[712325] = { default = true, duration = 45, class = "SPIRITMAGE" }, -- Zenith
	-- STARCALLER
	[563725] = { default = true, duration = 60, class = "STARCALLER" }, -- Arrow of the Goddess
	[520481] = { default = true, duration = 60, class = "STARCALLER" }, -- Arrows In The Night
	[801123] = { default = false, duration = 10, class = "STARCALLER" }, -- Aspect of the Cosmos
	[802203] = { default = false, duration = 10, class = "STARCALLER" }, -- Aspect of the Goddess
	[806155] = { default = false, duration = 30, class = "STARCALLER" }, -- Astral Aegis
	[805563] = { default = false, duration = 20, class = "STARCALLER" }, -- Astral Blade
	[801155] = { default = true, duration = 60, class = "STARCALLER" }, -- Astral Reconstitution
	[680822] = { default = true, duration = 90, class = "STARCALLER" }, -- Avatar of Vengeance
	[804381] = { default = false, duration = 35, class = "STARCALLER" }, -- Blanket of Stars
	[680705] = { default = false, duration = 40, class = "STARCALLER" }, -- Bonds of Justice
	[801231] = { default = true, duration = 60, class = "STARCALLER" }, -- Celestial Form
	[680755] = { default = true, duration = 180, class = "STARCALLER" }, -- Chosen of the Moon
	[801134] = { default = true, duration = 180, class = "STARCALLER" }, -- Cosmic Shift
	[801975] = { default = true, duration = 120, class = "STARCALLER" }, -- Drawstring of Elune
	[680774] = { default = true, duration = 180, class = "STARCALLER" }, -- Elune's Presence
	[680703] = { default = false, duration = 15, class = "STARCALLER" }, -- Fan of Knives
	[807741] = { default = true, duration = 120, class = "STARCALLER" }, -- Halt
	[704777] = { default = false, duration = 30, class = "STARCALLER" }, -- Infused Aegis
	[575030] = { default = false, duration = 10, class = "STARCALLER" }, -- Moonflow
	[805433] = { default = true, duration = 180, class = "STARCALLER" }, -- Moonlit Bulwark
	[805546] = { default = true, duration = 60, class = "STARCALLER" }, -- Moonlit Slumber
	[804739] = { default = true, duration = 120, class = "STARCALLER" }, -- Moonwell
	[801987] = { default = false, duration = 30, class = "STARCALLER" }, -- Prayer of Elune
	[570231] = { default = false, duration = 40, class = "STARCALLER" }, -- Reverse Magic
	[800506] = { default = false, duration = 15, class = "STARCALLER" }, -- Sentinel Glaive
	[805439] = { default = true, duration = 120, class = "STARCALLER" }, -- Shadowsong's Mandate
	[800505] = { default = true, duration = 60, class = "STARCALLER" }, -- Shooting Star
	[801996] = { default = false, duration = 20, class = "STARCALLER" }, -- Starburst
	[800497] = { default = false, duration = 12, class = "STARCALLER" }, -- Starcall
	[801135] = { default = true, duration = 90, class = "STARCALLER" }, -- Starshatter
	[805550] = { default = false, duration = 20, class = "STARCALLER" }, -- Starsweep
	[572784] = { default = true, duration = 90, class = "STARCALLER" }, -- Stellar Convergence
	[804652] = { default = true, duration = 180, class = "STARCALLER" }, -- Vial of Moonwell Water
	[805508] = { default = false, duration = 20, class = "STARCALLER" }, -- Warden's Blade
	-- STORMBRINGER
	[801847] = { default = false, duration = 20, class = "STORMBRINGER" }, -- Arm of Thorim
	[500041] = { default = true, duration = 90, class = "STORMBRINGER" }, -- Body of Lightning
	[804826] = { default = true, duration = 60, class = "STORMBRINGER" }, -- Charge
	[801838] = { default = false, duration = 35, class = "STORMBRINGER" }, -- Cloudburst
	[806407] = { default = true, duration = 60, class = "STORMBRINGER" }, -- Drown
	[705672] = { default = true, duration = 90, class = "STORMBRINGER" }, -- Exhale
	[806307] = { default = false, duration = 30, class = "STORMBRINGER" }, -- Eye of the Storm
	[707543] = { default = false, duration = 8, class = "STORMBRINGER" }, -- Flurry
	[806100] = { default = true, duration = 90, class = "STORMBRINGER" }, -- Fog
	[705661] = { default = true, duration = 120, class = "STORMBRINGER" }, -- Invigorating Winds
	[500039] = { default = false, duration = 30, class = "STORMBRINGER" }, -- Kiss of the Clouds
	[520087] = { default = true, duration = 60, class = "STORMBRINGER" }, -- Lexicon of Servitude
	[560030] = { default = true, duration = 180, class = "STORMBRINGER" }, -- Lightning Cage
	[504846] = { default = false, duration = 30, class = "STORMBRINGER" }, -- Mystic Thunder
	[704212] = { default = true, duration = 300, class = "STORMBRINGER" }, -- Nimbus
	[804830] = { default = true, duration = 90, class = "STORMBRINGER" }, -- Skyfall
	[681110] = { default = true, duration = 120, class = "STORMBRINGER" }, -- Storm Ascendance
	[804833] = { default = true, duration = 30, class = "STORMBRINGER" }, -- Stormcloak
	[801859] = { default = true, duration = 60, class = "STORMBRINGER" }, -- Stormcloud
	[532751] = { default = true, duration = 90, class = "STORMBRINGER" }, -- Stormfury
	[520083] = { default = true, duration = 60, class = "STORMBRINGER" }, -- Surge of Might
	[560567] = { default = true, duration = 300, class = "STORMBRINGER" }, -- Tempest's Call
	[804591] = { default = true, duration = 180, class = "STORMBRINGER" }, -- Thunder King
	[800098] = { default = true, duration = 300, class = "STORMBRINGER" }, -- Thunder Ward
	[706625] = { default = true, duration = 120, class = "STORMBRINGER" }, -- Unshackle
	[500042] = { default = true, duration = 90, class = "STORMBRINGER" }, -- Windsurf
	-- SUNCLERIC
	[804247] = { default = false, duration = 15, class = "SUNCLERIC" }, -- Bless
	[804249] = { default = false, duration = 15, class = "SUNCLERIC" }, -- Blessing of Absolution
	[804253] = { default = true, duration = 300, class = "SUNCLERIC" }, -- Blessing of Purity
	[804254] = { default = true, duration = 90, class = "SUNCLERIC" }, -- Blessing of Retribution
	[804250] = { default = true, duration = 180, class = "SUNCLERIC" }, -- Blessing of Triumph
	[804057] = { default = true, duration = 90, class = "SUNCLERIC" }, -- Calm
	[800612] = { default = true, duration = 120, class = "SUNCLERIC" }, -- Champion of the Sun
	[520647] = { default = true, duration = 180, class = "SUNCLERIC" }, -- Circle of Valor
	[500147] = { default = false, duration = 10, class = "SUNCLERIC" }, -- Daybreak
	[680624] = { default = true, duration = 60, class = "SUNCLERIC" }, -- Divine Retribution
	[805583] = { default = true, duration = 120, class = "SUNCLERIC" }, -- Glare
	[800626] = { default = false, duration = 8, class = "SUNCLERIC" }, -- Glorious Execution
	[804751] = { default = false, duration = 20, class = "SUNCLERIC" }, -- Hammer of Kings
	[805301] = { default = false, duration = 10, class = "SUNCLERIC" }, -- Holy Form
	[500154] = { default = false, duration = 25, class = "SUNCLERIC" }, -- Horusath Blast
	[520359] = { default = false, duration = 8, class = "SUNCLERIC" }, -- Justice
	[800600] = { default = true, duration = 480, class = "SUNCLERIC" }, -- New Day
	[680630] = { default = true, duration = 60, class = "SUNCLERIC" }, -- Pendant of the Sun
	[800054] = { default = true, duration = 120, class = "SUNCLERIC" }, -- Radiance
	[806477] = { default = false, duration = 20, class = "SUNCLERIC" }, -- Rapture
	[680646] = { default = true, duration = 300, class = "SUNCLERIC" }, -- Scroll of Hope
	[301266] = { default = false, duration = 30, class = "SUNCLERIC" }, -- Solar Concord
	[806123] = { default = true, duration = 90, class = "SUNCLERIC" }, -- Solar Invigoration
	[800764] = { default = false, duration = 30, class = "SUNCLERIC" }, -- Solar Invocation: Conquest
	[806159] = { default = false, duration = 30, class = "SUNCLERIC" }, -- Solar Invocation: Resplendence
	[503651] = { default = false, duration = 30, class = "SUNCLERIC" }, -- Solar Invocation: Revelation
	[680621] = { default = false, duration = 20, class = "SUNCLERIC" }, -- Solar Nova
	[806479] = { default = true, duration = 90, class = "SUNCLERIC" }, -- Solar Prayer
	[572752] = { default = false, duration = 30, class = "SUNCLERIC" }, -- Sun Down
	[802161] = { default = true, duration = 90, class = "SUNCLERIC" }, -- Sun Gate
	[680700] = { default = false, duration = 24, class = "SUNCLERIC" }, -- Sun Stride
	[805629] = { default = true, duration = 45, class = "SUNCLERIC" }, -- Sunslam
	[760379] = { default = true, duration = 120, class = "SUNCLERIC" }, -- Sunstorm
	[560123] = { default = true, duration = 180, class = "SUNCLERIC" }, -- Sunwell
	[520024] = { default = true, duration = 180, class = "SUNCLERIC" }, -- Valkyr's Calling
	-- TINKER
	[801744] = { default = true, duration = 60, class = "TINKER" }, -- Air Strike
	[520445] = { default = true, duration = 180, class = "TINKER" }, -- Auto Resuscitation Device
	[801005] = { default = false, duration = 8, class = "TINKER" }, -- Bomb Toss
	[805308] = { default = true, duration = 120, class = "TINKER" }, -- Build: Battery Recharge Station
	[804673] = { default = true, duration = 45, class = "TINKER" }, -- Build: Destructo-Bot
	[807723] = { default = true, duration = 90, class = "TINKER" }, -- Build: Noise Box
	[707257] = { default = true, duration = 120, class = "TINKER" }, -- Build: Oil-Spill Pylon
	[706904] = { default = true, duration = 90, class = "TINKER" }, -- Build: Repulsion Unit
	[500535] = { default = false, duration = 18, class = "TINKER" }, -- Build: Spider Bomb
	[802052] = { default = true, duration = 60, class = "TINKER" }, -- Build: Spider Bomb Factory
	[805305] = { default = true, duration = 90, class = "TINKER" }, -- Combat Symbiosis
	[500236] = { default = true, duration = 120, class = "TINKER" }, -- Deathball
	[500249] = { default = false, duration = 30, class = "TINKER" }, -- Hyperblast Barrage
	[806224] = { default = true, duration = 300, class = "TINKER" }, -- Kinetic Shield
	[707104] = { default = true, duration = 120, class = "TINKER" }, -- Macro-Gravity Zone
	[801389] = { default = false, duration = 10, class = "TINKER" }, -- Mechsuit: Activate Jets
	[801387] = { default = false, duration = 10, class = "TINKER" }, -- Mechsuit: Combustion
	[805372] = { default = false, duration = 10, class = "TINKER" }, -- Mechsuit: Laser Beam
	[800347] = { default = true, duration = 60, class = "TINKER" }, -- Med Pack
	[560744] = { default = true, duration = 180, class = "TINKER" }, -- My Greatest Invention!
	[806757] = { default = true, duration = 120, class = "TINKER" }, -- Overclocked Machine
	[801827] = { default = true, duration = 180, class = "TINKER" }, -- Rockadier
	[525039] = { default = true, duration = 90, class = "TINKER" }, -- Scrapper
	[800349] = { default = true, duration = 120, class = "TINKER" }, -- Upgrade!
	[680196] = { default = false, duration = 15, class = "TINKER" }, -- Zap!
	-- WILDWALKER
	[805105] = { default = true, duration = 150, class = "WILDWALKER" }, -- Ancient of Lore
	[504222] = { default = true, duration = 150, class = "WILDWALKER" }, -- Ancient of War
	[800094] = { default = true, duration = 300, class = "WILDWALKER" }, -- Bearskin
	[500692] = { default = true, duration = 180, class = "WILDWALKER" }, -- Boulder Dash
	[806415] = { default = true, duration = 120, class = "WILDWALKER" }, -- Bramblepatch
	[806552] = { default = true, duration = 60, class = "WILDWALKER" }, -- Bring Me Their Bones
	[500615] = { default = false, duration = 24, class = "WILDWALKER" }, -- Cave In
	[805867] = { default = true, duration = 180, class = "WILDWALKER" }, -- Dreamslip
	[806143] = { default = true, duration = 300, class = "WILDWALKER" }, -- Earth's Embrace
	[680421] = { default = true, duration = 180, class = "WILDWALKER" }, -- Earthen Avatar
	[805107] = { default = true, duration = 60, class = "WILDWALKER" }, -- Earthmother's Binding
	[802335] = { default = false, duration = 30, class = "WILDWALKER" }, -- Eruption
	[805442] = { default = false, duration = 10, class = "WILDWALKER" }, -- Flourishing Growth
	[800133] = { default = true, duration = 60, class = "WILDWALKER" }, -- Frenzied Roar
	[805335] = { default = true, duration = 120, class = "WILDWALKER" }, -- Golem Form
	[503721] = { default = true, duration = 60, class = "WILDWALKER" }, -- Grove Guardian
	[520466] = { default = true, duration = 60, class = "WILDWALKER" }, -- Judgement of The Three Hammers
	[802793] = { default = true, duration = 90, class = "WILDWALKER" }, -- Magma Fissure
	[806185] = { default = true, duration = 45, class = "WILDWALKER" }, -- Mountain Fury
	[681130] = { default = true, duration = 60, class = "WILDWALKER" }, -- Mountain Hammer
	[807467] = { default = true, duration = 60, class = "WILDWALKER" }, -- Neptulon's Wrath
	[807560] = { default = true, duration = 300, class = "WILDWALKER" }, -- Primal Awakening
	[800181] = { default = true, duration = 180, class = "WILDWALKER" }, -- Primal Convergence
	[500696] = { default = false, duration = 25, class = "WILDWALKER" }, -- Primal Rush
	[504229] = { default = true, duration = 600, class = "WILDWALKER" }, -- Primal Totem
	[802782] = { default = true, duration = 120, class = "WILDWALKER" }, -- Protective Roar
	[800180] = { default = true, duration = 180, class = "WILDWALKER" }, -- Sacred Grove
	[806549] = { default = true, duration = 180, class = "WILDWALKER" }, -- Savage Frenzy
	[300693] = { default = false, duration = 8, class = "WILDWALKER" }, -- Seismic Smash
	[680442] = { default = false, duration = 8, class = "WILDWALKER" }, -- Seismic Tremor
	[805462] = { default = false, duration = 8, class = "WILDWALKER" }, -- Seismic Wave
	[800144] = { default = true, duration = 30, class = "WILDWALKER" }, -- Spirit Charge
	[681119] = { default = false, duration = 20, class = "WILDWALKER" }, -- Terrasurge
	[500764] = { default = false, duration = 14, class = "WILDWALKER" }, -- Throat Clamp
	[803980] = { default = true, duration = 300, class = "WILDWALKER" }, -- Wildheart
	-- WITCHDOCTOR
	[500952] = { default = true, duration = 120, class = "WITCHDOCTOR" }, -- Amphibimorph
	[801689] = { default = true, duration = 120, class = "WITCHDOCTOR" }, -- Arcane Brew
	[802087] = { default = false, duration = 15, class = "WITCHDOCTOR" }, -- Bad Juju
	[705870] = { default = true, duration = 90, class = "WITCHDOCTOR" }, -- Base: Beast Blood
	[500962] = { default = true, duration = 90, class = "WITCHDOCTOR" }, -- Base: Crystal Water
	[681222] = { default = false, duration = 40, class = "WITCHDOCTOR" }, -- Call of Sseratus
	[706542] = { default = true, duration = 60, class = "WITCHDOCTOR" }, -- Cursed Effigy
	[602220] = { default = false, duration = 30, class = "WITCHDOCTOR" }, -- Death Draught
	[681007] = { default = true, duration = 120, class = "WITCHDOCTOR" }, -- Fool's Play
	[560748] = { default = false, duration = 20, class = "WITCHDOCTOR" }, -- Frenzied Spirits
	[807042] = { default = true, duration = 10, class = "WITCHDOCTOR" }, -- Hexfire
	[801664] = { default = true, duration = 500, class = "WITCHDOCTOR" }, -- Ingredient: Bloodthistle
	[801663] = { default = true, duration = 500, class = "WITCHDOCTOR" }, -- Ingredient: Frog Bones
	[801660] = { default = true, duration = 500, class = "WITCHDOCTOR" }, -- Ingredient: Jungle Shrooms
	[803678] = { default = true, duration = 60, class = "WITCHDOCTOR" }, -- Malignant Jinx
	[705864] = { default = true, duration = 120, class = "WITCHDOCTOR" }, -- Master Mixologist
	[707162] = { default = true, duration = 60, class = "WITCHDOCTOR" }, -- Mimic Ward
	[501136] = { default = true, duration = 180, class = "WITCHDOCTOR" }, -- Mirage
	[500950] = { default = false, duration = 10, class = "WITCHDOCTOR" }, -- Mojo Beam
	[705850] = { default = true, duration = 45, class = "WITCHDOCTOR" }, -- Mojo: Fish Bones
	[705851] = { default = true, duration = 45, class = "WITCHDOCTOR" }, -- Mojo: Frog Shrooms
	[500472] = { default = true, duration = 45, class = "WITCHDOCTOR" }, -- Mojo: Jungle Thistle
	[801661] = { default = false, duration = 15, class = "WITCHDOCTOR" }, -- Potion Toss
	[707209] = { default = true, duration = 180, class = "WITCHDOCTOR" }, -- Puppeteer's Grasp
	[503750] = { default = true, duration = 120, class = "WITCHDOCTOR" }, -- Rage Brew
	[500015] = { default = false, duration = 18, class = "WITCHDOCTOR" }, -- Shadow Puppets
	[807040] = { default = true, duration = 180, class = "WITCHDOCTOR" }, -- Shadowstalker
	[500947] = { default = true, duration = 60, class = "WITCHDOCTOR" }, -- Slither
	[704497] = { default = true, duration = 90, class = "WITCHDOCTOR" }, -- Soul Marionette
	[801607] = { default = false, duration = 10, class = "WITCHDOCTOR" }, -- Spirit Eclipse
	[806289] = { default = false, duration = 20, class = "WITCHDOCTOR" }, -- Spirit Glaive
	[706369] = { default = true, duration = 180, class = "WITCHDOCTOR" }, -- Spirit Link Idol
	[807743] = { default = false, duration = 28, class = "WITCHDOCTOR" }, -- Spirit Shock
	[802710] = { default = false, duration = 15, class = "WITCHDOCTOR" }, -- Splash Potion
	[804226] = { default = true, duration = 60, class = "WITCHDOCTOR" }, -- Swift Idol
	[802100] = { default = true, duration = 90, class = "WITCHDOCTOR" }, -- Veil of Darkness
	[801716] = { default = true, duration = 90, class = "WITCHDOCTOR" }, -- Voice of Bwonsamdi
	[504465] = { default = true, duration = 120, class = "WITCHDOCTOR" }, -- Vol'jin's Vigil
	[804684] = { default = true, duration = 180, class = "WITCHDOCTOR" }, -- Voodoo Cauldron
	[800330] = { default = true, duration = 180, class = "WITCHDOCTOR" }, -- War Golem
	-- WITCHHUNTER
	[520670] = { default = true, duration = 45, class = "WITCHHUNTER" }, -- Bolt and Dash
	[501380] = { default = true, duration = 60, class = "WITCHHUNTER" }, -- Brand of the Unworthy
	[802269] = { default = false, duration = 40, class = "WITCHHUNTER" }, -- Burrow Bolt
	[680521] = { default = true, duration = 180, class = "WITCHHUNTER" }, -- Chains of Darkness
	[500086] = { default = false, duration = 30, class = "WITCHHUNTER" }, -- Daring Escape
	[802139] = { default = true, duration = 120, class = "WITCHHUNTER" }, -- Darkslayer's Lantern
	[681450] = { default = true, duration = 60, class = "WITCHHUNTER" }, -- Death Trap
	[804194] = { default = true, duration = 120, class = "WITCHHUNTER" }, -- Decimate
	[802140] = { default = false, duration = 30, class = "WITCHHUNTER" }, -- Fiery Judgement
	[805365] = { default = true, duration = 60, class = "WITCHHUNTER" }, -- Flourish
	[802138] = { default = true, duration = 180, class = "WITCHHUNTER" }, -- Gaze of the Black Knight
	[805754] = { default = false, duration = 10, class = "WITCHHUNTER" }, -- Heartseeking Bolt
	[802273] = { default = false, duration = 20, class = "WITCHHUNTER" }, -- Houndmaster's Call
	[801343] = { default = false, duration = 10, class = "WITCHHUNTER" }, -- Houndmaster's Whistle
	[681445] = { default = true, duration = 60, class = "WITCHHUNTER" }, -- Inquisitor's Trap
	[680498] = { default = true, duration = 45, class = "WITCHHUNTER" }, -- Knight's Seal
	[681095] = { default = false, duration = 10, class = "WITCHHUNTER" }, -- March of the Black King
	[802277] = { default = true, duration = 120, class = "WITCHHUNTER" }, -- Pyro Tonic
	[804193] = { default = false, duration = 10, class = "WITCHHUNTER" }, -- Quickdraw
	[805738] = { default = true, duration = 300, class = "WITCHHUNTER" }, -- Rearmament
	[680236] = { default = false, duration = 20, class = "WITCHHUNTER" }, -- Repulse
	[680238] = { default = true, duration = 60, class = "WITCHHUNTER" }, -- Shadow Trap
	[804068] = { default = true, duration = 90, class = "WITCHHUNTER" }, -- Slayer's Mark
	[805756] = { default = true, duration = 120, class = "WITCHHUNTER" }, -- Smoke Grenade
	[503662] = { default = false, duration = 20, class = "WITCHHUNTER" }, -- Torchlight
	[807918] = { default = false, duration = 10, class = "WITCHHUNTER" }, -- Unleash the Hounds
	[802276] = { default = true, duration = 120, class = "WITCHHUNTER" }, -- Vampiric Tonic
	[500085] = { default = false, duration = 12, class = "WITCHHUNTER" }, -- Vault
	[680494] = { default = false, duration = 30, class = "WITCHHUNTER" }, -- Witchblight
	[802278] = { default = true, duration = 120, class = "WITCHHUNTER" }, -- Witchblood Tonic
	[805770] = { default = true, duration = 90, class = "WITCHHUNTER" }, -- Witching Shroud
}


