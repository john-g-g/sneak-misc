#!/Users/sneak/dev/venv-2.7/bin/python
# shouts to @AskAmex for being a replicant and 
# David Bartle for making a very difficult-to-use ofxclient library
# 2013 jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2

import os
import re
from ofxclient.request import Builder as OFXClientBuilder

class MockInstitution(object):
    def __init__(self,user=None,password=None,url=None,org=None,fid=None):
        self.username = user
        self.password = password
        self.dsn = {
            'url': url,
            'org': org,
            'fid': fid,
        }

class FinancialScraper(object):
    def __init__(self,*args,**kwargs):
        self.user = kwargs.pop('user')
        self.password = kwargs.pop('password')

    def scrape(self):
        b = OFXClientBuilder(self.getInstitution())
        r = b.doQuery(b.acctQuery())
        
        # i could parse the sgml.  or i could do this.
        c = re.compile(r'<ACCTID>(\d+)', re.MULTILINE)
        out = {}
        for acctnum in re.findall(c,r):
            out[acctnum] = {}
        c = re.compile(r'<BALAMT>([\d\.\-]+)', re.MULTILINE)
        for acctnum in out.keys():
            r = b.doQuery(b.ccQuery(acctnum,'19700101000000'))
            out[acctnum]['balance'] = re.findall(c,r)[0]
        return out
