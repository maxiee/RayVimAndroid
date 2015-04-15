function! FindManifestFile() " refer to bpowell/vim-android
python << EOF

import vim
import os

old_dir = pwd = os.getcwd()

def find_manifest(path):
    dirs = os.listdir(path)
    for d in dirs:
        vim.current.buffer.append('\t' + d)
        if d == 'AndroidManifest.xml':
            return os.getcwd()
    return ""

path_found = find_manifest(pwd) 
while(path_found is "" and pwd is not '/'):
    path_found = find_manifest(pwd)
    os.chdir(pwd+'/..')
    pwd = os.getcwd()

if path_found is not '':
    vim.current.buffer.append(path_found)
else:
    vim.current.buffer.append("Not found!")
os.chdir(old_dir)
EOF
endfunction
