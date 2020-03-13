# Joplin Noteplan Actions

Alfred workflow for automating some actions when working with [Joplin](https://joplinapp.org).

**[Downloads](https://github.com/beet/joplin_alfred_actions/releases)**

## Insert wiki link

Keyword: `jwl`

Insert a wiki link to any Joplin page with fuzzy search of the page headings that looks like:

```
[Index](:/2a1da8fb229c4824ab64833b589b108b)
```

It's very common in wiki-like apps to be able to create a new page by inserting a link into another page and then clicking it, but most other wiki-like apps follow the convention of using a format like `[[Page Name]]` for the links.

Joplin follows the convention of using some kind of SHA for the filename, like `2a1da8fb229c4824ab64833b589b108b` which is generated when pages have been created.

So while the workflow isn't quite as neat, you can still just create a new page with `COMMAND+N`, use `COMMANG+G` to navigate back to the target page, then use this workflow to insert a link back to the new page.

Yes, you can right click on the file, if you have the note list exposed, and copy its markdown link from there. If you have the list sorted with the newest notes at the top, it will be easy to find too.

I often find myself interlinking exsiting pages though during review and reflection, and this workflow means I can stay in the flow and link them up by name instead of having to locate them in the notes list, copy the markdown link, then paste it into page I'm working on.
