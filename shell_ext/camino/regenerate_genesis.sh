#!/bin/bash

source "$HOME/.shell_ext/utility.sh"

# Beggining from camino-node repo root
assert_cd "$HOME/Proj/camino/camino-node"

# Check whether there is a new source file
download_source="$HOME/Downloads/KOPERNIKUS GENESIS.xlsx"
source_file="$HOME/.camino-genesis/kopernikus_genesis.xlsx"
template_file="$(pwd)/tools/genesis/templates/template_depositOffers_kopernikus.json"

if [ -f "${download_source}" ]; then
	mv "${download_source}" "${source_file}"
	say $YELLOW "New source: ${source_file}"
else
	echo "No new source file available in ${download_source}"
fi

# Check whether the generator needs to be build
[ -f "./build/genesis-generator" ] || ./scripts/build_genesis_generator.sh

# Run the generator
./build/genesis-generator \
  "${source_file}" \
  "${template_file}" \
  kopernikus
