with open('simular_economia.py', 'r', encoding='utf-8') as f:
    content = f.read()

old = """for cname, cdata in sorted(CROPS.items(), key=lambda x: x[1][\"profit_per_day\"]):
    energy_per_cycle = COST_HOE + COST_HARVEST + COST_WATER * cdata[\"days\"]
    profit_per_energy = cdata[\"profit\"] / energy_per_cycle if energy_per_cycle > 0 else 0
    print(f\"     {cname:15s} | ${cdata['seed']:>3d} semilla | ${cdata['sell']:>2d} venta | \"
          f\"${cdata['profit']:>2d} ganancia | {cdata['days']}dias | \"
          f\"${profit_per_energy:.2f}/energia | ${cdata['profit_per_day']:.2f}/dia\")"""

new = """for cname, cdata in sorted(CROPS.items(), key=lambda x: x[1][\"profit\"]/x[1][\"days\"]):
    energy_per_cycle = COST_HOE + COST_HARVEST + COST_WATER * cdata[\"days\"]
    profit_per_energy = cdata[\"profit\"] / energy_per_cycle if energy_per_cycle > 0 else 0
    ppd = cdata[\"profit\"] / cdata[\"days\"]
    print(f\"     {cname:15s} | ${cdata['seed']:>3d} semilla | ${cdata['sell']:>2d} venta | \"
          f\"${cdata['profit']:>2d} ganancia | {cdata['days']}dias | \"
          f\"${profit_per_energy:.2f}/energia | ${ppd:.2f}/dia\")"""

content = content.replace(old, new)

with open('simular_economia.py', 'w', encoding='utf-8') as f:
    f.write(content)
print('Done')
