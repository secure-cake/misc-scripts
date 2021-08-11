       #Enable all firewall profiles and block inbound TCP Port 445 and 3389
       $ports_to_block = @("445","3389")
       Set-NetFirewallRule -Enabled True
       New-NetFirewallRule -DisplayName "IR: Block $ports_to_block Inbound" -Direction Inbound `
          -LocalPort $ports_to_block -Protocol TCP -Action Block
