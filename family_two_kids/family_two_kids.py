from random import SystemRandom

def random_kid():
    """Randomly returns boy or girl"""
    return random.choice(["boy", "girl"])

random = SystemRandom ()

both_girls = 0
older_girl = 0
either_girl = 0

for _ in range(10000):
    younger = random_kid()
    older = random_kid()
    if older == "girl":
        older_girl += 1
    if older == "girl" and younger == "girl":
        both_girls += 1
    if older == "girl" or younger == "girl":
        either_girl += 1

print(f"P(both | older): {both_girls / older_girl}") # 0.514 ~ 1/2
print(f"P(both | either): {both_girls / either_girl}") # 0.342 ~ 1/3