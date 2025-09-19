#import "/resources/slide_template.typ": *

#show: project.with(
    title_en: [],
    title_ja: [V2X向けマルチバンド連携による \ 通信安定化手法の研究],
    authors: (),
    cite: [],
    date: [],
)

#slide[
    #header[研究背景 - V2X通信]

    - V2X#footnote[V2X: Vehicle-to-Everything (車両とあらゆるものとの通信)]通信
        - 自動車・路側機・歩行者間でのリアルタイム通信を可能にする技術
            - #adv[衝突回避]や#adv[渋滞緩和]につながる

    - V2X通信に用いられる周波数帯
        - Sub-6GHz帯：#dadv[低速]だが#adv[安定]な通信
        - ミリ波帯：#adv[高速]だが#dadv[不安定]な通信
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
        - RSSI#footnote[RSSI: Received Signal Strength Indicator (受信信号強度指標)]・SINR#footnote[SINR: Signal to Interference plus Noise Ratio (信号対干渉雑音比)]などの品質劣化を観測後に制御 #custom_cite(<0001>)
        - #adv[急激な変化に対応可能]
        - 検知から切り替えまでの#dadv[遅延で通信断発生]

    - 事前対応的制御
        - 移動軌跡予測に基づく事前の帯域切り替え #custom_cite(<0003>)
        - 理論上は通信瞬断を#adv[未然に防止]可能
        - 予測精度に性能が#dadv[大きく依存]
]

#slide[
    #header[研究目的]

    - V2X通信における通信安定化手法の提案
        - ミリ波とSub-6GHzの連携による再送および帯域切り替え
            - 通信失敗時にSub-6GHzで再送
            - SINR値による動的な帯域切り替え

    #v(30mm)

    #align(center)[
        #box(
            stroke: 6pt + luma(150),
            width: 85%,
            inset: 32pt,
            radius: 6pt,
        )[
            再送と動的な帯域切り替えによる#adv[高速性]と#adv[安定性]の両立
        ]
    ]
]

#slide[
    #header[シミュレーションモデル]

    - チャネルモデル：UMi Street Canyon モデル #custom_cite(<0007>)
    - 環境設定
        - 送受信車両 $1$ 台ずつ + 一般車両 $35$ 台 + 大型車両 $8$ 台
        - 送受信車両速度： #qty(60, "km/h", per: "\/")、初期距離： #qty(50, "m")
        - 全車両はランダムに車線変更する

    #figure(
        image("images/model.drawio.png", width: 43%),
        caption: [シミュレーションモデルのイメージ],
    )<label>
]

#slide[
    #header[評価指標]

    - 評価指標
        $ "SINR [dB]" = 10 log_(10) (P_"s" / (P_"i" + P_"n")) $
        #align(center)[#text(tiny)[
            $P_"s"$：受信信号電力、$P_"i"$：干渉信号電力、$P_"n"$：ノイズ電力 \
        ]]

    // - シミュレータ：SUMO，Omnet++，Veins
    //     - 交通シミュレーション + 通信品質評価の統合環境
    //         - SUMO: 交通シミュレータ
    //         - Omnet++: ネットワークシミュレータ
    //         - Veins: SUMOとOmnet++の連携フレームワーク
]

#slide[
    #header[提案手法]

    - ミリ波と Sub-6GHzの連携による再送およびバンド切り替え
        - 動的制御切り替えによる#adv[通信品質と効率性の両立]

    - 再送処理
        - ミリ波での通信を基本
        - 送信に失敗したパケットのみSub-6GHzで再送

    - バンド切り替え
        - SINRが閾値未満となった場合に切り替え
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
        - 再送も帯域切り替えも行わない

        - 目的
            - ミリ波とSub-6GHzの特性を確認する
                - ミリ波の#adv[高速性]と#dadv[遮蔽に弱い]ことを確認
                - Sub-6GHzの#adv[安定性]と#adv[遮蔽に強い]ことを確認
            - 帯域切り替えを行うSINR閾値の検討

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
            [ミリ波], [#qty(28, "GHz")帯 (#qty(100, "MHz"))],
            [Sub- #qty(6, "GHz")], [#qty(3.5, "GHz")帯 (#qty(20, "MHz"))],
            table.hline(),
        ),
    )<label>
]

#slide[
    #header[シミュレーション結果 - SINRの比較]

    - ミリ波の不安定性とSub-6GHzの安定性を確認

    #figure(
        image("images/sinr_comprehensive_analysis.png", width: 80%),
        caption: [
            ミリ波とSub-6GHzのSINRのシミュレーション結果の比較 \
            点線：3GPPにおけるSINRの要求水準値
        ],
    )<fig:sinr>
]

