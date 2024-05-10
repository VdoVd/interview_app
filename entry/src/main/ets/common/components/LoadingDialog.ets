import emitter from '@ohos.events.emitter'

@CustomDialog
export struct LoadingDialog {
  @State
  message: string = ''
  controller: CustomDialogController  // 是调用的时候自动传入的，可以调用它的close方法来关闭自己

  aboutToAppear(): void {
    console.log('is loading................................')
    //  页面加载就注册emmiter的on事件
    emitter.on({eventId:0},(receiveData)=>{
      // receiveData格式:{data:{msg:'完成'}}
      this.message = receiveData.data!['msg'] as string
      console.log(`${this.message}`)
      // AlertDialog.show({message:JSON.stringify(receiveData)})
    })
  }

  aboutToDisappear(): void {
    // 关闭loading组件时，销毁事件
    emitter.off(0)
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      LoadingProgress().width(30).height(30).color('#fff')
      if (this.message) {
        Text(this.message).fontSize((14)).fontColor('#fff')
      }
    }
    .width(150)
    .height(50)
    .padding(10)
    .backgroundColor('rgba(0,0,0,0.5)')
    .borderRadius(8)
  }
}