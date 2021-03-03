


| Feature                       | Cray                         | AMD                                  | GNU                                                   |
| ------------------------------|------------------------------|--------------------------------------|-------------------------------------------------------|
| Listing                       | -hlist=a                     | -ast-view                            | -fdump-tree-all                                       |
| Vectorization Report          | -hlist=m                     | -Rpass-analysis=loop-vectorize<br/>-Rpass-missed=loop-vectorize | -fopt-info-vec<br/>-fopt-info-missed
| Free format (ftn)             | -ffree                       | -Mfreeform                           | -ffree-form                                           |
| Vectorization                 | By default at -O1 and above  | By default at –O1 or above           | By default at -O3 or using -ftree-vectorize           |
| Inter-Procedural Optimization | -hwp –hpl=tmp                | -flto                                | -flto                                                 |
| Floating-point Optimizations  | -hfpN, N=0...4               | -ffast-math -ffp- contract=fast      | -f[no-]fast-math or -funsafe-math-optimizations       |
| Suggested Optimization        | (default)                    | (default)                            | -O2 -mavx -ftree-vectorize -ffast-math -funroll-loops |
| Aggressive Optimization       | -O3 -hfp3                    | -Ofast                               | -Ofast -funroll-loops                                 |
| OpenMP recognition            | (default)                    | -fopenmp                             | -fopenmp                                              |
| Variables size (ftn)          | -s real64<br/>-s integer64   | -r8<br/>-fdefault-real-8             | -freal-4-real-8<br/>-finteger-4-integer-8             | 