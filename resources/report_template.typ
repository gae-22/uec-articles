#import "@preview/codelst:2.0.2": *
#import "@preview/unify:0.7.1": *
#import "@preview/physica:0.9.3": *

// フォントサイズ
#let title_size = 20pt
#let large = 16pt
#let medium = 12pt
#let normal = 10.5pt
#let small = 9.5pt
#let tiny = 8.5pt
// フォント
#let default_font = ("New Computer Modern", "Harano Aji Mincho")
#let gothic_font = ("New Computer Modern", "Harano Aji Gothic")
#let math_font = ("New Computer Modern Math", "New Computer Modern")

// フォントの色定義(RGB)
#let red_rgb = rgb("#933")
#let green_rgb = rgb("#272")
#let blue_rgb = rgb("#339")

// フォントスタイル定義
#let red(body) = text(fill: red_rgb, weight: "semibold")[#body]
#let green(body) = text(fill: green_rgb, weight: "semibold")[#body]
#let blue(body) = text(fill: blue_rgb, weight: "semibold")[#body]

#let project(title: "", author: "", course: "", abstract: "", body) = {
    // Set the document's basic properties.
    set document(author: author.name, title: title)
    set page(paper: "a4", margin: (top: 32mm, bottom: 12mm, rest: 16mm))
    set text(font: default_font, size: normal, weight: "regular", lang: "jp")
    set par(justify: true, first-line-indent: normal, leading: normal, spacing: normal)

    // Heading
    set heading(numbering: "I.A")
    show heading.where(level: 1): it => {
        set heading(supplement: [章])
        text(font: gothic_font, weight: "medium", size: normal, lang: "ja")[
            #align(center)[#pad(top: 8pt)[#it]] #par(text(size: 0pt, ""))
        ]
    }
    show heading.where(level: 2): it => {
        set heading(supplement: [節])
        text(it, font: gothic_font, weight: "medium", size: normal, lang: "ja")
    }
    show heading.where(level: 3): it => {
        set heading(supplement: [項])
        text(it, font: gothic_font, weight: "medium", size: normal, lang: "ja")
    }
    show ref: it => {
        let elem = it.element
        if elem != none and elem.func() == heading {
            let num = numbering(
                elem.numbering,
                ..counter(heading).at(elem.location()),
            )
            if elem.level == 1 {
                "第" + num + "章"
            } else if elem.level == 2 {
                "第" + num + "節"
            } else if elem.level == 3 {
                "第" + num + "項"
            } else {
                num
            }
        } else {
            it
        }
    }
    // Figure
    show figure: it => pad(y: 0.5em, it)
    show figure: set text(size: normal)
    show figure.caption: it => text(it, lang: "ja")

    // Table
    set table(stroke: none)
    show figure.where(kind: table): set figure.caption(position: top)

    // Equation
    set math.mat(delim: "[")
    show math.equation: set text(font: math_font, size: small)
    set math.equation(
        numbering: "(1)",
        number-align: (right + bottom),
        supplement: "式",
    )

    // Code
    show figure.where(kind: raw): set figure(supplement: "アルゴリズム")
    show figure.where(kind: raw): set figure.caption(position: top)

    set box(stroke: 2pt + luma(60%), inset: 0pt, outset: 12pt, radius: 8pt)
    let date = datetime.today()

    // Title row.
    align(center)[
        #block(text(weight: "medium", size: title_size, font: default_font)[#title])
        #v(4mm)
        #block(text(size: large, font: default_font)[#course])
    ]

    // Abstract
    v(16mm)
    align(center)[#text(font: default_font)[
            #heading("Abstract", numbering: none, level: 1)
        ]
    ]
    abstract

    v(1fr)

    align(right)[
        #table(
            columns: 2,
            [研究室 :], [藤井研究室],
            [メンター :], [工藤 駿輔],
            [学籍番号 :], [2210177],
            [氏名 :], [鐘ヶ江僚太],
        )
        提出日 : #date.year() 年 #date.month() 月 #date.day() 日
    ]

    pagebreak()

    set text(font: default_font, size: normal, weight: "light", lang: "ja")
    set page(columns: 2, numbering: "1", number-align: center, margin: (top: 16mm, rest: 12mm))
    counter(page).update(1)
    counter(figure).update(1)

    // Main
    body
    bibliography(
        "main.bib",
        title: "参考文献",
        style: "ieee",
        full: true,
    )
}

#let math_text(text, size: normal) = { math.text(text, font: default_font, weight: "regular", size: size) }

#let math_restate(target_label) = context {
    let queried_elements = query(selector(label(target_label)).before(here()))
    if queried_elements.len() == 0 {
        panic("Error: Could not find element <" + str(target_label) + ">.")
    }

    let el = queried_elements.first()
    if el.func() == math.equation {
        let body_content = el.body

        let restatement_text = $#math_text("(再掲)")$
        let ref_text = ref(label(target_label), supplement: none)

        let measured_width = measure(block[#restatement_text]).width

        let restatement_annotation = [
            #place(left, dx: -measured_width)[#text(restatement_text, weight: "thin")] #ref_text
        ]

        math.equation(
            block: true,
            body_content,
            numbering: _ => restatement_annotation,
        )
        counter(math.equation).update(n => n - 1)
    } else {
        panic(
            "Error: <" + str(target_label) + "> is not a math.equation." + " Instead, it is " + el.func().name() + ".",
        )
    }
}
