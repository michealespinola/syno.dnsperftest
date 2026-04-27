*Note: This script is a majorly overhauled fork. IPv6 processing is currently incomplete.*

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

...as well as the redundant servers of these other well-known providers (and many more):

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
* `bc` is no longer a requirement of this script since being forked. `awk` is used instead for greater wide-spread availability - particularly for Synology. (this need was what initially prompted the creation of this fork)

# Utilization and example output:

```
bash /volume1/homes/admin/scripts/bash/dnstest.sh

CHECKING FOR LOCAL DNS SERVER AND FLUSHING CACHE

      Local DNS: tcp/53 pihole-FTL (pid:31666)
           Type: docker (pihole)
         Action: Reloading Pi-hole DNS (pihole-FTL)


TESTING DOMAINS (dnstest.domains)

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
pihole-FTL/I     18  14  20  15  18  45  21  17  17  14  15  15  17   18.92 ms
pihole-FTL/C     1   1   1   1   1   1   2   2   2   2   1   2   8     1.92 ms
nameserver/1     13  7   13  13  11  43  18  18  19  14  19  16  16   16.92 ms
nameserver/2     13  18  16  13  12  43  15  13  13  8   19  14  14   16.23 ms
114DNS/1         18  19  12  15  18  20  22  22  22  19  21  20  19   19.00 ms
114DNS/2         18  17  18  17  23  25  18  18  19  22  18  18  18   19.15 ms
AdGuard/1        149 18  22  14  19  19  20  15  13  13  20  19  23   28.00 ms
AdGuard/2        21  17  19  22  18  14  20  19  18  16  21  23  17   18.85 ms
AliDNS/1         257 240 243 315 245 231 197 309 229 233 247 267 189 246.31 ms
AliDNS/2         192 193 198 197 191 192 187 365 197 196 195 190 191 206.46 ms
AlternateDNS/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
AlternateDNS/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
CenturyLink/1    107 938 367 426 331 57  247 222 687 *   *   954 404 518.46 ms
CenturyLink/2    28  31  27  30  32  30  30  27  29  33  29  30  30   29.69 ms
ChinaTCL-UNC/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
ChinaTCL-UNC/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
CleanBrowsing/1  66  63  62  63  59  62  60  68  64  110 67  69  58   67.00 ms
CleanBrowsing/2  63  66  65  69  61  63  65  60  64  61  68  64  63   64.00 ms
Cloudflare/1     15  15  13  18  14  39  18  17  19  20  13  15  17   17.92 ms
Cloudflare/2     13  15  18  12  14  19  15  14  17  13  18  18  14   15.38 ms
CNNICSDNS/1      *   217 318 *   235 *   324 *   *   227 *   316 311 611.38 ms
CNNICSDNS/2      *   224 222 *   *   *   323 *   *   223 *   233 228 650.23 ms
Comodo/1         66  69  58  68  61  61  62  71  66  66  62  70  61   64.69 ms
Comodo/2         72  61  63  64  66  64  70  64  60  125 63  62  63   69.00 ms
ControlD/1       28  19  31  20  25  24  21  23  25  28  20  19  19   23.23 ms
ControlD/2       21  23  21  22  23  27  24  24  21  24  19  15  18   21.69 ms
DNSFilter/1      22  18  18  18  18  20  22  17  25  25  18  22  18   20.08 ms
DNSFilter/2      18  17  20  22  18  23  18  17  19  21  19  19  11   18.62 ms
DNSpai/1         180 212 435 991 168 181 165 580 195 185 202 188 171 296.38 ms
DNSpai/2         185 181 186 855 180 202 183 180 237 236 679 189 223 285.85 ms
DNSPodDNS+/1     436 386 399 210 387 389 205 446 450 385 449 382 478 384.77 ms
DNSPodDNS+/2     196 260 202 198 264 201 263 371 212 193 265 253 194 236.31 ms
DNS.WATCH/1      *   *   178 178 *   175 *   *   180 *   313 *   *   694.15 ms
DNS.WATCH/2      *   *   *   *   168 *   *   *   216 220 *   163 190 689.00 ms
Freenom/1        94  40  27  30  27  27  27  137 187 75  209 *   28  146.77 ms
Freenom/2        33  21  29  20  28  31  31  30  31  26  29  30  27   28.15 ms
Google/1         36  22  29  45  29  24  20  24  27  32  65  20  17   30.00 ms
Google/2         24  26  26  37  19  20  19  23  20  18  62  21  19   25.69 ms
Level3/1         21  22  16  19  21  18  21  18  17  23  18  17  19   19.23 ms
Level3/2         18  21  21  19  22  19  23  18  19  22  18  17  23   20.00 ms
Neustar/1        33  25  35  27  36  30  32  30  32  33  37  32  26   31.38 ms
Neustar/2        27  23  18  19  19  17  12  23  25  18  22  15  17   19.62 ms
NextDNS/1        122 22  20  24  26  19  14  23  19  29  19  25  19   29.31 ms
NextDNS/2        52  21  20  20  22  20  21  18  18  22  22  18  21   22.69 ms
NortonCS/1       26  15  19  21  19  17  20  28  19  17  17  18  17   19.46 ms
NortonCS/2       34  36  39  30  33  36  35  33  35  35  30  32  31   33.77 ms
OneDNS/1         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
OneDNS/2         206 188 205 182 192 *   191 188 184 193 180 187 183 252.23 ms
OpenDNS/1        20  20  52  23  26  45  25  19  24  24  54  22  50   31.08 ms
OpenDNS/2        18  18  46  35  33  42  17  18  18  23  20  18  61   28.23 ms
OracleDyn/1      32  38  29  27  34  34  33  32  28  34  36  28  31   32.00 ms
OracleDyn/2      31  34  29  29  28  27  33  32  29  34  49  29  28   31.69 ms
Quad9/1          20  21  18  15  24  23  22  19  20  28  22  21  20   21.00 ms
Quad9/2          23  19  18  18  19  22  19  19  19  19  19  26  25   20.38 ms
SafeDNS/1        29  18  31  23  24  19  16  21  15  19  19  19  19   20.92 ms
SafeDNS/2        20  20  18  19  20  16  19  24  17  19  21  19  15   19.00 ms
SKTelecom/1      204 198 156 179 164 161 159 256 186 192 181 162 171 182.23 ms
SKTelecom/2      168 158 167 180 182 197 166 182 163 180 173 178 156 173.08 ms
Verisign/1       26  31  31  31  28  36  31  27  36  53  32  31  32   32.69 ms
Verisign/2       21  23  20  17  25  21  25  17  18  19  17  18  21   20.15 ms
Yandex/1         215 208 214 216 211 216 211 218 212 211 218 203 210 212.54 ms
Yandex/2         217 212 208 208 209 225 205 217 218 228 215 204 210 213.54 ms


ALL SERVERS BY MEDIAN RESPONSE TIME (dnstest.sorted.log)

Server           t1  t2  t3  t4  t5  t6  t7  t8  t9  t10 t11 t12 t13 Median ms
---------------- --- --- --- --- --- --- --- --- --- --- --- --- --- ---------
pihole-FTL/C     1   1   1   1   1   1   2   2   2   2   1   2   8     1.92 ms
Cloudflare/2     13  15  18  12  14  19  15  14  17  13  18  18  14   15.38 ms
nameserver/2     13  18  16  13  12  43  15  13  13  8   19  14  14   16.23 ms
nameserver/1     13  7   13  13  11  43  18  18  19  14  19  16  16   16.92 ms
Cloudflare/1     15  15  13  18  14  39  18  17  19  20  13  15  17   17.92 ms
DNSFilter/2      18  17  20  22  18  23  18  17  19  21  19  19  11   18.62 ms
AdGuard/2        21  17  19  22  18  14  20  19  18  16  21  23  17   18.85 ms
pihole-FTL/I     18  14  20  15  18  45  21  17  17  14  15  15  17   18.92 ms
114DNS/1         18  19  12  15  18  20  22  22  22  19  21  20  19   19.00 ms
SafeDNS/2        20  20  18  19  20  16  19  24  17  19  21  19  15   19.00 ms
114DNS/2         18  17  18  17  23  25  18  18  19  22  18  18  18   19.15 ms
Level3/1         21  22  16  19  21  18  21  18  17  23  18  17  19   19.23 ms
NortonCS/1       26  15  19  21  19  17  20  28  19  17  17  18  17   19.46 ms
Neustar/2        27  23  18  19  19  17  12  23  25  18  22  15  17   19.62 ms
Level3/2         18  21  21  19  22  19  23  18  19  22  18  17  23   20.00 ms
DNSFilter/1      22  18  18  18  18  20  22  17  25  25  18  22  18   20.08 ms
Verisign/2       21  23  20  17  25  21  25  17  18  19  17  18  21   20.15 ms
Quad9/2          23  19  18  18  19  22  19  19  19  19  19  26  25   20.38 ms
SafeDNS/1        29  18  31  23  24  19  16  21  15  19  19  19  19   20.92 ms
Quad9/1          20  21  18  15  24  23  22  19  20  28  22  21  20   21.00 ms
ControlD/2       21  23  21  22  23  27  24  24  21  24  19  15  18   21.69 ms
NextDNS/2        52  21  20  20  22  20  21  18  18  22  22  18  21   22.69 ms
ControlD/1       28  19  31  20  25  24  21  23  25  28  20  19  19   23.23 ms
Google/2         24  26  26  37  19  20  19  23  20  18  62  21  19   25.69 ms
AdGuard/1        149 18  22  14  19  19  20  15  13  13  20  19  23   28.00 ms
Freenom/2        33  21  29  20  28  31  31  30  31  26  29  30  27   28.15 ms
OpenDNS/2        18  18  46  35  33  42  17  18  18  23  20  18  61   28.23 ms
NextDNS/1        122 22  20  24  26  19  14  23  19  29  19  25  19   29.31 ms
CenturyLink/2    28  31  27  30  32  30  30  27  29  33  29  30  30   29.69 ms
Google/1         36  22  29  45  29  24  20  24  27  32  65  20  17   30.00 ms
OpenDNS/1        20  20  52  23  26  45  25  19  24  24  54  22  50   31.08 ms
Neustar/1        33  25  35  27  36  30  32  30  32  33  37  32  26   31.38 ms
OracleDyn/2      31  34  29  29  28  27  33  32  29  34  49  29  28   31.69 ms
OracleDyn/1      32  38  29  27  34  34  33  32  28  34  36  28  31   32.00 ms
Verisign/1       26  31  31  31  28  36  31  27  36  53  32  31  32   32.69 ms
NortonCS/2       34  36  39  30  33  36  35  33  35  35  30  32  31   33.77 ms
CleanBrowsing/2  63  66  65  69  61  63  65  60  64  61  68  64  63   64.00 ms
Comodo/1         66  69  58  68  61  61  62  71  66  66  62  70  61   64.69 ms
CleanBrowsing/1  66  63  62  63  59  62  60  68  64  110 67  69  58   67.00 ms
Comodo/2         72  61  63  64  66  64  70  64  60  125 63  62  63   69.00 ms
Freenom/1        94  40  27  30  27  27  27  137 187 75  209 *   28  146.77 ms
SKTelecom/2      168 158 167 180 182 197 166 182 163 180 173 178 156 173.08 ms
SKTelecom/1      204 198 156 179 164 161 159 256 186 192 181 162 171 182.23 ms
AliDNS/2         192 193 198 197 191 192 187 365 197 196 195 190 191 206.46 ms
Yandex/1         215 208 214 216 211 216 211 218 212 211 218 203 210 212.54 ms
Yandex/2         217 212 208 208 209 225 205 217 218 228 215 204 210 213.54 ms
DNSPodDNS+/2     196 260 202 198 264 201 263 371 212 193 265 253 194 236.31 ms
AliDNS/1         257 240 243 315 245 231 197 309 229 233 247 267 189 246.31 ms
OneDNS/2         206 188 205 182 192 *   191 188 184 193 180 187 183 252.23 ms
DNSpai/2         185 181 186 855 180 202 183 180 237 236 679 189 223 285.85 ms
DNSpai/1         180 212 435 991 168 181 165 580 195 185 202 188 171 296.38 ms
DNSPodDNS+/1     436 386 399 210 387 389 205 446 450 385 449 382 478 384.77 ms
CenturyLink/1    107 938 367 426 331 57  247 222 687 *   *   954 404 518.46 ms
CNNICSDNS/1      *   217 318 *   235 *   324 *   *   227 *   316 311 611.38 ms
CNNICSDNS/2      *   224 222 *   *   *   323 *   *   223 *   233 228 650.23 ms
DNS.WATCH/2      *   *   *   *   168 *   *   *   216 220 *   163 190 689.00 ms
DNS.WATCH/1      *   *   178 178 *   175 *   *   180 *   313 *   *   694.15 ms
AlternateDNS/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
AlternateDNS/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
ChinaTCL-UNC/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
ChinaTCL-UNC/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
OneDNS/1         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to


RESULTS WITH QUERY TIMEOUTS

Server           t1  t2  t3  t4  t5  t6  t7  t8  t9  t10 t11 t12 t13 Median ms
---------------- --- --- --- --- --- --- --- --- --- --- --- --- --- ---------
Freenom/1        94  40  27  30  27  27  27  137 187 75  209 *   28  146.77 ms
OneDNS/2         206 188 205 182 192 *   191 188 184 193 180 187 183 252.23 ms
CenturyLink/1    107 938 367 426 331 57  247 222 687 *   *   954 404 518.46 ms
CNNICSDNS/1      *   217 318 *   235 *   324 *   *   227 *   316 311 611.38 ms
CNNICSDNS/2      *   224 222 *   *   *   323 *   *   223 *   233 228 650.23 ms
DNS.WATCH/2      *   *   *   *   168 *   *   *   216 220 *   163 190 689.00 ms
DNS.WATCH/1      *   *   178 178 *   175 *   *   180 *   313 *   *   694.15 ms
AlternateDNS/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
AlternateDNS/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
ChinaTCL-UNC/1   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
ChinaTCL-UNC/2   *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to
OneDNS/1         *   *   *   *   *   *   *   *   *   *   *   *   *    NR 13-to


RESPONDING PROVIDERS BY AVERAGED MEDIAN RESPONSE TIMES

Provider           Average Servers
---------------- --------- -------
pihole-FTL        10.42 ms (2) 127.0.0.1, 127.0.0.1
nameserver        16.57 ms (2) 1.1.1.1, 1.0.0.1
Cloudflare        16.65 ms (2) 1.1.1.1, 1.0.0.1
114DNS            19.07 ms (2) 114.114.114.114, 114.114.115.115
DNSFilter         19.35 ms (2) 103.247.36.36, 103.247.37.37
Level3            19.61 ms (2) 4.2.2.1, 4.2.2.2
SafeDNS           19.96 ms (2) 195.46.39.39, 195.46.39.40
Quad9             20.69 ms (2) 9.9.9.9, 149.112.112.112
ControlD          22.46 ms (2) 76.76.2.0, 76.76.10.0
AdGuard           23.43 ms (2) 94.140.14.14, 94.140.15.15
Neustar           25.50 ms (2) 64.6.64.6, 64.6.65.6
NextDNS           26.00 ms (2) 45.90.28.243, 45.90.30.243
Verisign          26.42 ms (2) 64.6.64.6, 64.6.65.6
NortonCS          26.61 ms (2) 199.85.126.10, 199.85.127.10
Google            27.84 ms (2) 8.8.8.8, 8.8.4.4
OpenDNS           29.66 ms (2) 208.67.222.222, 208.67.220.220
OracleDyn         31.84 ms (2) 216.146.35.35, 216.146.36.36
CleanBrowsing     65.50 ms (2) 185.228.168.9, 185.228.169.9
Comodo            66.84 ms (2) 8.26.56.26, 8.20.247.20
Freenom           87.46 ms (2) 80.80.80.80, 80.80.81.81
SKTelecom        177.66 ms (2) 168.126.63.1, 168.126.63.2
Yandex           213.04 ms (2) 77.88.8.8, 77.88.8.1
AliDNS           226.38 ms (2) 223.5.5.5, 223.6.6.6
OneDNS           252.23 ms (1) 117.50.22.22
CenturyLink      274.07 ms (2) 205.171.3.65, 205.171.2.65
DNSpai           291.12 ms (2) 101.226.4.6, 218.30.118.6
DNSPodDNS+       310.54 ms (2) 119.29.29.29, 119.28.28.28
CNNICSDNS        630.80 ms (2) 1.2.4.8, 210.2.4.8
DNS.WATCH        691.58 ms (2) 84.200.69.80, 84.200.70.40
```
