# NVIDIA Jetson TX2 Docker Images

A collection of the CRIMAC project Docker image recipes for NVIDIA Jetson TX2.

There are 3 different image types:

1. `crimac/jetson-tx2-base`

    ![Docker Pulls](https://img.shields.io/docker/pulls/crimac/jetson-tx2-base?style=flat-square)

   This is a Docker base image for Jetson TX2. It's based on the official Ubuntu 18.04 image. The Jetson TX2 `apt` repository has been pre-setup and a pre-compiled Python 3.8 is also installed.

2. `crimac/jetson-tx2-preprocess`

    ![Docker Pulls](https://img.shields.io/docker/pulls/crimac/jetson-tx2-preprocess?style=flat-square)

    A ready to use CRIMAC's pre-processor Docker image for Jetson TX2. Based on `crimac/jetson-tx2-base` image and includes the CRIMAC's acoustic data pre-processing script:
    https://github.com/CRIMAC-WP4-Machine-learning/CRIMAC-preprocessing.

    The image behaves similar to the official CRIMAC's `crimac/preprocessor` image.
    Full usage documentation is available here: https://github.com/CRIMAC-WP4-Machine-learning/CRIMAC-preprocessing/blob/master/README.md

3. `crimac/jetson-tx2-pytorch`

    ![Docker Pulls](https://img.shields.io/docker/pulls/crimac/jetson-tx2-pytorch?style=flat-square)

    This image contains ready to use Pytorch library with CUDA support for Jetson TX2 board. All libraries and drivers are included in the image, therefore we only need to share the appropriate host's `/dev` paths.

    Here are some of the usage examples:

    ## A. CUDA Device Query
  
    ```console
    crimac@crimac-tx2:~$ sudo docker run --rm -it \
                                --device=/dev/nvhost-ctrl \
                                --device=/dev/nvhost-ctrl-gpu \
                                --device=/dev/nvhost-prof-gpu \
                                --device=/dev/nvmap \
                                --device=/dev/nvhost-gpu \
                                --device=/dev/nvhost-as-gpu \
                                --device=/dev/nvhost-vic \
                                --device=/dev/tegra_dc_ctrl \
                                -v /usr/local/cuda-10.2/samples:/samples \
                                crimac/jetson-tx2-pytorch \
                                /bin/bash

    root@crimac-tx2:/# cd /samples/1_Utilities/deviceQueryDrv/
    root@crimac-tx2:/samples/1_Utilities/deviceQueryDrv# ./deviceQueryDrv 
    ./deviceQueryDrv Starting...

    CUDA Device Query (Driver API) statically linked version 
    Detected 1 CUDA Capable device(s)

    Device 0: "NVIDIA Tegra X2"
      CUDA Driver Version:                           10.2
      CUDA Capability Major/Minor version number:    6.2
      Total amount of global memory:                 7850 MBytes (8231813120 bytes)
      ( 2) Multiprocessors, (128) CUDA Cores/MP:     256 CUDA Cores
      GPU Max Clock rate:                            1300 MHz (1.30 GHz)
      Memory Clock rate:                             1300 Mhz
      Memory Bus Width:                              128-bit
      L2 Cache Size:                                 524288 bytes
      Max Texture Dimension Sizes                    1D=(131072) 2D=(131072, 65536) 3D=(16384, 16384, 16384)
      Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
      Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
      Total amount of constant memory:               65536 bytes
      Total amount of shared memory per block:       49152 bytes
      Total number of registers available per block: 32768
      Warp size:                                     32
      Maximum number of threads per multiprocessor:  2048
      Maximum number of threads per block:           1024
      Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
      Max dimension size of a grid size (x,y,z):    (2147483647, 65535, 65535)
      Texture alignment:                             512 bytes
      Maximum memory pitch:                          2147483647 bytes
      Concurrent copy and kernel execution:          Yes with 1 copy engine(s)
      Run time limit on kernels:                     No
      Integrated GPU sharing Host Memory:            Yes
      Support host page-locked memory mapping:       Yes
      Concurrent kernel execution:                   Yes
      Alignment requirement for Surfaces:            Yes
      Device has ECC support:                        Disabled
      Device supports Unified Addressing (UVA):      Yes
      Device supports Compute Preemption:            Yes
      Supports Cooperative Kernel Launch:            Yes
      Supports MultiDevice Co-op Kernel Launch:      Yes
      Device PCI Domain ID / Bus ID / location ID:   0 / 0 / 0
      Compute Mode:
        < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >
    Result = PASS
    ```
    ## B. Pytorch with CUDA

    ```python
    Python 3.8.9 (default, Apr 12 2021, 15:27:15)
    [GCC 7.5.0] on linux
    Type "help", "copyright", "credits" or "license" for more information.

    >>> import torch

    >>> device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    >>> print('Using device:', device)
    Using device: cuda

    >>> torch.rand(10).to(device)
    tensor([0.1142, 0.4635, 0.6739, 0.3689, 0.2312, 0.0696, 0.9773, 0.7621, 0.9729, 0.6640], device='cuda:0')

    >>> torch.rand(10, device=device)
    tensor([0.1406, 0.6409, 0.5563, 0.5888, 0.9272, 0.1949, 0.9050, 0.5155, 0.7439, 0.1924], device='cuda:0')

    >>> print(torch.cuda.get_device_name(0))
    NVIDIA Tegra X2

    >>> print('Allocated memory:', round(torch.cuda.memory_allocated(0)/1024**3,1), 'GB')
    Allocated memory: 0.0 GB

    >>> print('Cached memory:   ', round(torch.cuda.memory_reserved(0)/1024**3,1), 'GB')
    Cached memory:    0.0 GB
    ```

