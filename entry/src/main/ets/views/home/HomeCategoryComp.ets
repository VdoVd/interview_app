import { QuestionType, QuestionTypeModel } from '../../models/CategoryModel'
import { hdHttp } from '../../common/utils/request'
import {allResponse,getHomeSubList, getHomeTypeList, hasCLockIn as hasClockIn, login } from '../../common/utils/myReq'
import { homeSubItemModel, homeSubListModel } from '../../models/homeSubListModel'
import HomeSubListItemView from './HomeSubListItemView'
import { promptAction, router } from '@kit.ArkUI'
import HomeFilterView from './HomeFilterView'
import { IvSkeleton } from '../../common/components/IvSkeleton'

AppStorage.setOrCreate<homeSubItemModel[]>("subList",[])

@Component
export  struct HomeCategoryComp {

  @State
  questionTypeList: QuestionTypeModel[] = [
    {
      id: 1,
      name: 'html',
      displayNewestFlag: 0
    } as QuestionType,
    {
      id: 2,
      name: 'css',
      displayNewestFlag: 1
    } as QuestionType
  ]

  @StorageLink("subList") list:homeSubItemModel[]=[]

  @StorageLink("questId") Id:string=''

  @Consume isShowWait:boolean

  @Watch("changeSubList") @State index: number = 0

  @State refreshing:boolean=false

  @State isLoading:boolean=false

   tryIt(){

    console.log('ques before type')


    hdHttp.get<QuestionTypeModel[]>('question/type').then((res) => {

      this.questionTypeList = res.data

      console.log(`type:${JSON.stringify(res.data)}`)

      getHomeTypeList()

    })

  }

  @State typeId:number=21

  @State sort:number=0

  @State fatherSelect:number=0

  @Watch("finishSheet") @State showSheet:boolean=false

  @Builder
  sheetBuilder(){

    HomeFilterView({show:this.showSheet,sort:this.sort,typeId:this.typeId,objs:this.questionTypeList,FatherTabSelect:this.fatherSelect})
      .zIndex(2)

  }

  @State page:number=1

  finishSheet(){
      this.index=this.fatherSelect
  }

  async changeSubList(){
    console.log('change sub Index')
    this.isLoading=true

    const res=await getHomeSubList(10,this.typeId,this.page,this.sort)

    let receiveList=JSON.parse(res.result.toString()) as allResponse<homeSubListModel>
    this.list.unshift(...receiveList.data.rows)
    this.list=[...this.list]

    if(this.refreshing=true)this.refreshing=false

    this.isLoading=false


  }

  timeId?:number=0

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

  @Builder
  TabItemBuilder(q: QuestionTypeModel, index: number) {
    Row() {
      Stack({ alignContent: Alignment.Bottom }) {
        Text(q.name)
          .fontSize(15)
          .height(43)
          .fontColor(this.index === index ? Color.Black : Color.Gray)

        Text()
          .width(this.index === index ? 20 : 0)
          .height(2)
          .backgroundColor(Color.Black)
          .animation({ duration: this.index === index ? 300 : 0 })
      }
      .padding({ left: index === 0 ? 16 : 0, })

      if (q.displayNewestFlag === 1) {
        Image($r("app.media.ic_home_new"))
          .width(32)
          .height(14)
          .objectFit(ImageFit.Contain)
          .margin({ left: 4 })
      }
    }
    .padding({ right: this.questionTypeList.length === index + 1 ? 54 : 16 })
  }

  build() {
    Column(){

      Stack({ alignContent: Alignment.TopEnd }) { //设置堆叠位置为右上角
        Tabs({ index: $$this.index }) {
          ForEach(this.questionTypeList , (item: QuestionTypeModel, index: number) => {

            TabContent() {
              Column(){
                if(this.isLoading===true)
                  this.SkeletonBuilder()
                else {

                  Refresh({refreshing:$$this.refreshing}){

                    List(){

                      ForEach(this.list,(item:homeSubItemModel,index:number)=>{

                        ListItem(){

                          HomeSubListItemView({item:item})
                            .margin({bottom:15})
                            .onClick(()=>{
                              router.pushUrl({
                                url:"pages/questionDetailPage",
                                params:{
                                  id:item.id
                                }
                              })
                            })

                        }

                      })

                    }
                    .width('100%')
                    .height('100%')
                    .scrollBar(BarState.Off)
                    .onReachEnd(()=>{
                      clearTimeout(this.timeId)
                      promptAction.showToast({message:'正在加载中'})
                      this.timeId=setTimeout(()=>{
                        this.page++
                        console.log('reachEnd.............................................................'+`page:${this.page}`)
                        this.changeSubList()
                      },2000)
                    })

                  }
                  .onRefreshing(()=>{
                    promptAction.showToast({message:'正在加载中'})
                    clearTimeout(this.timeId)
                    this.timeId=setTimeout(()=>{
                      this.page++
                      this.changeSubList()
                    },300)

                  })
                }


              }

            }.tabBar( this.TabItemBuilder (item, index))
            .height('100%')
          })
        }
        .divider({ strokeWidth: $r('app.float.common_border_width'),
          color: $r('app.color.common_gray_border') }) //设置tabbar下面的横线样式
        .barMode(BarMode.Scrollable) // 设置tabs可以滚动
        .barHeight(44)
        .onChange(

          i =>{
            console.log(`change tabs:${i}`)
            this.typeId=this.questionTypeList[i].id
            this.index = i
            this.page=1
            this.list=[...[]]
          }

        )  // 切换tabbar内容

        Row() {
          // 过滤条件按钮
          Image($r('app.media.ic_home_filter'))
            .width(22)
            .height(44)
            .objectFit(ImageFit.Contain)  // 设置图片按照容器大小填满
        }
        .width(54)
        .height(44)
        .justifyContent(FlexAlign.Center) // 图片居中对齐
        .backgroundColor(Color.White)// 设置背景色位白色，使过滤条件图标能遮盖住tabbar的文字
        .onAppear(()=>{

          this.tryIt()

        })
        .onClick(()=>{

          this.showSheet=true

          console.log('onClick it')

        })

      }
      .bindSheet(this.showSheet,this.sheetBuilder(),{height:750,showClose:false})

    }


  }
}