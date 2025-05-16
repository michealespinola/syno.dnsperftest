*Note: This script is a majorly overhauled fork.*

# DNS Performance Test

Shell script to test the performance of the most popular DNS resolvers from your location.

The accompanying ipv4 and ipv6 text files contain the redundant servers of notable DNS providers by default, including:

* AdGuard
* CleanBrowsing 
* Cloudflare (aka 1.1.1.1)
* Comodo
* DNS.Watch
* Google (aka 8.8.8.8)
* Level3 (aka 4.2.2.1)
* Neustar
* OpenDNS (aka 208.67.222.222)
* OracleDyn
* Quad9 (aka 9.9.9.9)

...as well as the redundant servers of these other well-known providers:

* AlternateDNS
* ControlD
* DNSFilter
* Freenom
* NextDNS
* NortonCS 
* SafeDNS
* UncensoredDNS
* Verisign
* Yandex 

13 default domain names are tested, with many others available as toggleable in the accompanying text files, or simply add your own:

* docker.io
* github.com
* gmail.com
* www.amazon.com
* www.apple.com
* www.facebook.com
* www.google.com
* www.paypal.com
* www.reddit.com
* www.twitter.com
* www.wikipedia.org
* www.yahoo.com
* www.youtube.com

# Requirements 

* `dig` needs to be in the PATH. If you don't have it, the script will provide instructions for where to get it.
* `bc` is no longer a requirement of this script since being forked. `awk` is used instead for greater wide-spread availability - particularly for Synology.

