---
type: youtube
source: https://youtu.be/3MP8D-mdheA?si=e0pdvl2YHUv-P_sI
title: "How To De-Slop A Codebase Ruined By AI (with one skill)"
channel: "Matt Pocock"
duration_sec: 679
upload_date: 2026-04-29
created: 2026-05-04T13:32:23+03:00
status: inbox
transcript_status: ok
tags:
  - source/youtube
---

# How To De-Slop A Codebase Ruined By AI (with one skill)

## Transcript

[00:00] You've probably seen the thousands of
[00:01] LinkedIn CEO posts saying that code is
[00:04] cheap and they can move faster than ever
[00:06] before. But what's happening is that AI
[00:09] has simply accelerated software entropy.
[00:11] In other words, code bases are falling
[00:13] apart faster than they ever have before.
[00:16] Because every time that you make a
[00:17] change that doesn't take into account
[00:18] the entire codebase, you are likely to
[00:21] introduce little things, weird things
[00:23] that make the codebase harder to change.
[00:25] And over time, that just snowballs and
[00:27] snowballs until you end up with a huge
[00:29] ball of mud. Sloppy, sloppy mud that is
[00:32] incredibly hard to reverse if you don't
[00:35] know how to do it. I've made a video
[00:36] about this before, introducing folks to
[00:38] the idea of deep modules. And that video
[00:40] focuses more on prevention, how you can
[00:43] prevent your setup from getting to that
[00:45] point. Let's now focus on the cure. How
[00:47] you can take a codebase that feels like
[00:49] it's beyond repair and rescue it. And
[00:51] you can do that with some good old
[00:53] software fundamentals as well as my
[00:55] improve codebase architecture skill.
[00:57] We're going to be walking through what
[00:58] this skill does, revisiting some of the
[01:00] terms we looked at in the other video,
[01:02] and then we're going to take that and
[01:03] apply it to a real codebase. And this,
[01:05] by the way, is part of my GitHub skills
[01:07] repo, which is currently sitting at
[01:09] 41.5K stars. Bonkers. Now, one of the
[01:12] things that I added to this improve
[01:13] codebase architecture skill recently was
[01:16] a glossery of terminology. Having a
[01:18] shared vocabulary with the AI is super
[01:20] important because it means that you can
[01:22] talk using the same language. You can
[01:24] understand what each other's language is
[01:27] and you can be a lot more precise with
[01:29] what you're asking for. This terminology
[01:31] here is super duper useful and I'm going
[01:34] to spend a portion of this video going
[01:35] through what each of these terms
[01:37] actually mean. Honestly, just
[01:38] understanding this stuff at a deep level
[01:39] will make you a better software
[01:41] developer. So, let's get started by
[01:43] talking about modules. A module is a
[01:45] unit of something in your application.
[01:48] It could be a bunch of React components
[01:50] that all fit together to form a page. It
[01:52] could be a bunch of functions inside
[01:54] your application that are entirely
[01:55] responsible for authentication. Or it
[01:57] could simply be the logger that you've
[01:59] chosen, like a log to the console, log
[02:01] into a file, or log into a third party
[02:03] service. In a good codebase, these
[02:04] modules talk to each other, and they
[02:06] talk to each other via their interfaces.
[02:08] An interface is everything a caller must
[02:10] know to use the module correctly. For
[02:12] instance, if it's an authentication
[02:13] module, then it might have a sign in
[02:15] method. It might have a sign out method.
[02:17] And these methods are the interface to
[02:19] that module. The methods are not the
[02:21] only thing that's important. The
[02:22] interface also includes kind of nebulous
[02:24] information about how to call the
[02:26] module. So perhaps it's documentation
[02:28] too. The implementation is then what's
[02:30] inside the module, what it actually does
[02:32] when you call sign in or sign out. And
[02:34] so this is the core primitive that we're
[02:36] talking about, the modules that have
[02:37] interfaces and implementations scattered
[02:39] throughout your application. These
[02:40] modules can either be deep modules or
[02:43] they can be shallow modules. A deep
[02:45] module hides lots of implementation
[02:48] behind a relatively simple interface. A
[02:50] shallow module has a complex interface
[02:53] and kind of not much implementation
[02:55] actually behind it. These ideas are from
[02:57] John Asterout's book, A Philosophy of
[02:59] Software Design, which I recommend you
[03:00] pick up a copy of. Deep modules are
[03:02] considered better than shallow modules
[03:03] because it hides more information away
[03:05] from the caller. In other words, the
[03:06] person who's calling this or the
[03:08] function that's calling this only needs
[03:09] to know about this tiny little interface
[03:11] and they'll get access to all of this
[03:13] implementation. Lovely. And so that's
[03:14] what we describe as depth. The amount of
[03:16] behavior a caller can exercise per unit
[03:19] of interface that they have to learn.
[03:21] Really good open source libraries like
[03:22] uh Tanstack query or something have
[03:25] really good deep modules. In other
[03:27] words, they're hiding a lot of
[03:28] complexity behind a super simple
[03:30] interface. These modules then interact
[03:32] with each other and they have
[03:33] dependencies on each other. For
[03:34] instance, this module might interact
[03:36] with this module here, which then
[03:38] interacts with this module up here and
[03:40] this module up here. And they have these
[03:42] dependency graphs between them. These
[03:43] gaps between these modules are called
[03:45] the seams. It's the location at which
[03:48] the module's interface lives inside the
[03:50] application. These seams are usually
[03:52] where you're going to do your unit
[03:53] testing or your integration testing. For
[03:55] instance, if we wanted to test this
[03:57] module in isolation down here, then we
[03:59] would add a mock or something just at
[04:02] this seam. So figuring out where your
[04:04] seams are going to live in your
[04:05] application is crucial to getting a good
[04:07] architecture. When you find out where a
[04:08] seam is in your application, you need
[04:10] some concrete thing, a module that
[04:12] satisfies that interface. This is what
[04:14] I'm going to call an adapter, which I'm
[04:16] taking from hexagonal architecture. For
[04:18] instance, if you have some kind of
[04:19] application that depends on a clock
[04:21] running, then you may want to have a
[04:24] clock, a normal clock inside here using
[04:26] the actual living clock. And then inside
[04:28] some tests, you may want to have an
[04:30] adapter that is a fake clock. These both
[04:32] satisfy the interface at that seam. And
[04:34] it means that you can use the fake clock
[04:36] in tests. So you don't have to literally
[04:38] wait 2 weeks for your test to finish. So
[04:40] that's how seams and adapters play
[04:42] together. The benefit of all this is
[04:44] that these deep modules have two main
[04:47] properties or two main benefits that you
[04:48] get from them. But the maintainers, the
[04:50] people maintaining this module, they get
[04:52] locality changes to that module and bugs
[04:54] and all the fixes to do with them. They
[04:56] concentrate in one place in that deep
[04:59] module. If it's scattered around over
[05:01] multiple different modules, then you
[05:02] have low locality. You want high
[05:04] locality, grouping and colloccating the
[05:07] things that matter and that often change
[05:09] together. The people using this module
[05:11] will get more leverage the deeper the
[05:13] module is. In other words, more
[05:14] capability per unit of interface they
[05:16] have to learn. And so when we're talking
[05:18] about improving our code bases, these
[05:20] are the two attributes that we're aiming
[05:21] at. Right? That's enough knowledge. We
[05:23] know the basic terms of engagement. Now,
[05:25] let's go and improve a codebase. The
[05:27] codebase we're going to look at is my
[05:28] course video manager codebase, which is
[05:31] the repo of software that I'm actually
[05:33] using to record this video. This
[05:35] codebase has had around 1,500 commits
[05:38] here. And I wouldn't say it's a ball of
[05:40] mud, but I also wouldn't say it's
[05:42] perfect either. It's a React router
[05:43] application. It uses effect.ts under the
[05:45] hood. Uh, let's get into it. I'm going
[05:47] to open up a new clawed session inside
[05:49] here, and I'm going to run my improve
[05:51] codebase architecture skill. I'm going
[05:53] to turn off auto mode. Auto mode does
[05:55] some funny things with these human in
[05:56] the loop style flows and so I don't want
[05:58] it on here. We can see it's going and
[06:00] exploring and looking through the code.
[06:02] That's what it's instructed to do first.
[06:04] Here we go. Explore architecture for
[06:06] deepening opportunities. Usually a bad
[06:08] codebase is one that has a ton of
[06:10] shallow modules in it or one that has
[06:12] very poor leverage for those modules or
[06:14] poor locality where lots of stuff is
[06:16] spread in lots of different places.
[06:18] Okay, it's come back with some
[06:19] candidates here. Let's bump up the
[06:21] screen size and hopefully Claude code
[06:23] won't just destroy itself. Okay, I guess
[06:25] maybe we're not bumping up the screen
[06:27] size. Thank you for that, Claude Code.
[06:28] We can see it's identified six deepening
[06:31] opportunities here. These candidates
[06:32] here are pretty hard to explain because
[06:34] they sort of require domain knowledge
[06:35] about my repo. But we can see here that
[06:37] it's saying that there's a concept that
[06:39] doesn't have a single seam. In other
[06:41] words, there are two implementations of
[06:43] this insertion point and they live in
[06:45] parallel. And the seam where they must
[06:46] agree is untested. This essentially
[06:49] means that the front end could make some
[06:50] changes um but the back end because it
[06:53] has a separate parallel implementation
[06:55] could be out of sync with it. So this I
[06:57] think is actually a really good
[06:58] candidate for refactoring into a single
[07:00] module. We gain locality and it says
[07:02] that here we would gain locality. The
[07:03] interleaf clip clip section ordering
[07:05] rule lives in one place. So let's go and
[07:08] take a look at that. Let's actually say
[07:10] yeah I'd like to pick one here. That
[07:12] seems like a good candidate. So let's
[07:14] fire that off and see what it says.
[07:15] Okay, Claude is trolling me here. It
[07:17] says I'd like to pick one. I meant I
[07:19] meant one. Great. Okay. So, it now has
[07:23] come back with it's got concrete code on
[07:24] both sides to to ground this. And it
[07:26] enters a grilling session. And in this
[07:28] grilling session, we can take the ideas
[07:31] inside here and we can start kind of
[07:33] talking about what a better solution
[07:34] would be. This is a nice sentence here.
[07:36] The back end has no end. Let's not think
[07:39] about that too literally. What you end
[07:40] up doing with this skill is you end up
[07:42] talking about the potential proposed
[07:44] solution and it will then propose a
[07:46] shape. And once that's all done, you can
[07:48] take that and you can put that in as a
[07:50] GitHub issue into your issue tracker
[07:52] which can then be picked up by an AFK
[07:54] agent. You should check out my video on
[07:55] San Castle if you're interested in that.
[07:57] Now, in the course of normal
[07:58] development, what I would do is go
[07:59] through and thoughtfully answer each of
[08:02] these questions in turn. But since I'm
[08:03] doing a video and this is slightly
[08:05] artificial, I'm going to say, could you
[08:07] just choose your recommended answers for
[08:09] each of these questions? And that should
[08:11] speed us through to actually making the
[08:12] change or potentially creating an issue
[08:14] out of this. So, it's now coming back
[08:16] with a proposed module shape. And it's
[08:17] also asking to verify a particular part
[08:20] of the implementation where end is
[08:22] collapsed and to sketch the actual
[08:24] TypeScript interface. Yeah, go ahead and
[08:26] do both. That sounds great. Let's ping
[08:27] that off and see what it says. Okay, it
[08:29] has figured out uh the implementation
[08:31] detail it needed and it's come back and
[08:33] proposed a design here. So each of these
[08:35] functions are going to be essentially
[08:37] the uh the interface for this module.
[08:39] And so we can talk about this with the
[08:41] AI and figure it out. It's again come
[08:43] back with two design decisions that it
[08:45] wants my feedback on. And here I think
[08:47] you've got the flavor of how this skill
[08:49] works and the kind of conversations that
[08:51] you end up having with the AI based on
[08:53] this. If I want to turn this into an
[08:54] issue that my AFK agent picks up, I can
[08:56] use two PRD or two issues here. And by
[09:00] the way, if you're interested in these
[09:01] skills that I'm talking about, then you
[09:03] should check out this site here, which
[09:05] is linked below. I'm going to be
[09:06] creating a real documentation site for
[09:08] these skills. And for now, I have a
[09:10] newsletter that you can sign up to for
[09:11] the latest updates, as well as tips and
[09:13] tricks and resources for getting the
[09:15] most out of agents. The thing that's
[09:17] important to notice here is just how
[09:19] much this skill demands of you, the
[09:21] user. This is not an AFK skill that you
[09:23] can just sort of run and kind of like uh
[09:25] just rely on to continually improve your
[09:28] codebase. This requires a judgment call
[09:30] from you, the programmer, sitting above
[09:32] the LLM. I think of agents as really,
[09:34] really good tactical programmers.
[09:37] They're able to get on the ground and
[09:39] make changes quickly, but they need
[09:40] someone on the level above them who is
[09:42] the strategic programmer. And that's
[09:44] what this skill does. It allows the
[09:46] sergeant to go and run around the
[09:48] codebase and look for potential
[09:49] improvement um opportunities, but then
[09:52] you the general have to go and actually
[09:54] make the change and decide what's good
[09:56] for the long-term health of the
[09:57] codebase. I recommend that you run this
[09:58] skill, you know, every couple of days
[10:01] really, especially in a codebase that's
[10:02] fastmoving, you're going to come up with
[10:04] tons of opportunities for deepening the
[10:06] codebase. And the deeper you get those
[10:08] modules, the higher leverage you're
[10:10] going to get out of them. And leverage
[10:11] as well means testing. If you have a set
[10:13] of really nice clear seams in your
[10:16] codebase, then you're going to be able
[10:17] to write really nice tests around those
[10:20] nice deep modules. And the better your
[10:21] tests are, the better the output from
[10:23] the agent is going to be. One final
[10:25] thought here is that lots of folks ask
[10:26] me how you would get started by using AI
[10:30] in a legacy codebase. And a legacy
[10:31] codebase is probably going to have a lot
[10:33] of shallow modules. Is I mean, we talk
[10:35] about legacy code bases. What we really
[10:37] mean are bad code bases. Code bases that
[10:39] are hard to make changes in. And what
[10:42] you really need before you start making
[10:43] changes in a legacy codebase is a
[10:45] harness around the codebase to make sure
[10:48] that your changes don't mess anything
[10:49] up. So for that you need tests testing
[10:52] really nice deep modules that have a lot
[10:55] of leverage and locality. So running
[10:56] improved codebase architecture is a
[10:58] great place to start. Thanks for
[11:00] watching folks and I hope that answers
[11:01] some of your questions about how to
[11:03] solve this neverending problem of AI
[11:06] just running away and creating terrible
[11:08] code bases. I hope you enjoy the skills.
[11:10] Do follow the link below if you want to
[11:11] find more of them. So, thanks for
[11:12] watching and I will see you in the next
[11:14] one.
