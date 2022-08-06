# **1. Managing the Mail Queue**


## The Mail Queue Manager
### There are many reasons a delivery attempt may fail.
1. The load on the server may be above the **delivery threshold**
2. The receiving mail server may be undergoing maintenance and not able to accept messages at the moment.
3. There may be an issue with the recipient’s account (over quota, etc).

**Mail is not necessarily considered spam if it’s in the queue - and a lot of spam never makes it to the queue because it fails with a permanent error.**

## Using the Interface
### Using Mail Queue Manager,
- It allows you to manage the mail queue from the comfort of the WHM interface. Some of the actions you can perform from this interface are the following:
    - Find Patterns 
    - Search for messages based on a criterion
    - Force delivery attempts 
    - Remove messages from the queue

### Why do some messages get put into the queue?
- Messages existing in the queue indicate some kind of delivery failure. The messages are placed into the queue so that Exim can try to deliver them again at a later time.


### The Mail Troubleshooter Interface
- The **Mail Troubleshooter interface** traces an email’s route from your server to a specified address in order to highlight issues along the delivery path. 

- A **virtual user** is a user that was added through the cPanel interface. Almost all of the email that will be delivered locally will be to a **virtual user**.

- **The ability to set specific email account quotas is found in the cPanel interface and not WHM.**


## Troubleshooting Common Issues with Mail 

### Common Situations 

- In this section, we're going to take a look at some common issues that your users may report, and how to handle them effectively.
    - The user reports that no new mail is arriving in their inbox.
    - The user reports that a particular, important email was never received.
    - The user reports that they never receive mail from a particular person or website.

#### 1. Quota Issues:
- Set mail to reject when the account is over its quota using the Disk Quota Delivery Failure Response option, within the **Mailserver Configuration** interface in WHM.
- 
#### 2. Permissions Issues
- This feature can be found as the **Repair Mailbox Permissions** item within the WHM interface, under the Email section. Use this interface to inspect mailbox ownership and file permissions, or attempt to repair any permissions and ownership contradictions that may exist in the mail system. Clicking the **Proceed** button begins the process.

#### 3. "Disappearing" Mail
- A user may indicate that they did not receive a particular, important email. If, when looking in the Mail Delivery Reports, you're able to find that email, you may still be able to assist the user in receiving the message.
- One example of this can be seen below, where all indications in the reports interface show that the email was indeed accepted, as shown by the green checkmark.
- To find out more about what happened to this message, we would then want to click the magnifying glass icon on the righthand side of the message to further inspect it.

#### 4. Actually Disappearing Mail
- It's mean that when we check the information of the Delivery Event Details, we will saw **Delivered To: /dev/null**. What this means is that the message was actually deleted.
- Again, the next step here would be to examine the cPanel account's email filters to try and determine which filter is responsible for this behavior or to instruct the user to adjust the filters themselves so that it better fits their needs.


# **Administering Mail from the Command Line (T400)**

## Introduction & Mail Server Overview
- cPanel servers use Exim for their Mail Transfer Agent (MTA), Dovecot for their IMAP/POP3 daemon, Mailman for mailing lists, and SpamAssassin for spam control.

- Before you start troubleshooting, you probably want to know what Exim is currently processing. There are several ways to determine this.

The three most common ways in order of usefulness, from our perspective, are as follows:

**1. exiwhat**
This command shows active connections being handled

**2. ps -C exim wwwu**
This command shows a list of all running exim processes

**3. lsof -c exim**
This command shows a list of files being accessed by Exim




