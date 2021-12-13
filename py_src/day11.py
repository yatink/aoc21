little_test = """5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"""

big_test = """7147713556
6167733555
5183482118
3885424521
7533644611
3877764863
7636874333
8687188533
7467115265
1626573134"""

from itertools import product
from functools import cache

@cache
def get_span(p):
    if p <= 0:
        adj_p = [p, p + 1]
    elif p >= 9:
        adj_p = [p - 1, p]
    else:
        adj_p = [p + 1, p, p - 1]
    return adj_p

@cache
def adjacent_coords(x, y):
    x_span = get_span(x)
    y_span = get_span(y)
    return list(
        (ix, iy)
        for (ix, iy) in product(x_span, y_span)
        if not (ix == x and iy == y)
    )

def parse_input(inpt):
    lines = inpt.split("\n")
    octopii = []
    for line in lines:
        octopii.append([int(x) for x in line])
    return octopii

all_indexes = [(x,y) for (x,y) in product(range(10), repeat=2)]

def step(octopii):
    for (x,y) in all_indexes:
        octopii[y][x] += 1
    total_glowing = set()
    while True:
        glowing = {(x,y)
                   for (x,y) in all_indexes
                   if octopii[y][x] > 9 and (x,y) not in total_glowing}
        total_glowing |= glowing
        if not glowing:
            break
        for (x,y) in glowing:
            for (x1, y1) in adjacent_coords(x,y):
                octopii[y1][x1] += 1
    for (x,y) in total_glowing:
        octopii[y][x] = 0
    return len(total_glowing)


def print_pattern(octopii):
    for line in octopii:
        print(''.join(map(str,line)))
    print('\n')
                

def part1(inpt):
    octopii = parse_input(inpt)
    print_pattern(octopii)
    print(0)
    total_flashes = 0
    for x in range(100):
        flashes = step(octopii)
        total_flashes += flashes
        if x % 10 == 0:
            print("Step %s" % (x+1))
            print_pattern(octopii)
            print (flashes)
    print(total_flashes)


def part2(inpt):
    octopii = parse_input(inpt)
    for x in range(1000):
        flashes = step(octopii)
        if flashes == 100:
            return x+1
    print("Nothing yet")
    
print(part2(little_test))
print(part2(big_test))
