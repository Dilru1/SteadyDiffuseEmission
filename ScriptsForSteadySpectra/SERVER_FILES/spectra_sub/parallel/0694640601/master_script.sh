#!/bin/bash

# Function to execute commands in parallel
execute_parallel() {
    $1 &
}

# Execute all_new_command.sh
echo "Executing all_new_command.sh..."
./all_new_command.sh

# Wait for all_new_command.sh to finish before proceeding
wait

# Execute run_all_2.sh in parallel
echo "Executing run_all_2.sh in parallel..."
execute_parallel "./run_all_2.sh"

# Add any other commands you want to run sequentially after run_all_2.sh here

echo "Master script execution completed."
