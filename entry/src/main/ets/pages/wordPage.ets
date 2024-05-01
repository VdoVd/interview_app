import { promptAction, window } from '@kit.ArkUI'
import util from '@ohos.util'
import { webview } from '@kit.ArkWeb'
import { WordSoundDialog } from '../views/word/WordSoundDialog'

export interface WordItem {
  zh: string
  en: string
  code: string
}
export interface Words {
  en: string;
  zh: string;
  down: number;
  code: string;
}
@CustomDialog
struct CustomDialogExample {
  controller: CustomDialogController
  build() {
    Column() {
      Text('我是内容')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
    }
  }
}

@Entry
@Component
export struct WordPage {

  @StorageProp('topHeight') topHeight: number = 0
  @State
  showTypeSheet: boolean = false // 控制当前阶段分类弹框
  @State
  showCodeSheet: boolean = false // 控制当前单词详细代码弹框
  @State
  activeIndex: number = 0 // 当前阶段索引
  @State
  loading: boolean = false

  onPageShow(): void {
    const resourceMgr = getContext().resourceManager
    let uint8Array = resourceMgr.getRawFileContentSync('word.json')
    const textDecoder = new util.TextDecoder()
    const workJsonstr = textDecoder.decodeWithStream(uint8Array)
    this.words = JSON.parse(workJsonstr) as Record<string, WordItem[]>
    window.getLastWindow(getContext()).then(win => {
      let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      win.setWindowLayoutFullScreen(true)  // true：设置全屏
      win.setWindowSystemBarProperties({statusBarContentColor:'#FFFFFF'}) // 白色

      let h = area.topRect.height  // 获取安全区域高度，单位px
      let hvp = px2vp(h)  // 将px单位转换成vp单位
      console.log(`hvp:${hvp}`)
      AppStorage.setOrCreate('topHeight',hvp)  // 将高度保存到AppStorage中共享给其他页面使用
    })
  }
  // word
  @State
  words: Record<string, WordItem[]> = {
    'HTML5': [
      {
        "en": "strong",
        "zh": "加粗标签",
        "code": "<strong>加粗内容</strong>"
      }
    ],
    'CSS3': [
      {
        "en": "color",
        "zh": "字体颜色",
        "code": "color: red;"
      },
      {
        "en": "color",
        "zh": "字体颜色",
        "code": "color: red;"
      }
    ]
  }
  webviewCtrl:webview.WebviewController=new webview.WebviewController()
  @State
  currentCode: string = ''
  @State
  currentWordEn: string = ''
  @State
  currentWordZh: string = ''
  scroller = new Scroller()

  aboutToAppear(): void {
    this.loadWord()
  }

  // 读取当前项目中的rawfile文件夹中的word.json文件中的内容赋值给this.words
  async loadWord() {
    //  1. 定义上下文Resource操作对象
    let mgr = getContext().resourceManager
    let arr = mgr.getRawFileContentSync('word.json')

    //   2. 将arr这个数组转成字符串
    let textDecoder = new util.TextDecoder()
    let wordJsonStr = textDecoder.decodeWithStream(arr)

    //   3. 将字符串转成对象后赋值给当前页面的状态属性words
    this.words = JSON.parse(wordJsonStr)
  }

