#!/bin/bash

# Description:
# This bash script checks for power, water, or gas outages at a specified address in Armenia
# by scraping the outage information from the relevant Armenian utility websites. It supports
# different formats of the address to ensure comprehensive coverage. The script fetches the 
# webpage content using `curl` and searches for the address using `grep`. If an outage is 
# detected, it reports the affected service and address.

# Define your address in different formats
addresses=("Մ.Սարյան" "Մ. Սարյան" "Մարտիրոս Սարյան" "Մ. ՍԱՐՅԱՆ" "ՄԱՐՏԻՐՈՍ ՍԱՐՅԱՆ")

# Define the URLs
power_url="https://www.ena.am/Info.aspx?id=5&lang=1"
water_url="https://interactive.vjur.am/"
gas_url="https://armenia-am.gazprom.com/notice/announcement/plan/"

# Function to check for outages
check_outages() {
  local url=$1
  local service=$2
  local status=0

  # Fetch the webpage content
  content=$(curl -s $url)

  # Check for the address in the content
  for address in "${addresses[@]}"; do
    if echo "$content" | grep -q "$address"; then
      echo "Outage detected for $service at address: $address"
      status=1
    fi
  done

  # if [ $status -eq 0 ]; then
  #   echo "No outage detected for $service."
  # fi
}

# Check for power outages
check_outages $power_url "power"

# Check for water outages
check_outages $water_url "water"

# Check for gas outages
check_outages $gas_url "gas"
