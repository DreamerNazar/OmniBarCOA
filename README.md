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

> **EN:**
1. Completely remove the old `OmniBar` and `OmniBar_Options` folders from the client’s AddOns directory.
2. Copy **both** folders from this repository:
   - `OmniBar` (must include `CoA_Cooldowns.lua` and `CoA_Scan.lua`)
   - `OmniBar_Options`
3. Fully restart the client (not only `/reload`).
4. On login you should see: `OmniBar CoA: options panels = General + 21 CoA classes`.
5. In `/ob`, version should be **CoA 1.1**, and the left list should show Barbarian / Felsworn / Templar, etc. — not Warrior/Mage.

If you still see Warrior / Mage, an old copy of the addon is still in AddOns.

> **RU:**
1. Полностью удалите старые папки `OmniBar` и `OmniBar_Options` из AddOns клиента.
2. Скопируйте **обе** папки из этого репозитория:
   - `OmniBar` (обязательно с файлами `CoA_Cooldowns.lua` и `CoA_Scan.lua`)
   - `OmniBar_Options`
3. Полностью перезапустите клиент (не только `/reload`).
4. В чате при входе должно появиться: `OmniBar CoA: options panels = General + 21 CoA classes`.
5. В `/ob` версия должна быть **CoA 1.1**, в списке слева — Barbarian / Felsworn / Templar и т.д., без Warrior/Mage.

## CoA-class

| Token | Class |
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

Spec and class + token `OmniBar/OmniBar.lua` (`LOCALIZED_CLASS_SPEC_NAMES`).  
CD CoA in [`OmniBar/CoA_Cooldowns.lua`](OmniBar/CoA_Cooldowns.lua).

## Structure

```
OmniBar/
  CoA_Cooldowns.lua   # база кулдаунов CoA
  CoA_Scan.lua        # /obscan, /obclass
  OmniBar.lua         # логика трекера
  OmniBar.xml
  OmniBar.toc
OmniBar_Options/
  OmniBar_Options.lua
  OmniBar_Options.xml
  localization.lua
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

## Известные ограничения

- `C_CharacterAdvancement.GetAllEntries` может не отдавать отдельные классы (например Knight of Xoroth). Сканер дополнительно снимает **текущий** класс через `GetSpellsByClass` — для полной базы зайдите на альтов нужных классов и повторите `/obscan`.
- Lookup в combat log идёт по spell ID и по имени; разные ранги с одним именем схлопываются.
- Таблица `resets` в `OmniBar.lua` (сброс связанных CD) для CoA пока почти пустая — дополняйте по мере нахождения аналогов Preparation / Cold Snap.

## Credits

- **Jordon** — оригинальный OmniBar  
- **Jammin** — backport на 3.3.5a  
- Адаптация под Conquest of Azeroth / Ascension
- https://www.donationalerts.com/r/dreamernazar 

## Лицензия

Исходный OmniBar распространялся как аддон сообщества WoW. Этот форк — неофициальная адаптация для Ascension CoA; используйте на свой страх и риск.

