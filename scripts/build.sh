#!/bin/bash
set -e

if [ -z "$ORGREPO" ]; then
    echo "ORGREPO must be provided ex; https://github.com/openshift"
    exit -1
fi
if [ -z "$PROJECT" ] ; then
    echo "PROJECT name must be provided ex; cluster-api, cluster-api-providers-aws, cluster-api-providers-azure"
    exit -1
fi
if [ -z "$BRANCH" ]; then
    echo "BRANCH must be provided ex; master, release-4.18"
    exit -1
fi

WKDIR=../out
CONFIGDIR=config
TMPDIR=tmp

## TODO: We need function to compare the $PROJECT --feature-gates in config/manager/manager.yaml
## with the chart generated $PROJECT --feature-gates in templates/apps_v1_deployment*.yaml 
## and break if a new feature-gate has been added.
function subst_env_vars {
    echo 'Check ' $PROJECT ' feature-gates changes'
    # local ORIG_FILE="$1"
    # local T_FILE="$2"
    # cp "$ORIG_FILE" "$T_FILE"
    # declare -a subst=(
    #   "EXP_MACHINE_POOL=true"
    #   "CAPA_EKS=true"
    #   "CAPA_EKS_IAM=false"
    #   "CAPA_EKS_ADD_ROLES=false"
    #   "EXP_EKS_FARGATE=false"
    #   "EVENT_BRIDGE_INSTANCE_STATE=false"
    #   "AUTO_CONTROLLER_IDENTITY_CREATOR=false"
    #   "EXP_BOOTSTRAP_FORMAT_IGNITION=false"
    #   "EXP_EXTERNAL_RESOURCE_GC=false"
    #   "EXP_ALTERNATIVE_GC_STRATEGY=false"
    #   "TAG_UNMANAGED_NETWORK_RESOURCES=false"
    #   "EXP_ROSA=true"
    # )
    # for SUB in "${subst[@]}" ; do
    #    local WHAT="${SUB%=*}"
    #    local WITH="${SUB##*=}"
    #    sed -i "s;\${$WHAT[^}]*};$WITH;g" "$T_FILE" 
    # done
    # return -1
}


mkdir -p $WKDIR
rm -rf $WKDIR/$PROJECT
mkdir $WKDIR/$PROJECT
git clone $ORGREPO/$PROJECT $WKDIR/$PROJECT
cp ../$CONFIGDIR/$PROJECT/kustomization.yaml $WKDIR/$PROJECT/$CONFIGDIR

cd $WKDIR/$PROJECT
git checkout "$BRANCH" && git pull
rm -rf $CONFIGDIR/$TMPDIR
mkdir -p $CONFIGDIR/$TMPDIR
kustomize build config -o $CONFIGDIR/$TMPDIR
rm -rf $CONFIGDIR/$TMPDIR/cert*
## TODO: call subst_env_vars config/manager/manager.yaml templates/apps_v1_deployment*.yaml

echo $WKDIR/$PROJECT/$CONFIGDIR/$TMPDIR