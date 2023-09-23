### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# ╔═╡ 644037fa-2f64-441c-abe3-d145f63e9602
begin
	using Dates
	using JSON
end

# ╔═╡ d6cc3a7d-6cad-4ff5-b601-4209a494abbe
struct Review
    datetime::DateTime
    grade::String
end

# ╔═╡ 7b014fda-366f-11ee-2ab1-c95a638d2b04
struct Card
    spelling::String
    reading::String
    reviews::Vector{Review}
end

# ╔═╡ 62ec0354-5560-4470-b4c2-640e241dee7e
function localize(date)
    return date + Hour(8)
end

# ╔═╡ 346747a9-9940-4955-aa2f-be3cfa38d04f
function parse_review(review)
    datetime = (localize ∘ unix2datetime)(review["timestamp"])
    grade = review["grade"]
    return Review(datetime, grade)
end

# ╔═╡ 032c0df7-c6a4-4b64-baec-ed4c9443d716
function parse_reviews(reviews)
    return map(review -> parse_review(review), reviews)
end

# ╔═╡ 67fe9c8b-75fb-41d7-a416-3084ef583e66
function parse_card(card)
    spelling = card["spelling"]
    reading = card["reading"]
    reviews = parse_reviews(card["reviews"])
    return Card(spelling, reading, reviews)
end

# ╔═╡ 233c4b66-1591-492e-af33-c0d359e295bd
function parse_cards(cards)
    return map(card -> parse_card(card), cards)
end

# ╔═╡ 05b93b07-68d5-459e-b1c7-b51174139610
cards_url = "https://raw.githubusercontent.com/daryll-ko/JPDBStats.jl/main/reviews.json"

# ╔═╡ 66ba483a-f5f1-4666-ae27-dd53941c42cc
cards_filename = download(cards_url)

# ╔═╡ 347bcddd-6ffc-45b2-baea-89361ddae480
cards = open(cards_filename, "r") do f
	read(f, String) |>
	JSON.parse |>
	(json -> json["cards_vocabulary_jp_en"]) |>
	parse_cards
end

# ╔═╡ d49abd42-c93e-43ab-bb41-c73eef330854
length(cards)

# ╔═╡ 862cc331-99ef-4e3d-8b4a-88428b26b0bb
function get_kanji_counter(cards)
    kanji_counter = Dict{String,Int}()
    kanji_regex = r"[一-龯]"
    for card in cards
        matches = unique(
            map(
                regex_match -> regex_match.match,
                collect(eachmatch(kanji_regex, card.spelling)),
            ),
        )
        for match in matches
            kanji_counter[match] = get(kanji_counter, match, 0) + 1
        end
    end
    return kanji_counter
end

# ╔═╡ 8fcba01a-d700-46fc-a308-cf5c5e4db9c8
kanji_counter = get_kanji_counter(cards)

# ╔═╡ 7117465f-4b30-4d80-8389-f4593d1045e2
length(kanji_counter)

# ╔═╡ 3510cbf5-eb56-4ff3-b38b-e5a5f31180df
my_kanji_list = collect(keys(kanji_counter))

# ╔═╡ 5c765e9f-799f-459d-9431-a97a8ac724c3
length(my_kanji_list)

