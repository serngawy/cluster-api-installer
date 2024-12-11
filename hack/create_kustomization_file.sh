#!/usr/bin/env bash

export yamlFilesDir=$1
export kustomizFile=/tmp/kustomization.yaml
rm -f $kustomizFile $yamlFilesDir/kustomization.yaml

echo yamlFilesDir $yamlFilesDir

printf 'apiVersion: kustomize.config.k8s.io/v1beta1 \nkind: Kustomization \n\nresources:' >> $kustomizFile

for f in $(ls $yamlFilesDir); do 
	printf '\n- '$f >> $kustomizFile
done

cat $kustomizFile
cp $kustomizFile $yamlFilesDir/kustomization.yaml
