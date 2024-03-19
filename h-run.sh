# Check ts
if ! command -v ts &> /dev/null; then
    echo "Program ts - not installed. Moreutils is required. Install:"
    apt update && apt upgrade -y --allow-downgrades && sudo sed -i '/^deb http:\/\/archive\.ubuntu\.com\/ubuntu\ jammy\ main$/d' /etc/apt/sources.list && sudo sed -i '/^deb http:\/\/archive\.ubuntu\.com\/ubuntu\ jammy\ InRelease$/d' /etc/apt/sources.list && apt update && apt install moreutils -y
fi

#copy qli-Client to CPU directory and run for CPU, then to GPU directory and run for GPU
cp ./qli-Client ./cpu/
cp ./qli-Client ./gpu/
sleep 1

# Check if both ./cpu/appsettings.json and ./gpu/appsettings.json exist
if [[ -e ./cpu/appsettings.json && -e ./gpu/appsettings.json ]]; then
    # If both files exist, run the program for CPU first, then for GPU
    cd ./cpu/
    sudo ./qli-Client | ts CPU | tee --append $MINER_LOG_BASENAME.log &
    sleep 2
    cd ../gpu/
    sudo ./qli-Client | ts GPU | tee --append $MINER_LOG_BASENAME.log
# Check if only ./cpu/appsettings.json exists
elif [[ -e ./cpu/appsettings.json ]]; then
    # If the file exists only in ./cpu/, run the program for CPU
    cd ./cpu/
    sudo ./qli-Client | ts CPU | tee --append $MINER_LOG_BASENAME.log
# Check if only ./gpu/appsettings.json exists
elif [[ -e ./gpu/appsettings.json ]]; then
    # If the file exists only in ./gpu/, run the program for GPU
    cd ./gpu/
    sudo ./qli-Client | ts GPU | tee --append $MINER_LOG_BASENAME.log
# If neither file exists, display an error message and exit
else
    echo "ERROR: No CPU and GPU config file found, exiting"
    exit 1
fi