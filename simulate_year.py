#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
simulate_year.py - Balance simulation for Veredas Dream
Runs a 1-year (112-day) Monte Carlo simulation to verify economic balance.
Data extracted from script_init.gml and design docs.
"""
import sys
import io
import random
import math
from collections import defaultdict

# Force UTF-8 output on Windows
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

# ============================================================
# CONSTANTS
# ============================================================
DAYS_PER_SEASON = 28
SEASONS = ["spring", "summer", "fall", "winter"]
YEAR_DAYS = DAYS_PER_SEASON * 4  # 112
ENERGY_PER_DAY = 500
ENERGY_FARM = 2       # per till / water / harvest tile
ENERGY_FISH = 15      # per fish caught (increased from 10 for balance)
ENERGY_MINE = 2       # per pickaxe hit
RAIN_CHANCE = 0.20    # 20% days skip watering
STARTING_GOLD = 200

# ============================================================
# CROP DATA  (seed_cost from seed_data, sell from crop_data)
# ============================================================
CROPS = {
    # --- Spring ---
    "parsnip":      {"seed": 12, "sell": 22, "days": 5, "seasons": ["spring"]},
    "spring_onion": {"seed": 10, "sell": 16, "days": 6, "seasons": ["spring"]},
    "potato":       {"seed": 18, "sell": 32, "days": 6, "seasons": ["spring"]},
    "onion":        {"seed": 14, "sell": 24, "days": 6, "seasons": ["spring"]},
    "carrot":       {"seed": 14, "sell": 24, "days": 6, "seasons": ["spring"]},
    "cabbage":      {"seed": 18, "sell": 32, "days": 7, "seasons": ["spring"]},
    "rice":         {"seed": 22, "sell": 40, "days": 6, "seasons": ["spring"]},
    "broccoli":     {"seed": 22, "sell": 40, "days": 5, "seasons": ["spring"]},
    "cauliflower":  {"seed": 28, "sell": 46, "days": 6, "seasons": ["spring"]},
    "asparagus":    {"seed": 28, "sell": 50, "days": 5, "seasons": ["spring"]},
    "strawberry":   {"seed": 35, "sell": 56, "days": 6, "seasons": ["spring"]},
    "blueberry":    {"seed": 40, "sell": 72, "days": 6, "seasons": ["spring"]},
    # --- Summer ---
    "tomato":       {"seed": 20, "sell": 28, "days": 5, "seasons": ["summer"]},
    "sunflower":    {"seed": 15, "sell": 21, "days": 6, "seasons": ["summer"]},
    "hot_pepper":   {"seed": 30, "sell": 42, "days": 7, "seasons": ["summer"]},
    "corn":         {"seed": 25, "sell": 35, "days": 8, "seasons": ["summer", "fall"]},
    "green_pepper": {"seed": 20, "sell": 28, "days": 6, "seasons": ["summer"]},
    "melon":        {"seed": 50, "sell": 70, "days": 6, "seasons": ["summer"]},
    "watermelon":   {"seed": 50, "sell": 70, "days": 8, "seasons": ["summer"]},
    "cucumber":     {"seed": 20, "sell": 28, "days": 6, "seasons": ["summer"]},
    "eggplant":     {"seed": 25, "sell": 35, "days": 6, "seasons": ["summer"]},
    "pineapple":    {"seed": 60, "sell": 84, "days": 6, "seasons": ["summer"]},
    "green_beans":  {"seed": 25, "sell": 35, "days": 7, "seasons": ["summer"]},
    "adzuki_bean":  {"seed": 30, "sell": 42, "days": 7, "seasons": ["summer"]},
    "wild_berry":   {"seed": 20, "sell": 28, "days": 7, "seasons": ["summer"]},
    "wheat":        {"seed": 10, "sell": 14, "days": 6, "seasons": ["summer", "fall"]},
    "aloe":         {"seed": 30, "sell": 42, "days": 6, "seasons": ["summer"]},
    # --- Fall ---
    "beetroot":     {"seed": 25, "sell": 35, "days": 6, "seasons": ["fall"]},
    "pumpkin":      {"seed": 30, "sell": 42, "days": 6, "seasons": ["fall"]},
    "grapes":       {"seed": 40, "sell": 56, "days": 6, "seasons": ["fall"]},
}

JAM_MULTIPLIER = 2.5  # jam_sell = crop_sell * 2.5

# ============================================================
# FORAGE DATA (rarity 1-5, pool weight = 6 - rarity)
# ============================================================
# Representative sample matching the 119-item distribution in forage_data
FORAGE_ITEMS = [
    # rarity 1 (weight 5, sell 2g) — 12 representatives
    *[{"rarity": 1, "sell": 2}] * 12,
    # rarity 2 (weight 4, sell 4g) — 11 representatives
    *[{"rarity": 2, "sell": 4}] * 11,
    # rarity 3 (weight 3, sell 8g) — 12 representatives
    *[{"rarity": 3, "sell": 8}] * 12,
    # rarity 4 (weight 2, sell 20g) — 8 representatives
    *[{"rarity": 4, "sell": 20}] * 8,
    # rarity 5 (weight 1, sell 51g) — 5 representatives
    *[{"rarity": 5, "sell": 51}] * 5,
]
FORAGE_WEIGHTS = [6 - f["rarity"] for f in FORAGE_ITEMS]
FORAGE_RARE = [f for f in FORAGE_ITEMS if f["rarity"] >= 4]
# Proportion of flowers (22/119) and mushrooms (78/119) for town donations
FORAGE_FLOWER_FRAC = 22 / 119
FORAGE_MUSH_FRAC = 78 / 119

# ============================================================
# FISH DATA  (price_kg * weight = revenue; no extra multiplier)
# ============================================================
FISH = [
    # --- Spring (rarity = pool weight: higher = more common) ---
    {"seasons": ["spring"],        "rarity": 50, "price_kg":  9,  "wt_min": 1.5,  "wt_max": 4.0},   # Salmon
    {"seasons": ["spring"],        "rarity": 20, "price_kg": 12,  "wt_min": 0.8,  "wt_max": 3.0},   # Trucha
    {"seasons": ["spring"],        "rarity": 50, "price_kg": 17,  "wt_min": 0.2,  "wt_max": 0.8},   # Pez Sol
    {"seasons": ["spring"],        "rarity": 50, "price_kg":  9,  "wt_min": 0.3,  "wt_max": 1.2},   # Pez Gato
    {"seasons": ["spring"],        "rarity": 50, "price_kg":  5,  "wt_min": 0.8,  "wt_max": 3.0},   # Carpa
    {"seasons": ["spring"],        "rarity": 50, "price_kg": 11,  "wt_min": 0.2,  "wt_max": 1.0},   # Perca
    {"seasons": ["spring"],        "rarity": 50, "price_kg":  7,  "wt_min": 0.8,  "wt_max": 2.5},   # Bacalao
    {"seasons": ["spring"],        "rarity": 50, "price_kg": 25,  "wt_min": 0.05, "wt_max": 0.15},  # Sardina
    {"seasons": ["spring"],        "rarity": 50, "price_kg": 20,  "wt_min": 0.04, "wt_max": 0.12},  # Boqueron
    {"seasons": ["spring"],        "rarity": 50, "price_kg":  6,  "wt_min": 0.5,  "wt_max": 2.5},   # Merluza
    {"seasons": ["spring"],        "rarity": 20, "price_kg":  8,  "wt_min": 1.0,  "wt_max": 4.0},   # Lubina
    {"seasons": ["spring"],        "rarity": 20, "price_kg":  9,  "wt_min": 1.0,  "wt_max": 5.0},   # Rodaballo
    {"seasons": ["spring"],        "rarity": 20, "price_kg": 27,  "wt_min": 0.3,  "wt_max": 1.5},   # Lenguado
    {"seasons": ["spring"],        "rarity": 20, "price_kg": 15,  "wt_min": 0.5,  "wt_max": 2.0},   # Besugo
    {"seasons": ["spring"],        "rarity": 20, "price_kg": 15,  "wt_min": 0.5,  "wt_max": 3.0},   # Dorada
    {"seasons": ["spring"],        "rarity": 20, "price_kg":  6,  "wt_min": 2.0,  "wt_max": 8.0},   # Mero
    {"seasons": ["spring"],        "rarity": 50, "price_kg": 27,  "wt_min": 0.2,  "wt_max": 0.8},   # Salmonete
    {"seasons": ["spring"],        "rarity": 50, "price_kg": 15,  "wt_min": 0.2,  "wt_max": 0.8},   # Caballa
    {"seasons": ["spring"],        "rarity": 50, "price_kg": 15,  "wt_min": 0.2,  "wt_max": 0.6},   # Jurel
    {"seasons": ["spring"],        "rarity":  7, "price_kg": 29,  "wt_min": 0.5,  "wt_max": 3.0},   # Anguila
    {"seasons": ["spring"],        "rarity":  7, "price_kg":  7,  "wt_min": 3.0,  "wt_max": 12.0},  # Esturion
    {"seasons": ["spring"],        "rarity":  7, "price_kg":  5,  "wt_min": 5.0,  "wt_max": 20.0},  # Pez Espada
    {"seasons": ["spring"],        "rarity": 20, "price_kg":  7,  "wt_min": 3.0,  "wt_max": 12.0},  # Atun
    {"seasons": ["spring"],        "rarity": 20, "price_kg":  4,  "wt_min": 2.0,  "wt_max": 8.0},   # Bonito
    {"seasons": ["spring"],        "rarity": 20, "price_kg": 11,  "wt_min": 0.8,  "wt_max": 3.0},   # Lubina Roca
    # --- Summer (tropical, high value small fish) ---
    {"seasons": ["summer"],        "rarity": 20, "price_kg": 40,  "wt_min": 0.2,  "wt_max": 1.0},   # Pez Cirujano  (−26%)
    {"seasons": ["summer"],        "rarity": 20, "price_kg": 30,  "wt_min": 0.3,  "wt_max": 1.5},   # Pez Angel     (−27%)
    {"seasons": ["summer"],        "rarity": 20, "price_kg": 84,  "wt_min": 0.1,  "wt_max": 0.5},   # Pez Mariposa  (−25%)
    {"seasons": ["summer"],        "rarity": 20, "price_kg": 23,  "wt_min": 0.5,  "wt_max": 2.0},   # Pez Loro
    {"seasons": ["summer"],        "rarity": 20, "price_kg": 34,  "wt_min": 0.3,  "wt_max": 1.5},   # Pez Ballesta
    {"seasons": ["summer"],        "rarity": 20, "price_kg": 68,  "wt_min": 0.1,  "wt_max": 0.5},   # Pez Cofre     (−24%)
    {"seasons": ["summer"],        "rarity":  7, "price_kg": 51,  "wt_min": 0.3,  "wt_max": 1.5},   # Pez Globo     (−25%)
    {"seasons": ["summer"],        "rarity":  7, "price_kg": 54,  "wt_min": 0.3,  "wt_max": 1.5},   # Pez Leon      (−24%)
    {"seasons": ["summer"],        "rarity":  7, "price_kg": 118, "wt_min": 0.1,  "wt_max": 0.5},   # Pez Pipa      (−25%)
    {"seasons": ["summer"],        "rarity":  7, "price_kg": 50,  "wt_min": 0.3,  "wt_max": 1.5},   # Pez Escorpion (−24%)
    {"seasons": ["summer"],        "rarity":  2, "price_kg":  7,  "wt_min": 8.0,  "wt_max": 30.0},  # Tiburon Blanco
    {"seasons": ["summer"],        "rarity":  2, "price_kg": 10,  "wt_min": 10.0, "wt_max": 40.0},  # Tiburon Ballena
    {"seasons": ["summer"],        "rarity":  7, "price_kg": 33,  "wt_min": 0.5,  "wt_max": 2.0},   # Pez Trompeta  (−25%)
    {"seasons": ["summer"],        "rarity":  7, "price_kg": 42,  "wt_min": 0.3,  "wt_max": 1.5},   # Pez Flauta    (−25%)
    {"seasons": ["summer"],        "rarity":  7, "price_kg":  8,  "wt_min": 4.0,  "wt_max": 15.0},  # Pez Vela
    {"seasons": ["summer"],        "rarity":  7, "price_kg":  6,  "wt_min": 6.0,  "wt_max": 25.0},  # Pez Martillo
    {"seasons": ["summer"],        "rarity":  7, "price_kg":  6,  "wt_min": 5.0,  "wt_max": 20.0},  # Raya Latigo
    # --- Fall (shellfish, high price/kg small weight) ---
    {"seasons": ["fall"],          "rarity": 50, "price_kg": 34,  "wt_min": 0.1,  "wt_max": 0.5},   # Calamar
    {"seasons": ["fall"],          "rarity": 50, "price_kg": 24,  "wt_min": 0.2,  "wt_max": 0.8},   # Sepia
    {"seasons": ["fall"],          "rarity": 50, "price_kg": 54,  "wt_min": 0.1,  "wt_max": 0.4},   # Langostino
    {"seasons": ["fall"],          "rarity": 50, "price_kg": 226, "wt_min": 0.01, "wt_max": 0.05},  # Camaron
    {"seasons": ["fall"],          "rarity": 20, "price_kg": 13,  "wt_min": 1.5,  "wt_max": 5.0},   # Cangrejo Real
    {"seasons": ["fall"],          "rarity": 20, "price_kg": 92,  "wt_min": 0.1,  "wt_max": 0.4},   # Cigala        (−25%)
    {"seasons": ["fall"],          "rarity": 20, "price_kg": 163, "wt_min": 0.05, "wt_max": 0.2},   # Gamba Roja    (−25%)
    {"seasons": ["fall"],          "rarity":  7, "price_kg": 62,  "wt_min": 0.5,  "wt_max": 2.0},   # Langosta      (−24%)
    {"seasons": ["fall"],          "rarity":  7, "price_kg": 51,  "wt_min": 0.5,  "wt_max": 3.0},   # Bogavante     (−25%)
    {"seasons": ["fall"],          "rarity":  7, "price_kg": 15,  "wt_min": 2.0,  "wt_max": 10.0},  # Pulpo Gigante
    {"seasons": ["fall"],          "rarity":  7, "price_kg": 574, "wt_min": 0.04, "wt_max": 0.12},  # Percebe       (−25%)
    {"seasons": ["fall"],          "rarity": 20, "price_kg": 87,  "wt_min": 0.1,  "wt_max": 0.4},   # Necora        (−25%)
    {"seasons": ["fall"],          "rarity":  2, "price_kg": 313, "wt_min": 0.3,  "wt_max": 1.0},   # Nautilo
    {"seasons": ["fall"],          "rarity":  2, "price_kg": 16,  "wt_min": 6.0,  "wt_max": 25.0},  # Delfin Oceanico
    {"seasons": ["fall"],          "rarity":  1, "price_kg": 30,  "wt_min": 5.0,  "wt_max": 20.0},  # Delfin Rosado
]

# ============================================================
# MINERAL DATA
# ============================================================
ORES = [
    {"name": "bronce",       "sell": 3,   "bar_sell": 7,   "hits_basic": 10},
    {"name": "plata",        "sell": 7,   "bar_sell": 14,  "hits_basic": 12},
    {"name": "oro",          "sell": 14,  "bar_sell": 27,  "hits_basic": 16},
    {"name": "broncastanio", "sell": 27,  "bar_sell": 54,  "hits_basic": 20},
    {"name": "chubestanio",  "sell": 54,  "bar_sell": 109, "hits_basic": 25},
    {"name": "picastanio",   "sell": 109, "bar_sell": 218, "hits_basic": 30},
    {"name": "hitlerstanio", "sell": 218, "bar_sell": 435, "hits_basic": 36},
    {"name": "vitolanio",    "sell": 435, "bar_sell": 870, "hits_basic": 44},
]
PLAIN_ROCK_HITS = 4
PLAIN_ROCK_STONE = 3   # piedra por roca normal
COAL_HITS = 8
COAL_SELL = 2
GEM_HITS = 15

GEMS = [
    {"rarity": 30, "sell":  26},  # Ruby
    {"rarity": 25, "sell":  34},  # Sapphire
    {"rarity": 20, "sell":  51},  # Emerald
    {"rarity": 18, "sell":  68},  # Topaz
    {"rarity": 15, "sell": 102},  # Pink Sapphire
    {"rarity": 12, "sell": 136},  # Turquoise
    {"rarity": 10, "sell": 170},  # Aquamarine
    {"rarity":  8, "sell": 221},  # Amethyst
    {"rarity":  6, "sell": 272},  # Pearl
    {"rarity":  4, "sell": 340},  # Diamond
    {"rarity":  2, "sell": 510},  # Pink Diamond
    {"rarity":  1, "sell": 850},  # Alexandrite
]
GEM_WEIGHTS = [g["rarity"] for g in GEMS]

# ============================================================
# TOWN RESTORATION STAGES
# Sources: plans/TOWN_PROGRESSION.md + town_progression_implementation.md
# ============================================================
TOWN_STAGES = [
    {
        "label": "0→1  Limpiar Calles",
        "stone": 500, "wood": 300, "coal": 25,
        "bar_plata": 15, "bar_bronce": 15,
        "dye": 6, "honey": 5,
        "construction_days": 0,
    },
    {
        "label": "1→2  Areas Verdes",
        "parsnip": 50, "carrot": 25, "onion": 25,
        "forage_any": 35, "bar_oro": 10,
        "construction_days": 0,
    },
    {
        "label": "2→3  Calles Restauradas",
        "stone": 600, "wood": 400, "bar_broncastanio": 10,
        "cloth": 30, "leather": 15, "thread": 10, "wool": 5, "dye": 3,
        "construction_days": 0,
    },
    {
        "label": "3→5  Tienda Miraculos",
        "cheese": 20, "goat_cheese": 15, "butter": 20, "honey": 5,
        "thread": 15, "egg": 15, "dye": 3, "fruit_any": 50, "forage_any": 15,
        "construction_days": 3,
    },
    {
        "label": "5→7  Herreria Carlos",
        "bar_chubestanio": 10, "leather": 40, "pelt": 20,
        "yarn": 20, "gemstone": 10, "stone": 200,
        "construction_days": 3,
    },
    {
        "label": "7→8  Arboles",
        "bar_vitolanio": 5, "bar_chubestanio": 20, "gemstone": 15,
        "forage_flowers": 30, "forage_mush": 20, "wood": 500, "stone": 300,
        "construction_days": 0,
    },
    {
        "label": "8→10 Torre y Parque",
        "stone": 800, "wood": 600, "bar_vitolanio": 10,
        "cloth": 40, "leather": 25, "yarn": 30, "dye": 10,
        "construction_days": 4,
    },
    {
        "label": "10→12 Urbanizacion",
        "stone": 400, "bar_chubestanio": 30, "coal": 15, "cloth": 20, "leather": 15,
        "construction_days": 3,
    },
]

# ============================================================
# HELPERS
# ============================================================

def weighted_choice(items, weights):
    total = sum(weights)
    r = random.uniform(0, total)
    cursor = 0
    for item, w in zip(items, weights):
        cursor += w
        if r <= cursor:
            return item
    return items[-1]


def avg_list(lst):
    return sum(lst) / len(lst) if lst else 0


def bar(value, max_val, width=25):
    if max_val <= 0:
        return "░" * width
    filled = min(width, int((value / max_val) * width))
    return "█" * filled + "░" * (width - filled)


# ============================================================
# FARMING SIMULATION
# ============================================================

def best_crop(season, budget, max_plots=100):
    """Returns the crop that maximizes total gold/day with current budget.
    At low capital fewer plots of a high-PPD crop beats a cheap crop;
    this chooses the option with the highest actual daily return."""
    best = None
    best_total_gpd = -1
    for name, c in CROPS.items():
        if season not in c["seasons"]:
            continue
        profit = c["sell"] - c["seed"]
        if profit <= 0:
            continue
        plots = min(max_plots, budget // c["seed"])
        if plots <= 0:
            continue
        total_gpd = plots * profit / c["days"]  # total gold/day with current budget
        if total_gpd > best_total_gpd:
            best_total_gpd = total_gpd
            best = (name, plots, profit / c["days"], c)
    return best  # (name, plots, ppd_per_plot, crop_dict) or None


def simulate_farming_season(season, start_budget, max_plots=100, days=DAYS_PER_SEASON):
    budget = start_budget
    earned = spent = energy = cycles = 0

    day = 0
    while day < days:
        pick = best_crop(season, budget, max_plots)
        if not pick:
            break
        name, plots, ppd, c = pick
        if day + c["days"] > days:
            break

        cost = plots * c["seed"]
        budget -= cost
        spent += cost

        # Till + water day 1
        energy += plots * ENERGY_FARM * 2

        # Water intermediate days
        for _ in range(c["days"] - 2):
            if random.random() > RAIN_CHANCE:
                energy += plots * ENERGY_FARM

        # Water + harvest last day
        energy += plots * ENERGY_FARM * 2

        revenue = plots * c["sell"]
        budget += revenue
        earned += revenue
        cycles += 1
        day += c["days"]

    return {"earned": earned, "spent": spent, "net": earned - spent,
            "energy": energy, "cycles": cycles, "end_budget": budget}


def simulate_farming_year(start_budget=STARTING_GOLD, max_plots=100):
    budget = start_budget
    year = {"net": 0, "energy": 0, "cycles": 0, "by_season": {}}
    for s in SEASONS:
        if s == "winter":
            year["by_season"][s] = {"net": 0, "energy": 0}
            continue
        r = simulate_farming_season(s, budget, max_plots)
        budget = r["end_budget"]
        year["net"] += r["net"]
        year["energy"] += r["energy"]
        year["cycles"] += r["cycles"]
        year["by_season"][s] = r
    year["end_budget"] = budget
    return year


# ============================================================
# FORAGING SIMULATION
# ============================================================

def simulate_foraging(days=YEAR_DAYS):
    total_gold = items = rare = 0
    days_since_rare = 0

    for _ in range(days):
        n = random.randint(8, 15)
        spawned_rare = False
        for _ in range(n):
            f = weighted_choice(FORAGE_ITEMS, FORAGE_WEIGHTS)
            total_gold += f["sell"]
            items += 1
            if f["rarity"] >= 4:
                spawned_rare = True
                rare += 1

        days_since_rare += 1
        if spawned_rare:
            days_since_rare = 0
        elif days_since_rare >= 3:
            f = random.choice(FORAGE_RARE)
            total_gold += f["sell"]
            items += 1
            rare += 1
            days_since_rare = 0

    return {"gold": total_gold, "items": items, "rare": rare,
            "daily_avg": total_gold / days}


# ============================================================
# FISHING SIMULATION
# ============================================================

def simulate_fishing(days=YEAR_DAYS, casts_per_day=20):
    total_gold = fish_count = energy_used = 0
    best = 0
    by_season = {}

    for day_idx in range(days):
        season = SEASONS[(day_idx // DAYS_PER_SEASON) % 4]
        pool = [f for f in FISH if season in f["seasons"]]
        if not pool:
            pool = [f for f in FISH if "fall" in f["seasons"]]

        weights = [f["rarity"] for f in pool]
        day_gold = 0

        for _ in range(casts_per_day):
            f = weighted_choice(pool, weights)
            w = random.uniform(f["wt_min"], f["wt_max"])
            value = f["price_kg"] * w
            day_gold += value
            fish_count += 1
            energy_used += ENERGY_FISH
            if value > best:
                best = value

        total_gold += day_gold
        if season not in by_season:
            by_season[season] = {"gold": 0, "fish": 0, "days": 0}
        by_season[season]["gold"] += day_gold
        by_season[season]["fish"] += fish_count
        by_season[season]["days"] += 1

    return {"gold": total_gold, "fish": fish_count, "energy": energy_used,
            "daily_avg": total_gold / days, "best": best, "by_season": by_season}


# ============================================================
# MINING SIMULATION
# ============================================================

def simulate_mining(days=YEAR_DAYS, ore_tier=0, visits_per_week=3, pickaxe_dmg=1):
    ore = ORES[ore_tier]
    floor = ore_tier + 1
    ore_pct = min((5 + floor * 3) / 100, 0.80)
    coal_pct = 0.04
    gem_pct = 0.01
    plain_pct = max(0, 1.0 - ore_pct - coal_pct - gem_pct)

    hits_ore   = max(1, math.ceil(ore["hits_basic"] / pickaxe_dmg))
    hits_gem   = max(1, math.ceil(GEM_HITS / pickaxe_dmg))
    hits_coal  = max(1, math.ceil(COAL_HITS / pickaxe_dmg))
    hits_plain = max(1, math.ceil(PLAIN_ROCK_HITS / pickaxe_dmg))

    avg_hits = (ore_pct * hits_ore + gem_pct * hits_gem +
                coal_pct * hits_coal + plain_pct * hits_plain)

    gold = ores = gems = stone = energy_used = bars = gem_gold = 0
    visits = (days // 7) * visits_per_week

    for _ in range(visits):
        visit_e = ENERGY_PER_DAY
        rocks = int(visit_e / (avg_hits * ENERGY_MINE))

        for _ in range(rocks):
            r = random.random()
            if r < gem_pct:
                g = weighted_choice(GEMS, GEM_WEIGHTS)
                gold += g["sell"]
                gem_gold += g["sell"]
                gems += 1
                energy_used += hits_gem * ENERGY_MINE
            elif r < gem_pct + coal_pct:
                gold += COAL_SELL
                energy_used += hits_coal * ENERGY_MINE
            elif r < gem_pct + coal_pct + ore_pct:
                gold += ore["sell"]
                bars += 1
                ores += 1
                energy_used += hits_ore * ENERGY_MINE
            else:
                stone += PLAIN_ROCK_STONE
                energy_used += hits_plain * ENERGY_MINE

    gold_if_bars = gold - ores * ore["sell"] + bars * ore["bar_sell"]

    return {"gold": gold, "gold_if_bars": gold_if_bars, "ores": ores,
            "bars": bars, "gems": gems, "gem_gold": gem_gold,
            "stone": stone, "energy": energy_used,
            "daily_avg": gold / max(1, days)}


# ============================================================
# TOWN TIMELINE
# ============================================================

def estimate_town_timeline():
    """
    Estimates which day each town stage can be completed.
    Uses conservative daily resource generation rates for a balanced player.
    """
    # Daily resource accumulation rates (conservative estimates)
    RATES = {
        "stone":          30.0,  # 3 mine visits/week * ~70 plain rocks * 3 stone
        "wood":           15.0,  # chopping trees daily
        "coal":            1.5,  # 4% coal rocks while mining
        "bar_bronce":      0.8,  # ~5-6 ore/visit, 3 visits/week
        "bar_plata":       0.4,
        "bar_oro":         0.2,
        "bar_broncastanio":0.1,
        "bar_chubestanio": 0.05,
        "bar_vitolanio":   0.0,  # 0 until Blacksmith opens (stage 5 done)
        "leather":         1.5,  # killing wild animals daily
        "pelt":            1.0,
        "yarn":            0.4,
        "cloth":           0.2,
        "thread":          0.3,
        "wool":            0.08, # from sheep
        "forage_any":     11.5,  # avg forage items/day
        "forage_flowers":  2.1,  # 11.5 * 22/119
        "forage_mush":     7.5,  # 11.5 * 78/119
        "gemstone":        0.15, # 1% gem rocks * ~15 rocks/visit * 3/week / 7
        "honey":           0.1,  # bear kill on Saturday + colmena
        "egg":             0.5,  # chickens
        "cheese":          0.15, # goats + prensa_queso
        "goat_cheese":     0.10,
        "butter":          0.15, # cows + mantequillera
        "fruit_any":       0.4,  # fruit trees (6-8 days initial + 2 days per fruit)
        "dye":             0.15, # slimes
        # Specific crops: available from farming
        "parsnip":         6.0,
        "carrot":          4.0,
        "onion":           4.0,
    }

    current_day = 0
    timeline = []
    blacksmith_open_day = None

    for i, stage in enumerate(TOWN_STAGES):
        label = stage["label"]
        construction = stage["construction_days"]
        reqs = {k: v for k, v in stage.items() if k not in ("label", "construction_days")}

        # Unlock bar_vitolanio rate after Blacksmith opens
        rates = dict(RATES)
        if blacksmith_open_day is not None:
            # After blacksmith: need ~20 extra days to unlock mine tier 8
            # Model as: effective rate = 0.04/day but add 20-day delay to days_needed
            rates["bar_vitolanio"] = 0.04  # slow but possible post-blacksmith
            rates["_bar_vitolanio_delay"] = 20  # days of mine-unlock delay

        blocker = {"resource": "none", "days": 0}
        max_days = 0

        for resource, qty in reqs.items():
            rate = rates.get(resource, 0.01)
            if rate <= 0:
                days_needed = 9999
            else:
                days_needed = math.ceil(qty / rate)
                # Add unlock delay if applicable
                delay_key = f"_{resource}_delay"
                days_needed += rates.get(delay_key, 0)
            if days_needed > blocker["days"]:
                blocker = {"resource": resource, "days": days_needed}
            if days_needed > max_days:
                max_days = days_needed

        completion_day = current_day + max_days + construction
        current_day = completion_day

        # Track when Blacksmith opens
        if "Herreria" in label and blacksmith_open_day is None:
            blacksmith_open_day = completion_day

        timeline.append({
            "label": label,
            "est_day": completion_day,
            "construction": construction,
            "blocker_resource": blocker["resource"],
            "blocker_days": blocker["days"],
            "feasible": completion_day <= YEAR_DAYS,
        })

    return timeline


# ============================================================
# CROP RANKING
# ============================================================

def crop_rankings():
    rows = []
    for name, c in CROPS.items():
        profit = c["sell"] - c["seed"]
        if profit <= 0:
            continue
        ppd = profit / c["days"]
        roi = profit / c["seed"] * 100
        rows.append({
            "name": name, "seed": c["seed"], "sell": c["sell"],
            "days": c["days"], "profit": profit, "ppd": ppd, "roi": roi,
            "seasons": "+".join(c["seasons"]),
            "jam": round(c["sell"] * JAM_MULTIPLIER),
        })
    rows.sort(key=lambda x: x["ppd"], reverse=True)
    return rows


# ============================================================
# FISH EXPECTED VALUE
# ============================================================

def fish_ev_by_season():
    result = {}
    for season in SEASONS:
        pool = [f for f in FISH if season in f["seasons"]]
        if not pool:
            pool = [f for f in FISH if "fall" in f["seasons"]]
        tw = sum(f["rarity"] for f in pool)
        ev = sum(f["rarity"] / tw * f["price_kg"] * (f["wt_min"] + f["wt_max"]) / 2 for f in pool)
        result[season] = {"ev": ev, "count": len(pool)}
    return result


# ============================================================
# MONTE CARLO RUNNER
# ============================================================

def run_simulation(iters=100):
    farm_res, forage_res, fish_res, mine_res = [], [], [], []

    for _ in range(iters):
        farm_res.append(simulate_farming_year(STARTING_GOLD, max_plots=100))
        forage_res.append(simulate_foraging(YEAR_DAYS))
        fish_res.append(simulate_fishing(YEAR_DAYS, casts_per_day=20))
        mine_res.append(simulate_mining(YEAR_DAYS, ore_tier=0, visits_per_week=3, pickaxe_dmg=1))

    def stats(lst, key):
        vals = [r[key] for r in lst]
        return avg_list(vals), min(vals), max(vals)

    farm_net, fnmin, fnmax = stats(farm_res, "net")
    farm_e, _, _ = stats(farm_res, "energy")
    forage_g, fgmin, fgmax = stats(forage_res, "gold")
    fish_g, figmin, figmax = stats(fish_res, "gold")
    fish_e, _, _ = stats(fish_res, "energy")
    mine_g, mgmin, mgmax = stats(mine_res, "gold")
    mine_bars, _, _ = stats(mine_res, "bars")
    mine_stone, _, _ = stats(mine_res, "stone")
    mine_gems, _, _ = stats(mine_res, "gems")
    mine_e, _, _ = stats(mine_res, "energy")

    season_data = {}
    for s in SEASONS:
        nets = [r["by_season"][s]["net"] if s != "winter" else 0 for r in farm_res]
        engs = [r["by_season"][s]["energy"] if s != "winter" else 0 for r in farm_res]
        season_data[s] = {"net": avg_list(nets), "energy": avg_list(engs)}

    return {
        "farm":   {"net": farm_net, "range": (fnmin, fnmax), "energy": farm_e,
                   "daily": farm_net / YEAR_DAYS, "by_season": season_data},
        "forage": {"gold": forage_g, "range": (fgmin, fgmax),
                   "daily": forage_g / YEAR_DAYS},
        "fish":   {"gold": fish_g, "range": (figmin, figmax), "energy": fish_e,
                   "daily": fish_g / YEAR_DAYS},
        "mine":   {"gold": mine_g, "range": (mgmin, mgmax), "energy": mine_e,
                   "daily": mine_g / YEAR_DAYS, "bars": mine_bars,
                   "stone": mine_stone, "gems": mine_gems},
    }


# ============================================================
# REPORT
# ============================================================

def print_report(res, iters=100):
    SEP = "=" * 72
    print(SEP)
    print("  VEREDAS DREAM — BALANCE REPORT  (1 año / 112 días)")
    print(f"  Monte Carlo: {iters} iteraciones | Energía: {ENERGY_PER_DAY}E/día")
    print(SEP)

    # ── CULTIVOS ──────────────────────────────────────────────
    print("\n┌─ RANKING CULTIVOS (profit/día/plot) ─────────────────────────────┐")
    print(f"  {'Cultivo':<16} {'Semilla':>7} {'Cosecha':>8} {'Días':>5} {'P/día':>6} {'ROI%':>5}  {'Jam':>5}  Temporada")
    print("  " + "─" * 68)
    ranks = crop_rankings()
    max_ppd = ranks[0]["ppd"]
    for r in ranks:
        flag = "▲▲" if r["ppd"] >= 4.0 else ("▲ " if r["ppd"] >= 2.5 else "  ")
        print(f"  {flag}{r['name']:<14} {r['seed']:>7}g {r['sell']:>7}g {r['days']:>5}d "
              f"{r['ppd']:>5.1f}g {r['roi']:>4.0f}% {r['jam']:>6}g  {r['seasons']}")
    print(f"\n  💡 Mermelada ×{JAM_MULTIPLIER}: blueberry={72*JAM_MULTIPLIER:.0f}g, "
          f"pineapple={84*JAM_MULTIPLIER:.0f}g, grapes={56*JAM_MULTIPLIER:.0f}g")

    # ── FARMING ───────────────────────────────────────────────
    f = res["farm"]
    print(f"\n┌─ FARMING (100 plots, reinversión, start {STARTING_GOLD}g) ─────────────────┐")
    print(f"  Profit neto/año: {f['net']:>8,.0f}g  [{f['range'][0]:,.0f}–{f['range'][1]:,.0f}]")
    print(f"  Profit neto/día: {f['daily']:>8.0f}g")
    print(f"  Energía/año:     {f['energy']:>8,.0f}E  = {f['energy']/(YEAR_DAYS*ENERGY_PER_DAY)*100:.1f}% del total disponible")
    print("\n  Por temporada:")
    for s in SEASONS:
        sd = f["by_season"][s]
        b = bar(sd["net"], f["net"] / 3 if f["net"] else 1, 20)
        print(f"    {s.capitalize():<8} {sd['net']:>8,.0f}g net  [{b}]  {sd['energy']:>6,.0f}E")

    # ── FORAGING ─────────────────────────────────────────────
    fo = res["forage"]
    print(f"\n┌─ FORAGING (8–15 items/día, 0E, 1 raro garantizado c/3 días) ────┐")
    print(f"  Ingreso/año: {fo['gold']:>8,.0f}g  [{fo['range'][0]:,.0f}–{fo['range'][1]:,.0f}]")
    print(f"  Ingreso/día: {fo['daily']:>8.1f}g  (pasivo, no consume energía)")

    # ── PESCA ────────────────────────────────────────────────
    fi = res["fish"]
    fev = fish_ev_by_season()
    print(f"\n┌─ PESCA (20 lanzamientos/día, {ENERGY_FISH}E/pez capturado) ────────────────┐")
    print(f"  Ingreso/año: {fi['gold']:>8,.0f}g  [{fi['range'][0]:,.0f}–{fi['range'][1]:,.0f}]")
    print(f"  Ingreso/día: {fi['daily']:>8.1f}g")
    print(f"  Energía/año: {fi['energy']:>8,.0f}E  = {fi['energy']/(YEAR_DAYS*ENERGY_PER_DAY)*100:.1f}% del total")
    print("\n  Valor esperado por pez / temporada:")
    for s in SEASONS:
        ev = fev[s]
        print(f"    {s.capitalize():<8} {ev['ev']:>6.1f}g/pez  → {ev['ev']*20:>7.0f}g/día (20 lanzamientos) "
              f"[{ev['count']} especies]")

    # ── MINERÍA ───────────────────────────────────────────────
    mi = res["mine"]
    print(f"\n┌─ MINERÍA (3 visitas/sem, piso 1 ore_bronce, pico oxidado) ──────┐")
    print(f"  Ingreso/año (raw ore):  {mi['gold']:>8,.0f}g  [{mi['range'][0]:,.0f}–{mi['range'][1]:,.0f}]")
    print(f"  Ingreso/año (si funde): {mi['gold']+(mi['bars']*(7-3)):>8,.0f}g  (bar_bronce vale 7g vs 3g raw)")
    print(f"  Gemas/año:              {mi['gems']:>8.0f}")
    print(f"  Piedra/año:             {mi['stone']:>8,.0f}  ← crítico para town donations")
    print(f"  Energía/año:            {mi['energy']:>8,.0f}E")

    # ── COMPARATIVA ────────────────────────────────────────────
    print(f"\n┌─ COMPARATIVA DE INGRESOS/DÍA ───────────────────────────────────┐")
    print(f"  {'Actividad':<14} {'G/día':>8}  {'Barra':25}  {'E/día':>8}  {'G/E':>8}")
    print("  " + "─" * 68)
    max_d = max(f["daily"], fo["daily"], fi["daily"], mi["daily"])
    acts = [
        ("Farming",  f["daily"],  f["energy"] / YEAR_DAYS),
        ("Foraging", fo["daily"], 0),
        ("Pesca",    fi["daily"], fi["energy"] / YEAR_DAYS),
        ("Mineria",  mi["daily"], mi["energy"] / YEAR_DAYS),
    ]
    for name, gday, eday in acts:
        b = bar(gday, max_d, 25)
        ge = f"{gday/eday:.2f}g/E" if eday > 0 else "inf (gratis)"
        print(f"  {name:<14} {gday:>7.0f}g  [{b}]  {eday:>6.0f}E  {ge:>10}")

    # ── TOWN TIMELINE ──────────────────────────────────────────
    timeline = estimate_town_timeline()
    print(f"\n┌─ TOWN RESTORATION — Timeline Estimado ──────────────────────────┐")
    print(f"  (supuestos: 30 stone/día, 15 wood/día, mining casual 3 veces/sem)")
    print(f"\n  {'Etapa':<28} {'Día est.':>8} {'Const.':>6} {'¿OK?':>6}  Blocker")
    print("  " + "─" * 68)
    for t in timeline:
        ok = "✓" if t["feasible"] else "✗ NO"
        const_str = f"{t['construction']}d" if t["construction"] > 0 else "—"
        print(f"  {t['label']:<28} día {t['est_day']:>3}    {const_str:>4}   {ok:>4}   "
              f"{t['blocker_resource']} ({t['blocker_days']:.0f}d)")

    total_const = sum(s["construction_days"] for s in TOWN_STAGES)
    last_stage = timeline[-1]
    print(f"\n  Total días de construcción: {total_const} días")
    print(f"  Etapa final estimada: día {last_stage['est_day']} de {YEAR_DAYS}")
    feasible_count = sum(1 for t in timeline if t["feasible"])
    print(f"  Etapas alcanzables en 1 año: {feasible_count}/{len(TOWN_STAGES)}")

    # ── ALERTAS ───────────────────────────────────────────────
    print(f"\n┌─ ALERTAS DE BALANCE ────────────────────────────────────────────┐")

    def alert(level, msg):
        icons = {"OK": "✓ OK  ", "WARN": "⚠ WARN", "ALERT": "🚨 "}
        print(f"  [{icons.get(level, level)}] {msg}")

    # 1. Pesca vs farming
    ratio = fi["daily"] / max(1, f["daily"])
    if ratio > 3.0:
        alert("ALERT", f"Pesca ({fi['daily']:.0f}g/día) es {ratio:.1f}x farming ({f['daily']:.0f}g/día) — "
              "considera reducir casts/día o aumentar costo de energía")
    elif ratio > 1.5:
        alert("WARN",  f"Pesca ({fi['daily']:.0f}g/día) es {ratio:.1f}x farming — revisar si está equilibrado")
    else:
        alert("OK",    f"Pesca ({fi['daily']:.0f}g/día) vs Farming ({f['daily']:.0f}g/día) ratio {ratio:.1f}x")

    # 2. Energía pesca vs disponible
    fish_e_day = fi["energy"] / YEAR_DAYS
    if fish_e_day > ENERGY_PER_DAY * 0.5:
        alert("WARN", f"Pesca usa {fish_e_day:.0f}E/día ({fish_e_day/ENERGY_PER_DAY*100:.0f}%) — "
              "con farming simultáneo puede quedarse sin energía")
    else:
        alert("OK",   f"Pesca usa {fish_e_day:.0f}E/día — compatible con farming ({f['energy']/YEAR_DAYS:.0f}E/día)")

    # 3. Cultivos con ROI bajo
    bad = [r for r in ranks if r["ppd"] < 1.0]
    if bad:
        alert("WARN", f"{len(bad)} cultivo(s) < 1g/día/plot: {', '.join(r['name'] for r in bad)}")
    else:
        alert("OK", "Todos los cultivos dan > 1g/día/plot")

    # 4. Brecha mejor vs peor cultivo
    ratio_crops = ranks[0]["ppd"] / ranks[-1]["ppd"]
    if ratio_crops > 12:
        alert("ALERT", f"Brecha cultivos: {ranks[0]['name']} ({ranks[0]['ppd']:.1f}g/d) es "
              f"{ratio_crops:.0f}x mejor que {ranks[-1]['name']} ({ranks[-1]['ppd']:.1f}g/d)")
    else:
        alert("OK", f"Brecha cultivos {ratio_crops:.0f}x (mejor vs peor) — razonable")

    # 5. Town feasibility
    infeasible = [t for t in timeline if not t["feasible"]]
    if infeasible:
        alert("ALERT", f"{len(infeasible)} etapa(s) NO alcanzables en 1 año: " +
              ", ".join(t["label"][:20] for t in infeasible))
    else:
        alert("OK", f"Todas las etapas del town son teóricamente alcanzables en {YEAR_DAYS} días")

    # 6. Stone/wood totals
    stone_need = sum(s.get("stone", 0) for s in TOWN_STAGES)
    wood_need  = sum(s.get("wood", 0) for s in TOWN_STAGES)
    stone_avail = 30 * YEAR_DAYS
    wood_avail  = 15 * YEAR_DAYS
    if stone_avail < stone_need:
        alert("ALERT", f"Stone: necesita {stone_need} total, sólo ~{stone_avail} disponibles/año "
              f"(déficit {stone_need-stone_avail})")
    else:
        alert("OK", f"Stone: necesita {stone_need}, produce ~{stone_avail}/año — cubierto")
    if wood_avail < wood_need:
        alert("ALERT", f"Wood: necesita {wood_need} total, sólo ~{wood_avail} disponibles/año "
              f"(déficit {wood_need-wood_avail})")
    else:
        alert("OK", f"Wood: necesita {wood_need}, produce ~{wood_avail}/año — cubierto")

    # 7. Bar_chubestanio
    chu_need = sum(s.get("bar_chubestanio", 0) for s in TOWN_STAGES)
    chu_avail = 0.05 * YEAR_DAYS
    alert("WARN" if chu_avail < chu_need else "OK",
          f"bar_chubestanio: necesita {chu_need} total, produce ~{chu_avail:.0f}/año con minería casual "
          f"({'INSUFICIENTE' if chu_avail < chu_need else 'suficiente'})")

    # 8. Bar_vitolanio chain
    vito_need = sum(s.get("bar_vitolanio", 0) for s in TOWN_STAGES)
    alert("WARN", f"bar_vitolanio: necesita {vito_need} total — solo disponible post-Blacksmith. "
          "Cadena: abrir Herrero → upgrade pickaxe → desbloquear mine tier 8 → minar. "
          "Verificar que mine_unlocks[7] NO requiera town_stage (sería circular).")

    # 9. Tool upgrade cap (fixed)
    alert("OK", "Cap de upgrades antes de Blacksmith = QUALITY.ORO (tier 4, 1-indexed). "
          "Correcto: max sin herrero = ORO. Con herrero = VITOLANIO.")

    # 10. Animal products for stage 3→5
    alert("WARN", "Stage 3→5 (Tienda): requiere cheese×20, goat_cheese×15, butter×20. "
          "Necesita cabras + vacas + prensa_queso + mantequillera. "
          "Con 0.15 cheese/día + 0.15 butter/día → ~66-133 días para acumularlos. "
          "Asegurarse de que las máquinas sean accesibles antes de esta etapa.")

    # 11. Fruit_any for stage 3→5
    alert("WARN", "Stage 3→5: requiere fruit_any×50. Árboles frutales: 6-8 días para madurar, "
          "luego 1 fruta cada 2 días. Con 3 árboles: ~33 días + tiempo inicial. "
          "El jugador debe plantar árboles desde el inicio del juego.")

    print(f"\n{SEP}")
    print("  FIN DEL REPORTE")
    print(f"  Para sensibilidad: modificar casts_per_day, ore_tier, visits_per_week,")
    print(f"  max_plots, o las tasas diarias en estimate_town_timeline().")
    print(SEP)


# ============================================================
# MAIN
# ============================================================

if __name__ == "__main__":
    ITERS = 100
    random.seed(42)

    print(f"\nEjecutando {ITERS} iteraciones...", end=" ", flush=True)
    results = run_simulation(ITERS)
    print("listo.\n")
    print_report(results, ITERS)