# ╔═╡ f4c3feef-d7ea-4fd5-8831-ec6950f566dd
jouyou_kanji_string = "亜哀挨愛曖悪握圧扱宛嵐安案暗以衣位囲医依委威為畏胃尉異移萎偉椅彙意違維慰遺緯域育一壱逸茨芋引印因咽姻員院淫陰飲隠韻右宇羽雨唄鬱畝浦運雲永泳英映栄営詠影鋭衛易疫益液駅悦越謁閲円延沿炎怨宴媛援園煙猿遠鉛塩演縁艶汚王凹央応往押旺欧殴桜翁奥横岡屋億憶臆虞乙俺卸音恩温穏下化火加可仮何花佳価果河苛科架夏家荷華菓貨渦過嫁暇禍靴寡歌箇稼課蚊牙瓦我画芽賀雅餓介回灰会快戒改怪拐悔海界皆械絵開階塊楷解潰壊懐諧貝外劾害崖涯街慨蓋該概骸垣柿各角拡革格核殻郭覚較隔閣確獲嚇穫学岳楽額顎掛潟括活喝渇割葛滑褐轄且株釜鎌刈干刊甘汗缶完肝官冠巻看陥乾勘患貫寒喚堪換敢棺款間閑勧寛幹感漢慣管関歓監緩憾還館環簡観韓艦鑑丸含岸岩玩眼頑顔願企伎危机気岐希忌汽奇祈季紀軌既記起飢鬼帰基寄規亀喜幾揮期棋貴棄毀旗器畿輝機騎技宜偽欺義疑儀戯擬犠議菊吉喫詰却客脚逆虐九久及弓丘旧休吸朽臼求究泣急級糾宮救球給嗅窮牛去巨居拒拠挙虚許距魚御漁凶共叫狂京享供協況峡挟狭恐恭胸脅強教郷境橋矯鏡競響驚仰暁業凝曲局極玉巾斤均近金菌勤琴筋僅禁緊錦謹襟吟銀区句苦駆具惧愚空偶遇隅串屈掘窟熊繰君訓勲薫軍郡群兄刑形系径茎係型契計恵啓掲渓経蛍敬景軽傾携継詣慶憬稽憩警鶏芸迎鯨隙劇撃激桁欠穴血決結傑潔月犬件見券肩建研県倹兼剣拳軒健険圏堅検嫌献絹遣権憲賢謙鍵繭顕験懸元幻玄言弦限原現舷減源厳己戸古呼固股虎孤弧故枯個庫湖雇誇鼓錮顧五互午呉後娯悟碁語誤護口工公勾孔功巧広甲交光向后好江考行坑孝抗攻更効幸拘肯侯厚恒洪皇紅荒郊香候校耕航貢降高康控梗黄喉慌港硬絞項溝鉱構綱酵稿興衡鋼講購乞号合拷剛傲豪克告谷刻国黒穀酷獄骨駒込頃今困昆恨根婚混痕紺魂墾懇左佐沙査砂唆差詐鎖座挫才再災妻采砕宰栽彩採済祭斎細菜最裁債催塞歳載際埼在材剤財罪崎作削昨柵索策酢搾錯咲冊札刷刹拶殺察撮擦雑皿三山参桟蚕惨産傘散算酸賛残斬暫士子支止氏仕史司四市矢旨死糸至伺志私使刺始姉枝祉肢姿思指施師恣紙脂視紫詞歯嗣試詩資飼誌雌摯賜諮示字寺次耳自似児事侍治持時滋慈辞磁餌璽鹿式識軸七叱失室疾執湿嫉漆質実芝写社車舎者射捨赦斜煮遮謝邪蛇尺借酌釈爵若弱寂手主守朱取狩首殊珠酒腫種趣寿受呪授需儒樹収囚州舟秀周宗拾秋臭修袖終羞習週就衆集愁酬醜蹴襲十汁充住柔重従渋銃獣縦叔祝宿淑粛縮塾熟出述術俊春瞬旬巡盾准殉純循順準潤遵処初所書庶暑署緒諸女如助序叙徐除小升少召匠床抄肖尚招承昇松沼昭宵将消症祥称笑唱商渉章紹訟勝掌晶焼焦硝粧詔証象傷奨照詳彰障憧衝賞償礁鐘上丈冗条状乗城浄剰常情場畳蒸縄壌嬢錠譲醸色拭食植殖飾触嘱織職辱尻心申伸臣芯身辛侵信津神唇娠振浸真針深紳進森診寝慎新審震薪親人刃仁尽迅甚陣尋腎須図水吹垂炊帥粋衰推酔遂睡穂随髄枢崇数据杉裾寸瀬是井世正生成西声制姓征性青斉政星牲省凄逝清盛婿晴勢聖誠精製誓静請整醒税夕斥石赤昔析席脊隻惜戚責跡積績籍切折拙窃接設雪摂節説舌絶千川仙占先宣専泉浅洗染扇栓旋船戦煎羨腺詮践箋銭潜線遷選薦繊鮮全前善然禅漸膳繕狙阻祖租素措粗組疎訴塑遡礎双壮早争走奏相荘草送倉捜挿桑巣掃曹曽爽窓創喪痩葬装僧想層総遭槽踪操燥霜騒藻造像増憎蔵贈臓即束足促則息捉速側測俗族属賊続卒率存村孫尊損遜他多汰打妥唾堕惰駄太対体耐待怠胎退帯泰堆袋逮替貸隊滞態戴大代台第題滝宅択沢卓拓託濯諾濁但達脱奪棚誰丹旦担単炭胆探淡短嘆端綻誕鍛団男段断弾暖談壇地池知値恥致遅痴稚置緻竹畜逐蓄築秩窒茶着嫡中仲虫沖宙忠抽注昼柱衷酎鋳駐著貯丁弔庁兆町長挑帳張彫眺釣頂鳥朝貼超腸跳徴嘲潮澄調聴懲直勅捗沈珍朕陳賃鎮追椎墜通痛塚漬坪爪鶴低呈廷弟定底抵邸亭貞帝訂庭逓停偵堤提程艇締諦泥的笛摘滴適敵溺迭哲鉄徹撤天典店点展添転填田伝殿電斗吐妬徒途都渡塗賭土奴努度怒刀冬灯当投豆東到逃倒凍唐島桃討透党悼盗陶塔搭棟湯痘登答等筒統稲踏糖頭謄藤闘騰同洞胴動堂童道働銅導瞳峠匿特得督徳篤毒独読栃凸突届屯豚頓貪鈍曇丼那奈内梨謎鍋南軟難二尼弐匂肉虹日入乳尿任妊忍認寧熱年念捻粘燃悩納能脳農濃把波派破覇馬婆罵拝杯背肺俳配排敗廃輩売倍梅培陪媒買賠白伯拍泊迫剥舶博薄麦漠縛爆箱箸畑肌八鉢発髪伐抜罰閥反半氾犯帆汎伴判坂阪板版班畔般販斑飯搬煩頒範繁藩晩番蛮盤比皮妃否批彼披肥非卑飛疲秘被悲扉費碑罷避尾眉美備微鼻膝肘匹必泌筆姫百氷表俵票評漂標苗秒病描猫品浜貧賓頻敏瓶不夫父付布扶府怖阜附訃負赴浮婦符富普腐敷膚賦譜侮武部舞封風伏服副幅復福腹複覆払沸仏物粉紛雰噴墳憤奮分文聞丙平兵併並柄陛閉塀幣弊蔽餅米壁璧癖別蔑片辺返変偏遍編弁便勉歩保哺捕補舗母募墓慕暮簿方包芳邦奉宝抱放法泡胞俸倣峰砲崩訪報蜂豊飽褒縫亡乏忙坊妨忘防房肪某冒剖紡望傍帽棒貿貌暴膨謀頬北木朴牧睦僕墨撲没勃堀本奔翻凡盆麻摩磨魔毎妹枚昧埋幕膜枕又末抹万満慢漫未味魅岬密蜜脈妙民眠矛務無夢霧娘名命明迷冥盟銘鳴滅免面綿麺茂模毛妄盲耗猛網目黙門紋問冶夜野弥厄役約訳薬躍闇由油喩愉諭輸癒唯友有勇幽悠郵湧猶裕遊雄誘憂融優与予余誉預幼用羊妖洋要容庸揚揺葉陽溶腰様瘍踊窯養擁謡曜抑沃浴欲翌翼拉裸羅来雷頼絡落酪辣乱卵覧濫藍欄吏利里理痢裏履璃離陸立律慄略柳流留竜粒隆硫侶旅虜慮了両良料涼猟陵量僚領寮療瞭糧力緑林厘倫輪隣臨瑠涙累塁類令礼冷励戻例鈴零霊隷齢麗暦歴列劣烈裂恋連廉練錬呂炉賂路露老労弄郎朗浪廊楼漏籠六録麓論和話賄脇惑枠湾腕"

