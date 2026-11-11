#!/bin/bash

logfile=job_results.log

echo "The script ran at the following time: $(date)" > $logfile

# at 17:15 -f ./scheduling_jobs.sh
# atq -> to view the queue
# atrm <number_job> -> to delete the job <number_job>
# at 18:00 110226 -f ./scheduling_jobs -> to carry out the task on November 2, 2026
# at -c <ID_JOB> -> to see the content of the job
# Separate using queues from a to z: (the -q flag must be used)
# at 15:30 -q b -f backup.sh
# at 15:30 -q d -f limpeza.sh


