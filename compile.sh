#!/bin/bash

# This script compiles one or more C++ files into a single executable.
# Usage: ./compile.sh <cpp_file_1_with_extension> [cpp_file_2_with_extension ...] [-o <output_name>]
# Example: ./compile.sh main.cpp utility.cpp -o my_program

# Define your compiler and flags here
#CXX="clang++"
#CXXFLAGS="-std=c++23 -Wall -Wextra -Wpedantic -stdlib=libc++ -O3 -g -fexperimental-library"
CXX="g++"
CXXFLAGS="-std=c++17 -Wall -Wextra -Wpedantic -O3 -g"

# Initialize an empty array to hold the full paths of source files
SOURCE_FILES=()
OUTPUT_EXECUTABLE="a.out" # Default output executable name

# --- Argument Parsing ---
# Create a temporary array to hold arguments for parsing
ARGS=("$@")
NUM_ARGS=${#ARGS[@]}

# Loop through arguments to separate source files from the output name
i=0
while [ "$i" -lt "$NUM_ARGS" ]; do
    ARG="${ARGS[$i]}"
    case "$ARG" in
        -o)
            # If -o is found, the next argument is the output executable name
            i=$((i+1)) # Move past -o
            if [ "$i" -ge "$NUM_ARGS" ]; then
                echo "Error: -o requires an argument (output filename)."
                exit 1
            fi
            OUTPUT_EXECUTABLE="${ARGS[$i]}"
            ;;
        *.cpp)
            # If the argument ends with .cpp, treat it as a source file
            SOURCE_FILES+=("${ARG}")
            ;;
        *)
            # For any other argument
            echo "Error: Unrecognized argument or file format: '$ARG'. Expected '.cpp' files or '-o <output_name>'."
            echo "If '$ARG' is a source file, it must include the '.cpp' extension."
            exit 1
            ;;
    esac
    i=$((i+1)) # Move to the next argument
done
# --- End Argument Parsing ---

# Check if any source files were provided
if [ ${#SOURCE_FILES[@]} -eq 0 ]; then
    echo "Error: No C++ source files provided."
    echo "Usage: $0 <cpp_file_1_with_extension> [cpp_file_2_with_extension ...] [-o <output_name>]"
    echo "Example: $0 main.cpp utility.cpp -o my_program"
    exit 1
fi

# Verify that all source files exist
ALL_FILES_EXIST=true
for file in "${SOURCE_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "Error: Source file '$file' not found in current directory. Please ensure the script is run from the directory containing your .cpp files, or provide full paths."
        ALL_FILES_EXIST=false
    fi
done

if [ "$ALL_FILES_EXIST" = false ]; then
    echo "Aborting compilation due to missing source files."
    exit 1
fi

#echo "Compiling ${#SOURCE_FILES[@]} file(s) into '$OUTPUT_EXECUTABLE'..."

# Execute the compilation command
echo "[INFO]" $CXX -o "$OUTPUT_EXECUTABLE" "${SOURCE_FILES[@]}" $CXXFLAGS
$CXX -o "$OUTPUT_EXECUTABLE" "${SOURCE_FILES[@]}" $CXXFLAGS

# Check the exit status of the last command (the compilation)
if [ $? -eq 0 ]; then
    echo "Compilation successful."
    exit 0;
else
    echo "Compilation failed. Please check the error messages from the compiler above."
    exit 1;
fi
