
#======================= setup for running... ==============================#

"ppaste" <- function(...){paste(...,sep="")}

args <- commandArgs(TRUE)

cat(ppaste("Command-line arguments:\n"))
print(args)

####
# sim_zero ==> Lowest possible dataset number
# sim_start ==> Lowest dataset number to be analyzed by this particular batch job
###

###################
sim_start <- 0
#sim_zero <- 1
###################

if (length(args)==0){
  sim_num <- sim_start + 1
  sinkit <- FALSE
} else {
  # SLURM can use either 0- or 1-indexing...
  sinkit <- TRUE
  sim_num <- sim_start + as.numeric(args[1])
}


#i <- sim_num # use i rather than sim_num
sinkfile <- paste("log_step_2_5_6/output_progress_",sim_num,".txt",sep="")

cat(paste("\nAnalyzing dataset number ",sim_num,"...\n\n",sep=""))



#================== Run the simulation study ==============================#

if (sinkit){
  cat(paste("Sinking output to: ",sinkfile,"\n",sep=""))
  sink(sinkfile)
}


user.begin=sim_num
user.end=sim_num

source("task_step_2.R")