#slide[
    #header[シミュレーション結果 - スループットの比較]

    - ミリ波の高速性とSub-6GHzの安定性を確認

    #figure(
        image("images/harq_comprehensive_analysis.png", width: 80%),
        caption: [
            ミリ波とSub-6GHzのスループットのシミュレーション結果の比較 \
            点線：平均スループット値
        ],
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
            - ミリ波の#adv[高速性]と#dadv[遮蔽に弱い]ことを確認
            - Sub-6GHzの#adv[安定性]と#adv[遮蔽に強い]ことを確認

    - 今後の研究方針
        - 送信失敗時のSub-6GHzによる再送の効果検証
        - SINR閾値による帯域切り替えの検証
]

#slide[
    #header[参考文献]
    #set text(size: tiny, font: "Arial")
    #bibliography(
        "main.bib",
        style: "ieee",
        title: none,
    )
]

#appendix_title_slide()

#appendix_slide[
    #header[補足：シミュレーション結果 - スループットの分布]

    #figure(
        image("images/throughput_distribution_shape_analysis.png", width: 90%),
        caption: [ミリ波とSub-6GHzのスループットのシミュレーション結果の比較],
    )<fig:throughput>
]

#appendix_slide[
    #header[補足：UMi Street Canyonモデル]

    - UMi (Urban Micro-cell) Street Canyon チャネルモデル
        - 都市部の道路（峡谷状の環境）を模擬
        - 建物間の狭い道路での電波伝搬特性をモデル化

    - 主な特徴
        - 見通し(LOS)と非見通し(NLOS)の両方をサポート
        - 車両による遮蔽効果を考慮
        - 距離減衰、シャドウイング、高速フェージングを含む
]

#appendix_slide[
    #header[補足：シミュレーションの考慮点]

    - SINR閾値の設定方法
        - 3GPPの要求水準値や初期検討結果を参考に設定
        - ミリ波で安定通信が困難になるSINR値を基準に閾値を決定

    - 車線変更のモデル化
        - ランダムな車線変更を仮定
        - 実際の交通流を考慮したより詳細なモデル化は今後の課題

    - 遅延やオーバーヘッド
        - 帯域切り替えや再送による遅延などを定量的に評価する予定

    - ドローン通信への適用性
        - 3次元移動や高度変化による伝搬特性の違いを考慮する必要がある
]

#appendix_slide[
    #header[補足：今後の展開]

    - 他の周波数帯との組み合わせ
        - より高速で安定化が期待できる場合は検討
        - ミリ波とSub-6GHzの組み合わせでの性能向上の確認を優先

    - 今後の実験計画
        - シミュレーション評価の拡張
        - ミリ波通信を基本としつつSub-6GHzによる再送の実装
        - SINR閾値の決定とバンド切り替えの実装・評価
]

#appendix_slide[
    #header[補足：シミュレーション環境詳細]
    #set text(size: small)

    - *SUMO* (Simulation of Urban MObility)
        - 交通流シミュレータ
        - 車両の移動軌跡、車線変更、速度制御を模擬

    - *OMNeT++*
        - ネットワークシミュレーションフレームワーク
        - 通信プロトコル、電波伝搬、パケット伝送を模擬

    - *Veins* (Vehicles in Network Simulation)
        - SUMOとOMNeT++を連携するフレームワーク
        - V2X通信シミュレーション専用に設計

    #figure(
        caption: [シミュレータ連携構成],
        table(
            columns: 3,
            table.hline(),
            [ツール], table.vline(), [役割], table.vline(), [主な機能],
            table.hline(),
            [SUMO], [交通流], [車両移動、車線変更],
            [OMNeT++], [通信], [電波伝搬、プロトコル],
            [Veins], [統合], [SUMO-OMNeT++連携],
            table.hline(),
        ),
    )
]

#appendix_slide[
    #header[補足：本研究の新規性]

    - 従来手法の限界
        - 事後対応的手法：品質劣化検知後の切り替え → 遅延発生
        - 事前対応的手法：予測に依存 → 予測誤差で性能劣化
        - 既存ハイブリッド：LiDARや機械学習に依存 → 実装困難

    - 本研究の新規性
        1. 2つの手法の統合
            - 失敗パケットのみSub-6GHzで再送
            - SINR閾値による事前切り替え

        2. 状況適応型制御
            - 短時間遮蔽 → ミリ波継続＋失敗パケット再送
            - 長時間遮蔽 → 事前にSub-6GHzへ切り替え

        3. 実装の容易さ
            - SINR閾値によるシンプルな判定
            - 特別なセンサーや複雑な予測不要
]
