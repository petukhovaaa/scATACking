#!/bin/bash -ueo pipefail
set -eou pipefail

python /net/seq/data2/projects/apetukhova/ENCODE4/scripts/barcodes_matching/nf-scATAC-mapping/scATACking/nextflow/bin/scATAC_clusterization_snapATAC_and_figures_making.py ENCSR007QIO ENCSR007QIO_barcodes_peaks_counted ENCSR007QIO.barcodes.npz ENCSR007QIO.unique_barcodes.map index_mapping.txt
