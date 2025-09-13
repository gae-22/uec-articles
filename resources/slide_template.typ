#import "@preview/polylux:0.4.0": *
#import "@preview/codelst:2.0.2": *
#import "@preview/unify:0.7.1": *
#import "@preview/physica:0.9.3": *

// フォントサイズ
#let title_size = 32pt
#let large = 26pt
#let medium = 24pt
#let normal = 22pt
#let small = 20pt
#let tiny = 18pt

#let gothic_font_ja = "Meiryo UI"
#let math_font = "New Computer Modern Math"

// フォントの色定義(RGB)
#let red_rgb = rgb("#933")
#let green_rgb = rgb("#272")
#let blue_rgb = rgb("#339")

// フォントスタイル定義
#let red(body) = text(body, fill: red_rgb, weight: "semibold")
#let green(body) = text(body, fill: green_rgb, weight: "semibold")
#let blue(body) = text(body, fill: blue_rgb, weight: "semibold")
// メリット・デメリットのフォントスタイル定義
#let adv(body) = blue(body)
#let dadv(body) = red(body)
#let unknown(body) = box(body, fill: rgb(200, 100, 100, 100), stroke: 1pt + red_rgb)

// 花文字
#let scr(it) = text(features: ("ss01",), box($cal(it)$))

#let header(title) = place(
    text(title, size: large, weight: "bold"),
    left + top,
    float: true,
    clearance: -1.7em,
    dx: 0em,
    dy: -3.7em,
)

#let project(title_en: "", title_ja: "", authors: "", cite: "", date: "", body) = {
    set document(author: "鐘ヶ江 僚太", title: "集中輪講第2回")
    set page(paper: "presentation-4-3", margin: (top: 10mm, left: 15mm, right: 15mm, bottom: 5mm))

    // フォント
    set text(
        font: (
            (name: gothic_font_ja, covers: regex("[\p{scx:Latin}0-9]")),
            (name: math_font, covers: regex("[\p{scx:Greek}]")),
            (name: gothic_font_ja, covers: regex("[^\\p{scx:Latin}\\p{scx:Greek}]")),
        ),
        size: normal,
        weight: "regular",
    )

    // 箇条書き
    set list(marker: (
        [#text(size: 16pt)[$square.filled.big$]],
        [#text(size: 16pt)[$diamond.filled$]],
        [#scale(x: 100%, y: 180%)[\u{27A2}]],
        [#text(size: tiny)[$bold(circle.filled.small)$]],
        [✔️],
        [・],
        [・],
        [・],
    ))

    // 見出しのスタイル
    show heading.where(level: 1): set text(size: large, weight: "bold")
    show heading.where(level: 2): set text(size: medium, weight: "bold")
    show heading.where(level: 3): set text(size: normal, weight: "semibold")

    // 表・図のスタイル
    set table(stroke: none, inset: .4em)
    set table.hline(stroke: (paint: luma(60%), thickness: 1pt))
    set table.vline(stroke: (paint: luma(60%), thickness: 1pt))

    show figure.caption: it => text(it, size: small)
    show figure.where(kind: table): set figure.caption(position: top)
    show figure.where(kind: image): set figure(supplement: "図")
    show figure.where(kind: table): set figure(supplement: "表")


    // 数式のスタイル
    show math.equation: set text(font: math_font, size: normal)
    set math.equation(numbering: "(1)", number-align: (right + bottom), supplement: "式")

    // スライドのスタイル
    slide[
        // タイトルスライド
        #place(bottom + left, dx: -10mm, box(width: 36mm, fill: luma(0.9), image(
            "AWCC_logo.png",
            width: 60mm,
        )))

        #align(center + horizon)[
            #let affiliations = authors.map(a => a.affiliation).dedup()
            #grid(
                columns: (1fr,) * authors.len(),
                ..authors.map(author => {
                    let symbol_index = affiliations.position(aff => aff == author.affiliation)
                    align(center)[#text(size: tiny)[#author.name #super(str(symbol_index + 1))]]
                })
            ) \ #v(8mm)
            #text(size: title_size)[#title_ja] \ #v(20mm)
            #text(size: normal)[#date] \ #v(4mm)
            #text(size: 20pt)[
                電気通信大学 \
                先端ワイヤレス・コミュニケーション研究センター (AWCC) \
                藤井研究室 \
                2210177 B4 鐘ヶ江 僚太 \
                #link("mailto: kanegae@awcc.uec.ac.jp") \
            ]


            #for (i, affiliation) in affiliations.enumerate() {
                text(size: 14pt)[#super(str(i + 1)) #affiliation \ ]
            }
        ]
    ]

    counter(page).update(0)

    set page(
        paper: "presentation-4-3",
        margin: (top: 4.5em, left: 8mm, right: 8mm, bottom: 12mm),
        header: context [
            #place(top + right, dx: 4mm, dy: 2mm)[
                #image("AWCC_logo.png", width: 40mm)
            ]
            #place(top, dx: -6.38mm, dy: 18.55mm)[
                #rect(width: 276.72mm, height: 6pt, fill: gradient.linear(
                    rgb("#94a4d5"),
                    rgb("#b4c0e5"),
                    angle: 270deg,
                ))
            ]
        ],
        footer: context [
            #align(right)[
                #set text(16pt)
                #pad(right: -.5em)[
                    #counter(page).display(
                        "1 / 1",
                        both: true,
                    )
                ]
            ]
        ],
    )

    body
}

#let math_text(text, size: small) = math.text(text, font: (gothic_font_ja, gothic_font), weight: "regular", size: size)

#let math_restate(target_label, size: normal) = context {
    show math.equation: set text(font: math_font, size: size)
    let queried_elements = query(selector(label(target_label)).before(here()))
    if queried_elements.len() == 0 {
        panic("Error: Could not find element <" + str(target_label) + ">.")
    }

    let el = queried_elements.first()
    if el.func() == math.equation {
        let body_content = el.body

        let restatement_text = $(#math_text("再掲"))$
        let ref_text = ref(label(target_label), supplement: none)

        let measured_width = measure(block[#restatement_text]).width

        let restatement_annotation = [
            #place(text(restatement_text, weight: "thin", size: size), left, dx: -measured_width) (#ref_text)
        ]

        math.equation(block: true, body_content, numbering: _ => restatement_annotation)
        counter(math.equation).update(n => n - 1)
    } else {
        panic(
            "Error: <" + str(target_label) + "> is not a math.equation." + " Instead, it is " + el.func().name() + ".",
        )
    }
}

#let no_counted_pages = counter("no_counted_pages")
#let appendix_slide(body) = {
    set page(footer: context [
        #let all_counted_pages_int = counter(page).final().last()
        #let no_counted_pages_int = no_counted_pages.get().at(0)
        #let total_slides = all_counted_pages_int + no_counted_pages_int

        #align(right)[
            #pad(right: -0.5em)[#text(16pt)[#total_slides / #all_counted_pages_int]]
        ]
    ])

    slide[#body]

    counter(page).update(n => n - 1)
    no_counted_pages.step()
}

#let appendix_title_slide() = {
    set page(footer: none, numbering: none)
    slide[
        #align(center + horizon)[
            #text(size: 60pt, weight: "bold")[
                付録
            ]
        ]
    ]
    counter(page).update(n => n - 1)
}
