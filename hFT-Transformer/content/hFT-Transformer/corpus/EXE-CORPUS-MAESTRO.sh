#! /bin/bash

CURRENT_DIR=$(pwd)
DRIVE_DIR=/content/drive/MyDrive

# Set the path to your data and output directories
DATA_CSV_PATH=$DRIVE_DIR/TESTDATA2/data_final.csv
OUTPUT_DIR=$DRIVE_DIR/OUT

# 1. make lists that include train/valid/test split
mkdir -p $OUTPUT_DIR/MAESTRO-V3/list
python3 $CURRENT_DIR/corpus/make_list_maestro.py -i $DATA_CSV_PATH -d_list $OUTPUT_DIR/MAESTRO-V3/list

# 2. rename the files (copy instead of symlink)
mkdir -p $OUTPUT_DIR/MAESTRO-V3/midi
mkdir -p $OUTPUT_DIR/MAESTRO-V3/wav
python3 $CURRENT_DIR/corpus/rename_maestro.py -d_i $DRIVE_DIR -d_o $OUTPUT_DIR/MAESTRO-V3 -d_list $OUTPUT_DIR/MAESTRO-V3/list

# 3. convert wav to log-mel spectrogram
mkdir -p $OUTPUT_DIR/MAESTRO-V3/feature
python3 $CURRENT_DIR/corpus/conv_wav2fe.py -d_list $OUTPUT_DIR/MAESTRO-V3/list -d_wav $OUTPUT_DIR/MAESTRO-V3/wav -d_feature $OUTPUT_DIR/MAESTRO-V3/feature -config $CURRENT_DIR/corpus/config.json

# 4. convert midi to note
mkdir -p $OUTPUT_DIR/MAESTRO-V3/note
python3 $CURRENT_DIR/corpus/conv_midi2note.py -d_list $OUTPUT_DIR/MAESTRO-V3/list -d_midi $OUTPUT_DIR/MAESTRO-V3/midi -d_note $OUTPUT_DIR/MAESTRO-V3/note -config $CURRENT_DIR/corpus/config.json

# 5. convert note to label
mkdir -p $OUTPUT_DIR/MAESTRO-V3/label
python3 $CURRENT_DIR/corpus/conv_note2label.py -d_list $OUTPUT_DIR/MAESTRO-V3/list -d_note $OUTPUT_DIR/MAESTRO-V3/note -d_label $OUTPUT_DIR/MAESTRO-V3/label -config $CURRENT_DIR/corpus/config.json

# 6. convert txt to reference for evaluation
mkdir -p $OUTPUT_DIR/MAESTRO-V3/reference
python3 $CURRENT_DIR/corpus/conv_note2ref.py -f_list $OUTPUT_DIR/MAESTRO-V3/list/valid.list -d_note $OUTPUT_DIR/MAESTRO-V3/note -d_ref $OUTPUT_DIR/MAESTRO-V3/reference
python3 $CURRENT_DIR/corpus/conv_note2ref.py -f_list $OUTPUT_DIR/MAESTRO-V3/list/test.list -d_note $OUTPUT_DIR/MAESTRO-V3/note -d_ref $OUTPUT_DIR/MAESTRO-V3/reference

# 7. make dataset
mkdir -p $OUTPUT_DIR/MAESTRO-V3/dataset
python3 $CURRENT_DIR/corpus/make_dataset.py -f_config_in $CURRENT_DIR/corpus/config.json -f_config_out $OUTPUT_DIR/MAESTRO-V3/dataset/config.json -d_dataset $OUTPUT_DIR/MAESTRO-V3/dataset -d_list $OUTPUT_DIR/MAESTRO-V3/list -d_feature $OUTPUT_DIR/MAESTRO-V3/feature -d_label $OUTPUT_DIR/MAESTRO-V3/label -n_div_train 4 -n_div_valid 1 -n_div_test 1
