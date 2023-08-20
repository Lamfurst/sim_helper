# #!/bin/bash
# cd gnss_localizer
# ./launch_script.sh
# sleep 5

# cd ../traffic_light_bridge
# ./launch_script.sh 

# cd ../auto_reroute_py
# ./launch_script.sh

#!/bin/bash

use_gnss=false

for arg in "$@"; do
  case $arg in
    --gnss=true)
      use_gnss=true
      ;;
  esac
done

cd gnss_localizer
if $use_gnss; then
  ./launch_script.sh
fi
sleep 5

cd ../traffic_light_bridge
./launch_script.sh 

cd ../auto_reroute_py
./launch_script.sh

