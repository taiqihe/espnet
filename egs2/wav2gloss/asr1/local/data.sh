#!/bin/bash

sort_file(){
	mv  $1 "${1}.bak"
	sort "${1}.bak" > $1
}


splits=(train dev test)
for split in ${splits[@]}; do
	utt2spk="data/$split/utt2spk"
	sort_file $utt2spk
	sort_file "data/$split/text"
	sort_file "data/$split/wav.scp"
	./utils/utt2spk_to_spk2utt.pl $utt2spk > "data/$split/spk2utt"
done