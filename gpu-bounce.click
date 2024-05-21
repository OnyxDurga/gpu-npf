define ($ndesc 2048)
define ($threads 2)

FromDPDKDevice(0, NDESC $ndesc, MAXTHREADS $threads)
        -> Strip(14)
        -> GetIPAddress(16)
        -> r :: LinearIPLookup()
		-> Unstrip(14)
		-> ToDPDKDevice(0, NDESC $ndesc, MAXTHREADS $threads);

s :: Script(
		write r.add 11.0.0.0/8  195.66.224.175 0,
		write r.add 12.0.0.0/8  195.66.224.175 0,
		write r.add 5.113.128.0/18  195.66.224.131 0,
		write r.add 5.113.192.0/18  195.66.224.131 0,
		write r.add 5.114.0.0/18  195.66.224.131 0,
		write r.add 0.0.0.0/0  195.66.224.131 0,
)