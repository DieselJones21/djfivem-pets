# djfivem-pets

A premium companion system for FiveM. Pets are **ox_inventory items** — use the animal item to call or recall it. Feeding, watering, walking, collars, leashes, death, and revive are item-driven. A glass kennel HUD and a custom **Companion Emporium** shop are included.

## Features

- **41 companions** across Police K9, dogs, puppies, cats, farm, exotic, wild, and special
- **Police K9** units with attack, search, and guard commands
- Realistic transparent inventory / HUD portraits
- Use the pet item to **call / recall**
- **Pet, feed, water,** sit, stay, follow
- **Walks require a collar on the pet and a leash in your inventory**
- Guard animals can attack a targeted ped (K9 units can take down players by default)
- Pets get hungry and thirsty, can **die**, and need a **revive kit**
- Black / red / white / blue NUI **kennel** (default `F6`) — compact HUD in the **top-right**
- Custom **Companion Emporium** with a Police K9 section, search, and adopt cards
- OneSync networked peds so other players can see your animal

## Roster

| Item | Model | Category |
| --- | --- | --- |
| `pet_lspd` | `a_c_lspddog` | Police K9 |
| `pet_shepherd` | `A_C_shepherd_2` | Police K9 |
| `pet_shepherd_np` | `a_c_shepherd_np` | Police K9 |
| `pet_doberman` | `doberman` | Police K9 |
| `pet_dusa_doberman` | `dusa_doberman` | Police K9 |
| `pet_cane` | `dusa_cane` | Police K9 |
| `pet_pit` | `A_C_Pit_NP` | Police K9 |
| `pet_chop` | `A_C_Chop` | Police K9 |
| `pet_retriever_np` | `A_C_Retriever_np` | Police K9 |
| `pet_husky_np` | `a_c_husky_np` | Police K9 |
| `pet_husky` | `A_C_Husky_2` | Dogs |
| `pet_retriever` | `A_C_Retriever_2` | Dogs |
| `pet_westy` | `a_c_westy_2` | Dogs |
| `pet_poodle` | `a_c_poodle_2` | Dogs |
| `pet_bulldog` | `dusa_englishbulldog` | Dogs |
| `pet_dalmatian` | `a_c_dalmatian` | Dogs |
| `pet_chowchow` | `chowchow` | Dogs |
| `pet_dachshund` | `poprplonghairweiner` | Dogs |
| `pet_aussiepup` | `a_c_aussiepup` | Puppies |
| `pet_fdpuppy` | `a_c_fdpuppy` | Puppies |
| `pet_pitpup` | `a_c_pitbullpup` | Puppies |
| `pet_rotpuppy` | `a_c_rotpuppy` | Puppies |
| `pet_bostonpup` | `bostonterrier_puppy` | Puppies |
| `pet_boxerpup` | `boxerpuppy` | Puppies |
| `pet_dalpup` | `dal_puppy` | Puppies |
| `pet_yorkie` | `yorkie_puppy` | Puppies |
| `pet_sphynx` | `dusa_sphynx` | Cats |
| `pet_piglet` | `bugpiglet` | Farm |
| `pet_donkey` | `c3d_donkey` | Farm |
| `pet_goat` | `c3d_goat` | Farm |
| `pet_pig` | `c3d_pig` | Farm |
| `pet_turkey` | `c3d_turkey` | Farm |
| `pet_dodo` | `a_c_dodo` | Exotic |
| `pet_raccoon` | `A_C_Raccoon_01` | Exotic |
| `pet_capybara` | `bugcapybara` | Exotic |
| `pet_skunk` | `c3d_skunk` | Exotic |
| `pet_reindeer` | `reindeer` | Exotic |
| `pet_blackbear` | `c3d_blackbear` | Wild |
| `pet_honeybadger` | `c3d_honeybadger` | Wild |
| `pet_wolf` | `c3d_lobo` | Wild |
| `pet_robot` | `Robot_Zathura` | Special |

Addon models must be streamed by your own animal packs. This resource does not include ped streams.

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target) (optional, E-prompt fallback is included)

`server.cfg`:

```cfg
ensure ox_lib
ensure ox_inventory
ensure ox_target
ensure djfivem-pets
```

## Install ox_inventory items

1. Copy every entry from `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`.
2. Copy the PNGs from `install/images/` into `ox_inventory/web/images/`.
3. Restart `ox_inventory`, then this resource.

The shop charges the `money` item by default. Change `Config.Shop.currency.item` if your economy uses a different ox_inventory cash item. Set `Config.Shop.useCustomUI = false` to fall back to the default ox_inventory shop.

Supplies:

| Item | Use |
| --- | --- |
| `pet_food` | Feed a spawned companion |
| `pet_water` | Water a spawned companion |
| `pet_collar` | Equip a collar (consumed). Required before walking |
| `pet_leash` | Keep in inventory to start a walk (not consumed) |
| `pet_revive` | Revive a downed companion |

Pet identity, name, collar, and needs are stored on the **item metadata**. Trading or dropping the item takes the animal with it. If that pet was out, it is recalled.

## How to play

1. Buy a companion and supplies at the **Companion Emporium** (Harmony, near YouTool — move it in `config.lua`).
2. Use the animal item to spawn it. Use that same item again to put it away.
3. `F6` opens the kennel HUD in the top-right. You can also target the animal with ox_target.
4. Use a **collar** on a spawned pet, then use a **leash** (or Walk in the menu) to walk them.
5. Aim at a ped and press `G` (default) to send a guard animal after it. Police K9 units also get **Search** and **Guard** in the kennel and on ox_target.

## Police K9

These working dogs sit in their own shop section and ship with attack, search, and guard:

`pet_lspd`, `pet_shepherd`, `pet_shepherd_np`, `pet_doberman`, `pet_dusa_doberman`, `pet_cane`, `pet_pit`, `pet_chop`, `pet_retriever_np`, `pet_husky_np`

- **Attack** sends the K9 after the aimed ped. K9 units can take down players even when `Config.AttackPlayers` is false.
- **Search** sends them to the aimed person (or sweeps nearby) and triggers their bark/alert.
- **Guard** holds the current position with `TaskGuardCurrentPosition`.

To lock K9 purchase and commands to police jobs:

```lua
Config.K9.requireJob = true
Config.K9.jobs = { 'police', 'sheriff', 'lspd' }
```

Ace bypass: `djfivem-pets.k9`. Optional custom job lookup: `Config.K9.getJob = function(src) ... end`.
6. If health hits 0 from injury or neglect, the pet goes down. Use a **revive kit** before it can be called again.

Admin: `/givepet [id] [species]` (`husky`, `cane`, `wolf`, `sphynx`, `pet_robot`, …). Ace: `group.admin`.

## Config

Edit `config.lua` for shop location, currency, prices, decay, attack-players, vehicle warping, and per-animal models.

## Keys

Players can rebind these in ox_lib keybinds:

- Pet menu: `F6`
- Pet attack: `G`
