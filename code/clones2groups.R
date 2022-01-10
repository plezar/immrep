library(rprojroot)

library("optparse")

option_list = list(
  make_option(c("-i", "--input"), type="character", default=NULL,
              help="path to immunarch input data, in rds format"),
  make_option(c("-d", "--downsample"), type="character", default=NULL,
              help="whether to downsample to a fixed number of cells. Can either be a number or just True"),
  make_option(c("-g", "--group-by"), type="character", default=NULL,
              help="if set, in addition to the normal midX_clones.csv it will also pool together samples according to the specified variable (eg, mouse)"),
  make_option(c("-p", "--pool-samples"), type="character", default=F,
              help="if True, all samples will be pooled")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)
print(opt)

root <- is_vcs_root$make_fix_file()

source(root("code/util.R"))

if (is.null(opt$downsample)) {
  downsample = F
} else if (opt$downsample == "True" || opt$downsample == "T") {
  downsample = T
} else {
  downsample = as.integer(opt$downsample)
}

if (opt$'pool-samples' == "True") {
  pool_samples = T
} else {
  pool_samples = F
}

clones2groups(immdata=opt$input,
  overwrite=F,
  savefasta=F,
  dirname="output",
  downsample=downsample,
  pool_samples=pool_samples,
  save_clustered=T,
  save_collapsed=T)

if (!is.null(opt$'group-by')) {
  clones2groups(immdata=opt$input,
    overwrite=F,
    savefasta=F,
    dirname="output_groups",
    join_by=opt$'group-by',
    pool_samples=T,
    downsample=downsample,
    save_clustered=T,
    save_collapsed=T)
}
