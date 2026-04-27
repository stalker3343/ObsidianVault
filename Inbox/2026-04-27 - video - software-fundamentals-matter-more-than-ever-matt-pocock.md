---
type: youtube
source: https://youtu.be/v4F1gFy-hqg?si=2a5RROhWImzqSsmR
title: "\"Software Fundamentals Matter More Than Ever\" — Matt Pocock"
channel: "AI Engineer"
duration_sec: 1106
upload_date: 2026-04-23
created: 2026-04-27T11:28:42+03:00
status: inbox
transcript_status: ok
tags:
  - source/youtube
---

# "Software Fundamentals Matter More Than Ever" — Matt Pocock

## Transcript

[00:07] [music]
[00:14] Hello everyone. Having a good conference
[00:16] so far?
[00:17] >> Are you having a good conference so far?
[00:19] >> Good. Wonderful.
[00:22] I have a message for you that I hope
[00:24] will be um a comforting message for
[00:27] folks who believe that uh their skill
[00:30] set is no longer worth anything in this
[00:32] new age, which is I believe that
[00:34] software fundamentals matter now more
[00:36] than they actually ever have.
[00:39] And
[00:40] I'm a teacher and I've been recently
[00:44] teaching a course called Claude Code for
[00:45] real engineers. Nice and provocative.
[00:48] And in the process of kind of working on
[00:50] this course, I had to come up with a
[00:52] curriculum about AI coding, which is a
[00:56] bit of a nightmare because things are
[00:58] changing all the time, right? AI is a
[01:00] whole new paradigm. We need to chuck out
[01:03] all of the old rules surely so that we
[01:05] can bring in the new stuff.
[01:08] And there's a kind of movement that has
[01:11] come up around this, which is the specs
[01:14] to code movement. And the specs to code
[01:16] movement says that okay you can write a
[01:18] specification about how an application
[01:19] is supposed to work then you can use AI
[01:22] to turn it into code. If there's a
[01:24] problem with the application you then go
[01:26] back to the spec. You don't really look
[01:28] at the code. You just change the spec.
[01:29] You run the compiler again and you end
[01:32] up with more code. Raise your hand if
[01:35] you've heard of that. Keep your hand
[01:37] raised if you've tried it. Okay. I've
[01:40] tried it too. You can put your hands
[01:41] down.
[01:42] And what I noticed was I would run it
[01:45] and I would try not to look at the code
[01:48] but I would look at the code and I
[01:50] realized I would get code out first of
[01:52] all and then I would run it I would get
[01:53] worse code and then I did it again I got
[01:55] even worse code and I got it again I
[01:58] kept running the compiler kept running
[01:59] the compiler and I would just end up
[02:00] with garbage.
[02:03] You know raise your hand if that's
[02:04] happened to you. Yes. I don't think this
[02:08] works. the idea that we can just ignore
[02:10] the code and just have the code let it
[02:12] manage itself is just sort of v coding
[02:14] by another name
[02:16] and I didn't believe that back then I
[02:19] thought okay how do I fix the compiler
[02:21] how do I make it so that it doesn't
[02:22] produce bad code each time or worse code
[02:25] and so I thought okay I need to explain
[02:27] to the LLM in English what a good
[02:30] codebase looks like let me dig out one
[02:33] of my old favorite books which is a
[02:35] philosophy of software design by John
[02:36] ouster go on Amazon get it. Um, and he
[02:41] has a definition for what bad code looks
[02:44] like. He calls it complex code.
[02:46] Complexity is anything related to the
[02:48] structure of a software system that
[02:50] makes it hard to understand and modify
[02:52] the system. Right? So, a a bad codebase
[02:55] is a codebase that's hard to change. If
[02:57] you can't change a codebase without
[02:59] causing bugs, then it's a bad codebase.
[03:01] Good code bases are easy to change. So,
[03:04] I thought, oh, that was good. Let's try
[03:06] another book. Let's try the paragmatic
[03:07] programmer. Go on Amazon, get it. They
[03:11] have a whole chapter on something called
[03:12] software entropy. And this is exactly
[03:15] what I was seeing. Entropy is the idea
[03:17] that things tend towards um disaster and
[03:20] uh floating away from each other and
[03:22] collapse. And this is exactly how most
[03:24] software systems behave too is that
[03:26] every time you make a change to a
[03:27] codebase, if you're only thinking about
[03:29] that change, not thinking about the
[03:30] design of the whole system, your
[03:32] codebase is going to get worse and worse
[03:34] and worse. And that's what I was seeing.
[03:37] Everything inside the specs to code idea
[03:39] that you just run the compiler again and
[03:40] again was making worse code. Now there's
[03:44] an idea that sort of drives the specs to
[03:46] code movement which is that code is
[03:49] cheap. Raise your hand if you've heard
[03:51] that phrase before that code is cheap.
[03:52] Yeah.
[03:55] Well, I don't think this is right. I
[03:57] think code is not cheap. In fact, bad
[04:00] code is the most expensive it's ever
[04:02] been. Because if you have a codebase
[04:04] that's hard to change, you're not able
[04:06] to take all of the bounty that AI can
[04:09] offer because AI in a good codebase
[04:12] actually does really, really well.
[04:15] And this means good code bases matter
[04:17] more than ever, which means software
[04:18] fundamentals matter more than ever.
[04:20] That's the thesis of this talk. So,
[04:22] let's actually get into practical stuff.
[04:25] I'm going to talk about different
[04:26] failure modes that you may have
[04:27] experienced or you may not have
[04:29] experienced yet with AI and how you can
[04:31] avoid them by just going back to old
[04:33] books and looking at good software
[04:34] practices. Sound good? So, the first one
[04:37] is that the AI didn't do what I wanted.
[04:40] You know, I I thought I had a good idea
[04:42] in my head and the AI just did something
[04:44] totally different or it did some uh like
[04:46] specs that I you know, it just made
[04:48] something I didn't want. Raise your hand
[04:49] if you've hit this mode.
[04:51] Cool. Okay. Well, this is what they say
[04:55] in the pragmatic programmer is that no
[04:57] one knows exactly what they want. Is
[04:59] that you and the AI, there is a
[05:01] communication barrier there, right? And
[05:04] so when you're talking to the AI, that's
[05:06] kind of like the AI doing its
[05:07] requirements gathering. It's basically
[05:09] working out from you what it is that you
[05:11] need. And I realized that there was
[05:15] another book, Frederick P. Brooks, the
[05:17] design of design, and it talks about
[05:19] this idea called the design concept. is
[05:22] that when you have more than one person
[05:24] designing something together, you have
[05:26] this idea sort of floating between you,
[05:28] this ephemeral idea of the thing that
[05:30] you're building. And that thing that
[05:32] you're building or the idea of it is
[05:34] called the design concept. It's not an
[05:36] asset. It's not something you can put in
[05:37] a markdown file. It is the invisible
[05:40] sort of theory of what you're building.
[05:44] And so I thought, okay, that's what's
[05:46] going on. Me and the AI don't share a
[05:48] design concept. So I came up with a
[05:50] skill. The skill is very very simple.
[05:53] It's called grill me and it looks like
[05:56] this. Interview me relentlessly about
[05:58] every aspect of this plan until we reach
[06:01] a shared understanding. Walk down each
[06:04] branch of the design tree which is
[06:05] another thing from Frederick P. Brooks
[06:07] resolving dependencies between decisions
[06:09] one by one. This skill is like uh the
[06:12] repo containing this skill has like
[06:13] 13,000 stars or something like it just
[06:15] went nuts. Went viral. People love this
[06:17] thing. it. These couple of lines means
[06:20] the AI asks you like 40 questions, 60
[06:23] questions. I've had it ask uh people a
[06:25] hundred questions before it's satisfied
[06:27] they've reached a shared understanding.
[06:29] And it means it turns the AI into a kind
[06:32] of adversary where it's just continually
[06:34] pinging you ideas and trying to reach a
[06:36] shared understanding. And that means
[06:38] that the conversation that you then
[06:40] generate, you can take that and turn it
[06:42] into a product requirements document or
[06:44] something. or if it's a small change,
[06:47] you can just uh do turn it directly into
[06:50] issues and then your AFK agent will then
[06:53] pick it up. And don't at me on this, but
[06:56] I personally believe this is better than
[06:58] the default plan mode in the tool that I
[07:02] use, which is claw code. Plan mode is
[07:05] extremely eager to create an asset. It
[07:08] really wants to uh just create a plan
[07:10] and start working. whereas I think it's
[07:13] a lot nicer to reach a shared design
[07:17] concept first. So that's tip number one.
[07:21] Now failure mode number two is that the
[07:22] AI is just way too verbose.
[07:26] It's like you're almost talking across
[07:27] purposes with the AI. Raise your hand if
[07:29] you uh feel this. If you ever experience
[07:32] that failure mode. Yeah. It's kind of
[07:33] like the AI is like talking just using
[07:35] too many words to try to communicate
[07:37] what it's doing. It's not like you're
[07:39] talking uh using the same language. And
[07:42] this to me felt very very familiar.
[07:44] Right? If you've ever been a developer
[07:46] for a long time and you've worked with
[07:48] let's say domain experts, someone
[07:49] building an application um let's say the
[07:52] domain expert wants you to build
[07:53] something on uh I don't know microchips.
[07:55] You have no idea what microchips are.
[07:57] You need to establish some kind of
[07:58] shared language, right? Because
[08:00] otherwise they're going to be using
[08:01] terms you don't understand. You're going
[08:02] to be translating that into code that
[08:04] maybe you don't even understand and
[08:05] certainly the domain expert won't. And
[08:07] so there's this kind of language gap
[08:09] between you and the domain expert. And
[08:13] so I went back to domain driven design.
[08:16] DDD, this is something I'm still kind of
[08:18] on the edge of exploring, but everything
[08:20] I'm reading about DDD is just music to
[08:23] my ears. I freaking love it. And DDD has
[08:26] a concept of a ubiquitous language.
[08:30] With ubiquitous language, conversations
[08:33] among developers and expressions of the
[08:35] code and conversations with domain
[08:36] experts are all derived from the same
[08:38] domain model. It's essentially a
[08:40] markdown file full of a list of terms
[08:42] that you and the AI have in common. And
[08:44] you really focus on those terms and you
[08:46] really make sure that they're aligned
[08:48] with what it actually means and you use
[08:50] them all the time in the code when
[08:52] you're talking about the code when
[08:53] you're talking to domain experts or in
[08:55] our case when you're talking with AI. So
[08:57] I made a skill. This skill is the
[09:00] ubiquitous language skill. Basically
[09:02] just scans your codebase, looks for
[09:04] terminology, and then um creates a
[09:08] markdown file. Creates the ubiquitous
[09:10] language markdown file. A bunch of
[09:11] markdown tables with all of the
[09:13] terminology. And this then I pass it to
[09:16] the AI and I'm able to read it to and I
[09:19] actually have it open all the time when
[09:21] I'm grilling with the AI and planning
[09:22] and that. And what I noticed by reading
[09:25] the thinking traces of the AI, it not
[09:26] only improves the planning, but it
[09:28] allows the AI to think in a less verbose
[09:31] way and actually means that the
[09:33] implementation is more aligned with what
[09:35] you actually planned. So this has
[09:38] absolutely been a powerhouse. It's been
[09:39] unbelievably good. So that's tip number
[09:42] two. Create a shared language with the
[09:44] AI. So okay, let's imagine that you've
[09:47] aligned with the AI. You know what it is
[09:49] you're supposed to be building. the AI
[09:51] has built the right thing, but it
[09:54] doesn't work. Raise your hands if that's
[09:56] happened to you. Yeah, just doesn't
[09:58] work. Well, there's an obvious thing
[10:00] that we can do to make that better,
[10:03] which is we can use feedback loops. We
[10:05] can use um static types. You know, if
[10:07] you're not using TypeScript, u that's
[10:09] crazy. Uh if you're not using uh if
[10:12] you're building a front-end app and
[10:13] you're not giving it the LM access to
[10:15] the browser so it can look around,
[10:17] absolutely needs that. And you obviously
[10:20] also need automated tests.
[10:23] And one sort of thing I notice here is
[10:27] that even with these feedback loops, the
[10:29] LLM doesn't use them very well. It
[10:32] doesn't kind of like get the most out of
[10:34] its feedback loops in the way that a
[10:35] veteran developer would. And so it does
[10:37] what it tends to do is just does way too
[10:40] much at once. it will produce like huge
[10:42] amounts of code and then think, "Oh, I
[10:44] should probably type check that actually
[10:46] or I should uh yeah, maybe check a test
[10:48] on that or maybe do something like
[10:49] that." And this in the pragmatic
[10:52] programmer they describe as outrunning
[10:53] your headlights as essentially driving
[10:56] too fast because the rate of feedback is
[11:00] your speed limit. The rate of feedback
[11:03] is your speed limit, which means that
[11:04] you should be testing as you go, taking
[11:07] small deliberate steps. And the AI by
[11:09] default is really not very good at that.
[11:12] And so skill number three is TDD. You
[11:15] should be using testdriven development
[11:17] because TDD forces the LLM to really
[11:22] take small steps. You create a test
[11:24] first. You make that test pass and then
[11:27] you refactor the code to make it nicer
[11:29] and consider the design.
[11:32] The issue here is that testing is really
[11:35] hard. Testing has always been hard.
[11:38] And the reason for that
[11:41] is there are a ton of different
[11:43] decisions you need to make when you
[11:45] write a test. You need to figure out how
[11:47] big a unit do you want to test. You need
[11:50] to figure out what to mock. You need to
[11:52] figure out what behaviors do you even
[11:54] want to test in the first place. And all
[11:56] of these decisions are dependent. So if
[11:57] you are testing a really big unit like
[11:59] an entire massive application, then it
[12:02] might be quite flaky. You might not want
[12:04] to test that many behaviors. you know,
[12:06] if you only test this unit, you need to
[12:08] mock this unit. You know, it's all
[12:09] interlin. And I've been thinking about
[12:11] this for years for my entire development
[12:13] career.
[12:15] And what we notice is that good code
[12:18] bases are easy code bases to test,
[12:20] right? So, here we're starting to get
[12:22] back to the idea of code being important
[12:25] is that the better your codebase is, the
[12:27] better your feedback loops are. Because
[12:29] you're able to um give better feedback
[12:32] to the LM, it produces better code.
[12:35] And so I thought what does a good
[12:37] codebase what does a testable codebase
[12:38] look like? Again we go to John
[12:41] [clears throat] erhout. He talks about
[12:43] having deep modules in your codebase.
[12:46] Not shallow modules not lots of modules
[12:48] that expose like kind of um lots of
[12:51] functions. They should be relatively few
[12:54] large deep modules with simple
[12:56] interfaces. Let's compare them quickly.
[12:59] Deep modules, lots of functionality
[13:01] hidden behind a simple interface, hiding
[13:04] the complexity. You can look inside the
[13:06] deep module if you want to, but you
[13:07] don't need to. You can just use the
[13:09] interface. Shallow modules, not much
[13:11] functionality, complex interface.
[13:14] And I'll just wait for you to take the
[13:16] photos.
[13:18] Shallow modules in a codebase kind of
[13:20] look like this, where you have a ton of
[13:22] different tiny little blobs that the AI
[13:24] has to walk through and navigate. And
[13:27] this is really hard for the AI to
[13:29] explore actually. And so often what
[13:31] you'll see is if you have a codebase
[13:33] like this, which AI is really good at
[13:34] creating code bases like this is that
[13:37] you'll have a situation where AI doesn't
[13:39] understand what your code is doing. It
[13:41] will attempt to explore the code, but
[13:43] because it's poorly laid out, filled
[13:45] with shallow modules, it doesn't maybe
[13:47] get to the right module in time or
[13:49] doesn't understand all the dependencies,
[13:50] all that stuff. It doesn't understand
[13:52] your code. And so what does a codebase
[13:55] full of deep modules look like? Well, it
[13:58] looks like this
[14:00] where it's the same code, but it's just
[14:02] structured inside boundaries where you
[14:04] have these interfaces on the top.
[14:08] And these interfaces, you should
[14:10] probably have a lot of control over them
[14:12] and design them really well. Otherwise,
[14:14] you know, AI might mess up the design.
[14:17] But the implementation, you can kind of
[14:18] leave that to the AI a bit.
[14:21] So, how do you turn a codebase that
[14:23] looks like this into a codebase that
[14:26] looks like that? Well, I've got a skill
[14:30] for that. Improve codebase architecture.
[14:32] Turns out this is not it's quite
[14:34] complicated to do this, but it's a like
[14:37] a set of steps that you can reusably do
[14:39] again and again. You just sort of
[14:41] explore the codebase, look for
[14:42] opportunities where there's code that's
[14:44] kind of um related, and wrap all of that
[14:47] in a deep module.
[14:50] And this is a testable codebase because
[14:52] the boundaries around this code are so
[14:54] so simple. You test at the interface,
[14:57] you verify using that interface and
[14:59] you're good to go. And so this is a
[15:00] codebase that rewards TDD.
[15:04] But how about failure bone number six,
[15:06] which is your okay, let's say your
[15:08] feedback loops are working. Let's say
[15:09] that things are kicking into gear.
[15:11] You're able to ship more code than you
[15:12] ever have before, but your brain can't
[15:15] keep up, right? Uh, raise your hand if
[15:18] you felt more tired than you have ever
[15:20] before in your development career. Yeah,
[15:22] me too. It's knackering. And I think
[15:26] that this is a codebase that actually
[15:28] makes it harder for your brain because
[15:30] you as well as the AI need to keep all
[15:32] of that information in your head.
[15:34] Whereas this, not only is it simpler
[15:38] for you to read and understand, it also
[15:40] means you can kind of treat these
[15:42] modules or these deep modules as gray
[15:45] boxes.
[15:47] you can kind of say okay I'm going to
[15:51] just design the interface but I'm not
[15:52] going to worry too much or not review
[15:54] the implementation too much you can do
[15:57] this obviously with uh things that are
[15:58] less critical in your application can't
[16:00] do this with uh you know various things
[16:02] like finance or whatever but in many
[16:05] many modules in your app you don't need
[16:07] to think about the implementation too
[16:08] much as long as you have a testable
[16:10] boundary outside the module and as long
[16:12] as you understand its purpose and can
[16:14] design it from the outside I have found
[16:16] this has really saved my brain because I
[16:18] can just go okay the AI I'll let you
[16:21] handle what's inside the big blob I'm
[16:23] just going to test from the outside and
[16:24] verify it so that's tip number five
[16:27] design the interface delegate the
[16:29] implementation
[16:32] but this means that whenever we're
[16:34] touching the code whenever we're
[16:35] planning stuff we need to think about
[16:37] and be aware of the modules in our
[16:39] application we need to know that map
[16:41] really well it needs to be part of our
[16:43] ubiquitous language we need to build
[16:45] into our planning skills as well. So my
[16:48] writer PRD inside the PRD I'm specific
[16:50] about the module changes and the
[16:52] interfaces inside those modules how
[16:54] they're being modified. I'm thinking
[16:55] about them all the time. And this comes
[16:57] from Kent Beck. Invest in the design of
[17:00] the system every day. And this is the
[17:03] core of it right because specs the code
[17:05] we are not investing in the design of
[17:07] the system we are divesting from it.
[17:10] We're getting rid of that. Whereas this
[17:12] I think is absolutely key.
[17:16] And so code is not cheap. That's the
[17:19] message I want you to take away. Code is
[17:21] important.
[17:23] And if we think about AI as a really
[17:25] great on the ground programmer, a kind
[17:28] of tactical programmer, a sergeant on
[17:30] the ground making the code changes, you
[17:33] need someone above that. You need
[17:35] someone thinking on the strategic level
[17:38] and that's you. And that requires
[17:40] software fundamental skills that we've
[17:42] been using for 20 years for longer.
[17:46] Now, if you are interested in any of the
[17:48] skills I put up here, it's in the GitHub
[17:50] repo, Mac PCO skills. And if you're
[17:52] interested in the training that I do or
[17:54] uh any free stuff, I'm on YouTube, I'm
[17:56] on Twitter, but I'm also at aihero.dev
[17:58] where I have a newsletter that you can
[18:00] check out. Thank you so much. I hope
[18:02] that this gives you confidence in this
[18:04] new AI age that you can actually make a
[18:06] good impact. Thank you.
[18:09] >> [music]
[18:10] [applause]
[18:15] [music]
[18:21] [music]
