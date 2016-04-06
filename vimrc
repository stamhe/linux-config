" 语法高亮显示
syntax on
set fileencodings=utf-8,gb2312,gbk,cp936,latin-1
set fileencoding=utf-8
set termencoding=utf-8
set fileformat=unix
set encoding=utf-8
" 配色方案
colorscheme desert
" 指定配色方案是256色
set t_Co=256

"去掉有关vi一致性模式，避免以前版本的一些bug和局限，解决backspace不能使用的问题
set nocompatible
set backspace=indent,eol,start
set backspace=2
" 启用自动对齐功能，把上一行的对齐格式应用到下一行
set autoindent
" 依据上面的格式，智能的选择对齐方式，对于类似C语言编写很有用处
set smartindent

"vim禁用自动备份
set nobackup
set nowritebackup
set noswapfile

"在屏幕底部显示光标所在的行、列位置
set ruler
"set noruler

" 光标所在的行出现一条白色的线
"set cursorline

" 用空格代替tab
set expandtab

" 不用空格代替tab
"set noexpandtab

"设置显示制表符的空格字符个数,改进tab缩进值，默认为8，现改为4
"set tabstop=value
set tabstop=4
"统一缩进为4，方便在开启了et后使用退格(backspace)键，每次退格将删除X个空格
set softtabstop=4
"设定自动缩进为4个字符，程序中自动缩进所使用的空白长度
set shiftwidth=4
"用space替代tab的输入
set expandtab
"set noexpandtab

"设置帮助文件为中文(需要安装vimcdoc文档)
set helplang=cn
" 显示匹配的括号
set showmatch
" 智能缩进(smtart indent)
set si
" 自动缩进(auto indent)
set ai
" wrap lines
"set wrap

" 文件缩进及tab个数
au FileType html,python,vim,javascript setl shiftwidth=2
au FileType html,python,vim,javascript setl tabstop=2
au FileType java,php setl shiftwidth=4
au FileType java,php setl tabstop=4

" 自动更新被外部更改后的文件
"set autoread

"设置vim的历史记录条数
"set history=400

" have the mouse enabled all the time
"set mouse=a

"设置命令条离底边的高度
"set cmdheight=2

" 搜索时对大小写不敏感
" set incsearch

" 错误时关闭声音
"set noerrorbells
"set novisualbell
"set t_vb=

" 高亮搜索的字符串
" set hlsearch
" set nohlsearch

" F2 保存文件
nmap <F2>	:w<CR>
imap <F2>	<ESC>:w<CR>

" NERDTree
nmap <F10> :NERDTreeToggle<CR>
imap <F10> <ESC>:NERDTreeToggle<CR>

" F8打开Tlist
nmap <F8>	:TlistToggle<CR>
imap <F8>	<ESC>:TlistToggle<CR>

" F12建立tag文件
nmap <F12>	:!ctags -R --c-kinds=+p --fields=+liaS --extra=+q ./<CR>
imap <F12>	<ESC>:!ctags -R --c-kinds=+p --fields=+liaS --extra=+q ./<CR>

" 检测文件的类型
filetype on
filetype plugin on
filetype indent on
" C风格缩进
set cindent
set completeopt=longest,menu

"set tags+=/data/tag/tags
set tags+=tags
"au BufWritePost *.c,*.cpp,*.cc,*.h !ctags -R --c++-kinds=+p --fields=+liaS --extra=+q

"左右键自动代码提示
let g:EchoFuncKeyPrev='<LEFT>'
let g:EchoFuncKeyNext='<RIGHT>'

"let g:EchoFuncKeyPrev='<Esc>+'
"let g:EchoFuncKeyNext='<Esc>-'
