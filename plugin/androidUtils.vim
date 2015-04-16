function! FindFile(name)
python << EOF

import vim
import os

old_dir = os.getcwd()

def find_file(name):
    old_dir = pwd = os.getcwd()
    path_found = ''
    while(path_found is '' and pwd is not '/'):
        dirs = os.listdir(pwd)
        for d in dirs:
            #vim.current.buffer.append('\t' + d)
            if d == name:
                path_found = pwd
        os.chdir(pwd+'/..')
        pwd = os.getcwd()
    return path_found
    
res = find_file(
    vim.eval("a:name")
)
os.chdir(old_dir)
vim.command('let l:result="%s"' % res)
EOF
return l:result
endfunction

function! ParseSettings(path)
python << EOF
import vim
settings = open(vim.eval('a:path') + '/' + 'settings.gradle')
data = settings.read().split(" ")
modules = [module.replace("'","").replace(":","",1).replace(",","").replace("\n","") 
    for module in data][1:] 
#vim.command('echom "%s"' % ' '.join(modules))
vim.command('let l:result = "%s"' % ' '.join(modules))
EOF
return l:result
endfunction

function! OpenBuffer()
python << EOF

import vim
BUFFER_NAME = '__RayVimAndroid__'
existing_buffer_window_id = \
    vim.eval('bufwinnr("%s")' % BUFFER_NAME)
if existing_buffer_window_id == '-1':
    vim.command('vsplit %s' % BUFFER_NAME)
    vim.command('setlocal buftype=nofile nospell')
    vim.current.window.width = 30
else:
    vim.command('%swincmd w' % existing_buffer_window_id)
del vim.current.buffer[:]
EOF
endfunction

function! AndroidProject()
let l:settings = FindFile("settings.gradle")
if l:settings == ""
   echom "Android Project not found!"
   return 
endif
let l:data = "{}"
let l:modules = ParseSettings(l:settings)
echom l:modules
python << EOF
import vim
import json
data = json.loads(vim.eval("l:data"))
res = vim.eval("l:settings")
data['project_name'] = res.split('/')[-1]
module_list = []
for module in vim.eval("l:modules").split(' '):
    dict = {}
    dict['module_name'] = module    
    module_list.append(dict)
data['modules'] = module_list
# format project information
vim.command('call OpenBuffer()')
vim.current.buffer.append(data['project_name'])
vim.current.buffer.append("Modules:")
for module in data['modules']:
    vim.current.buffer.append(module['module_name'])
vim.command('let l:content = \'%s\'' % json.dumps(data))
EOF
endfunction
