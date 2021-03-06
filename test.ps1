if($args[0])
{
    $LAB = $args[0]
    $BUILD_TEST_DIR = "build_$LAB"

    if (-not (Test-Path -Path $LAB))
    {
        Write-Host -ForegroundColor Red "No such file or directory"
        exit 1
    }
}
else 
{
    $LAB = "."
    $BUILD_TEST_DIR = "build_all_labs"
}

if (Test-Path -Path $BUILD_TEST_DIR) 
{ 
    Remove-Item $BUILD_TEST_DIR -Force -Recurse 2>&1 > $null 
}

New-Item -Path $BUILD_TEST_DIR -ItemType "directory" 2>&1 > $null

Write-Host -ForegroundColor Yellow "TEST 1"
cmake -B $BUILD_TEST_DIR/Test1 -S $LAB -DUNLIMITED=ON
cmake --build $BUILD_TEST_DIR/Test1 --config Debug
cmake --build $BUILD_TEST_DIR/Test1 --target RUN_TESTS
if (Test-Path $BUILD_TEST_DIR/Testing/Temporary/LastTestsFailed.log) 
{ 
    exit 1 
}

Write-Host -ForegroundColor Yellow "TEST 2"
cmake -B $BUILD_TEST_DIR/Test2 -S $LAB -DUNLIMITED=OFF
cmake --build $BUILD_TEST_DIR/Test2 --config Debug
cmake --build $BUILD_TEST_DIR/Test2 --target RUN_TESTS
if (Test-Path $BUILD_TEST_DIR/Testing/Temporary/LastTestsFailed.log) 
{ 
    exit 1 
}

Write-Host -ForegroundColor Yellow "TEST 3"
cmake -B $BUILD_TEST_DIR/Test3 -S $LAB -DCMAKE_C_COMPILER=clang -DENABLE_ASAN=true -DUNLIMITED=ON
cmake --build $BUILD_TEST_DIR/Test3 --config Debug
cmake --build $BUILD_TEST_DIR/Test3 --target RUN_TESTS
if (Test-Path $BUILD_TEST_DIR/Testing/Temporary/LastTestsFailed.log) 
{ 
    exit 1 
}

Write-Host -ForegroundColor Yellow "TEST 4"
cmake -B $BUILD_TEST_DIR/Test4 -S $LAB -DCMAKE_C_COMPILER=clang -DENABLE_USAN=true -DUNLIMITED=ON
cmake --build $BUILD_TEST_DIR/Test4 --config Debug
cmake --build $BUILD_TEST_DIR/Test4 --target RUN_TESTS
if (Test-Path $BUILD_TEST_DIR/Testing/Temporary/LastTestsFailed.log) 
{ 
    exit 1 
}

exit 0