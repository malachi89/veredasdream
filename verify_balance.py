import random, statistics
random.seed(42)

MAX_ENERGY = 500; START_MONEY = 200; DAYS = 30
COST_HOE = 2; COST_WATER = 2; COST_HARVEST = 2; COST_FISH = 10; COST_INSECT = 6

CROPS = {
    "parsnip":{"seed":10,"sell":24,"days":5},"potato":{"seed":15,"sell":34,"days":6},
    "broccoli":{"seed":20,"sell":42,"days":5},"cauliflower":{"seed":25,"sell":50,"days":6},
    "asparagus":{"seed":25,"sell":55,"days":5},"strawberry":{"seed":30,"sell":60,"days":6},
    "blueberry":{"seed":35,"sell":80,"days":6},
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

FORAGE = [(2,50),(4,20),(8,7),(20,2),(51,1)]
forage_pool = []
for p,w in FORAGE:
    for _ in range(w): forage_pool.append(p)

INSECTS = [(2,50),(3,50),(2,50),(6,20),(5,20),(7,20),
    (3,50),(3,50),(4,50),(8,20),(9,20),(10,20),(10,20),(11,20),(12,20),(10,20),
    (18,7),(20,7),(20,7),(20,7),(22,7),(20,7),(25,7),(22,7),(22,7),
    (35,2),(40,2),(45,2),(40,2),(35,2),(65,1),(80,1)]
insect_pool = []
for p,w in INSECTS:
    for _ in range(w): insect_pool.append(p)

def simulate(choose_fn):
    money = START_MONEY
    fields = []
    for _ in range(10): fields.append(("parsnip",1,6))
    total_earned = 0; total_spent = 0
    hi_all = 0; fi_all = 0; foi_all = 0; bi_all = 0
    daily_money = [(0, money)]

    for day in range(1, DAYS+1):
        energy = MAX_ENERGY

        wc = sum(1 for f in fields if f[2] > day)
        energy -= min(wc * COST_WATER, energy)

        ready = [f for f in fields if f[2] <= day]
        fields = [f for f in fields if f[2] > day]
        energy -= min(len(ready) * COST_HARVEST, energy)
        hi = 0
        for f in ready:
            v = CROPS[f[0]]["sell"]
            money += v; hi += v; hi_all += v

        crop = choose_fn(money)
        info = CROPS[crop]
        nb = min(money // info["seed"], energy // COST_HOE)
        if nb > 0:
            money -= nb * info["seed"]
            total_spent += nb * info["seed"]
            energy -= nb * COST_HOE
            for _ in range(nb):
                fields.append((crop, day, day + info["days"]))

        nf = energy // COST_FISH
        fi = 0
        for _ in range(nf):
            if energy < COST_FISH: break
            energy -= COST_FISH
            pp,wmin,wmax = random.choice(fish_pool)
            fi += round(pp * random.uniform(wmin,wmax))
        if fi: money += fi; fi_all += fi; hi += fi

        nfo = random.randint(8,15)
        fo = sum(random.choice(forage_pool) for _ in range(nfo))
        money += fo; foi_all += fo; hi += fo

        nbi = min(random.randint(5,10), energy // COST_INSECT)
        bi = 0
        for _ in range(nbi):
            if energy < COST_INSECT: break
            energy -= COST_INSECT
            bi += random.choice(insect_pool)
        if bi: money += bi; bi_all += bi; hi += bi

        total_earned += hi
        daily_money.append((day, money))

    return money, total_earned, total_spent, hi_all, fi_all, foi_all, bi_all, len(fields), daily_money

def high_profit(m):
    if m >= 35: return "blueberry"
    elif m >= 30: return "strawberry"
    elif m >= 25: return "asparagus"
    elif m >= 20: return "broccoli"
    elif m >= 15: return "potato"
    return "parsnip"

print("Balance final - 30 dias en primavera")
print("Nuevos precios de cultivos (ajuste moderado)")
print()

for sname, sfunc in [("Alta rentabilidad", high_profit)]:
    res = []
    for t in range(10):
        random.seed(42+t)
        r = simulate(sfunc)
        res.append(r[0])
    avg = statistics.mean(res)
    print("Dinero final (prom 10 trials): $%.0f" % avg)
    print("Ganancia neta: $%.0f" % (avg-START_MONEY))

    r = simulate(sfunc)
    m, earned, spent, hi, fi, foi, bi, fld, dm = r
    tot = hi+fi+foi+bi
    print("Campos activos al dia 30: %d" % fld)
    print("Cultivos: $%d (%d%%)  Pesca: $%d (%d%%)  Forrajeo: $%d (%d%%)  Insectos: $%d (%d%%)" % (
        hi, hi/tot*100, fi, fi/tot*100, foi, foi/tot*100, bi, bi/tot*100))
    print("Progresion:")
    for d, mny in dm:
        if d % 5 == 0:
            print("  Dia %2d: $%d" % (d, mny))
    print()

# Quick efficiency check
print("---")
print("Eficiencia por energia:")
print("  Forrajeo: gratis ($48/dia limitado)")
print("  Insectos: $1.30/energia (6 energia/uso)")
print("  Pesca: $1.38/energia")
print("  Parsnip: $%.2f/energia" % ((24-10)/(2+10+2)))
print("  Blueberry: $%.2f/energia" % ((80-35)/(2+12+2)))
