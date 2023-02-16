#!/usr/bin/env bash

set -euo pipefail

workdir="$(realpath $(dirname ${BASH_SOURCE[0]}))"
cluster_file="${workdir}/pks_clusters.txt"
envs_dir="${workdir}/envs"
INTERACTIVE=false

for line in $(cat "${cluster_file}" | grep -v '^#'); do
    IFS='|' read -r cluster_alias pks_cluster_name pks_server namespaces <<< "${line}"
    env_dir="${envs_dir}/${cluster_alias}"

    export KUBECONFIG="${env_dir}/config"

    if [[ " ${@} " =~ "-n" ]] || [[ " ${@} " =~ "--namespace" ]] || [[ " ${@} " =~ "--all-namespaces" ]]; then
        echo "##### Cluster = ${cluster_alias} (${pks_cluster_name})"
        echo "##### Command = ${@}"
        echo " "
        if [[ ${INTERACTIVE} == true ]]; then
            read -p ""
        fi
        eval "${@}"
        echo " "

        continue
    fi

    IFS=','
    for ns in ${namespaces}; do
        cmd="${@}"
        cmd="${cmd//__ns__/${ns}}"
        echo "##### Cluster = ${cluster_alias} (${pks_cluster_name}/${ns})"
        echo "##### Command = ${cmd}"
        echo " "
        kubectl ns ${ns}
        echo " "
        eval "${cmd}"

        if [[ ${INTERACTIVE} == true ]]; then
            read -p ""
        else
            echo " "
        fi
    done
done
