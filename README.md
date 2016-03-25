Profitbricks CLI fish completion
================================
[Profitbricks CLI](https://github.com/profitbricks/profitbricks-cli) completion for the fish shell.

Installation
------------
    mkdir ~/.config/fish/completions
    wget https://raw.github.com/bkendinibilir/profitbricks-cli-fish-completion/master/profitbricks.fish -O ~/.config/fish/completions/profitbricks.fish
    
Example
-------
    % profitbricks server [TAB]
    create  (Create new server)  get            (Get server info)  reboot  (Reboot server)  stop           (Stop server)
    delete      (Delete server)  list  (Show list of all servers)  start    (Start server)  update  (Update server info)
    
    % profitbricks lan create --[TAB]
    --datacenterid  (ID of datacenter)  --name  (Name of NIC)  --public  (Connect LAN to Internet?)
