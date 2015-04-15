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

function! OpenBuffer(content)
python << EOF

import vim
BUFFER_NAME = '__RayVimAndroid__'
existing_buffer_window_id = \
    vim.eval('bufwinnr("%s")' % BUFFER_NAME)
if existing_buffer_window_id == '-1':
    vim.command('vsplit %s' % BUFFER_NAME)
    vim.command('setlocal buftype=nofile nospell')
    vim.current.window.width = 20
else:
    vim.command('%swincmd w' % existing_buffer_window_id)
del vim.current.buffer[:]
vim.current.buffer.append(vim.eval("a:content"))
EOF
endfunction
