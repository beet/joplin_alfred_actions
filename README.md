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
