#!/usr/bin/env python
# -*- coding: utf-8 -*-

import socket
import StringIO
import contextlib
import traceback
import sys
from sys import argv

script, PORT, token_file = argv

##### set up a server
HOST = 'localhost'
PORT = int(PORT)
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
print 'Socket created'    
 
try:
    s.bind((HOST, PORT))
except socket.error , msg:
    print 'Bind failed. Error Code : ' + str(msg[0]) + '; Message: ' + msg[1]
    quit()
print 'Socket bind complete'
s.listen(10)
print 'Socket now listening', '\n'
 


@contextlib.contextmanager
def stdoutIO(stdout=None):
    '''
    store outputs from stdout
    '''
    old = sys.stdout
    if stdout is None:
        stdout = StringIO.StringIO()
    sys.stdout = stdout
    yield stdout
    sys.stdout = old

# now keep talking with the client
while 1:
    # wait to accept a connection - blocking call
    conn, addr = s.accept()
    print 'Connected with ' + addr[0] + ':' + str(addr[1])
     
    input_data = conn.recv(1024)
    # print data
    with open(token_file, 'w') as f:
        f.write(input_data)
    with stdoutIO() as output:
        try:
            execfile(token_file)
        except: 
            traceback.print_exc()
    output_data = output.getvalue()
    conn.send(output_data)
    conn.close()

s.close()
