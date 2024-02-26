#!/bin/bash

set -e

cd "$(dirname "$0")"
source ./scripts/run.sh
# ---------------------------------------------------------------------- #
# Helpers
# ---------------------------------------------------------------------- #
swap_snippets() {
    local find="$1"
    local replace="$2"
    local file="$3"
    if [ -e "$file" ]; then
        sed -i "s@$find@$replace@I" "$file"
        echo "Modified the content of $file"
    else
        echo "Error: $file does not exist." 1>&2
        exit 1
    fi
}
handle_credentials(){
    local action="$1"
    local default="ansible_ssh_pass=NODE_PASS"
    local password="ansible_ssh_pass=$(get_env NODE_PASS)"
    case ${action} in
        set) swap_snippets "$default" "$password" configs/inventory ;;
        clear) swap_snippets "$password" "$default" configs/inventory ;;
        *) echo "Error: Invalid credentials options." 2>&1; exit 1 ;;
    esac
}
load_env(){
    set -a
    source .env
}
# ---------------------------------------------------------------------- #
# OPTIONS
# ---------------------------------------------------------------------- #
install_ansible_ubuntu(){
    sudo apt update
    sudo apt install software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible
}

install_prerequisites(){
    sudo apt update
    sudo apt install -y python3 python3-venv sshpass
}
setup_ansible_venv(){
    python3 -m venv .venv
    source .venv/bin/activate
    pip install -r configs/requirements/core.txt
}

run_playbooks_venv(){
    load_env
    handle_credentials set
    source .venv/bin/activate
    ansible-playbook "playbooks/${@}.yaml"
    handle_credentials clear
}
run_playbooks_cli(){
    load_env
    handle_credentials set
    ansible-playbook "playbooks/${@}.yaml"
    handle_credentials clear
}

run_playbooks_wsl_debian(){
    wsl --exec ./run.sh -p $@
}
run_playbooks_wsl_ubuntu(){
    wsl --exec ./run.sh -r $@
}

# ---------------------------------------------------------------------- #
# Main Function
# ---------------------------------------------------------------------- #
main(){
    while getopts "uisp:r:d:w:h" OPTION; do
        case $OPTION in
            u) install_ansible_ubuntu           ;;
            i) install_prerequisites            ;;
            s) setup_ansible_venv               ;;
            p) run_playbooks_venv $OPTARG       ;;
            r) run_playbooks_cli $OPTARG        ;;
            d) run_playbooks_wsl_debian $OPTARG ;;
            w) run_playbooks_wsl_ubuntu $OPTARG ;;
            h) display_usage                    ;;
            ?) display_usage                    ;;
        esac
    done
    shift $((OPTIND -1))
}

main $@
