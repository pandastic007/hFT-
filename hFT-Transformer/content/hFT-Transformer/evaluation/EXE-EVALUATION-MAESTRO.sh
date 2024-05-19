#!/bin/bash

CURRENT_DIR=$(pwd)
DRIVE_DIR=/content/drive/MyDrive

# Set the path to your data and output directories
FILE_LIST=$DRIVE_DIR/OUT/MAESTRO-V3/list/$2.list
FILE_CONFIG=$DRIVE_DIR/OUT/MAESTRO-V3/dataset/config.json
DIR_FEATURE=$DRIVE_DIR/OUT/MAESTRO-V3/feature
DIR_REFERENCE=$DRIVE_DIR/OUT/MAESTRO-V3/reference

DIR_CHECKPOINT=$DRIVE_DIR/OUT/MAESTRO-V3/checkpoint

DIR_RESULT=$DRIVE_DIR/OUT/MAESTRO-V3/result
mkdir -p $DIR_RESULT

MODE=combination
OUTPUT=2nd

# inference
python3 $CURRENT_DIR/evaluation/m_inference.py -f_list $FILE_LIST -f_config $FILE_CONFIG -d_cp $DIR_CHECKPOINT -m $1.pkl -d_fe $DIR_FEATURE -d_mpe $DIR_RESULT -d_note $DIR_RESULT -calc_transcript -mode $MODE &&
# (for half-stride)
#python3 $CURRENT_DIR/evaluation/m_inference.py -f_list $FILE_LIST -f_config $FILE_CONFIG -d_cp $DIR_CHECKPOINT -m $1.pkl -d_fe $DIR_FEATURE -d_mpe $DIR_RESULT -d_note $DIR_RESULT -calc_transcript -mode $MODE  -n_stride 32 &&

# mir_eval
python3 $CURRENT_DIR/evaluation/m_transcription.py -f_list $FILE_LIST -d_ref $DIR_REFERENCE -d_est $DIR_RESULT -d_out $DIR_RESULT -output $OUTPUT &&
python3 $CURRENT_DIR/evaluation/m_transcription.py -f_list $FILE_LIST -d_ref $DIR_REFERENCE -d_est $DIR_RESULT -d_out $DIR_RESULT -output $OUTPUT -velocity &&
python3 $CURRENT_DIR/evaluation/m_mpe.py -f_config $FILE_CONFIG -f_list $FILE_LIST -d_ref $DIR_REFERENCE -d_est $DIR_RESULT -d_out $DIR_RESULT -output $OUTPUT -thred_mpe 0.5
