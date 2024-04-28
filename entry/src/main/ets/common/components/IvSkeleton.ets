

@Component
export struct IvSkeleton {
  widthValue: number | string = 100
  heightValue: number | string = 20
  @State
  translateValue: string = '-100%'

  build() {
    Stack() {
      Text() // 骨架样式
        .backgroundColor($r('app.color.common_gray_bg'))
        .height('100%')
        .width('100%')
      Text()  // 骨架上的闪光特效
        .linearGradient({
          angle: 90,
          colors: [
            ['rgba(255,255,255,0)', 0], // 0%的位置透明
            ['rgba(255,255,255,0.5)', 0.5], // 50%的位置透明度不透明，则translate在移动此Text的时候会看到闪光
            ['rgba(255,255,255,0)', 1] // 100%的位置透明
          ]
        })
        .height('100%')
        .width('100%')
        .translate({
          x: this.translateValue, // 设置Text的初始位置
        })
        .animation({
          duration: 1500,  // 动画时间为1.5秒
          iterations: -1 // -1表示设置重复动画
        })
    }
    .height(this.heightValue)
    .width(this.widthValue)
    .borderRadius((4))
    .clip(true)
    .onAppear(() => {
      this.translateValue = '100%' //设置Text组件挂载后的结束位置
    })
  }
}