%file gpu-crc-commlist.click
// Size of the mempool to allocate
define ($nb_mbuf 65535)

// Number of descriptors per ring
define ($ndesc 2048)

// A batch must contain at most 1024 packets
define ($batch ${BATCH})
define ($burst 32)
define ($minbatch $((${BATCH}-32))) // has to be $batch - $burst

// number of cores receiving and processing packets
define ($maxthreads ${NTHREADS})

// each thread has `lists_per_core` lists of size `capacity`
define ($capacity ${CAPACITY})
define ($lists_per_core ${LISTSorQUEUES_PER_CORE})

// If true, NIC stores packets directly in GPU memory
define ($gpudirect_rdma ${MEMPOOL_GPU})

// Control Flow
define ($persistent_kernel ${PERSISTENT_KERNEL})


info :: DPDKInfo($nb_mbuf, MEMPOOL_GPU $gpudirect_rdma)

FromDPDKDevice(0, NDESC $ndesc, MAXTHREADS $maxthreads, BURST $burst, NUMA false) 
    -> MinBatch($minbatch, TIMER 1000) 
    -> GPUSetCRC32CommList(VERBOSE false, PERSISTENT_KERNEL $persistent_kernel, CAPACITY $capacity, MAX_BATCH $batch, LISTS_PER_CORE $lists_per_core) 
    -> ToDPDKDevice(0, NDESC $ndesc, MAXTHREADS $maxthreads, BLOCKING false)