#! python
import os
import argparse
import shutil

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-d_i', help='MAESTRO original corpus directory (input)')
    parser.add_argument('-d_o', help='MAESTRO renamed corpus directory (output)')
    parser.add_argument('-d_list', help='corpus list directory')
    args = parser.parse_args()

    print('** rename MAESTRO wav/mid file **')
    a_attribute = ['train', 'valid', 'test']
    for attribute in a_attribute:
        with open(args.d_list.rstrip('/') + '/' + attribute + '.tsv', 'r', encoding='utf-8') as f:
            a_in = f.readlines()
        for i in range(1, len(a_in)):
            fname_wav = a_in[i].rstrip('\n').split('\t')[5]
            fname_mid = a_in[i].rstrip('\n').split('\t')[4]
            number = a_in[i].rstrip('\n').split('\t')[7]
            src_wav = args.d_i.rstrip('/') + '/' + fname_wav
            dst_wav = args.d_o.rstrip('/') + '/wav/' + attribute + '_' + number + '.wav'
            src_mid = args.d_i.rstrip('/') + '/' + fname_mid
            dst_mid = args.d_o.rstrip('/') + '/midi/' + attribute + '_' + number + '.mid'
            if os.path.exists(src_wav):
                shutil.copy(src_wav, dst_wav)
            else:
                print(f"File not found: {src_wav}")
            if os.path.exists(src_mid):
                shutil.copy(src_mid, dst_mid)
            else:
                print(f"File not found: {src_mid}")
    print('** done **')
