import { promptAction, router } from '@kit.ArkUI'
import { allResponse, getInterviewDetail } from '../common/utils/myReq'
import { HdTag } from '../models/QuestionItemModel'
import { getId } from '../views/interview/Interview'

export interface InterviewItem {
  id: string
  stem: string
  content: string
  likeCount: number
  views: number
  creatorName: string
  creatorAvatar: ResourceStr
  createdAt: string
  tags: string[]
  likeFlag: 0 | 1
  collectFlag: 0 | 1
}

//接收参数的实体
export interface ParamsType {
  id: number
}

interface OptData {
  id: string,
  type: number,
  optType: 1 | 2
}

interface OptDataModel {
  id: number
}

interface OptModel {
  /**
   * 请求成功code
   */
  code?: number;
  data?: OptDataModel
  /**
   * 请求成功message
   */
  message?: string;

  /**
   * 请求成功标志
   */
  success?: boolean;
}

@Entry
@Component
export struct InterviewDetailComp {

  @StorageProp('topHeight') topHeight: number = 0

  @State
  item: InterviewItem = {
    stem:'标题',
    views:100,
    likeCount:100,
    createdAt:'2024-01-22',
    creatorAvatar:'http://teachoss.itheima.net/heimaQuestionMiniapp/%E5%AE%98%E6%96%B9%E9%BB%98%E8%AE%A4%E5%A4%B4%E5%83%8F%402x.png',
    creatorName:'jim',
    content:'面经详情内容',
    tags:['vue','前端']
  } as InterviewItem
  scroller: Scroller = new Scroller()
  @State
  show: boolean = false

  @State
  questionId: number = parseInt((router.getParams() as InterviewItem).id)

  async onPageShow(): Promise<void> {

    const res = await getInterviewDetail(`${this.questionId}`)

    const result = (JSON.parse(res.result.toString()) as allResponse<InterviewItem>).data

    this.item=result

  }

  @Builder
  menuBuilder() {
    Menu() {
      MenuItem({ content: this.item.likeFlag === 1 ? '取消点赞' : '点赞' }).onClick(()=>{
        // 实现点赞逻辑
      })
      MenuItem({ content: this.item.collectFlag === 1 ? '取消收藏' : '收藏' }).onClick(()=>{
        //  实现收藏逻辑
      })
    }
    .radius(12)
    .width(108)
  }

  build() {
    Column() {
      // nav
      Row({ space: 16 }) {
        Image($r('sys.media.ohos_ic_public_arrow_left'))
          .size({ width: 24, height: 24 })
          .onClick(() => router.back())
        Text(this.item.stem)
          .fontWeight(600)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .fontSize(18)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .opacity(this.show ? 1 : 0)
          .animation({ duration: 300 })
        Image($r('sys.media.ohos_ic_public_more'))
          .size({ width: 24, height: 20 })
          .objectFit(ImageFit.Contain)
          .bindMenu(this.menuBuilder())
      }
      .padding({ left: 16, right: 16 })
      .height(56)
      .width('100%')

      Scroll(this.scroller) {
        Column({ space: 16 }) {
          Text(this.item.stem)
            .fontWeight(600)
            .fontSize(18)

          Row({ space: 4 }) {
            Image(this.item.creatorAvatar)
              .width(36)
              .aspectRatio(1)
              .sharedTransition(this.questionId.toString(), { duration: 300 })
            Column({ space: 4 }) {
              Text(this.item.creatorName)
                .fontSize(14)
              Text() {
                Span('浏览 ' + this.item.views)
                Span(' · ')
                Span('点赞 ' + this.item.likeCount)
                Span(' · ')
                Span(this.item.createdAt)
              }
              .width('100%')
              .fontSize($r('app.float.common_font12'))
              .fontColor('#bdbdbd')
            }
            .alignItems(HorizontalAlign.Start)
            .layoutWeight(1)
          }

          Row({ space: 4 }) {
            ForEach(['大厂','面经'], (tag: string) => {
              HdTag({ text: tag })
            })
          }
          .width('100%')

          // con
          RichText(`

        <html>
          <body>
          <!--真机next系统文字太小，需要增加div设置字体大小和结合initial-scale=1.3兼容一下-->
          <div style="font-size: 45px;">
            ${ this.item.content}
          </div>
          </body>
        </html>
      `)
            .width("100%").height("100%")

          // ref
          Row({ space: 4 }) {
            Text('相关题目：')
              .fontSize(14)
            Column({ space: 10 }) {
              ForEach([1, 2, 3, 4], () => {
                Row() {
                  Image($r('app.media.ic_interview_file'))
                    .size({ width: 14, height: 14 })
                    .fillColor($r('app.color.common_blue'))
                  Text(' Vue 生命周期总共分为几个阶段？')
                    .fontSize(12)
                    .fontColor($r('app.color.common_blue'))
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width('100%')
              })
            }
            .layoutWeight(1)
          }
          .alignItems(VerticalAlign.Top)
          .padding(16)
          .backgroundColor($r('app.color.common_gray_bg'))
          .borderRadius(8)

          Text('© 著作权归作者所有')
            .fontSize(12)
            .fontColor($r('app.color.common_gray_01'))
            .height(60)
        }
        .padding({ left: 16, right: 16 })
      }
      .onScroll(() => {
        this.show = this.scroller.currentOffset().yOffset > 30
      })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Start)
    .padding({top:this.topHeight})
  }
}