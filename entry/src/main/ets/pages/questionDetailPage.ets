import axios, { AxiosResponse } from '@ohos/axios'
import { promptAction, router } from '@kit.ArkUI'
import { passId, questionDetail } from '../models/questionDetailModel'
import { authStore } from '../common/utils/Auth'
import { http } from '@kit.NetworkKit'
import { allResponse, getLikeOrCollect } from '../common/utils/myReq'
import { homeSubItemModel } from '../models/homeSubListModel'
import { trackingService } from '../common/utils/TrackingService'

let token=authStore.getUser().token

@Entry
@Component
struct questionDetailPage{

  @StorageLink('subList') list:homeSubItemModel[]=[]

  @StorageLink('topHeight') topHeight:number=0

  @State select:boolean=false

  @State loading:boolean=false

  @State qId:string=(router.getParams() as passId).id

  @State obj:questionDetail={} as questionDetail

  @State collectFlag:boolean=false

  @State likeFlag:boolean=false

  @State pageIndex:number=0

  aboutToAppear(): void {

    trackingService.setStartTime()
    trackingService.setQuestionId(this.qId)

  }

  aboutToDisappear(): void {
    trackingService.setEndTime()
    trackingService.save()
  }

  async refreshPage(){
    await axios.get<questionDetail,AxiosResponse<questionDetail>,null>(`https://api-harmony-teach.itheima.net/hm/question/${this.qId}`, { headers:{ Authorization:`Bearer ${token}`, } })
      .then((res:AxiosResponse)=>{
        console.log(`data:${JSON.stringify(res.data.data)}`)
        this.obj=res.data.data
        this.collectFlag=this.obj.collectFlag===1?true:false
        this.likeFlag=this.obj.likeFlag===1?true:false

      })
    setTimeout(()=>{

      console.log(`refresh obj:${JSON.stringify(this.obj)}`)

      console.log(`refresh answer:${JSON.stringify(this.obj.answer)}`)

    },300)
  }

  async onPageShow(): Promise<void> {
    await axios.get<questionDetail,AxiosResponse<questionDetail>,null>(`https://api-harmony-teach.itheima.net/hm/question/${this.qId}`, { headers:{ Authorization:`Bearer ${token}`, } })
      .then((res:AxiosResponse)=>{
        console.log(`data:${JSON.stringify(res.data.data)}`)
        this.obj=res.data.data
        this.collectFlag=this.obj.collectFlag===1?true:false
        this.likeFlag=this.obj.likeFlag===1?true:false
        let index=0
        this.list.forEach((item=>{
          if(item.id===this.qId){
            this.pageIndex=index
            console.log(`id:${item.id}`)
          }
          index++
        }))
      })
    setTimeout(()=>{

      console.log(`obj:${JSON.stringify(this.obj)}`)

      console.log(`answer:${JSON.stringify(this.obj.answer)}`)

    },300)
  }

  tryHttp(){
    axios.get<string,AxiosResponse<string>,null>('http://www.baidu.com')
      .then((res:AxiosResponse<string>)=>{
        console.log(`res:${JSON.stringify(res)}`)
      })
  }

  build() {
    Column(){

    Navigation(){
    Scroll(){
      Column(){
        Column({space:7}){
          Text(`${this.obj.stem}`)
            .width('100%')
            .fontWeight(FontWeight.Bold)
            .fontSize(18)
            .textAlign(TextAlign.Start)
          Row({space:10}){
            Text(this.obj.difficulty===0||this.obj.difficulty===1?'简单':(this.obj.difficulty===2||this.obj.difficulty===3?'一般':'困难'))
              .backgroundColor('rgba(0,0,0,0.1)')
              .padding(5)
              .fontSize(12)
              .fontColor(Color.Green)
              .borderRadius(5)
            ForEach(this.obj.stage,(item:string)=>{
              Text(item)
                .fontSize(12)
                .backgroundColor('rgba(0,0,0,0.1)')
                .padding(5)
                .fontColor(Color.Blue)
                .borderRadius(5)
            })

            Row(){
              Image($r('app.media.icon_point'))
                .width(30).alignSelf(ItemAlign.End)
                .onClick(()=>{
                  this.select=true
                })
            }.layoutWeight(1).justifyContent(FlexAlign.End)


          }.width('100%').justifyContent(FlexAlign.Start)

        }
        .padding(18)
        Column({space:14}){

          Text('答案:')
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontWeight(FontWeight.Bold)
            .margin({left:18})

          this.richTextBuilder()

          Row({space:15}){

            Image($r('app.media.tabbar_home'))
              .width(20)
              .margin({left:10})

            Text('有问题？点我反馈')
              .fontColor(Color.Blue)
              .fontSize(16)

          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .height(50)

          Row({space:18}){

            Image($r('app.media.love2'))
              .width(50)
              .padding(10)
              .borderRadius(28)
              .shadow({radius:8,color:'rgba(0,0,0,0.2)'})
              .backgroundColor(!this.collectFlag?Color.White:Color.Red)

            Image($r('app.media.like'))
              .backgroundColor(Color.Yellow)
              .width(50)
              .padding(10)
              .borderRadius(28)
              .shadow({radius:8,color:'rgba(0,0,0,0.4)'})
              .margin({right:20})
              .backgroundColor(!this.likeFlag?Color.White:Color.Orange)

          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .height(50)
          Row(){
            Image($r('app.media.prev_black'))
              .width('30%')
              .onClick(()=>{
                if(this.pageIndex===0){
                  promptAction.showToast({message:'已经到顶了'})
                }else {
                  this.pageIndex--
                  this.qId=this.list[this.pageIndex].id
                  this.refreshPage()
                }
              })
            Image($r('app.media.next_black'))
              .width('30%')
              .onClick(()=>{
                if(this.pageIndex===9){
                  promptAction.showToast({message:'我已经到底了'})
                }else {
                  this.pageIndex++
                  this.qId=this.list[this.pageIndex].id
                  this.refreshPage()
                }
              })
          }.width('90%')
          .justifyContent(FlexAlign.SpaceBetween)

        }

      }
    }

    }
    .title('题目详情')
    .titleMode(NavigationTitleMode.Mini)
    .zIndex(0)

    Column(){
      Column({space:15}){
        Text(this.collectFlag?'取消收藏':'收藏').fontSize(20).width(100).textAlign(TextAlign.Center)
          .onClick(async ()=>{
          const res=await getLikeOrCollect(this.obj.id,1)
          const result=JSON.parse(res.result.toString())as allResponse<Object>
          console.log(`collect:${JSON.stringify(res.result)}`)
          console.log(`collect:${JSON.stringify(result)}`)
          if(result.success=true){
            this.collectFlag=!this.collectFlag
            console.log(`collect flag:${this.collectFlag}`)
          }
          this.select=false
        })

        Text(this.likeFlag?'取消点赞':'点赞').fontSize(20).width(100).textAlign(TextAlign.Center)
          .onClick(async ()=>{
            const res=await getLikeOrCollect(this.obj.id,2)
            const result=JSON.parse(res.result.toString())as allResponse<Object>
            console.log(`like:${JSON.stringify(res.result)}`)
            console.log(`like:${JSON.stringify(result)}`)
            if(result.success=true){
              this.likeFlag=!this.likeFlag
              console.log(`like flag:${this.likeFlag}`)
            }
            this.select=false
          })
        Text('点我评价').fontSize(20).width(100).textAlign(TextAlign.Center)
        Text('试题分享').fontSize(20).width(100).textAlign(TextAlign.Center)
      }
      .padding(20)
      .backgroundColor(Color.White)
      .borderRadius(15)
      .position({x:'60%',y:'20%'})

    }.width('100%')
      .height('100%')
      .backgroundColor('rgba(0,0,0,0.5)')
      .position({x:'0%'})
      .zIndex(this.select?1:-1)
      .opacity(this.select?1:0)
    }
    .padding({top:this.topHeight})

  }

  @Builder
  loadingPart() {
    if (this.loading) {
      LoadingProgress()
        .width(30)
        .height(30)
    }
  }

  @Builder
  richTextBuilder() {
    if (this.obj.answer != undefined)
    Scroll() {
      Column() {

        Column() {

          RichText(`
            <!doctype html>
        <html>
          <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.3" />
            <style>
              body {
                background: "pink";

              }
              div{
                text-align: start;
                line-height: 65px;
              }
            </style>
          </head>
          <body style="width:76%;">
           <!--真机next系统文字太小，需要增加div设置字体大小和结合initial-scale=1.3兼容一下-->
          <div style="font-size: 40px; ">

            ${this.obj.answer}
          </div>
          </body>
        </html>
            `)
            .width('85%')
            .onStart(() => {
              this.loading = true
            })
            .onComplete(() => {
              this.loading = false
            })
        }
        .layoutWeight(1)

      }
    }
    .height('50%')
  }
}