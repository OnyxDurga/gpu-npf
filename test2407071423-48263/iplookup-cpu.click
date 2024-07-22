
// Size of the mempool to allocate
define ($nb_mbuf 65535)

// Number of descriptors per ring
define ($ndesc 2048)

// number of cores receiving and processing packets
define ($threads ${THREADS})

info :: DPDKInfo($nb_mbuf)

FromDPDKDevice(0, NDESC $ndesc, MAXTHREADS $threads)
        -> Strip(14)
        -> GetIPAddress(16)
        -> r :: LinearIPLookup(LOOKUP_TABLE 0)
        -> Unstrip(14)
        -> ToDPDKDevice(0, NDESC $ndesc, MAXTHREADS $threads);


