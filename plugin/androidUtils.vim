function! FindManifestFile() " refer to bpowell/vim-android
python << EOF

import vim
import os

old_dir = pwd = os.getcwd()

def find_manifest(path):
    dirs = os.listdir(path)
    for d in dirs:
        if d == 'AndroidManifest.xml':
            return os.getcwd()
    return ""

path_found = ''    
while(path_found == find_manifest(pwd) is ""):
    if pwd == '/':
        break
    pwd = os.chdir(pwd+'/..')

if path_found is not '':
    vim.current.buffer.append(path_found)
else:
    vim.current.buffer.append("Not found!)
os.chdir(old_dir)
EOF
endfunction
