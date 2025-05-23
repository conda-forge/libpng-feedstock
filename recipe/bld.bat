@echo on

mkdir build-%SUBDIR%-%c_compiler%
cd build-%SUBDIR%-%c_compiler%

:: Configure.
cmake %CMAKE_ARGS% -G Ninja                                  ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%  ^
      -D ZLIB_LIBRARY=%LIBRARY_LIB%\zlib.lib    ^
      -D ZLIB_INCLUDE_DIR=%LIBRARY_INC%         ^
      -DCMAKE_C_FLAGS="%CFLAGS% -DWIN32"        ^
      -DCMAKE_BUILD_TYPE=Release                ^
      %SRC_DIR%
if errorlevel 1 exit /b 1

cmake --build . --target install
if errorlevel 1 exit /b 1

:: Test.
:: TODO: check if there exists a emulator
if not "%CONDA_BUILD_SKIP_TESTS%"=="1" (
if not "%CONDA_BUILD_CROSS_COMPILATION%" == "1" (
ctest -C Release
if errorlevel 1 exit 1
)
)

:: Make copies of the .lib files without the embedded version number.
copy %LIBRARY_LIB%\libpng16.lib %LIBRARY_LIB%\libpng.lib
if errorlevel 1 exit 1

copy %LIBRARY_LIB%\libpng16_static.lib %LIBRARY_LIB%\libpng_static.lib
if errorlevel 1 exit 1

:: Make copies of the .lib files without the 'lib' prefix.
copy %LIBRARY_LIB%\libpng16.lib %LIBRARY_LIB%\png16.lib
if errorlevel 1 exit 1

copy %LIBRARY_LIB%\libpng16_static.lib %LIBRARY_LIB%\png16_static.lib
if errorlevel 1 exit 1

