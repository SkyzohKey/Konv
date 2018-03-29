# /!\ Disclaimer: Project moved to a new repository /!\

*tl;dr. Project moved at [TheToxProject/client](https://github.com/TheToxProject/client).*

Hey dear community!

A lot of people have asked me about the state of Ricin & Konv projects, so let me clarify the situation.

Ricin was mostly a "proof of concept" that permited me to learn to code in Vala. Once I was enough confident in developing with Vala, I realised that Ricin's source code was a shit-code. Nightmare to maintain, hard to update. So I decided to rewrite/rebrand it under the Konv project-name. I worked on Konv during some time before I had a vision.

So let's talk about that vision. I dreamed people would just download Tox, and start to chat, without missing important IM features, nor security features. I dreamed that Tox would replace Skype, Messenger, Whatsapp and other IM apps, because it's decentralized, and would be looking good, with features parity with other IMs + gamification. User would see & use the same interface not depending on the device he is using. Whether it's desktop, mobile or web browser.

The Universal Tox Client is my attempt to realize this.  
You can find the new repository at [TheToxProject/client](https://github.com/TheToxProject/client).

Also feel free to look at the contribute or donations part of the readme if you want to get involved ! :)

I hope I clarified the situation enough.
Thanks for the interest.

----

# Konv.im - Secure P2P instant messenger

| [![CircleCI][3]][2] | [![Make a donation on Liberapay][5]][6] |
|:-------------:|:-------------:|
| **[Install Konv][7]** | [Help us translating Konv][4] |

<!-- TODO: Add logo, one global screenshot or banner and links. -->

[Konv.im] is an open-source, libre and secure instant messaging application that
aims to replace Skype, Whatsapp, and other proprietary services. I believe that
bringing a free (as in freedom, aswell as in price) software that enable
individuals to communicate freely, without the fear to be censored or sued, is
primordial in this post-Snowden era. Free speech enables **real** sharing of
ideas, concepts, researchs, etc. That's how I want to contribute saving what
stays of people liberties and rights.

| [![A screenshot of Konv's MainWindow + SettingsWindow running 0.1.0-looneypig](https://a.doko.moe/pjrjbp.png)](https://a.doko.moe/jsfcgo.ogv) |
|:--:|
| Click the screenshot to see the **preview** video. |

## Features

Here is a tentative list of the features that Konv.im must have in order to be
usable and useful. The list is **not** ordered nor complete. This list also
serves as a sort of Roadmap for me.

- [ ] Usable, bug-free and user-friendly interface ;
- [ ] Modern way to communicate with contacts (messages, actions, auto-reply) ;
- [ ] File transfers : Inline images, inline musics, inline videos, regular
files, avatars ;
- [ ] Simple and convenient way to share a contact (drag&drop, right click) ;
- [ ] Customizable interface ;
- [x] Intuitive and not cluttered settings interface (advanced mode?) ;
- [ ] Group chats, with simple way to add people inside ;
- [ ] Avatars, status messages, presence ;
- [ ] Audio calls, video calls, desktop sharing/streaming ;
- [ ] Secure way to add peoples from an user-friendly ID (no ToxID,
  decentralized ToxMe-like) ;
- [ ] Custom bootstrap nodes list.
- [x] Social welcome screen.

## Protocol

Konv.im is an instant messaging application that uses [the Tox protocol] in
order to enable truely secure communications. By so, it can be called a [Tox
client].

ToxCore (the Tox core library) provides an easy and intuitive API for building
secure communication platforms. It is maintained by [The TokTok Project].

I'm using [TokTok/c-toxcore] instead of the old [irungentoo/toxcore] library for convenience and
security related concerns.

## Install

You can run and install Konv with a few lines, just type the following in a
shell

```bash
# Download it!
$ git clone https://github.com/SkyzohKey/Konv.git && cd Konv

# Build it!
$ mkdir build && cd build
$ cmake .. -DCMAKE_INSTALL_PREFIX=/usr
$ make

# [Optional] If you want to install it system-wide
$ sudo make install
```

## License

Konv.im is released under [The MIT License] while the ToxCore binaries are
licensed under [The GPLv3 License].

<!-- Links reference -->
[Konv.im]: https://konv.im
[the Tox protocol]: https://tox.chat
[Tox client]: https://tox.chat/clients.html
[The TokTok Project]: https://toktok.ltd
[TokTok/c-toxcore]: https://github.com/TokTok/c-toxcore
[irungentoo/toxcore]: https://github.com/irungentoo/toxcore
[The MIT License]: License.txt
[The GPLv3 License]: https://github.com/TokTok/c-toxcore/blob/master/COPYING

[1]: https://chat.konv.im
[2]: https://circleci.com/gh/SkyzohKey/Konv
[3]: https://circleci.com/gh/SkyzohKey/Konv.svg?style=svg
[4]: https://www.transifex.com/ricinapp/im-konv-client/
[5]: https://liberapay.com/assets/widgets/donate.svg
[6]: https://liberapay.com/SkyzohKey/donate
[7]: #install
