#!/Users/sneak/dev/venv-2.7/bin/python
# shouts to @AskAmex for being a replicant and 
# David Bartle for making a very difficult-to-use ofxclient library
# 2013 jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2

from pprint import pformat
import os
import re
import json
import logging
logging.basicConfig(level=logging.ERROR)
log = logging.getLogger()
from ofxclient.request import Builder

url = 'https://online.americanexpress.com/myca/ofxdl/desktop/' + \
    'desktopDownload.do?request_type=nl_ofxdownload'

# this exists because ofxclient is tightly coupled with their "Institution"
# class which shits all over my home directory with caching and
# credential storage that I don't want
class MockAmexInstitution(object):
    def __init__(self,user=None,password=None):
        self.username = user
        self.password = password
        self.dsn = {
            'url': url,
            'org': 'AMEX',
            'fid': '3101',
        }

class AmexScraper(object):
    def __init__(self,*args,**kwargs):
        self.user = kwargs.pop('user')
        self.password = kwargs.pop('password')

    def scrape(self):
        i = MockAmexInstitution(
            user=self.user,
            password=self.password
        )
        b = Builder(i)
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
        
def main():
    s = AmexScraper(
        user=os.environ['AMEXUSERNAME'],
        password=os.environ['AMEXPASSWORD']
    )
    print json.dumps(s.scrape())

if __name__=="__main__":
    main()