# Utilization and example output:

    # bash dnsreload.sh && bash dnstest.sh

    CHECKING FOR LOCAL DNS SERVER AND FLUSHING CACHE
    
          Local DNS: tcp/53 pihole-FTL (pid:31093)
               Type: docker (pihole)
             Action: Reloading Pi-hole DNS (pihole-FTL)
    
    
    TESTING DOMAINS (dnstest.domains.txt)
    
       Test# Domain Name
      ------ ---------------
          t1 docker.io
          t2 github.com
          t3 gmail.com
          t4 www.amazon.com
          t5 www.apple.com
          t6 www.facebook.com
          t7 www.google.com
          t8 www.paypal.com
          t9 www.reddit.com
         t10 www.twitter.com
         t11 www.wikipedia.org
         t12 www.yahoo.com
         t13 www.youtube.com
    
    
    LOCAL THEN ALPHABETICAL BY SERVER (dnstest.log)
    
    Server           t1  t2  t3  t4  t5  t6  t7  t8  t9  t10 t11 t12 t13 Median ms
    ---------------- --- --- --- --- --- --- --- --- --- --- --- --- --- ---------
    pihole-FTL/I     32  21  24  30  44  67  17  19  18  20  52  19  19   29.38 ms
    pihole-FTL/C     1   1   1   1   1   1   1   1   2   1   1   2   5     1.46 ms
    nameserver/1     19  26  29  31  36  66  19  18  15  19  91  19  39   32.85 ms
    nameserver/2     17  22  24  23  87  17  18  18  18  19  86  18  51   32.15 ms
    114DNS/1         19  18  19  17  20  19  19  19  18  23  18  16  19   18.77 ms
    114DNS/2         18  17  17  19  17  17  17  19  24  19  18  22  18   18.62 ms
    AdGuard/1        18  19  18  18  19  17  18  19  19  18  19  20  18   18.46 ms
    AdGuard/2        19  19  18  20  19  19  19  19  18  20  18  20  17   18.85 ms
    AliDNS/1         182 185 181 187 185 183 189 180 193 184 180 187 184 184.62 ms
    AliDNS/2         195 181 190 180 194 186 190 180 182 194 181 194 176 186.38 ms
    AlternateDNS/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    AlternateDNS/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    CenturyLink/1    61  25  26  31  27  27  25  28  30  25  28  31  25   29.92 ms
    CenturyLink/2    44  28  35  28  29  27  34  28  29  34  28  29  27   30.77 ms
    ChinaTCL-UNC/1   *   *   *   *   *   182 *   *   *   181 *   *   184 811.31 ms
    ChinaTCL-UNC/2   *   *   *   *   *   191 *   *   *   188 *   *   188 812.85 ms
    CleanBrowsing/1  24  17  17  19  18  19  19  20  19  18  24  18  24   19.69 ms
    CleanBrowsing/2  160 160 167 155 160 160 161 154 159 159 159 159 159 159.38 ms
    Cloudflare/1     27  14  13  13  13  62  28  14  13  16  13  13  118  27.46 ms
    Cloudflare/2     12  9   15  12  14  15  13  15  9   13  54  13  13   15.92 ms
    CNNICSDNS/1      254 256 355 361 263 250 249 *   396 259 811 261 242 381.31 ms
    CNNICSDNS/2      421 267 467 255 260 256 412 *   243 225 335 353 305 369.15 ms
    Comodo/1         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    Comodo/2         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    ControlD/1       21  23  21  30  26  21  21  26  16  23  22  27  18   22.69 ms
    ControlD/2       19  17  12  20  20  27  19  17  20  24  19  17  23   19.54 ms
    DNSFilter/1      19  17  18  19  17  14  19  20  19  18  19  18  22   18.38 ms
    DNSFilter/2      24  23  18  13  18  19  18  17  24  19  14  25  19   19.31 ms
    DNSpai/1         159 207 312 *   171 151 159 166 164 151 159 174 149 240.15 ms
    DNSpai/2         199 279 361 221 201 190 197 194 221 192 203 219 192 220.69 ms
    DNSPodDNS+/1     445 427 433 414 400 506 412 381 383 375 449 378 406 416.08 ms
    DNSPodDNS+/2     275 249 207 186 190 201 211 207 189 251 204 248 196 216.46 ms
    DNS.WATCH/1      169 178 *   184 *   *   180 166 *   164 *   *   *   618.54 ms
    DNS.WATCH/2      166 158 177 153 168 156 156 166 156 156 153 154 156 159.62 ms
    Freenom/1        93  70  112 26  27  25  25  170 101 154 202 26  26   81.31 ms
    Freenom/2        23  26  25  23  25  27  26  27  33  26  28  27  27   26.38 ms
    Google/1         18  21  32  31  18  19  17  18  16  18  28  21  18   21.15 ms
    Google/2         19  19  19  28  17  19  19  18  16  13  52  19  19   21.31 ms
    Level3/1         26  14  24  18  22  19  19  18  20  18  17  25  18   19.85 ms
    Level3/2         19  18  19  19  24  21  20  24  21  18  24  18  13   19.85 ms
    Neustar/1        37  29  45  31  31  27  41  42  30  44  34  31  35   35.15 ms
    Neustar/2        93  30  25  20  26  27  20  19  12  12  22  17  18   26.23 ms
    NextDNS/1        15  23  18  19  18  18  15  17  19  19  19  19  26   18.85 ms
    NextDNS/2        25  18  16  26  21  18  19  18  14  20  18  18  17   19.08 ms
    NortonCS/1       31  20  19  19  20  18  19  19  24  17  17  20  20   20.23 ms
    NortonCS/2       29  40  31  33  28  31  31  32  32  30  32  30  31   31.54 ms
    OneDNS/1         *   *   *   *   *   172 *   *   *   171 *   *   172 808.85 ms
    OneDNS/2         180 388 178 183 224 171 195 234 177 171 184 181 172 202.92 ms
    OpenDNS/1        23  19  25  29  30  20  18  29  18  19  50  21  20   24.69 ms
    OpenDNS/2        12  14  17  26  29  36  17  18  17  13  18  20  18   19.62 ms
    OracleDyn/1      227 76  75  73  78  75  75  79  82  70  166 73  76   94.23 ms
    OracleDyn/2      137 76  75  75  77  79  73  73  77  76  144 74  76   85.54 ms
    Quad9/1          19  19  24  18  20  18  19  19  19  18  24  20  19   19.69 ms
    Quad9/2          19  22  24  88  29  67  96  267 112 119 78  74  59   81.08 ms
    SafeDNS/1        21  19  19  38  20  20  19  17  15  20  18  23  15   20.31 ms
    SafeDNS/2        18  20  18  19  19  20  17  18  13  20  19  20  18   18.38 ms
    SKTelecom/1      156 157 162 155 153 160 156 160 162 163 154 226 155 163.00 ms
    SKTelecom/2      162 156 154 155 153 161 155 157 151 159 156 163 160 157.08 ms
    Verisign/1       28  30  31  29  31  30  28  28  28  30  33  35  32   30.23 ms
    Verisign/2       21  15  18  18  18  19  19  19  18  19  20  23  19   18.92 ms
    Yandex/1         214 201 212 203 221 205 196 240 205 239 203 204 204 211.31 ms
    Yandex/2         208 206 202 198 204 207 220 207 212 211 240 217 222 211.85 ms
    
    
    ALL SERVERS BY MEDIAN RESPONSE TIME (dnstest.sorted.log)
    
    Server           t1  t2  t3  t4  t5  t6  t7  t8  t9  t10 t11 t12 t13 Median ms
    ---------------- --- --- --- --- --- --- --- --- --- --- --- --- --- ---------
    pihole-FTL/C     1   1   1   1   1   1   1   1   2   1   1   2   5     1.46 ms
    Cloudflare/2     12  9   15  12  14  15  13  15  9   13  54  13  13   15.92 ms
    DNSFilter/1      19  17  18  19  17  14  19  20  19  18  19  18  22   18.38 ms
    SafeDNS/2        18  20  18  19  19  20  17  18  13  20  19  20  18   18.38 ms
    AdGuard/1        18  19  18  18  19  17  18  19  19  18  19  20  18   18.46 ms
    114DNS/2         18  17  17  19  17  17  17  19  24  19  18  22  18   18.62 ms
    114DNS/1         19  18  19  17  20  19  19  19  18  23  18  16  19   18.77 ms
    AdGuard/2        19  19  18  20  19  19  19  19  18  20  18  20  17   18.85 ms
    NextDNS/1        15  23  18  19  18  18  15  17  19  19  19  19  26   18.85 ms
    Verisign/2       21  15  18  18  18  19  19  19  18  19  20  23  19   18.92 ms
    NextDNS/2        25  18  16  26  21  18  19  18  14  20  18  18  17   19.08 ms
    DNSFilter/2      24  23  18  13  18  19  18  17  24  19  14  25  19   19.31 ms
    ControlD/2       19  17  12  20  20  27  19  17  20  24  19  17  23   19.54 ms
    OpenDNS/2        12  14  17  26  29  36  17  18  17  13  18  20  18   19.62 ms
    CleanBrowsing/1  24  17  17  19  18  19  19  20  19  18  24  18  24   19.69 ms
    Quad9/1          19  19  24  18  20  18  19  19  19  18  24  20  19   19.69 ms
    Level3/1         26  14  24  18  22  19  19  18  20  18  17  25  18   19.85 ms
    Level3/2         19  18  19  19  24  21  20  24  21  18  24  18  13   19.85 ms
    NortonCS/1       31  20  19  19  20  18  19  19  24  17  17  20  20   20.23 ms
    SafeDNS/1        21  19  19  38  20  20  19  17  15  20  18  23  15   20.31 ms
    Google/1         18  21  32  31  18  19  17  18  16  18  28  21  18   21.15 ms
    Google/2         19  19  19  28  17  19  19  18  16  13  52  19  19   21.31 ms
    ControlD/1       21  23  21  30  26  21  21  26  16  23  22  27  18   22.69 ms
    OpenDNS/1        23  19  25  29  30  20  18  29  18  19  50  21  20   24.69 ms
    Neustar/2        93  30  25  20  26  27  20  19  12  12  22  17  18   26.23 ms
    Freenom/2        23  26  25  23  25  27  26  27  33  26  28  27  27   26.38 ms
    Cloudflare/1     27  14  13  13  13  62  28  14  13  16  13  13  118  27.46 ms
    pihole-FTL/I     32  21  24  30  44  67  17  19  18  20  52  19  19   29.38 ms
    CenturyLink/1    61  25  26  31  27  27  25  28  30  25  28  31  25   29.92 ms
    Verisign/1       28  30  31  29  31  30  28  28  28  30  33  35  32   30.23 ms
    CenturyLink/2    44  28  35  28  29  27  34  28  29  34  28  29  27   30.77 ms
    NortonCS/2       29  40  31  33  28  31  31  32  32  30  32  30  31   31.54 ms
    nameserver/2     17  22  24  23  87  17  18  18  18  19  86  18  51   32.15 ms
    nameserver/1     19  26  29  31  36  66  19  18  15  19  91  19  39   32.85 ms
    Neustar/1        37  29  45  31  31  27  41  42  30  44  34  31  35   35.15 ms
    Quad9/2          19  22  24  88  29  67  96  267 112 119 78  74  59   81.08 ms
    Freenom/1        93  70  112 26  27  25  25  170 101 154 202 26  26   81.31 ms
    OracleDyn/2      137 76  75  75  77  79  73  73  77  76  144 74  76   85.54 ms
    OracleDyn/1      227 76  75  73  78  75  75  79  82  70  166 73  76   94.23 ms
    SKTelecom/2      162 156 154 155 153 161 155 157 151 159 156 163 160 157.08 ms
    CleanBrowsing/2  160 160 167 155 160 160 161 154 159 159 159 159 159 159.38 ms
    DNS.WATCH/2      166 158 177 153 168 156 156 166 156 156 153 154 156 159.62 ms
    SKTelecom/1      156 157 162 155 153 160 156 160 162 163 154 226 155 163.00 ms
    AliDNS/1         182 185 181 187 185 183 189 180 193 184 180 187 184 184.62 ms
    AliDNS/2         195 181 190 180 194 186 190 180 182 194 181 194 176 186.38 ms
    OneDNS/2         180 388 178 183 224 171 195 234 177 171 184 181 172 202.92 ms
    Yandex/1         214 201 212 203 221 205 196 240 205 239 203 204 204 211.31 ms
    Yandex/2         208 206 202 198 204 207 220 207 212 211 240 217 222 211.85 ms
    DNSPodDNS+/2     275 249 207 186 190 201 211 207 189 251 204 248 196 216.46 ms
    DNSpai/2         199 279 361 221 201 190 197 194 221 192 203 219 192 220.69 ms
    DNSpai/1         159 207 312 *   171 151 159 166 164 151 159 174 149 240.15 ms
    CNNICSDNS/2      421 267 467 255 260 256 412 *   243 225 335 353 305 369.15 ms
    CNNICSDNS/1      254 256 355 361 263 250 249 *   396 259 811 261 242 381.31 ms
    DNSPodDNS+/1     445 427 433 414 400 506 412 381 383 375 449 378 406 416.08 ms
    DNS.WATCH/1      169 178 *   184 *   *   180 166 *   164 *   *   *   618.54 ms
    OneDNS/1         *   *   *   *   *   172 *   *   *   171 *   *   172 808.85 ms
    ChinaTCL-UNC/1   *   *   *   *   *   182 *   *   *   181 *   *   184 811.31 ms
    ChinaTCL-UNC/2   *   *   *   *   *   191 *   *   *   188 *   *   188 812.85 ms
    AlternateDNS/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    AlternateDNS/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    Comodo/1         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    Comodo/2         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    
    
    RESULTS WITH QUERY TIMEOUTS
    
    Server           t1  t2  t3  t4  t5  t6  t7  t8  t9  t10 t11 t12 t13 Median ms
    ---------------- --- --- --- --- --- --- --- --- --- --- --- --- --- ---------
    DNSpai/1         159 207 312 *   171 151 159 166 164 151 159 174 149 240.15 ms
    CNNICSDNS/2      421 267 467 255 260 256 412 *   243 225 335 353 305 369.15 ms
    CNNICSDNS/1      254 256 355 361 263 250 249 *   396 259 811 261 242 381.31 ms
    DNS.WATCH/1      169 178 *   184 *   *   180 166 *   164 *   *   *   618.54 ms
    OneDNS/1         *   *   *   *   *   172 *   *   *   171 *   *   172 808.85 ms
    ChinaTCL-UNC/1   *   *   *   *   *   182 *   *   *   181 *   *   184 811.31 ms
    ChinaTCL-UNC/2   *   *   *   *   *   191 *   *   *   188 *   *   188 812.85 ms
    AlternateDNS/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    AlternateDNS/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    Comodo/1         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
    Comodo/2         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to

    
    RESPONDING PROVIDERS BY AVERAGED MEDIAN RESPONSE TIMES
    
    Provider           Average Servers
    ---------------- --------- -------
    pihole-FTL        15.42 ms (2)
    AdGuard           18.66 ms (2)
    114DNS            18.70 ms (2)
    DNSFilter         18.84 ms (2)
    NextDNS           18.96 ms (2)
    SafeDNS           19.34 ms (2)
    Level3            19.85 ms (2)
    ControlD          21.11 ms (2)
    Google            21.23 ms (2)
    Cloudflare        21.69 ms (2)
    OpenDNS           22.16 ms (2)
    Verisign          24.57 ms (2)
    NortonCS          25.89 ms (2)
    CenturyLink       30.34 ms (2)
    Neustar           30.69 ms (2)
    nameserver        32.50 ms (2)
    Quad9             50.38 ms (2)
    Freenom           53.84 ms (2)
    CleanBrowsing     89.53 ms (2)
    OracleDyn         89.89 ms (2)
    SKTelecom        160.04 ms (2)
    AliDNS           185.50 ms (2)
    Yandex           211.58 ms (2)
    DNSpai           230.42 ms (2)
    DNSPodDNS+       316.27 ms (2)
    CNNICSDNS        375.23 ms (2)
    DNS.WATCH        389.08 ms (2)
    OneDNS           505.88 ms (2)
    ChinaTCL-UNC     812.08 ms (2)