# ╔═╡ fe7510dc-c8ed-41be-864e-39e37d2ed222
length(jouyou_kanji_string)

# ╔═╡ 4b6c6c67-42cf-4d5e-ae11-0a9723f7a1ff
jouyou_kanji_list = string.(collect(jouyou_kanji_string))

# ╔═╡ d4c53d7e-8813-4ba1-bfb0-9d179ad0b71e
length(jouyou_kanji_list)

# ╔═╡ fe123bec-051a-4189-9116-16c89ce583a9
jouyou_kanji_known = my_kanji_list ∩ jouyou_kanji_list

# ╔═╡ f93b75a0-26e8-4b89-9c72-358d0412d7ca
length(jouyou_kanji_known)

# ╔═╡ 4fa3d354-bec3-47bf-a102-602482d528c8
length(jouyou_kanji_known) / length(jouyou_kanji_list)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Dates = "ade2ca70-3891-5945-98fb-dc099432e06a"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"

[compat]
JSON = "~0.21.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.3"
manifest_format = "2.0"
project_hash = "92e5efaf4eb324d929cb42e9a20b5734b00b06f9"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "716e24b21538abc91f6205fd1d8363f39b442851"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.7.2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "9673d39decc5feece56ef3940e5dafba15ba0f81"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.1.2"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "7eb1686b4f04b82f96ed7a4ea5890a4f0c7a09f1"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═644037fa-2f64-441c-abe3-d145f63e9602
# ╠═d6cc3a7d-6cad-4ff5-b601-4209a494abbe
# ╠═7b014fda-366f-11ee-2ab1-c95a638d2b04
# ╠═62ec0354-5560-4470-b4c2-640e241dee7e
# ╠═346747a9-9940-4955-aa2f-be3cfa38d04f
# ╠═032c0df7-c6a4-4b64-baec-ed4c9443d716
# ╠═67fe9c8b-75fb-41d7-a416-3084ef583e66
# ╠═233c4b66-1591-492e-af33-c0d359e295bd
# ╠═05b93b07-68d5-459e-b1c7-b51174139610
# ╠═66ba483a-f5f1-4666-ae27-dd53941c42cc
# ╠═347bcddd-6ffc-45b2-baea-89361ddae480
# ╠═d49abd42-c93e-43ab-bb41-c73eef330854
# ╠═862cc331-99ef-4e3d-8b4a-88428b26b0bb
# ╠═8fcba01a-d700-46fc-a308-cf5c5e4db9c8
# ╠═7117465f-4b30-4d80-8389-f4593d1045e2
# ╠═3510cbf5-eb56-4ff3-b38b-e5a5f31180df
# ╠═5c765e9f-799f-459d-9431-a97a8ac724c3
# ╟─f4c3feef-d7ea-4fd5-8831-ec6950f566dd
# ╠═fe7510dc-c8ed-41be-864e-39e37d2ed222
# ╠═4b6c6c67-42cf-4d5e-ae11-0a9723f7a1ff
# ╠═d4c53d7e-8813-4ba1-bfb0-9d179ad0b71e
# ╠═fe123bec-051a-4189-9116-16c89ce583a9
# ╠═f93b75a0-26e8-4b89-9c72-358d0412d7ca
# ╠═4fa3d354-bec3-47bf-a102-602482d528c8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
