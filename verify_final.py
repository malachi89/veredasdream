import random, statistics
random.seed(42)
MAX_ENERGY=500;START=200;DAYS=30
C2=2;C10=10;C6=6
CROPS={"parsnip":{"s":12,"p":22,"d":5},"potato":{"s":18,"p":32,"d":6},
"broccoli":{"s":22,"p":40,"d":5},"cauliflower":{"s":28,"p":46,"d":6},
"asparagus":{"s":28,"p":50,"d":5},"strawberry":{"s":35,"p":56,"d":6},
"blueberry":{"s":40,"p":72,"d":6}}
FISH=[(20,9,1.5,4),(20,12,.8,3),(50,17,.2,.8),(50,9,.3,1.2),
(50,5,.8,3),(20,8,1,4),(50,11,.2,1),(7,2,10,50),(7,29,.5,3),
(7,1,30,100),(20,1,20,80),(50,7,.8,2.5),(50,25,.05,.15),
(50,20,.04,.12),(50,6,.5,2.5),(20,9,1,5),(20,27,.3,1.5),
(20,15,.5,2),(20,6,2,8),(20,15,.5,3),(20,11,.8,3),
(50,27,.2,.8),(50,15,.2,.8),(50,15,.2,.6),(20,4,2,8)]
fp=[]
for r,p,w1,w2 in FISH:
 for _ in range(r):fp.append((p,w1,w2))
FORAGE=[(2,50),(4,20),(8,7),(20,2),(51,1)]
fg=[]
for p,w in FORAGE:
 for _ in range(w):fg.append(p)
INSECTS=[(2,50),(3,50),(2,50),(6,20),(5,20),(7,20),
(3,50),(3,50),(4,50),(8,20),(9,20),(10,20),(10,20),(11,20),(12,20),(10,20),
(18,7),(20,7),(20,7),(20,7),(22,7),(20,7),(25,7),(22,7),(22,7),
(35,2),(40,2),(45,2),(40,2),(35,2),(65,1),(80,1)]
ip=[]
for p,w in INSECTS:
 for _ in range(w):ip.append(p)

def sim(fn):
 m=START;fs=[];he=0;fe=0;foe=0;be=0
 for _ in range(10):fs.append(("parsnip",1,6))
 for d in range(1,DAYS+1):
  e=MAX_ENERGY
  e-=min(sum(1 for f in fs if f[2]>d)*C2,e)
  r=[f for f in fs if f[2]<=d];fs=[f for f in fs if f[2]>d]
  e-=min(len(r)*C2,e)
  for f in r:v=CROPS[f[0]]["p"];m+=v;he+=v
  c=fn(m);ci=CROPS[c]
  nb=min(m//ci["s"],e//C2)
  if nb>0:m-=nb*ci["s"];e-=nb*C2
  for _ in range(nb):fs.append((c,d,d+ci["d"]))
  nf=e//C10;fi=0
  for _ in range(nf):
   if e<C10:break
   e-=C10;pp,w1,w2=random.choice(fp);fi+=round(pp*random.uniform(w1,w2))
  if fi:m+=fi;fe+=fi
  nfo=random.randint(8,15)
  fo=sum(random.choice(fg) for _ in range(nfo))
  m+=fo;foe+=fo
  nbi=min(random.randint(5,10),e//C6);bi=0
  for _ in range(nbi):
   if e<C6:break
   e-=C6;bi+=random.choice(ip)
  if bi:m+=bi;be+=bi
 return m,he,fe,foe,be,len(fs)

def hi(m):
 if m>=40:return"blueberry"
 elif m>=35:return"strawberry"
 elif m>=28:return"asparagus"
 elif m>=22:return"broccoli"
 elif m>=18:return"potato"
 return"parsnip"
def lo(m):
 if m>=12:return"parsnip"
 return"parsnip"

print("VERIFICACION FINAL")
print()
for sn,sf in [("Alta rentabilidad",hi),("Solo parsnip",lo)]:
 rs=[]
 for t in range(10):
  random.seed(42+t);rs.append(sim(sf)[0])
 avg=statistics.mean(rs)
 r=sim(sf);he,fe,foe,be,fld=r[1],r[2],r[3],r[4],r[5]
 print("%s:"%sn)
 print("  Dinero final (prom 10): $%.0f  [%d-%d]"%(avg,min(rs),max(rs)))
 print("  Ganancia neta: $%.0f"%(avg-START))
 t=he+fe+foe+be
 print("  Cultivos=%d(%d%%) Pesca=%d(%d%%) Forrajeo=%d(%d%%) Insectos=%d(%d%%)"%
       (he,he/t*100,fe,fe/t*100,foe,foe/t*100,be,be/t*100))
 print("  Campos activos al dia 30: %d"%fld)
 print()

print("---")
print("$/energia:")
print("  Forrajeo: gratis")
print("  Insectos: $%.2f/energia"%(sum(random.choice(ip)for _ in range(10000))/10000/6))
fi=sum(round(p*random.uniform(w1,w2))for _ in range(10000)for p,w1,w2 in[random.choice(fp)])/10000
print("  Pesca: $%.2f/energia"%(fi/10))
for k,v in sorted(CROPS.items(),key=lambda x:x[1]["p"]-x[1]["s"]):
 e=v["d"]*2+4;pr=v["p"]-v["s"]
 print("  %s: $%.2f/energia (seed %d, sell %d, profit %d)"%(k,pr/e,v["s"],v["p"],pr))
