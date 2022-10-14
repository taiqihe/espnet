#!/bin/bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set="train"
train_dev="dev"
test_set="test"

asr_config=conf/train_asr_transformer.yaml
inference_config=conf/decode_asr.yaml

./asr.sh \
    --local_data_opts "--stage 1" \
    --stage 11 \
    --stop_stage 100 \
    --ngpu 1 \
    --nj 16 \
    --inference_nj 16 \
    --use_lm true \
    --token_type bpe \
    --nbpe 1000 \
    --feats_type raw \
    --audio_format wav \
    --asr_config "${asr_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${train_dev}" \
    --test_sets "${test_set}" \
    --inference_asr_model valid.acc.best.pth \
    --expdir 'jya_text' \
    --lm_train_text "data/${train_set}/text"  "$@"
    
