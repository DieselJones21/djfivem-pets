# djfivem-pets

Interactable GTA animal pets for FiveM. Pets are **ox_inventory items** — use the animal item to call or recall it. Feeding, watering, walking, collars, leashes, death, and revive are all item-driven. A Kennel menu shows every stat and action.

## Features

- **13 vanilla GTA animals:** Rottweiler, Shepherd, Husky, Retriever, Pug, Poodle, Chop, Cat, Rabbit, Pig, Monkey, Coyote, Mountain Lion
- Use the pet item to **call / recall**
- **Pet, feed, water,** sit, stay, follow
- **Walks require a collar on the pet and a leash in your inventory**
- **Dogs, monkeys, coyotes, and mountain lions can attack** a targeted ped (player attacks optional in config)
- Pets get hungry and thirsty, can **die**, and need a **revive kit**
- NUI **pet menu** (default `F6`) with stats, bond/level, and all actions
- Harmony **pet store** with blip and ox_target
- OneSync networked peds so other players can see your animal

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

Item names:

| Item | Use |
| --- | --- |
| `pet_rottweiler` `pet_shepherd` `pet_husky` `pet_retriever` `pet_pug` `pet_poodle` `pet_chop` `pet_cat` `pet_rabbit` `pet_pig` `pet_monkey` `pet_coyote` `pet_mtlion` | Call / recall that pet |
| `pet_food` | Feed a spawned pet |
| `pet_water` | Water a spawned pet |
| `pet_collar` | Equip a collar (consumed). Required before walking |
| `pet_leash` | Keep in inventory to start a walk (not consumed) |
| `pet_revive` | Revive a dead pet |

Pet identity, name, collar, and needs are stored on the **item metadata**. Trading or dropping the item takes the animal with it. If that pet was out, it is recalled.

## How to play

1. Buy a pet, food, water, a collar, a leash, and a revive kit at the **Pet Store** (Harmony, near YouTool — move it in `config.lua`).
2. Use the animal item (or Kennel → Call) to spawn it.
3. `F6` opens the Kennel menu. You can also target the animal with ox_target.
4. Use a **collar** on a spawned pet, then use a **leash** (or Walk in the menu) to walk them. No collar or no leash = no walk.
5. Aim at a ped and press `G` (default) to send a **dog, monkey, coyote, or mountain lion** after it.
6. If health hits 0 from injury or neglect, the pet dies. Use a **revive kit** before it can be called again.

Admin: `/givepet [id] [species]` (`rottweiler`, `cat`, `monkey`, `coyote`, `mtlion`, …). Ace: `group.admin`.

## Config

Edit `config.lua` for shop location, prices, decay, attack-players, vehicle warping, and per-animal models.

## Keys

Players can rebind these in ox_lib keybinds:

- Pet menu: `F6`
- Pet attack: `G`
