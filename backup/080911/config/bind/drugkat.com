$TTL	3600
drugkat.com.	IN	SOA	ns5.hosting.reg.ru. root.21noon.com. (2011090200 10800 3600 604800 86400)
drugkat.com.	IN	NS	 ns5.hosting.reg.ru.
drugkat.com.	IN	NS	 ns6.hosting.reg.ru.
drugkat.com.	IN	MX	10 mail.21noon.com
drugkat.com.	IN	A	 95.163.16.146
www	IN	A	 95.163.16.146
ftp	IN	A	 95.163.16.146
mail	IN	A	 95.163.16.146
smtp	IN	A	 95.163.16.146
pop	IN	A	 95.163.16.146
drugkat.com.	IN	TXT	 "v=spf1 ip4:95.163.16.146 a mx ~all"