#!/usr/bin/python
from pystatsd import Client

class LinuxNetStats(object):
    def __init__(self):
        self.d = self._get()

    def _get(self):
        # thx
        # http://stackoverflow.com/questions/1052589/
        # how-can-i-parse-the-output-of-proc-net-dev-
        # into-keyvalue-pairs-per-interface-u
        lines = open("/proc/net/dev", "r").readlines()
        columnLine = lines[1]
        _, receiveCols , transmitCols = columnLine.split("|")
        receiveCols = map(lambda a:"rx_"+a, receiveCols.split())
        transmitCols = map(lambda a:"tx_"+a, transmitCols.split())
        cols = receiveCols+transmitCols
        faces = {}
        for line in lines[2:]:
            if line.find(":") < 0: continue
            face, data = line.split(":")
            face = face.lstrip()
            faces[face] = dict(zip(cols, data.split()))
        return faces

    def forStatsd(self,prefix=''):
        out = {}
        for iface in self.d.keys():
            for kn in self.d[iface].keys():
                out['%s%s.%s' % (prefix, iface, kn)] = int(self.d[iface][kn])
        return out

def main():
    s = Client('localhost',8125)
    n = LinuxNetStats()
    for k,v in n.forStatsd(prefix='host.com.eeqj.net.').items():
        s.update_stats(k,v)

if __name__=="__main__":
    main()
