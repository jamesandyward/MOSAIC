#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

cattle_rmap <- read.table(args[1], header = TRUE)

rates <- function(chr) {
  cattle_rmap$mean_map <- (cattle_rmap$map_f + cattle_rmap$map_m)/2
  chr.rates <- cattle_rmap[cattle_rmap$Chr== chr,]
  chr.rates$cum_rates <- cumsum(chr.rates$mean_map)*100
  sites <- matrix(, nrow = 1, ncol = length(chr.rates$Name))
  pos <- t(chr.rates$Location)
  r_rate <- t(chr.rates$cum_rates)
  d <- list(sites, pos, r_rate)
  x <- do.call(rbind, d)
  x[1,1] <- paste(":sites:", length(chr.rates$Name), sep = "")
  x[is.na(x)] <- " "
  write.table(x, quote = F,row.names = F, col.names = F, file=paste0(args[2], "rates.",chr))
}

chrs <- c(1:29)

lapply(chrs, rates)