  // 单词分类弹窗
  @Builder
  typeSheetBuilder() {
    Column() {

      Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
        ForEach(Object.keys(this.words), (key: string, index) => {
          Button() {
            Text(key)
              .fontSize(14)
              .fontColor(index === this.activeIndex ? $r('app.color.common_green') : $r('app.color.common_gray_01'))
          }
          .backgroundColor($r('app.color.common_gray_bg'))
          .padding({ top: 6, right: 12, bottom: 6, left: 12 })
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            this.activeIndex = index
            this.showTypeSheet = false
            this.scroller.scrollTo({ yOffset: 0, xOffset: 0 })
          })
        })
      }
    }
    .padding({ left: 16, right: 16, top: 8, bottom: 34 })
  }

  // 弹出单词用法弹窗
  @Builder
  codeSheetBuilder() {
    Row(){
      Web({
        src:$rawfile('word.html'),
        controller:this.webviewCtrl
      })
        .onPageEnd(()=>{
          this.webviewCtrl.runJavaScript(`writeCode(\`${this.currentCode}\`)`)
        })
    }.height('100%')
    .width('100%')
    .padding({left:16,right:16,top:18,bottom:34})
  }
  dialogController: CustomDialogController = new CustomDialogController({
    builder:WordSoundDialog({wordEn:this.currentWordEn,wordZh:this.currentWordEn})
  })
  build() {
    Navigation() {
      Column() {
        Row() {
          Column({ space: 4 }) {
            Text('开发常用词汇')
            Text(`共 ${this.words[Object.keys(this.words)[this.activeIndex]]?.length} 个单词`)
              .fontSize(12)
              .fontColor($r('app.color.common_gray_03'))
          }
          .alignItems(HorizontalAlign.Start)

          Row() {
            Text(Object.keys(this.words)[this.activeIndex])
              .fontSize(12)
              .fontColor($r('app.color.common_gray_01'))
            Image($r('sys.media.ohos_ic_public_arrow_down'))
              .width(16)
              .aspectRatio(1)
              .fillColor($r('app.color.common_gray_01'))
          }
          .onClick(() => this.showTypeSheet = true)
          .bindSheet($$this.showTypeSheet, this.typeSheetBuilder(), {
            height: 200,
            title: { title: '选择分类' }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(16)
        .border({ width: { top: $r('app.float.common_border_width') }, color: $r('app.color.common_gray_bg') })

        Divider()
          .strokeWidth(8)
          .color($r('app.color.common_gray_bg'))

        List({ scroller: this.scroller }) {
          ForEach(this.words[Object.keys(this.words)[this.activeIndex]], (wordItem: WordItem) => {

            ListItem() {
              Row({ space: 6 }) {
                Image($r('sys.media.ohos_ic_public_sound'))
                  .width(20)
                  .aspectRatio(1)
                  .alignSelf(ItemAlign.Start)
                  .fillColor($r('app.color.common_gray_03'))
                  .onClick(() => {
                    // 开启弹框读单词
                    this.currentWordEn = wordItem.en
                    this.currentWordZh = wordItem.zh
                    this.dialogController.open()

                  })
                Column({ space: 10 }) {
                  Text(wordItem.en)
                    .fontWeight(FontWeight.Bold)
                  Text(wordItem.zh)
                    .fontSize(14)
                    .fontColor($r('app.color.common_gray_03'))
                }
                .alignItems(HorizontalAlign.Start)
                .layoutWeight(1)

                Column({ space: 10 }) {
                  // 读音评测
                  Row() {
                    Text('读音评测')
                      .fontSize(12)
                      .fontColor($r('app.color.common_gray_01'))

                  }
                  .onClick(() => {

                  })

                  Row() {
                    Text('详细代码')
                      .fontSize(12)
                      .fontColor(wordItem.code ? $r('app.color.common_gray_01') : '#dddddd')
                    Image($r('sys.media.ohos_ic_public_arrow_right'))
                      .width(16)
                      .aspectRatio(1)
                      .fillColor(wordItem.code ? $r('app.color.common_gray_01') : '#dddddd')
                  }
                  // .alignSelf(ItemAlign.End)
                  .onClick(() => {
                    this.currentCode = wordItem.code
                    if (this.currentCode) {
                      this.showCodeSheet = true
                    } else {
                      promptAction.showToast({ message: '暂无代码' })
                    }
                  })
                }
              }
              .padding(16)
            }
          })
        }
        .divider({
          strokeWidth: $r('app.float.common_border_width'),
          color: $r('app.color.common_gray_bg')
        })
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .bindSheet($$this.showCodeSheet, this.codeSheetBuilder, {
        height: 500,
        title: { title: '详细代码' }
      })
    }
    .title('常用单词')
    .titleMode(NavigationTitleMode.Mini)
    .padding({ top: this.topHeight })
    .onAppear(()=>{
      console.log(`top:${this.topHeight}`)
    })
  }
}