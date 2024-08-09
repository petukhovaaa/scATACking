nextflow.enable.dsl=2

//params.info = "/net/seq/data2/projects/apetukhova/ENCODE4/scripts/barcodes_matching/nf-scATAC-mapping/figure_info.csv"
params.info = "/net/seq/data2/projects/apetukhova/ENCODE4/scripts/barcodes_matching/nf-scATAC-mapping/test/figure_info.csv"
 
process figures_making {
  publishDir '/net/seq/data2/projects/apetukhova/ENCODE4/scripts/barcodes_matching/nf-scATAC-mapping/test/output/', mode: 'copy', overwrite: true
  tag "${ids}"
  conda '/home/apetukhova/anaconda3/envs/snapatac/'
///net/seq/data2/projects/apetukhova/ENCODE4/scripts/barcodes_matching/nf-scATAC-mapping/environment.yml'
 
  input:
    tuple val(ids), val(counts_file), val(input_file), val(barcodes_map), val(index_mapping), path(full_path_counts_file), path(full_path_input_file), path(full_path_barcodes_map), path(full_path_index_mapping)
 
  output:
    tuple val(ids), path(less_than_10000_fragments_hist), path(less_than_10000_fragments_hist_log), path(more_than_2000_fragments_hist_log), path(leiden_plot_4000_fragments), path(fragments_plot_4000_fragments), path(leiden_plot_2000_fragments), path(fragments_plot_2000_fragments) 
 
  script:
  less_than_10000_fragments_hist = "${ids}_cells_more_than_2000_and_less_than_10000_fragments_hist.pdf"
  less_than_10000_fragments_hist_log = "${ids}_cells_more_than_2000_and_less_than_10000_fragments_hist_log.pdf"
  more_than_2000_fragments_hist_log = "${ids}_cells_more_than_2000_fragments_hist_log.pdf"
  leiden_plot_4000_fragments = "${ids}_4000_fragments_number_of_fragments_plot.pdf"
  fragments_plot_4000_fragments = "${ids}_4000_fragments_leiden_plot.pdf"
  leiden_plot_2000_fragments = "${ids}_2000_fragments_number_of_fragments_plot.pdf"
  fragments_plot_2000_fragments = "${ids}_2000_fragments_leiden_plot.pdf"
  """
  set -eou pipefail

  python $moduleDir/bin/scATAC_clusterization_snapATAC_and_figures_making.py ${ids} ${counts_file} ${input_file} ${barcodes_map} ${index_mapping}
  """
}

workflow {
  data = Channel.fromPath(params.info)
      .splitCsv(header:true, sep:',')
    .map(row -> tuple(row.ids, row.counts_file, row.input_file, row.barcodes_map, row.index_mapping, row.full_path_counts_file, row.full_path_input_file, row.full_path_barcodes_map, row.full_path_index_mapping))
  figures_making(data) 
}
