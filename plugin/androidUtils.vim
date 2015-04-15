function! FindFile(path, name)
python << EOF

import vim
import os

old_dir = os.getcwd()

def find_file(path, name):
    old_dir = pwd = os.getcwd()
    path_found = ''
    while(path_found is '' and pwd is not '/'):
        dirs = os.listdir(path)
        for d in dirs:
            vim.current.buffer.append('\t' + d)
            if d == name:
                path_found = pwd
        os.chdir(pwd+'/..')
        pwd = os.getcwd()
    return path_found
    
res = find_file(
    vim.eval("a:path"),
    vim.eval("a:name")
)
if res is not '':
    vim.current.buffer.append(res)
else:
    vim.current.buffer.append("Not found!")
os.chdir(old_dir)
EOF
endfunction
