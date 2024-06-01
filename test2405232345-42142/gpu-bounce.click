/**
 * This simple configuration bounces packets from a single interface to itself
 * MAC addresses are inverted using GPU
 *
 * A minimal launch line would be:
 * sudo bin/click --dpdk -- conf/cuda/gpu-bounce.click
 */

// Size of the mempool to allocate
define ($nb_mbuf 65535)

// Number of descriptors per ring
define ($ndesc 2048)

define ($batch 8192)    // VAR 32 64 128 256 512 1024 2048 4096 8192
define ($burst 32)
define ($minbatch 8160) // has to be $batch - $burst

define ($maxthreads 4)  // VAR 1 2 3 4

define ($zerocopy true) // VAR true or false

from :: FromDPDKDevice(0, NDESC $ndesc, MAXTHREADS $maxthreads, BURST $burst) 
    -> MinBatch($minbatch, TIMER 1000) 
    -> GPUEtherMirrorCoalescent(FROM 0, TO 12, VERBOSE false, CAPACITY 4096, MAX_BATCH $batch, ZEROCOPY $zerocopy, BLOCKING false, QUEUES_PER_CORE 16)
    -> ToDPDKDevice(0, NDESC $ndesc, MAXTHREADS $maxthreads, BLOCKING true)

/* For debug purposes */
// Script(TYPE ACTIVE, read from.hw_dropped, wait 1s, loop);




