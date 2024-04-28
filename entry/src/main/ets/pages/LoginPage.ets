import promptAction from '@ohos.promptAction';
import router from '@ohos.router';
import { BasicConstant } from '../common/constants/BasicContant';
import { authStore, HdUserModel } from '../common/utils/Auth';
import { hdHttp } from '../common/utils/request';
import { HdResponse } from '../models/HttpResponseModel';

interface iLoginParams{
  username:string
  password:string
}

@Entry
@Component
struct LoginPage {
  @State
  mobile: string = 'hmheima'
  @State
  code: string = 'Hmheima%123'
  @State
  isAgree: boolean = false
  @State
  loading: boolean = false

  @Styles
  inputStyle() {
    .margin({ bottom: (15) })
    .height((44))
    .borderRadius((2))
    .backgroundColor('#ffffff')
    .border({ width: { bottom: 0.5 }, color: '#e4e4e4' })
    .padding({ left: 0 })
  }

  onPageShow(): void {
      this.isAgree=true
      this.login()
      this.loading = true
      setTimeout(()=>{
        this.loading = false
      },300)


  }

  // 登录逻辑
  login() {
    if(this.loading) return;

    if (!this.mobile) {
      return promptAction.showToast({ message: '请输入用户名' })
    }
    if (!this.code) {
      return promptAction.showToast({ message: '请输入密码' })
    }
    if (!this.isAgree) {
      return promptAction.showToast({ message: '请勾选已阅读并同意' })
    }

    this.loading = true
    console.log('login')
    hdHttp.post<HdUserModel>('login', {
      username: this.mobile,
      password: this.code
    } as iLoginParams).then((res: HdResponse<HdUserModel>) => {
      authStore.setUser(res.data)
      promptAction.showToast({ message: '登录成功', duration: 1000 })
      this.loading = false
      router.pushUrl({
        url:BasicConstant.PAGE_INDEX
      })
    })
  }
  build() {
    Scroll() {
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
        Column() {
          Image($r('app.media.startIcon')).width((120)).height((120))
          Text('面试宝典').fontSize((28)).margin({ bottom: (15) })
          Text('搞定企业面试真题，就用面试宝典').fontSize((14))
            .fontColor($r('app.color.ih_gray_color'))
        }.padding(20)

        Column() {
          TextInput({ placeholder: '请输入用户名', text: this.mobile })
            .inputStyle()
            .placeholderColor('#C3C3C5')
            .caretColor('#fa711d')
            .onChange(val => this.mobile = val)
          TextInput({ placeholder: '请输入密码', text: this.code, })
            .type(InputType.Password)
            .showPasswordIcon(false)
            .inputStyle()
            .placeholderColor('#C3C3C5')
            .caretColor('#fa711d')
            .onChange(val => this.code = val)
          Row() {
            Checkbox()
              .selectedColor('#fa711d')
              .size({ width: (14), height: (14) })
              .select(this.isAgree)
              .onChange((val) => {
                this.isAgree = val
              })
            Text('已阅读并同意')
              .fontSize((14))
              .fontColor($r('app.color.ih_gray_color'))
              .padding({ right: (4) })
            Text('用户协议')
              .fontSize((14))
              .padding({ right: (4) })
            Text('和')
              .fontSize((14))
              .fontColor($r('app.color.ih_gray_color'))
              .padding({ right: (4) })
            Text('隐私政策')
              .fontSize((14))
              .onClick(() => {
                router.pushUrl({
                  url: 'pages/PreviewWebPage'
                })
              })
          }.width('100%').margin({ bottom: (15) })

          Button({ type: ButtonType.Normal }) {
            Row(){
              if (this.loading) {
                LoadingProgress()
                  .color('#ffffff')
                  .width((24))
                  .height((24))
                  .margin({ right: (10) })
              }
              Text('立即登录').fontColor('#ffffff')
            }
          }
          .width('100%')
          .backgroundColor('none')
          .borderRadius((4))
          .height((44))
          .linearGradient({
            direction: GradientDirection.Right,
            colors: [['#fc9c1c', '0%'], ['#fa711d', '100%']]
          })
          .stateEffect(false)
          .onClick(() => {
            // TODO:编写登录逻辑
            this.login()
            this.loading = true
            setTimeout(()=>{
              this.loading = false
            },300)
          })
        }.padding((30))

        Column() {
          Text('其他登录方式')
            .fontSize((14))
            .fontColor($r('app.color.ih_gray_color'))
        }
        .padding({ top: (70), bottom: (100) })
      }
    }
  }
}