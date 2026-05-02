"""
Verificacion final del balance economico
Con los nuevos precios y costos de energia
"""
import random, statistics

random.seed(42)

MAX_ENERGY = 500
START_MONEY = 200
DAYS = 30
COST_HOE = 2; COST_WATER = 2; COST_HARVEST = 2; COST_FISH = 10; COST_INSECT = 6

CROPS = {
    "parsnip":  {"seed":10,"sell":30,"days":5},
    "potato":   {"seed":15,"sell":40,"days":6},
    "broccoli": {"seed":20,"sell":50,"days":5},
    "cauliflower":{"seed":25,"sell":60,"days":6},
    "asparagus":{"seed":25,"sell":65,"days":5},
    "strawberry":{"seed":30,"sell":75,"days":6},
    "blueberry":{"seed":35,"sell":95,"days":6},
}

FISH = [(20,9,1.5,4.0),(20,12,0.8,3.0),(50,17,0.2,0.8),(50,9,0.3,1.2),
    (50,5,0.8,3.0),(20,8,1.0,4.0),(50,11,0.2,1.0),(7,2,10,50),
    (7,29,0.5,3.0),(7,1,30,100),(20,1,20,80),(50,7,0.8,2.5),
    (50,25,0.05,0.15),(50,20,0.04,0.12),(50,6,0.5,2.5),(20,9,1.0,5.0),
    (20,27,0.3,1.5),(20,15,0.5,2.0),(20,6,2.0,8.0),(20,15,0.5,3.0),
    (20,11,0.8,3.0),(50,27,0.2,0.8),(50,15,0.2,0.8),(50,15,0.2,0.6),(20,4,2.0,8.0)]
fish_pool = []
for r,pp,wmin,wmax in FISH:
    for _ in range(r): fish_pool.append((pp,wmin,wmax))

FORAGE_PRICES = [(2,50),(4,20),(8,7),(20,2),(51,1)]
forage_pool = []
for p,w in FORAGE_PRICES:
    for _ in range(w): forage_pool.append(p)

INSECTS = [(2,50),(3,50),(2,50),(6,20),(5,20),(7,20),
    (3,50),(3,50),(4,50),(8,20),(9,20),(10,20),(10,20),(11,20),(12,20),(10,20),
    (18,7),(20,7),(20,7),(20,7),(22,7),(20,7),(25,7),(22,7),(22,7),
    (35,2),(40,2),(45,2),(40,2),(35,2),(65,1),(80,1)]
insect_pool = []
for p,w in INSECTS:
    for _ in range(w): insect_pool.append(p)

def simulate(strategy_name, choose_fn):
    money = START_MONEY
    fields = []
    for _ in range(10): fields.append(("parsnip",1,6))
    total_earned = 0; total_spent = 0
    daily_income = []; daily_expenses = []
    harvest_inc = 0; fish_inc = 0; forage_inc = 0; bug_inc = 0

    for day in range(1, DAYS+1):
        energy = MAX_ENERGY
        income = 0

        # water
        n_water = sum(1 for f in fields if f[2] > day)
        cost_w = min(n_water * COST_WATER, energy)
        energy -= cost_w

        # harvest
        ready = [f for f in fields if f[2] <= day]
        fields = [f for f in fields if f[2] > day]
        cost_h = min(len(ready) * COST_HARVEST, energy)
        energy -= cost_h
        for f in ready:
            sell = CROPS[f[0]]["sell"]
            money += sell
            income += sell
            harvest_inc += sell

        # plant
        crop = choose_fn(money)
        info = CROPS[crop]
        n_buy = min(money // info["seed"], energy // COST_HOE)
        if n_buy > 0:
            money -= n_buy * info["seed"]
            total_spent += n_buy * info["seed"]
            energy -= n_buy * COST_HOE
            for _ in range(n_buy):
                fields.append((crop, day, day + info["days"]))

        # fish
        n_fish = energy // COST_FISH
        fi = 0
        for _ in range(n_fish):
            if energy < COST_FISH: break
            energy -= COST_FISH
            pp,wmin,wmax = random.choice(fish_pool)
            w = random.uniform(wmin,wmax)
            v = round(pp * w)
            fi += v
        if fi > 0: money += fi; income += fi; fish_inc += fi

        # forage
        n_forage = random.randint(8,15)
        fo = sum(random.choice(forage_pool) for _ in range(n_forage))
        money += fo; income += fo; forage_inc += fo

        # bugs
        n_bugs = min(random.randint(5,10), energy // COST_INSECT)
        bi = 0
        for _ in range(n_bugs):
            if energy < COST_INSECT: break
            energy -= COST_INSECT
            bi += random.choice(insect_pool)
        if bi > 0: money += bi; income += bi; bug_inc += bi

        total_earned += income
        daily_income.append(income)

    return money, total_earned, total_spent, harvest_inc, fish_inc, forage_inc, bug_inc, len(fields)

def high_profit(m):
    if m >= 35: return "blueberry"
    elif m >= 30: return "strawberry"
    elif m >= 25: return "asparagus"
    elif m >= 20: return "broccoli"
    elif m >= 15: return "potato"
    elif m >= 10: return "parsnip"
    return "parsnip"

def quantity(m):
    if m >= 10: return "parsnip"
    return "parsnip"

print("="*60)
print("VERIFICACION FINAL - BALANCE ECONOMICO")
print("30 DIAS - PRIMAVERA")
print("="*60)
print()
print("Nuevos valores:")
print("  - Insectos: precios reducidos ~60%, energia 6 por uso")
print("  - Pesca: sardina/boqueron ajustados, caballito/dragon reducidos")
print("  - Semillas: mas baratas (parsnip 10, blueberry 35)")
print("  - Cosechas: mas caras (parsnip 30, blueberry 95)")
print("  - Sin items debug en inventario inicial")
print()

for sname, sfunc in [("Alta rentabilidad", high_profit), ("Cantidad (parsnip)", quantity)]:
    results = []
    for t in range(10):
        random.seed(42 + t)
        r = simulate(sname, sfunc)
        results.append(r[0])

    avg = statistics.mean(results)
    rng = (min(results), max(results))

    r = simulate(sname, sfunc)  # one detailed run
    _, earned, spent, hi, fi, foi, bi, fields = r

    print("-- %s --" % sname)
    print("  Dinero final (prom 10): $%.0f  [%d-%d]" % (avg, rng[0], rng[1]))
    print("  Ganancia neta: $%.0f" % (avg - START_MONEY))
    tot = hi + fi + foi + bi
    print("  Ingresos: cultivos=%d(%.0f%%) pesca=%d(%.0f%%) forrajeo=%d(%.0f%%) insectos=%d(%.0f%%)" 
          % (hi, hi/tot*100, fi, fi/tot*100, foi, foi/tot*100, bi, bi/tot*100))
    print()

print("="*60)
print("EFICIENCIA POR ENERGIA (NUEVA)")
print("="*60)
print()
print("  Actividad     | $/energia")
print("  ------------- | --------")
print("  Forrajeo      |  inf (gratis, ~$48/dia limitado)")
print("  Insectos      |  $1.30/energia (6 energia/uso)")
print("  Pesca         |  $1.38/energia (10 energia/uso)")
print("  Parsnip       |  $1.43/energia")
print("  Blueberry     |  $3.75/energia")
print()
print("  Rango total: $1.30 - $3.75/energia (sin contar forrajeo gratuito)")
print("  Diferencia maxima: 2.9x (antes era 20x+)")
