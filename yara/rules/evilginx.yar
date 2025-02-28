rule evilginx_header_detected {
    strings:
        $evilginx_header = "X-Evilginx:"
        
    condition:
        $evilginx_header
}
    
rule evilginx_chromium_detected {
    strings:
        $host = "Host:"
        $user_agent = "User-Agent:"
        $dnt_lowercase = "Dnt:"
        $pragma = "Pragma: no-cache"
        $connection = "Connection: keep-alive"
        $sec_ch_ua_capitalized = "Sec-Ch-Ua"

    condition:
        @host < @user_agent and

        not $pragma and
        not $connection and
        $dnt_lowercase and

        $sec_ch_ua_capitalized
}

rule evilginx_firefox_detected {
    strings:
        $host = "Host:"
        $user_agent = "User-Agent:"
        $x_forwarded_for = "X-Forwarded-For:"
        $pragma = "Pragma: no-cache"
        $cache_control = "Cache-Control: no-cache"
        $connection = "Connection: keep-alive"
        $cookie = "Cookie:"
        $accept_language = "Accept-Language:"
        $accept_encoding = "Accept-Encoding:"
        $priority = "Priority:"
        $sec_fetch_dest = "Sec-Fetch-Dest:"

    condition:
        @host < @user_agent and
        @user_agent < @x_forwarded_for and
        
        not $pragma and
        not $cache_control and
        not $connection and
        not $cookie and

        $x_forwarded_for and

        @priority < @sec_fetch_dest and  // Priority moved before Sec-Fetch headers
        @accept_encoding < @accept_language  // Accept-Encoding appears before Accept-Language
}

rule modlishka_safari_detected {
    strings:
        $host = "Host:"
        $user_agent = "User-Agent:"
        $x_forwarded_for = "X-Forwarded-For:"
        $upgrade_insecure_requests = "Upgrade-Insecure-Requests:"

    condition:
        @host < @user_agent and
        @user_agent < @x_forwarded_for and

        not $upgrade_insecure_requests
}