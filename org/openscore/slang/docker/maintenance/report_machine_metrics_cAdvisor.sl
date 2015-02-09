#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0

##################################################################################################################################################
#   This flow retrieves cAdviser status of a container in docker 
#
#   Inputs:
#       - container - name or ID of the Docker container that runs MySQL
#       - dockerHost - Docker machine host
#       - identityPort - optional - port used for cAdvisor - Default: 8080
##################################################################################################################################################

namespace: org.openscore.slang.docker.maintenance

imports:
  docker_maintenance: org.openscore.slang.docker.maintenance

flow:
  name: report_machine_metrics_cAdvisor
  inputs:
    - host
    - identityPort:
        default: "'8080'"
        required: false
  workflow:
    retrieve_machine_metrics_cAdvisor:
      do:
        docker_maintenance.get_machine_metrics_cAdvisor:
            - host
            - identityPort
      publish:
        - response_body: returnResult
        - returnCode
        - errorMessage
    parse:
      do:
        docker_maintenance.parse_cadvisor_machine:
          - jsonResponse: response_body
      publish:
        - decoded
        - num_cores
        - cpu_frequency_khz
        - memory_capacity
        - filesystems
        - disk_map
        - network_devices
        - topology
        - errorMessage
  outputs:
    - decoded
    - num_cores
    - cpu_frequency_khz
    - memory_capacity
    - filesystems
    - disk_map
    - network_devices
    - topology
    - errorMessage
  results:
    - SUCCESS
    - FAILURE