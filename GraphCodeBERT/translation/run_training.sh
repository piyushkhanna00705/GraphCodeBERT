#!/bin/bash -x
#SBATCH --gres=gpu:A6000:2
#SBATCH --mem=128G
###SBATCH --cpus-per-task=4
#SBATCH -t 1-00:00              # time limit: (D-HH:MM) 
#SBATCH --job-name=graph_codebert
#SBATCH --mail-type=ALL
#SBATCH --mail-user=piyushkh@andrew.cmu.edu
#SBATCH --partition=babel-shared-long


source=java
target=cs
lr=1e-4
batch_size=32
beam_size=10
source_length=320
target_length=256
output_dir=saved_models/$source-$target/
train_file=data/train.java-cs.txt.$source,data/train.java-cs.txt.$target
dev_file=data/valid.java-cs.txt.$source,data/valid.java-cs.txt.$target
epochs=100
pretrained_model=microsoft/graphcodebert-base

mkdir -p $output_dir
python run.py \
--do_train \
--do_eval \
--model_type roberta \
--source_lang $source \
--model_name_or_path $pretrained_model \
--tokenizer_name microsoft/graphcodebert-base \
--config_name microsoft/graphcodebert-base \
--train_filename $train_file \
--dev_filename $dev_file \
--output_dir $output_dir \
--max_source_length $source_length \
--max_target_length $target_length \
--beam_size $beam_size \
--train_batch_size $batch_size \
--eval_batch_size $batch_size \
--learning_rate $lr \
--num_train_epochs $epochs 2>&1| tee $output_dir/train.log