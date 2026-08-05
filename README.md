# OmniBarCOA
PvP cooldown tracker for Ascension CoA (21 classes) / Трекер кулдаунов для Ascension CoA
Трекер вражеских кулдаунов для клиента Ascension / **Conquest of Azeroth** (форк OmniBar 3.3.5a).

Аддон слушает `SPELL_CAST_SUCCESS` в combat log и показывает иконки способностей с таймером.

> **EN:** Enemy cooldown tracker for Ascension Conquest of Azeroth — OmniBar fork with 21 CoA classes  
> **RU:** Трекер вражеских кулдаунов для Ascension CoA — форк OmniBar под 21 класс

## DONATION
https://www.donationalerts.com/r/dreamernazar

> **EN:**
Thank you for your donations!
Your support helps OmniBarCOA grow — we fix bugs, add new abilities, and make the tracker better for Conquest of Azeroth.

Every contribution helps the addon move forward. Thank you for being with us!

> **RU:**
Спасибо за ваши донаты!
Благодаря вашей поддержке OmniBarCOA становится лучше — мы исправляем ошибки, добавляем новые способности и делаем трекер удобнее для Conquest of Azeroth.

Каждый вклад помогает развитию аддона. Спасибо, что вы с нами!

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

