// gpk, go reimplementation of the fast async port scanner
// scanrand from dan kaminsky's pakketo keiretsu project
// by sneak <sneak@sneak.berlin>

// implementation based on
// https://github.com/akrennmair/gopcap/blob/master/tools/pcaptest/pcaptest.go

package main

import (
	"flag"
	"fmt"
	"github.com/akrennmair/gopcap"
	"github.com/op/go-logging"
	"os"
)

var log = logging.MustGetLogger("gpk")

const (
	TCP_FIN = 1 << iota
	TCP_SYN
	TCP_RST
	TCP_PSH
	TCP_ACK
	TCP_URG
	TCP_ECE
	TCP_CWR
	TCP_NS
)

// it is dumb that go doesn't let me define additional methods
// on the external package, now these have to be plain funcs
func isRST(tcp *pcap.Tcphdr) bool {
	return (tcp.Flags & TCP_RST) != 0
}

func isACK(tcp *pcap.Tcphdr) bool {
	return (tcp.Flags & TCP_ACK) != 0
}

func isFIN(tcp *pcap.Tcphdr) bool {
	return (tcp.Flags & TCP_FIN) != 0
}

func min(x uint32, y uint32) uint32 {
	if x < y {
		return x
	}
	return y
}

func usage() {
	fmt.Printf("usage: gopakketo [-d <device> | -r <file>]\n")
	os.Exit(0)
}

var logFormat = logging.MustStringFormatter(
	`%{color}%{time:15:04:05.000} %{shortfunc} ▶ %{level:.4s} %{id:03x}%{color:reset} %{message}`,
)

func main() {

	loggingBackend := logging.NewLogBackend(os.Stderr, "", 0)
	backendFormatter := logging.NewBackendFormatter(loggingBackend, logFormat)
	logging.SetBackend(backendFormatter)

	var device *string = flag.String("d", "", "device")
	var targetlist *string = flag.String("t", "", "target list e.g. 192.168.0.0/16 or 192.168.0-255.0-255")
	var portlist *string = flag.String("p", "", "port list e.g. 0-1024 or 22,23,80 or 0-1024,6667")
	//var outfile *string = flag.String("o", "", "output file")
	//var expr *string = flag.String("e", "", "filter expression")

	flag.Parse()

	go send(device, targetlist, portlist)
	receive(device)
}

func parsePortList(pl *[]uint16, s *string) {

}

func parseTargetList(tl *[]uint32, s *string) {

}

func send(device *string, targetlist *string, portlist *string) {

	pl := make([]uint16, 0)
	parsePortList(pl, portlist)

	tl := make([]uint32, 0)
	parseTargetList(tl, targetlist)

}

func sendSyn(device *string, sport uint16, dst uint32, dport uint16) {
    // TODO(sneak)
    // https://www.devdungeon.com/content/packet-capture-injection-and-analysis-gopacket#creating-sending-packets

}

func receive(device *string) {
	var pc *pcap.Pcap
	var err error

	ifs, err := pcap.Findalldevs()
	if len(ifs) == 0 {
		panic(fmt.Sprintf("no interfaces found : %s\n", err))
	}

	if *device != "" {
		pc, err = pcap.Openlive(*device, 65535, true, 0)
		if pc == nil {
			log.Noticef("Openlive(%s) failed: %s\n", *device, err)
			return
		}
		if err != nil {
			log.Criticalf("Openlive(%s) failed: %s\n", *device, err)
			return
		}
	} else {
		usage()
		return
	}
	defer pc.Close()

	log.Infof("pcap version: %s\n", pcap.Version())

	for pkt := pc.Next(); pkt != nil; pkt = pc.Next() {
		pkt.Decode()
		if pkt.TCP == nil {
			// we are only interested in TCP for scanning purposes rn
			continue
		}

		if !isRST(pkt.TCP) && !isACK(pkt.TCP) {
			// for scanning we only want RSTs (closed) and ACKs (open)
			continue
		}

		if isACK(pkt.TCP) {
			if isFIN(pkt.TCP) {
				continue
			}
		}

		fmt.Printf("%s\n", pkt.String())
	}
}
