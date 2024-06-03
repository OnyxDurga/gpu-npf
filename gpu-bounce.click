
// Size of the mempool to allocate
define ($nb_mbuf 65536)

// Number of descriptors per ring
define ($ndesc 2048)

define ($batch 64)    // VAR 32 64 128 256 512 1024 2048 4096 8192
define ($burst 32)
define ($minbatch 32) // has to be $batch - $burst

define ($maxthreads 3)  // VAR 1 2 3 4

define ($zerocopy false) // VAR true or false

from :: FromDPDKDevice(0, NDESC $ndesc, MAXTHREADS $maxthreads, BURST $burst) 
    -> MinBatch($minbatch, TIMER 1000) 
    -> GPUEtherMirrorCoalescent(FROM 0, TO 12, VERBOSE false, CAPACITY 128, MAX_BATCH $batch, ZEROCOPY $zerocopy, BLOCKING false, QUEUES_PER_CORE 16)
    -> ToDPDKDevice(0, NDESC $ndesc, MAXTHREADS $maxthreads, BLOCKING true)

/* For debug purposes */
// Script(TYPE ACTIVE, read from.hw_dropped, wait 1s, loop);



