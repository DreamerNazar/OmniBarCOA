# OmniBarCOA
PvP cooldown tracker for Ascension CoA (21 classes) / Трекер кулдаунов для Ascension CoA
Трекер вражеских кулдаунов для клиента Ascension / **Conquest of Azeroth** (форк OmniBar 3.3.5a).

Аддон слушает `SPELL_CAST_SUCCESS` в combat log и показывает иконки способностей с таймером.

> **EN:** Enemy cooldown tracker for Ascension Conquest of Azeroth — OmniBar fork with 21 CoA classes  
> **RU:** Трекер вражеских кулдаунов для Ascension CoA — форк OmniBar под 21 класс

# OmniBar (Conquest of Azeroth)

## Установка

1. Скопируйте папки `OmniBar` и `OmniBar_Options` в каталог аддонов клиента, например:
   - `World of Warcraft/_classic_/Interface/AddOns/`
   - или путь AddOns вашего Ascension-клиента
2. Убедитесь, что рядом лежат обе папки (Options зависит от основного аддона).
3. В игре: `/ob` или Interface Options → OmniBar.

## CoA-классы

В клиенте CoA классы используют **fileString-токены**, а не отображаемые имена:

| Токен | Имя в игре |
|---|---|
| `BARBARIAN` | Barbarian |
| `WITCHDOCTOR` | Witch Doctor |
| `DEMONHUNTER` | Felsworn |
| `WITCHHUNTER` | Witch Hunter |
| `STORMBRINGER` | Stormbringer |
| `FLESHWARDEN` | Knight of Xoroth |
| `GUARDIAN` | Guardian |
| `MONK` | Templar |
| `SONOFARUGAL` | Bloodmage |
| `RANGER` | Ranger |
| `PROPHET` | Venomancer |
| `PYROMANCER` | Pyromancer |
| `CULTIST` | Cultist |
| `NECROMANCER` | Necromancer |
| `SUNCLERIC` | Sun Cleric |
| `TINKER` | Tinker |
| `REAPER` | Reaper |
| `WILDWALKER` | Primalist |
| `STARCALLER` | Starcaller |
| `SPIRITMAGE` | Runemaster |
| `CHRONOMANCER` | Chronomancer |

Спеки и токены заданы в `OmniBar/OmniBar.lua` (`LOCALIZED_CLASS_SPEC_NAMES`).  
Кулдауны CoA вынесены в [`OmniBar/CoA_Cooldowns.lua`](OmniBar/CoA_Cooldowns.lua).

## Как добавить способность

1. Найдите spell ID на [CoA Tavern](https://coatavern.com) (страница спелла, поле `id` / URL `/spell/123456`).
2. Посмотрите кулдаун: `Cooldown` / `recoveryTime` (мс → секунды: `60000` = 60).
3. Проверьте `ownerClassFileString` — это токен для поля `class`.
4. Добавьте строку в `OmniBar/CoA_Cooldowns.lua`:

```lua
[501380] = { default = true, duration = 60, class = "WITCHHUNTER" }, -- Brand of the Unworthy
```

- `default = true` — включено сразу в опциях  
- `default = false` — выключено, можно включить вручную в `/ob`  
- Комментарий — имя для людей; иконка/название берутся из `GetSpellInfo` в клиенте

5. Перезагрузите UI (`/reload`) и проверьте вкладку класса в опциях.

### Что имеет смысл трекать

Как у классических классов в OmniBar: кики, CC, крупные сейвы и бурсты, мобилити — не весь spellbook.

## Автосбор с CoA Tavern

В репозитории есть скрипт (нужен Python 3 и сеть):

```bash
# Один класс (Barbarian = 12) — быстрее для проверки
python tools/fetch_coa_cooldowns.py --class-id 12 --out OmniBar/CoA_Cooldowns.generated.lua

# Все 21 класс (долго: сотни страниц спеллов)
python tools/fetch_coa_cooldowns.py --min-cd 8 --out OmniBar/CoA_Cooldowns.generated.lua
```

Скрипт пишет фрагмент Lua. Скопируйте нужные строки в `OmniBarCoA.cooldowns` внутри `CoA_Cooldowns.lua` (не подключайте generated-файл в `.toc` без ревью — там будут лишние спеллы).

ID классов на Tavern: 12–32 (см. [classes](https://coatavern.com/classes)).

## Структура

```
OmniBar/
  CoA_Cooldowns.lua   # CoA-классы и их кулдауны
  OmniBar.lua         # логика + WotLK/классические кулдауны + спеки
  OmniBar.xml
  OmniBar.toc
OmniBar_Options/
  OmniBar_Options.lua
  localization.lua
tools/
  fetch_coa_cooldowns.py
```

## Проверка в игре

1. `/ob` → есть вкладки CoA-классов, у которых уже есть записи в `CoA_Cooldowns.lua`.
2. В BG/арене: враг кастует отслеживаемый спелл → появляется иконка с таймером.
3. Если иконка с вопросом — `GetSpellInfo(spellID)` вернул nil (неверный ID для вашего патча).
4. Если таймер «плывёт» — поправьте `duration` (таланты/essences могут менять CD).

## Примечания

- Lookup в combat log идёт и по spell ID, и по имени (`cooldownLookup`) — разные ранги с одним именем схлопываются.
- Таблица `resets` в `OmniBar.lua` сбрасывает связанные CD (как Preparation / Cold Snap); для CoA добавляйте туда по мере нахождения аналогов.
- Источник данных по спеллам: [coatavern.com](https://coatavern.com).

