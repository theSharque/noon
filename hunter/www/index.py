#!/usr/bin/env python

import cgi
import cgitb; cgitb.enable()  # For troubleshooting

def test():
    print "test func"

print "Content-type: text/html"
print #End of header

print "Index page"
test()