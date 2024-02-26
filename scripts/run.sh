#!/bin/bash

# Icons
icon_log="\xF0\x9F\x93\x91" # Bookmark Tabs (U+1F4D1)
icon_start="\xF0\x9F\x9B\xA0 " # Hammer and Wrench (U+1F6E0)

display_usage() {
    cat << EOF

Usage: $0 [OPTIONS]

Run Ansible commands [REQUIRES ANSIBLE CLI]

    OPTIONS
     -u             Install Ansible CLI on Ubuntu
     -i             Install prerequisites for venv setup
     -s             Setup Ansible using local python venv
     -p [PLAYBOOK]  Run Ansible playbook on nodes using venv
     -r [PLAYBOOK]  Run Ansible playbook on nodes using CLI
     -d [PLAYBOOK]  Run Ansible playbook on nodes using WSL Debian (venv)
     -w [PLAYBOOK]  Run Ansible playbook on nodes using WSL Ubuntu (CLI)
     -h             Display this help

EOF
    exit 1
}

# Generic
get_env(){
    echo $(grep -i "$@" .env | cut -d "=" -f 2)
}
get_bool(){
    local variable=$(get_env "$@" | tr '[A-Z]' '[a-z]')
    
    if [[ $variable =~ (1|true) ]]; then
        echo true
    else
        echo false
    fi
}
handle_errors(){
    if [[ $(get_bool KEEP_LOGS) == "true" ]]; then
        printf "\n$icon_log Keeping logs...\n\n"
        return
    fi
    if [[ $@ != 0 ]]; then
        printf "\n$icon_start Error encountered!\n\n"
        exit 1
    fi
    
    clear
    printf "\n$icon_log Cleared logs...\n\n"
}
