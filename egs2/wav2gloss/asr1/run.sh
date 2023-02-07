#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set="train"
train_dev="dev"
test_set="test"

asr_config=conf/tuning/train_asr_transformer_default_xlsr_linear.yaml
inference_config=conf/tuning/decode_asr.yaml

./asr.sh \
    --local_data_opts "--stage 1" \
    --stage 1 \
    --stop_stage 100 \
    --ngpu 1 \
    --nj 2 \
    --inference_nj 2 \
    --use_lm true \
    --token_type char \
    --feats_type raw \
    --audio_format wav \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --inference_asr_model valid.acc.best.pth \
    --expdir 'kke_ur_xlsr' \
    --lm_train_text "data/${train_set}/text"  "$@"
    
