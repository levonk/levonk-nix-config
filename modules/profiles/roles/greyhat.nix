{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Offensive Tools (Isolated)
    nmap
    metasploit
    # responder # check if in nixpkgs
    # wireshark
  ];
}
