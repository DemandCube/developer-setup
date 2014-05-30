#!/usr/bin/python
import sys
import re

try:
    import pip
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    print pip.__version__
    sys.exit(0)
except:
    noop = 0

try:
    import pip
    file = pip.__file__
    tuple = re.search('(pip-([\d]\.[\d]\.[\d])-|pip-([\d]\.[\d])-|pip-([\d])-)',file).groups()[1:4]
    for item in tuple:
        print "item"
        print "item"
        print "item"
        print "item"
        print "item"
        print "item"
        print "item"
        print "item"
        print "item"
        
        if item != None:
            print item
            break
except:
    sys.exit(1)
