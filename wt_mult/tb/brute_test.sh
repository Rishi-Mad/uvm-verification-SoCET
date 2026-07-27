#!/bin/bash

set -e

signs=(u i)
sizes=(4 8 16 24 32 53 64)
stage_depths=(1 2 4 8 10)
merge_prod_gen_reduce_stages=(0 1)
merge_reduce_final_stages=(0 1)

for merge_reduce_final_stage in ${merge_reduce_final_stages[@]}; do
    sed -i -r "s/MERGE_REDUCE_FINAL_STAGES=[0-9]+/MERGE_REDUCE_FINAL_STAGES=$merge_reduce_final_stage/" wt_mult_tb.core
    for merge_prod_gen_reduce_stage in ${merge_prod_gen_reduce_stages[@]}; do
        sed -i -r "s/MERGE_PROD_GEN_REDUCE_STAGES=[0-9]+/MERGE_PROD_GEN_REDUCE_STAGES=$merge_prod_gen_reduce_stage/" wt_mult_tb.core
        for stage_depth in ${stage_depths[@]}; do
            sed -i -r "s/STAGE_DEPTH=[0-9]+/STAGE_DEPTH=$stage_depth/" wt_mult_tb.core
            for sign in ${signs[@]}; do
                for size in ${sizes[@]}; do
                    make ${sign}${size}_test 2>/dev/null &
                done
                wait
            done
        done
    done
done

sed -i -r "s/MERGE_REDUCE_FINAL_STAGES=[0-9]+/MERGE_REDUCE_FINAL_STAGES=0/" wt_mult_tb.core
sed -i -r "s/MERGE_PROD_GEN_REDUCE_STAGES=[0-9]+/MERGE_PROD_GEN_REDUCE_STAGES=0/" wt_mult_tb.core
sed -i -r "s/STAGE_DEPTH=[0-9]+/STAGE_DEPTH=8/" wt_mult_tb.core
