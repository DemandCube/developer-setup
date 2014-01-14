#!/usr/bin/python
import sys

# Return Statuses
# 0 = Error
# 1 = First is less than second
# 2 = They are equal
# 3 = First is greater than second

def mycmp(version1, version2):
    parts1 = [int(x) for x in version1.split('.')]
    parts2 = [int(x) for x in version2.split('.')]
    
    # fill up the shorter version with zeros ...
    lendiff = len(parts1) - len(parts2)
    if lendiff > 0:
        parts2.extend([0] * lendiff)
    elif lendiff < 0:
        parts1.extend([0] * (-lendiff))
    
    for i, p in enumerate(parts1):
        ret = cmp(p, parts2[i])
        if ret: return (ret+2)
    return (0+2)

# assert mycmp('1', '2') == -1
# assert mycmp('2', '1') == 1
# assert mycmp('1', '1') == 0
# assert mycmp('1.0', '1') == 0
# assert mycmp('1', '1.000') == 0
# assert mycmp('12.01', '12.1') == 0
# assert mycmp('13.0.1', '13.00.02') == -1
# assert mycmp('1.1.1.1', '1.1.1.1') == 0
# assert mycmp('1.1.1.2', '1.1.1.1') == 1
# assert mycmp('1.1.3', '1.1.3.000') == 0
# assert mycmp('3.1.1.0', '3.1.2.10') == -1
# assert mycmp('1.1', '1.10') == -1

try:
    sys.argv[1]
    sys.argv[2]
except:
    print "version_compare.py requires two arguments"
    sys.exit(0)

# try:
sys.exit(mycmp(sys.argv[1], sys.argv[2]))
# except:
#     print "Was an error in the comparison"
#     sys.exit(0)