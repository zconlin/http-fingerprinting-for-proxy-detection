rule evilginx_chromium_detected {
    strings:
        $host = "Host:"
        $user_agent = "User-Agent:"
        $evilginx_header = "X-Evilginx:"
        $dnt_lowercase = "Dnt:"
        $pragma = "Pragma: no-cache"
        $connection = "Connection: keep-alive"
        $sec_ch_ua_capitalized = "Sec-Ch-Ua"

    condition:
        (
            @host < @user_agent and

            not $pragma and
            not $connection and
            $dnt_lowercase and

            $sec_ch_ua_capitalized
        ) or

        $evilginx_header

}