#!/bin/bash

cd ../src/
make clean
make boot.bin

mv ../build/compile_commands.json ../.vscode/
 