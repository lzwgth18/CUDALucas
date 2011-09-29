CUDA_VERSION = 4.0
CUDA_ARCH = sm_13
BIT = WIN64

CUDA = C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v$(CUDA_VERSION)
NVIDIA_SDK = C:/ProgramData/NVIDIA Corporation/NVIDIA GPU Computing SDK $(CUDA_VERSION)
LIBS = "$(CUDA)/lib/x64/cudart.lib" "$(CUDA)/lib/x64/cufft.lib"

CUFLAGS = -m64 --ptxas-options=-v "-ccbin=$(VCINSTALLDIR)/bin" -D$(BIT)  -Xcompiler /EHsc,/W3,/nologo,/Ox,/Oy,/GL -arch=$(CUDA_ARCH) -DMERS_PACKAGE -DBIT_SIEVE -DTESTING_SMALL_EXPONENTS -DSIEVE_SIZE_IN_BYTES=32 -DNUM_SMALL_PRIMES=32768 "-I$(CUDA)/include" "-I$(CUDA)/include/cudart" "-I$(NVIDIA_SDK)/C/common/inc"  -D__x86_64__ -O3

LINK = link
LFLAGS = /nologo /LTCG #/ltcg:pgo

CUSRC = CUDALucas.cu setup.cu rw.cu balance.cu zero.cu

CUOBJS = $(CUSRC:.cu=.cuda$(CUDA_VERSION).$(CUDA_ARCH).$(BIT).obj)

CUDALucas.cuda$(CUDA_VERSION).$(CUDA_ARCH).$(BIT).exe: $(CUOBJS)
	$(LINK) $(LFLAGS) $^ $(LIBS) /out:$@

%.cuda$(CUDA_VERSION).$(CUDA_ARCH).$(BIT).obj: %.cu
	"$(CUDA)/bin/nvcc" -c $< -o $@ $(CUFLAGS)
