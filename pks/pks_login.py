import os
import sys
import questionary

workdir = os.path.realpath(os.path.dirname(__file__))
envs_dir = os.path.join(workdir, 'envs')
clusters_file = 'pks_clusters.txt'
interactive_mode = False

for arg in sys.argv[1:]:
    if arg == '-i':
        interactive_mode = True
        continue

with open(os.path.join(workdir, clusters_file)) as f:
    lines = f.readlines()

clusters = {}
for line in lines:
    if line.startswith('#'):
        continue
    line = line.strip()
    cluster_alias, cluster_name, pks_server, _ = line.split('|')
    clusters[cluster_alias] = {
        'cluster_alias': cluster_alias,
        'cluster_name': cluster_name,
        'pks_server': pks_server,
    }

selected_clusters = []
if interactive_mode:
    selected_alias = questionary.select(
        'Choose a pks cluster',
        choices=clusters.keys(),
    ).ask()
    selected_clusters = [clusters[selected_alias]]
else:
    selected_clusters = list(clusters.values())

for selected_cluster in selected_clusters:
    kubeconfig=os.path.join(envs_dir, selected_cluster["cluster_alias"], 'config')
    os.system(f'export KUBECONFIG={kubeconfig}; echo $KUBECONFIG; pks get-kubeconfig {selected_cluster["cluster_name"]} -k -a="{selected_cluster["pks_server"]}" -u="$PKS_USERNAME" -p="$PKS_PASSWORD"')
