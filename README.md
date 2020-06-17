# Joplin Noteplan Actions

Alfred workflow for automating some actions when working with [Joplin](https://joplinapp.org).

**[Downloads](https://github.com/beet/joplin_alfred_actions/releases)**

As humans, we think of our notes in terms of their headings/titles, but Joplin names the files with a kind of SHA like `2a1da8fb229c4824ab64833b589b108b`. This allows links between pages to remain intact even if their titles are changed, but makes the files themselves more difficult to work with.

These actions provide an abstraction over the note IDs that allows you to stay in the mind-space of page headings while working with Joplin.

## Setup

### Notes location

When first installing the Alfred workflow, it should prompt you to enter a value for the `base_directory` variable.

This should be set to the _relative_ path, without your home directory included.

For example, if your Joplin notes are in `/Users/homedir/Library/Mobile Documents/com~apple~CloudDocs/Docs/Joplin/`, you should set `base_directory` to `/Library/Mobile Documents/com~apple~CloudDocs/Docs/Joplin`

## Insert wiki link

Keyword: `jwl`

Insert a wiki link to any Joplin page with fuzzy search of the page headings that looks like:

```
[Page heading](:/2a1da8fb229c4824ab64833b589b108b)
```

Much easier than showing the notes list, finding the target note, right clicking on it, selecting "Copy Markdown link", then pasting it into the page.

## Open in Marked 2

Keyword: `jmk`

Opens the selected note in [Marked 2](https://marked2app.com).

Joplin's live preview is great, but sometimes it's handy to have a rendered preview of one page open for reference while working on another in Joplin.

This action does not require the targe note being open in Joplin, in fact, it doesn't even require Joplin itself being open at all.

## Reveal in Finder

Keyword: `jrf`

Reveals the selected note in Finder.

As humans, we think of our notes in terms of their headings, but Joplin names the files with some kind of SHA like `2a1da8fb229c4824ab64833b589b108b`, so if you need to locate a specific note in Finder for something, this action makes it easy with fuzzy search by heading.

## Browse in Alfred

Keyword: `jba`

Kinda renders the reveal in Finder action redundant, as Alfred has a reveal in Finder action itself, but this action also provides access to Alfred's other file actions, including "Open with" if you want to use a different editor, like Folding Text for example.

Usage:

* Bring up Alfred and enter `jba` 
* Search for the desired note, and hit enter after selecting it
* Press the right arrow on the keyboard to bring up Alfred's file actions

## Table Of Contents

Keyword: `jtoc`

Select a Joplin note with fuzzy search by title, and it will generate a nested table of contents of other notes that it links to, and their child notes etc. recursively up to 5 levels deep. The output is a Markdown nested bullet list of links to the child pages, which is copied to the system clipboard.

You can then paste that into another page, but pasting it into the same page will mean that regenerating the TOC for that same page will result in every nested child page being seen as a direct decendent of the parent page, as it now contains a link directly to each one, so you'd want to remove it first.

It excludes recursive links back from a child page to its parent, and will stop at 5 levels deep. If it takes more than 5 seconds to process, it will timeout and return an error.

**NOTE:** you may need to explicitly invoke Joplin's file sync so that the workflow picks up any notes that have been created/edited recently.
