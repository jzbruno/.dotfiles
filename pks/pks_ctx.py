import os
import questionary


workdir = os.path.realpath(os.path.dirname(__file__))
envs_dir = os.path.join(workdir, 'envs')


with open(os.path.join(workdir, 'pks_clusters.txt')) as f:
    lines = f.readlines()

clusters = []
for line in lines:
    if line.startswith('#'):
        continue
    cluster_alias, _, _, _ = line.split('|')
    clusters.append(cluster_alias)
clusters.sort()

cluster_new = questionary.select(
    'Choose a pks cluster',
    choices=clusters,
).ask()

kubeconfig=os.path.join(envs_dir, cluster_new, 'config')
with open(os.path.join(envs_dir, 'current_env'), 'w') as f:
    f.write(f'export KUBECONFIG={kubeconfig}')
