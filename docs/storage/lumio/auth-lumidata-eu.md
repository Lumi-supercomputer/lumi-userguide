# Create LUMI-O credentials

[auth.lumidata.eu]: https://auth.lumidata.eu

Go to [LUMI-O credentials management service page][auth.lumidata.eu]. And click
on "-> Go to login".

<figure>
  <img src="../../../assets/images/auth.lumidata.eu-landingpage.png"     
       width="720" alt="Screenshot of auth.lumidata.eu landing page"
  >
  <figcaption>auth.lumidata.eu landing page</figcaption>
</figure>

Choose the correct authentication provider which for most LUMI users is "MyAccessID" (users with a Finnish allocation can also use "CSC" or "HAKA"), and follow the authentication procedure.

<figure>
  <img
    src="../../../assets/images/auth.lumidata.eu-authentication-provider.png"
    width="720" alt="Screenshot of auth.lumidata.eu authentication providers"
  >
  <figcaption>Authentication provider selection</figcaption>
</figure>

This page displays all the projects that are associated with your account.
It shows the project number, project description, set storage quota, in GB, for
a specific project, and how much of said quota is used up.
Additionally, this page allows creating the necessary authentication keys,
which are required for accessing the object storage.

<figure>
  <img 
    src="../../../assets/images/auth.lumidata.eu-main-page.png" 
    width="720" 
    alt="Screenshot of auth.lumidata.eu main page"
  >
  <figcaption>LUMI-O credential management main page</figcaption>
</figure>

!!! warning
	The **Usage** column does not display correct data as the feature is still being implemented 


To create an authentication access key pair. Open up the side menu from the
rightward pointing arrow. In this example, we are opening the side menu for
project 462000008, for which we will create the authentication key pair for.

<figure>
  <img
    src="../../../assets/images/auth.lumidata.eu-main-page-select-project.png"
    width="720"
    alt="Screenshot of auth.lumidata.eu side menu arrow"
  >
  <figcaption>Open the side menu</figcaption>
</figure>

The side menu allows for the creation of access keys. To generate an access key
"Duration (hours)*" and "Key description*" fields must be filled out.

!!! tip
    A good practice is to set the authentication key pair duration for the job
    walltime. This lets the job move the necessary data from LUMI-O to the
    scratch filesystem, perform the necessary calculations, and after finishing
    move the data back to LUMI-O.

<figure>
  <img
    src="../../../assets/images/auth.lumidata.eu-create-the-first-key.png"
    width="720" alt="Screenshot of auth.lumidata.eu side menu content"
  >
  <figcaption>Side menu</figcaption>
</figure>

When filling out the duration, keep the previous advice in mind.

!!! tip
    The key description should be something relevant to the job it is meant for,
    that way it is easier to manage the created keys, should there be more than
    a few at the same time.

<figure>
  <img 
    src="../../../assets/images/auth.lumisade.eu-key-duration-and-hours.png"
    width="720"
    alt="Screenshot of auth.lumidata.eu setting duration and description"
  >
  <figcaption>Filling out the required fields</figcaption>
</figure>

After the necessary fields are created, click on "Generate key".
The generated key will appear in the side menu under "Available keys".
The previously mentioned key description field is visible there,
which makes it easy to distinguish between several keys.

<figure>
  <img 
    src="../../../assets/images/auth.lumidata.eu-first-access-key.png"
    width="720" alt="Screenshot of auth.lumidata.eu available keys"
  >
  <figcaption>Available keys</figcaption>
</figure>

Click on the newly generated Access key. This opens up the key's content. It
provides the necessary "Access key" and "Secret key". You can also see the key
description, which project said key is related to, owner of the key and finally
Creation and Expiry dates.

From this side menu, it is also possible to extend the key.

!!! info
	When you initially create the key, the initial allowed maximum lifetime is 168h = 7 days.
	This can then be extended by one hour for every hour from key creation,
    i.e., you are always able to extend the duration of the key to now + 7 days.

Downloading a configuration template for different object storage clients like
shell, boto3, rclone, s3cmd and aws.

After selecting the desired object storage client and clicking "Generate"
opens the output in a new browser tab.

Finally, by scrolling down in the menu this side menu allows you to delete the
key. After deletion of a key, a new one needs to be created to resume
utilizing LUMI-O for a certain project. Keys are non-recoverable, but a new one
can be created in its place.

<figure>
  <img 
    src="../../../assets/images/auth.lumisade.eu-first-key-content.png"
    width="720" alt="Screenshot of auth.lumidata.eu access key details"
  >
  <figcaption>Access key details</figcaption>
</figure>

