// This function gets your whole document as its `body` and formats
// it as a simple fiction book.
#let book(
  // The book's title.
  title: "Title",

  // The book's author.
  author: "Author",

  // The paper size to use.
  paper: "a4",

  date: none,

  // A dedication to display on the third page.
  dedication: none,

  // Details about the book's publisher that are
  // display on the second page.
  publishing-info: none,

  // The book's content.
  body,
) = {
  show link: underline
  
  // Set the document's metadata.
  set document(title: title, author: author)

  // Set the body font. TeX Gyre Pagella is a free alternative
  // to Palatino.
  set text(font: ("Linux Libertine", "NSimSun"), size: 12pt)

  // Configure the page properties.
  set page(
    paper: paper,
    margin: (bottom: 1.25cm, top: 1.25cm, left: 1.25cm, right: 1.25cm),
  )

  // The first page.
  page(align(center + horizon)[
    #text(2em)[#title]
    #v(2em, weak: true)
    #text(1.6em)[#author]
    #v(2em, weak: true)
    #{
    if date != none {[#date]}
    }
  ])

  // Display publisher info at the bottom of the second page.
  if publishing-info != none {
    align(center + bottom, text(0.8em, publishing-info))
    pagebreak()
  }

  // Display the dedication at the top of the third page.
  if dedication != none {
    v(15%)
    align(center, strong(dedication))
    pagebreak()
  }

  // Configure paragraph properties.
  set par(leading: 0.78em, first-line-indent: 0em, justify: false)
  show par: set block(spacing: 1em)

  // Start with a chapter outline.
  outline(title: [目#h(0.5em)录 #v(0.5em)], indent: true)


  // Configure page properties.
  set page(
    numbering: "1/1",

    // The header always contains the book title on odd pages and
    // the chapter title on even pages, unless the page is one
    // the starts a chapter (the chapter title is obvious then).
    header: locate(loc => {
      // Are we on an odd page?
      let i = counter(page).at(loc).first()

      // Are we on a page that starts a chapter? (We also check
      // the previous page because some headings contain pagebreaks.)
      let all = query(heading, loc)
      if all.any(it => it.location().page() in (i - 1, i)) {
        return
      }

      // Find the heading of the section we are currently in.
      let before = query(heading, before: loc)
      if before != () {
        align(right, text(0.95em, smallcaps(before.last().body)))
      }
    }),
  )

  set heading(numbering: "1.1.1.")
  show heading.where(level: 1): it => {
    pagebreak()
    block(inset:("bottom":0.5em), counter(heading).display() + h(0.5em) + it.body)
  }
  show heading.where(level: 2): it => {
    block(inset:("bottom":0.5em), counter(heading).display() + h(0.5em) + it.body)
  }
  show heading.where(level: 3): it => {
    block(inset:("bottom":0.5em), counter(heading).display() + h(0.5em) + it.body)
  }

  body
}