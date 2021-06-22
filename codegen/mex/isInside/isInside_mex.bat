@echo off
set MATLAB=D:\PROGRA~1\Matlab
set MATLAB_ARCH=win64
set MATLAB_BIN="D:\Program Files (x86)\Matlab\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=isInside_mex
set MEX_NAME=isInside_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for isInside > isInside_mex.mki
echo COMPILER=%COMPILER%>> isInside_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> isInside_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> isInside_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> isInside_mex.mki
echo LINKER=%LINKER%>> isInside_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> isInside_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> isInside_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> isInside_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> isInside_mex.mki
echo OMPFLAGS= >> isInside_mex.mki
echo OMPLINKFLAGS= >> isInside_mex.mki
echo EMC_COMPILER=msvc150>> isInside_mex.mki
echo EMC_CONFIG=optim>> isInside_mex.mki
"D:\Program Files (x86)\Matlab\bin\win64\gmake" -j 1 -B -f isInside_mex.mk
