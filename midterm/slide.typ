#import "/resources/slide_template.typ": *

#show: project.with(
    title_en: [],
    title_ja: [V2X向けマルチバンド連携による \ 通信安定化手法の研究],
    authors: (),
    cite: [],
    date: [2025/09/30],
)

#slide[
    #header[研究背景 - V2X通信]

    - V2X#footnote[V2X: Vehicle-to-Everything (車両とあらゆるものとの通信)]通信
        - 自動車・路側機・歩行者間でのリアルタイム通信を可能にする技術
            - #adv[衝突回避]や#adv[渋滞緩和]につながる

    - ミリ波とSub-6GHzの特性
    #figure(
        caption: [ミリ波とSub-6GHzの特性比較],
        table(
            columns: 3,
            table.hline(),
            [], table.vline(), [ミリ波], [Sub-6GHz],
            table.hline(),
            [スループット], [#adv[高い]], [#dadv[低い]],
            [遮蔽影響], [#dadv[大きい]], [#adv[小さい]],
            [品質変動], [#dadv[高変動]], [#adv[安定]],
            table.hline(),
        ),
    )
]

#slide[
    #header[既存研究]

    - 事後対応的制御
        - RSSI#footnote[RSSI: Received Signal Strength Indicator (受信信号強度指標)]・SINR#footnote[SINR: Signal to Interference plus Noise Ratio (信号対干渉雑音比)]などの品質劣化を観測後に制御
        - #adv[予測不能な変化に対応可能]
        - 検知から切り替えまでの#dadv[遅延で通信断発生]

    - 事前対応的制御
        - 移動軌跡予測に基づく事前のバンド切り替え
        - 理論上は通信瞬断を#adv[未然に防止]
        - 予測精度に性能が#dadv[大きく依存]
]

#slide[
    #header[シミュレーションモデル]

    - チャネルモデル：3GPP TS 38.901 UMi Street Canyon
    - 環境設定
        - 道路長 $L = #qty(2000, "m", thousandsep: "#h(0.1em)")$
        - 送受信車両1台ずつ + 一般車両35台 + 大型車両8台
        - 送受信車両速度： #qty(60, "km/h", per: "\/")、初期距離： #qty(50, "m")
        - 車両はランダムに車線変更する
    - 通信パラメータ
        - ミリ波：#qty(28, "GHz")帯（帯域幅 #qty(100, "MHz")）
        - Sub-6GHz：#qty(3.5, "GHz")帯（帯域幅 #qty(20, "MHz")）

    #figure(
        image("images/model.drawio.png", width: 40%),
        caption: [シミュレーションモデル],
    )<label>
]

#slide[
    #header[シミュレーション条件と評価手法]

    - 評価指標と計算式
        $ "SINR [dB]" = 10 log_(10) (P_"s" / (P_"i" + P_"n")) $
        $ "Throughput [bps]" = B_"Rx" / T $
        #align(center)[#text(tiny)[
            $P_"s"$：受信信号電力、$P_"i"$：干渉信号電力、$P_"n"$：ノイズ電力 \
            $B_"Rx"$：受信成功ビット数、$T$：観測時間
        ]]

    - シミュレータ：SUMO，Omnet++，Veins
        - 交通シミュレーション + 通信品質評価の統合環境
            - SUMO: 交通シミュレータ
            - Omnet++: ネットワークシミュレータ
            - Veins: SUMOとOmnet++の連携フレームワーク
]

#slide[
    #header[提案手法]

    - ミリ波と Sub-6GHzの連携による再送およびバンド切り替え
        - 動的制御切り替えによる#adv[通信品質と効率性の両立]

    - 再送処理
        - ミリ波での通信を基本
        - 送信に失敗したパケットのみSub-6GHzで再送

    - バンド切り替え
        - SINRが閾値となった場合に切り替え
        - より遮蔽が強い場合に切り替え

    #align(center)[
        #box(
            stroke: 3pt + luma(150),
            width: 85%,
            inset: 15pt,
            radius: 6pt,
        )[
            状況適応型制御により#adv[高速性]と#adv[安定性]を両立
        ]
    ]
]

#slide[
    #header[初期検討]

    - 単一の帯域のみでの通信をシミュレーション
        - 再送もバンド切り替えも行わない

        - 目的
            - ミリ波とSub-6GHzの特性を確認する
                - ミリ波の#adv[高速通信の優位性]と#dadv[遮蔽に弱い]ことを確認
                - Sub-6GHzの#adv[安定性の優位性]と#adv[遮蔽に強い]ことを確認
            - バンド切り替えを行うSINR閾値の検討

    #v(20mm)

    #align(center)[
        #box(
            stroke: 3pt + luma(150),
            width: 85%,
            inset: 15pt,
            radius: 6pt,
        )[
            本研究の基礎データを取得して提案手法の#adv[有効性を検証]
        ]
    ]
]

#slide[
    #header[シミュレーション諸元]

    #figure(
        caption: [シミュレーション諸元],
        table(
            columns: 2,
            table.hline(),
            [パラメータ], table.vline(), [値],
            table.hline(),
            [シミュレーション時間], [#qty(60, "s")],
            [道路長 $L$], [#qty(2, "km", thousandsep: "#h(0.1em)")],
            [車線幅], [#qty(3.5, "m")],
            [車線数], [$3$],
            [初期送受信車両間距離], [#qty(50, "m")],
            [送受信車両速度], [#qty(60, "km/h", per: "\/")],
            [一般車両数], [$35$ 台],
            [大型車両数], [$8$ 台],
            [一般車両速度], [$40$ -- #qty(60, "km/h", per: "\/")],
            [大型車両速度], [$40$ -- #qty(50, "km/h", per: "\/")],
            [#qty(28, "GHz")帯域幅], [#qty(100, "MHz")],
            [#qty(3.5, "GHz")帯域幅], [#qty(20, "MHz")],
            table.hline(),
        ),
    )<label>
]

#slide[
    #header[シミュレーション結果 - SINRの比較]

    #figure(
        image("images/sinr_comprehensive_analysis.png", width: 80%),
        caption: [ミリ波とSub-6GHzのSINRのシミュレーション結果の比較],
    )<fig:sinr>
]

#slide[
    #header[シミュレーション結果 - スループットの比較]

    #figure(
        image("images/harq_comprehensive_analysis.png", width: 80%),
        caption: [ミリ波とSub-6GHzのスループットのシミュレーション結果の比較],
    )<fig:throughput>
]

#slide[
    #header[まとめ・今後の研究方針]

    - 目的
        - V2X通信における通信安定化手法の提案

    - 提案手法
        - ミリ波とSub-6GHzの連携による再送およびバンド切り替え

    - 初期検討シミュレーション結果
        - 単一の帯域のみでの通信をシミュレーション
            - ミリ波の#adv[高速通信]の優位性と#dadv[遮蔽に弱い]ことを確認
            - Sub-6GHzの#adv[安定性]の優位性と#adv[遮蔽に強い]ことを確認

    - 今後の研究方針
        - 送信失敗時のSub-6GHzによる再送の効果検証
        - SINR閾値によるバンド切り替えの検証
]

#appendix_title_slide()

#appendix_slide[
    #header[補足：シミュレーション結果 - スループットの分布]

    #figure(
        image("images/throughput_distribution_shape_analysis.png", width: 80%),
        caption: [ミリ波とSub-6GHzのスループットのシミュレーション結果の比較],
    )<fig:throughput>
]
