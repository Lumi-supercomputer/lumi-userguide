[terms-of-use]: https://www.lumi-supercomputer.eu/lumi-general-terms-of-use_1-0/
[support-account]: https://lumi-supercomputer.eu/user-support/need-help/account/
[myaccessid-profile]: https://mms.myaccessid.org/profile/
[mycsc-profile]: https://my.csc.fi/
[puttygen]: https://www.puttygen.com/#How_to_use_PuTTYgen
[support]: https://lumi-supercomputer.eu/user-support/need-help/
[registration]: ../accounts/registration.md
[connecting]: ../connecting/connecting_.md
[website-getstarted]: https://lumi-supercomputer.eu/get-started/
[jump-ssh-key]: #setting-up-ssh-key-pair
[eidas-eduid]: https://puhuri.neic.no/user_guides/myaccessid_registration/

[regular-access]: ./accessLUMI.md
[SSH-keys]: ./SSH-keys.md
[logging-in]: ./loggingin.md

# Access to LUMI

To access LUMI, you need to be a member of a project that has been granted
resources on LUMI. The LUMI consortium countries have different policies for
accessing LUMI. An overview of the access policies is provided on the [LUMI
Supercomputer Get Started][website-getstarted] page.

In general, a Resource Allocator (RA) must create a project and invite the
Principal Investigator (PI), i.e. the lead researcher, to the project. The
project PI can then invite other project members. If you have been granted
access to LUMI but didn't receive an invitation to a project, please contact
your PI or your local organization. You may find contact information for your
local organization on the [LUMI Supercomputer Get Started][website-getstarted]
page.

Please note that when using LUMI, you must accept and adhere to the [LUMI Terms
of Use][terms-of-use].

=== "For regular users (with a non-Finnish allocation)"

    Once you have received an invitation to a project on LUMI, you need to register to MyAccessID and accept the terms of use as instructed in the invitation. The procedure for registering to MyAccessID differs between the LUMI consortium countries. In general, the recommended authentication method is to use your home organization's identity provider. You should find it by typing your organization into the *Choose Your Identity Provider* search field. If you found your organization, but you got an error, please contact your identity provider for assistance. Alternative registration options are available for some countries. Please see the [Puhuri documentation][eidas-eduid] for information about these alternatives (the passport-based identity vetting is currently not available).

    For the next step, you will be directed to the registration page, where you have to accept the Acceptable Use Policy and LUMI Terms of Use document, which is linked there. Please read them carefully! 

    <figure>
      <img src="../../assets/images/Puhuri_Registration_example.png" width="480" alt="Screenshot of registration portal">
      <figcaption>MyAccessID Registration portal</figcaption>
    </figure>

    You may also modify the email address, but according to [LUMI Terms of Use][terms-of-use] you must use your institutional email address. For a more detailed description of how to register for MyAccessID, please consult the [Puhuri documentation][eidas-eduid] (the passport-based identity vetting is currently not available).
    
    The following short video shows an example procedure from receiving the email invitation to accessing the project's puhuri page.
    This example uses a Czech consortium project. Note that the Puhuri portal might look slightly different for other countries.
    
    <iframe id="kaltura_player" src="https://api.kaltura.nordu.net/p/191/sp/19100/embedIframeJs/uiconf_id/14971191/partner_id/191?iframeembed=true&playerId=kaltura_player&entry_id=0_qb2xq6e9&flashvars[streamerType]=auto&amp;flashvars[localizationCode]=en&amp;flashvars[leadWithHTML5]=true&amp;flashvars[sideBarContainer.plugin]=true&amp;flashvars[sideBarContainer.position]=left&amp;flashvars[sideBarContainer.clickToClose]=true&amp;flashvars[chapters.plugin]=true&amp;flashvars[chapters.layout]=vertical&amp;flashvars[chapters.thumbnailRotator]=false&amp;flashvars[streamSelector.plugin]=true&amp;flashvars[EmbedPlayer.SpinnerTarget]=videoHolder&amp;flashvars[dualScreen.plugin]=true&amp;flashvars[hotspots.plugin]=1&amp;flashvars[Kaltura.addCrossoriginToIframe]=true&amp;&wid=0_zexcx6xb" width="100%" height="400" allowfullscreen webkitallowfullscreen mozAllowFullScreen allow="autoplay *; fullscreen *; encrypted-media *" sandbox="allow-downloads allow-forms allow-same-origin allow-scripts allow-top-navigation allow-pointer-lock allow-popups allow-modals allow-orientation-lock allow-popups-to-escape-sandbox allow-presentation allow-top-navigation-by-user-activation" frameborder="0" title="LUMI Getting Started: Account via MyAccessID"></iframe>

=== "With a Finnish allocation"

    Users with a Finnish allocation (via [MyCSC](https://my.csc.fi/welcome)) must follow the instructions given in the [CSC documentation for creating a Finnish LUMI project](https://docs.csc.fi/accounts/how-to-create-new-project/#creating-a-lumi-project-and-applying-for-resources).
