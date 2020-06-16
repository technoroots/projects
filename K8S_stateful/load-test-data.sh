#!/bin/bash

curl --header "Content-Type: application/json" \
  --request POST localhost/configs \
  --data @- << EOF
{
    "name": "datacenter-10",
    "metadata": {
      "monitoring": {
        "enabled": "false"
      },
      "limits": {
        "cpu": {
          "enabled": "false",
          "value": "300m"
        }
      }
    }
  }
EOF


curl --header "Content-Type: application/json" \
  --request POST localhost/configs \
  --data @- << EOF
  {
    "name": "datacenter-2",
    "metadata": {
      "monitoring": {
        "enabled": "true"
      },
      "limits": {
        "cpu": {
          "enabled": "true",
          "value": "250m"
        }
      }
    }
  }

EOF

