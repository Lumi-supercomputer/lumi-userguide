# AMD ROCm


## CMake

## Using

### Linking the Cray MPICH library

```
export MPI_CFLAGS="${CRAY_XPMEM_INCLUDE_OPTS} \
                      -I${MPICH_DIR}/include"
export MPI_LDFLAGS="${CRAY_XPMEM_POST_LINK_OPTS} –lxpmem \
                      -L${MPICH_DIR}/lib -lmpi \
                      –L${GTL_ROOT} -lmpi_gtl_hsa"
```

=== "C"
    
    ```
    -DCMAKE_C_COMPILER=hipcc
    -DCMAKE_C_FLAGS="${MPI_CFLAGS}"
    -DCMAKE_EXE_LINKER_FLAGS="${MPI_LDFLAGS}"
    -DCMAKE_SHARED_LINKER_FLAGS="${MPI_LDFLAGS}"
    ```

=== "C++"
    
    ```
    -DCMAKE_CXX_COMPILER=hipcc
    -DCMAKE_CXX_FLAGS="${MPI_CFLAGS}"
    -DCMAKE_EXE_LINKER_FLAGS="${MPI_LDFLAGS}"
    -DCMAKE_SHARED_LINKER_FLAGS="${MPI_LDFLAGS}"
    ```