import pytest
import torch

from espnet2.asr.frontend.huggingface import HuggingFaceFrontend

pytest.importorskip("transformers", minversion="4.43.0")


@pytest.mark.timeout(4)
@pytest.mark.parametrize(
    "model, fs",
    [
        ("facebook/hubert-base-ls960", 16000),
        ("microsoft/wavlm-base-plus", 16000),
    ],
)
def test_frontend_backward(model, fs):
    frontend = HuggingFaceFrontend(
        model,
        fs=fs,
        download_dir="./hf_cache",
        load_pretrained=False,
    )
    wavs = torch.randn(2, fs, requires_grad=True)
    lengths = torch.LongTensor([fs, fs])
    feats, f_lengths = frontend(wavs, lengths)
    feats.sum().backward()