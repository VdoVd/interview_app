import { media } from '@kit.MediaKit'
import { request } from '@kit.BasicServicesKit'
import fs from '@ohos.file.fs'
import { Logger } from '../../common/utils/Logger'
import { window } from '@kit.ArkUI'


@CustomDialog
export struct WordSoundDialog {
  controller: CustomDialogController
  @Link wordEn: string
  @Link wordZh: string
  @State
  isGreen: boolean = false
  timer: number = -1
  streamId: number = -1

  avplayer: media.AVPlayer = Object()

  aboutToAppear() {
    console.log(`en:${this.wordEn}`)
    console.log(`zn:${this.wordZh}`)
    this.playMp3('http://dict.youdao.com/dictvoice?audio=' + this.wordEn + '&type=1')
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

  aboutToDisappear(): void {
    //   4. 停止播放
    this.avplayer.stop()

  }

  async playMp3(url: string) {
    //  1. 创建了AVplayer对象实例
    const avPlayer = await media.createAVPlayer()
    this.avplayer = avPlayer
    // 2. 监听avPlayer的状态改变
    avPlayer.on("stateChange", (state) => {
      if (state === "initialized") {
        //   表示avPlayer已经设置了播放源
        console.log('init')
        avPlayer.prepare()
      }

      if (state === "prepared") {
        //  表示avPlayer已经进入了准备播放状态，此时就可以通知播放了
        // 设置avPlayer循环播放音频
        avPlayer.loop = true
        console.log('play')
        avPlayer.play()
      }
    })
    console.log('set play')
    //   3. 设置播放源
    avPlayer.url = url
    console.log('after set play')
  }


  build() {
    Column({ space: 10 }) {
      Row({ space: 10 }) {
        Text(this.wordEn)
          .fontSize(20)
          .fontColor(Color.White)
          .fontWeight(500)
        Image($r('app.media.icon_public_search'))
          .width(20)
          .aspectRatio(1)
          .fillColor(this.isGreen ? $r('app.color.common_green') : Color.White)
          .onAppear(() => {
            clearInterval(this.timer)
            this.timer = setInterval(() => {
              this.isGreen = !this.isGreen
            }, 500)
          })
          .onDisAppear(() => {
            clearInterval(this.timer)
            this.avplayer.stop()
          })
          .animation({ duration: 300 })
      }

      Text(this.wordZh)
        .fontColor(Color.White)
    }
    .constraintSize({ minWidth: 175 })
    .padding({ left: 16, right: 16 })
    .height(90)
    .borderRadius(45)
    .backgroundColor('#8f000000')
    .justifyContent(FlexAlign.Center)
  }
}