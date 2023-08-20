# #!/bin/bash
# cd gnss_localizer
# ./launch_script.sh
# sleep 5

# cd ../traffic_light_bridge
# ./launch_script.sh 

# cd ../auto_reroute_py
# ./launch_script.sh

#!/bin/bash

#!/bin/bash

use_gnss=false
use_traffic_light=false
use_auto_reroute=false

for arg in "$@"; do
  case $arg in
    --gnss=true)
      use_gnss=true
      ;;
    --traffic-light=true)
      use_traffic_light=true
      ;;
    --auto-reroute=true)
      use_auto_reroute=true
      ;;
  esac
done

if $use_gnss; then
  cd gnss_localizer
  ./launch_script.sh
  sleep 5
  cd ..
fi

if $use_traffic_light; then
  cd traffic_light_bridge
  ./launch_script.sh
  cd ..
fi

if $use_auto_reroute; then
  cd auto_reroute_py
  ./launch_script.sh
  cd ..
fi


