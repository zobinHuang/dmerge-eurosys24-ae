# distutils: language=c++
from libcpp.string cimport string

cdef extern from "native/wrapper.h":
    void * create_heap(unsigned long long start_addr, unsigned long long mem_sz)
    cpdef int sopen()
    cpdef int call_register(int sd, unsigned long long peak_addr, unsigned int hint)
    cpdef int call_pull(int sd, unsigned int hint, unsigned int machine_id)
    int call_connect_session(int sd, const char *addr, unsigned int mac_id, unsigned int nic_id)
    int call_get_mac_id(int sd, unsigned int nic_idx, const char *mac_id)


cpdef unsigned long long ccreate_heap(unsigned long long start_addr, unsigned long long mem_sz):
    cdef void * ptr = create_heap(start_addr, mem_sz)
    # Of python type `long`
    return <unsigned long long> ptr

cpdef int syscall_connect_session(int sd, str addr, unsigned int mac_id, unsigned int nic_id):
    cdef string caddr = addr.encode()
    return call_connect_session(sd, caddr.c_str(), mac_id, nic_id)


cpdef str syscall_get_mac_id(int sd, unsigned int nic_idx):
    cdef char[39] mac_id
    cdef size_t len_mac_id = call_get_mac_id(sd, nic_idx, mac_id)
    return (<char*>mac_id)[:len_mac_id].decode('utf-8')

cpdef void my_write_ptr(addr, val):
    cdef unsigned long long caddr = addr
    cdef int * ptr = <int *> caddr
    ptr[0] = val

cpdef int my_read_ptr(addr):
    cdef unsigned long long caddr = addr
    cdef int * ptr = <int *> caddr
    return ptr[0]
