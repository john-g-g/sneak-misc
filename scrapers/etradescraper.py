#!/Users/sneak/dev/venv-2.7/bin/python
# shouts to @AskAmex for being a replicant and 
# David Bartle for making a very difficult-to-use ofxclient library
# 2013 jeffrey paul <sneak@datavibe.net>
# 5539 AD00 DE4C 42F3 AFE1  1575 0524 43F4 DF2A 55C2
from pprint import pformat
import os
import re
import json
from scraper import FinancialScraper, MockInstitution

class EtradeScraper(FinancialScraper):
    def isBank(self):
        return True
    def isCC(self):
        return False
    def getInstitution(self):
        return MockInstitution(
            user=self.user,
            password=self.password,
            url='https://ofx.etrade.com/cgi-ofx/etradeofx',
            org='ETRADE BANK',
            fid='9989'
        )
       
def main():
    s = EtradeScraper(
        user=os.environ['ETRADEUSERNAME'],
        password=os.environ['ETRADEPASSWORD']
    )
    print json.dumps(s.scrape())

if __name__=="__main__":
    main()
