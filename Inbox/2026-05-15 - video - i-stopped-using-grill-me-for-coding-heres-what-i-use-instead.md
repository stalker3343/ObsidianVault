---
type: youtube
source: https://www.youtube.com/watch?v=6BB6exR8Zd8
title: "I stopped using /grill-me for coding. Here’s what I use instead:"
channel: "Matt Pocock"
duration_sec: 916
upload_date: 2026-05-14
created: 2026-05-15T13:08:09+03:00
status: inbox
transcript_status: ok
tags:
  - source/youtube
---

# I stopped using /grill-me for coding. Here’s what I use instead:

## Transcript

[00:00] A few months ago, I wrote a few
[00:02] sentences, about four sentences, that
[00:04] have turned out to be the most
[00:06] influential four sentences I've ever
[00:09] written. I packaged these four sentences
[00:10] up into the Grill Me skill, which is a
[00:13] skill that you can use to get the LLM to
[00:15] interview you relentlessly. It
[00:17] interviews you until you reach a shared
[00:19] understanding, walking down each branch
[00:21] of the design tree, resolving
[00:22] dependencies between decisions one by
[00:24] one. I know this skill is influential
[00:25] because every single day I receive about
[00:28] five messages of people saying they've
[00:30] tried it and they love it. This skill is
[00:31] an absolute game-changer. What are your
[00:33] favorite skills? Grill Me is great. I'm
[00:35] working on a project, blah blah blah.
[00:37] The Grill Me skill asks me about
[00:38] ambiguities. Fantastic. Grill Me skill
[00:41] is goated. At first, I felt like it
[00:42] slowed me down with all the questions,
[00:44] but after using it a bit, I honestly
[00:45] think it might save time. You just
[00:47] one-shot everything after you've kind of
[00:50] gathered all the context. Have you
[00:51] tested the skill called Grill Me? And
[00:53] blah blah blah blah blah. It's
[00:54] wonderful, wonderful, wonderful,
[00:55] wonderful. And after all that praise,
[00:57] you might think, well, you should
[00:59] probably stick with that skill,
[01:00] shouldn't you? That skill sounds pretty
[01:01] good. And it turns out I've actually
[01:03] built a better one. I'm never very happy
[01:05] when I'm resting on my laurels. I always
[01:07] feel like there's improvements to be
[01:09] made at every single part of my process.
[01:11] And now, Grill Me has been replaced with
[01:14] a new skill. Let's open up a session so
[01:15] that I can explain a little bit more
[01:17] about where Grill Me goes wrong. I'm
[01:19] going to paste in a prompt that I've
[01:20] already added here. And this prompt is
[01:22] an idea for a new feature. I've just
[01:24] dictated this out, so you just sort of
[01:26] be spared the details of it. But
[01:28] essentially, I want to create a new
[01:30] entity in my database, and a new entity
[01:32] that my app is going to deal with.
[01:34] Currently, this application deals in
[01:36] courses, deals in lessons, deals in
[01:38] videos, and you know, sections and a few
[01:40] other things. And I want to add a
[01:42] concept of pitches. There's this kind of
[01:44] Mr. Beast style axiom where you should
[01:46] be thinking about the packaging for your
[01:48] video before you actually work out
[01:50] what's going in the video. And that's
[01:52] what a pitch is in this kind of setup. A
[01:55] pitch is really just the packaging for
[01:57] the video, the title, the description,
[01:59] how I'm going to frame it to people, and
[02:00] I create a bunch of these pitches and
[02:02] then pick the best ones and then turn
[02:04] those into videos. Now, what you notice
[02:06] here is as I'm communicating with the
[02:07] agent, I we're really focusing on
[02:10] language, right? We're really focusing
[02:11] on what is a pitch. I just had to
[02:13] communicate that to you so that you
[02:15] could follow along, and the agent will
[02:16] need to extract that information from
[02:18] me, too. But, there's also some extra
[02:20] jargon in here that the agent doesn't
[02:22] know about yet. For instance, I'm
[02:24] talking about stand-alone videos. What
[02:26] does a stand-alone video mean? Oh, of
[02:29] course, it means a video that's not
[02:30] connected to a lesson or a course. Now,
[02:33] of course, I know that. That's kind of
[02:34] like a term of art for using this whole
[02:36] set up, but the agent doesn't know that
[02:38] yet. It doesn't have any concept of what
[02:40] that is. So, during the grilling
[02:42] session, it's going to have to ask me
[02:43] what a stand-alone video is or try to
[02:45] figure it out from the code. So, as I
[02:47] used Grill me more and more and more, I
[02:49] would start to notice these times where
[02:51] the agent was being really, really
[02:53] verbose and I would have to remind it,
[02:55] "No, there's already a term for that."
[02:57] And often though, there wasn't a term or
[03:00] I was kind of thinking about things in a
[03:02] very verbose way myself and that wasn't
[03:04] being challenged by the agent. Or, we
[03:07] would actually land on some really good
[03:08] shared language and then that wasn't
[03:10] documented anywhere. So, I started to
[03:12] feel dissatisfied with Grill me because
[03:14] there was this piece missing from the
[03:16] puzzle, which is we were able to
[03:18] communicate about the code pretty
[03:19] effectively, but I would have to
[03:21] re-explain all of the non-obvious things
[03:24] about the code base and about the
[03:25] domain, the problem that we were solving
[03:28] before we could do anything productive.
[03:30] So, I started to think to myself, what
[03:32] is the thinnest layer of documentation I
[03:35] could use to just give the AI a bit more
[03:38] of a leg up. So, I came up with this
[03:40] skill, the ubiquitous language skill.
[03:42] Ubiquitous language is an idea that
[03:44] comes from domain-driven design. This is
[03:46] the big blue book by Eric Evans that
[03:48] everyone goes on about. And what it
[03:49] does, it's it's essentially you're
[03:51] trying to create a document, which is
[03:54] the language that's used by the code
[03:56] base, that's used by developers, and
[03:59] that's used by domain experts. In other
[04:01] words, people that know about what
[04:02] you're building, but not how you're
[04:04] building it. All of those three groups
[04:06] should be using a shared language,
[04:08] because that means that the domain
[04:09] expert can go, "Okay, there's something
[04:11] wrong with this particular section of
[04:12] the app." The developer knows what
[04:14] they're talking about, and the code also
[04:16] reflects that. So, what I would do is in
[04:18] the middle of a grilling session, when I
[04:20] noticed that we were needed to sharpen
[04:22] some language, I would use the
[04:24] ubiquitous language skill and call it
[04:26] with, you know, ubiquitous language, and
[04:28] try to create a ubiquitous language.md
[04:31] as we were going. So, I had grill me and
[04:33] I had ubiquitous language, and I was
[04:35] using them both at the same time, and I
[04:37] realized, "Wouldn't it be great if I
[04:39] just combine the two into a new skill?"
[04:41] And here is that new skill. It is grill
[04:44] with docs. It has exactly the same text
[04:47] as grill me at the top here, but it has
[04:49] a couple of extra pieces. The first
[04:51] thing it has is the ability to look for
[04:52] a context.md file. This context.md file
[04:56] will have document all of the shared
[04:58] language that's inside that context.
[05:01] Now, context is like super overloaded,
[05:03] so I'm sort of uncomfortable, but maybe
[05:06] okay with it. It's essentially a bounded
[05:08] context in DDD is a part of the app in
[05:11] which you speak a shared language. So,
[05:13] if you have a massive mono repo, you can
[05:15] have a context map here and have many
[05:18] different contexts inside. So, that's
[05:20] how you would scale this to an enormous
[05:22] repo. But still, if you just have one
[05:25] pretty big repo where all the
[05:27] application is speaking the same
[05:28] language and the domain expert speak the
[05:30] same language, then you can just use a
[05:31] single context.md here. So, it's
[05:33] instructed to look for this existing
[05:35] documentation to pull in this shared
[05:37] language, and then during the session
[05:39] it's got some extra additions here to
[05:42] challenge uh language usage against the
[05:45] existing glossary, to sharpen fuzzy
[05:47] language, discuss concrete scenarios,
[05:50] cross-reference with code, and update it
[05:52] as you go. So, this essentially helps
[05:55] you really sharpen your language as
[05:57] you're using the Grill with Docs skill.
[05:59] And this pays off as you go. I was
[06:02] asking some folks for feedback on this,
[06:03] and I got some really nice quotes here.
[06:06] So, this guy used it for the whole of
[06:07] today, and at the start it asked him to
[06:09] define a lot of terms. Some terms were
[06:11] hard to agree on, and ones he would most
[06:13] definitely forget. But four or five
[06:15] sessions in, he started noticing that
[06:17] Claude was picking up the context during
[06:19] the Grill session, and it magically
[06:21] aligned with the thoughts I had before
[06:23] the words came out of that brain. So,
[06:24] that's what you get out of this. By
[06:26] documenting the non-obvious stuff, by
[06:28] agreeing on a shared language, you
[06:30] really can nail down and get a magical
[06:33] alignment between you and the AI, where
[06:35] you just have to use far fewer words to
[06:37] communicate what you mean. For instance,
[06:38] here's the one that I have in my repo
[06:40] here. We essentially just have a little
[06:42] description about what the um, you know,
[06:45] what the repo is. Then we have a course
[06:47] and a course repo, and we have all of
[06:49] the entities inside here, course
[06:51] versions as well, because I have
[06:52] multiple versions. And if we look for
[06:54] the one that we were looking at before,
[06:55] which is standalone
[06:57] video, it is just down here. So, we have
[07:00] an exact specification for what
[07:02] standalone video means now. Now, the
[07:04] Grill with Docs skill knows to look for
[07:06] this, but I also add a context pointer
[07:08] into, not inside that claw.md, but
[07:11] inside the local claw.md here. So, we
[07:15] have just this domain docs, a single
[07:17] context layout, context.md at the repo
[07:19] root, and you see this extra little bit
[07:22] of uh, documentation for more
[07:25] information about where this stuff is.
[07:27] One final thing that Grill with Docs
[07:28] does is that there are some things that
[07:31] sharpening the fuzzy language will help
[07:33] with, but there are some things that it
[07:35] won't. And so, I wanted a layer that
[07:38] would explain all the non-obvious
[07:40] decisions that weren't able to be
[07:42] captured inside context.md. And so for
[07:44] that, I've gone with an architectural
[07:46] decision record. These ADRs here are
[07:48] really like simple markdown files that
[07:51] sit in your repo that essentially
[07:53] document all of the non-obvious
[07:55] decisions. You only want to create an
[07:57] ADR when the decision is hard to reverse
[08:00] because if it's just like oh we'll use
[08:01] this library instead of this library and
[08:03] they're kind of interchangeable, then
[08:04] you can always just swap later.
[08:06] It would be surprising without context.
[08:09] And plenty of decisions in a repo are
[08:11] surprising without context, especially
[08:13] more complex ones, and the result of a
[08:15] real trade-off. In other words, that
[08:17] this decision has consequences down the
[08:19] line. And I've got an ADR format inside
[08:21] here that um the LLM uses when it
[08:24] creates these ADRs. So now we understand
[08:26] all the pieces, let's go back up to
[08:28] here. Let's replace grill me with grill
[08:31] with docs, and let's actually start this
[08:33] grilling session to see it in action.
[08:35] All right, so the first thing it has
[08:36] done is it said "Ooh, context.md is
[08:38] rich. Standalone video is already
[08:40] defined as a lessier
[08:42] a video with lesson ID equals null." And
[08:44] it says before going further, I want to
[08:46] surface attention with the glossary.
[08:48] This is what you'll often find with
[08:49] grill with docs is that it really
[08:51] focuses on the language before you then
[08:53] actually go and talk about
[08:54] implementation details. It says there's
[08:56] cardinality between pitch and standalone
[08:58] video. It's asking whether one pitch
[09:00] holds many standalone videos or one
[09:02] pitch corresponds to exactly one
[09:04] standalone video. I think it might make
[09:06] sense to follow its recommendation here
[09:08] and go with okay, we have one to many
[09:10] relationship here. So I'm just going to
[09:12] say correct. Very nice. Next up, it's
[09:15] noticing that there's a terminology
[09:16] collision with the standalone video. So
[09:19] it's saying that you have a standalone
[09:21] video that are either totally standalone
[09:23] or they can be related to pitches. So I
[09:26] think it's basically asking whether we
[09:28] keep standalone video as any pitched or
[09:31] unpitched lesson
[09:33] or we redefine it to mean specifically
[09:34] unpitched unlessoned video. Now the way
[09:37] we answer this question is going to
[09:38] influence everything afterwards. It's
[09:39] going to influence whether standalone
[09:41] videos get their own section in the UI
[09:44] or whether we have standalone videos and
[09:47] videos with pitches kind of mixed in.
[09:49] Because the language that we're defining
[09:50] here is also the language that the user
[09:52] is going to be seeing on the page when
[09:54] they navigate around this. And I think
[09:56] I'm agreeing with it. Actually, I was
[09:58] actually going into this thinking we
[09:59] would probably have a separate section
[10:00] for pitched videos, but I think yes, I
[10:03] agree. It makes sense to keep pitching
[10:05] as just metadata on the standalone video
[10:07] itself. This, by the way, is Whisper
[10:09] Flow, what I'm using for dictation. It
[10:11] works okay. I'm not sure I'd recommend
[10:13] it, but it's fine. It's now saying,
[10:15] "Okay, we need some status semantics
[10:17] here." So, each pitch can be idle or
[10:20] scheduled or shipped here. I think I
[10:23] want just to allow I think I want to
[10:26] allow just free-form transitions. So, I
[10:28] don't really care about this being
[10:30] automated. We can always layer on
[10:32] automation later, you know, like when
[10:34] you press uh send to YouTube or
[10:36] something, it goes into a new status.
[10:38] But for now, I'm okay just like toggling
[10:39] it myself. That's fine. It's now asking,
[10:41] "Can a pitch exist with zero videos?"
[10:43] Absolutely, a pitch can exist with zero
[10:45] videos. The point here is that we're
[10:47] kind of generating um pitches, ideas for
[10:49] videos, you know? This is the Mr. Beast
[10:51] thing. We're trying to uh
[10:53] get the packaging ready first. And this
[10:55] relationship, this language also goes
[10:57] into things as concrete as deletion
[10:59] cascades. So, I think I'm going to say
[11:03] on delete restrict here. This is mostly
[11:05] because I just uh like um restrictive
[11:08] deletions. And mostly what I do is I
[11:11] tend to archive instead of delete when I
[11:12] actually do these. We're now getting
[11:14] into more implementation details here.
[11:16] So, I think um instead of just boring
[11:18] you with actually like implementing the
[11:20] grilling session here, I'm just going to
[11:21] say, "Could you save what we have into
[11:23] context.md so far?" If there's anything
[11:25] we haven't figured out, grill me about
[11:26] that before you make the adjustments.
[11:28] And let's see what it goes for here. And
[11:30] okay, it has made a bunch of updates
[11:33] into context.md. Specifically, it's
[11:35] added a bunch of pitch information here.
[11:37] So, we've got pitch, the actual entity
[11:38] itself. We've got pitch status, the
[11:41] status the pitch can be in. Pitched
[11:43] standalone video is a little bit
[11:45] awkward. I might want to grill it about
[11:47] that. And then unattached standalone
[11:50] video. That's also like So, it's
[11:52] basically saying standalone standalone
[11:54] video. Now, bear in mind, I'm like I
[11:56] might seem like pretty, you know,
[11:57] anal-retentive about this language. This
[11:59] might just feel like bike-shedding to
[12:01] you. But, this is going to affect every
[12:02] part of the code that's generated. All
[12:05] variable names, all file names are going
[12:07] to be based on these uh context.md
[12:09] documents here. And so, getting this
[12:11] right is absolutely crucial for feeling
[12:13] aligned with the AI. Now, of course, we
[12:15] don't want to just endlessly bike-shed.
[12:17] So, I'm going to call this now. I'm
[12:19] going to say that's good enough. Let's
[12:21] ship with this. We can always change and
[12:22] refactor to new language later. So,
[12:25] let's quickly talk about the benefits
[12:26] here. What you actually get from going
[12:28] through this ceremony. thing that you
[12:30] get is concise replies. The AI is able
[12:32] to use fewer tokens to speak to you
[12:35] because you have this shared language
[12:36] and it doesn't need to verbosely repeat
[12:39] everything or re-describe everything. It
[12:41] just says, "Okay, standalone videos are
[12:43] changing. We needed to make a change to
[12:45] the pitches and how the pitches
[12:46] display." This concision is also
[12:48] reflected in its own thinking traces as
[12:50] well. Because, of course, AI uses
[12:52] language to think to itself. And so,
[12:55] it's able to be much more aligned with
[12:57] your intention and actually use fewer
[12:59] tokens thinking. This is something I've
[13:01] observed and it feels pretty nice. And
[13:03] finally, because the planning documents,
[13:05] because the way that you're speaking
[13:07] with the AI is also aligned with the way
[13:09] the code looks as well, then you end up
[13:12] with easier to navigate code. Because
[13:13] it's able to just, "Okay, I need to find
[13:15] all the information about pitches. Let
[13:16] me just search for it." And of course,
[13:18] this makes sense because these are all
[13:19] the same benefits described in
[13:21] domain-driven design itself. So, the
[13:23] same techniques that work with humans
[13:24] also, it turns out, work with AI. You're
[13:27] thinking though, is Grill me dead? Did I
[13:30] just kill Grill me? Did its creator come
[13:32] along and stab it in the back?
[13:33] Absolutely not. I think Grill me is an
[13:35] excellent excellent skill, but Grill
[13:38] with Docs is better when you have a code
[13:40] base. In my skills, I have moved Grill
[13:43] me into the productivity area here. So,
[13:46] this is for general use cases, for use
[13:48] cases where you don't have a code base.
[13:50] I had someone, this is the most amazing
[13:52] story, who said that they were writing a
[13:54] eulogy for their mom, and they used
[13:56] Grill me to get the AI to grill them
[13:58] about their mom and surface all these
[14:00] amazing stories. And so, Grill me has
[14:03] incredible use cases outside of
[14:05] engineering. And of course, if you are
[14:07] really early on in a project, actually
[14:09] really early on a project, I'd still
[14:11] probably recommend using Grill with Docs
[14:13] because you just get so much more out of
[14:15] that shared language, and often at the
[14:17] start of a project is where you're
[14:18] trying to establish that shared
[14:20] language. So, essentially, the rule is
[14:22] when you have a code base, use Grill
[14:23] with Docs. When you don't have a code
[14:25] base, use Grill me. I update these
[14:27] skills super duper regularly, and I'm
[14:29] often thinking new thoughts about the
[14:31] skills or even how best to use them
[14:33] without changing the skills themselves.
[14:35] So, I keep everyone up to date on this
[14:37] with my AI skills for real engineers
[14:39] newsletter. This is just an addition to
[14:40] the already good newsletter that I have
[14:43] that just gives you a few extra skills
[14:45] updates, or maybe one a week when they
[14:47] happen. I really freaking hate email
[14:49] spam, and so I'm not going to spam you,
[14:51] but this little page will help you
[14:53] basically keep up to date with all the
[14:54] skill change logs and have some nice
[14:56] extra additions here that you can just
[14:59] take a look at and learn how to use the
[15:00] skills better. Otherwise, thanks for
[15:01] watching, and I'll see you in the next
[15:03] one. Thank you so much for following
[15:04] along. I really really appreciate it.
[15:06] And if you enjoy this skill, then do let
[15:08] me know in the comments how you got on
[15:09] with it, what you noticed, and do raise
[15:11] an issue on the skills repo itself if
[15:14] you think there's something that I can
[15:15] improve.
