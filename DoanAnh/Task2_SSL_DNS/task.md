# **TASK 2 TRAINING**

![](src/ssl-security-plan.png)

1. <a href='#1'> SSL and related issues.
1. <a href='#2'> What is Domain?
1. <a href='#3'> What is DNS? Some records of DNS.
1. <a href='#4'> What is Hosting, VPS, Server?
1. <a href='#5'> Reverse proxy and operating principle.
2. <a href='#6'> Compare Nginx and Apache.  

***

<div id='1'></div>

## 1. SSL and related issues.

### What is SSL/TLS?

#### SSL
- SSL (Secure Sockets Layer) and its successor, TLS (Transport Layer Security), are protocols for establishing authenticated and encrypted links between networked computers. Although the SSL protocol was deprecated with the release of TLS 1.0 in 1999, it is still common to refer to these related technologies as “SSL” or “SSL/TLS.”
- SSL ensures that all data transmitted between web servers and browsers is private, separate.

#### TLS
- TLS (Transport Layer Security), released in 1999, is the successor to the SSL (Secure Sockets Layer) protocol for authentication and encryption.

#### SSL Certificate
- An SSL certificate (also known as a TLS or SSL/TLS certificate) is a digital document that binds the identity of a website to a cryptographic key pair consisting of a public key and a private key. The public key, included in the certificate, allows a web browser to initiate an encrypted communication session with a web server via the TLS and HTTPS protocols. The private key is kept secure on the server, and is used to digitally sign web pages and other documents (such as images and JavaScript files).
- An SSL certificate also includes identifying information about a website, including its domain name and, optionally, identifying information about the site’s owner. If the web server’s SSL certificate is signed by a publicly trusted certificate authority (CA), like SSL.com, digitally signed content from the server will be trusted by end users’ web browsers and operating systems as authentic.


### What is CA?
- CA is stand for Certificate Authority. CA is an organization that issues certificates of digital certificates for users, businesses, servers, code, and software. The digital certificate provider acts as a third party (trusted by both parties) to facilitate the secure exchange of information.


### How does SSL/TLS work?
- In order to provide a high degree of privacy, SSL encrypts data that is transmitted across the web. This means that anyone who tries to intercept this data will only see a garbled mix of characters that is nearly impossible to decrypt.
- SSL initiates an authentication process called a `handshake` between two communicating devices to ensure that both devices are really who they claim to be.
- SSL also digitally signs data in order to provide data integrity, verifying that the data is not tampered with before reaching its intended recipient.

### Some related to SSL

#### Domain Validation (DV SSL)
- The SSL digital certificate authenticates the Domain Name – Website. When a Website uses DV SSL, the domain name will be authenticated, the website has been securely encrypted when exchanging data.

#### Extended Validation (EV SSL)
- Show your customers that the Website is using the highest security SSL certificate and has been thoroughly legalized.

#### Subject Alternative Names (SANs SSL)
Multiple domain names merge in 1 digital certificate:
- A standard SSL digital certificate secures only one verified domain name. Option to add SANs with only single certificate to secure multiple subdomains. SANs bring flexibility to users, making it easier to install, use and manage SSL digital certificates.

#### Wildcard SSL Certificate (Wildcard SSL)
Ideal product for e-commerce portals. Each e-store is a sub-domain and is shared across one or more IP addresses. Then, to deploy a secure solution for online transactions (order, payment, registration & account login, ...) with SSL, we can use only one Wildcard digital certificate for the domain name. main website and all sub-domains.

### How a website check SSL?
- When the Website sends the browser an SSL certificate, the browser sends this certificate to a server that hosts the approved digital certificates. These servers are established by reputable companies such as GlobalSign, VeriSign.
- Technically, SSL uses public encryption. This technique helps the Website and the Browser to agree a set of keys to use during the subsequent information exchange.

- The key set will change each time in the next transaction, another person will not be able to decrypt it even with the data of the above digital certificate server.

<div id='2'></div>

## 2. What is Domain name?

### Domain
#### Define
- A domain name is a string of text that maps to a numeric IP address, used to access a website from client software. In plain English, a domain name is the text that a user types into a browser window to reach a particular website. For instance, the domain name for Google is **google.com**
- The actual address of a website is a complex numerical IP address (e.g. 103.21.244.0), but thanks to DNS, users are able to enter human-friendly domain names and be routed to the websites they are looking for. This process is known as a **DNS lookup**.

#### Domain && URL
- A **uniform resource locator** (URL), sometimes called a web address, contains the domain name of a site as well as other information, including the transfer protocol and the path. For example, in the URL **https://cloudflare.com/learning/’**, `cloudflare.com` is the domain name, while `https` is the protocol and `/learning/` is the path to a specific page on the website.

### What are the parts of a Domain name
- Domain names are typically broken up into two or three parts, each seperated by a dot. When read right-to-left, the indentifiers in domain names go from most general to most specific. The section to the right of the last dot in a domain name is the **top-level domain (TLD)**. These include the `generic` TLDs suc as `.com`, `.net` and `.org`, as well as country-specifics TLSs like `.uk` and `.jp`

- To the left of the TLD is the second-level domain (2LD) and if there is anything to the left of the 2LD, it is called the third-level domain (3LD). Let’s look at a couple of examples:

For Google’s US domain name, ‘google.com’:
- ’.com’ is the TLD (most general)
- ’google’ is the 2LD (most specific)

But for Google UK’s domain name, ‘google.co.uk’:
- ’.com’ is the TLD (most general)
- ’.co’* is the 2LD
- ’google’ is the 3LD (most specific)


<div id='3'></div>

## 3. What is DNS? Some record of DNS.

### What is DNS?
#### Define
- **The Domain Name System (DNS)** is the phonebook of the Internet. Humans access information online through domain names, like **facebook.com** or **google.com**. Web browsers interact through Internet Protocol (IP) addresses. DNS translates domain names to IP addresses so browsers can load Internet resources.