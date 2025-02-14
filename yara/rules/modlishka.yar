rule modlishka_chromium_detected {
    strings:
        $host = "Host:"
        $user_agent = "User-Agent:"
        $x_forwarded_for = "X-Forwarded-For:"
        $pragma = "Pragma: no-cache"
        $connection = "Connection: keep-alive"
        $sec_ch_ua_capitalized = "Sec-Ch-Ua"

    condition:
        @host < @user_agent and
        @user_agent < @x_forwarded_for and

        not $pragma and
        not $connection and

        $x_forwarded_for and

        $sec_ch_ua_capitalized
}