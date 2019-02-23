#!/bin/env python
"""
Simple script to test HTTP Web Front End and count the number of hits per container

Written by Michael Petrinovic 2019
"""
__version__ = 1.0

import time
import requests
import argparse
from tabulate import tabulate

MASTER_K8_NODE = "10.66.80.36" # IP Address of the Master K8s Node. Change this to your environment specific IP address
TOTAL_CONTAINERS = {}
SHUTDOWN_CONTAINERS = {}

def query_website(URL, DEVICE, ACTION):
    '''
    Query the specific URL, extract the container ID and return the result
    Specific to the implementation of my "hello.py" Web Front End service, available on DockerHub mipetrin/hello
    '''
    try:
        r = requests.get(URL)
    except requests.exceptions.RequestException as e:  # This is the correct syntax
        # Do a second try, as the container was likely still in process of being shutdown before K8s took it out of rotation
        time.sleep(1)
        try:
            r = requests.get(URL)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            #print e
            print ("\n%%% ERROR: Selected Front End \"{}\" is not available to {}\n".format(DEVICE, ACTION))
            exit(1)

    # Pull the text version of the returned HTML page from my other script hello.py run inside the container
    my_text = r.text

    # Extract just the container ID from the returned page
    my_list = []
    my_list = my_text.split("<b>")
    container_id = []
    container_id = my_list[1].split("</b>")
    container_id = str(container_id[0])
    return container_id

def test_website(DEVICE, PORT, MAX_COUNT):
    '''
    Retrieve Web Site from Specific Front End
    '''
    LOOP_COUNT = 1
    URL = "http://{}:{}/Melbourne".format(DEVICE, PORT)

    while LOOP_COUNT <= MAX_COUNT:
        container_id = query_website(URL, DEVICE, "test")

        if container_id not in TOTAL_CONTAINERS:
            TOTAL_CONTAINERS[container_id] = 1
        else:
            TOTAL_CONTAINERS[container_id] = TOTAL_CONTAINERS[container_id] + 1

        LOOP_COUNT += 1

def shutdown_website(DEVICE, PORT, MAX_COUNT):
    '''
    Shutdown a Container Instance of the Web Site from Specific Front End
    '''
    LOOP_COUNT = 1
    URL = "http://{}:{}/shutdown".format(DEVICE, PORT)

    while LOOP_COUNT <= MAX_COUNT:
        container_id = query_website(URL, DEVICE, "shutdown")

        if container_id not in SHUTDOWN_CONTAINERS:
            SHUTDOWN_CONTAINERS[container_id] = 1
        else:
            # Shouldn't actually shutdown the same host more than once, so don't track it
            # as K8s probably didn't take it out of rotation immediately, or faster than this script executes
            # so skip and not increment the counter to ensure we still perform the correct number of shutdowns
            continue

        LOOP_COUNT += 1

        time.sleep(1) # Sleep for 1 second to ensure we give K8s time to remove pod from rotation before trying again

def print_table(CONTAINER_DICT):
    '''
    Print out a pretty table with the results
    '''
    data = []
    instance_num = 1
    for container_id, value in sorted(CONTAINER_DICT.iteritems()):
        data.append((instance_num, container_id, value))
        instance_num += 1

    print ("\n")
    print tabulate(data, headers=["#", "Pod/Container ID", "Hit Count"], tablefmt="simple")

def main():
    '''
    Main Function
    '''
    parser = argparse.ArgumentParser(description='Test Container Front End')
    parser.add_argument('-d', '--device', help='Which front end to test', required=True, choices=['localhost', 'k8s'])
    parser.add_argument('-p', '--port', type=int, help='Which port to use', default=5000)
    parser.add_argument('-c', '--count', type=int, help='Number of iterations to perform', default=10)
    parser.add_argument('-s', '--shutdown', type=int, help='Number of containers to shutdown')
    args = parser.parse_args()

    # Start time count at this point, otherwise takes into consideration the amount of time taken to input the password
    start_time = time.time()

    if args.device == "localhost":
        MY_HOST = "localhost"
    else:
        MY_HOST = MASTER_K8_NODE

    if args.shutdown:
        # Perform shutdown sequence
        shutdown_website(MY_HOST, args.port, args.shutdown)
        print ("\nShutting down pod/containers...")
        print_table(SHUTDOWN_CONTAINERS)
    else:
        # Test HTTP Web Front End Service
        test_website(MY_HOST, args.port, args.count)
        print ("\nTesting connection to pod/containers...")
        print_table(TOTAL_CONTAINERS)

    print ("\n")
    print ("=" * 80)
    finish_time = time.time()
    print("--- Total Execution Time: %s seconds ---" % (finish_time - start_time))
    print ("")

if __name__ == '__main__':
    main()