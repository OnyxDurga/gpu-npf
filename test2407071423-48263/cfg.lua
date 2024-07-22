package.path = package.path .. ";/etinfo/users/2021/rvanhauwaert/dpdk-23.03/Pktgen-DPDK/?.lua"
require("Pktgen")

-- Set random seed
math.randomseed(os.time())

local first_byte = math.random(1, 255)
local second_byte = math.random(1, 255)
local third_byte = math.random(1, 255)
-- local dstip = 1234
-- Generate a random source IP address
local first_byte = math.random(1, 255)
local second_byte = math.random(1, 255)
local third_byte = math.random(1, 255)
local fourth_byte = math.random(1, 255)
-- local srcip = 4321
-- Writting packet length in dstmac field (60 bytes packets)
local srcmac = "10:70:fd:c3:f1:48"
local dstmac = "08:c0:eb:bf:ee:c2"

TIME = 10
RATE = 1
PKT_SIZE = 64

-- =================== Generic Info ===================
pktgen.ports_per_page(1)

pktgen.range.dst_mac("0", "start", dstmac)
pktgen.range.src_mac("0", "start", srcmac)

pktgen.set_range("0", "on")

pktgen.range.src_ip("0", "start", "1.2.3.4")
pktgen.range.src_ip("0", "min", "0.0.0.0")
pktgen.range.src_ip("0", "inc", "0.1.1.1")
pktgen.range.src_ip("0", "max", "255.255.255.255")

-- For some reason, the simple start statement does not work
-- I had to set min, max to the same value and increment to 0
pktgen.range.dst_ip("0", "start", "5.6.7.8")
pktgen.range.dst_ip("0", "min", "0.0.0.0")
pktgen.range.dst_ip("0", "inc", "0.1.1.1")
pktgen.range.dst_ip("0", "max", "255.255.255.255")

pktgen.range.ip_proto("0", "udp")

pktgen.range.pkt_size("0", "start", PKT_SIZE)
pktgen.range.pkt_size("0", "inc", 0)
pktgen.range.pkt_size("0", "min", PKT_SIZE)
pktgen.range.pkt_size("0", "max", PKT_SIZE)

pktgen.range.dst_port("0", "start", 1024)
pktgen.range.dst_port("0", "inc", 1)
pktgen.range.dst_port("0", "min", 1024)
pktgen.range.dst_port("0", "max", 1500)

-- Source port iterates over the list of ports
pktgen.range.src_port("0", "start", 2048)
pktgen.range.src_port("0", "inc", 1)
pktgen.range.src_port("0", "min", 2048)
pktgen.range.src_port("0", "max", 2048)


-- Set the rate of pkts
pktgen.set("0", "rate", RATE)

-- Settings latency stuff
pktgen.latency(0, "enable");
pktgen.latency(0, "rate", 10000);
pktgen.latency(0, "entropy", 8);
pktgen.delay(100)
pktgen.start("0")

pktgen.delay(TIME * 1000)

pktgen.stop("0")

statRx = pktgen.portStats(0, "port")[0]
num_rx = statRx.ipackets
num_tx = statRx.opackets
ibytes_rx = statRx.ibytes

-- compute average rate during the time of experience
-- see iBitsTotal in pktgen.h:114
-- PKT_OVERHEAD_SIZE = 24
mbps_rx = ((num_rx * 24) + ibytes_rx) / TIME * 8 / 1000000

-- latency
pkt_stats = pktgen.pktStats(0)
avg_cycles = pkt_stats[0].latency.avg_cycles
avg_us = pkt_stats[0].latency.avg_us

print(" RESULT-RX-RATE-PPS " .. math.floor(num_rx / TIME))
print(" RESULT-RX-RATE-MBPS " .. mbps_rx)
print(" RESULT-LOSE-RATE " .. 1-(num_rx / (num_tx)) .. "")
print(" RESULT-AVG-LAT " .. avg_us .. "us")

pktgen.quit()