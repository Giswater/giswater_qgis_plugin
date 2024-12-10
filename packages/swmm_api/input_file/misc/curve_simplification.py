"""
Python package:
https://github.com/fhirschmann/rdp

ist aber nicht schnell (Faktor 10 langsamer)

https://en.wikipedia.org/wiki/Ramer–Douglas–Peucker_algorithm

Code von hier:
https://stackoverflow.com/questions/2573997/reduce-number-of-points-in-line#10934629
"""


def _vec2d_dist(p1, p2):
    return (p1[0] - p2[0])**2 + (p1[1] - p2[1])**2


def _vec2d_sub(p1, p2):
    return p1[0]-p2[0], p1[1]-p2[1]


def _vec2d_mult(p1, p2):
    return p1[0]*p2[0] + p1[1]*p2[1]


def ramer_douglas(line, dist):
    """Does Ramer-Douglas-Peucker simplification of a curve with `dist`
    threshold.

    `line` is a list-of-tuples, where each tuple is a 2D coordinate

    Usage is like so:

    >>> myline = [(0.0, 0.0), (1.0, 2.0), (2.0, 1.0)]
    >>> simplified = ramer_douglas(myline, dist = 1.0)
    """

    if len(line) < 3:
        return line

    begin = line[0]
    end = line[-1] if line[0] != line[-1] else line[-2]

    distSq = []
    for curr in line[1:-1]:
        tmp = (
            _vec2d_dist(begin, curr) - _vec2d_mult(_vec2d_sub(end, begin), _vec2d_sub(curr, begin)) ** 2 / _vec2d_dist(begin, end))
        distSq.append(tmp)

    maxdist = max(distSq)
    if maxdist < dist ** 2:
        return [begin, end]

    pos = distSq.index(maxdist)
    return (ramer_douglas(line[:pos + 2], dist) +
            ramer_douglas(line[pos + 1:], dist)[1:])
