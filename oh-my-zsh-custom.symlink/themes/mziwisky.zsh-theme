local ret_status="%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ %s)"
PROMPT='${ret_status}%{$green%}%p %{$fg[cyan]%}%c %{$fg[blue]%}$(git_prompt_info)%{$blue%}%{$fg[green]%}$ %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*%{$fg[blue]%}) "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "
