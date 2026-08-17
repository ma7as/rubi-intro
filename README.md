# Pokémon Ruby — Intro

A fan-made, non-commercial recreation of the **Pokémon Ruby / Emerald** title intro in the [Godot Engine](https://godotengine.org/), rendered at the original GBA resolution (240×160) and scaled up to a 720×480 window.

> Status: early prototype (`0.1.0`). The splash → developer intro → title → bike → battle intro pipeline is functional; the in-game menu is a placeholder.

---

## Features

- **Splash & developer intro**: pond animation with animated water drops and expanding ripples (`estanque.tscn`).
- **Title intro**: Pokéball transition (`transicion_ball.tscn`) leading into the title screen (`title_intro.tscn`) with a custom shine shader.
- **Bike intro** (`bicicleteando.tscn`): character-driven ride-in with sprite aura and diagonal particle effects; selectable player (boy / girl).
- **Battle intro animation** (`anim_batalla.tscn`): Pokémon-colored sprite animation (`anim_batalla_pkm_color.gdshader`) over a pulsing Groudon-themed backdrop (`fondo_groudon_pulse.gdshader`).
- **Main menu shell**: Continue / New Game / Options / Exit with classic GBA-style 9-slice frame.
- **Custom shaders**:
  - `fondo_oleaje.gdshader` — scrolling wave background
  - `fondo_groudon_pulse.gdshader` — radial pulse on the battle backdrop
  - `particulas_diagonales.gdshader` — diagonal particle overlay
  - `logo_shine.gdshader` — animated logo highlight
  - `anim_batalla_pkm_color.gdshader` — per-Pokémon battle palette
- **Original Emerald music** in `Audio/emerald/` (Departure, Double Battle, Title Theme).

---

## Tech

| Item | Value |
| --- | --- |
| Engine | Godot **4.7** |
| Renderer | GL Compatibility (`gl_compatibility`) |
| GDScript version | GDScript 2 (Godot 4) |
| Native viewport | 240 × 160 |
| Window | 720 × 480 |
| Texture filter | Nearest (pixel-art friendly) |

---

## Running

1. Install [Godot 4.7](https://godotengine.org/download) (standard or mono — both work, this project has no C#).
2. Clone this repository.
3. Open `project.godot` in the editor.
4. Press **F5** (or _Project → Run_). The main scene is `res://escenas/pantalla_inicio/pantalla_inicio.tscn`.

> The first run will trigger Godot to import all assets under `escenas/pantalla_inicio/graficos/`, `graficos/`, `UI/` and `Audio/`. This only happens once.

---

## Controls

The project uses GBA-style action mapping (configurable in `Project → Project Settings → Input Map`).

| Action | Key | Use |
| --- | --- | --- |
| `btn_arriba` / `btn_abajo` / `btn_izquierda` / `btn_derecha` | Arrow keys | Navigate menus; skip developer intro |
| `btn_accion` | `X` | Confirm / A-button (skip title intro) |
| `btn_cancelar` | `Z` | Cancel / B-button (skip title intro) |
| `btn_menu` | `Enter` | Start / menu (skip title intro) |
| `btn_select` | `Backspace` | Select |

---

## Project layout

```
.
├── project.godot
├── README.md
├── Audio/
│   └── emerald/                # Music tracks from Pokémon Emerald
├── escenas/
│   └── pantalla_inicio/        # Main intro pipeline
│       ├── pantalla_inicio.gd  # State machine: SPLASH → INTRO → TITLE → ...
│       ├── pantalla_inicio.tscn
│       ├── title_intro.tscn    # Title screen
│       ├── transicion_ball.tscn# Pokéball transition
│       ├── bicicleteando.tscn  # Bike ride-in
│       ├── estanque.tscn       # Pond (developer intro)
│       ├── anim_batalla.tscn   # Battle intro animation
│       ├── *.gdshader          # Custom shaders
│       └── graficos/           # Sprite assets for the intro
├── fuentes/                    # TTF fonts (e.g. pokemon-rs.ttf)
├── graficos/                   # Shared graphics (battle, UI backgrounds, ...)
└── UI/                         # Shared UI sprites & cursor
```

---

## Roadmap

- [ ] Wire `nueva_partida_solicitada` / `opciones_solicitadas` / `salir_solicitado` to actual gameplay
- [ ] Save-slot detection for the **Continue** option
- [ ] Per-Pokémon palettes for `anim_batalla_pkm_color.gdshader`
- [ ] Settings menu (volume, text speed)
- [ ] Touch / gamepad input map

---

## Credits & disclaimer

- **Game design, music, and original Pokémon IP**: © Nintendo / Creatures Inc. / GAME FREAK inc. This project is an **unofficial, non-commercial fan work** made for educational purposes. No copyright infringement is intended.
- **Engine**: [Godot Engine](https://godotengine.org/) (MIT license).
- **Font**: `pokemon-rs.ttf` — third-party font used under its own license.
- **Music**: tracks under `Audio/emerald/` belong to their respective rights holders and are included for non-commercial demonstration only. Replace them with your own audio if you redistribute a build.

If you are a rights holder and want any asset removed, please open an issue.

---

## License

Source code in this repository is released under the **MIT License** — see [`LICENSE`](LICENSE).

**Assets are not covered by the MIT license.** See _Credits & disclaimer_ above for individual asset ownership and usage terms.