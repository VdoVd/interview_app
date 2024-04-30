import { HdClockIn } from '../../common/components/HdClockIn'
import { HdSearch } from '../../common/components/HdSearch'
import { IvSkeleton } from '../../common/components/IvSkeleton'
import { BasicConstant } from '../../common/constants/BasicContant'
import { HomeCategoryComp } from './HomeCategoryComp'
import { router, window } from '@kit.ArkUI'
import { allResponse, getClockIn } from '../../common/utils/myReq'
import { clockIn } from '../../models/clockInModel'
import { untilWinManagerClass } from '../../common/utils/manager'

AppStorage.setOrCreate<string>("questionId","")

let manage:untilWinManagerClass=new untilWinManagerClass()

@Component
export struct Home {
  @StorageProp('topHeight') topHeight: number = 0

  @State clickCount:number=0

  aboutToDisappear(): void {
    window.getLastWindow(getContext()).then(win => {

      win.setWindowSystemBarProperties({statusBarContentColor:'#FFFFFF'}) // 白色

      AppStorage.setOrCreate('topHeight',0)
    })
  }

  async aboutToAppear(): Promise<void> {
    const res=await getClockIn()

    let result=JSON.parse(res.result.toString()) as allResponse<clockIn>

    this.clickCount=result.data.clockinNumbers

    manage.fullScreen()

    manage.setWindowBarFontColor()

    manage.setWindowBarHeight()

  }

  @Provide isShowWait:boolean=false
  @Builder
  SkeletonBuilder() {
    Column({space:10}) {


      List({ space: (15) }){
        ForEach([1, 2 ], () => {
          ListItem(){
            Column({ space: (15) }){

              Row({ space: (15) }){
                IvSkeleton({ widthValue: (30) })
                IvSkeleton({ widthValue: '100%' }).layoutWeight(1)
              }

              Row({ space: (15) }){
                IvSkeleton({ widthValue: (50) })
                IvSkeleton({ widthValue: (50) })
                IvSkeleton({ widthValue: (50) })
              }
              .width('100%')
            }
            .padding({ top: (10), bottom: (10) })
          }
        })
      }
      .divider({ strokeWidth: 0.5, color: $r('app.color.common_gray_bg') })
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .padding((15))
    .layoutWeight(1)

  }
  build() {
    Column({space:10}) {

      Row({space:13}){

        HdSearch()
          .layoutWeight(1)

        HdClockIn({clockCount:this.clickCount})
          .onClick(()=>{
            router.pushUrl({url:"pages/clockPage"})
          })

      }

      Row() {
        Swiper() {

          //三个Flex结构一样，可以使用@Builder 封装
          Flex() {
            Image($r('app.media.banner_qa'))
              .objectFit(ImageFit.Fill)
          }
          .padding({ left: BasicConstant.SPACE_LG, right: BasicConstant.SPACE_LG })
          .aspectRatio(2.8)

          Flex() {
            Image($r('app.media.banner_pj'))
              .objectFit(ImageFit.Fill)
          }
          .padding({ left: BasicConstant.SPACE_LG, right: BasicConstant.SPACE_LG })
          .aspectRatio(2.8)

          Flex() {
            Image($r('app.media.banner_ai'))
              .objectFit(ImageFit.Fill)
          }
          .padding({ left: BasicConstant.SPACE_LG, right: BasicConstant.SPACE_LG })
          .aspectRatio(2.8)

        }
        .autoPlay(true)
        .indicator(DotIndicator.dot()
          .selectedColor(Color.White)
          .bottom(BasicConstant.SPACE_SM)
          .itemHeight(BasicConstant.SPACE_SM)
          .selectedItemHeight(BasicConstant.SPACE_SM)
          .itemWidth(BasicConstant.SPACE_MD)
          .selectedItemWidth(BasicConstant.SPACE_MD))
      }

      if(this.isShowWait)
      this.SkeletonBuilder()

      HomeCategoryComp()
        .layoutWeight(1)

      // QuestionItemComp({item:{
      //   id: '1',
      //   stem: '请总结一下Vue2中生命周期函数有哪些',
      //   difficulty: 3,
      //   likeCount: 10,
      //   views: 20,
      //   readFlag: 1
      // } as QuestionItem})
      //   .padding(10)


    }
    .width('100%')
    .padding({top:this.topHeight})
    .height('100%')
  }
}