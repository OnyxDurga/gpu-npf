define ($ndesc 2048)
define ($threads 1)

FromDPDKDevice(0, NDESC $ndesc, MAXTHREADS $threads) 
    -> GPUIPLookup(
		CAPACITY 4096, LISTS_PER_CORE 1,
				
	) 
    -> ToDPDKDevice(0, NDESC $ndesc, MAXTHREADS $threads);