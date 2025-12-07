{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Offensive Tools (Isolated)
    nmap        # Network scanner and mapper
    metasploit  # Penetration testing framework
    # responder # check if in nixpkgs
    # wireshark
  ];
}
