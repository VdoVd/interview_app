import { promptAction, window } from '@kit.ArkUI'
import { authStore, HdUser, InfoUser, ProfileUser } from '../common/utils/Auth'
import { picker } from '@kit.CoreFileKit'
import fs from '@ohos.file.fs';
import { emitter, request } from '@kit.BasicServicesKit';
import { Logger } from '../common/utils/Logger';
import { allResponse, getUserInfoGetMethod, updateUserAvatarNickName } from '../common/utils/myReq';
import { LoadingDialog } from '../common/components/LoadingDialog';

let user=authStore.getUser()

@Entry
@Component
struct ProfileEditPage {

  @State user:HdUser=authStore.getUser()
  @State message: string = '完成0%'
  dialog: CustomDialogController = new CustomDialogController({
    builder: LoadingDialog({ message: this.message }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })

  async onPageShow(): Promise<void> {
    console.info('user before')
    this.RefreshUserData()
    console.info(`user:${JSON.stringify(this.user)}`)
    console.info('user after')
    await window.getLastWindow(getContext()).then(async win => {
      let area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
      win.setWindowLayoutFullScreen(true)  // true：设置全屏
      win.setWindowSystemBarProperties({statusBarContentColor:'#FFFFFF'}) // 白色

      let h = area.topRect.height  // 获取安全区域高度，单位px
      let hvp = px2vp(h)  // 将px单位转换成vp单位
      console.log(`hvp:${hvp}`)
      await AppStorage.setOrCreate('topHeight',hvp)  // 将高度保存到AppStorage中共享给其他页面使用
    })
    console.log(`height:${this.topHeight}`)
  }

  @StorageLink('topHeight') topHeight:number=0
  async pickerAvatar() {
    //  1. 实例化选择参数对象
    const options = new picker.PhotoSelectOptions()
    options.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE // 表示从相册中选择图片
    options.maxSelectNumber = 1 // 表示只选择一张

    //   2. 实例化选择器对象
    const pickerView = new picker.PhotoViewPicker()
    //   3. 调用选择器对象上的select方法传入参数对象即可完成选择
    let res = await pickerView.select(options)

    AlertDialog.show({message:JSON.stringify(res.photoUris)})

    //   4. 判断用户取消了选择图片，则组织下面代码的继续运行
    if (res.photoUris.length === 0) {
      promptAction.showToast({ message: "用户取消图片选择" })
      return
    }
    //   4.1 准备好一个图片的完整路径
    let ext = 'jpg' // 图片扩展名
    let fileName = Date.now().toString() // 图片名称
    let cacheDir = getContext().cacheDir // 获取应用程序的缓存目录
    let fullPath = cacheDir + '/' + fileName + '.' + ext // 完整的图片路径
    let fullFileName=fileName+'.'+ext
    //   4.2 利用fs拷贝图片
    let file = fs.openSync(res.photoUris[0], fs.OpenMode.READ_ONLY)
    fs.copyFileSync(file.fd,fullPath)
    AlertDialog.show({ message: '图片拷贝成功' })

    //   5. 利用request.uploadFile方法完成应用程序缓存目录下的文件上传操作
    //   5.1 缓存文件路径
    let uploadFilePath = `internal://cache/${fullFileName}`

    this.dialog.open()

    //   5.2 准备reqeust
     let uploador = await request.uploadFile(getContext(), {
      method: 'POST',
      url: 'https://api-harmony-teach.itheima.net/hm/userInfo/avatar',
      header: {
        "Content-Type": "multipart/form-data",
        "Authorization": `Bearer ${this.user.token}`
      },
      // name：指的是接口中的body中的参数名称，不能写错一定要和接口保持一致
      // uri:指的是应用程序缓存中的图片
      //filename：文件名称
      // type：文件类型，也就是扩展名
      files: [{ name: 'file', uri: uploadFilePath, filename: fullFileName, type: ext }],
      data: [] // 因为本接口除了上传文件之外，无需接收其他文本数据，所以空着即可
    })
    let i=0
    //   5.3 注册uploador对象上的两个事件，一个是progress用来监听上传进度，一个是fail用来监听上传失败的异常获取
    uploador.on('progress', (uploadSize, totalSize) => {
      //  这个回调函数是随着文件的上传会被不间断的触发执行，每次的uploadSize的值会增加，但是totalSize永远都是当前上传图片的大小
      //   所以我们可以通过判断 uploadSize === totalSize 表示上传完成，我们就可以做完成后端 逻辑处理
      let parcenStr = ((uploadSize/totalSize)*100).toFixed(0).toString()
      console.log(`times:${i++}`)
      Logger.info('上传:',uploadSize + ' / '+ totalSize)
      console.log(`uploadSize:${uploadSize}`)
      emitter.emit({eventId:0},{
        data:{
          msg:'完成:'+parcenStr+'%'
        }
      })
      if(uploadSize === totalSize){
        AlertDialog.show({message:'图片上传完成'})
        // this.dialog.close()
      }
      //   由于此函数会被多次调用，所以我们可以在这个函数中计算处当前上传的进度百分比
    })

    //  监听上传失败的事件
    uploador.on('fail',(err)=>{
      AlertDialog.show({message:JSON.stringify(err)})
    })

    this.RefreshUserData()
    // this.dialog.close()
  }

  async RefreshUserData(){
    await this.getUserInfoToUser();
  }

  private async getUserInfoToUser() {
    const result = await getUserInfoGetMethod();
    const userInfo = JSON.parse(result.result.toString()) as allResponse<InfoUser>;
    console.log(`userInfo:${JSON.stringify(userInfo.data)}`)
    console.log(`before avatar:${this.user.avatar}`)
    console.log(`after avatar:${userInfo.data.avatar}`)
    this.user.avatar = userInfo.data.avatar;
    this.user.nickName = userInfo.data.nickName;
    authStore.setUser(this.user)
  }

  build() {
    Navigation() {
      Stack() {
        List() {
          ListItem() {
            Row() {
              Text('头像')
              Image(this.user.avatar)
                .width(50)
                .height(50)
                .borderRadius(50)
                .border({ width: 0.5, color: '#e4e4e4' })
                .onClick(async () => {

                  await this.pickerAvatar()
                  await this.RefreshUserData()
                  //await updateUserAvatarNickName(this.user.avatar,this.user.nickName)

                })
            }.width('100%').height((60)).justifyContent(FlexAlign.SpaceBetween)
          }

          ListItem() {
            Row() {
              Text('昵称')
              TextInput({ text:this.user.nickName})
                .textAlign(TextAlign.End)
                .layoutWeight(1)
                .padding(0)
                .height((60))
                .backgroundColor(Color.Transparent)
                .borderRadius(0)
                .onChange((val)=>{
                  this.user.nickName=val
                })

                .onSubmit(async () => {

                  const res=await updateUserAvatarNickName(this.user.avatar,this.user.nickName)

                  const result=JSON.parse(res.result.toString()) as ProfileUser

                  console.info(`nickName:${JSON.stringify(result)}`)

                  this.RefreshUserData()//昵称更新修复bug

                })
            }.width('100%').height(60).justifyContent(FlexAlign.SpaceBetween)
          }
        }
        .width('100%')
        .height('100%')
        .padding({ left: (45), right: (45), top: (15), bottom: (15) })
        .divider({ strokeWidth: 0.5, color: '#f5f5f5' })

      }.width('100%')
      .height('100%')
    }
    .title('完善个人信息')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .linearGradient({
      colors: [['#FFB071', 0], ['#f3f4f5', 0.3], ['#f3f4f5', 1]]
    })
    .padding({top:25})

  }
}