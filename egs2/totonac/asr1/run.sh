#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set="train"
train_dev="dev"
test_set="test dev"

asr_config=conf/tuning/train_xls_r_conformer.yaml
inference_config=conf/decode_asr.yaml

./asr.sh \
    --local_data_opts "--stage 1" \
    --audio_format "flac.ark" \
    --feats_normalize utterance_mvn \
    --stage 1 \
    --stop_stage 100 \
    --ngpu 4 \
    --nj 16 \
    --inference_nj 4 \
    --gpu_inference true \
    --use_lm true \
    --token_type char \
    --feats_type raw \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --inference_asr_model valid.acc.best.pth \
    --lm_train_text "data/${train_set}/text"  "$@"
